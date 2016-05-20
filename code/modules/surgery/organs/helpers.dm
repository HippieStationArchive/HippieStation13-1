/mob/proc/getorgan(typepath)
	return

/mob/proc/getorganszone(zone)
	return

/mob/proc/getorganslot(slot)
	return

/mob/proc/getrandomorgan(zone, prob)
	return

/mob/proc/regenerate_limbs()
	return

/mob/proc/get_missing_limbs()

/mob/living/carbon/getorgan(typepath)
	return (locate(typepath) in internal_organs)

/mob/living/carbon/getorganszone(zone, var/subzones = 0)
	var/list/returnorg = list()
	if(subzones)
		// Include subzones - groin for chest, eyes and mouth for head
		if(zone == "head")
			returnorg = getorganszone("eyes") + getorganszone("mouth")
		if(zone == "chest")
			returnorg = getorganszone("groin")

	for(var/obj/item/organ/internal/O in internal_organs)
		if(zone == O.zone)
			returnorg += O
	return returnorg

/mob/living/carbon/getorganslot(slot)
	for(var/obj/item/organ/internal/O in internal_organs)
		if(slot == O.slot)
			return O

/mob/living/carbon/human/getrandomorgan(zone, prob) //This is the same as get_organ(ran_zone) but it also makes sure that organ is actually attached/exists
	var/list/exceptions = list("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg")
	for(var/obj/item/organ/limb/L in organs)
		if(Bodypart2name(L) in exceptions)
			exceptions -= L
	return get_organ(ran_zone(zone, prob, exceptions))

//Regenerates all limbs. Returns amount of limbs regenerated
/mob/living/carbon/human/regenerate_limbs(new_type, noheal=0)
	. = 0
	var/list/full = list("head", "chest", "r_arm", "l_arm", "r_leg", "l_leg")
	for(var/t in full)
		var/obj/item/organ/limb/L = get_organ(t)
		if(!(L in organs))
			L = newBodyPart(t)
			L.loc = src
			L.owner = src
			organs += L
			.++
		L.change_organ(new_type ? new_type : L.status, noheal)
	return .

/mob/living/carbon/human/get_missing_limbs()
	var/list/full = list("head", "chest", "r_arm", "l_arm", "r_leg", "l_leg")
	var/list/missing = list()
	for(var/t in full)
		var/obj/item/organ/limb/L = get_organ(t)
		if(!(L in organs))
			missing += L
	return missing

/mob/proc/getlimb()
	return

/mob/living/carbon/human/getlimb(typepath)
	return (locate(typepath) in organs)

/proc/isorgan(atom/A)
	return istype(A, /obj/item/organ/internal)