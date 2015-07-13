//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE "/area/supply/station" //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/supply/dock"	//Type of the supply shuttle area for dock

var/global/datum/controller/supply_shuttle/supply_shuttle

/area/supply/station //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

/area/supply/dock //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

/obj/structure/plasticflaps	//HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "plastic flaps"
	desc = "Definitely can't get past those. No way."
	icon = 'icons/obj/stationobjs.dmi'	//Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	layer = 4

/obj/structure/plasticflaps/CanPass(atom/movable/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/stool/bed/B = A
	if (istype(A, /obj/structure/stool/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	else if(istype(A, /mob/living)) // You Shall Not Pass!
		var/mob/living/M = A
		if(!M.lying && !istype(M, /mob/living/carbon/monkey) && !istype(M, /mob/living/carbon/slime))	//If your not laying down, or a small creature, no pass.
			return 0
	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

/obj/structure/plasticflaps/mining/New() //set the turf below the flaps to block air
	var/turf/T = get_turf(loc)
	if(T)
		T.blocks_air = 1
	..()

/obj/structure/plasticflaps/mining/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor //wow this is terrible
	var/turf/T = get_turf(loc)
	if(T)
		if(istype(T, /turf/simulated/floor))
			T.blocks_air = 0
	..()

/obj/machinery/computer/supplycomp
	name = "supply shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "supply"
	req_access = list(access_cargo)
	circuit = /obj/item/weapon/circuitboard/supplycomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/hacked = 0
	var/can_order_contraband = 0
	var/last_viewed_group = "categories"


/obj/machinery/computer/ordercomp
	name = "supply ordering console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "request"
	circuit = /obj/item/weapon/circuitboard/ordercomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/last_viewed_group = "categories"

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null

/datum/controller/supply_shuttle
	var/processing = 1
	var/processing_interval = 300
	var/iteration = 0
	//supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/points_per_crate = 5
	var/points_per_intel = 100

	var/points_per_iron = 10 //1 point per 15 iron sheets, NT sells high and buys low
	var/points_per_glass = 10 //1 point per 15 iron sheets, NT sells high and buys low
	var/points_per_silver = 5 //1 point per 5 sheets
	var/points_per_plasteel = 1 //1-to-1 ratio
	var/points_per_plasma = 0.25 //4 points per sheet, NT loves that plasma
	var/points_per_gold = 0.25 //4 points per sheet
	var/points_per_diamond = 0.2 //5 points per sheet
	var/points_per_uranium = 0.1 //10 points per sheet, for NUKES
	var/points_per_bananium = 0.05 //20 points per sheet, fuck the clown
	var/points_per_mime = 0.05 //20 points per sheet, the mime can't do shit with it anyway
	var/points_per_adamantine = 0.01 //100 points per sheet!!!

	var/centcom_message = "" // Remarks from Centcom on how well you checked the last order.
	// Unique typepaths for unusual things we've already sent CentComm, associated with their potencies
	var/list/discoveredPlants = list()
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	//shuttle movement
	var/at_station = 0
	var/movetime = 1200
	var/moving = 0
	var/eta_timeofday
	var/eta
	//shuttle loan
	var/datum/round_event/shuttle_loan/shuttle_loan

/datum/controller/supply_shuttle/New()
	ordernum = rand(1,9000)
	for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs))
		var/datum/supply_packs/P = new typepath()
		if(P.name == "HEADER") continue		// To filter out group headers
		supply_packs[P.name] = P

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcom and the station
/datum/controller/supply_shuttle/proc/process()

	spawn(0)
		set background = BACKGROUND_ENABLED
		while(1)
			if(processing)
				iteration++
				points += points_per_process

				if(moving == 1)
					var/ticksleft = (eta_timeofday - world.timeofday)
					if(ticksleft > 0)
						eta = round(ticksleft/600,1)
					else
						eta = 0
						send()


			sleep(processing_interval)

/datum/controller/supply_shuttle/proc/send()
	var/area/from
	var/area/dest
	switch(at_station)
		if(1)
			from = locate(SUPPLY_STATION_AREATYPE)
			dest = locate(SUPPLY_DOCK_AREATYPE)
			at_station = 0
		if(0)
			from = locate(SUPPLY_DOCK_AREATYPE)
			dest = locate(SUPPLY_STATION_AREATYPE)
			at_station = 1
	dest.clear_docking_area()
	moving = 0

	from.move_contents_to(dest)

//Check whether the shuttle is allowed to move
/datum/controller/supply_shuttle/proc/can_move()
	if(moving) return 0

	var/area/shuttle = locate(/area/supply/station)
	if(!shuttle) return 0

	if(forbidden_atoms_check(shuttle))
		return 0

	return 1

//To stop things being sent to centcom which should not be sent to centcom Recursively checks for these types.
/datum/controller/supply_shuttle/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1
	if(istype(A,/obj/effect/blob))
		return 1
	if(istype(A,/obj/effect/spider/spiderling))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

//Sellin
/datum/controller/supply_shuttle/proc/sell()
	var/shuttle_at
	if(at_station)	shuttle_at = SUPPLY_STATION_AREATYPE
	else			shuttle_at = SUPPLY_DOCK_AREATYPE

	var/area/shuttle = locate(shuttle_at)
	if(!shuttle)	return

	var/iron_count = 0
	var/glass_count = 0
	var/silver_count = 0
	var/gold_count = 0
	var/plasma_count = 0
	var/diamond_count = 0
	var/plasteel_count = 0
	var/uranium_count = 0
	var/bananium_count = 0
	var/mime_count = 0
	var/adamantine_count = 0

	var/intel_count = 0
	var/crate_count = 0

	centcom_message = ""

	for(var/atom/movable/MA in shuttle)
		if(MA.anchored)	continue


		// Must be in a crate (or a critter crate)!
		if(istype(MA,/obj/structure/closet/crate) || istype(MA,/obj/structure/closet/critter))
			crate_count++
			var/find_slip = 1

			for(var/atom in MA)
				// Sell manifests
				var/atom/A = atom
				if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
					var/obj/item/weapon/paper/manifest/slip = A
					// TODO: Check for a signature, too.
					if(slip.stamped && slip.stamped.len) //yes, the bananium stamp will work. bananium is the highest authority on the station, it makes sense
						// Did they mark it as erroneous?
						var/denied = 0
						for(var/i=1,i<=slip.stamped.len,i++)
							if(slip.stamped[i] == /obj/item/weapon/stamp/denied)
								denied = 1
						if(slip.erroneous && denied) // Caught a mistake by Centcom (IDEA: maybe Centcom rarely gets offended by this)
							points += slip.points-points_per_crate // For now, give a full refund for paying attention (minus the crate cost)
							centcom_message += "<font color=green>+[slip.points-points_per_crate]</font>: Station correctly denied package [slip.ordernumber]: "
							if(slip.erroneous & MANIFEST_ERROR_NAME)
								centcom_message += "Destination station incorrect. "
							else if(slip.erroneous & MANIFEST_ERROR_COUNT)
								centcom_message += "Packages incorrectly counted. "
							else if(slip.erroneous & MANIFEST_ERROR_ITEM)
								centcom_message += "Package incomplete. "
							centcom_message += "Points refunded.<BR>"
						else if(!slip.erroneous && !denied) // Approving a proper order awards the relatively tiny points_per_slip
							points += points_per_slip
							centcom_message += "<font color=green>+1</font>: Package [slip.ordernumber] accorded.<BR>"
						else // You done goofed.
							if(slip.erroneous)
								centcom_message += "<font color=red>+0</font>: Station approved package [slip.ordernumber] despite error: "
								if(slip.erroneous & MANIFEST_ERROR_NAME)
									centcom_message += "Destination station incorrect."
								else if(slip.erroneous & MANIFEST_ERROR_COUNT)
									centcom_message += "Packages incorrectly counted."
								else if(slip.erroneous & MANIFEST_ERROR_ITEM)
									centcom_message += "We found unshipped items on our dock."
								centcom_message += "  Be more vigilant.<BR>"
							else
								points -= slip.points-points_per_crate
								centcom_message += "<font color=red>-[slip.points-points_per_crate]</font>: Station denied package [slip.ordernumber].  Our records show no fault on our part.<BR>"
						find_slip = 0
					continue

				// Sell minerals
				if(istype(A, /obj/item/stack/sheet/metal))
					var/obj/item/stack/sheet/metal/M = A
					iron_count += M.amount
				if(istype(A, /obj/item/stack/sheet/glass))
					var/obj/item/stack/sheet/glass/G = A
					glass_count += G.amount
				if(istype(A, /obj/item/stack/sheet/plasteel))
					var/obj/item/stack/sheet/plasteel/PS = A
					plasteel_count += PS.amount
				if(istype(A, /obj/item/stack/sheet/mineral/plasma))
					var/obj/item/stack/sheet/mineral/plasma/P = A
					plasma_count += P.amount
				if(istype(A, /obj/item/stack/sheet/mineral/silver))
					var/obj/item/stack/sheet/mineral/plasma/S = A
					silver_count += S.amount
				if(istype(A, /obj/item/stack/sheet/mineral/gold))
					var/obj/item/stack/sheet/mineral/gold/G = A
					gold_count += G.amount
				if(istype(A, /obj/item/stack/sheet/mineral/uranium))
					var/obj/item/stack/sheet/mineral/uranium/U = A
					uranium_count += U.amount
				if(istype(A, /obj/item/stack/sheet/mineral/diamond))
					var/obj/item/stack/sheet/mineral/diamond/D = A
					diamond_count += D.amount
				if(istype(A, /obj/item/stack/sheet/mineral/bananium))
					var/obj/item/stack/sheet/mineral/bananium/C = A
					bananium_count += C.amount
				if(istype(A, /obj/item/stack/sheet/mineral/mime))
					var/obj/item/stack/sheet/mineral/mime/M = A
					mime_count += M.amount
				if(istype(A, /obj/item/stack/sheet/mineral/adamantine))
					var/obj/item/stack/sheet/mineral/adamantine/AD = A
					adamantine_count += AD.amount

				// Sell syndicate intel
				if(istype(A, /obj/item/documents/syndicate))
					intel_count += 1

				if(istype(A, /obj/item/seeds))
					var/obj/item/seeds/S = A
					if(S.rarity == 0) // Mundane species
						centcom_message += "<font color=red>+0</font>: We don't need samples of mundane species \"[capitalize(S.species)]\".<BR>"
					else if(discoveredPlants[S.type]) // This species has already been sent to CentComm
						var/potDiff = S.potency - discoveredPlants[S.type] // Compare it to the previous best
						if(potDiff > 0) // This sample is better
							discoveredPlants[S.type] = S.potency
							centcom_message += "<font color=green>+[potDiff]</font>: New sample of \"[capitalize(S.species)]\" is superior.  Good work.<BR>"
							points += potDiff
						else // This sample is worthless
							centcom_message += "<font color=red>+0</font>: New sample of \"[capitalize(S.species)]\" is not more potent than existing sample ([discoveredPlants[S.type]] potency).<BR>"
					else // This is a new discovery!
						discoveredPlants[S.type] = S.potency
						centcom_message += "<font color=green>+[S.rarity]</font>: New species discovered: \"[capitalize(S.species)]\".  Excellent work.<BR>"
						points += S.rarity // That's right, no bonus for potency.  Send a crappy sample first to "show improvement" later
		qdel(MA)


	if(iron_count)
		centcom_message += "<font color=green>+[round(iron_count/points_per_iron)]</font>: Received [iron_count] unit(s) of metal sheets.<BR>"
		points += round(iron_count / points_per_iron)
	if(glass_count)
		centcom_message += "<font color=green>+[round(glass_count/points_per_glass)]</font>: Received [glass_count] unit(s) of glass sheets.<BR>"
		points += round(glass_count / points_per_glass)
	if(plasteel_count)
		centcom_message += "<font color=green>+[round(plasteel_count/points_per_plasteel)]</font>: Received [plasteel_count] unit(s) of plasteel sheets.<BR>"
		points += round(plasteel_count / points_per_plasteel)
	if(plasma_count)
		centcom_message += "<font color=green>+[round(plasma_count/points_per_plasma)]</font>: Received [plasma_count] unit(s) of plasma.<BR>"
		points += round(plasma_count / points_per_plasma)
	if(gold_count)
		centcom_message += "<font color=green>+[round(gold_count/points_per_gold)]</font>: Received [gold_count] unit(s) of gold.<BR>"
		points += round(gold_count / points_per_gold)
	if(silver_count)
		centcom_message += "<font color=green>+[round(silver_count/points_per_silver)]</font>: Received [silver_count] unit(s) of silver.<BR>"
		points += round(silver_count / points_per_silver)
	if(uranium_count)
		centcom_message += "<font color=green>+[round(uranium_count/points_per_uranium)]</font>: Received [uranium_count] unit(s) of uranium.<BR>"
		points += round(uranium_count / points_per_uranium)
	if(diamond_count)
		centcom_message += "<font color=green>+[round(diamond_count/points_per_diamond)]</font>: Received [diamond_count] unit(s) of diamond(s).<BR>"
		points += round(diamond_count / points_per_diamond)
	if(bananium_count)
		centcom_message += "<font color=green>+[round(bananium_count/points_per_bananium)]</font>: Received [bananium_count] unit(s) of Bananium.<BR>"
		points += round(bananium_count / points_per_bananium)
	if(mime_count)
		centcom_message += "<font color=green>+[round(mime_count/points_per_mime)]</font>: Received [mime_count] unit(s) of Mimesteinium.<BR>"
		points += round(mime_count / points_per_mime)
	if(adamantine_count)
		centcom_message += "<font color=green>+[round(adamantine_count/points_per_adamantine)]</font>: Received [adamantine_count] unit(s) of Adamantine!<BR>"
		points += round(adamantine_count / points_per_adamantine)



	if(intel_count)
		centcom_message += "<font color=green>+[round(intel_count*points_per_intel)]</font>: Received [intel_count] article(s) of enemy intelligence.<BR>"
		points += round(intel_count*points_per_intel)

	if(crate_count)
		centcom_message += "<font color=green>+[round(crate_count*points_per_crate)]</font>: Received [crate_count] crate(s).<BR>"
		points += crate_count * points_per_crate

//Buyin
/datum/controller/supply_shuttle/proc/buy()
	if(!shoppinglist.len) return

	var/shuttle_at
	if(at_station)	shuttle_at = SUPPLY_STATION_AREATYPE
	else			shuttle_at = SUPPLY_DOCK_AREATYPE

	var/area/shuttle = locate(shuttle_at)
	if(!shuttle)	return

	var/list/clear_turfs = list()

	for(var/turf/T in shuttle)
		if(T.density || T.contents.len)	continue
		clear_turfs += T

	for(var/S in shoppinglist)
		if(!clear_turfs.len)	break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		var/datum/supply_order/SO = S
		var/datum/supply_packs/SP = SO.object

		var/atom/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"

		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip = new /obj/item/weapon/paper/manifest(A)

		var printed_station_name = station_name()
		if(prob(5))
			printed_station_name = new_station_name()
			slip.erroneous |= MANIFEST_ERROR_NAME // They got our station name wrong.  BASTARDS!
			// IDEA: Have Centcom accidentally send random low-value crates in large orders, give large bonus for returning them intact.
		var printed_packages_amount = supply_shuttle.shoppinglist.len
		if(prob(5))
			printed_packages_amount += rand(1,2) // I considered rand(-2,2), but that could be zero.  Heh.
			slip.erroneous |= MANIFEST_ERROR_COUNT // They typoed the number of crates in this shipment.  It won't match the other manifests.

		slip.points = SP.cost
		slip.ordernumber = SO.ordernum
		slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
		slip.info +="Order #[SO.ordernum]<br>"
		slip.info +="Destination: [printed_station_name]<br>"
		slip.info +="[printed_packages_amount] PACKAGES IN THIS SHIPMENT<br>"
		slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			A:req_access = list()
			A:req_access += text2num(SP.access)

		var/list/contains
		if(istype(SP,/datum/supply_packs/misc/randomised))
			var/datum/supply_packs/misc/randomised/SPR = SP
			contains = list()
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					contains += pick(SPR.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)	continue
			var/atom/B2 = new typepath(A)
			if(SP.amount && B2:amount) B2:amount = SP.amount
			slip.info += "<li>[B2.name]</li>" //add the item to the manifest (even if it was misplaced)
			// If it has multiple items, there's a 1% of each going missing... Not for secure crates or those large wooden ones, though.
			if(contains.len > 1 && prob(1) && !findtext(SP.containertype,"/secure/") && !findtext(SP.containertype,"/largecrate/"))
				slip.erroneous |= MANIFEST_ERROR_ITEM // This item was not included in the shipment!
				qdel(B2) // Lost in space... or the loading dock.

		//manifest finalisation
		slip.info += "</ul><br>"
		slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>" // And now this is actually meaningful.

	supply_shuttle.shoppinglist.Cut()
	return

/obj/item/weapon/paper/manifest
	name = "supply manifest"
	var/erroneous = 0
	var/points = 0
	var/ordernumber = 0

/obj/machinery/computer/ordercomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	if(temp)
		dat = temp
	else
		dat += {"Shuttle Location: [supply_shuttle.moving ? "Moving to station ([supply_shuttle.eta] Mins.)":supply_shuttle.at_station ? "Station":"Dock"]<BR>
		<HR>Supply Points: [supply_shuttle.points]<BR>

		<BR>\n<A href='?src=\ref[src];order=categories'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	// Removing the old window method but leaving it here for reference
	//user << browse(dat, "window=computer;size=575x450")
	//onclose(user, "computer")

	// Added the new browser window method
	var/datum/browser/popup = new(user, "computer", "Supply Ordering Console", 575, 450)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return

	if( isturf(loc) && (in_range(src, usr) || istype(usr, /mob/living/silicon)) )
		usr.set_machine(src)

	if(href_list["order"])
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/cat in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[cat]'>[get_supply_group_name(cat)]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			var/cat = text2num(last_viewed_group)
			temp = "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [get_supply_group_name(cat)]</b><BR><BR>"
			for(var/supply_name in supply_shuttle.supply_packs )
				var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
				if(N.hidden || N.contraband || N.group != cat || supply_name == "HEADER") continue												//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"									//the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_shuttle.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		var/reason = copytext(sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text),1,MAX_MESSAGE_LEN)
		if(world.time > timeout)	return
		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_shuttle.ordernum++
		var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "requisition form - [P.name]"
		reqform.info += "<h3>[station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_shuttle.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [replacetext(get_access_desc(P.access))]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = P
		O.orderedby = idname
		supply_shuttle.requestlist += O

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["vieworders"])
		temp = "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><BR><BR>Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["viewrequests"])
		temp = "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><BR><BR>Current requests: <BR><BR>"
		for(var/S in supply_shuttle.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(!allowed(user))
		user << "<span class='warning'> Access Denied.</span>"
		return

	if(..())
		return
	user.set_machine(src)
	post_signal("supply")
	var/dat
	if (temp)
		dat = temp
	else
		dat += {"<BR><B>Supply shuttle</B><HR>
		\nLocation: [supply_shuttle.moving ? "Moving to station ([supply_shuttle.eta] Mins.)":supply_shuttle.at_station ? "Station":"Away"]<BR>
		<HR>\nSupply Points: [supply_shuttle.points]<BR>\n<BR>
		[supply_shuttle.moving ? "\n*Must be away to order items*<BR>\n<BR>":supply_shuttle.at_station ? "\n*Must be away to order items*<BR>\n<BR>":"\n<A href='?src=\ref[src];order=categories'>Order items</A><BR>\n<BR>"]
		[supply_shuttle.moving ? "\n*Shuttle already called*<BR>\n<BR>":supply_shuttle.at_station ? "\n<A href='?src=\ref[src];send=1'>Send away</A><BR>\n<BR>":"\n<A href='?src=\ref[src];send=1'>Send to station</A><BR>\n<BR>"]
		[supply_shuttle.shuttle_loan ? (supply_shuttle.shuttle_loan.dispatched ? "\n*Shuttle loaned to Centcom*<BR>\n<BR>" : "\n<A href='?src=\ref[src];send=1;loan=1'>Loan shuttle to Centcom (5 mins duration)</A><BR>\n<BR>") : "\n*No pending external shuttle requests*<BR>\n<BR>"]
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A><BR>
		<HR>\n<B>Central Command messages</B><BR> [supply_shuttle.centcom_message ? supply_shuttle.centcom_message : "Remember to stamp and send back the supply manifests."]"}

	user << browse(dat, "window=computer;size=700x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/supplycomp/attackby(I as obj, user as mob, params)
	if(istype(I,/obj/item/weapon/card/emag) && !hacked)
		user << "<span class='notice'> Special supplies unlocked.</span>"
		hacked = 1
		return
	else
		..()
	return

/obj/machinery/computer/supplycomp/Topic(href, href_list)
	if(!supply_shuttle)
		world.log << "## ERROR: Eek. The supply_shuttle controller datum is missing somehow."
		return
	if(..())
		return

	if(isturf(loc) && ( in_range(src, usr) || istype(usr, /mob/living/silicon) ) )
		usr.set_machine(src)

	//Calling the shuttle
	if(href_list["send"])
		if(!supply_shuttle.can_move())
			if(supply_shuttle.shuttle_loan)
				temp = "The supply shuttle must be docked to send new commands.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
			else
				temp = "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

		else if(supply_shuttle.at_station)
			if(href_list["loan"] && supply_shuttle.shuttle_loan)
				if(!supply_shuttle.shuttle_loan.dispatched)
					supply_shuttle.sell()
					supply_shuttle.send()
					supply_shuttle.shuttle_loan.loan_shuttle()
					temp = "The supply shuttle has been loaned to Centcom.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
					post_signal("supply")
				else
					temp = "You can not loan the supply shuttle at this time.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
			else
				temp = "The supply shuttle has departed.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				supply_shuttle.moving = -1
				supply_shuttle.sell()
				supply_shuttle.send()

		else
			if(href_list["loan"] && supply_shuttle.shuttle_loan)
				if(!supply_shuttle.shuttle_loan.dispatched)
					supply_shuttle.shuttle_loan.loan_shuttle()
					temp = "The supply shuttle has been loaned to Centcom.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
					post_signal("supply")
				else
					temp = "You can not loan the supply shuttle at this time.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
			else
				supply_shuttle.buy()
				temp = "The supply shuttle has been called and will arrive in [round(supply_shuttle.movetime/600,1)] minutes.<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				supply_shuttle.moving = 1
				supply_shuttle.eta_timeofday = (world.timeofday + supply_shuttle.movetime) % 864000
				post_signal("supply")

	else if (href_list["order"])
		if(supply_shuttle.moving) return
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/cat in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[cat]'>[get_supply_group_name(cat)]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			var/cat = text2num(last_viewed_group)
			temp = "<b>Supply points: [supply_shuttle.points]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [get_supply_group_name(cat)]</b><BR><BR>"
			for(var/supply_name in supply_shuttle.supply_packs )
				var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
				if((N.hidden && !hacked) || (N.contraband && !can_order_contraband) || N.group != cat || supply_name == "HEADER") continue		//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"		//the obj because it would get caught by the garbage

		/*temp = "Supply points: [supply_shuttle.points]<BR><HR><BR>Request what?<BR><BR>"

		for(var/supply_name in supply_shuttle.supply_packs )
			var/datum/supply_packs/N = supply_shuttle.supply_packs[supply_name]
			if(N.hidden && !hacked) continue
			if(N.contraband && !can_order_contraband) continue
			temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"    //the obj because it would get caught by the garbage
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"*/

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_shuttle.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		var/reason = copytext(sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text),1,MAX_MESSAGE_LEN)
		if(world.time > timeout)	return
//		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_shuttle.ordernum++
		var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "requisition form - [P.name]"
		reqform.info += "<h3>[station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_shuttle.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [replacetext(get_access_desc(P.access))]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = P
		O.orderedby = idname
		supply_shuttle.requestlist += O

		temp = "Order request placed.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> | <A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];confirmorder=[O.ordernum]'>Authorize Order</A>"

	else if(href_list["confirmorder"])
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list["confirmorder"])
		var/datum/supply_order/O
		var/datum/supply_packs/P
		temp = "Invalid Request"
		for(var/i=1, i<=supply_shuttle.requestlist.len, i++)
			var/datum/supply_order/SO = supply_shuttle.requestlist[i]
			if(SO && SO.ordernum == ordernum)
				O = SO
				P = O.object
				if(supply_shuttle.points >= P.cost)
					supply_shuttle.requestlist.Cut(i,i+1)
					supply_shuttle.points -= P.cost
					supply_shuttle.shoppinglist += O
					temp = "Thanks for your order.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				else
					temp = "Not enough supply points.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				break

	else if (href_list["vieworders"])
		temp = "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><BR><BR>Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""]<BR>"// <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
/*
	else if (href_list["cancelorder"])
		var/datum/supply_order/remove_supply = href_list["cancelorder"]
		supply_shuttle_shoppinglist -= remove_supply
		supply_shuttle_points += remove_supply.object.cost
		temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""] <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
*/
	else if (href_list["viewrequests"])
		temp = "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><BR><BR>Current requests: <BR><BR>"
		for(var/S in supply_shuttle.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]  [supply_shuttle.moving ? "":supply_shuttle.at_station ? "":"<A href='?src=\ref[src];confirmorder=[SO.ordernum]'>Approve</A> <A href='?src=\ref[src];rreq=[SO.ordernum]'>Remove</A>"]<BR>"

		temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["rreq"])
		var/ordernum = text2num(href_list["rreq"])
		temp = "Invalid Request.<BR>"
		for(var/i=1, i<=supply_shuttle.requestlist.len, i++)
			var/datum/supply_order/SO = supply_shuttle.requestlist[i]
			if(SO && SO.ordernum == ordernum)
				supply_shuttle.requestlist.Cut(i,i+1)
				temp = "Request removed.<BR>"
				break
		temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["clearreq"])
		supply_shuttle.requestlist.Cut()
		temp = "List cleared.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)




