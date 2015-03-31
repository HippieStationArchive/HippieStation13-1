/obj/structure/stool/bed/chair/janicart/lawnmower
	name = "lawnmower"
	desc = "VROOM VROOM"
	icon_state = "lawnmower"
	var/emagged = 0

	Bump(atom/A as mob|obj|turf|area)
		if(emagged)
			if(istype(A, /mob/living/))
				var/mob/living/C = A
				C.adjustBruteLoss(25) //Crit in 4 hits, rip
				var/atom/throw_target = get_edge_target_turf(C, get_dir(src, get_step_away(C, src)))
				C.throw_at(throw_target, 4, 1)
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

/obj/structure/stool/bed/chair/janicart/lawnmower/update_mob()
	if(buckled_mob)
		buckled_mob.dir = dir
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 5
				buckled_mob.pixel_y = 2
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -5
				buckled_mob.pixel_y = 2

obj/structure/stool/bed/chair/janicart/lawnmower/relaymove(mob/user as mob, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	else
		step(src, direction)
		update_mob()
		handle_rotation()

/obj/structure/stool/bed/chair/janicart/lawnmower/examine()
	return