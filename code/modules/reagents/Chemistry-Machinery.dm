#define SOLID 1
#define LIQUID 2
#define GAS 3

/obj/machinery/chem_dispenser
	name = "chem dispenser"
	desc = "Creates and dispenses chemicals."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 1
	idle_power_usage = 40
	l_color = "#0000FF"
	var/energy = 50
	var/max_energy = 50
	var/amount = 30
	var/beaker = null
	var/uiname = "Chem Dispenser 5000"
	var/recharged = 0
	var/recharge_delay = 15  //Time it game ticks between recharges
	var/list/dispensable_reagents = list("hydrogen","lithium","carbon","nitrogen","oxygen","fluorine",
	"sodium","aluminium","silicon","phosphorus","sulfur","chlorine","potassium","iron",
	"copper","mercury","radium","water","ethanol","sugar","sacid")

/obj/machinery/chem_dispenser/proc/recharge()
	if(stat & (BROKEN|NOPOWER)) return
	var/addenergy = 1
	var/oldenergy = energy
	energy = min(energy + addenergy, max_energy)
	if(energy != oldenergy)
		use_power(1500) // This thing uses up alot of power (this is still low as shit for creating reagents from thin air)
		nanomanager.update_uis(src) // update all UIs attached to src

/obj/machinery/chem_dispenser/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/machinery/chem_dispenser/process()

	if(recharged < 0)
		recharge()
		recharged = recharge_delay
	else
		recharged -= 1

/obj/machinery/chem_dispenser/New()
	..()
	recharge()
	dispensable_reagents = sortList(dispensable_reagents)

/obj/machinery/chem_dispenser/ex_act(severity, target)
	if(severity < 3)
		..()

/obj/machinery/chem_dispenser/blob_act()
	if(prob(50))
		qdel(src)

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/chem_dispenser/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	if(stat & (BROKEN)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	data["amount"] = amount
	data["energy"] = energy
	data["maxEnergy"] = max_energy
	data["isBeakerLoaded"] = beaker ? 1 : 0

	var beakerContents[0]
	var beakerCurrentVolume = 0
	if(beaker && beaker:reagents && beaker:reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker:reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker:volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var chemicals[0]
	for (var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "chem_dispenser.tmpl", "[uiname]", 390, 610)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/chem_dispenser/Topic(href, href_list)
	if(stat & (BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		if (amount < 0) // Since the user can actually type the commands himself, some sanity checking
			amount = 0
		if (amount > 100)
			amount = 100

	if(href_list["dispense"])
		if (dispensable_reagents.Find(href_list["dispense"]) && beaker != null)
			var/obj/item/weapon/reagent_containers/glass/B = src.beaker
			var/datum/reagents/R = B.reagents
			var/space = R.maximum_volume - R.total_volume

			R.add_reagent(href_list["dispense"], min(amount, energy * 10, space))
			energy = max(energy - min(amount, energy * 10, space) / 10, 0)

	if(href_list["ejectBeaker"])
		if(beaker)
			var/obj/item/weapon/reagent_containers/glass/B = beaker
			B.loc = loc
			beaker = null

	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/chem_dispenser/attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return

	if(!istype(B, /obj/item/weapon/reagent_containers/glass))
		return

	if(src.beaker)
		user << "A beaker is already loaded into the machine."
		return

	src.beaker =  B
	user.drop_item()
	B.loc = src
	user << "You add the beaker to the machine!"
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/machinery/chem_dispenser/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chem_dispenser/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chem_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return

	ui_interact(user)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_dispenser/constructable
	name = "portable chem dispenser"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "minidispenser"
	energy = 5
	max_energy = 5
	amount = 5
	recharge_delay = 30
	dispensable_reagents = list()
	var/list/special_reagents = list(list("hydrogen", "oxygen", "silicon", "phosphorus", "sulfur", "carbon", "nitrogen"),
						 		list("lithium", "sugar", "sacid", "water", "copper", "mercury", "sodium"),
								list("ethanol", "chlorine", "potassium", "aluminium", "radium", "fluorine", "iron"))

/obj/machinery/chem_dispenser/constructable/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/chem_dispenser(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/stock_parts/cell/high(null)
	RefreshParts()

/obj/machinery/chem_dispenser/constructable/RefreshParts()
	var/time = 0
	var/temp_energy = 0
	var/i
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		temp_energy += M.rating
	temp_energy--
	max_energy = temp_energy * 5  //max energy = (bin1.rating + bin2.rating - 1) * 5, 5 on lowest 25 on highest
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		time += C.rating
	for(var/obj/item/weapon/stock_parts/cell/P in component_parts)
		time += round(P.maxcharge, 10000) / 10000
	recharge_delay /= time/2         //delay between recharges, double the usual time on lowest 50% less than usual on highest
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		for(i=1, i<=M.rating, i++)
			dispensable_reagents = sortList(dispensable_reagents | special_reagents[i])

/obj/machinery/chem_dispenser/constructable/attackby(var/obj/item/I, var/mob/user, params)
	..()
	if(default_deconstruction_screwdriver(user, "minidispenser-o", "minidispenser", I))
		return

	if(exchange_parts(user, I))
		return

	if(panel_open)
		if(istype(I, /obj/item/weapon/crowbar))
			if(beaker)
				var/obj/item/weapon/reagent_containers/glass/B = beaker
				B.loc = loc
				beaker = null
			default_deconstruction_crowbar(I)
			return 1

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/adv_chem
	name = "Advanced chemical machine"
	desc = "Something is wrong if this is the machine you are using!"
	density = 1
	anchored = 1
	icon = 'icons/obj/machines/chem.dmi'
	icon_state = "distill"
	use_power = 1
	idle_power_usage = 10
	var/obj/item/weapon/reagent_containers/glass/beaker = null

/obj/machinery/adv_chem/ex_act(severity, target)
	if(severity < 3)
		..()

/obj/machinery/adv_chem/blob_act()
	if (prob(50))
		qdel(src)

/obj/machinery/adv_chem/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
/obj/machinery/adv_chem/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(istype(B,/obj/item/weapon/reagent_containers/glass))
		if(src.beaker)
			user<<"A beaker is already loaded into the machine"
			return
		else
			user.drop_item()
			B.loc = src
			user << "You add the beaker to the machine!"
			src.beaker = B
			src.updateUsrDialog()
/obj/machinery/adv_chem/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/adv_chem/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/adv_chem/attack_hand(mob/user as mob)
	return
/obj/machinery/adv_chem/process()
	return
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/adv_chem/pressure
	name = "Pressurized reaction chamber"
	desc = "Creates immensly high pressures to suit certain reaction conditions"
	density = 1
	anchored = 1
	icon_state = "press"
	use_power = 1
	idle_power_usage = 10
	var/pressure = 1
	var/target_pressure = 1

/obj/machinery/adv_chem/pressure/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = ""
	if(!src.beaker)
		dat += "No beaker loaded"
	else
		dat += "Target pressure: [src.pressure] Atmospheres <BR><BR>"


		dat += "<A href='?src=\ref[src];lower=1'>Pressure (- 1) </A> "
		dat += "<A href='?src=\ref[src];higher=1'>Pressure (+ 1)</A> "
		dat += "<A href='?src=\ref[src];lower_=1'>Pressure (- 10) </A> "
		dat += "<A href='?src=\ref[src];higher_=1'>Pressure (+ 10)</A> "
		dat += "<A href='?src=\ref[src];pressure=1'>Pressurize chamber</A><BR><BR> "
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR> "
		dat += "Contained reagents<BR>"
		var/datum/reagents/R = src.beaker:reagents
		for(var/datum/reagent/I in R.reagent_list)
			dat += "Reagent : [I.name] , [I.volume] Units <BR>"
	user << browse("<TITLE>Pressurized reaction chamber</TITLE>Reactor menu:<BR><BR>[dat]", "window=preactor;size=575x400")
	onclose(user, "preactor")

/obj/machinery/adv_chem/pressure/Topic(href, href_list)
	usr.set_machine(src)
	if(href_list["lower"])
		if(src.pressure - 1 >= 0)
			src.pressure -= 1
	else if(href_list["higher"])
		if(src.pressure + 1 <= 200)
			src.pressure += 1
	if(href_list["lower_"])
		if(src.pressure - 10 >= 0)
			src.pressure -= 10
		else
			src.pressure = 0
	else if(href_list["higher_"])
		if(src.pressure + 10 <= 100)
			src.pressure += 10
		else
			src.pressure = 100
	else if(href_list["pressure"])
		var/datum/reagents/R = src.beaker:reagents
		R.present_machines[3] = src.pressure
		R.handle_reactions()
		R.present_machines[3] = -1 //reset it so we don't have magic infinite reactions or reactions that dont happen.
	else if(href_list["eject"])
		src.beaker.loc = src.loc
		src.beaker = null
	src.updateUsrDialog()
	return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/adv_chem/radioactive//break up in action dust I walk my brow and I strut my
	name = "Radioactive molecular reassembler"
	desc = "A mystical machine that changes molecules directly on the level of bonding."
	density = 1
	anchored = 1
	icon_state = "radio"
	use_power = 1
	idle_power_usage = 10
	var/material_amt = 0 //requires uranium in order to function
	var/active = 0
	var/curr_time = 0
	var/target_time = 10

/obj/machinery/adv_chem/radioactive/attackby(var/obj/item/B as obj, var/mob/user as mob)
	if(istype(B,/obj/item/weapon/reagent_containers/glass))
		if(src.beaker)
			user<<"A beaker is already loaded into the machine"
			return
		else
			user.drop_item()
			B.loc = src
			user << "You add the beaker to the machine!"
			src.beaker = B
			src.updateUsrDialog()
	if(istype(B,/obj/item/stack/sheet/mineral/uranium))
		user<<"You add the uranium to the machine"
		var/obj/item/stack/sheet/mineral/uranium/I = B
		material_amt += I.amount * 500
		user.drop_item()
		qdel(I)//it's a var now

/obj/machinery/adv_chem/radioactive/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	if(!beaker || material_amt == 0)
		user.visible_message("<span class='danger'>The [src.name] pings angrilly!</span>")
	else if(!active)
		user<<"<span class='notice'>You turn on the [src.name].</span>"
		active = 1
/obj/machinery/adv_chem/radioactive/process()
	if(stat & BROKEN || !active || !beaker)
		return
	if(curr_time == target_time)
		active = 0
		curr_time = 0
		var/datum/reagents/R = src.beaker:reagents
		R.present_machines[4] = -1//reset the value so we don't have outside reactions
		beaker.loc = src.loc
		beaker = null
		return
	curr_time ++
	if(prob(25))
		src.visible_message("<span class='notice'>The [src.name] humms loudly.</span>")
		var/datum/reagents/R = src.beaker:reagents
		R.present_machines[4] = rand(0,30)//much more out of chance much more dangerous
		R.handle_reactions()//always called
		material_amt -= 10 //50 charges per sheet of uranium
		for(var/mob/living/l in range(4,src))//boy is this thing nasty!
			if(l in view())
				l.show_message("<span class=\"warning\">You become covered in radiation burns from the [src.name].</span>")
			else
				l.show_message("<span class=\"warning\">Your clothes feel warm and you notice your arms a burnt!</span>", 2)
			var/rads = 100 * sqrt( 1 / (get_dist(l, src) + 1) )
			l.apply_effect(rads, IRRADIATE)
//do_teleport(L, get_turf(L), blink_range, asoundin = 'sound/effects/phasein.ogg')
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/adv_chem/bluespace
	name = "Bluespace recombobulator"
	desc = "Forget changing molecules , this thing changes the laws of physics itself in order to produce chemicals."
	density = 1
	anchored = 1
	icon_state = "blue"
	use_power = 1
	idle_power_usage = 10
	//var/material_amt = 0 // I might add something I don't know
	var/curr_time = 0
	var/target_time = 10
	var/active = 0
	var/crystal_amt = 0
	var/target_activity = 0


/obj/machinery/adv_chem/bluespace/attackby(var/obj/item/B as obj, var/mob/user as mob)
	if(istype(B,/obj/item/weapon/reagent_containers/glass))
		if(src.beaker)
			user<<"A beaker is already loaded into the machine"
			return
		else
			user.drop_item()
			B.loc = src
			user << "You add the beaker to the machine!"
			src.beaker = B
			src.updateUsrDialog()
	if(istype(B,/obj/item/bluespace_crystal))
		crystal_amt += 1
		user<<"<span class='notice'>You add the bluespace crystal to the machine!</span>"
		user.drop_item()
		qdel(B)

/obj/machinery/adv_chem/bluespace/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	if(!beaker)
		user<<"<span class='notice'>There is no beaker loaded in the [src.name]"
		if(prob(10))
			user.visible_message("<span class='danger'>The [src.name] sparks!</span>")
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
			sparks.set_up(1, 1, src)
			sparks.start()
	else
		var/dat = ""
		dat += "Active : [(active)? "Yes" : "No"] <BR><BR>"
		dat += "Target bluespace activity : [src.target_activity] <BR><BR>"
		dat += "<A href='?src=\ref[src];lower=1'>Activity (-1) </A> "
		dat += "<A href='?src=\ref[src];higher=1'>Activity (+1)</A> "
		dat += "<A href='?src=\ref[src];heat=1'>Recombobulate</A><BR><BR> "
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR> "
		dat += "Contained reagents<BR>"
		var/datum/reagents/R = src.beaker:reagents
		for(var/datum/reagent/I in R.reagent_list)
			dat += "[I.name] , [I.volume] Units <BR>"
		user << browse("<TITLE>Bluespace recombobulator</TITLE>Bluespace recombobulator menu:<BR><BR>[dat]", "window=bluespace;size=575x400")
		onclose(user, "bluespace")
/obj/machinery/adv_chem/bluespace/Topic(href, href_list)
	usr.set_machine(src)
	if(href_list["lower"])
		if(src.target_activity - 1 >= 0)
			src.target_activity -= 1
	else if(href_list["higher"])
		if(src.target_activity + 1 <= 30)
			src.target_activity += 1
	else if(href_list["heat"])
		active = !active
	else if(href_list["eject"])
		if(!active)
			src.beaker.loc = src.loc
			src.beaker = null
	src.updateUsrDialog()
	return

/obj/machinery/adv_chem/bluespace/process()
	if(stat & BROKEN || !active || !beaker)
		return
	if(curr_time == target_time)
		active = 0
		curr_time = 0
		var/datum/reagents/R = src.beaker:reagents
		R.present_machines[5] = 0//reset the value so we don't have outside reactions
		beaker.loc = src.loc
		beaker = null
		return
	curr_time ++
	if(prob(30))
		src.visible_message("<span class='danger'>The [src.name] sparks crazily!.</span>")
		var/datum/reagents/R = src.beaker:reagents
		if(!(crystal_amt > 0))
			R.present_machines[5] = rand(0,30)//much more out of chance much more dangerous
		else
			var/value = rand(target_activity , target_activity + 3)
			if(value > 30)
				value = 30
			else if(value < 0)
				value = 0
			crystal_amt -= 1
			R.present_machines[5] = value
		R.handle_reactions()//always called
	if(prob(20))//low chance but could still happen
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread//give it some sparks for drama ofc!
		sparks.set_up(1, 1, src)
		sparks.start()
		for(var/mob/living/l in range(2,src))//boy is this thing nasty!
			l.show_message("<span class=\"warning\">You feel disorientated!</span>")
			do_teleport(l, get_turf(l), 5, asoundin = 'sound/effects/phasein.ogg')

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/adv_chem/distiller
	name = "Chemical Distillery"
	desc = "Used in the manufacturing of highly complicated chemicals"
	density = 1
	anchored = 1
	icon_state = "distill"
	use_power = 1
	idle_power_usage = 10
	var/temperature = 270
	var/target_temp = 270
	var/heating = 0

/obj/machinery/adv_chem/distiller/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(istype(B,/obj/item/weapon/reagent_containers/glass))
		if(src.beaker)
			user<<"A beaker is already loaded into the machine"
			return
		else
			heating = 0
			user.drop_item()
			B.loc = src
			user << "You add the beaker to the machine!"
			src.beaker = B
			temperature = src.beaker:reagents.present_machines[1]//this makes it unique
			src.updateUsrDialog()
/obj/machinery/adv_chem/distiller/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = ""
	if(!src.beaker)
		dat += "No beaker loaded"
	else if(src.temperature != -1)
		dat += "Temperature : [src.temperature]K <BR><BR>"
		dat += "Target temperature : [src.target_temp]K <BR><BR>"
		dat += "<A href='?src=\ref[src];lower=1'>Temp (- 10) </A> "
		dat += "<A href='?src=\ref[src];higher=1'>Temp (+ 10)</A> "
		dat += "<A href='?src=\ref[src];lower_=1'>Temp (- 100) </A> "
		dat += "<A href='?src=\ref[src];higher_=1'>Temp (+ 100)</A> "
		dat += "<A href='?src=\ref[src];heat=1'>Heat beaker</A><BR><BR> "
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR> "
		dat += "Contained reagents<BR>"
		var/datum/reagents/R = src.beaker:reagents
		for(var/datum/reagent/I in R.reagent_list)
			dat += "[I.name] , [I.volume] Units <BR>"
	else
		dat += "No reagents within the container"
	user << browse("<TITLE>Chemical Distillery</TITLE>Chemical Distillery menu:<BR><BR>[dat]", "window=dist;size=575x400")
	onclose(user, "dist")

/obj/machinery/adv_chem/distiller/Topic(href, href_list)
	usr.set_machine(src)
	if(href_list["lower"])
		if(src.target_temp - 10 >= 0)
			src.target_temp -= 10
	else if(href_list["higher"])
		if(src.target_temp + 10 <= 500)
			src.target_temp += 10
	if(href_list["lower_"])
		if(src.target_temp - 100 >= 0)
			src.target_temp -= 100
		else
			src.target_temp = 0
	else if(href_list["higher_"])
		if(src.target_temp + 100 <= 500)
			src.target_temp += 100
		else
			src.target_temp = 500
	else if(href_list["heat"])
		heating = !heating
	else if(href_list["eject"])
		heating = 0
		src.beaker.loc = src.loc
		src.beaker = null
	src.updateUsrDialog()
	return
/obj/machinery/adv_chem/distiller/process()
	if((stat & (BROKEN|NOPOWER)) || !beaker)
		return
	if(heating)
		var/datum/reagents/R = src.beaker:reagents
		if(R.present_machines[1] == -1)
			return

		R.present_machines[1] = src.temperature
		R.handle_reactions()//always called
		if(temperature == target_temp)
			heating = 0
			return
		var/increase_amt = 30 //temp to increase by , because it's this value chemials can and will overheat_react
		if(target_temp > temperature)
			if(temperature + increase_amt > target_temp)
				increase_amt -= ((temperature + increase_amt) - target_temp) //get it to the exact temperature
		else
			increase_amt = -30
			if(temperature + increase_amt < target_temp)
				increase_amt -= ((temperature + increase_amt) - target_temp)
		if(increase_amt + temperature > 500)
			increase_amt -= (temperature + increase_amt) - 500
		else if(increase_amt + temperature < 0)
			increase_amt -= (temperature + increase_amt)
		temperature += increase_amt
	src.updateUsrDialog()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/adv_chem/centrifuge
	name = "Centrifuge"
	desc = "Spins chemicals at high speeds to seperate them"
	density = 1
	anchored = 1
	icon_state = "cent_off"
	use_power = 1
	idle_power_usage = 30
	var/time_required = 30
	var/current_time = 0
	var/working = 0

/obj/machinery/adv_chem/centrifuge/attack_hand(mob/user as mob)
	if(stat & BROKEN || working)
		return
	if(src.beaker)
		user<<"<span class='notice'>You activate the centrifuge."
		//play sound here
		working = 1


	else
		user<<"<span class='notice'>No beaker is in the machine!"

/obj/machinery/adv_chem/centrifuge/process()
	if((stat & (BROKEN|NOPOWER)) || !working)
		return
	else
		icon_state = "cent_on"
		current_time ++
		if(current_time == time_required)
			icon_state = "cent_off"
			var/datum/reagents/Reagent = src.beaker:reagents
			Reagent.present_machines[2] = 1
			Reagent.handle_reactions()
			Reagent.present_machines[2] = -1
			working = 0
			current_time = 0
			src.beaker.loc = src.loc
			src.beaker = null
			return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "ChemMaster 3000"
	desc = "Used to bottle chemicals to create pills."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	var/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount

/obj/machinery/chem_master/New()
	create_reagents(100)
	overlays += "waitlight"

/obj/machinery/chem_master/ex_act(severity, target)
	if(severity < 3)
		..()

/obj/machinery/chem_master/blob_act()
	if (prob(50))
		qdel(src)

/obj/machinery/chem_master/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER

/obj/machinery/chem_master/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)

	if(default_unfasten_wrench(user, B))
		return

	if(istype(B, /obj/item/weapon/reagent_containers/glass))

		if(src.beaker)
			user << "A beaker is already loaded into the machine."
			return
		src.beaker = B
		user.drop_item()
		B.loc = src
		user << "You add the beaker to the machine!"
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(istype(B, /obj/item/weapon/storage/pill_bottle))

		if(src.loaded_pill_bottle)
			user << "A pill bottle is already loaded into the machine."
			return

		src.loaded_pill_bottle = B
		user.drop_item()
		B.loc = src
		user << "You add the pill bottle into the dispenser slot!"
		src.updateUsrDialog()
	return

/obj/machinery/chem_master/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)


	if (href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.loc = src.loc
			loaded_pill_bottle = null
	else if(href_list["close"])
		usr << browse(null, "window=chem_master")
		usr.unset_machine()
		return

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		if (href_list["analyze"])
			var/dat = ""
			if(!condi)
				dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if (href_list["add"])

			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				if (amount < 0) return
				R.trans_id_to(src, id, amount)

		else if (href_list["addcustom"])

			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = isgoodnumber(useramount)
			src.Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if (href_list["remove"])

			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if (amount < 0) return
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
				else
					reagents.remove_reagent(id, amount)


		else if (href_list["removecustom"])

			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = isgoodnumber(useramount)
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			if(beaker)
				beaker:loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"
		else if (href_list["createpill"]) //Also used for condiment packs.
			if(reagents.total_volume == 0) return
			if(!condi)
				var/amount = 1
				var/vol_each = min(reagents.total_volume, 50)
				if(text2num(href_list["many"]))
					amount = min(max(round(input(usr, "Amount:", "How many pills?") as num), 1), 10)
					vol_each = min(reagents.total_volume/amount, 50)
				var/name = reject_bad_text(input(usr,"Name:","Name your pill!", "[reagents.get_master_reagent_name()] ([vol_each]u)"))
				var/obj/item/weapon/reagent_containers/pill/P

				for(var/i = 0; i < amount; i++)
					if(loaded_pill_bottle && loaded_pill_bottle.contents.len < loaded_pill_bottle.storage_slots)
						P = new/obj/item/weapon/reagent_containers/pill(loaded_pill_bottle)
					else
						P = new/obj/item/weapon/reagent_containers/pill(src.loc)
					if(!name) name = reagents.get_master_reagent_name()
					P.name = "[name] pill"
					P.pixel_x = rand(-7, 7) //random position
					P.pixel_y = rand(-7, 7)
					reagents.trans_to(P,vol_each)
			else
				var/name = reject_bad_text(input(usr,"Name:","Name your bag!",reagents.get_master_reagent_name()))
				var/obj/item/weapon/reagent_containers/food/condiment/pack/P = new/obj/item/weapon/reagent_containers/food/condiment/pack(src.loc)

				if(!name) name = reagents.get_master_reagent_name()
				P.originalname = name
				P.name = "[name] pack"
				P.desc = "A small condiment pack. The label says it contains [name]."
				reagents.trans_to(P,10)

		else if (href_list["createbottle"])
			if(!condi)
				var/name = reject_bad_text(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()))
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				reagents.trans_to(P,30)
			else
				var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
				reagents.trans_to(P,50)

	src.updateUsrDialog()
	return

/obj/machinery/chem_master/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.storage_slots]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.storage_slots]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in R.reagent_list)
				dat += "[G.name] , [G.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[G.description];name=[G.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=[G.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];addcustom=[G.id]'>(Custom)</A><BR>"

		dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.name] , [N.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[N.description];name=[N.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=[N.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];removecustom=[N.id]'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='?src=\ref[src];createpill=1;many=0'>Create pill (50 units max)</A><BR>"
			dat += "<A href='?src=\ref[src];createpill=1;many=1'>Create pills (10 pills max)</A><BR><BR>"
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (30 units max)</A>"
		else
			dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pack (10 units max)</A><BR>"
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
	if(!condi)
		user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	else
		user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	onclose(user, "chem_master")
	return

/obj/machinery/chem_master/proc/isgoodnumber(var/num)
	if(isnum(num))
		if(num > 200)
			num = 200
		else if(num < 0)
			num = 1
		else
			num = round(num)
		return num
	else
		return 0



/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	desc = "Used to create condiments and other cooking supplies."
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	desc = "Used to work with viruses."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/weapon/circuitboard/pandemic
	use_power = 1
	idle_power_usage = 20
	var/temp_html = ""
	var/wait = null
	var/obj/item/weapon/reagent_containers/glass/beaker = null

obj/machinery/computer/pandemic/New()
	..()
	update_icon()

/obj/machinery/computer/pandemic/set_broken()
	icon_state = (src.beaker?"mixer1_b":"mixer0_b")
	overlays.Cut()
	stat |= BROKEN

/obj/machinery/computer/pandemic/proc/GetVirusByIndex(var/index)
	if(beaker && beaker.reagents)
		if(beaker.reagents.reagent_list.len)
			var/datum/reagent/blood/BL = locate() in beaker.reagents.reagent_list
			if(BL)
				if(BL.data && BL.data["viruses"])
					var/list/viruses = BL.data["viruses"]
					return viruses[index]
	return null

/obj/machinery/computer/pandemic/proc/GetResistancesByIndex(var/index)
	if(beaker && beaker.reagents)
		if(beaker.reagents.reagent_list.len)
			var/datum/reagent/blood/BL = locate() in beaker.reagents.reagent_list
			if(BL)
				if(BL.data && BL.data["resistances"])
					var/list/resistances = BL.data["resistances"]
					return resistances[index]
	return null

/obj/machinery/computer/pandemic/proc/GetVirusTypeByIndex(var/index)
	var/datum/disease/D = GetVirusByIndex(index)
	if(D)
		return D.GetDiseaseID()
	return null

obj/machinery/computer/pandemic/proc/replicator_cooldown(var/waittime)
	wait = 1
	update_icon()
	spawn(waittime)
		src.wait = null
		update_icon()
		playsound(src.loc, 'sound/machines/ping.ogg', 30, 1)

/obj/machinery/computer/pandemic/update_icon()
	if(stat & BROKEN)
		icon_state = (src.beaker?"mixer1_b":"mixer0_b")
		return

	icon_state = "mixer[(beaker)?"1":"0"][(powered()) ? "" : "_nopower"]"

	if(wait)
		overlays.Cut()
	else
		overlays += "waitlight"

/obj/machinery/computer/pandemic/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(!beaker) return

	if (href_list["create_vaccine"])
		if(!src.wait)
			var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
			if(B)
				B.pixel_x = rand(-3, 3)
				B.pixel_y = rand(-3, 3)
				var/path = GetResistancesByIndex(text2num(href_list["create_vaccine"]))
				var/vaccine_type = path
				var/vaccine_name = "Unknown"

				if(!ispath(vaccine_type))
					if(archive_diseases[path])
						var/datum/disease/D = archive_diseases[path]
						if(D)
							vaccine_name = D.name
							vaccine_type = path
				else if(vaccine_type)
					var/datum/disease/D = new vaccine_type(0, null)
					if(D)
						vaccine_name = D.name

				if(vaccine_type)

					B.name = "[vaccine_name] vaccine bottle"
					B.reagents.add_reagent("vaccine", 15, list(vaccine_type))
					replicator_cooldown(200)
		else
			src.temp_html = "The replicator is not ready yet."
		src.updateUsrDialog()
		return
	else if (href_list["create_virus_culture"])
		if(!wait)
			var/type = GetVirusTypeByIndex(text2num(href_list["create_virus_culture"]))//the path is received as string - converting
			var/datum/disease/D = null
			if(!ispath(type))
				D = GetVirusByIndex(text2num(href_list["create_virus_culture"]))
				var/datum/disease/advance/A = archive_diseases[D.GetDiseaseID()]
				if(A)
					D = new A.type(0, A)
			else if(type)
				if(type in diseases) // Make sure this is a disease
					D = new type(0, null)
			if(!D)
				return
			var/name = stripped_input(usr,"Name:","Name the culture",D.name,MAX_NAME_LEN)
			if(name == null)
				return
			var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
			B.icon_state = "bottle3"
			B.pixel_x = rand(-3, 3)
			B.pixel_y = rand(-3, 3)
			replicator_cooldown(50)
			var/list/data = list("viruses"=list(D))
			B.name = "[name] culture bottle"
			B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
			B.reagents.add_reagent("blood",20,data)
			src.updateUsrDialog()
		else
			src.temp_html = "The replicator is not ready yet."
		src.updateUsrDialog()
		return
	else if (href_list["empty_beaker"])
		beaker.reagents.clear_reagents()
		src.updateUsrDialog()
		return
	else if (href_list["eject"])
		beaker:loc = src.loc
		beaker = null
		icon_state = "mixer0"
		src.updateUsrDialog()
		return
	else if(href_list["clear"])
		src.temp_html = ""
		src.updateUsrDialog()
		return
	else if(href_list["name_disease"])
		var/new_name = stripped_input(usr, "Name the Disease", "New Name", "", MAX_NAME_LEN)
		if(!new_name)
			return
		if(..())
			return
		var/id = GetVirusTypeByIndex(text2num(href_list["name_disease"]))
		if(archive_diseases[id])
			var/datum/disease/advance/A = archive_diseases[id]
			A.AssignName(new_name)
			for(var/datum/disease/advance/AD in active_diseases)
				AD.Refresh()
		src.updateUsrDialog()


	else
		usr << browse(null, "window=pandemic")
		src.updateUsrDialog()
		return

	src.add_fingerprint(usr)
	return

/obj/machinery/computer/pandemic/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat = ""
	if(src.temp_html)
		dat = "[src.temp_html]<BR><BR><A href='?src=\ref[src];clear=1'>Main Menu</A>"
	else if(!beaker)
		dat += "Please insert beaker.<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"
	else
		var/datum/reagents/R = beaker.reagents
		var/datum/reagent/blood/Blood = null
		for(var/datum/reagent/blood/B in R.reagent_list)
			if(B)
				Blood = B
				break
		if(!R.total_volume||!R.reagent_list.len)
			dat += "The beaker is empty<BR>"
		else if(!Blood)
			dat += "No blood sample found in beaker."
		else if(!Blood.data)
			dat += "No blood data found in beaker."
		else
			dat += "<h3>Blood sample data:</h3>"
			dat += "<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>"
			dat += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"


			if(Blood.data["viruses"])
				var/list/vir = Blood.data["viruses"]
				if(vir.len)
					var/i = 0
					for(var/datum/disease/D in Blood.data["viruses"])
						i++
						if(!(D.visibility_flags & HIDDEN_PANDEMIC))

							if(istype(D, /datum/disease/advance))

								var/datum/disease/advance/A = D
								D = archive_diseases[A.GetDiseaseID()]
								if(D && D.name == "Unknown")
									dat += "<b><a href='?src=\ref[src];name_disease=[i]'>Name Disease</a></b><BR>"

							if(!D)
								CRASH("We weren't able to get the advance disease from the archive.")

							dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[i]'>Create virus culture bottle</A>":"none"]<BR>"
							dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
							dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
							dat += "<b>Spread:</b> [(D.spread_text||"none")]<BR>"
							dat += "<b>Possible cure:</b> [(D.cure_text||"none")]<BR><BR>"

							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/A = D
								dat += "<b>Symptoms:</b> "
								var/english_symptoms = list()
								for(var/datum/symptom/S in A.symptoms)
									english_symptoms += S.name
								dat += english_list(english_symptoms)

						else
							dat += "No detectable virus in the sample."
			else
				dat += "No detectable virus in the sample."

			dat += "<BR><b>Contains antibodies to:</b> "
			if(Blood.data["resistances"])
				var/list/res = Blood.data["resistances"]
				if(res.len)
					dat += "<ul>"
					var/i = 0
					for(var/type in Blood.data["resistances"])
						i++
						var/disease_name = "Unknown"

						if(!ispath(type))
							var/datum/disease/advance/A = archive_diseases[type]
							if(A)
								disease_name = A.name
						else
							var/datum/disease/D = new type(0, null)
							disease_name = D.name

						dat += "<li>[disease_name] - <A href='?src=\ref[src];create_vaccine=[i]'>Create vaccine bottle</A></li>"
					dat += "</ul><BR>"
				else
					dat += "nothing<BR>"
			else
				dat += "nothing<BR>"
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject beaker</A>[((R.total_volume&&R.reagent_list.len) ? "-- <A href='?src=\ref[src];empty_beaker=1'>Empty beaker</A>":"")]<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"

	user << browse("<TITLE>[src.name]</TITLE><BR>[dat]", "window=pandemic;size=575x400")
	onclose(user, "pandemic")
	return


/obj/machinery/computer/pandemic/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(stat & (NOPOWER|BROKEN)) return
		if(src.beaker)
			user << "A beaker is already loaded into the machine."
			return

		src.beaker =  I
		user.drop_item()
		I.loc = src
		user << "You add the beaker to the machine!"
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(istype(I, /obj/item/weapon/screwdriver))
		if(src.beaker)
			beaker.loc = get_turf(src)
		..()
		return
	else
		..()
	return
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

		name = "All-In-One Grinder"
		desc = "Used to grind things up into raw materials."
		icon = 'icons/obj/kitchen.dmi'
		icon_state = "juicer1"
		layer = 2.9
		anchored = 1
		use_power = 1
		idle_power_usage = 5
		active_power_usage = 100
		pass_flags = PASSTABLE
		var/operating = 0
		var/obj/item/weapon/reagent_containers/beaker = null
		var/limit = 10
		var/list/blend_items = list (

				//Sheets
				/obj/item/stack/sheet/mineral/plasma = list("plasma" = 20),
				/obj/item/stack/sheet/metal = list("iron" = 20),
				/obj/item/stack/sheet/plasteel = list("iron" = 20, "plasma" = 20),
				/obj/item/stack/sheet/mineral/wood = list("carbon" = 20),
				/obj/item/stack/sheet/glass = list("silicon" = 20),
				/obj/item/stack/sheet/rglass = list("silicon" = 20, "iron" = 20),
				/obj/item/stack/sheet/mineral/uranium = list("uranium" = 20),
				/obj/item/stack/sheet/mineral/bananium = list("banana" = 20),
				/obj/item/stack/sheet/mineral/silver = list("silver" = 20),
				/obj/item/stack/sheet/mineral/gold = list("gold" = 20),
				/obj/item/weapon/grown/nettle/basic = list("sacid" = 0),
				/obj/item/weapon/grown/nettle/death = list("pacid" = 0),
				/obj/item/weapon/grown/novaflower = list("capsaicin" = 0, "condensedcapsaicin" = 0),

				//Crayons (for overriding colours)
				/obj/item/toy/crayon/red = list("redcrayonpowder" = 10),
				/obj/item/toy/crayon/orange = list("orangecrayonpowder" = 10),
				/obj/item/toy/crayon/yellow = list("yellowcrayonpowder" = 10),
				/obj/item/toy/crayon/green = list("greencrayonpowder" = 10),
				/obj/item/toy/crayon/blue = list("bluecrayonpowder" = 10),
				/obj/item/toy/crayon/purple = list("purplecrayonpowder" = 10),
				/obj/item/toy/crayon/mime = list("invisiblecrayonpowder" = 50),

				//Blender Stuff
				/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = list("soymilk" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/tomato = list("ketchup" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/corn = list("cornoil" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/wheat = list("flour" = -5),
				/obj/item/weapon/reagent_containers/food/snacks/grown/cherries = list("cherryjelly" = 0),

				//Grinder stuff, but only if dry
				/obj/item/weapon/reagent_containers/food/snacks/grown/coffee/arabica = list("coffeepowder" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/coffee/robusta = list("coffeepowder" = 0, "hyperzine" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/tea/aspera = list("teapowder" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/tea/astra = list("teapowder" = 0, "kelotane" = 0),



				//All types that you can put into the grinder to transfer the reagents to the beaker. !Put all recipes above this.!
				/obj/item/weapon/reagent_containers/pill = list(),
				/obj/item/weapon/reagent_containers/food = list(),

				/obj/item/clothing/mask/cigarette = list() //Contains reagents.
		)

		var/list/juice_items = list (

				//Juicer Stuff
				/obj/item/weapon/reagent_containers/food/snacks/grown/tomato = list("tomatojuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/carrot = list("carrotjuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/berries = list("berryjuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/banana = list("banana" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/potato = list("potato" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lemon = list("lemonjuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = list("orangejuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lime = list("limejuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/watermelonslice = list("watermelonjuice" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/berries/poison = list("poisonberryjuice" = 0),
		)

		var/list/dried_items = list(

				//Grinder stuff, but only if dry
				/obj/item/weapon/reagent_containers/food/snacks/grown/coffee/arabica = list("coffeepowder" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/coffee/robusta = list("coffeepowder" = 0, "hyperzine" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/tea/aspera = list("teapowder" = 0),
				/obj/item/weapon/reagent_containers/food/snacks/grown/tea/astra = list("teapowder" = 0, "kelotane" = 0),
		)

		var/list/holdingitems = list()

/obj/machinery/reagentgrinder/New()
		..()
		beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		return

/obj/machinery/reagentgrinder/update_icon()
		icon_state = "juicer"+num2text(!isnull(beaker))
		return


/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob, params)

		if(default_unfasten_wrench(user, O))
				return

		if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
				istype(O,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass) || \
				istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

				if (beaker)
						return 1
				else
						src.beaker =  O
						user.drop_item()
						O.loc = src
						update_icon()
						src.updateUsrDialog()
						return 0

		if(is_type_in_list(O, dried_items))
				if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
						var/obj/item/weapon/reagent_containers/food/snacks/grown/G = O
						if(!G.dry)
								user << "<span class='notice'>You must dry that first!</span>"
								return 1

		if(holdingitems && holdingitems.len >= limit)
				usr << "The machine cannot hold anymore items."
				return 1

		//Fill machine with the plantbag!
		if(istype(O, /obj/item/weapon/storage/bag/plants))

				for (var/obj/item/weapon/reagent_containers/food/snacks/grown/G in O.contents)
						O.contents -= G
						G.loc = src
						holdingitems += G
						if(holdingitems && holdingitems.len >= limit) //Sanity checking so the blender doesn't overfill
								user << "You fill the All-In-One grinder to the brim."
								break

				if(!O.contents.len)
						user << "You empty the plant bag into the All-In-One grinder."

				src.updateUsrDialog()
				return 0

		if (!is_type_in_list(O, blend_items) && !is_type_in_list(O, juice_items))
				user << "Cannot refine into a reagent."
				return 1

		user.unEquip(O)
		O.loc = src
		holdingitems += O
		src.updateUsrDialog()
		return 0

/obj/machinery/reagentgrinder/attack_paw(mob/user as mob)
		return src.attack_hand(user)

/obj/machinery/reagentgrinder/attack_ai(mob/user as mob)
		return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
		user.set_machine(src)
		interact(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu
		var/is_chamber_empty = 0
		var/is_beaker_ready = 0
		var/processing_chamber = ""
		var/beaker_contents = ""
		var/dat = ""

		if(!operating)
				for (var/obj/item/O in holdingitems)
						processing_chamber += "\A [O.name]<BR>"

				if (!processing_chamber)
						is_chamber_empty = 1
						processing_chamber = "Nothing."
				if (!beaker)
						beaker_contents = "<B>No beaker attached.</B><br>"
				else
						is_beaker_ready = 1
						beaker_contents = "<B>The beaker contains:</B><br>"
						var/anything = 0
						for(var/datum/reagent/R in beaker.reagents.reagent_list)
								anything = 1
								beaker_contents += "[R.volume] - [R.name]<br>"
						if(!anything)
								beaker_contents += "Nothing<br>"


				dat = {"
		<b>Processing chamber contains:</b><br>
		[processing_chamber]<br>
		[beaker_contents]<hr>
		"}
				if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
						dat += "<A href='?src=\ref[src];action=grind'>Grind the reagents</a><BR>"
						dat += "<A href='?src=\ref[src];action=juice'>Juice the reagents</a><BR><BR>"
				if(holdingitems && holdingitems.len > 0)
						dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
				if (beaker)
						dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
		else
				dat += "Please wait..."

		var/datum/browser/popup = new(user, "reagentgrinder", "All-In-One Grinder")
		popup.set_content(dat)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open(1)
		return

/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	if(operating)
		updateUsrDialog()
		return
	switch(href_list["action"])
		if ("grind")
			grind()
		if("juice")
			juice()
		if("eject")
			eject()
		if ("detach")
			detach()

/obj/machinery/reagentgrinder/proc/detach()

		if (usr.stat != 0)
				return
		if (!beaker)
				return
		beaker.loc = src.loc
		beaker = null
		update_icon()
		updateUsrDialog()

/obj/machinery/reagentgrinder/proc/eject()

		if (usr.stat != 0)
				return
		if (holdingitems && holdingitems.len == 0)
				return

		for(var/obj/item/O in holdingitems)
				O.loc = src.loc
				holdingitems -= O
		holdingitems = list()
		updateUsrDialog()

/obj/machinery/reagentgrinder/proc/is_allowed(var/obj/item/weapon/reagent_containers/O)
		for (var/i in blend_items)
				if(istype(O, i))
						return 1
		return 0

/obj/machinery/reagentgrinder/proc/get_allowed_by_id(var/obj/item/O)
		for (var/i in blend_items)
				if (istype(O, i))
						return blend_items[i]

/obj/machinery/reagentgrinder/proc/get_allowed_snack_by_id(var/obj/item/weapon/reagent_containers/food/snacks/O)
		for(var/i in blend_items)
				if(istype(O, i))
						return blend_items[i]

/obj/machinery/reagentgrinder/proc/get_allowed_juice_by_id(var/obj/item/weapon/reagent_containers/food/snacks/O)
		for(var/i in juice_items)
				if(istype(O, i))
						return juice_items[i]

/obj/machinery/reagentgrinder/proc/get_grownweapon_amount(var/obj/item/weapon/grown/O)
		if (!istype(O))
				return 5
		else if (O.potency == -1)
				return 5
		else
				return round(O.potency)

/obj/machinery/reagentgrinder/proc/get_juice_amount(var/obj/item/weapon/reagent_containers/food/snacks/grown/O)
		if (!istype(O))
				return 5
		else if (O.potency == -1)
				return 5
		else
				return round(5*sqrt(O.potency))

/obj/machinery/reagentgrinder/proc/remove_object(var/obj/item/O)
		holdingitems -= O
		qdel(O)

/obj/machinery/reagentgrinder/proc/juice()
		power_change()
		if(stat & (NOPOWER|BROKEN))
				return
		if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
				return
		playsound(src.loc, 'sound/machines/juicer.ogg', 20, 1)
		var/offset = prob(50) ? -2 : 2
		animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 250) //start shaking
		operating = 1
		updateUsrDialog()
		spawn(50)
				pixel_x = initial(pixel_x) //return to its spot after shaking
				operating = 0
				updateUsrDialog()

		//Snacks
		for (var/obj/item/weapon/reagent_containers/food/snacks/O in holdingitems)
				if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						break

				var/allowed = get_allowed_juice_by_id(O)
				if(isnull(allowed))
						break

				for (var/r_id in allowed)

						var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
						var/amount = get_juice_amount(O)

						beaker.reagents.add_reagent(r_id, min(amount, space))

						if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
								break

				remove_object(O)

/obj/machinery/reagentgrinder/proc/grind()

		power_change()
		if(stat & (NOPOWER|BROKEN))
				return
		if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
				return
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		var/offset = prob(50) ? -2 : 2
		animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 250) //start shaking
		operating = 1
		updateUsrDialog()
		spawn(60)
				pixel_x = initial(pixel_x) //return to its spot after shaking
				operating = 0
				updateUsrDialog()

		//Snacks and Plants
		for (var/obj/item/weapon/reagent_containers/food/snacks/O in holdingitems)
				if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						break

				var/allowed = get_allowed_snack_by_id(O)
				if(isnull(allowed))
						break

				for (var/r_id in allowed)

						var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
						var/amount = allowed[r_id]
						if(amount <= 0)
								if(amount == 0)
										if (O.reagents != null && O.reagents.has_reagent("nutriment"))
												beaker.reagents.add_reagent(r_id, min(O.reagents.get_reagent_amount("nutriment"), space))
												O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))
								else
										if (O.reagents != null && O.reagents.has_reagent("nutriment"))
												beaker.reagents.add_reagent(r_id, min(round(O.reagents.get_reagent_amount("nutriment")*abs(amount)), space))
												O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))

						else
								O.reagents.trans_id_to(beaker, r_id, min(amount, space))

						if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
								break

				if(O.reagents.reagent_list.len == 0)
						remove_object(O)

		//Sheets
		for (var/obj/item/stack/sheet/O in holdingitems)
				var/allowed = get_allowed_by_id(O)
				if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						break
				for(var/i = 1; i <= round(O.amount, 1); i++)
						for (var/r_id in allowed)
								var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
								var/amount = allowed[r_id]
								beaker.reagents.add_reagent(r_id,min(amount, space))
								if (space < amount)
										break
						if (i == round(O.amount, 1))
								remove_object(O)
								break
		//Plants
		for (var/obj/item/weapon/grown/O in holdingitems)
				if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						break
				var/allowed = get_allowed_by_id(O)
				for (var/r_id in allowed)
						var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
						var/amount = allowed[r_id]
						if (amount == 0)
								if (O.reagents != null && O.reagents.has_reagent(r_id))
										beaker.reagents.add_reagent(r_id,min(O.reagents.get_reagent_amount(r_id), space))
						else
								beaker.reagents.add_reagent(r_id,min(amount, space))

						if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
								break
				remove_object(O)


		//Crayons
		//With some input from aranclanos, now 30% less shoddily copypasta
		for (var/obj/item/toy/crayon/O in holdingitems)
				if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						break
				var/allowed = get_allowed_by_id(O)
				for (var/r_id in allowed)
						var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
						var/amount = allowed[r_id]
						beaker.reagents.add_reagent(r_id,min(amount, space))
						if (space < amount)
								break
						remove_object(O)

		//Everything else - Transfers reagents from it into beaker
		for (var/obj/item/O in holdingitems)
				if(!O.reagents)
						continue
				if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
						break
				var/amount = O.reagents.total_volume
				O.reagents.trans_to(beaker, amount)
				if(!O.reagents.total_volume)
						remove_object(O)

/////////////////////
/obj/machinery/chem_dispenser/drinks
	name = "soda dispenser"
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "soda_dispenser"
	energy = 100
	max_energy = 100
	amount = 30
	recharge_delay = 5
	uiname = "Soda Dispenser"
	l_color = "#0000FF"
	dispensable_reagents = list("water","ice","coffee","cream","tea","icetea","cola","spacemountainwind","dr_gibb","space_up","tonic","sodawater","lemon_lime","sugar","orangejuice","limejuice","tomatojuice")
/obj/machinery/chem_dispenser/drinks/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
		if(default_unfasten_wrench(user, O))
				return
		if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
				istype(O,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass) || \
				istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))
				if (beaker)
						return 1
				else
						src.beaker =  O
						user.drop_item()
						O.loc = src
						update_icon()
						src.updateUsrDialog()
						return 0

/obj/machinery/chem_dispenser/drinks/beer
	name = "booze dispenser"
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "booze_dispenser"
	uiname = "Booze Dispenser"
	dispensable_reagents = list("lemon_lime","sugar","orangejuice","limejuice","sodawater","tonic","beer","kahlua","whiskey","wine","vodka","gin","rum","tequilla","vermouth","cognac","ale")

