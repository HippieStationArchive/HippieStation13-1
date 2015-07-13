#define MAX_TAPE_RANGE 3
//The max length of a line of hazard tape by tile range

//Define all tape types in hazardtape.dm
/obj/item/tapeproj
	icon = 'icons/obj/holotape.dmi'
	icon_state = ""
	w_class = 2.0
	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/holotape
	var/icon_base
	var/charging = 0
	var/emagged = 0

/obj/item/tapeproj/emag_act(mob/user as mob)
	if(!emagged)
		src.emagged = 1
		src.req_access = null
		user << "<span class='warning'>You emag [src], disabling it's access requirement.</span>"
		return

/obj/item/holotape
	icon = 'icons/obj/holotape.dmi'
	anchored = 1
	density = 1
	layer = 5
	var/icon_base
	var/health = 10

// /obj/item/holotape/emag_act(mob/user as mob)
// 	if(!emagged)
// 		src.emagged = 1
// 		src.req_access = null
// 		user << "<span class='warning'>You emag [src], disabling it's access requirement</span>"
// 		return

/obj/item/tapeproj/security
	name = "security holotape projector"
	desc = "A security hard-light holotape projector used to create holotape. It can be placed in segments along hallways or on airlocks to signify crime scenes."
	icon_state = "security_start"
	tape_type = /obj/item/holotape/security
	icon_base = "security"
	req_access = list(access_sec_doors)

/obj/item/holotape/security
	name = "security holotape"
	desc = "A length of security hard-light holotape. It reads: SECURITY LINE | DO NOT CROSS."
	icon_base = "security"
	req_access = list(access_sec_doors) 

/obj/item/tapeproj/engineering
	name = "engineering holotape projector"
	desc = "An engineering hard-light holotape projector used to create holotape. It can be placed in segments along hallways or on airlocks to show hazardous areas."
	icon_state = "engineering_start"
	tape_type = /obj/item/holotape/engineering
	icon_base = "engineering"
	req_access = list(access_construction)

/obj/item/holotape/engineering
	name = "engineering holotape"
	desc = "A length of engineering hard-light holotape. It reads: HAZARD AHEAD // DO NOT CROSS."
	icon_base = "engineering"
	req_access = list(access_construction)

/obj/item/tapeproj/dropped()
	reset()

/obj/item/tapeproj/equipped()
	reset()

/obj/item/tapeproj/proc/reset()
	if(icon_state == "[icon_base]_stop")
		icon_state = "[icon_base]_start"
		start = null
		return

/obj/item/tapeproj/attack_self(var/mob/user)
	if(!src.allowed(user))
		user << "<span class='warning'>You do not have required access to use this!</span>"
		return
	if(charging)
		usr << "<span class='warning'>[src] is recharging!</span>"
		return
	if(icon_state == "[icon_base]_start")
		start = get_turf(src)
		usr << "<span class='notice'>You project the start of the [icon_base] holotape.</span>"
		icon_state = "[icon_base]_stop"
	else
		icon_state = "[icon_base]_start"
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			usr << "<span class='warning'>[src] can only be projected horizontally or vertically.</span>"
			return
		if(get_dist(start,end) >= MAX_TAPE_RANGE)
			usr << "<span class='warning'>Your holotape segment is too long! It must be [MAX_TAPE_RANGE] tiles long or shorter!</span>"
			return

		var/turf/cur = start
		var/dir
		if(start.x == end.x)
			var/d = end.y-start.y
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x,end.y+d,end.z))
			dir = "v"
		else
			var/d = end.x-start.x
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x+d,end.y,end.z))
			dir = "h"

		var/can_place = 1
		while (cur!=end && can_place)
			if(cur.density == 1)
				can_place = 0
			else if(istype(cur, /turf/space))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(!istype(O, /obj/item/holotape) && O.density)
						can_place = 0
						break
			cur = get_step_towards(cur,end)
		if(!can_place)
			usr << "<span class='warning'>You can't project the [icon_base] holotape through that!</span>"
			return

		cur = start
		var/tapetest = 0
		while (cur!=end)
			for(var/obj/item/holotape/Ptest in cur)
				if(Ptest.icon_state == "[Ptest.icon_base]_[dir]")
					tapetest = 1
			if(tapetest != 1)
				var/obj/item/holotape/P = new tape_type(cur)
				P.icon_state = "[P.icon_base]_[dir]"
			cur = get_step_towards(cur,end)

		usr << "<span class='notice'>You finish project the legnth of [icon_base] holotape.</span>"
		user.visible_message("<span class='warning'>[user] finishes projecting the length of [icon_base] holotape.</span>")

		charging = 1
		spawn(40)
			charging = 0

/obj/item/tapeproj/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!src.allowed(user))
		user << "<span class='warning'>You do not have required access to use this!</span>"
		return

	if(proximity_flag == 0) // not adjacent
		return

	if(istype(target, /obj/item/holotape))
		user << "<span class='warning'>You start removing [target].</span>"
		if(!do_mob(user, target, 20))
			return
		user.visible_message("<span class='warning'>[user] removes [target].</span>", \
							 "<span class='warning'>You remove [target].</span>" )
		var/obj/item/holotape/H = target
		H.breaktape()
		return
	if(charging)
		usr << "<span class='warning'>[src] is recharging!</span>"
		return

	if(istype(target, /obj/machinery/door/airlock) || istype(target, /obj/machinery/door/firedoor) || istype(target, /obj/structure/window))
		var/turf = get_turf(target)

		if(locate(tape_type) in turf) //Don't you dare stack tape
			usr << "<span class='warning'>There's already tape here!</span>"
			return

		if(istype(target, /obj/structure/window))
			var/obj/structure/window/W = target
			if(!(W.dir == 5) || !(W.fulltile == 1))
				return

		user << "<span class='notice'>You start projecting the [icon_base] holotape onto [target].</span>"

		if(!do_mob(user, target, 30))
			return

		var/atom/tape = new tape_type(turf)
		tape.icon_state = "[icon_base]_door"
		tape.layer = 5

		user << "<span class='notice'>You project the [icon_base] holotape onto [target].</span>"

		charging = 1
		spawn(40)
			charging = 0

/obj/item/holotape/Bumped(var/mob/living/carbon/C)
	if(C.m_intent == "walk" || C.lying || src.allowed(C))
		var/turf/T = get_turf(src)
		C.loc = T

/obj/item/holotape/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!density) return 1
	if(air_group || (height==0)) return 1

	if((mover.flags & PASSGLASS || istype(mover, /obj/effect/meteor) || mover.throwing == 1) )
		return 1
	else
		return 0

/obj/item/holotape/attack_hand(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1)
	user.visible_message("<span class='warning'>[user] hits [src].</span>", \
						 "<span class='warning'>You hit [src].</span>" )

	health -= rand(1,2)
	healthcheck()

/obj/item/holotape/proc/healthcheck()
	if(health <= 0)
		breaktape()

/obj/item/holotape/ex_act(severity, target)
	breaktape()

/obj/item/holotape/blob_act()
	breaktape()

/obj/item/holotape/attack_paw(mob/living/user)
	attack_hand(user)

/obj/item/holotape/bullet_act(var/obj/item/projectile/Proj)
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		health -= Proj.damage
	..()
	if(health <= 0)
		breaktape()
	return

/obj/item/holotape/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)
	health -= W.force * 0.3

	healthcheck()
	..()
	return

/obj/item/holotape/hitby(AM as mob|obj)
	..()
	var/tforce = 0
	if(ismob(AM))
		tforce = 5
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = max(0, I.throwforce * 0.5)
	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1)
	health = max(0, health - tforce)
	healthcheck()

/obj/item/holotape/proc/breaktape()
	var/dir[2]
	var/icon_dir = src.icon_state
	if(icon_dir == "[src.icon_base]_h")
		dir[1] = EAST
		dir[2] = WEST
	if(icon_dir == "[src.icon_base]_v")
		dir[1] = NORTH
		dir[2] = SOUTH

	for(var/i=1;i<3;i++)
		var/N = 0
		var/turf/cur = get_step(src,dir[i])
		while(N != 1)
			N = 1
			for (var/obj/item/holotape/P in cur)
				if(P.icon_state == icon_dir)
					N = 0
					del(P)
			cur = get_step(cur,dir[i])

	del(src)
	return

#undef MAX_TAPE_RANGE