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
	var/mineral = "wood"
	health = 200.
	maxhealth = 200.0
	burntime = 15 //Wooden walls are thick, so they take longer to burn down
	var/temploc

obj/structure/barricade/wooden/wall/attackby(obj/item/O as obj, mob/user as mob)
	if (istype(O, /obj/item/stack/sheet/mineral/wood)&& health == maxhealth)
		user << "<span class='notice'>You begin to repair the wall.</span>"
		if(do_after(user,20, target = src))
			if(!src.loc || !O)
				return
			src.health = src.maxhealth
			O:use(1)
			user << "<span class='notice'>You repair the wall.</span>"
			return
	if(istype(O, /obj/item/weapon/hatchet) && user.a_intent == "help")
		visible_message("<span class='notice'>[user] begins to deconstruct [src].</span>", "<span class ='notice'>You begin to deconstruct [src].</spam>")
		if(do_after(user,70/O.toolspeed, target = src))
			if(!src.loc)
				return
			visible_message("<span class='notice'>[user] deconstructs [src].</span>", "<span class ='notice'>You deconstruct [src].</span>")
			for(var/i in 1 to 8)
				new /obj/item/stack/sheet/mineral/wood(get_turf(user))
			new /obj/structure/barricade/wooden(get_turf(src))
			qdel(src)
			..()
	else
		src.health -= O.force
		user.changeNext_move(CLICK_CD_MELEE)
		visible_message("<span class='warning'>[user] hits [src] with [O]!</span>", "<span class='warning'>You hit [src] with [O]!</span>")
		if (src.health <= 0)
			visible_message("<B><span class='danger'>The wall is smashed apart!</span></B>")
			new /obj/item/stack/sheet/mineral/wood(get_turf(src), 4)
			temploc = src.loc
			for(var/obj/structure/barricade/wooden/wall/W in range(temploc,1))
				W.relativewall()
			relativewall_neighbours()
			qdel(src)
	return

/obj/structure/barricade/wooden/wall/New()
	relativewall_neighbours()
	..()
/obj/structure/barricade/wooden/wall/CanAtmosPass(turf/T) //Not space worthy
	return !density

/obj/structure/barricade/wooden/windowframe
	name = "wooden window frame"
	desc = "A wooden window frame with no glass in it. You can fit through rather easily."
	icon = 'icons/turf/walls/wooden_walls.dmi'
	icon_state = "window_noglass"
	anchored = 1.0
	density = 0
	health = 125
	burntime = 15

/obj/structure/barricade/wooden/windowframe/filled/CanAtmosPass(turf/T) //Wood huts are not air tight, window or not
	return !density

/obj/structure/barricade/wooden/windowframe/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack/sheet/glass))
		user << "<span class='notice'>You begin to place [W] in the frame.</span>"
		if(do_after(user,20, target = src))
			W:use(1)
			visible_message("<span class='notice'>You successfully placed [W] in [src]!</span>")
			new /obj/structure/barricade/wooden/windowframe/filled(src.loc)
			qdel(src)
			return
	if (istype(W,/obj/item/weapon/hatchet) && user.a_intent == "help")
		if(src.health >= maxhealth *0.7)
			visible_message("<span class ='notice'>[user] begins to deconstruct [src]</span>","<span class ='notice'>You begin to disassemble the [src]</span>")
			if(do_after(user,50/W.toolspeed, target = src))
				visible_message("<span class ='notice'>[user] deconstructs [src]</span>", "<span class='notice'>You disassemble [src].</span>")
				new /obj/item/stack/sheet/mineral/wood(get_turf(user), 3)
				qdel(src)
				return
		else
			user << "<span class='danger'>[src] is too damaged to try to deconstruct normally</span>"
			return
	if(istype(W, /obj/item/stack/sheet/mineral/wood)&& W:amount >=5)
		user << "<span notice='notice'>You begin to place [W] in the frame</span>"
		if(do_after(user, 60, target = src))
			W:use(5)
			visible_message("<span class='notice'>[user] constructs a wall out of [src]</span>.", "<span class='notice'>You construct a wall out of [src].</span>")
			new /obj/structure/barricade/wooden/wall(get_turf(src))
			qdel(src)
			return
	else
		src.health -= W.force
		user.changeNext_move(CLICK_CD_MELEE)
		visible_message("<span class='warning'>[user] hits [src] with [W]!</span>", "<span class='warning'>You hit [src] with [W]!</span>")
		if (src.health <= 0)
			visible_message("<span class='danger'><B>[user] destroys [src]!</B></span>")
			new /obj/item/stack/sheet/mineral/wood(get_turf(src), 3)
			qdel(src)
			return

/obj/structure/barricade/wooden/windowframe/filled
	name = "wooden window"
	desc = "A plain, but rather classy window in a wooden frame."
	icon_state = "window"
	density = 1.0
	health = 75

/obj/structure/barricade/wooden/windowframe/filled/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/weldingtool) && user.a_intent == "help" && src.health != src.maxhealth && W.reagents.reagent_list)
		user << "<span class='notice'>You begins to repair the window."
		if(do_after(user,20/W.toolspeed, target = src))
			src.health = src.maxhealth
			W:use(1)
			visible_message("<span class='notice'>[user] repairs [src] with [W].</span>")
			playsound(src.loc, 'sound/items/Welder.ogg', 80, 1)
			return
	if(istype(W,/obj/item/weapon/screwdriver) && user.a_intent == "help" && src.health < src.maxhealth)
		user << "<span class='notice'>You begin to unfasten the window.</span>"
		if(do_after(user,30/W.toolspeed, target = src))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			visible_message("<span class='notice'>[user] removes the window from from the frame.</span>")
			new /obj/item/stack/sheet/glass(get_turf(user))
			new /obj/structure/barricade/wooden/windowframe(get_turf(src))
			qdel(src)
			return
	else
		src.health -= W.force
		user.changeNext_move(CLICK_CD_MELEE)
		visible_message("<span class='warning'>[user] hits [src] with [W]!</span>", "<span class='warning'>You hit [src] with [W]!</span>")
		if (src.health <= 0)
			visible_message("<span class='danger'><B>The window is smashed apart!</B></span>")
			playsound(src, 'sound/effects/Glassbr3.ogg', 100, 1)
			new /obj/item/weapon/shard(get_turf(src))
			new /obj/structure/barricade/wooden/windowframe(get_turf(src))
			qdel(src)
			return

/obj/structure/barricade/wooden/windowframe/filled/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'><B>The wall is smashed apart!</B></span>")
			qdel(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				visible_message("<span class='danger'> <B>The wall is smashed apart!</B></span>")
				for(var/i in 1 to 3)
					new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				new /obj/item/weapon/shard(get_turf(src))
				qdel(src)
				..()
			return

/obj/structure/barricade/wooden/windowframe/filled/blob_act()
	src.health -= 25
	if (src.health <= 0)
		visible_message("<span class='danger'><B>The blob eats through the window!</B></span>")
		qdel(src)
	return
