/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"
	buckle_lying = 0
	var/can_rotate = 0

/obj/structure/stool/bed/chair/New()
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_layer()
	return

/obj/structure/stool/bed/chair/Move(atom/newloc, direct)
	..()
	handle_rotation()

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		user.drop_item()
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)
/obj/structure/stool/bed/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/stool/bed/chair/proc/handle_rotation(direction)
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		if(!direction || !buckled_mob.Move(get_step(src, direction), direction))
			buckled_mob.buckled = src
			dir = buckled_mob.dir
			handle_layer()
			return 0
		handle_layer()
		buckled_mob.buckled = src //Restoring
	return 1

/obj/structure/stool/bed/chair/proc/handle_layer()
	if(dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

/obj/structure/stool/bed/chair/proc/spin()
	src.dir = turn(src.dir, 90)
	handle_layer()
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/stool/bed/chair/verb/rotate()
	if(src.can_rotate)
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

// /obj/structure/stool/bed/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
// 	if(!istype(M)) return
// 	buckle_mob(M, user)
// 	return

// Chair types
/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/escapepods
	icon_state = "sblackchair"
	name = "Pod Chair"
	desc = "Always confy, and efficient at leaving your worries behind."

/obj/structure/stool/bed/chair/escape
	icon_state = "sbluechair"
	name = "Shuttle Chair"
	desc = "Always confy, and efficient at leaving your worries behind."

/obj/structure/stool/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/mineral/wood(src.loc)
		qdel(src)
	else
		..()

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."
	icon_state = "comfychair"
	color = rgb(255,255,255)
	var/image/armrest = null

/obj/structure/stool/bed/chair/comfy/New()
	armrest = image("icons/obj/objects.dmi", "comfychair_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/stool/bed/chair/comfy/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

/obj/structure/stool/bed/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/stool/bed/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/stool/bed/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/stool/bed/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/stool/bed/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/stool/bed/chair/office
	anchored = 0
	var/cooldown = 0

/obj/structure/stool/bed/chair/office/relaymove(mob/user, direction)
	if((!Process_Spacemove(direction)) || (!has_gravity(src.loc)) || (cooldown) || user.stat || user.stunned || user.weakened || user.paralysis || (user.restrained()))
		return
	step(src, direction)
	if(buckled_mob)
		buckled_mob.dir = dir
		switch(buckled_mob.dir)
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
	spawn(10)
		cooldown = 0

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"