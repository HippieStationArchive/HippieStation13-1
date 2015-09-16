/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "closed"
	density = 1
	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/opened = 0
	var/welded = 0
	var/locked = 0
	var/broken = 0
	var/large = 1
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/health = 100
	var/lastbang
	var/max_mob_size = 1 //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 3 // how many human sized mob/living can fit together inside a closet.
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.

/obj/structure/closet/initialize()
	..()
	if(!opened)		// if closed, any item at the crate's loc is put in the contents
		take_contents()

/obj/structure/closet/alter_health()
	return get_turf(src)

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0 || wall_mounted) return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if(src.welded)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src && !closet.wall_mounted)
			return 0
	return 1

/obj/structure/closet/proc/dump_contents()

	for(var/obj/O in src)
		O.loc = src.loc

	for(var/mob/M in src)
		M.loc = src.loc
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/take_contents()

	for(var/atom/movable/AM in src.loc)
		if(insert(AM) == -1) // limit reached
			break

/obj/structure/closet/proc/open()
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	src.dump_contents()

	src.icon_state = src.icon_opened
	src.opened = 1
	if(istype(src, /obj/structure/closet/body_bag))
		playsound(src.loc, 'sound/items/zip.ogg', 15, 1, -3)
	else
		playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	density = 0
	return 1

/obj/structure/closet/proc/insert(var/atom/movable/AM)

	if(contents.len >= storage_capacity)
		return -1

	var/obj/O = AM

	if(!istype(O) || !O.closet_exception)
		if(istype(AM, /mob/living))
			var/mob/living/L = AM
			if(L.buckled || L.mob_size > max_mob_size) //buckled mobs and mobs too big for the container don't get inside closets.
				return 0
			if(L.mob_size > 0)
				var/mobs_stored = 0
				for(var/mob/living/M in contents)
					mobs_stored++
					if(mobs_stored >= mob_storage_capacity)
						return 0
			if(L.client)
				L.client.perspective = EYE_PERSPECTIVE
				L.client.eye = src
		else if(!istype(AM, /obj/item) && !istype(AM, /obj/effect/dummy/chameleon)) //&& !AM.closet_exception)
			return 0
		else if(AM.density || AM.anchored)
			return 0
		else if(AM.flags & NODROP)
			return 0

	AM.loc = src
	return 1

/obj/structure/closet/proc/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	take_contents()

	src.icon_state = src.icon_closed
	src.opened = 0
	if(istype(src, /obj/structure/closet/body_bag))
		playsound(src.loc, 'sound/items/zip.ogg', 15, 1, -3)
	else
		playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	density = 1
	return 1

/obj/structure/closet/proc/toggle()
	if(src.opened)
		return src.close()
	return src.open()

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity, target)
	contents_explosion(severity, target)
	open()
	..()

/obj/structure/closet/bullet_act(var/obj/item/projectile/Proj)
	..()
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		health -= Proj.damage
		if(health <= 0)
			dump_contents()
			qdel(src)
	return

/obj/structure/closet/attack_animal(mob/living/simple_animal/user as mob)
	if(user.environment_smash)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[user] destroys \the [src].</span>")
		dump_contents()
		qdel(src)

/obj/structure/closet/blob_act()
	if(prob(75))
		dump_contents()
		qdel(src)


/obj/structure/closet/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(src.opened)
		if(istype(W, /obj/item/weapon/grab))
			if(src.large)
				var/obj/item/weapon/grab/G = W
				src.MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
				user.drop_item()
			else
				user << "<span class='notice'>The locker is too small to stuff [W] into!</span>"
			return
		if(istype(W,/obj/item/tk_grab))
			return 0

		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin cutting \the [src] apart...</span>"
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
				if(do_after(user,40,5,1))
					if( !src.opened || !istype(src, /obj/structure/closet) || !user || !WT || !WT.isOn() || !user.loc )
						return
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					new /obj/item/stack/sheet/metal(src.loc)
					visible_message("<span class='notice'>[user] has cut \the [src] apart with \the [WT].</span>", "You hear welding.")
					qdel(src)
			return

		if(isrobot(user))
			return

		if(user.drop_item())
			W.Move(loc)

	else if(istype(W, /obj/item/stack/packageWrap))
		return
	else if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			user << "<span class='notice'>You begin [welded ? "unwelding":"welding"] \the [src]...</span>"
			playsound(loc, 'sound/items/Welder2.ogg', 40, 1)
			if(do_after(user,40,5,1))
				if(src.opened || !istype(src, /obj/structure/closet) || !user || !WT || !WT.isOn() || !user.loc )
					return
				playsound(loc, 'sound/items/welder.ogg', 50, 1)
				welded = !welded
				user << "<span class='notice'>You [welded ? "welded [src] shut":"unwelded [src]"].</span>"
				update_icon()
				user.visible_message("<span class='warning'>[user.name] has [welded ? "welded [src] shut":"unwelded [src]"].</span>")
		return
	else if(!place(user, W))
		src.attack_hand(user)
	return

/obj/structure/closet/proc/place(var/mob/user, var/obj/item/I)
	return 0

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob, var/needs_opened = 1, var/show_message = 1, var/move_them = 1)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return 0
	if(!isturf(O.loc))
		return 0
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis || user.lying)
		return 0
	if((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1))
		return 0
	if(!istype(user.loc, /turf)) // are you in a container/closet/pod/etc? Will also check for null loc
		return 0
	if(needs_opened && !src.opened)
		return 0
	if(istype(O, /obj/structure/closet))
		return 0
	if(move_them)
		step_towards(O, src.loc)
	if(show_message && user != O)
		user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
	src.add_fingerprint(user)
	return 1

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(src.loc))
		return

	if(!src.open())
		user << "<span class='notice'>It won't budge!</span>"
		if(!lastbang)
			lastbang = 1
			for (var/mob/M in get_hearers_in_view(src, null))
				M.show_message("<FONT size=[max(0, 5 - get_dist(src, M))]>BANG, bang!</FONT>", 2)
			spawn(30)
				lastbang = 0


/obj/structure/closet/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/closet/attack_hand(mob/user as mob, toggle)
	src.add_fingerprint(user)

	if(!src.toggle())
		usr << "<span class='notice'>It won't budge!</span>"

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	src.add_fingerprint(user)

	if(!src.toggle())
		usr << "<span class='notice'>It won't budge!</span>"

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(iscarbon(usr) || issilicon(usr))
		src.attack_hand(usr, 1) //"toggle" var to make the verb actually detectable code-wise for coding exceptions
	else
		usr << "<span class='warning'>This mob type can't use this verb.</span>"

/obj/structure/closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays.Cut()
	if(!opened)
		icon_state = icon_closed
		if(welded)
			overlays += "welded"
	else
		icon_state = icon_opened

// Objects that try to exit a locker by stepping were doing so successfully,
// and due to an oversight in turf/Enter() were going through walls.  That
// should be independently resolved, but this is also an interesting twist.
/obj/structure/closet/Exit(atom/movable/AM)
	open()
	if(AM.loc == src) return 0
	return 1

/obj/structure/closet/container_resist()
	var/mob/living/user = usr
	var/breakout_time = 2 //2 minutes by default
	if(istype(user.loc, /obj/structure/closet/critter) && !welded)
		breakout_time = 0.75 //45 seconds if it's an unwelded critter crate

	if( opened || (!welded && !locked && !istype(src.loc, /obj/mecha)) )
		return  //Door's open, not locked or welded or inside a mech, no point in resisting.

	//okay, so the closet is either welded or locked... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user << "<span class='notice'>You lean on the back of [src] and start pushing the door open. (this will take about [breakout_time] minutes.)</span>"
	for(var/mob/O in viewers(src))
		O << "<span class='warning'>[src] begins to shake violently!</span>"
	if(do_after(user,(breakout_time*60*10))) //minutes * 60seconds * 10deciseconds
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || (!locked && !welded && !istype(src.loc, /obj/mecha)) )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting

		welded = 0 //applies to all lockers lockers
		locked = 0 //applies to critter crates and secure lockers only
		broken = 1 //applies to secure lockers only
		visible_message("<span class='danger'>[user] successfully broke out of [src]!</span>")
		user << "<span class='notice'>You successfully break out of [src]!</span>"
		if(istype( src.loc, /obj/structure/bigDelivery))
			var/obj/structure/bigDelivery/D = src.loc
			qdel(D)
		else if(istype( src.loc, /obj/mecha))
			src.loc = get_turf(src.loc)
		open()
	else
		user << "<span class='warning'>You fail to break out of [src]!</span>"
		
/obj/structure/closet/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(!opened)
		if(istype(W, /obj/item/weapon/rcs))
			var/obj/item/weapon/rcs/E = W
			if(E.rcharges == 0)
				user  << "<span class='notice'>The RCS is out of power, please wait for it to recharge.</span>"
				return
			else if(E.pad)
				E.rcharges = E.rcharges - 1
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				playsound(src.loc, 'sound/machines/defib_zap.ogg', 75, 1)

				src.loc = E.pad.loc
				playsound(E.pad, 'sound/machines/defib_zap.ogg', 75, 1)
				var/datum/effect/effect/system/spark_spread/s1 = new /datum/effect/effect/system/spark_spread
				s1.set_up(5, 1, E.pad)
				s1.start()
				return
			else
				user  << "<span class='notice'>The RCS has not been calibrated, please calibrate it against a cargo teleport pad.</span>"
				return
	..()
