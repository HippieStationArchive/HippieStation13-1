//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(status_flags & GODMODE)
		return
	var/total_burn	= 0
	var/total_brute	= 0
	for(var/obj/item/organ/limb/O in organs)	//hardcoded to streamline things a bit
		total_brute	+= O.brute_dam
		total_burn	+= O.burn_dam
	health = maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute
	update_stat()
	if( ((maxHealth - total_burn) < config.health_threshold_dead) && stat == DEAD )
		ChangeToHusk()
		if(on_fire)
			shred_clothing()
	med_hud_set_health()
	med_hud_set_status()


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


/mob/living/carbon/human/adjustBruteLoss(amount)
	if(status_flags & GODMODE)
		return 0
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/carbon/human/adjustFireLoss(amount)
	if(status_flags & GODMODE)
		return 0
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

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
/mob/living/carbon/human/proc/get_damaged_organs(brute, burn)
	var/list/obj/item/organ/limb/parts = list()
	for(var/obj/item/organ/limb/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
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
/mob/living/carbon/human/heal_organ_damage(brute, burn)
	var/list/obj/item/organ/limb/parts = get_damaged_organs(brute,burn)
	if(!parts.len)
		return
	var/obj/item/organ/limb/picked = pick(parts)
	if(picked.heal_damage(brute,burn,0))
		update_damage_overlays(0)
	updatehealth()

//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(brute, burn)
	var/list/obj/item/organ/limb/parts = get_damageable_organs()
	if(!parts.len)
		return
	var/obj/item/organ/limb/picked = pick(parts)
	if(picked.take_damage(brute,burn))
		update_damage_overlays(0)
	updatehealth()


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(brute, burn, updating_health=1)
	var/list/obj/item/organ/limb/parts = get_damaged_organs(brute,burn)

	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/limb/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute,burn,0)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	if(updating_health)
		updatehealth()
		if(update)
			update_damage_overlays(0)

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(brute, burn)
	if(status_flags & GODMODE)
		return	//godmode

	var/list/obj/item/organ/limb/parts = get_damageable_organs()
	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/limb/picked = pick(parts)
		var/brute_per_part = brute/parts.len
		var/burn_per_part = burn/parts.len

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam


		update |= picked.take_damage(brute_per_part,burn_per_part)

		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	if(update)
		update_damage_overlays(0)

/mob/living/carbon/human/proc/restore_blood()
	if(!(NOBLOOD in dna.species.specflags))
		var/blood_volume = vessel.get_reagent_amount("blood")
		vessel.add_reagent("blood",560-blood_volume)

////////////////////////////////////////////


/mob/living/carbon/human/proc/get_organ(zone)
	if(!zone)
		zone = "chest"
	for(var/obj/item/organ/limb/O in organs)
		if(O.name == zone)
			return O
	return null


/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = 0)
	// depending on the species, it will run the corresponding apply_damage code there
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src)
