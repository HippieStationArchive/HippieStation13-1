/obj/structure/bed/chair
	name = "chair"
	desc = "You sit in this. Either by will or force.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon_state = "chair"
	buckle_lying = 0 //you sit in a chair, not lay
	burn_state = -1 //Not Burnable
	buildstackamount = 1

/obj/structure/bed/chair/New()
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_layer()

/obj/structure/bed/chair/Move(atom/newloc, direct)
	..()
	handle_rotation()

/obj/structure/bed/chair/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		if(!user.drop_item())
			return
		var/obj/item/assembly/shock_kit/SK = W
		var/obj/structure/bed/chair/e_chair/E = new /obj/structure/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/attack_tk(mob/user)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/bed/chair/proc/handle_rotation(direction)
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		if(!direction || !buckled_mob.Move(get_step(src, direction), direction))
			buckled_mob.buckled = src
			dir = buckled_mob.dir
			return 0
		buckled_mob.buckled = src //Restoring
	handle_layer()
	return 1

/obj/structure/bed/chair/proc/handle_layer()
	if(dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

/obj/structure/bed/chair/proc/spin()
	src.dir = turn(src.dir, 90)
	handle_layer()
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		spin()
	else
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return
		spin()

/obj/structure/bed/chair/AltClick(mob/user)
	..()
	if(!user.canUseTopic(user))
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		rotate()

// Chair types
/obj/structure/bed/chair/wood
	burn_state = 0 //Burnable
	burntime = 20
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3

/obj/structure/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon_state = "comfychair"
	color = rgb(255,255,255)
	burn_state = 0 //Burnable
	burntime = 30
	buildstackamount = 2
	var/image/armrest = null

/obj/structure/bed/chair/comfy/New()
	armrest = image("icons/obj/objects.dmi", "comfychair_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/bed/chair/comfy/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest


/obj/structure/bed/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/bed/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/bed/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/bed/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/bed/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/bed/chair/withwheels
	var/delay = 10
	var/cooldown = 0
	var/reverse_direction = 1

/obj/structure/bed/chair/withwheels/relaymove(mob/user, direction)
	if((!Process_Spacemove(direction)) || (!has_gravity(src.loc)) || (cooldown) || user.stat || user.stunned || user.weakened || user.paralysis || (user.restrained()))
		return
	step(src, direction)
	if(buckled_mob)
		buckled_mob.dir = direction
		if(reverse_direction)
			switch(direction)
				if(NORTH)
					buckled_mob.dir = SOUTH
				if(WEST)
					buckled_mob.dir = EAST
				if(SOUTH)
					buckled_mob.dir = NORTH
				if(EAST)
					buckled_mob.dir = WEST
		dir = buckled_mob.dir
	handle_rotation()
	handle_layer()
	cooldown = 1
	spawn(delay)
		cooldown = 0

/obj/structure/bed/chair/withwheels/office
	anchored = 0

//Wheelchair
/obj/structure/bed/chair/withwheels/wheelchair
	name = "wheelchair"
	desc = "Chances are you don't really need this."
	icon_state = "wheelchair"
	anchored = 0
	delay = 4
	reverse_direction = 0

/obj/structure/bed/chair/withwheels/wheelchair/handle_rotation()
	overlays = null
	var/image/O = image(icon = 'icons/obj/objects.dmi', icon_state = "wheelchair_overlay", layer = FLY_LAYER, dir = src.dir)
	overlays += O
	if(buckled_mob)
		buckled_mob.dir = dir


/obj/structure/bed/chair/withwheels/wheelchair/rotate()
	..()
	handle_rotation()

/obj/structure/bed/chair/withwheels/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/withwheels/office/dark
	icon_state = "officechair_dark"