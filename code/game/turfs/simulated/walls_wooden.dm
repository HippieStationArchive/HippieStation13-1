/*
/obj/structure/woodenwall()
	if(istype(src,/turf/simulated/wall/vault)) //HACK!!!
		return
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls
	for(var/obj/structure/woodenwall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	var/turf/simulated/wall/wall = src
	wall.icon_state = "[wall.walltype][junction]"
	return

/obj/structure/woodenwall/proc/relativewall_neighbours()
	for(var/obj/structure/woodenwall/W in range(src,1))
		W.relativewall()
	return
*/

/obj/structure/barricade/wooden/wall/proc/relativewall()

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/obj/structure/barricade/wooden/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	icon_state = "[mineral][junction]"
	return


/obj/structure/barricade/wooden/wall/proc/relativewall_neighbours()
	for(var/obj/structure/barricade/wooden/wall/S in range(src,1))
		S.relativewall()
		S.update_icon()
	return

/obj/structure/barricade/wooden/wall/Del()

	loc = src.loc

	spawn(10)
		for(var/obj/structure/barricade/wooden/wall/W in range(loc,1))
			W.relativewall()
	relativewall_neighbours()
	..()
/*
/obj/structure/woodenwall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	icon_state = "[mineral]0"
	src.relativewall()
*/
/obj/structure/barricade/wooden/wall
	name = "wooden wall"
	desc = "One day, the botanist got wood."
	icon = 'icons/turf/walls/wooden_walls.dmi'
	icon_state = "wall"
	anchored = 1
	density = 1
	opacity = 1
	layer = FLY_LAYER
	var/mineral = "wood"
	health = 200.
	maxhealth = 200.0
	burntime = 40 //Wooden walls are thick, so they take longer to burn down
	var/temploc

obj/structure/barricade/wooden/wall/attackby(obj/item/O as obj, mob/user as mob)
	if (istype(O, /obj/item/stack/sheet/mineral/wood))
		if (src.health < src.maxhealth)
			user << "<span class='notice'>You begin to repair the wall.</span>"
			if(do_after(user,20))
				src.health = src.maxhealth
				O:use(1)
				user << "<span class='notice'>You repair the wall.</span>"
				return
		else
			return
		return
/*	if(istype(O, /obj/item/weapon/hatchet))
		if(src.health == src.maxhealth)
			user << "You begin to carve a hole for a window"
			if(do_after(user,10))
				user << "You have cut a frame for the window in the wooden wall"
				new /obj/structure/barricade/wooden/wall/windowless(get_turf(src))
				qdel(src)*/
	else
		src.health -= O.force
		user.changeNext_move(CLICK_CD_MELEE)
		if (src.health <= 0)
			visible_message("<B><span class='danger'>The wall is smashed apart!</span></B>")
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			temploc = src.loc
			spawn(10)
			for(var/obj/structure/barricade/wooden/wall/W in range(temploc,1))
				W.relativewall()
			relativewall_neighbours()
			del(src)
		..()

/obj/structure/barricade/wooden/wall/New()
	relativewall_neighbours()
	..()
/*
/obj/structure/barricade/wooden/wall/window
	name = "wooden window"
	desc = "A plain, but rather classy window in a wooden frame."
	icon = 'icons/turf/walls/wooden_walls.dmi'
	icon_state = "window"
	anchored = 1.0
	density = 1.0
	layer = FLY_LAYER
/obj/structure/barricade/wooden/wall/window/New()
	..()

/obj/structure/barricade/wooden/wall/window/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack/sheet/mineral/wood))
		if (src.health < src.maxhealth)
			visible_message("\red [user] begins to repair the [src]!")
			if(do_after(user,20))
				src.health = src.maxhealth
				W:use(1)
				visible_message("\red [user] repairs the [src]!")
				return
		else
			return
		return
	else
		src.health -= W.force
		if (src.health <= 0)
			visible_message("\red <B>The window is smashed apart!</B>")
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			del(src)
		..()

/obj/structure/barricade/wooden/wall/window/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("\red <B>The window is smashed apart!</B>")
			del(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				visible_message("\red <B>The window is smashed apart!</B>")
				new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				del(src)
			return

/obj/structure/barricade/wooden/wall/window/blob_act()
	src.health -= 25
	if (src.health <= 0)
		visible_message("\red <B>The blob eats through the window!</B>")
		del(src)
	return

/obj/structure/barricade/wooden/wall/windowless
	name = "wooden window frame"
	desc = "A wooden window frame with no glass in it. You can fit through rather easily."
	icon_state = "window_noglass"
	anchored = 1.0
	density = 0
	layer = FLY_LAYER
	health = 60

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/stack/sheet/glass | /obj/item/stack/sheet/rglass))
			user << "<span class='notice'>You begin to place the [W] in the frame.</span>"
			if(do_after(user,20))
				W:use(1)
				visible_message("<span class='notice'>You successfully placed the glass in the frame!</span>")
				new /obj/structure/barricade/wooden/wall/window(src.loc)
				del(src)
		else
			return*/