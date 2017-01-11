
//////////////////////////////////////////////////////////////////////////////////////////
					// MEDICINE REAGENTS
//////////////////////////////////////////////////////////////////////////////////////

// where all the reagents related to medicine go.

/datum/reagent/medicine
	name = "Medicine"
	id = "medicine"

/datum/reagent/medicine/on_mob_life(mob/living/M)
	current_cycle++
	if(M && M.metabolism_efficiency)
		holder.remove_reagent(src.id, metabolization_rate / M.metabolism_efficiency) //medicine reagents stay longer if you have a better metabolism

/datum/reagent/medicine/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine will effectively regulate a patient's body temperature, ensuring it never leaves safe levels."
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/medicine/leporazine/on_mob_life(mob/living/M)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()

/datum/reagent/medicine/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/medicine/adminordrazine/on_mob_life(mob/living/carbon/M)
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.radiation = 0
	M.heal_organ_damage(5,5,2)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetWeakened(0)
	M.SetStunned(0)
	M.SetParalysis(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.slurring = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	for(var/datum/disease/D in M.viruses)
		if(D.severity == NONTHREAT)
			continue
		D.spread_text = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()
	..()
	return

/datum/reagent/medicine/adminordrazine/nanites
	name = "Nanites"
	id = "nanites"
	description = "Tiny nanomachines capable of rapid cellular regeneration."

/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Helps cure hallucinations and reduces drowsiness."
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/medicine/synaptizine/on_mob_life(mob/living/M)
	M.drowsyness = max(M.drowsyness-5, 0)
	if(holder.has_reagent("mindbreaker"))
		holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	/*
	if(prob(20))
		M.adjustToxLoss(2)
		M.AdjustParalysis(-2)
		M.AdjustStunned(-2)
		M.AdjustWeakened(-2)
	*/
	..()
	return

/datum/reagent/medicine/inacusiate
	name = "Inacusiate"
	id = "inacusiate"
	description = "Instantly restores all hearing to the patient, but does not cure deafness."
	color = "#6600FF" // rgb: 100, 165, 255

/datum/reagent/medicine/inacusiate/on_mob_life(mob/living/M)
	M.setEarDamage(0,0)
	..()
	return

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the patient's body temperature must be under 230K for it to metabolise correctly."
	color = "#0000C8"

/datum/reagent/medicine/cryoxadone/on_mob_life(mob/living/M)
	if(M.stat != DEAD && M.bodytemperature < 230)
		M.adjustCloneLoss(-4)
		M.adjustOxyLoss(-10)
		M.adjustBruteLoss(-3)
		M.adjustBloodLoss(-0.02)
		M.adjustFireLoss(-3)
		M.adjustToxLoss(-3)
		M.status_flags &= ~DISFIGURED
	..()
	return

/datum/reagent/medicine/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A stronger version of Cryoxadone that only metabolizes in extremely low temperatures below 130K."
	color = "#0000C8"

/datum/reagent/medicine/clonexadone/on_mob_life(mob/living/M)
	if(M.stat != DEAD && M.bodytemperature < 130)
		M.adjustCloneLoss(-12)
		M.adjustOxyLoss(-10)
		M.adjustBruteLoss(-5)
		M.adjustBloodLoss(-0.02)
		M.adjustFireLoss(-5)
		M.adjustToxLoss(-5)
		M.status_flags &= ~DISFIGURED
	..()
	return

/datum/reagent/medicine/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, Rezadone can effectively treat genetic damage as well as restoring minor wounds. Overdose will cause intense nausea and minor toxin damage."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose_threshold = 30

/datum/reagent/medicine/rezadone/on_mob_life(mob/living/M)
	M.setCloneLoss(0) //Rezadone is almost never used in favor of cryoxadone. Hopefully this will change that.
	M.heal_organ_damage(1,1,0.01)
	M.status_flags &= ~DISFIGURED
	..()
	return

/datum/reagent/medicine/rezadone/overdose_process(mob/living/M)
	M.adjustToxLoss(1)
	M.Dizzy(5)
	M.Jitter(5)
	..()
	return

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "Spaceacillin will prevent a patient from conventionally spreading any diseases they are currently infected with."
	color = "#C8A5DC" // rgb: 200, 165, 220
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

//Goon Chems. Ported mainly from Goonstation. Easily mixable (or not so easily) and provide a variety of effects.
/datum/reagent/medicine/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	id = "silver_sulfadiazine"
	description = "If used in touch-based applications, immediately restores burn wounds. If ingested through other means, deals minor toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/medicine/silver_sulfadiazine/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			M.adjustToxLoss(0.5*reac_volume)
			if(show_message)
				M << "<span class='warning'>You don't feel so good...</span>"
		else if(M.getFireLoss())
			M.adjustFireLoss(max(-reac_volume, -30))
			if(show_message)
				M << "<span class='danger'>You feel your burns healing! It stings like hell!</span>"
			M.emote("scream")
	..()


/datum/reagent/medicine/oxandrolone
	name = "Oxandrolone"
	id = "oxandrolone"
	description = "Stimulates the healing of severe burns. Heals severe burns extremely rapidly and slowly heals minor ones. Overdose will worsen existing burns."
	reagent_state = LIQUID
	color = "#f7ffa5"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/oxandrolone/on_mob_life(mob/living/M)
	if(M.getFireLoss() > 50)
		M.adjustFireLoss(-4*REM) //Twice as effective as silver sulfadiazine for severe burns
	else
		M.adjustFireLoss(-0.5*REM) //But only a quarter as effective for more minor ones
	..()
	return

/datum/reagent/medicine/oxandrolone/overdose_process(mob/living/M)
	if(M.getFireLoss()) //It only makes existing burns worse
		M.adjustFireLoss(4.5*REM) // it's going to be healing either 4 or 0.5
	..()
	return


/datum/reagent/medicine/styptic_powder
	name = "Styptic Powder"
	id = "styptic_powder"
	description = "If used in touch-based applications, immediately restores bruising. If ingested through other means, deals minor toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/medicine/styptic_powder/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			M.adjustToxLoss(0.5*reac_volume)
			if(show_message)
				M << "<span class='warning'>You don't feel so good...</span>"
		else if(M.getBruteLoss())
			M.adjustBruteLoss(max(-reac_volume, -30))
			M.adjustBloodLoss(-reac_volume/10)
			if(show_message)
				M << "<span class='danger'>You feel your wounds knitting back together!</span>"
			M.emote("scream")
	..()


/datum/reagent/medicine/salglu_solution
	name = "Saline-Glucose Solution"
	id = "salglu_solution"
	description = "Heals a small amount of brute and burn damage per cycle. Can be used as a blood substitute on an IV drip."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/medicine/salglu_solution/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.5*REM)
	M.adjustBloodLoss(-0.1*REM)
	M.adjustFireLoss(-0.5*REM)
	..()

/datum/reagent/medicine/salglu_solution/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && method == INJECT)
		var/mob/living/carbon/human/H = M
		//The lower the blood of the patient, the better it is as a blood substitute.
		var/efficiency = (560-H.vessel.get_reagent_amount("blood"))/700 + 0.2
		efficiency = min(0.75,efficiency)
		//As it's designed for an IV drip, make large injections not as effective as repeated small injections.
		H.vessel.add_reagent("blood", efficiency * min(5,reac_volume))
	..()

/datum/reagent/medicine/mine_salve
	name = "Miner's Salve"
	id = "mine_salve"
	description = "A powerful painkiller. Restores bruising and burns in addition to making the patient believe they are fully healed."
	reagent_state = LIQUID
	color = "#6D6374"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM

/datum/reagent/medicine/mine_salve/on_mob_life(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = 5
	M.adjustBruteLoss(-0.25*REM)
	M.adjustFireLoss(-0.25*REM)
	..()

/datum/reagent/medicine/mine_salve/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			M.adjustStaminaLoss(3*reac_volume)
			if(show_message)
				M << "<span class='warning'>Your stomach agonizingly cramps!</span>"
		else
			if(show_message)
				M << "<span class='danger'>You feel your wounds fade away to nothing!</span>" //It's a painkiller, after all
	..()

/datum/reagent/medicine/mine_salve/on_mob_delete(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = 0
	..()

/datum/reagent/medicine/synthflesh
	name = "Synthflesh"
	id = "synthflesh"
	description = "Has a 100% chance of instantly healing brute and burn damage. One unit of the chemical will heal one point of damage. Also heals bloodloss completely. Touch application only."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/medicine/synthflesh/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(PATCH, TOUCH))
			M.adjustBruteLoss(-1 * reac_volume)
			M.adjustBloodLoss(-M.getBloodLoss()) //Heal bloodloss completely
			M.adjustFireLoss(-1 * reac_volume)
			M.adjustStaminaLoss(1.5 * reac_volume)
			if(show_message)
				M << "<span class='danger'>You feel your burns healing and your flesh knitting together!</span>"
	..()


/datum/reagent/medicine/charcoal
	name = "Charcoal"
	id = "charcoal"
	description = "Heals toxin damage as well as slowly removing any other chemicals the patient has in their bloodstream."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/charcoal/on_mob_life(mob/living/M)
	M.adjustToxLoss(-2*REM)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,1)
	..()
	return

/datum/reagent/medicine/omnizine
	name = "Omnizine"
	id = "omnizine"
	description = "Slowly heals all damage types. Overdose will cause damage in all types instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/omnizine/on_mob_life(mob/living/M)
	M.adjustToxLoss(-0.5*REM)
	M.adjustOxyLoss(-0.5*REM)
	M.adjustBruteLoss(-0.5*REM)
	M.adjustBloodLoss(-0.01*REM)
	M.adjustFireLoss(-0.5*REM)
	..()
	return

/datum/reagent/medicine/omnizine/overdose_process(mob/living/M)
	M.adjustToxLoss(1.5*REM)
	M.adjustOxyLoss(1.5*REM)
	M.adjustBruteLoss(1.5*REM)
	M.adjustFireLoss(1.5*REM)
	..()
	return

/datum/reagent/medicine/calomel
	name = "Calomel"
	id = "calomel"
	description = "Quickly purges the body of all chemicals. Toxin damage is dealt if the patient is in good condition."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/calomel/on_mob_life(mob/living/M)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,2.5)
			M.client.dir = NORTH
	if(M.health > 20)
		M.adjustToxLoss(2.5*REM)
	..()
	return

/datum/reagent/medicine/potass_iodide
	name = "Potassium Iodide"
	id = "potass_iodide"
	description = "Efficiently restores low radiation damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/medicine/potass_iodide/on_mob_life(mob/living/M)
	if(M.radiation > 0)
		M.radiation--
	if(M.radiation < 0)
		M.radiation = 0
	..()
	return

/datum/reagent/medicine/pen_acid
	name = "Pentetic Acid"
	id = "pen_acid"
	description = "Reduces massive amounts of radiation and toxin damage while purging other chemicals from the body. Has a chance of dealing brute damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/pen_acid/on_mob_life(mob/living/M)
	if(M.radiation > 0)
		M.radiation -= 4
	M.adjustToxLoss(-2*REM)
	if(M.radiation < 0)
		M.radiation = 0
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,2)
	..()
	return

/datum/reagent/medicine/sal_acid
	name = "Salicyclic Acid"
	id = "sal_acid"
	description = "Restores light bruising very slowly. Primarily used as an ingredient in other medicines. Overdose causes slight bruising."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/sal_acid/on_mob_life(mob/living/M)
	if(M.getBruteLoss() < 50)
		M.adjustBruteLoss(-0.25*REM)
	..()
	return

/datum/reagent/medicine/sal_acid/overdose_process(mob/living/M)
	if(M.getBruteLoss() < 50)
		M.adjustBruteLoss(0.5*REM)
	..()
	return

/datum/reagent/medicine/salbutamol
	name = "Salbutamol"
	id = "salbutamol"
	description = "Rapidly restores oxygen deprivation as well as preventing more of it to an extent."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/medicine/salbutamol/on_mob_life(mob/living/M)
	M.adjustOxyLoss(-3*REM)
	if(M.losebreath >= 4)
		M.losebreath -= 2
	..()
	return

/datum/reagent/medicine/perfluorodecalin
	name = "Perfluorodecalin"
	id = "perfluorodecalin"
	description = "Restores oxygen deprivation extremely rapidly, but inhibits speech. May also heal small amounts of bruising and burns."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/medicine/perfluorodecalin/on_mob_life(mob/living/carbon/human/M)
	M.adjustOxyLoss(-12*REM)
	M.silent = max(M.silent, 5)
	if(prob(33))
		M.adjustBruteLoss(-0.5*REM)
		M.adjustFireLoss(-0.5*REM)
	..()
	return

/datum/reagent/medicine/ephedrine
	name = "Ephedrine"
	id = "ephedrine"
	description = "Slightly increases stamina regeneration and increases speed at full health. Overdose deals toxin damage and inhibits breathing. Mainly to be used in other recipes."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	addiction_threshold = 30
	speedboost = FAST

/datum/reagent/medicine/ephedrine/on_mob_life(mob/living/M)
	if(M.health == 100)
		speedboost = FAST
	else
		speedboost = NORMAL
	M.adjustStaminaLoss(-2)
	..()
	return

/datum/reagent/medicine/ephedrine/on_mob_delete(mob/living/M)
	if(current_cycle >= 10)
		M.visible_message("<span class='danger'>[M] suddenly runs out of breath!</span>")
		M.adjustStaminaLoss(50)
	else
		M.adjustStaminaLoss(current_cycle*5)

/datum/reagent/medicine/ephedrine/overdose_process(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(0.5*REM)
		M.losebreath++
	if(prob(12))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
			M.visible_message("<span class='danger'>[M] shudders and drops [I] on the floor!</span>")
	..()
	return

/datum/reagent/medicine/ephedrine/addiction_act_stage1(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(2*REM)
		M.losebreath += 2
	..()
	return
/datum/reagent/medicine/ephedrine/addiction_act_stage2(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(3*REM)
		M.losebreath += 3
	..()
	return
/datum/reagent/medicine/ephedrine/addiction_act_stage3(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(4*REM)
		M.losebreath += 4
	..()
	return
/datum/reagent/medicine/ephedrine/addiction_act_stage4(mob/living/M)
	if(prob(33))
		M.adjustToxLoss(5*REM)
		M.losebreath += 5
	..()
	return

/datum/reagent/medicine/diphenhydramine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	description = "Rapidly purges the body of Histamine and reduces jitteriness. Slight chance of causing drowsiness."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/diphenhydramine/on_mob_life(mob/living/M)
	if(prob(10))
		M.drowsyness += 1
	M.jitteriness -= 1
	M.reagents.remove_reagent("histamine",3)
	..()
	return

/datum/reagent/medicine/sleeptoxin
	name = "Sleep Toxin"
	id = "sleeptoxin"
	description = "A weak yet nontoxic sedative that can be used to safely put a patient to sleep."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/sleeptoxin/on_mob_life(mob/living/M)
	if(current_cycle == 7)
		M << "<span class='warning'>You start to feel tired...</span>" //Warning when the victim is starting to pass out
	if(current_cycle >= 7 && current_cycle < 15)
		M.drowsyness += 1
	else if(current_cycle >= 15)
		M.sleeping += 1
	..()
	return

/datum/reagent/medicine/morphine
	name = "Morphine"
	id = "morphine"
	description = "A painkiller that allows the patient to move at full speed, regardless of injury or clothing. However, it will make you drowsy, and can knock out severely wounded patients. Overdose will cause a variety of effects, ranging from minor to lethal."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	addiction_threshold = 25
	speedboost = IGNORE_SLOWDOWN

/datum/reagent/medicine/morphine/on_mob_life(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = 5
	/*
	for(var/datum/reagent/R in M.reagents.reagent_list)
		R.stun_timer = max(0, stun_timer - 0.5)
	*/
	if(current_cycle >= 10 && M.health <= 30)
		M.sleeping += 1
	..()
	return

/datum/reagent/medicine/morphine/on_mob_delete(mob/living/M)
	M.drowsyness += 10
	if(M.health <= 30)
		M.sleeping += 10
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = 0
	..()

/datum/reagent/medicine/morphine/overdose_process(mob/living/M)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.Dizzy(2)
		M.Jitter(2)
	..()
	return

/datum/reagent/medicine/morphine/addiction_act_stage1(mob/living/M)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.Dizzy(2)
		M.Jitter(2)
	..()
	return
/datum/reagent/medicine/morphine/addiction_act_stage2(mob/living/M)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.adjustToxLoss(1*REM)
		M.Dizzy(3)
		M.Jitter(3)
	..()
	return
/datum/reagent/medicine/morphine/addiction_act_stage3(mob/living/M)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.adjustToxLoss(2*REM)
		M.Dizzy(4)
		M.Jitter(4)
	..()
	return
/datum/reagent/medicine/morphine/addiction_act_stage4(mob/living/M)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.adjustToxLoss(3*REM)
		M.Dizzy(5)
		M.Jitter(5)
	..()
	return

/datum/reagent/medicine/oculine
	name = "Oculine"
	id = "oculine"
	description = "Quickly restores eye damage, cures nearsightedness, and has a chance to restore vision to the blind."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/medicine/oculine/on_mob_life(mob/living/M)
	if(M.disabilities & BLIND)
		if(prob(20))
			M << "<span class='warning'>Your vision slowly returns...</span>"
			M.disabilities &= ~BLIND
			M.disabilities &= NEARSIGHT
			M.eye_blurry = 35

	else if(M.disabilities & NEARSIGHT)
		M << "<span class='warning'>The blackness in your peripheral vision fades.</span>"
		M.disabilities &= ~NEARSIGHT
		M.eye_blurry = 10

	else if(M.eye_blind || M.eye_blurry)
		M.eye_blind = 0
		M.eye_blurry = 0
	else if(M.eye_stat > 0)
		M.eye_stat -= 1
		M.eye_stat = Clamp(M.eye_stat, 0, INFINITY)
	..()
	return

/datum/reagent/medicine/atropine
	name = "Atropine"
	id = "atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients. Can stop a heart attack."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35

/datum/reagent/medicine/atropine/on_mob_life(mob/living/M)
	if(M.health < -60)
		M.adjustToxLoss(-4*REM)
		M.adjustBruteLoss(-4*REM)
		M.adjustFireLoss(-4*REM)
		M.adjustOxyLoss(-10*REM)
	else if(M.health < 0)
		M.adjustToxLoss(-2*REM)
		M.adjustBruteLoss(-2*REM)
		M.adjustFireLoss(-2*REM)
		M.adjustOxyLoss(-5*REM)
	else if(M.health < 10)
		M.adjustToxLoss(-0.5*REM)
		M.adjustBruteLoss(-0.5*REM)
		M.adjustFireLoss(-0.5*REM)
		M.adjustOxyLoss(-0.5*REM)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.heart_attack && prob(10))
			H.heart_attack = 0
	M.losebreath = 0
	..()
	return

/datum/reagent/medicine/atropine/overdose_process(mob/living/M)
	M.hallucination = max(0, M.hallucination + 10)
	M.adjustToxLoss(1.5*REM)
	M.adjustStaminaLoss(5*REM)
	M.Dizzy(1)
	M.Jitter(1)
	if(prob(10))
		M.emote("vomit")
	..()
	return

/datum/reagent/medicine/epinephrine
	name = "Epinephrine"
	id = "epinephrine"
	description = "Slowly heals damage if a patient is in critical condition, as well as regulating oxygen loss. Overdose causes weakness and toxin damage. Has a very small chance of stopping heart attacks."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/epinephrine/on_mob_life(mob/living/M)
	if(M.health < 0)
		M.adjustToxLoss(-0.5*REM)
		M.adjustBruteLoss(-0.5*REM)
		M.adjustFireLoss(-0.5*REM)
	else if(M.health < 5)
		M.adjustToxLoss(-0.1*REM)
		M.adjustBruteLoss(-0.1*REM)
		M.adjustFireLoss(-0.1*REM)
	if(M.oxyloss > 35)
		M.adjustOxyLoss(-6)
	if(M.losebreath >= 4)
		M.losebreath -= 2
	if(M.losebreath < 0)
		M.losebreath = 0
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.heart_attack && prob(1))
			H.heart_attack = 0
	..()
	return

/datum/reagent/medicine/epinephrine/overdose_process(mob/living/M)
	M.adjustStaminaLoss(2.5*REM)
	M.adjustToxLoss(1*REM)
	M.losebreath++
	..()
	return


/datum/reagent/medicine/strange_reagent
	name = "Strange Reagent"
	id = "strange_reagent"
	description = "A miracle drug capable of bringing the dead back to life. Only functions if the target has less than 100 brute and burn damage (independent of one another), and causes slight damage to the living."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/strange_reagent/reaction_mob(mob/living/carbon/human/M, method=TOUCH, reac_volume)
	if(M.stat == DEAD)
		if(M.getBruteLoss() >= 100 || M.getFireLoss() >= 100)
			M.visible_message("<span class='warning'>[M]'s body convulses a bit, and then falls still once more.</span>")
			return
		M.visible_message("<span class='warning'>[M]'s body convulses a bit.</span>")
		if(!M.suiciding && !(M.disabilities & NOCLONE))
			if(!M)
				return
			if(M.notify_ghost_cloning())
				spawn (100) //so the ghost has time to re-enter
					return
			else
				M.stat = 1
				M.adjustOxyLoss(-20)
				M.adjustToxLoss(-20)
				dead_mob_list -= M
				living_mob_list |= list(M)
				M.emote("gasp")
				add_logs(M, M, "revived", src)
	..()
	return

/datum/reagent/medicine/strange_reagent/on_mob_life(mob/living/M)
	M.adjustBruteLoss(0.5*REM)
	M.adjustFireLoss(0.5*REM)
	..()
	return

/datum/reagent/medicine/mannitol
	name = "Mannitol"
	id = "mannitol"
	description = "Efficiently restores brain damage."
	color = "#C8A5DC"

/datum/reagent/medicine/mannitol/on_mob_life(mob/living/M)
	M.adjustBrainLoss(-3*REM)
	..()
	return

/datum/reagent/medicine/mutadone
	name = "Mutadone"
	id = "mutadone"
	description = "Removes jitteriness and restores genetic defects."
	color = "#C8A5DC"

/datum/reagent/medicine/mutadone/on_mob_life(mob/living/carbon/human/M)
	M.jitteriness = 0
	if(M.has_dna())
		M.dna.remove_all_mutations()
	..()
	return

/datum/reagent/medicine/antihol
	name = "Antihol"
	id = "antihol"
	description = "Purges alcoholic substance from the patient's body and eliminates its side effects."
	color = "#C8A5DC"

/datum/reagent/medicine/antihol/on_mob_life(mob/living/M)
	M.dizziness = 0
	M.drowsyness = 0
	M.slurring = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3*REM, 0, 1)
	M.adjustToxLoss(-0.2*REM)
	..()

/datum/reagent/medicine/insulin
	name = "Insulin"
	id = "insulin"
	description = "Increases sugar depletion rates."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/insulin/on_mob_life(mob/living/M)
	if(M.sleeping)
		M.sleeping--
	M.reagents.remove_reagent("sugar", 3)
	..()
	return

//Trek Chems, used primarily by medibots. Only heals a specific damage type, but is very efficient.
datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Restores bruising. Overdose causes it instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

datum/reagent/medicine/bicaridine/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-2*REM)
	..()
	return

datum/reagent/medicine/bicaridine/overdose_process(mob/living/M)
	M.adjustBruteLoss(3*REM)
	metabolization_rate = 3 * REAGENTS_METABOLISM
	..()
	return

datum/reagent/medicine/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Restores oxygen loss. Overdose causes it instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

datum/reagent/medicine/dexalin/on_mob_life(mob/living/M)
	M.adjustOxyLoss(-2*REM)
	..()
	return

datum/reagent/medicine/dexalin/overdose_process(mob/living/M)
	M.adjustOxyLoss(3*REM)
	metabolization_rate = 3 * REAGENTS_METABOLISM
	..()
	return

datum/reagent/medicine/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Restores fire damage. Overdose causes it instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

datum/reagent/medicine/kelotane/on_mob_life(mob/living/M)
	M.adjustFireLoss(-2*REM)
	..()
	return

datum/reagent/medicine/kelotane/overdose_process(mob/living/M)
	M.adjustFireLoss(3*REM)
	metabolization_rate = 3 * REAGENTS_METABOLISM
	..()
	return

datum/reagent/medicine/bromelain
	name = "Bromelain"
	id = "bromelain"
	description = "Effective at healing severe brusing and very efficient but acts somewhat slowly."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/bromelain/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-2*REM)
	if(M.getBruteLoss() < 30)
		metabolization_rate = REAGENTS_METABOLISM
	else
		metabolization_rate = 0.5 * REAGENTS_METABOLISM

	..()
	return

datum/reagent/medicine/bromelain/overdose_process(mob/living/M)
	M.adjustBruteLoss(3*REM)
	metabolization_rate = 2 * REAGENTS_METABOLISM
	..()
	return

datum/reagent/medicine/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Effective at healing severe burns and very efficient but acts somewhat slowly."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/dermaline/on_mob_life(mob/living/M)
	M.adjustFireLoss(-2*REM)
	if(M.getFireLoss() < 30)
		metabolization_rate = REAGENTS_METABOLISM
	else
		metabolization_rate = 0.5 * REAGENTS_METABOLISM

	..()
	return

datum/reagent/medicine/dermaline/overdose_process(mob/living/M)
	M.adjustFireLoss(3*REM)
	metabolization_rate = 2 * REAGENTS_METABOLISM
	..()
	return

datum/reagent/medicine/antitoxin
	name = "Anti-Toxin"
	id = "antitoxin"
	description = "Heals toxin damage and removes toxins in the bloodstream. Overdose causes toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

datum/reagent/medicine/antitoxin/on_mob_life(mob/living/M)
	M.adjustToxLoss(-2*REM)
	for(var/datum/reagent/toxin/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,1)
	..()
	return

datum/reagent/medicine/antitoxin/overdose_process(mob/living/M)
	M.adjustToxLoss(4*REM)
	..()
	return


datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Stabilizes the breathing of patients. Good for those in critical condition."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/medicine/inaprovaline/on_mob_life(mob/living/M)
	if(M.losebreath >= 5)
		M.losebreath -= 5
	..()
	return

datum/reagent/medicine/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Has a high chance to heal all types of damage. Overdose instead causes it."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

datum/reagent/medicine/tricordrazine/on_mob_life(mob/living/M)
	if(prob(80))
		M.adjustBruteLoss(-1*REM)
		M.adjustFireLoss(-1*REM)
		M.adjustOxyLoss(-1*REM)
		M.adjustToxLoss(-1*REM)
	..()
	return

datum/reagent/medicine/tricordrazine/overdose_process(mob/living/M)
	M.adjustToxLoss(2*REM)
	M.adjustOxyLoss(2*REM)
	M.adjustBruteLoss(2*REM)
	M.adjustFireLoss(2*REM)
	..()
	return

datum/reagent/medicine/syndicate_nanites //Used exclusively by Syndicate medical cyborgs
	name = "Restorative Nanites"
	id = "syndicate_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage."
	reagent_state = SOLID
	color = "#555555"

datum/reagent/medicine/syndicate_nanites/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-5*REM) //A ton of healing - this is a 50 telecrystal investment.
	M.adjustBloodLoss(-2*REM) //Great bloodloss healing
	M.adjustFireLoss(-5*REM)
	M.adjustOxyLoss(-15)
	M.adjustToxLoss(-5*REM)
	M.adjustBrainLoss(-15*REM)
	M.adjustCloneLoss(-3*REM)
	..()
	return

/datum/reagent/medicine/stimulants
	name = "Stimulants"
	id = "stimulants"
	description = "Grants immunity to slowdown, increases movement speed when not heavily injured and restores minor damage and stamina loss. Overdose causes weakness and toxin damage."
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60
	// stun_threshold = 4
	// stun_resist = 4
	speedboost = IGNORE_SLOWDOWN + FAST

/datum/reagent/medicine/stimulants/on_mob_life(mob/living/M)
	if(M.health >= 60)
		speedboost = IGNORE_SLOWDOWN + FAST
	else
		speedboost = IGNORE_SLOWDOWN
		if(M.health > 0)
			M.adjustOxyLoss(-1*REM)
			M.adjustToxLoss(-1*REM)
			M.adjustBruteLoss(-1*REM)
			M.adjustBloodLoss(-0.1*REM)
			M.adjustFireLoss(-1*REM)
	M.adjustStaminaLoss(-3)
	// stun_resist_act(M) Stun resists are still dead mate
	..()

/datum/reagent/medicine/stimulants/overdose_process(mob/living/M)
	if(prob(33))
		M.adjustStaminaLoss(15*REM)
		M.adjustToxLoss(1*REM)
		M.losebreath++
	..()
	return
