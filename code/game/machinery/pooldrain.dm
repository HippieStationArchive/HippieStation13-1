/obj/machinery/drain
	name = "Drain"
	icon = 'icons/turf/pool.dmi'
	icon_state = "drain"
	desc = "This removes things that clog the pool."
	anchored = 1
	var/active = 0
	var/status = 0 //1 is drained, 0 is full.
	var/timer = 0
	var/cooldown

/obj/machinery/drain/process()
	if(status == 0) //don't drain an empty pool.
		for(var/obj/item/absorbo in orange(1,src))
			if(absorbo.w_class == 1)
				step_towards(absorbo, src)
		sleep(7) //Gives them just the time to pick their items up.
		for(var/obj/item/absorb in range(0,src))
			if(absorb.w_class == 1)
				for(var/obj/machinery/poolfilter/filter in range(3,src))
					absorb.loc = filter
	if(active)
		if(status) //if filling up, get back to normal position
			if(timer > 0)
				playsound(src, 'sound/effects/fillingwatter.ogg', 100, 1)
				timer--
				for(var/obj/whirlo in orange(1,src))
					if(!whirlo.anchored )
						step_away(whirlo,src)
				for(var/mob/living/carbon/human/whirlm in orange(2,src))
					step_away(whirlm,src)
			else if(timer == 0)
				for(var/turf/simulated/pool/water/undrained in range(5,src))
					undrained.name = "poolwater"
					undrained.desc = "You're safer here than in the deep."
					undrained.icon_state = "turf"
					undrained.drained = 0
				for(var/obj/effect/overlay/water/undrained2 in range(5,src))
					undrained2.icon_state = "overlay"
				for(var/obj/effect/effect/waterspout/undrained3 in range(1,src))
					qdel(undrained3)
				for(var/obj/machinery/poolcontroller/undrained4 in range(5,src))
					undrained4.drained = 0
				status = 0
				active = 0
			return
		if(!status) //if draining, change everything.
			if(timer > 0)
				playsound(src, 'sound/effects/pooldrain.ogg', 100, 1)
				playsound(src, pick('sound/effects/water_wade1.ogg','sound/effects/water_wade2.ogg','sound/effects/water_wade3.ogg','sound/effects/water_wade4.ogg'), 60, 1)
				timer--
				for(var/obj/whirlo in orange(2,src))
					if(!whirlo.anchored )
						step_towards(whirlo,src)
				for(var/mob/living/carbon/human/whirlm in orange(2,src))
					step_towards(whirlm,src)
					if(prob(10))
						whirlm.Weaken(1)
					for(var/i in list(1,2,4,8,4,2,1)) //swril!
						whirlm.dir = i
						sleep(1)
					if(whirlm.loc == src.loc)
						if(whirlm.health <= -50) //If very damaged, gib.
							whirlm.gib()
						if(whirlm.stat != CONSCIOUS || whirlm.lying) // If
							whirlm.adjustBruteLoss(-5)
							playsound(src, pick('sound/misc/crack.ogg','sound/misc/crunch.ogg'), 50, 1)
							whirlm << "<span class='danger'>You're caught in the drain!</span>"
							continue
						else
							playsound(src, pick('sound/misc/crack.ogg','sound/misc/crunch.ogg'), 50, 1)
							var/obj/item/organ/limb/O = whirlm.get_organ(pick("l_leg", "r_leg")) //drain should only target the legs
							whirlm.apply_damage(4, BRUTE, O)
							whirlm << "<span class='danger'>Your legs are caught in the drain!</span>"
							continue

			else if(timer == 0)
				for(var/turf/simulated/pool/water/drained in range(5,src))
					drained.name = "Drained Pool"
					drained.desc = "Don't fall in!"
					drained.icon_state = "drained"
					drained.drained = 1
				for(var/obj/effect/overlay/water/drained2 in range(5,src))
					drained2.icon_state = "0"
				for(var/obj/effect/whirlpool/drained3 in range(1,src))
					qdel(drained3)
				for(var/obj/machinery/poolcontroller/drained4 in range(5,src))
					drained4.drained = 1
					drained4.mistoff()
				status = 1
				active = 0

/obj/effect/whirlpool
	name = "Whirlpool"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "whirlpool"
	layer = 5
	anchored = 1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32
	alpha = 90

/obj/effect/effect/waterspout
	name = "Waterspout"
	icon_state = "smoke"
	opacity = 1
	color = "#3399AA"
	layer = 5
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32
	alpha = 255


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



/obj/machinery/poolfilter/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/crowbar) && anchored)
		user << "You search the filter."
		for(var/obj/O in contents)
			O.loc = src.loc