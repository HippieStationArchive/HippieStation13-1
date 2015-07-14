/area/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "pool"

/area/centcom/pool
	name = "\improper Centcomm Pool"
	icon_state = "pool"

/mob
  var/swimming = 0

/turf/simulated/pool
	name = "pool"
	icon = 'icons/turf/pool.dmi'
	var/drained = 0 //Keeps track if the pool is empty or not
	var/splashed = 0 //Making sure they don't get splashed too much

/turf/simulated/floor/blob_act()
	return

//Put people out of the water
/turf/simulated/floor/MouseDrop_T(mob/M as mob, mob/user as mob)
	var/turf/loc = get_turf(usr)
	if(loc.name == "Drained Pool")
		return
	if(user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
		return ..()
	if(!M.swimming) //can't put yourself up if you are not swimming
		return ..()
	if(user == M)
		M.visible_message("<span class='notice'>[user] is getting out the pool", \
						"<span class='notice'>You start getting out of the pool.</span>")
		if(do_mob(user, M, 20))
			M.swimming = 0
			var/turf/T = get_turf(M)
			T.Exited(M)
			M.forceMove(src)
			user << "<span class='notice'>You get out of the pool.</span>"
			playsound(src, 'sound/effects/water_exit.ogg', 20, 1)
	else
		user.visible_message("<span class='notice'>[M] is being pulled to the poolborder by [user].</span>", \
						"<span class='notice'>You start getting [M] out of the pool.")
		if(do_mob(user, M, 20))
			M.swimming = 0
			var/turf/T = get_turf(M)
			T.Exited(M)
			M.forceMove(src)
			user << "<span class='notice'>You get [M] out of the pool.</span>"
			return

/turf/simulated/floor/CanPass(atom/movable/A, turf/T)
	if(istype(A, /mob/living) || istype(A, /obj/structure)) //This check ensures that only specific types of objects cannot pass into the water. Items will be able to get tossed out.
		if(istype(A, /mob/living/simple_animal) || istype(A, /mob/living/carbon/monkey))
			return ..()
		if (istype(A, /obj/structure) && istype(A.pulledby, /mob/living/carbon/human))
			return ..()
		if(istype(get_turf(A), /turf/simulated/pool/water) && !istype(T, /turf/simulated/pool/water)) //!(locate(/obj/structure/pool/ladder) in get_turf(A).loc)
			return 0
	return ..()

/obj/effect/overlay/water
	name = "Water"
	icon = 'icons/turf/pool.dmi'
	icon_state = "overlay"
	density = 0
	mouse_opacity = 0
	layer = 5
	anchored = 1

/turf/simulated/pool/water
	name = "poolwater"
	desc = "You're safer here than in the deep."
	icon_state = "turf"
	var/obj/effect/overlay/water/watereffect

/turf/simulated/pool/water/New()
	..()
	for(var/obj/effect/overlay/water/W in src)
		if(W)
			qdel(W)
	watereffect = new /obj/effect/overlay/water(src)

/turf/simulated/pool/water/ChangeTurf(var/path)
	. = ..()
	if(. != src)
		qdel(watereffect) //Remove the water overlay so it doesn't hang around

//put people in water, including you
/turf/simulated/pool/water/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(drained)
		return
	if(user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
		return
	if(!ishuman(user)) // no silicons or drones in mechas.
		return
	if(M.swimming == 1) //can't lower yourself again
		return
	else
		if(user == M)
			M.visible_message("<span class='notice'>[user] is descending in the pool", \
							"<span class='notice'>You start lowering yourself in the pool.</span>")
			if(do_mob(user, M, 20))
				M.swimming = 1
				M.forceMove(src)
				user << "<span class='notice'>You lower yourself in the pool.</span>"
		else
			user.visible_message("<span class='notice'>[M] is being put in the pool by [user].</span>", \
							"<span class='notice'>You start lowering [M] in the pool.")
			if(do_mob(user, M, 20))
				M.swimming = 1
				M.forceMove(src)
				user << "<span class='notice'>You lower [M] in the pool.</span>"
				return

//What happens if you don't drop in it like a good person would
/turf/simulated/pool/water/Entered(atom/A, turf/OL)
	..()
	if(drained) //self explanatory I believe
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.swimming == 0)
				if(locate(/obj/structure/pool/ladder) in H.loc)
					H.swimming = 1
			if(H.swimming == 0)
				if(prob(75))
					H.visible_message("<span class='danger'>[H] falls in the drained pool!</span>",
												"<span class='userdanger'>You fall in the drained pool!</span>")

					H.adjustBruteLoss(7)
					H.Weaken(4)
					H.swimming = 1
					playsound(src, 'sound/effects/woodhit.ogg', 60, 1, 1)
				else
					H.visible_message("<span class='danger'>[H] falls in the drained pool, and cracks his skull!</span>",
												"<span class='userdanger'>You fall in the drained pool, and crack your skull!</span>")

					var/obj/item/organ/limb/O = H.get_organ("head") //NT makes the most dangerous pool : they aim for the head.
					H.apply_damage(15, BRUTE, O)
					H.Weaken(12) // This should hurt. And it does.
					H.adjustBrainLoss(30) //herp
					H.swimming = 1
					playsound(src, 'sound/effects/woodhit.ogg', 60, 1, 1)
					playsound(src, 'sound/misc/crack.ogg', 100, 1)
					var/obj/effect/effect/splatter/B = new(H)
					B.basecolor = H.dna.species.blood_color
					B.blood_source = H
					B.update_icon()
					var/turf/targ = get_ranged_target_turf(H, get_dir(H, H), 1)
					B.GoTo(targ, 1)


	else
		..()
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			H.adjustStaminaLoss(1)
			H.wash()
			if(H.swimming == 1)
				playsound(src, pick('sound/effects/water_wade1.ogg','sound/effects/water_wade2.ogg','sound/effects/water_wade3.ogg','sound/effects/water_wade4.ogg'), 20, 1)
				H.ExtinguishMob()
				if(H.toxloss < 30 && H.staminaloss > 20 && H.staminaloss < 40) 	 //Heals toxin damage pretty well.
					H.adjustToxLoss(-0.4)
				if(H.fireloss < 21 && H.staminaloss > 20 && H.staminaloss < 40) //Heals light fire damage.
					H.adjustFireLoss(-0.4)
				if(H.bruteloss < 11 && H.staminaloss > 20 && H.staminaloss < 40) //Heals very light brute damage.
					H.adjustBruteLoss(-0.4)
				return
			if(H.swimming == 0)
				if(locate(/obj/structure/pool/ladder) in H.loc)
					H.swimming = 1
					return
				if (H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH)
					H.visible_message("<span class='danger'>[H] falls in the water!</span>",
										"<span class='userdanger'>You fall in the water!</span>")
					playsound(src, 'sound/effects/splash.ogg', 60, 1, 1)
					H.Weaken(1)
					H.swimming = 1
					H.ExtinguishMob()
					return
				else
					H.drop_item()
					H.adjustOxyLoss(5)
					H.emote("cough")
					H.visible_message("<span class='danger'>[H] falls in and takes a drink!</span>",
										"<span class='userdanger'>You fall in and swallow some water!</span>")
					playsound(src, 'sound/effects/splash.ogg', 60, 1, 1)
					H.Weaken(3)
					H.swimming = 1
					H.ExtinguishMob()

/turf/simulated/pool/water/Exited(mob/M)
	..()
	var/turf/T = get_turf(M)
	if(istype(M) && istype(watereffect) && istype(T) && src.y != T.y) //We're checking for y variable here so layering isn't fucked when you move horizontally
		watereffect.layer = M.layer - 0.1 //Always a step behind!
		spawn(3)
			watereffect.layer = initial(watereffect.layer)

/obj/structure/pool
	name = "pool"
	icon = 'icons/turf/pool.dmi'
	anchored = 1

/obj/structure/pool/ladder
	name = "Ladder"
	icon_state = "ladder"
	desc = "Are you getting in or are you getting out?."
	layer = 5.1
	dir=4

/obj/structure/pool/ladder/attack_hand(mob/user as mob)
	if(Adjacent(user) && user.y == src.y && user.swimming == 0)

		user.swimming = 1
		user.forceMove(get_step(user, get_dir(user, src))) //Either way, you're getting IN or OUT of the pool.
	else if(user.loc == src.loc && user.swimming == 1)
		user.swimming = 0
		user.forceMove(get_step(user, reverse_direction(dir)))

/obj/structure/pool/Rboard
	name = "JumpBoard"
	density = 0
	icon_state = "boardright"
	desc = "The less-loved portion of the jumping board."
	dir = 4

/obj/structure/pool/Rboard/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/pool/Lboard
	name = "JumpBoard"
	icon_state = "boardleft"
	desc = "Get on there to jump!"
	layer = 5
	dir = 8
	var/jumping = 0
	var/timer

/obj/structure/pool/Lboard/proc/backswim(obj/O as obj, mob/user as mob) //Puts the sprite back to it's maiden condition after a jump.
	if(jumping == 1)
		for(var/mob/jumpee in src.loc) //hackzors.
			playsound(jumpee, 'sound/effects/splash.ogg', 60, 1, 1)
			jumpee.layer = 4
			jumpee.pixel_x = 0
			jumpee.pixel_y = 0
			jumpee.stunned = 1
			jumpee.swimming = 1

/obj/structure/pool/Lboard/attack_hand(mob/user as mob)
	if(iscarbon(user))
		var/mob/living/carbon/jumper = user
		if(jumping == 1)
			user << "<span class='notice'>Someone else is already making a jump!</span>"
			return
		var/turf/T = get_turf(src)
		if(user.swimming)
			return
		else
			for(var/obj/machinery/poolcontroller/pc in range(4,src)) //Clunky as fuck I know.
				if(pc.timer > 44) //if it's draining/filling, don't allow.
					user << "<span class='notice'>This is not a good idea.</span>"
					return
				if(pc.drained == 1)
					user << "<span class='notice'>That would be suicide</span>"
					return
			if(Adjacent(jumper))
				jumper.visible_message("<span class='notice'>[user] climbs up \the [src]!</span>", \
									 "<span class='notice'>You climb up \the [src] and prepares to jump!</span>")
				jumper.canmove = 0
				jumper.stunned = 4
				jumping = 1
				jumper.layer = 5.1
				jumper.pixel_x = 3
				jumper.pixel_y = 7
				jumper.dir=8
				spawn(1) //somehow necessary
					jumper.loc = T
					jumper.stunned = 4
					spawn(10)
						var/randn = rand(1, 100)
						switch(randn)
							if(1 to 20)
								jumper.visible_message("<span class='notice'>[user] goes for a small dive!</span>", \
													 "<span class='notice'>You go for a small dive.</span>")
								sleep(15)
								backswim()
								var/atom/throw_target = get_edge_target_turf(src, dir)
								jumper.throw_at(throw_target, 1, 1)

							if(21 to 40)
								jumper.visible_message("<span class='notice'>[user] goes for a dive!</span>", \
													 "<span class='notice'>You're going for a dive!</span>")
								sleep(20)
								backswim()
								var/atom/throw_target = get_edge_target_turf(src, dir)
								jumper.throw_at(throw_target, 2, 1)

							if(41 to 60)
								jumper.visible_message("<span class='notice'>[user] goes for a long dive! Stay far away!</span>", \
										"<span class='notice'>You're going for a long dive!!</span>")
								sleep(25)
								backswim()
								var/atom/throw_target = get_edge_target_turf(src, dir)
								jumper.throw_at(throw_target, 3, 1)

							if(61 to 80)
								jumper.visible_message("<span class='notice'>[user] goes for a awesome dive! Don't stand in \his way!</span>", \
													 "<span class='notice'>You feel like this dive will be awesome</span>")
								sleep(30)
								backswim()
								var/atom/throw_target = get_edge_target_turf(src, dir)
								jumper.throw_at(throw_target, 4, 1)
							if(81 to 91)
								sleep(20)
								backswim()
								jumper.visible_message("<span class='danger'>[user] misses \his step!</span>", \
												 "<span class='userdanger'>You misstep!</span>")
								var/atom/throw_target = get_edge_target_turf(src, dir)
								jumper.throw_at(throw_target, 0, 1)
								jumper.Weaken(5)
								jumper.adjustBruteLoss(10)

							if(91 to 100)
								jumper.visible_message("<span class='notice'>[user] is preparing for the legendary dive! Can he make it?</span>", \
													 "<span class='userdanger'>You start preparing for a legendary dive!</span>")
								jumper.SpinAnimation(7,1)

								sleep(30)
								if(prob(75))
									backswim()
									jumper.visible_message("<span class='notice'>[user] fails!</span>", \
											 "<span class='userdanger'>You can't quite do it!</span>")
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 1, 1)
								else
									jumper.fire_stacks = min(1,jumper.fire_stacks + 1)
									jumper.IgniteMob()
									sleep(5)
									backswim()
									jumper.visible_message("<span class='danger'>[user] bursts into flame of pure awesomness!</span>", \
										 "<span class='userdanger'>No one can stop you now!</span>")
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 6, 1)
						spawn(35)
							jumping = 0
			else
				return

/turf/simulated/pool/water/attack_hand(mob/user)
	if(!user.stat && !user.lying && Adjacent(user) && user.swimming && !src.drained && !src.splashed) //not drained, user alive and close, and user in water.
		if(user.x == src.x && user.y == src.y)
			return
		else
			playsound(src, 'sound/effects/watersplash.ogg', 8, 1, 1)
			src.splashed = 1
			var/obj/effect/splash/S = new /obj/effect/splash(user.loc)
			animate(S, alpha = 40,  time = 7)
			S.Move(src)
			spawn(25)
				qdel(S)
				spawn(12)
					src.splashed = 0 //Otherwise, infinite splash party.

			for(var/mob/living/carbon/human/L in src)
				if(!L.wear_mask && !user.stat) //Do not affect those underwater or dying.
					L.emote("cough")
				L.adjustStaminaLoss(4) //You need to give em a break!




/obj/effect/splash
	name = "splash"
	desc = "Wataaa!."
	icon = 'icons/turf/pool.dmi'
	icon_state = "splash"
	layer = MOB_LAYER + 0.1