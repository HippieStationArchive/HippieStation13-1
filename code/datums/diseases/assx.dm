//Assfarts!

/datum/disease/assinspection
	form = "Condition"
	name = "GBA"
	max_stages = 3
	cure_text = "Surgery"
	spread_text = "Unknown"
	agent = "ASS-X 095"
	desc = "Report to Medical Bay for Ass Inspection"
	severity = "It will eventually pass out of your system, with your ass as well."
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = SPECIAL
	visibility_flags = HIDDEN_PANDEMIC
	permeability_mod = 1
	stage_prob = 5 //slightly increased stage probability to make it more effective

/datum/disease/assinspection/New()
	..()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/butt/B = null
		B = locate() in H.internal_organs
		if(!B)
			cure()
			return

/datum/disease/assinspection/stage_act()
	..()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/butt/B = null
		B = locate() in H.internal_organs
		if(!B)
			cure()
			return
	switch(stage)
		if(1)
			if(prob(5))
				affected_mob << "<span class='danger'>Your ass itches.</span>"
		if(2)
			if(prob(10))
				affected_mob << "<span class='danger'>You feel a lot of pressure behind you.</span>"
				affected_mob.apply_damage(5, BRUTE)
			else if(prob(5))
				affected_mob << "<span class='danger'>Oh the pain! The cruel, yet ironic, pain!</span>"

			if(prob(5))
				affected_mob.say(pick("WOOP!", "ASS INSPECTION!", "SON OF A CLOWN IT HURTS!", "WOOP WOOP!", "SON OF A COMDOM!", "BRING ME TO THE MEDICAL BAY!", "I NEED AN ASS INSPECTION!" ))
			else if(prob(5))
				affected_mob.say(pick(";WOOP!", ";ASS INSPECTION!", ";SON OF A CLOWN IT HURTS!", ";WOOP WOOP!", ";SON OF A COMDOM!", ";BRING ME TO THE MEDICAL BAY!", ";I NEED AN ASS INSPECTION!" ))
		if(3)
			affected_mob.say(";MY ASS! IT'S GOING TO BLOW!!")
			affected_mob.emote("scream")
			affected_mob << "<span class='danger'>You feel extreme pressure behind you!</span>"
			affected_mob.apply_damage(40, BRUTE, "chest")
			cure()
			affected_mob.spam_flag = 0 //So you can scream AND superfart with no delay!
			affected_mob.emote("superfart") //Superfart AFTER disease is cured.


/datum/disease/assinspectionplacebo
	form = "Condition"
	name = "GBA"
	max_stages = 3
	cure_text = "Surgery"
	spread_text = "Unknown"
	agent = "ASS-X 094-F"
	desc = "Report to Medical Bay for Ass Inspection"
	severity = "It will eventually pass out of your system, with your ass as well."
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = SPECIAL
	visibility_flags = HIDDEN_PANDEMIC
	permeability_mod = 1

/datum/disease/assinspectionplacebo/New()
	..()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/butt/B = null
		B = locate() in H.internal_organs
		if(!B)
			cure()
			return

/datum/disease/assinspectionplacebo/stage_act()
	..()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/butt/B = null
		B = locate() in H.internal_organs
		if(!B)
			cure()
			return
	switch(stage)
		if(1)
			if(prob(5))
				affected_mob << "<span class='danger'>Your ass itches.</span>"
		if(2)
			if(prob(10))
				affected_mob << "<span class='danger'>You feel some pressure behind you.</span>"
				// affected_mob.apply_damage(5, BRUTE)
			else if(prob(5))
				affected_mob << "<span class='danger'>Oh the pain! The cruel, yet ironic, pain!</span>"

			if(prob(5))
				affected_mob.say(pick("WOOP!", "ASS INSPECTION!", "SON OF A CLOWN IT DOESN'T HURT!", "WOOP WOOP!", "SON OF A COMDOM!", "BRING ME TO THE MEDICAL BAY!", "I NEED AN ASS INSPECTION!" ))
			else if(prob(5))
				affected_mob.say(pick(";WOOP!", ";ASS INSPECTION!", ";SON OF A CLOWN IT DOESN'T HURT", ";WOOP WOOP!", ";SON OF A COMDOM!", ";BRING ME TO THE MEDICAL BAY!", ";I NEED AN ASS INSPECTION!" ))
		if(3)
			affected_mob <<"<span class='danger'>You feel you should get an Ass Inspection in Medical Bay.</span>"
			affected_mob.say(pick("WHY DO I STILL HAVE AN ASS!?!", "FUCK ITS FAKE!" ))
			cure()