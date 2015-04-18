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
	//These are already defined in /simulated
	// thermite = 0
	// oxygen = MOLES_O2STANDARD
	// nitrogen = MOLES_N2STANDARD

//Put people out of the water
/turf/simulated/floor/MouseDrop_T(mob/M as mob, mob/user as mob)
	if( user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
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
			playsound(src, 'sound/effects/water_exit.ogg', 20, 1)
			return

/turf/simulated/floor/CanPass(atom/movable/A, turf/T)
	if(istype(A, /mob/living) || istype(A, /obj/structure)) //This check ensures that only specific types of objects cannot pass into the water. Items will be able to get tossed out.
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
	var/cooldown = 0 //this is literally only used for a message

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
			user.visible_message("<span class='notice'>[M] is being put in the water by [user].</span>", \
							"<span class='notice'>You start lowering [M] in the pool.")
			if(do_mob(user, M, 20))
				M.swimming = 1
				M.forceMove(src)
				user << "<span class='notice'>You lower [M] in the water.</span>"
				return

//What happens if you don't drop in it like a good person would
/turf/simulated/pool/water/Entered(atom/A, turf/OL)
	..()
	A.emp_act(1)
	// This makes water just look weird
	// if(istype(A, /mob))
	// 	var/mob/M = A
	// 	if(istype(watereffect) && istype(OL) && src.y != OL.y) //We're checking for y variable here so layering isn't fucked when you move horizontally
	// 		watereffect.layer = M.layer - 0.1 //Veeery tiny difference so layer 3 shit doesn't show up if mob's layer is MOB_LAYER (4).
	// 		spawn(3)
	// 			watereffect.layer = initial(watereffect.layer)

	if (istype(A,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/swimborg = A
		swimborg << "<span class='userdanger'>Your magnesium core explodes in reaction to the water!</span>"
		swimborg.self_destruct()
		if(swimborg.connected_ai)
			swimborg.connected_ai << "<br><br><span class='alert'>ALERT - Cyborg magnesium core failure detected: [swimborg.name]</span><br>"
	else if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.adjustStaminaLoss(1)
//		if(H.staminaloss > 35 && H.staminaloss < 50)
//			if (cooldown < world.time - 100)
//				cooldown = world.time
//				H << "<span class='notice'>You feel like you swam enough.</span>"
		if(H.swimming == 1)
			playsound(src, pick('sound/effects/water_wade1.ogg','sound/effects/water_wade2.ogg','sound/effects/water_wade3.ogg','sound/effects/water_wade4.ogg'), 20, 1)
			H.ExtinguishMob()
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
				H.adjustOxyLoss(10)
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
	if(ishuman(M) && !istype(T, /turf/simulated/pool/water)) //Check if the dude exited the pool
		var/mob/living/carbon/human/H = M
		if(H.staminaloss > 35 && H.staminaloss < 50)
			H << "<span class='notice'>You feel refreshed and cleaned by the exercise! You need to take a quick rest, though.</span>"
			H.setStaminaLoss(60) //So you can't instantly go back to swim
			H.adjustBruteLoss(-2)
			H.adjustFireLoss(-2)
			H.adjustToxLoss(-20) //An actual reason to take a swim

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
			switch( alert("Jump from the board?", "Jumpboard", "Yes!", "No!"))
				if("Yes!")
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


				if("No!")
					return

/obj/machinery/drain
	name = "Drain"
	icon = 'icons/turf/pool.dmi'
	icon_state = "drain"
	desc = "This is strangely useless."
	anchored = 1

/obj/machinery/poolfilter
	name = "Filter"
	icon = 'icons/turf/pool.dmi'
	icon_state = "filter"
	desc = "The part of the pool that swallows dangerous stuff"
	anchored = 1

/obj/machinery/poolfilter/emag_act(user as mob)
	if(!emagged)
		user << "\red You disable \the [src]'s shark filter. Run!" //you better
		emagged = 1
		src.icon_state = "filter_b"
		spawn(50)
			if(prob(50))
				new /mob/living/simple_animal/hostile/shark(src.loc)
			else
				if(prob(50))
					new /mob/living/simple_animal/hostile/shark/kawaii(src.loc)
				else
					new /mob/living/simple_animal/hostile/shark/laser(src.loc)