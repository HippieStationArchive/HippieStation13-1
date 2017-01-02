/obj/mecha/working/ripley
	desc = "Autonomous Power Loader Unit. This newer model is refitted with powerful armour against the dangers of the EVA mining process."
	name = "\improper APLU \"Ripley\""
	icon_state = "ripley"
	step_in = 5
	max_temperature = 20000
	health = 200
	lights_power = 7
	deflect_chance = 15
	damage_absorption = list("brute"=0.6,"fire"=1,"bullet"=0.8,"laser"=0.9,"energy"=1,"bomb"=0.6)
	max_equip = 6
	wreckage = /obj/structure/mecha_wreckage/ripley
	var/list/cargo = new
	var/cargo_capacity = 15
	var/hides = 0

/obj/mecha/working/ripley/Move()
	. = ..()
	if(. && (locate(/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp) in equipment))
		var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in cargo
		if(ore_box)
			for(var/obj/item/weapon/ore/ore in get_turf(src))
				ore.Move(ore_box)
	update_pressure()

/obj/mecha/working/ripley/Destroy()
	for(var/i=1, i <= hides, i++)
		new /obj/item/asteroid/goliath_hide(loc) //If a goliath-plated ripley gets killed, all the plates drop
	damage_absorption["brute"] =  initial(damage_absorption["brute"])
	for(var/atom/movable/A in cargo)
		A.loc = loc
		step_rand(A)
	cargo.Cut()
	return ..()

/obj/mecha/working/ripley/go_out()
	..()
	update_icon()

/obj/mecha/working/ripley/moved_inside(mob/living/carbon/human/H)
	..()
	update_icon()

/obj/mecha/working/ripley/mmi_moved_inside(obj/item/device/mmi/mmi_as_oc,mob/user)
	..()
	update_icon()

/obj/mecha/working/ripley/update_icon()
	..()
	if (hides)
		overlays = null
		if(hides < 3)
			overlays += image("icon" = "mecha.dmi", "icon_state" = occupant ? "ripley-g" : "ripley-g-open")
		else
			overlays += image("icon" = "mecha.dmi", "icon_state" = occupant ? "ripley-g-full" : "ripley-g-full-open")


/obj/mecha/working/ripley/firefighter
	desc = "Autonomous Power Loader Unit. This model is refitted with additional thermal protection."
	name = "\improper APLU \"Firefighter\""
	icon_state = "firefighter"
	max_temperature = 65000
	health = 250
	lights_power = 7
	deflect_chance = 30
	damage_absorption = list("brute"=0.4,"fire"=0.1,"bullet"=0.5,"laser"=0.5,"energy"=0.5,"bomb"=0.1)
	max_equip = 5 // More armor, less tools
	wreckage = /obj/structure/mecha_wreckage/ripley/firefighter

/obj/mecha/working/ripley/ripleyussr
	desc = "Autonomous Power Loader Unit. This model is insigned with communist symbols."
	icon_state = "ripleyussr"
	wreckage = /obj/structure/mecha_wreckage/ripley/ripleyussr

/obj/mecha/working/ripley/deathripley
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	name = "\improper DEATH-RIPLEY"
	icon_state = "deathripley"
	step_in = 3
	opacity=0
	lights_power = 7
	wreckage = /obj/structure/mecha_wreckage/ripley/deathripley
	step_energy_drain = 0

/obj/mecha/working/ripley/deathripley/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/kill
	ME.attach(src)
	return

/obj/mecha/working/ripley/mining
	desc = "An old, dusty mining Ripley."
	name = "\improper APLU \"Miner\""

/obj/mecha/working/ripley/mining/New()
	..()
	//Attach drill
	if(prob(25)) //Possible diamond drill... Feeling lucky?
		var/obj/item/mecha_parts/mecha_equipment/drill/diamonddrill/D = new /obj/item/mecha_parts/mecha_equipment/drill/diamonddrill
		D.attach(src)
	else
		var/obj/item/mecha_parts/mecha_equipment/drill/D = new /obj/item/mecha_parts/mecha_equipment/drill
		D.attach(src)

	//Add possible plasma cutter
	if(prob(25))
		var/obj/item/mecha_parts/mecha_equipment/M = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma
		M.attach(src)

	//Add ore box to cargo
	cargo.Add(new /obj/structure/ore_box(src))

	//Attach hydraulic clamp
	var/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/HC = new /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp
	HC.attach(src)
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)//Deletes the beacon so it can't be found easily
		qdel(B)

	var/obj/item/mecha_parts/mecha_equipment/mining_scanner/scanner = new /obj/item/mecha_parts/mecha_equipment/mining_scanner
	scanner.attach(src)

/obj/mecha/working/ripley/firefighter/mining
	desc = "A brand, spanking new mining Firefighter."
	name = "\improper APLU \"Miner\""

/obj/mecha/working/ripley/firefighter/mining/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/drill/D = new /obj/item/mecha_parts/mecha_equipment/drill
	D.attach(src)

	cargo.Add(new /obj/structure/ore_box(src))

	var/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/HC = new /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp
	HC.attach(src)
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)//Deletes the beacon so it can't be found easily
		qdel(B)

	var/obj/item/mecha_parts/mecha_equipment/mining_scanner/scanner = new /obj/item/mecha_parts/mecha_equipment/mining_scanner
	scanner.attach(src)

/obj/mecha/working/ripley/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()

/obj/mecha/working/ripley/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && O in src.cargo)
			src.occupant_message("<span class='notice'>You unload [O].</span>")
			O.loc = loc
			src.cargo -= O
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return



/obj/mecha/working/ripley/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(cargo.len)
		for(var/obj/O in cargo)
			output += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/working/ripley/proc/update_pressure()
	var/turf/T = get_turf(loc)
	var/datum/gas_mixture/environment = T.return_air()
	var/pressure = environment.return_pressure()

	if(pressure < 20)
		step_in = 2
		for(var/obj/item/mecha_parts/mecha_equipment/drill/drill in equipment)
			drill.equip_cooldown = initial(drill.equip_cooldown)/2
	else
		step_in = 5
		for(var/obj/item/mecha_parts/mecha_equipment/drill/drill in equipment)
			drill.equip_cooldown = initial(drill.equip_cooldown)
