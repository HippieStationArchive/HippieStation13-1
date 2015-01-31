/obj/structure/stool/bed/chair/janicart/lawnmower
	name = "lawnmower"
	desc = "VROOM VROOM"
	icon_state = "lawnmower"
	var/emagged = 0

	Bump(atom/A as mob|obj|turf|area)
		if(emagged)
			if(istype(A, /mob/living/))
				var/mob/living/C = A
				var/atom/throw_target = get_edge_target_turf(C, get_dir(src, get_step_away(C, src)))
				C.throw_at(throw_target, 25, 4)
				return

	Move()
		var/gibbed = 0
		if(emagged)
			for(var/mob/living/carbon/human/X in src.loc)
				if(X.lying)
					if(buckled_mob == X)
						shake_camera(X, 20, 1) //BOOM BOOM SHAKE THE ROOM
						return
					else
						X.gib()
						gibbed = 1
						playsound(src.loc, 'sound/effects/mowermovesquish.ogg', 75, 1)
						shake_camera(X, 40, 1) //BOOM BOOM SHAKE THE ROOM
		for(var/obj/effect/spacevine/S in src.loc)
			qdel(S)
		if(gibbed)
			return
		else
			playsound(src.loc, pick('sound/effects/mowermove1.ogg', 'sound/effects/mowermove2.ogg'), 75, 1)
		..()

	attackby(atom/C as mob|obj|turf|area)
		..()
		if(istype(C, /obj/item/weapon/card/emag))
			emagged = 1
			usr << "\red You emag the lawnmower and disable its safety."

//Handled by janicart
// /obj/structure/stool/bed/chair/janicart/lawnmower/update_mob()
// 	if(buckled_mob)
// 		buckled_mob.dir = dir
// 		switch(dir)
// 			if(SOUTH)
// 				buckled_mob.pixel_x = 0
// 				buckled_mob.pixel_y = 7
// 			if(WEST)
// 				buckled_mob.pixel_x = 5
// 				buckled_mob.pixel_y = 2
// 			if(NORTH)
// 				buckled_mob.pixel_x = 0
// 				buckled_mob.pixel_y = 4
// 			if(EAST)
// 				buckled_mob.pixel_x = -5
// 				buckled_mob.pixel_y = 2

obj/structure/stool/bed/chair/janicart/lawnmower/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle()
	else
		step(src, direction)
		update_mob()
		handle_rotation()

/obj/structure/stool/bed/chair/janicart/lawnmower/examine()
	return


//Scooter's lawnkarts - have to be reimplemented

// /obj/structure/stool/bed/chair/janicart/lawnmower/kart
// 	var/lap = 0
// 	var/checkpoint = 0
// 	dir = EAST
// 	var/canmove = 0


// /obj/structure/stool/bed/chair/janicart/lawnmower/kart/buckle_mob(mob/M, mob/user)
// 	M.client.screen += new /obj/screen/startinglight
// 	M.client.screen += new /obj/screen/kartitem
// 	M.client.screen += new /obj/screen/horn
// 	..()

// /obj/structure/stool/bed/chair/janicart/lawnmower/kart/unbuckle(mob)
// 	buckled_mob.client.screen -= locate(/obj/screen/startinglight)
// 	buckled_mob.client.screen -= locate(/obj/screen/kartitem)
// 	buckled_mob.client.screen -= locate(/obj/screen/horn)
// 	..()


// /obj/structure/stool/bed/chair/janicart/lawnmower/kart/Move()
// 	if(!canmove)
// 		return
// 	else
// 		..()
// 		if(buckled_mob && canmove)
// 			if(buckled_mob.buckled == src)
// 				buckled_mob.loc = loc
// 				for(var/atom/C in range(src,0))
// 					if(istype(C, /obj/item/weapon/grown/bananapeel))
// 						buckled_mob << "\red You fly off your Lawnmower!"
// 						unbuckle()
// 						var/atom/throw_target = get_edge_target_turf(buckled_mob, get_dir(src, get_step_away(C, src)))
// 						buckled_mob.throw_at(throw_target, 8, 10)
// 					if(istype(C, /obj/item/weapon/soap/syndie))
// 						buckled_mob << "\red Your kart slips!"
// 						var/atom/throw_target = get_edge_target_turf(src, get_dir(src, get_step_away(C, src)))
// 						src.throw_at(throw_target, 8, 10)
// 						for(var/i in list(1,2,4,8,4,8,4,dir))
// 							dir = i
// 							sleep(1)
// 						playsound(src.loc,'sound/effects/spinout.ogg')
// /obj/structure/stool/bed/chair/janicart/lawnmower/kart/Bump(atom/A as mob|obj|turf|area)
// 	if(istype(A, /obj/structure/stool/bed/chair/janicart/lawnmower/kart))
// 		var/mob/living/C = A
// 		var/atom/throw_target = get_edge_target_turf(C, get_dir(src, get_step_away(C, src)))
// 		C.throw_at(throw_target, 5, 6)
// 		return