/mob/living/carbon/human/movement_delay()
	if(dna)
		. += dna.species.movement_delay(src)

	. += ..()
	. += config.human_delay

/mob/living/carbon/human/Process_Spacemove(var/movement_dir = 0)

	if(..())
		return 1

	//Do we have a working jetpack
	if(istype(back, /obj/item/weapon/tank/jetpack) && isturf(loc)) //Second check is so you can't use a jetpack in a mech
		var/obj/item/weapon/tank/jetpack/J = back
		if((movement_dir || J.stabilization_on) && J.allow_thrust(0.01, src))
			return 1
	return 0


/mob/living/carbon/human/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	if(isobj(shoes) && (shoes.flags&NOSLIP) && !(lube&GALOSHES_DONT_HELP))
		return 0
	.=..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return shoes && shoes.negates_gravity()

/mob/living/carbon/human/Move(NewLoc, direct)
	..()
	if(shoes)
		if(!lying)
			if(loc == NewLoc)
				var/obj/item/clothing/shoes/S = shoes

				S.step_action(src)
	// This is honestly dumb. It makes CORPSES scream.
	// if(lying)
	// 	if(istype(loc, /turf/space))
	// 		if(screamcount <= 0)
	// 			return 0
	// 		else
	// 			var/sound = pick('sound/misc/scream_m1.ogg', 'sound/misc/scream_m2.ogg')
	// 			if(gender == FEMALE)
	// 				sound = pick('sound/misc/scream_f1.ogg', 'sound/misc/scream_f2.ogg')
	// 			playsound(src.loc, sound, 50, 1, 5)
	// 			screamcount--


/mob/living/carbon/human/
	var/screamcount = 2
	var/screamcounting = 0