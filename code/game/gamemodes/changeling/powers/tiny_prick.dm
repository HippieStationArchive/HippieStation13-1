/obj/effect/proc_holder/changeling/sting
	name = "Tiny Prick"
	desc = "Stabby stabby"
	var/sting_icon = null
	var/standing_req = 0 //If the target has to be standing
	var/conscious_req = 1 //If the sting can only be used on conscious targets
	var/alive_req = 1

/obj/effect/proc_holder/changeling/sting/Click()
	var/mob/user = usr
	if(!user || !user.mind || !user.mind.changeling)
		return
	if(!(user.mind.changeling.chosen_sting))
		set_sting(user)
	else
		unset_sting(user)
	return

/obj/effect/proc_holder/changeling/sting/proc/set_sting(mob/user)
	user << "<span class='notice'>We prepare our sting, use alt+click or middle mouse button on target to sting them.</span>"
	user.mind.changeling.chosen_sting = src
	user.hud_used.lingstingdisplay.icon_state = sting_icon
	user.hud_used.lingstingdisplay.invisibility = 0

/obj/effect/proc_holder/changeling/sting/proc/unset_sting(mob/user)
	user << "<span class='warning'>We retract our sting, we can't sting anyone for now.</span>"
	user.mind.changeling.chosen_sting = null
	user.hud_used.lingstingdisplay.icon_state = null
	user.hud_used.lingstingdisplay.invisibility = 101

/mob/living/carbon/proc/unset_sting()
	if(mind && mind.changeling && mind.changeling.chosen_sting)
		src.mind.changeling.chosen_sting.unset_sting(src)

/obj/effect/proc_holder/changeling/sting/can_sting(mob/user, mob/target)
	if(!..())
		return
	if(!user.mind.changeling.chosen_sting)
		user << "<span class='warning'>We haven't prepared our sting yet!</span>"
		return
	if(!iscarbon(target))
		user << "<span class='warning'>We may only sting carbon-based lifeforms!</span>"
		return
	if(!isturf(user.loc))
		return
	if(!AStar(user.loc, target.loc, null, /turf/proc/Distance, user.mind.changeling.sting_range))
		return
	if(standing_req && target.lying)
		user << "<span class='warning'>We can only use this sting on standing targets!</span>"
		return
	if(conscious_req && target.stat)
		user << "<span class='warning'>We can only use this sting on conscious targets!</span>"
		return
	if(alive_req && target.stat == DEAD) //Dead, i.e. cannot metabolize chemicals!
		user << "<span class='warning'>[target] is dead!</span>"
		return
	if(target.mind && target.mind.changeling)
		sting_feedback(user,target)
		take_chemical_cost(user.mind.changeling)
		return
	return 1

/obj/effect/proc_holder/changeling/sting/sting_feedback(mob/user, mob/target)
	if(!target)
		return
	user << "<span class='notice'>We stealthily sting [target.name].</span>"
	if(target.mind && target.mind.changeling)
		target << "<span class='warning'>You feel a tiny prick.</span>"
	return 1

/obj/effect/proc_holder/changeling/sting/transformation
	name = "Transformation Sting"
	desc = "We silently sting a human, injecting a retrovirus that forces them to transform."
	helptext = "The victim will transform much like a changeling would. The effects will be obvious to the victim, and the process will damage our genomes."
	sting_icon = "sting_transform"
	chemical_cost = 40
	evopoints_cost = 3
	req_dna = 3 //Tier 2
	alive_req = 0 //Can sting corpses
	standing_req = 0
	conscious_req = 0
	genetic_damage = 100
	var/datum/changelingprofile/selected_dna = null

/obj/effect/proc_holder/changeling/sting/transformation/Click()
	var/mob/user = usr
	var/datum/changeling/changeling = user.mind.changeling
	if(changeling.chosen_sting)
		unset_sting(user)
		return
	selected_dna = changeling.select_dna("Select the target DNA: ", "Target DNA")
	if(!selected_dna)
		return
	..()

/obj/effect/proc_holder/changeling/sting/transformation/can_sting(mob/user, mob/target)
	if(!..())
		return
	if((target.disabilities & HUSK) || !target.has_dna())
		user << "<span class='warning'>Our sting appears ineffective against its DNA.</span>"
		return 0
	return 1

/obj/effect/proc_holder/changeling/sting/transformation/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "transformation sting", " new identity is [selected_dna.dna.real_name]")
	var/datum/dna/NewDNA = selected_dna.dna
	if(ismonkey(target))
		user << "<span class='notice'>Our genes cry out as we sting [target.name]!</span>"

	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.status_flags & CANWEAKEN)
			C.do_jitter_animation(500)
			C.take_organ_damage(20, 0) //The process is extremely painful

		target.visible_message("<span class='danger'>[target] begins to violenty convulse!</span>","<span class='userdanger'>You feel a tiny prick and a begin to uncontrollably convulse!</span>")
		spawn(10)
			user.real_name = NewDNA.real_name
			NewDNA.transfer_identity(C, transfer_SE=1, noallow_cat=1)
			if(!istype(selected_dna.dna.species, /datum/species/human))
				C.humanize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE) //To keep lingstings from adding the monkey disability.
			C.updateappearance(mutcolor_update=1)
			C.domutcheck()
	feedback_add_details("changeling_powers","TS")
	return 1


/obj/effect/proc_holder/changeling/sting/false_armblade
	name = "False Armblade Sting"
	desc = "We silently sting a human, injecting a retrovirus that mutates their arm to temporarily appear as an armblade."
	helptext = "The victim will form an armblade much like a changeling would, except the armblade is dull and useless."
	sting_icon = "sting_armblade"
	chemical_cost = 40
	evopoints_cost = 3
	req_dna = 3 //Tier 2
	genetic_damage = 20
	max_genetic_damage = 10

/obj/item/weapon/melee/arm_blade/false
	desc = "A grotesque mass of flesh that used to be your arm. Although it looks dangerous at first, you can tell it's actually quite dull and useless."
	force = 5 //Basically as strong as a punch

/obj/item/weapon/melee/arm_blade/false/afterattack(atom/target, mob/user, proximity)
	return

/obj/effect/proc_holder/changeling/sting/false_armblade/can_sting(mob/user, mob/target)
	if(!..())
		return
	if((target.disabilities & HUSK) || !target.has_dna())
		user << "<span class='warning'>Our sting appears ineffective against its DNA.</span>"
		return 0
	return 1

/obj/effect/proc_holder/changeling/sting/false_armblade/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", object="falso armblade sting")

	if(!target.drop_item())
		user << "<span class='warning'>The [target.get_active_hand()] is stuck to their hand, you cannot grow a false armblade over it!</span>"
		return

	if(ismonkey(target))
		user << "<span class='notice'>Our genes cry out as we sting [target.name]!</span>"

	var/obj/item/weapon/melee/arm_blade/false/blade = new(target,1)
	if(target.put_in_hands(blade))
		target.visible_message("<span class='warning'>A grotesque blade forms around [target.name]\'s arm!</span>", "<span class='userdanger'>Your arm twists and mutates, transforming into a horrific monstrosity!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
		playsound(target, 'sound/effects/blobattack.ogg', 30, 1)

		spawn(600)
			playsound(target, 'sound/effects/blobattack.ogg', 30, 1)
			target.visible_message("<span class='warning'>With a sickening crunch, [target] reforms their [blade.name] into an arm!</span>", "<span class='warning'>[blade] reforms back to normal.</span>", "<span class='italics>You hear organic matter ripping and tearing!</span>")
			qdel(blade)
			user.update_inv_l_hand()
			user.update_inv_r_hand()

	feedback_add_details("changeling_powers","AS")
	return 1

/obj/effect/proc_holder/changeling/sting/mute
	name = "Mute Sting"
	desc = "We silently sting a human, completely silencing them for a short time."
	helptext = "Our target will not be alerted to their silence until they attempt to speak and cannot."
	sting_icon = "sting_mute"
	chemical_cost = 30
	evopoints_cost = 3

/obj/effect/proc_holder/changeling/sting/mute/sting_action(mob/user, mob/living/carbon/target)
	add_logs(user, target, "stung", "mute sting")
	target.reagents.add_reagent("mutetoxin", 5)
	feedback_add_details("changeling_powers","MS")
	return 1

/obj/effect/proc_holder/changeling/sting/blind
	name = "Blind Sting"
	desc = "We inject a serum that attacks and damages the eyes."
	helptext = "The victim will immediately be blinded for a short time in addition to becoming permanently nearsighted."
	sting_icon = "sting_blind"
	chemical_cost = 25
	evopoints_cost = 2

/obj/effect/proc_holder/changeling/sting/blind/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "blind sting")
	target << "<span class='userdanger'>Your eyes burn horrifically!</span>"
	target.disabilities |= NEARSIGHT
	target.eye_blind = 20
	target.eye_blurry = 40
	target.confused += 5 //Going instantaneously blind often makes one a little disoriented
	feedback_add_details("changeling_powers","BS")
	return 1

/obj/effect/proc_holder/changeling/sting/LSD
	name = "Hallucination Sting"
	desc = "Causes terror in the target."
	helptext = "We evolve the ability to sting a target with a powerful hallucinogenic chemical. The target does not notice they have been stung, and the effect occurs after 30 to 60 seconds."
	sting_icon = "sting_lsd"
	chemical_cost = 10
	evopoints_cost = 1

/obj/effect/proc_holder/changeling/sting/LSD/sting_action(mob/user, mob/living/carbon/target)
	add_logs(user, target, "stung", "LSD sting")
	spawn(rand(300,600))
		if(target)
			if(target.reagents)
				target.reagents.add_reagent("mindbreaker", 25)
	feedback_add_details("changeling_powers","HS")
	return 1

/obj/effect/proc_holder/changeling/sting/cryo
	name = "Cryogenic Sting"
	desc = "We silently sting a human with a cocktail of chemicals that freeze them."
	helptext = "This will provide an ambiguous warning to the victim after a short time. Reccomended to be used more than once on the same victim."
	sting_icon = "sting_cryo"
	chemical_cost = 25
	evopoints_cost = 3
	conscious_req = 0 //Can be used on the unconscious

/obj/effect/proc_holder/changeling/sting/cryo/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "cryo sting")
	if(target.reagents)
		target.reagents.add_reagent("frostoil", 10)
	spawn(100)
		if(target)
			if(!target.stat)
				target << "<span class='warning'>You feel strangely cold. Goosebumps break out across your skin.</span>"
			else
				target << "<span class='notice'><b>It's so cold.</b></span>" //Give a spookier message if they're unconscious
	feedback_add_details("changeling_powers","CS")
	return 1

/obj/effect/proc_holder/changeling/sting/paralysis
	name = "Paralysis Sting"
	desc = "We inject a human with a powerful muscular inhibitor, preventing their movement after a short time."
	helptext = "They will still be able to speak while paralyzed. The paralysis will last for around fifteen seconds."
	sting_icon = "sting_paralysis"
	chemical_cost = 30
	evopoints_cost = 4
	req_dna = 3 //Tier 2
	standing_req = 1

/obj/effect/proc_holder/changeling/sting/paralysis/sting_action(mob/user, mob/living/target)
	add_logs(user, target, "stung", "parasting")
	user << "<span class='notice'>The paralysis will take effect more quickly depending on their wounds.</span>"
	// target << "<span class='warning'>Your body begins throbbing with a painful ache...</span>" //No target warning so it can be used as a stealth-sting.
	var/time_to_wait = target.health
	time_to_wait += 50 //The target's health, plus five seconds - a fully healed human will take fifteen seconds to begin experiencing the effects
	time_to_wait = Clamp(time_to_wait, 0, INFINITY)
	spawn(time_to_wait)
		if(target && !target.lying) //So you can't spam parastings if they're already on the ground
			target << "<span class='userdanger'>Your muscles painfully seize up! You can't move!</span>"
			target.Weaken(15)
			target.Stun(15)
	feedback_add_details("changeling_powers", "PS")
	return 1

/obj/effect/proc_holder/changeling/sting/purge
	name = "Purge Sting"
	desc = "We inject calomel into our victim to completely purge all of their chemicals and cause some toxin damage."
	helptext = "Our victim will have all of their chemicals removed from the body. It also deals toxin damage to victims in good condition."
	sting_icon = "sting_poison"
	req_dna = 3 //Tier 2
	chemical_cost = 20
	evopoints_cost = 3 //Purgin' is good ok?

/obj/effect/proc_holder/changeling/sting/purge/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "purge sting")
	if(target.reagents)
		target.reagents.add_reagent("calomel", 15)
		feedback_add_details("changeling_powers", "PS")
	return 1