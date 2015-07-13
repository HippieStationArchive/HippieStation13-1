/mob/living/carbon/hitby(atom/movable/AM, zone, skip)
	if(!skip)	//ugly, but easy
		if(in_throw_mode)	//we're in throw mode
			if(canmove && !restrained())
				if(istype(AM, /obj/item))
					var/obj/item/I = AM
					if(isturf(I.loc))
						var/obj/item/B = get_active_hand()
						if(istype(B) && B.deflectItem && B.specthrow_maxwclass >= I.w_class)
							throw_mode_off()
							visible_message("<span class='warning'>[src] has [B.specthrowmsg] [I]!</span>")
							var/atom/throw_target = get_edge_target_turf(src, src.dir)
							I.throw_at(throw_target, I.throw_range, I.throw_speed)
							if(B.specthrowsound)
								playsound(loc, B.specthrowsound, 50, 1, -1)
						else if(!istype(B)) //empty hand
							put_in_active_hand(I)
							visible_message("<span class='warning'>[src] catches [I]!</span>")
							throw_mode_off()
						return 0
	..()


/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if(lying || isslime(src))
		if(surgeries.len)
			if(user.a_intent == "help")
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	..()


/mob/living/carbon/attack_hand(mob/living/carbon/human/user)
	if(!iscarbon(user))
		return

	for(var/datum/disease/D in viruses)
		if(D.IsSpreadByTouch())
			user.ContractDisease(D)

	for(var/datum/disease/D in user.viruses)
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(lying || isslime(src))
		if(user.a_intent == "help")
			if(surgeries.len)
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	return 0


/mob/living/carbon/attack_paw(mob/living/carbon/monkey/M as mob)
	if(!istype(M, /mob/living/carbon))
		return 0

	for(var/datum/disease/D in viruses)
		if(D.IsSpreadByTouch())
			M.ContractDisease(D)

	for(var/datum/disease/D in M.viruses)
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(..()) //successful monkey bite.
		for(var/datum/disease/D in M.viruses)
			ForceContractDisease(D)
		return 1

	if(M.a_intent == "help")
		help_shake_act(M)
	return 0


/mob/living/carbon/attack_slime(mob/living/carbon/slime/M)
	if(..())
		var/power = M.powerlevel + rand(0,3)
		Weaken(power)
		if (stuttering < power)
			stuttering = power
		Stun(power)
		var/stunprob = M.powerlevel * 7 + 10
		if (prob(stunprob) && M.powerlevel >= 8)
			adjustFireLoss(M.powerlevel * rand(6,10))
			updatehealth()
		return 1
