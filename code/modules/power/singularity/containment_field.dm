//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/field/containment
	name = "Containment Field"
	desc = "An energy field."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "Contain_F"
	anchored = 1
	density = 0
	unacidable = 1
	use_power = 0
	luminosity = 4
	layer = OBJ_LAYER + 0.1
	var/obj/machinery/field/generator/FG1 = null
	var/obj/machinery/field/generator/FG2 = null

/obj/machinery/field/containment/Destroy()
	if(FG1 && !FG1.clean_up)
		FG1.cleanup()
	if(FG2 && !FG2.clean_up)
		FG2.cleanup()
	return ..()

/obj/machinery/field/containment/attack_hand(mob/user)
	if(get_dist(src, user) > 1)
		return 0
	else
		shock(user)
		return 1


/obj/machinery/field/containment/blob_act()
	return 0


/obj/machinery/field/containment/ex_act(severity, target)
	return 0


/obj/machinery/field/containment/Crossed(mob/mover)
	if(isliving(mover))
		shock(mover)

/obj/machinery/field/containment/Crossed(obj/mover)
	if(istype(mover, /obj/machinery) || istype(mover, /obj/structure) || istype(mover, /obj/mecha))
		bump_field(mover)

/obj/machinery/field/containment/proc/set_master(master1,master2)
	if(!master1 || !master2)
		return 0
	FG1 = master1
	FG2 = master2
	return 1

/obj/machinery/field/containment/shock(mob/living/user)
	if(!FG1 || !FG2)
		qdel(src)
		return 0
	..()

/obj/machinery/field/containment/Move()
	qdel(src)

// Abstract Field Class
// Used for overriding certain procs

/obj/machinery/field
	var/hasShocked = 0 //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.
	var/bumps = 0 // to prevent a lag exploit
	var/list/recently_bumped = list() //so that a large pile of shit being thrown at the field doesn't trigger the failsafe.

/obj/machinery/field/CanPass(mob/mover, turf/target, height=0)
	if(isliving(mover)) // Don't let mobs through
		shock(mover)
		return 0
	return ..()

/obj/machinery/field/CanPass(obj/mover, turf/target, height=0)
	if((istype(mover, /obj/machinery) && !istype(mover, /obj/singularity)) || \
		istype(mover, /obj/structure) || \
		istype(mover, /obj/mecha))
		bump_field(mover)
		return 0
	return ..()

/obj/machinery/field/proc/shock(mob/living/user)
	if(hasShocked)
		return 0
	if(isliving(user))
		hasShocked = 1
		var/shock_damage = min(rand(30,40),rand(30,40))

		if(iscarbon(user))
			var/stun = min(shock_damage, 15)
			user.Stun(stun)
			user.Weaken(10)
			user.burn_skin(shock_damage)
			user.visible_message("<span class='danger'>[user.name] was shocked by the [src.name]!</span>", \
			"<span class='userdanger'>You feel a powerful shock course through your body, sending you flying!</span>", \
			"<span class='italics'>You hear a heavy electrical crack.</span>")

		else if(issilicon(user))
			if(prob(20))
				user.Stun(2)
			user.take_overall_damage(0, shock_damage)
			user.visible_message("<span class='danger'>[user.name] was shocked by the [src.name]!</span>", \
			"<span class='userdanger'>Energy pulse detected, system damaged!</span>", \
			"<span class='italics'>You hear an electrical crack.</span>")

		user.updatehealth()
		bump_field(user)

		spawn(5)
			hasShocked = 0
	return

/obj/machinery/field/proc/bump_field(atom/movable/AM as mob|obj)
	if(AM in recently_bumped)
		if(bumps <= 9)
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(5, 1, AM.loc)
			s.start()
			var/atom/target = get_edge_target_turf(AM, get_dir(src, get_step_away(AM, src)))
			AM.throw_at(target, 200, 4)
			bumps++
			spawn(10)
				bumps -= 1
		else if(bumps == 10)
			AM.density = 0
			AM.anchored = 1
			message_admins("[AM] has bumped the containment field too often at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> and triggered the failsafe, anchoring it in place and removing it's density. Last touched by [key_name_admin(fingerprintslast)]")
			log_game("[AM] has bumped the containment field too often at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> and triggered the failsafe, anchoring it in place and removing it's density. Last touched by [key_name_admin(fingerprintslast)]")
		else if(bumps >= 20)
			message_admins("[AM] has bumped the containment field too often at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> and triggered the second failsafe, deleting it. Last touched by [key_name_admin(fingerprintslast)]")
			log_game("[AM] has bumped the containment field too often at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> and triggered the second failsafe, deleting it. Last touched by [key_name_admin(fingerprintslast)]")
			qdel(AM)
	else
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, AM.loc)
		s.start()
		var/atom/target = get_edge_target_turf(AM, get_dir(src, get_step_away(AM, src)))
		AM.throw_at(target, 200, 4)
		recently_bumped.Add(AM)
		spawn(100)
			recently_bumped.Remove(AM)
