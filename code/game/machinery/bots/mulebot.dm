//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// Mulebot - carries crates around for Quartermaster
// Navigates via floor navbeacons
// Remote Controlled from QM's PDA

var/global/mulebot_count = 0


#define SIGH 0
#define ANNOYED 1
#define DELIGHT 2

/obj/machinery/bot/mulebot
	name = "\improper MULEbot"
	desc = "A Multiple Utility Load Effector bot."
	icon_state = "mulebot0"
	layer = MOB_LAYER
	density = 1
	anchored = 1
	animate_movement=1
	health = 150
	maxhealth = 150
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
	var/atom/movable/load = null
	bot_type = MULE_BOT
	model = "MULE"
	can_buckle = 1
	buckle_lying = 0

	suffix = ""

	var/turf/target				// this is turf to navigate to (location of beacon)
	var/loaddir = 0				// this the direction to unload onto/load from
	var/home_destination = "" 	// tag of home beacon
	req_access = list(access_cargo)

	mode = BOT_IDLE

	blockcount	= 0		//number of times retried a blocked path
	var/reached_target = 1 	//true if already reached the target

	var/refresh = 1			// true to refresh dialogue
	var/auto_return = 1		// true if auto return to home beacon after unload
	var/auto_pickup = 1 	// true if auto-pickup at beacon
	var/report_delivery = 1 // true if bot will announce an arrival to a location.

	var/obj/item/weapon/stock_parts/cell/cell
	var/datum/wires/mulebot/wires = null
						// the installed power cell

	// constants for internal wiring bitflags
	/*

	var/wires = 1023		// all flags on

	var/list/wire_text	// list of wire colours
	var/list/wire_order	// order of wire indices
	*/


	var/bloodiness = 0		// count of bloodiness

/obj/machinery/bot/mulebot/New()
	..()
	wires = new(src)
	var/datum/job/cargo_tech/J = new/datum/job/cargo_tech
	botcard.access = J.get_access()
	prev_access = botcard.access
	cell = new(src)
	cell.charge = 2000
	cell.maxcharge = 2000

	spawn(5)	// must wait for map loading to finish
		mulebot_count += 1
		if(!suffix)
			suffix = "#[mulebot_count]"
		name = "\improper Mulebot ([suffix])"

/obj/machinery/bot/mulebot/Destroy()
	unload(0)
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/bot/mulebot/bot_reset()
	..()
	reached_target = 0

// attack by item
// emag : lock/unlock,
// screwdriver: open/close hatch
// cell: insert it
// other: chance to knock rider off bot
/obj/machinery/bot/mulebot/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/device/pda))
		if(toggle_lock(user))
			user << "<span class='notice'>Controls [(locked ? "locked" : "unlocked")].</span>"

	else if(istype(I,/obj/item/weapon/stock_parts/cell) && open && !cell)
		if(!user.drop_item())
			return
		var/obj/item/weapon/stock_parts/cell/C = I
		C.loc = src
		cell = C
		updateDialog()
	else if(istype(I,/obj/item/weapon/screwdriver))
		if(locked)
			user << "<span class='warning'>The maintenance hatch cannot be opened or closed while the controls are locked!</span>"
			return

		open = !open
		if(open)
			visible_message("[user] opens the maintenance hatch of [src]", "<span class='notice'>You open [src]'s maintenance hatch.</span>")
			on = 0
			icon_state="mulebot-hatch"
		else
			visible_message("[user] closes the maintenance hatch of [src]", "<span class='notice'>You close [src]'s maintenance hatch.</span>")
			icon_state = "mulebot0"

		updateDialog()
	else if (istype(I, /obj/item/weapon/wrench))
		if (health < maxhealth)
			health = min(maxhealth, health+25)
			user.visible_message(
				"[user] repairs [src]!",
				"<span class='notice'>You repair [src].</span>"
			)
		else
			user << "<span class='warning'>[src] does not need a repair!</span>"
	else if(istype(I, /obj/item/device/multitool) || istype(I, /obj/item/weapon/wirecutters))
		if(open)
			attack_hand(usr)
	else if(load && ismob(load))  // chance to knock off rider
		if(prob(1+I.force * 2))
			unload(0)
			user.visible_message("<span class='danger'>[user] knocks [load] off [src] with \the [I]!</span>", "<span class='danger'>You knock [load] off [src] with \the [I]!</span>")
		else
			user << "<span class='warning'>You hit [src] with \the [I] but to no effect!</span>"
	else
		..()
	return

/obj/machinery/bot/mulebot/emag_act(mob/user)
	locked = !locked
	user << "<span class='notice'>You [locked ? "lock" : "unlock"] the mulebot's controls!</span>"
	flick("mulebot-emagged", src)
	playsound(loc, 'sound/effects/sparks1.ogg', 100, 0)

/obj/machinery/bot/mulebot/ex_act(severity)
	unload(0)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			for(var/i = 1; i < 3; i++)
				wires.RandomCut()
		if(3)
			wires.RandomCut()
	return

/obj/machinery/bot/mulebot/bullet_act(obj/item/projectile/Proj)
	if(..())
		if(prob(50) && !isnull(load))
			unload(0)
		if(prob(25))
			visible_message("<span class='danger'>Something shorts out inside [src]!</span>")
			wires.RandomCut()


/obj/machinery/bot/mulebot/attack_ai(mob/user)
	user.set_machine(src)
	interact(user, 1)

/obj/machinery/bot/mulebot/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	user.set_machine(src)
	interact(user, 0)

/obj/machinery/bot/mulebot/interact(mob/user, ai=0)
	var/dat
	dat += "<h3>Multiple Utility Load Effector Mk. V</h3>"
	dat += "<b>ID:</b> [suffix]<BR>"
	dat += "<b>Power:</b> [on ? "On" : "Off"]<BR>"

	if(!open)

		dat += "<h3>Status</h3>"

		dat += "<div class='statusDisplay'>"
		switch(mode)
			if(BOT_IDLE)
				dat += "<span class='good'>Ready</span>"
			if(BOT_DELIVER)
				dat += "<span class='good'>[mode_name[BOT_DELIVER]]</span>"
			if(BOT_GO_HOME)
				dat += "<span class='good'>[mode_name[BOT_GO_HOME]]</span>"
			if(BOT_BLOCKED)
				dat += "<span class='average'>[mode_name[BOT_BLOCKED]]</span>"
			if(BOT_NAV,BOT_WAIT_FOR_NAV)
				dat += "<span class='average'>[mode_name[BOT_NAV]]</span>"
			if(BOT_NO_ROUTE)
				dat += "<span class='bad'>[mode_name[BOT_NO_ROUTE]]</span>"
		dat += "</div>"

		dat += "<b>Current Load:</b> [load ? load.name : "<i>none</i>"]<BR>"
		dat += "<b>Destination:</b> [!destination ? "<i>none</i>" : destination]<BR>"
		dat += "<b>Power level:</b> [cell ? cell.percent() : 0]%"

		if(locked && !ai)
			dat += "&nbsp;<br /><div class='notice'>Controls are locked</div><A href='byond://?src=\ref[src];op=unlock'>Unlock Controls</A>"
		else
			dat += "&nbsp;<br /><div class='notice'>Controls are unlocked</div><A href='byond://?src=\ref[src];op=lock'>Lock Controls</A><BR><BR>"

			dat += "<A href='byond://?src=\ref[src];op=power'>Toggle Power</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=stop'>Stop</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=go'>Proceed</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=home'>Return to Home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=destination'>Set Destination</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=setid'>Set Bot ID</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=sethome'>Set Home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=autoret'>Toggle Auto Return Home</A> ([auto_return ? "On":"Off"])<BR>"
			dat += "<A href='byond://?src=\ref[src];op=autopick'>Toggle Auto Pickup Crate</A> ([auto_pickup ? "On":"Off"])<BR>"
			dat += "<A href='byond://?src=\ref[src];op=report'>Toggle Delivery Reporting</A> ([report_delivery ? "On" : "Off"])<BR>"
			dat += "<A href='byond://?src=\ref[src];op=autorefresh'>Toggle Interface Refreshing</A> ([refresh ? "On" : "Off"])<BR>"

			if(load)
				dat += "<A href='byond://?src=\ref[src];op=unload'>Unload Now</A><BR>"
			dat += "<div class='notice'>The maintenance hatch is closed.</div>"

	else
		if(!ai)
			dat += "<div class='notice'>The maintenance hatch is open.</div><BR>"
			dat += "<b>Power cell:</b> "
			if(cell)
				dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
			else
				dat += "<A href='byond://?src=\ref[src];op=cellinsert'>Removed</A><BR>"

			dat += wires()
		else
			dat += "<div class='notice'>The bot is in maintenance mode and cannot be controlled.</div><BR>"

	//user << browse("<HEAD><TITLE>M.U.L.E. Mk. III [suffix ? "([suffix])" : ""]</TITLE></HEAD>[dat]", "window=mulebot;size=350x500")
	//onclose(user, "mulebot")
	var/datum/browser/popup = new(user, "mulebot", "M.U.L.E. Mk. V [suffix ? "([suffix])" : ""]", 350, 600)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()
	return

// returns the wire panel text
/obj/machinery/bot/mulebot/proc/wires()
	return wires.GetInteractWindow()


/obj/machinery/bot/mulebot/Topic(href, href_list)
	if(..())
		return
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		switch(href_list["op"])

			if("lock", "unlock")
				toggle_lock(usr)

			if("power")
				if (on)
					turn_off()
				else if (cell && !open)
					if (!turn_on())
						usr << "<span class='warning'>You can't switch on [src]!</span>"
						return
				else
					return
				visible_message("[usr] switches [on ? "on" : "off"] [src].")
				updateDialog()


			if("cellremove")
				if(open && cell && !usr.get_active_hand())
					cell.updateicon()
					usr.put_in_active_hand(cell)
					cell.add_fingerprint(usr)
					cell = null

					usr.visible_message("[usr] removes the power cell from [src].", "<span class='notice'>You remove the power cell from [src].</span>")
					updateDialog()

			if("cellinsert")
				if(open && !cell)
					var/obj/item/weapon/stock_parts/cell/C = usr.get_active_hand()
					if(istype(C))
						if(!usr.drop_item())
							return
						cell = C
						C.loc = src
						C.add_fingerprint(usr)

						usr.visible_message("[usr] inserts a power cell into [src].", "<span class='notice'>You insert the power cell into [src].</span>")
						updateDialog()
			else
				bot_control(href_list["op"], usr)


		updateDialog()
		//updateUsrDialog()
	else
		usr << browse(null, "window=mulebot")
		usr.unset_machine()
	return

/obj/machinery/bot/mulebot/bot_control(command, mob/user, pda= 0)
	if(pda && !wires.RemoteRX()) //MULE wireless is controlled by wires.
		return

	switch(command)

		if("autorefresh")
			refresh = !refresh
			updateDialog()

		if("stop")
			if(mode >= BOT_DELIVER)
				bot_reset()
				updateDialog()

		if("go")
			if(mode == BOT_IDLE)
				start()
				updateDialog()

		if("home")
			if(mode == BOT_IDLE || mode == BOT_DELIVER)
				start_home()
				updateDialog()

		if("destination")
			refresh=0
			var/new_dest = input(user, "Select M.U.L.E. Destination", "Mulebot [suffix ? "([suffix])" : ""]", destination) as null|anything in deliverybeacontags
			refresh=1
			if(new_dest)
				set_destination(new_dest)


		if("setid")
			refresh=0
			var/new_id = stripped_input(user, "Enter new bot ID", "Mulebot [suffix ? "([suffix])" : ""]", suffix, MAX_NAME_LEN)
			refresh=1
			if(new_id)
				suffix = new_id
				name = "\improper Mulebot ([suffix])"
				updateDialog()

		if("sethome")
			refresh=0
			var/new_home = stripped_input(user, "Enter new home tag", "Mulebot [suffix ? "([suffix])" : ""]", home_destination)
			refresh=1
			if(new_home)
				home_destination = new_home
				updateDialog()

		if("unload")
			if(load && mode != BOT_HUNT)
				if(loc == target)
					unload(loaddir)
				else
					unload(0)

		if("autoret")
			auto_return = !auto_return

		if("autopick")
			auto_pickup = !auto_pickup

		if("report")
			report_delivery = !report_delivery

		if("close")
			usr.unset_machine()
			usr << browse(null,"window=mulebot")



// returns true if the bot has power
/obj/machinery/bot/mulebot/proc/has_power()
	return !open && cell && cell.charge > 0 && wires.HasPower()

/obj/machinery/bot/mulebot/proc/toggle_lock(mob/user)
	if(allowed(user))
		locked = !locked
		updateDialog()
		return 1
	else
		user << "<span class='danger'>Access denied.</span>"
		return 0

/obj/machinery/bot/mulebot/proc/buzz(type)
	switch(type)
		if(SIGH)
			audible_message("[src] makes a sighing buzz.", "<span class='italics'>You hear an electronic buzzing sound.</span>")
			playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		if(ANNOYED)
			audible_message("[src] makes an annoyed buzzing sound.", "<span class='italics'>You hear an electronic buzzing sound.</span>")
			playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
		if(DELIGHT)
			audible_message("[src] makes a delighted ping!", "<span class='italics'>You hear a ping.</span>")
			playsound(loc, 'sound/machines/ping.ogg', 50, 0)


// mousedrop a crate to load the bot
// can load anything if emagged
/obj/machinery/bot/mulebot/MouseDrop_T(atom/movable/AM, mob/user)

	if(user.incapacitated() || user.lying)
		return

	if (!istype(AM))
		return

	load(AM)

// called to load a crate
/obj/machinery/bot/mulebot/proc/load(atom/movable/AM)
	if(load ||  AM.anchored)
		return

	if(!isturf(AM.loc)) //To prevent the loading from stuff from someone's inventory or screen icons.
		return

	var/obj/structure/closet/crate/CRATE
	if(istype(AM,/obj/structure/closet/crate))
		CRATE = AM
	else
		if(wires.LoadCheck())
			buzz(SIGH)
			return		// if not emagged, only allow crates to be loaded

	if(CRATE) // if it's a crate, close before loading
		CRATE.close()

	if(isobj(AM))
		var/obj/O = AM
		if(O.buckled_mob || (locate(/mob) in AM)) //can't load non crates objects with mobs buckled to it or inside it.
			buzz(SIGH)
			return

	if(isliving(AM))
		if(!buckle_mob(AM))
			return
	else
		AM.loc = src
		AM.pixel_y += 9
		if(AM.layer < layer)
			AM.layer = layer + 0.1
		overlays += AM

	load= AM
	mode = BOT_IDLE

/obj/machinery/bot/mulebot/buckle_mob(mob/living/M, force = 0)
	if(M.buckled)
		return 0
	var/turf/T = get_turf(src)
	if(M.loc != T)
		density = 0
		var/can_step = step_towards(M, T)
		density = 1
		if(!can_step)
			return 0
	return ..()


/obj/machinery/bot/mulebot/post_buckle_mob(mob/living/M)
	if(M == buckled_mob) //post buckling
		M.pixel_y = initial(M.pixel_y) + 9
		if(M.layer < layer)
			M.layer = layer + 0.1

	else //post unbuckling
		load = null
		M.layer = initial(M.layer)
		M.pixel_y = initial(M.pixel_y)


// called to unload the bot
// argument is optional direction to unload
// if zero, unload at bot's location
/obj/machinery/bot/mulebot/proc/unload(dirn)
	if(!load)
		return

	mode = BOT_IDLE

	overlays.Cut()

	if(buckled_mob)
		unbuckle_mob()
		return

	load.loc = loc
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)
	if(dirn)
		var/turf/T = loc
		var/turf/newT = get_step(T,dirn)
		if(load.CanPass(load,newT)) //Can't get off onto anything that wouldn't let you pass normally
			step(load, dirn)

	load = null



/obj/machinery/bot/mulebot/call_bot()
	..()
	var/area/dest_area
	if (path && path.len)
		target = ai_waypoint //Target is the end point of the path, the waypoint set by the AI.
		dest_area = get_area(target)
		destination = format_text(dest_area.name)
		pathset = 1 //Indicates the AI's custom path is initialized.
		start()

/obj/machinery/bot/mulebot/bot_process()
	if(!has_power())
		on = 0
		return
	if(on)
		var/speed = (wires.Motor1() ? 1 : 0) + (wires.Motor2() ? 2 : 0)
		//world << "speed: [speed]"
		var/num_steps = 0
		switch(speed)
			if(0)
				// do nothing
			if(1)
				num_steps = 10
			if(2)
				num_steps = 5
			if(3)
				num_steps = 3

		if(num_steps)
			process_bot()
			num_steps--
			for(var/i=num_steps,i>0,i--)
				sleep(2)
				process_bot()

	if(refresh) updateDialog()

/obj/machinery/bot/mulebot/proc/process_bot()

	if(!on)
		return

	switch(mode)
		if(BOT_IDLE)		// idle
			icon_state = "mulebot0"
			return

		if(BOT_DELIVER,BOT_GO_HOME,BOT_BLOCKED)		// navigating to deliver,home, or blocked
			if(loc == target)		// reached target
				at_target()
				return

			else if(path.len > 0 && target)		// valid path

				var/turf/next = path[1]
				reached_target = 0
				if(next == loc)
					path -= next
					return


				if(istype( next, /turf/simulated))
					//world << "at ([x],[y]) moving to ([next.x],[next.y])"


					if(bloodiness)
						var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
						B.blood_DNA |= blood_DNA.Copy()
						var/newdir = get_dir(next, loc)
						if(newdir == dir)
							B.dir = newdir
						else
							newdir = newdir | dir
							if(newdir == 3)
								newdir = 1
							else if(newdir == 12)
								newdir = 4
							B.dir = newdir
						bloodiness--



					var/moved = step_towards(src, next)	// attempt to move
					if(cell) cell.use(1)
					if(moved)	// successful move
						//world << "Successful move."
						blockcount = 0
						path -= loc



						if(destination == home_destination)
							mode = BOT_GO_HOME
						else
							mode = BOT_DELIVER

					else		// failed to move

						//world << "Unable to move."



						blockcount++
						mode = BOT_BLOCKED
						if(blockcount == 3)
							buzz(ANNOYED)

						if(blockcount > 10)	// attempt 10 times before recomputing
							// find new path excluding blocked turf
							buzz(SIGH)

							spawn(2)
								calc_path(next)
								if(path.len > 0)
									buzz(DELIGHT)
								mode = BOT_BLOCKED
							mode = BOT_WAIT_FOR_NAV
							return
						return
				else
					buzz(ANNOYED)
					//world << "Bad turf."
					mode = BOT_NAV
					return
			else
				//world << "No path."
				mode = BOT_NAV
				return

		if(BOT_NAV)	// calculate new path
			//world << "Calc new path."
			mode = BOT_WAIT_FOR_NAV
			spawn(0)

				calc_path()

				if(path.len > 0)
					blockcount = 0
					mode = BOT_BLOCKED
					buzz(DELIGHT)

				else
					buzz(SIGH)

					mode = BOT_NO_ROUTE


// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/mulebot/calc_path(turf/avoid = null)
	path = get_path_to(loc, target, src, /turf/proc/Distance_cardinal, 0, 250, id=botcard, exclude=avoid)


// sets the current destination
// signals all beacons matching the delivery code
// beacons will return a signal giving their locations
/obj/machinery/bot/mulebot/proc/set_destination(new_dest)
	new_destination = new_dest
	get_nav()
	updateDialog()

// starts bot moving to current destination
/obj/machinery/bot/mulebot/proc/start()
	if(!on)
		return
	if(destination == home_destination)
		mode = BOT_GO_HOME
	else
		mode = BOT_DELIVER
	icon_state = "mulebot[(wires.MobAvoid() != 0)]"
	get_nav()

// starts bot moving to home
// sends a beacon query to find
/obj/machinery/bot/mulebot/proc/start_home()
	if(!on)
		return
	spawn(0)
		set_destination(home_destination)
		mode = BOT_BLOCKED
	icon_state = "mulebot[(wires.MobAvoid() != 0)]"

// called when bot reaches current target
/obj/machinery/bot/mulebot/proc/at_target()
	if(!reached_target)
		radio_frequency = SUPP_FREQ //Supply channel
		audible_message("[src] makes a chiming sound!", "<span class='italics'>You hear a chime.</span>")
		playsound(loc, 'sound/machines/chime.ogg', 50, 0)
		reached_target = 1

		if(pathset) //The AI called us here, so notify it of our arrival.
			loaddir = dir //The MULE will attempt to load a crate in whatever direction the MULE is "facing".
			if(calling_ai)
				calling_ai << "<span class='notice'>\icon[src] [src] wirelessly plays a chiming sound!</span>"
				playsound(calling_ai, 'sound/machines/chime.ogg',40, 0)
				calling_ai = null
				radio_frequency = AIPRIV_FREQ //Report on AI Private instead if the AI is controlling us.

		if(load)		// if loaded, unload at target
			if(report_delivery)
				speak("Destination <b>[destination]</b> reached. Unloading [load].",radio_frequency)
			unload(loaddir)
		else
			// not loaded
			if(auto_pickup)		// find a crate
				var/atom/movable/AM
				if(!wires.LoadCheck())		// if emagged, load first unanchored thing we find
					for(var/atom/movable/A in get_step(loc, loaddir))
						if(!A.anchored)
							AM = A
							break
				else			// otherwise, look for crates only
					AM = locate(/obj/structure/closet/crate) in get_step(loc,loaddir)
				if(AM && AM.Adjacent(src))
					load(AM)
					if(report_delivery)
						speak("Now loading [load] at <b>[get_area(src)]</b>.", radio_frequency)
		// whatever happened, check to see if we return home

		if(auto_return && destination != home_destination)
			// auto return set and not at home already
			start_home()
			mode = BOT_BLOCKED
		else
			bot_reset()	// otherwise go idle

	return

// called when bot bumps into anything
/obj/machinery/bot/mulebot/Bump(atom/obs)
	if(!wires.MobAvoid())		//usually just bumps, but if avoidance disabled knock over mobs
		var/mob/M = obs
		if(ismob(M))
			if(istype(M,/mob/living/silicon/robot))
				visible_message("<span class='danger'>[src] bumps into [M]!</span>")
			else
				visible_message("<span class='danger'>[src] knocks over [M]!</span>")
				M.stop_pulling()
				M.Stun(8)
				M.Weaken(5)
	return ..()

/obj/machinery/bot/mulebot/alter_health()
	return get_turf(src)


// called from mob/living/carbon/human/Crossed()
// when mulebot is in the same loc
/obj/machinery/bot/mulebot/proc/RunOver(mob/living/carbon/human/H)
	H.visible_message("<span class='danger'>[src] drives over [H]!</span>", \
					"<span class='userdanger'>[src] drives over you!<span>")
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)

	var/damage = rand(5,15)
	H.apply_damage(2*damage, BRUTE, "head")
	H.apply_damage(2*damage, BRUTE, "chest")
	H.apply_damage(0.5*damage, BRUTE, "l_leg")
	H.apply_damage(0.5*damage, BRUTE, "r_leg")
	H.apply_damage(0.5*damage, BRUTE, "l_arm")
	H.apply_damage(0.5*damage, BRUTE, "r_arm")

	var/obj/effect/decal/cleanable/blood/B = new(loc)
	B.add_blood_list(H)
	add_blood_list(H)
	bloodiness += 4
	add_logs(src, H, "ran over")

// player on mulebot attempted to move
/obj/machinery/bot/mulebot/relaymove(mob/user)
	if(user.incapacitated())
		return
	if(load == user)
		unload(0)


//Update navigation data. Called when commanded to deliver, return home, or a route update is needed...
/obj/machinery/bot/mulebot/proc/get_nav()
//Formerly the beacon reception proc, except that it is no longer a potential lag bomb called TEN TIMES A SECOND OR MORE in some cases!
	if(!on || !wires.BeaconRX())
		return

	for(var/obj/machinery/navbeacon/NB in deliverybeacons)
		if(NB.location == new_destination)	// if the beacon location matches the set destination
									// the we will navigate there
			destination = new_destination
			target = NB.loc
			var/direction = NB.dir	// this will be the load/unload dir
			if(direction)
				loaddir = text2num(direction)
			else
				loaddir = 0
			icon_state = "mulebot[(wires.MobAvoid() != null)]"
			if(destination) // No need to calculate a path if you do not have a destination set!
				calc_path()
			updateDialog()

/obj/machinery/bot/mulebot/emp_act(severity)
	if (cell)
		cell.emp_act(severity)
	if(load)
		load.emp_act(severity)
	..()


/obj/machinery/bot/mulebot/explode()
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)
	if (cell)
		cell.loc = Tsec
		cell.update_icon()
		cell = null

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	..() //qdels us and removes us from processing objects

#undef SIGH
#undef ANNOYED
#undef DELIGHT
