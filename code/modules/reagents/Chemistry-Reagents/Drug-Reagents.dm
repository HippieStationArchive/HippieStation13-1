

/datum/reagent/drug
	name = "Drug"
	id = "drug"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/drug/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30

/datum/reagent/drug/space_drugs/on_mob_life(mob/living/M)
	M.druggy = max(M.druggy, 15)
	if(isturf(M.loc) && !istype(M.loc, /turf/space))
		if(M.canmove)
			if(prob(10)) step(M, pick(cardinal))
	if(prob(7))
		M.emote(pick("twitch","drool","moan","giggle"))
	..()
	return

/datum/reagent/drug/space_drugs/overdose_start(mob/living/M)
	M << "<span class='userdanger'>You start tripping hard!</span>"


/datum/reagent/drug/space_drugs/overdose_process(mob/living/M)
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
	..()
	return

/datum/reagent/drug/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "Slightly reduces stun times. If overdosed it will deal toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	addiction_threshold = 30

/datum/reagent/drug/nicotine/on_mob_life(mob/living/M)
	if(prob(1))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		M << "<span class='notice'>[smoke_message]</span>"
	M.AdjustStunned(-1)
	M.adjustStaminaLoss(-0.5*REM)
	..()

/datum/reagent/drug/crank
	name = "Crank"
	id = "crank"
	description = "Reduces stun times by about 200%. If overdosed or addicted it will deal significant Toxin, Brute and Brain damage."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 20
	addiction_threshold = 10

/datum/reagent/drug/crank/on_mob_life(mob/living/M)
	var/high_message = pick("You feel jittery.", "You feel like you gotta go fast.", "You feel like you need to step it up.")
	var/tolerance_message = pick("You feel uncomfortable.", "You feel like you're too slow.", "You feel like you don't want to go fast anymore.")
	if(current_cycle <= 100)
		if(prob(5))
			M << "<span class='notice'>[high_message]</span>"
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
	if(current_cycle > 100)
		if(prob(15))
			M << "<span class='notice'>[tolerance_message]</span>"
		M.adjustStaminaLoss(2)
	M.Jitter(1)
	..()
	
/datum/reagent/drug/crank/on_mob_delete(mob/living/M)
	M.adjustToxLoss(min(current_cycle*0.1*REM, 50))
	if(current_cycle >= 5)
		M.visible_message("<span class='danger'>[M] staggers and falls!</span>")
		M.AdjustWeakened(5)
		M.AdjustStunned(5)
		M.adjustStaminaLoss(20)
	else
		M.adjustStaminaLoss(current_cycle*4)
	return

/datum/reagent/drug/crank/overdose_process(mob/living/M)
	M.adjustBrainLoss(2*REM)
	M.adjustToxLoss(2*REM)
	M.adjustBruteLoss(2*REM)
	..()

/datum/reagent/drug/crank/addiction_act_stage1(mob/living/M)
	M.adjustBrainLoss(5*REM)
	..()

/datum/reagent/drug/crank/addiction_act_stage2(mob/living/M)
	M.adjustToxLoss(5*REM)
	..()

/datum/reagent/drug/crank/addiction_act_stage3(mob/living/M)
	M.adjustBruteLoss(5*REM)
	..()

/datum/reagent/drug/crank/addiction_act_stage4(mob/living/M)
	M.adjustBrainLoss(5*REM)
	M.adjustToxLoss(5*REM)
	M.adjustBruteLoss(5*REM)
	..()

/datum/reagent/drug/krokodil
	name = "Krokodil"
	id = "krokodil"
	description = "Cools and calms you down. If overdosed it will deal significant Brain and Toxin damage. If addicted it will begin to deal fatal amounts of Brute damage as the subject's skin falls off."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 20
	addiction_threshold = 15


/datum/reagent/drug/krokodil/on_mob_life(mob/living/M)
	var/high_message = pick("You feel calm.", "You feel collected.", "You feel like you need to relax.")
	if(prob(5))
		M << "<span class='notice'>[high_message]</span>"
	..()
	return

/datum/reagent/drug/krokodil/overdose_process(mob/living/M)
	M.adjustBrainLoss(0.25*REM)
	M.adjustToxLoss(0.25*REM)
	..()
	return


/datum/reagent/drug/krokodil/addiction_act_stage1(mob/living/M)
	M.adjustBrainLoss(2*REM)
	M.adjustToxLoss(2*REM)
	..()
	return
/datum/reagent/krokodil/addiction_act_stage2(mob/living/M)
	if(prob(25))
		M << "<span class='danger'>Your skin feels loose...</span>"
	..()
	return
/datum/reagent/drug/krokodil/addiction_act_stage3(mob/living/M)
	if(prob(25))
		M << "<span class='danger'>Your skin starts to peel away...</span>"
	M.adjustBruteLoss(3*REM)
	..()
	return

/datum/reagent/drug/krokodil/addiction_act_stage4(mob/living/carbon/human/M)
	if(M.has_dna() && M.dna.species.id != "zombie")
		M << "<span class='userdanger'>Your skin falls off easily!</span>"
		M.adjustBruteLoss(50*REM) // holy shit your skin just FELL THE FUCK OFF
		M.set_species(/datum/species/cosmetic_zombie)
	else
		M.adjustBruteLoss(5*REM)
	..()
	return

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine"
	id = "methamphetamine"
	description = "Halves the duration of stuns and greatly increases movement speed. However, it drains an ever-increasing amount of stamina over time and being stunned will force the body to metabolize the drug faster."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		M << "<span class='notice'>[high_message]</span>"
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	M.adjustStaminaLoss(4) // Is actually -2 per tick, humans regenerate 2 per tick
	M.adjustToxLoss(0.4*REM)
	M.status_flags |= GOTTAGOREALLYFAST
	M.sleeping = max(0,M.sleeping - 3)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	M.Jitter(2)

	if(M.stunned || M.weakened)
		metabolization_rate = 1.5 * REAGENTS_METABOLISM
	else if(holder.has_reagent("heroin"))
		metabolization_rate = 5 * REAGENTS_METABOLISM
		M.adjustToxLoss(1.2*REM)
	else
		metabolization_rate= 0.75 * REAGENTS_METABOLISM
	..()
	return

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/M)
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 4, i++)
			step(M, pick(cardinal))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
	..()
	M.adjustToxLoss(0.6*REM)
	M.adjustBrainLoss(1*REM)
	return


/datum/reagent/drug/heroin
	name = "Heroin"
	id = "heroin"
	description = "An extremely potent painkiller which allows you to move at full speed regardless of injuries. However, the duration of all stuns is doubled."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/drug/heroin/on_mob_life(mob/living/M)
	var/high_message = pick("You feel numb.", "You feel no pain whatsoever.", "You don't feel your wounds at all.", "You feel perfect.")
	if(prob(5))
		M << "<span class='notice'>[high_message]</span>"
	M.setStaminaLoss(0)
	if(M.health > 0)
		M.status_flags |= IGNORESLOWDOWN
	else
		M.status_flags &= ~IGNORESLOWDOWN
	M.adjustToxLoss(0.4*REM)
	M.Jitter(2)
	M.adjustBrainLoss(0.4*REM)
	if(prob(10))
		M.emote(pick("twitch", "shiver"))
	if(M.stunned)
		M.AdjustStunned(0.5) //Doubles the duration of stuns
	if(M.weakened)
		M.AdjustWeakened(0.5) //Doubles the duration of weakens

	if(holder.has_reagent("methamphetamine"))
		metabolization_rate = 5 * REAGENTS_METABOLISM
		M.adjustBrainLoss(1.6*REM)
	else
		metabolization_rate = 0.5 * REAGENTS_METABOLISM
	..()
	return

/datum/reagent/drug/heroin/overdose_process(mob/living/M)
	if(current_cycle > 5)
		M.sleeping += 1
	if(prob(20))
		M.emote("yawn")
	if(prob(12))
		M.adjustToxLoss(1)
		M.adjustBrainLoss(2)
	..()
	return

/datum/reagent/drug/bath_salts
	name = "Bath Salts"
	id = "bath_salts"
	description = "Makes you nearly impervious to stuns and grants a stamina regeneration buff, but you will be a nearly uncontrollable tramp-bearded raving lunatic."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 15
	addiction_threshold = 10


/datum/reagent/drug/bath_salts/on_mob_life(mob/living/M)
	var/high_message = pick("You feel your grip on reality loosening.", "You feel like your heart is beating out of control.", "You feel as if you're about to die.")
	if(prob(15))
		M << "<span class='notice'>[high_message]</span>"
	if(current_cycle >= 5)
		M.AdjustParalysis(-6)
		M.AdjustStunned(-6)
		M.AdjustWeakened(-6)
		M.adjustStaminaLoss(-10)
	if(holder.has_reagent("synaptizine"))
		holder.remove_reagent("synaptizine", 5)
		M.hallucination += 5
	M.adjustBrainLoss(0.2)
	M.adjustToxLoss(min(0.1+(current_cycle/50),1))
	M.status_flags |= GOTTAGOFAST
	M.hallucination += 7.5
	M.Jitter(4)
	if(M.canmove && !istype(M.loc, /atom/movable))
		step(M, pick(cardinal))
		step(M, pick(cardinal))
	..()
	return
	
/datum/reagent/drug/bath_salts/on_mob_delete(mob/living/M)
	M.adjustToxLoss(min(current_cycle*1.5*REM,195))
	M.adjustBrainLoss(current_cycle*0.8*REM)
	if(current_cycle >= 5)
		M.visible_message("<span class='danger'>[M] goes pale and collapses!</span>")
		M.AdjustWeakened(8)
		M.AdjustStunned(8)
		M.adjustStaminaLoss(50)
	else
		M.adjustStaminaLoss(current_cycle*10)
	return

/datum/reagent/drug/bath_salts/overdose_process(mob/living/M)
	M.hallucination += 10
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 8, i++)
			step(M, pick(cardinal))
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
	..()
	return

/datum/reagent/drug/bath_salts/addiction_act_stage1(mob/living/M)
	M.hallucination += 10
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 8, i++)
			step(M, pick(cardinal))
	M.Jitter(5)
	M.adjustBrainLoss(10)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()
	return
/datum/reagent/drug/bath_salts/addiction_act_stage2(mob/living/M)
	M.hallucination += 20
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 8, i++)
			step(M, pick(cardinal))
	M.Jitter(10)
	M.Dizzy(10)
	M.adjustBrainLoss(10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()
	return
/datum/reagent/drug/bath_salts/addiction_act_stage3(mob/living/M)
	M.hallucination += 30
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 12, i++)
			step(M, pick(cardinal))
	M.Jitter(15)
	M.Dizzy(15)
	M.adjustBrainLoss(10)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()
	return
/datum/reagent/drug/bath_salts/addiction_act_stage4(mob/living/carbon/human/M)
	M.hallucination += 40
	if(M.canmove && !istype(M.loc, /atom/movable))
		for(var/i = 0, i < 16, i++)
			step(M, pick(cardinal))
	M.Jitter(50)
	M.Dizzy(50)
	M.adjustToxLoss(5)
	M.adjustBrainLoss(10)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	return

/datum/reagent/drug/aranesp
	name = "Aranesp"
	id = "aranesp"
	description = "Amps you up and gets you going, fixes all stamina damage you might have but can cause toxin and oxygen damage.."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132

/datum/reagent/drug/aranesp/on_mob_life(mob/living/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		M << "<span class='notice'>[high_message]</span>"
	M.adjustStaminaLoss(-18)
	M.adjustToxLoss(0.5)
	if(prob(50))
		M.losebreath++
		M.adjustOxyLoss(1)
	..()
	return

/datum/reagent/drug/fartium
	name = "Fartium"
	id = "fartium"
	description = "A chemical compound that promotes concentrated production of gas in your groin area."
	color = "#8A4B08" // rgb: 138, 75, 8
	reagent_state = LIQUID
	overdose_threshold = 30
	addiction_threshold = 50

/datum/reagent/drug/fartium/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/butt/B = locate() in H.internal_organs
		if(prob(7))
			if(B)
				H.emote("fart")
			else
				H << "<span class='danger'>Your stomach rumbles as pressure builds up inside of you.</span>"
				H.adjustToxLoss(1*REM)
	..()
	return

/datum/reagent/drug/fartium/overdose_process(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/butt/B = locate() in H.internal_organs
		if(prob(9))
			if(B)
				H.emote("fart")
			else
				H << "<span class='danger'>Your stomach hurts a bit as pressure builds up inside of you.</span>"
				H.adjustToxLoss(2*REM)
	..()

/datum/reagent/drug/fartium/addiction_act_stage1(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/butt/B = locate() in H.internal_organs
		if(prob(11))
			if(B)
				H.emote("fart")
			else
				H << "<span class='danger'>Your stomach hurts as pressure builds up inside of you.</span>"
				H.adjustToxLoss(3*REM)
	..()

/datum/reagent/drug/fartium/addiction_act_stage2(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/butt/B = locate() in H.internal_organs
		if(prob(13))
			if(B)
				H.emote("fart")
			else
				H << "<span class='danger'>Your stomach hurts a lot as pressure builds up inside of you.</span>"
				H.adjustToxLoss(4*REM)
	..()

/datum/reagent/drug/fartium/addiction_act_stage3(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/butt/B = locate() in H.internal_organs
		if(prob(15))
			if(B)
				if(prob(2) && !B.loose) H.emote("superfart")
				else H.emote("fart")
			else
				H << "<span class='danger'>Your stomach hurts too much as pressure builds up inside of you.</span>"
				H.adjustToxLoss(5*REM)
	..()

/datum/reagent/drug/fartium/addiction_act_stage4(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/butt/B = locate() in H.internal_organs
		if(prob(15))
			if(B)
				if(prob(5) && !B.loose) H.emote("superfart")
				else H.emote("fart")
			else
				H << "<span class='danger'>Your stomach hurts too much as pressure builds up inside of you.</span>"
				H.adjustToxLoss(6*REM)
	..()
