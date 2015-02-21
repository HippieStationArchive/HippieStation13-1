//spacepod handle IT

/datum/spacepod/equipment
	var/obj/mecha/spacepod/my_atom
	var/obj/item/mecha_parts/spod_equipment/weaponry/weapon_system


/datum/spacepod/equipment/New(var/obj/mecha/spacepod/SP)
	..()
	if(istype(SP))
		my_atom = SP

/obj/item/mecha_parts/spod_equipment
	name = "mecha equipment"
	icon = 'icons/mecha/spod_equipment.dmi'
	icon_state = "sp_equip"
	force = 5
	origin_tech = "materials=2"
	var/equip_cooldown = 0
	var/equip_ready = 1
	var/energy_drain = 0
	var/obj/mecha/chassis = null
	var/range = MELEE //bitflags
	reliability = 1000
	var/salvageable = 1
	var/obj/mecha/spacepod/my_atom


/obj/item/mecha_parts/spod_equipment/proc/do_after_cooldown(target=1)
	sleep(equip_cooldown)
	set_ready_state(1)
	if(target && chassis)
		return 1
	return 0


/obj/item/mecha_parts/spod_equipment/New()
	..()
	return

/obj/item/mecha_parts/spod_equipment/proc/update_chassis_page()
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","eq_list",chassis.get_equipment_list())
		send_byjax(chassis.occupant,"exosuit.browser","equipment_menu",chassis.get_equipment_menu(),"dropdowns")
		return 1
	return

/obj/item/mecha_parts/spod_equipment/proc/update_equip_info()
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",get_equip_info())
		return 1
	return

/obj/item/mecha_parts/spod_equipment/proc/destroy()//missiles detonating, teleporter creating singularity?
	if(chassis)
		chassis.equipment -= src
		listclearnulls(chassis.equipment)
		if(chassis.selected == src)
			chassis.selected = null
		src.update_chassis_page()
		chassis.occupant_message("<span class='danger'>The [src] is destroyed!</span>")
		chassis.log_append_to_last("[src] is destroyed.",1)
		if(istype(src, /obj/item/mecha_parts/spod_equipment/weaponry))
			chassis.occupant << sound('sound/mecha/weapdestr.ogg',volume=50)
		else
			chassis.occupant << sound('sound/mecha/critdestr.ogg',volume=50)
	qdel(src)
	return

/obj/item/mecha_parts/spod_equipment/proc/critfail()
	if(chassis)
		log_message("Critical failure",1)
	return

/obj/item/mecha_parts/spod_equipment/proc/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]"

/obj/item/mecha_parts/spod_equipment/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED

/obj/item/mecha_parts/spod_equipment/proc/is_melee()
	return range&MELEE


/obj/item/mecha_parts/spod_equipment/proc/action_checks(atom/target)
	if(!target)
		return 0
	if(!chassis)
		return 0
	if(!equip_ready)
		return 0
	if(crit_fail)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	return 1

/obj/item/mecha_parts/spod_equipment/proc/action(atom/target)
	return

/obj/item/mecha_parts/spod_equipment/proc/can_attach(obj/mecha/spacepod/S as obj)
	if(istype(S))
		if(S.equipment.len<S.max_equip)
			return 1
	return 0

/obj/item/mecha_parts/spod_equipment/proc/attach(obj/mecha/spacepod/S as obj)
	S.equipment += src
	chassis = S
	src.loc = S
	S.log_message("[src] initialized.")
	if(!S.selected)
		S.selected = src
	src.update_chassis_page()
	return

/obj/item/mecha_parts/spod_equipment/proc/detach(atom/moveto=null)
	moveto = moveto || get_turf(chassis)
	if(src.Move(moveto))
		chassis.equipment -= src
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.log_message("[src] removed from equipment.")
		chassis = null
		set_ready_state(1)
	return


/obj/item/mecha_parts/spod_equipment/Topic(href,href_list)
	if(href_list["detach"])
		src.detach()
	return


/obj/item/mecha_parts/spod_equipment/proc/set_ready_state(state)
	equip_ready = state
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	return

/obj/item/mecha_parts/spod_equipment/proc/occupant_message(message)
	if(chassis)
		chassis.occupant_message("\icon[src] [message]")
	return

/obj/item/mecha_parts/spod_equipment/proc/log_message(message)
	if(chassis)
		chassis.log_message("<i>[src]:</i> [message]")
	return

/obj/item/mecha_parts/spod_equipment/weaponry/proc/fire_weapons()

	if(my_atom.next_firetime > world.time)
		usr << "<span class='warning'>Your weapons are recharging.</span>"
		return
	var/turf/firstloc
	var/turf/secondloc
	if(!my_atom.equipment_system || !my_atom.equipment_system.weapon_system)
		usr << "<span class='warning'>Missing equipment or weapons.</span>"
		my_atom.verbs -= text2path("[type]/proc/fire_weapons")
		return
	my_atom.cell.use(shot_cost)
	var/olddir
	for(var/i = 0; i < shots_per; i++)
		if(olddir != dir)
			switch(dir)
				if(NORTH)
					firstloc = get_step(src, NORTH)
					secondloc = get_step(firstloc,EAST)
				if(SOUTH)
					firstloc = get_turf(src)
					secondloc = get_step(firstloc,EAST)
				if(EAST)
					firstloc = get_turf(src)
					firstloc = get_step(firstloc, EAST)
					secondloc = get_step(firstloc,NORTH)
				if(WEST)
					firstloc = get_turf(src)
					secondloc = get_step(firstloc,NORTH)
		olddir = dir

		var/obj/item/projectile/projone = new projectile_type(firstloc)
		var/obj/item/projectile/projtwo = new projectile_type(secondloc)
		projone.starting = get_turf(src)
		projone.firer = usr
		projone.def_zone = "chest"
		projtwo.starting = get_turf(src)
		projtwo.firer = usr
		projtwo.def_zone = "chest"
		spawn()
			playsound(src, fire_sound, 50, 1)
			projone.fire(firstloc)
			projtwo.fire(secondloc)
		sleep(1)
	my_atom.next_firetime = world.time + fire_delay



//
//
//
//spacepod STUFF for the POD ONLY
//
//
//



/obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp
	name = "hydraulic clamp"
	desc = "Equipment for spacepods. Lifts objects and loads them into it's cargo bay."
	icon_state = "sp_clamp"
	equip_cooldown = 15
	energy_drain = 10
	var/dam_force = 30
	var/obj/mecha/spacepod/cargo_holder


/obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp/action(atom/target)
	if(!action_checks(target)) return
	if(!cargo_holder) return
	if(istype(target,/obj))
		var/obj/O = target
		if(!O.anchored)
			if(cargo_holder.cargo.len < cargo_holder.cargo_capacity)
				occupant_message("You lift [target] and start to load it into the cargo bay.")
				chassis.visible_message("[chassis] lifts [target] and starts to load it into the [chassis]'s cargo bay.")
				set_ready_state(0)
				chassis.use_power(energy_drain)
				O.anchored = 1
				var/T = chassis.loc
				if(do_after_cooldown(target))
					if(T == chassis.loc && src == chassis.selected)
						cargo_holder.cargo += O
						O.loc = chassis
						O.anchored = 0
						occupant_message("<span class='notice'>[target] successfully loaded.</span>")
						log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - cargo_holder.cargo.len]")
					else
						occupant_message("<span class='danger'>You must hold still while handling objects.</span>")
						O.anchored = initial(O.anchored)
			else
				occupant_message("<span class='danger'>Not enough room in cargo compartment.</span>")
		else
			occupant_message("<span class='danger'>[target] is firmly secured.</span>")

	else if(istype(target,/mob/living))
		var/mob/living/M = target
		if(M.stat>1) return
		if(chassis.occupant.a_intent == "harm")
			M.take_overall_damage(dam_force)
			M.adjustOxyLoss(round(dam_force/2))
			M.updatehealth()
			occupant_message("<span class='danger'>You squeeze [target] with [src.name]. Something cracks.</span>")
			chassis.visible_message("<span class='danger'>[chassis] squeezes [target].</span>")
			add_logs(chassis.occupant, M, "attacked", object="[name]", addition="(INTENT: [uppertext(chassis.occupant.a_intent)]) (DAMTYE: [uppertext(damtype)])")
		else
			step_away(M,chassis)
			occupant_message("You push [target] out of the way.")
			chassis.visible_message("[chassis] pushes [target] out of the way.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1


/obj/item/mecha_parts/spod_equipment/tool/drill
	name = "spacepod drill"
	desc = "Equipment for spacepods. "
	icon_state = "sp_drill"
	equip_cooldown = 30
	energy_drain = 10
	force = 0

/obj/item/mecha_parts/spod_equipment/tool/drill/action(atom/target)
	if(!action_checks(target)) return
	if(isobj(target))
		var/obj/target_obj = target
		if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)	return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='userdanger'>[chassis] starts to drill [target]</span>", "You hear the drill.")
	occupant_message("<span class='userdanger'>You start to drill [target]</span>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/simulated/wall/r_wall))
				occupant_message("<span class='danger'>[target] is too durable to drill through.</span>")
			else if(istype(target, /turf/simulated/mineral))
				for(var/turf/simulated/mineral/M in range(chassis,1))
					if(get_dir(chassis,M)&chassis.dir)
						M.gets_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/weapon/ore/ore in range(chassis,1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)
			else if(istype(target, /turf/simulated/floor/plating/asteroid))
				for(var/turf/simulated/floor/plating/asteroid/M in range(chassis,1))
					if(get_dir(chassis,M)&chassis.dir)
						M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/weapon/ore/ore in range(chassis,1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				if(isliving(target))
					drill_mob(target, chassis.occupant)
				else
					target.ex_act(2)
	return 1



/obj/item/mecha_parts/spod_equipment/tool/drill/proc/drill_mob(mob/living/target, mob/user, var/drill_damage=80)
	target.visible_message("<span class='danger'>[chassis] drills [target] with the [src].</span>\
						<span class='userdanger'>[chassis] drills [target] with the [src].</span>")
	add_logs(user, target, "attacked", object="[name]", addition="(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/limb/affecting = H.get_organ("chest")
		affecting.take_damage(drill_damage)
		H.update_damage_overlays(0)
	else
		target.take_organ_damage(drill_damage)
	target.Paralyse(10)
	target.updatehealth()

/obj/item/mecha_parts/spod_equipment/tool/drill/diamonddrill
	name = "diamond-tipped spacepod drill"
	desc = "Miner's law: the number of ores in a miner's pod doubles approximately every two drills."
	icon_state = "sp_diamond_drill"
	origin_tech = "materials=4;engineering=3"
	equip_cooldown = 20
	force = 0

/obj/item/mecha_parts/spod_equipment/tool/drill/diamonddrill/action(atom/target)
	if(!action_checks(target)) return
	if(isobj(target))
		var/obj/target_obj = target
		if(target_obj.unacidable)	return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='userdanger'>[chassis] starts to drill [target]</span>", "You hear the drill.")
	occupant_message("<span class='danger'>You start to drill [target]</span>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/simulated/wall/r_wall))
				if(do_after_cooldown(target))//To slow down how fast mechs can drill through the station
					log_message("Drilled through [target]")
					target.ex_act(3)
			else if(istype(target, /turf/simulated/mineral))
				for(var/turf/simulated/mineral/M in range(chassis,1))
					if(get_dir(chassis,M)&chassis.dir)
						M.gets_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/weapon/ore/ore in range(chassis,1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)
			else if(istype(target,/turf/simulated/floor/plating/asteroid))
				for(var/turf/simulated/floor/plating/asteroid/M in range(target,1))
					M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/weapon/ore/ore in range(target,1))
							ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				if(isliving(target))
					drill_mob(target, chassis.occupant, 120)
				else
					target.ex_act(2)
	return 1

/obj/item/mecha_parts/spod_equipment/tool/wormhole_generator
	name = "wormhole generator"
	desc = "A spacepod module that makes small quasi-stable wormholes, for easy travel across space."
	icon_state = "sp_engine"
	origin_tech = "bluespace=3"
	equip_cooldown = 50
	energy_drain = 300
	range = RANGED


/obj/item/mecha_parts/spod_equipment/tool/wormhole_generator/action(atom/target)
	if(!action_checks(target) || src.loc.z == 2) return
	var/list/theareas = list()
	for(var/area/AR in orange(100, chassis))
		if(AR in theareas) continue
		theareas += AR
	if(!theareas.len)
		return
	var/area/thearea = pick(theareas)
	var/list/L = list()
	var/turf/pos = get_turf(src)
	for(var/turf/T in get_area_turfs(thearea.type))
		if(!T.density && pos.z == T.z)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T
	if(!L.len)
		return
	var/turf/target_turf = pick(L)
	if(!target_turf)
		return
	chassis.use_power(energy_drain)
	set_ready_state(0)
	var/obj/effect/portal/P = new /obj/effect/portal(get_turf(target))
	P.target = target_turf
	P.creator = null
	P.icon = 'icons/obj/objects.dmi'
	P.icon_state = "anom"
	P.name = "wormhole"
	var/turf/T = get_turf(target)
	message_admins("[key_name(chassis.occupant, chassis.occupant.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[chassis.occupant]'>?</A>) used a Wormhole Generator in ([T.x],[T.y],[T.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)",0,1)
	log_game("[chassis.occupant.ckey]([chassis.occupant]) used a Wormhole Generator in ([T.x],[T.y],[T.z])")
	do_after_cooldown()
	src = null
	spawn(rand(150,300))
		qdel(P)
	return

//
//
// ENGINES
//
//


/obj/item/mecha_parts/spod_equipment/engine/basic
	name = "basic engine"
	desc = "Using directed ion bursts and cunning solar wind reflection technique, this device enables controlled spacepod flight."
	icon_state = "sp_engine"
	equip_cooldown = 5
	energy_drain = 50
	var/wait = 0
	var/datum/effect/effect/system/ion_trail_follow/iontrail


/obj/item/mecha_parts/spod_equipment/engine/basic/can_attach(obj/mecha/spacepod/S as obj)
	if(!(locate(src.type) in S.equipment) && !S.proc_res["dyndomove"])
		return ..()

/obj/item/mecha_parts/spod_equipment/engine/basic/detach()
	..()
	chassis.proc_res["dyndomove"] = null
	return

/obj/item/mecha_parts/spod_equipment/engine/basic/attach(obj/mecha/spacepod/S as obj)
	..()
	if(!iontrail)
		iontrail = new
	iontrail.set_up(chassis)
	return

/obj/item/mecha_parts/spod_equipment/engine/basic/proc/toggle()
	if(!chassis)
		return
	!equip_ready? turn_off() : turn_on()
	return equip_ready

/obj/item/mecha_parts/spod_equipment/engine/basic/proc/turn_on()
	set_ready_state(0)
	chassis.proc_res["dyndomove"] = src
	iontrail.start()
	occupant_message("Activated")
	log_message("Activated")

/obj/item/mecha_parts/spod_equipment/engine/basic/proc/turn_off()
	set_ready_state(1)
	chassis.proc_res["dyndomove"] = null
	iontrail.stop()
	occupant_message("Deactivated")
	log_message("Deactivated")

/obj/item/mecha_parts/spod_equipment/engine/basic/proc/dyndomove(direction)
	//if(!chassis.can_move)
		//return 0
	//if(!Process_Spacemove(direction))
		//return 0
	//if(!has_charge(step_energy_drain))
	//	return 0
	//var/move_result = 0
	//if(chassis.hasInternalDamage(MECHA_INT_CONTROL_LOST))
	//	move_result = chassis.mechsteprand()
	//else if(src.dir!=direction)
	//	move_result = chassis.mechturn(direction)
	//else
	//	move_result = chassis.mechstep(direction)
	//if(move_result)
		//chassis.can_move = 0
		//if(do_after(chassis.step_in))
			//chassis.can_move = 1
		//return 1
	//return 0
	return 1

/obj/item/mecha_parts/spod_equipment/engine/basic/action_checks()
	if(equip_ready || wait)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	if(crit_fail)
		return 0
	//if(chassis.check_for_support())
	//	return 0
	return 1

/obj/item/mecha_parts/spod_equipment/engine/basic/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] \[<a href=\"?src=\ref[src];toggle=1\">Toggle</a>\]"


/obj/item/mecha_parts/spod_equipment/engine/basic/Topic(href,href_list)
	..()
	if(href_list["toggle"])
		toggle()

/obj/item/mecha_parts/spod_equipment/engine/basic/do_after_cooldown()
	sleep(equip_cooldown)
	wait = 0
	return 1


//
//
// GUNS AND SHIT PEW PEW
//
//

/obj/item/mecha_parts/spod_equipment/weaponry
	name = "pod weapons"
	desc = "You shouldn't be seeing this"
	icon_state = "sp_equip"
	var/projectile_type
	var/shot_cost = 0
	var/shots_per = 1
	var/fire_sound
	var/fire_delay = 10

/obj/item/mecha_parts/spod_equipment/weaponry/taser
	name = "\improper taser system"
	desc = "A weak taser system for space pods, fires electrodes that shock upon impact."
	icon_state = "sp_taser"
	projectile_type = "/obj/item/projectile/energy/electrode"
	shot_cost = 10
	fire_sound = "sound/weapons/Taser.ogg"

/obj/item/mecha_parts/spod_equipment/weaponry/taser/action(atom/target)
	fire_weapons()

/obj/item/mecha_parts/spod_equipment/weaponry/taser/proc/fire_weapon_system()
	set category = "Exosuit Interface"
	set name = "Fire Taser System"
	set desc = "Fire ze tasers!"
	set src = usr.loc

	fire_weapons()

/obj/item/mecha_parts/spod_equipment/weaponry/taser/burst
	name = "\improper burst taser system"
	desc = "A weak taser system for space pods, this one fires 3 at a time."
	icon_state = "sp_taser"
	shot_cost = 20
	shots_per = 3

/obj/item/mecha_parts/spod_equipment/weaponry/taser/burst/action(atom/target)
	fire_weapons()

/obj/item/mecha_parts/spod_equipment/weaponry/laser
	name = "\improper laser system"
	desc = "A weak laser system for space pods, fires concentrated bursts of energy"
	icon_state = "sp_laser"
	projectile_type = "/obj/item/projectile/beam"
	shot_cost = 15
	fire_sound = 'sound/weapons/Laser.ogg'
	fire_delay = 25

/obj/item/mecha_parts/spod_equipment/weaponry/laser/action(atom/target)
	fire_weapons()

/obj/item/mecha_parts/spod_equipment/weaponry/laser/proc/fire_weapon_system()
	set category = "Exosuit Interface"
	set name = "Fire Laser System"
	set desc = "Fire ze lasers!"
	set src = usr.loc

	fire_weapons()