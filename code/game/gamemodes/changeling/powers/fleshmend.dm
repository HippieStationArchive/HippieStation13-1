/obj/effect/proc_holder/changeling/fleshmend
	name = "Fleshmend"
	desc = "Our flesh rapidly regenerates, healing our wounds. Effectiveness decreases with quick, repeated use."
	helptext = "Heals a moderate amount of damage over a short period of time. Can be used while unconscious."
	chemical_cost = 25
	evopoints_cost = 4
	req_dna = 6 //Tier 3
	req_stat = UNCONSCIOUS
	var/recent_uses = 1 //The factor of which the healing should be divided by

/obj/effect/proc_holder/changeling/fleshmend/New()
	..()
	SSobj.processing.Add(src)

/obj/effect/proc_holder/changeling/fleshmend/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/effect/proc_holder/changeling/fleshmend/process()
	if(recent_uses > 1)
		recent_uses--

//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/obj/effect/proc_holder/changeling/fleshmend/sting_action(mob/living/user)
	user << "<span class='notice'>We begin to heal rapidly.</span>"
	if(recent_uses > 1)
		user << "<span class='warning'>Our healing's effectiveness is reduced by quickly repeated use!</span>"
	spawn(0)
		recent_uses++
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.restore_blood()
			H.remove_all_embedded_objects()
			if(H.get_missing_limbs())
				playsound(get_turf(H), 'sound/effects/blobattack.ogg', 30, 1)
				H.visible_message("<span class='warning'>[user]'s missing limbs reform, making a loud, grotesque sound!</span>", "<span class='userdanger'>Your limbs regrow, making a loud, crunchy sound and giving you great pain!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
				H.emote("scream")
				H.regenerate_limbs(ORGAN_ORGANIC, 1)

		for(var/i = 0, i < 10, i++) //The healing itself - doesn't heal toxin damage (that's anatomic panacea) and effectiveness decreases with each use in a short timespan
			if(user)
				user.adjustBruteLoss(-10 / recent_uses)
				user.adjustOxyLoss(-10 / recent_uses)
				user.adjustFireLoss(-10 / recent_uses)
			sleep(10)

	feedback_add_details("changeling_powers","RR")
	return 1
