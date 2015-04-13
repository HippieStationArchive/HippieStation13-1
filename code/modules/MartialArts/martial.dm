/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/current_target = null
	var/priority = 0 //Having multiple same-priority martial arts on same guy is not very good, so try to avoid that.

/datum/martial_art/proc/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/tablepush_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D) //Called when you tablepush someone
	return 0

/datum/martial_art/proc/onEquip(var/mob/living/carbon/human/H) //Called when martial art was "equipped". Used for wrassling belt.
	return 0

/datum/martial_art/proc/onDropped(var/mob/living/carbon/human/H) //Called when martial art was "dropped". Used for wrassling belt.
	return 0

/datum/martial_art/proc/add_to_streak(var/element,var/mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	return

/datum/martial_art/proc/basic_hit(var/mob/living/carbon/human/A,var/mob/living/carbon/human/D, var/damage = rand(0,9))
	add_logs(A, D, "punched")
	A.do_attack_animation(D)
	var/atk_verb = "punch"
	if(D.lying)
		atk_verb = "kick"
	else if(A.dna)
		atk_verb = A.dna.species.attack_verb

	if(A.dna)
		damage += A.dna.species.punchmod

	if(!damage)
		if(A.dna)
			playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		else
			playsound(D.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>")
		return 0

	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")

	if(A.dna)
		playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)
	else
		playsound(D.loc, 'sound/weapons/punch1.ogg', 25, 1, -1)

	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
								"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>")

	D.apply_damage(damage, BRUTE, affecting, armor_block)
	if((D.stat != DEAD) && damage >= 9)
		D.visible_message("<span class='danger'>[A] has weakened [D]!!</span>", \
								"<span class='userdanger'>[A] has weakened [D]!</span>")
		D.apply_effect(4, WEAKEN, armor_block)
		D.forcesay(hit_appends)
	else if(D.lying)
		D.forcesay(hit_appends)
	return 1

// HUMAN METHODS

/mob/living/carbon/human/proc/update_martial_art()

	// The order of checks here allows for one martial art to have precedence over another.
	// Weaker martial arts should propser, so that you can't wrestle the shit out of people while wearing boxing gloves.
	// Maybe this could be better.

	martial_art = null
	var/priority = -1

	for (var/datum/martial_art/I in martial_arts)
		if (I.priority > priority)
			martial_art = I
			priority = I.priority