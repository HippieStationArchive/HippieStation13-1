//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	var/total_burn	= 0
	var/total_brute	= 0
	for(var/obj/item/organ/limb/O in organs)	//hardcoded to streamline things a bit
		total_brute	+= O.brute_dam
		total_burn	+= O.burn_dam
	health = maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute

	var/list/missing_limbs = get_missing_limbs() //Get missing limbs yo
	health -= missing_limbs.len * 10 //-10 max health for every missing limb
	if( ((maxHealth - total_burn) < config.health_threshold_dead) && stat == DEAD )
		ChangeToHusk()
		if(on_fire)
			shred_clothing()
	med_hud_set_health()
	med_hud_set_status()
	return


//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/obj/item/organ/limb/O in organs)
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/obj/item/organ/limb/O in organs)
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/getBloodLoss()
	var/amount = 0
	for(var/obj/item/organ/limb/O in organs)
		amount += O.bloodloss
	return amount

/mob/living/carbon/human/adjustBruteLoss(amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/carbon/human/adjustFireLoss(amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/carbon/human/adjustBloodLoss(amount)
	if(amount > 0)
		take_overall_damage(0, 0, amount)
	else
		heal_overall_damage(0, 0, -amount)

//this is an unused proc, would be nice if it was used somewhere tho.
/mob/living/carbon/human/proc/hat_fall_prob()
	var/multiplier = 1
	var/obj/item/clothing/head/H = head
	var/loose = 40
	if(stat || (status_flags & FAKEDEATH))
		multiplier = 2
	if(H.flags_cover & (HEADCOVERSEYES | HEADCOVERSMOUTH) || H.flags_inv & (HIDEEYES | HIDEFACE))
		loose = 0
	return loose * multiplier

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(brute, burn, bleed)
	var/list/obj/item/organ/limb/parts = list()
	for(var/obj/item/organ/limb/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam) || (bleed && O.bloodloss))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/obj/item/organ/limb/parts = list()
	for(var/obj/item/organ/limb/O in organs)
		if(O.brute_dam + O.burn_dam < O.max_damage)
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(brute, burn, bleed)
	var/list/obj/item/organ/limb/parts = get_damaged_organs(brute,burn,bleed)
	if(!parts.len)	return
	var/obj/item/organ/limb/picked = pick(parts)
	if(picked.heal_damage(brute,burn,bleed))
		update_damage_overlays(0)
	updatehealth()

//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(brute, burn, bleed)
	var/list/obj/item/organ/limb/parts = get_damageable_organs()
	if(!parts.len)	return //Can't even induce bloodloss if no organs can be damaged
	var/obj/item/organ/limb/picked = pick(parts)
	if(picked.take_damage(brute,burn,bleed))
		update_damage_overlays(0)

	updatehealth()


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(brute, burn, bleed)
	var/list/obj/item/organ/limb/parts = get_damaged_organs(brute,burn,bleed)

	var/update = 0
	while(parts.len && (brute>0 || burn>0 || bleed>0) )
		var/obj/item/organ/limb/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		var/bleed_was = picked.bloodloss

		update |= picked.heal_damage(brute,burn,bleed)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)
		bleed -= (bleed_was-picked.bloodloss)

		parts -= picked
	updatehealth()
	if(update)	update_damage_overlays(0)

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(brute, burn, bleed)
	if(status_flags & GODMODE)	return	//godmode

	var/list/obj/item/organ/limb/parts = get_damageable_organs()
	var/update = 0
	while(parts.len && (brute>0 || burn>0 || bleed>0) )
		var/obj/item/organ/limb/picked = pick(parts)
		var/brute_per_part = brute/parts.len
		var/burn_per_part = burn/parts.len
		var/bleed_per_part = bleed/parts.len

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam
		var/bleed_was = picked.bloodloss


		update |= picked.take_damage(brute_per_part,burn_per_part,bleed_per_part)

		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)
		bleed	-= (picked.bloodloss - bleed_was)

		parts -= picked

	updatehealth()

	if(update)	update_damage_overlays(0)

/mob/living/carbon/human/proc/restore_blood()
	if(!(NOBLOOD in dna.species.specflags))
		var/blood_volume = vessel.get_reagent_amount("blood")
		vessel.add_reagent("blood",560-blood_volume)

////////////////////////////////////////////


/mob/living/carbon/human/proc/get_organ(zone)
	if(!zone)	zone = "chest"
	for(var/obj/item/organ/limb/O in organs)
		if(Bodypart2name(O) == zone)
			return O
	return null


/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = 0)
	// depending on the species, it will run the corresponding apply_damage code there
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src)
