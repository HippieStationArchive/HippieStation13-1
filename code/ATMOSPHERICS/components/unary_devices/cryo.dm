/obj/machinery/atmospherics/components/unary/cryo_cell
	name = "cryo cell"
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "cell-off"
	density = 1
	anchored = 1
	layer = 4

	var/on = 0
	var/temperature_archived
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/next_trans = 0
	var/current_heat_capacity = 50
	state_open = 0
	var/efficiency
	var/autoEject = 0

/obj/machinery/atmospherics/components/unary/cryo_cell/New()
	..()
	initialize_directions = dir
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/cryo_tube(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)


/obj/machinery/atmospherics/components/unary/cryo_cell/construction()
	..(dir,dir)

/obj/machinery/atmospherics/components/unary/cryo_cell/RefreshParts()
	var/C
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		C += M.rating
	current_heat_capacity = 50 * C
	efficiency = C

/obj/machinery/atmospherics/components/unary/cryo_cell/Destroy()
	var/turf/T = loc
	T.contents += contents

	if(beaker)
		beaker.loc = get_step(loc, SOUTH) //Beaker is carefully fed from the wreckage of the cryotube
	beaker = null
	return ..()
/obj/machinery/atmospherics/components/unary/cryo_cell/process_atmos()
	..()
	var/datum/gas_mixture/air_contents = AIR1

	if(air_contents)
		temperature_archived = air_contents.temperature
		heat_gas_contents()
	if(abs(temperature_archived-air_contents.temperature) > 1)
		update_parents()

/obj/machinery/atmospherics/components/unary/cryo_cell/process()
	..()
	if(occupant)
		if(occupant.health >= 100)
			on = 0
			open_machine()
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	if(!NODE1 || !is_operational())
		return

	if(AIR1)
		if (occupant)
			process_occupant()
		expel_gas()

	return 1

/obj/machinery/atmospherics/components/unary/cryo_cell/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user) || !iscarbon(target) || user.buckled)
		return
	close_machine(target)

/obj/machinery/atmospherics/components/unary/cryo_cell/relaymove(mob/user)	open_machine()

/obj/machinery/atmospherics/components/unary/cryo_cell/container_resist()
	open_machine()
	return

/obj/machinery/atmospherics/components/unary/cryo_cell/verb/move_eject()
	set name = "Eject Cryo Cell"
	set desc = "Begin the release sequence inside the cryo tube."
	set category = "Object"
	set src in oview(1)
	if(usr == occupant || contents.Find(usr))	//If the user is inside the tube...
		if(usr.stat == DEAD)	//and he's not dead....
			return
		usr << "<span class='notice'>Release sequence activated. This will take about a minute.</span>"
		sleep(600)
		if(!src || !usr || (!occupant && !contents.Find(usr)))	//Check if someone's released/replaced/bombed him already
			return
		open_machine()
		add_fingerprint(usr)
	else
		if(!istype(usr, /mob/living) || usr.stat)
			usr << "<span class='warning'>You can't do that!</span>"
			return
		open_machine()

/obj/machinery/atmospherics/components/unary/cryo_cell/examine(mob/user)
	..()

	var/list/otherstuff = contents - beaker
	if(otherstuff.len > 0)
		user << "You can just about make out some loose objects floating in the murk:"
		for(var/atom/movable/floater in otherstuff)
			user << "\icon[floater] [floater.name]"
	else
		user << "Seems empty."

/obj/machinery/atmospherics/components/unary/cryo_cell/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
																		datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cryo", name, 400, 550, master_ui, state)
		ui.open()

/obj/machinery/atmospherics/components/unary/cryo_cell/get_ui_data()
	// this is the data which will be sent to the ui
	var/datum/gas_mixture/air_contents = AIR1

	var/data = list()
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? 1 : 0

	var/occupantData = list()
	if (!occupant)
		occupantData["name"] = null
		occupantData["stat"] = null
		occupantData["health"] = null
		occupantData["maxHealth"] = null
		occupantData["minHealth"] = null
		occupantData["bruteLoss"] = null
		occupantData["oxyLoss"] = null
		occupantData["toxLoss"] = null
		occupantData["fireLoss"] = null
		occupantData["bodyTemperature"] = null
	else
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.maxHealth
		occupantData["minHealth"] = config.health_threshold_dead
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["bodyTemperature"] = occupant.bodytemperature
	data["occupant"] = occupantData

	data["isOpen"] = state_open
	data["cellTemperature"] = round(air_contents.temperature)

	data["isBeakerLoaded"] = beaker ? 1 : 0
	var beakerContents[0]
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/atmospherics/components/unary/cryo_cell/ui_act(action, params)
	switch(action)
		if("power")
			if(on)
				on = FALSE
			else if(!state_open)
				on = TRUE
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
		if("autoeject")
			autoEject = !autoEject
		if("ejectbeaker")
			if(beaker)
				beaker.loc = get_step(loc, SOUTH)
				beaker = null
	update_icon()
	return 1

/obj/machinery/atmospherics/components/unary/cryo_cell/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(isrobot(user))
			return
		if(beaker)
			user << "<span class='warning'>A beaker is already loaded into [src]!</span>"
			return
		if(!user.drop_item())
			return

		beaker = I
		I.loc = src
		user.visible_message("[user] places [I] in [src].", \
							"<span class='notice'>You place [I] in [src].</span>")

	if(!(on || occupant || state_open))
		if(default_deconstruction_screwdriver(user, "cell-o", "cell-off", I))
			return

	if(default_change_direction_wrench(user, I))
		return

	if(exchange_parts(user, I))
		return

	if(default_pry_open(I))
		return

	default_deconstruction_crowbar(I)

/obj/machinery/atmospherics/components/unary/cryo_cell/open_machine()
	if(!state_open && !panel_open)
		on = 0
		layer = 3
		if(occupant)
			occupant.bodytemperature = Clamp(occupant.bodytemperature, 261, 360)
		..()
		if(beaker)
			beaker.loc = src

/obj/machinery/atmospherics/components/unary/cryo_cell/close_machine(mob/living/carbon/M)
	if(state_open && !panel_open)
		layer = 4
		..(M)
		return occupant

/obj/machinery/atmospherics/components/unary/cryo_cell/update_icon()
	if(panel_open)
		icon_state = "cell-o"
		return
	if(state_open)
		icon_state = "cell-open"
		return
	if(on && is_operational())
		if(occupant)
			icon_state = "cell-occupied"
		else
			icon_state = "cell-on"
	else
		icon_state = "cell-off"

/obj/machinery/atmospherics/components/unary/cryo_cell/power_change()
	..()
	update_icon()

/obj/machinery/atmospherics/components/unary/cryo_cell/proc/process_occupant()
	var/datum/gas_mixture/air_contents = AIR1
	if(air_contents.total_moles() < 10)
		return
	if(occupant)
		if(occupant.stat == 2 || occupant.health >= 100)  //Why waste energy on dead or healthy people
			occupant.bodytemperature = T0C
			return
		occupant.bodytemperature += 2*(air_contents.temperature - occupant.bodytemperature) * current_heat_capacity / (current_heat_capacity + air_contents.heat_capacity())
		occupant.bodytemperature = max(occupant.bodytemperature, air_contents.temperature) // this is so ugly i'm sorry for doing it i'll fix it later i promise //TODO: fix someone else's broken promise - duncathan
		if(occupant.bodytemperature < T0C)
//			occupant.sleeping = max(5/efficiency, (1 / occupant.bodytemperature)*2000/efficiency)
//			occupant.Paralyse(max(5/efficiency, (1 / occupant.bodytemperature)*3000/efficiency))
			if(air_contents.gases["o2"] && air_contents.gases["o2"][MOLES] > 2)
				if(occupant.getOxyLoss()) occupant.adjustOxyLoss(-1)
			else
				occupant.adjustOxyLoss(-1)
			//severe damage should heal waaay slower without proper chemicals
			if(occupant.bodytemperature < 225)
				if(occupant.getToxLoss())
					occupant.adjustToxLoss(max(-efficiency, (-20*(efficiency ** 2)) / occupant.getToxLoss()))
				var/heal_brute = occupant.getBruteLoss() ? min(efficiency, 20*(efficiency**2) / occupant.getBruteLoss()) : 0
				var/heal_fire = occupant.getFireLoss() ? min(efficiency, 20*(efficiency**2) / occupant.getFireLoss()) : 0
				occupant.heal_organ_damage(heal_brute,heal_fire)
		if(beaker && next_trans == 0)
			beaker.reagents.trans_to(occupant, 1, 10)
			beaker.reagents.reaction(occupant, VAPOR)
	next_trans++
	if(next_trans == 10)
		next_trans = 0


/obj/machinery/atmospherics/components/unary/cryo_cell/proc/heat_gas_contents()
	var/datum/gas_mixture/air_contents = AIR1

	if(air_contents.total_moles() < 1)
		return
	var/air_heat_capacity = air_contents.heat_capacity()
	var/combined_heat_capacity = current_heat_capacity + air_heat_capacity
	if(combined_heat_capacity > 0)
		var/combined_energy = T20C * current_heat_capacity + air_heat_capacity * air_contents.temperature
		air_contents.temperature = combined_energy/combined_heat_capacity

/obj/machinery/atmospherics/components/unary/cryo_cell/proc/expel_gas()
	var/datum/gas_mixture/air_contents = AIR1

	if(air_contents.total_moles() < 1)
		return
	var/datum/gas_mixture/expel_gas = new
	var/remove_amount = air_contents.total_moles() / 100
	expel_gas = air_contents.remove(remove_amount)
	expel_gas.temperature = T20C	//Lets expel hot gas and see if that helps people not die as they are removed
	loc.assume_air(expel_gas)
	air_update_turf()