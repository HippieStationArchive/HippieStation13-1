
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 1.5

/datum/reagent/toxin/on_mob_life(mob/living/M)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM)
	..()
	return

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0

/datum/reagent/toxin/mutagen/reaction_mob(mob/living/carbon/M, method=TOUCH, reac_volume)
	if(!..())
		return
	if(!M.has_dna())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if((method==VAPOR && prob(min(33, reac_volume))) || method==INGEST || method==PATCH || method==INJECT)
		randmuti(M)
		if(prob(98))
			randmutb(M)
		else
			randmutg(M)
		M.updateappearance()
		M.domutcheck()
	..()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/M)
	if(istype(M))
		M.apply_effect(5,IRRADIATE,0)
	..()

/datum/reagent/toxin/plasma
	name = "Plasma"
	id = "plasma"
	description = "Plasma in its liquid form."
	color = "#500064" // rgb: 80, 0, 100
	toxpwr = 3

/datum/reagent/toxin/plasma/on_mob_life(mob/living/M)
	if(holder.has_reagent("epinephrine"))
		holder.remove_reagent("epinephrine", 2*REM)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.adjustPlasma(20)
	..()
	return

/datum/reagent/toxin/plasma/reaction_obj(obj/O, reac_volume)
	if((!O) || (!reac_volume))
		return 0
	O.atmos_spawn_air(SPAWN_TOXINS|SPAWN_20C, reac_volume)

/datum/reagent/toxin/plasma/reaction_turf(turf/simulated/T, reac_volume)
	if(istype(T))
		T.atmos_spawn_air(SPAWN_TOXINS|SPAWN_20C, reac_volume)
	return

/datum/reagent/toxin/plasma/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 5)
		return
	..()

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "A powerful poison used to stop respiration."
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/M)
	if(M.stat != DEAD)
		M.adjustOxyLoss(5)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			C.losebreath += 2
		if(prob(20))
			M.emote("gasp")
	..()
	return

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/M)
	if(prob(10))
		M << "<span class='danger'>Your insides are burning!</span>"
		M.adjustToxLoss(rand(20,60)*REM)
	else if(prob(40))
		M.heal_organ_damage(5*REM,0)
	..()
	return

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

/datum/reagent/toxin/minttoxin/on_mob_life(mob/living/M)
	if (M.nutrition >= NUTRITION_LEVEL_FAT)
		M.gib()
	..()
	return

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded spess carp."
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/carbon/M)
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.5*REM)
	M.Weaken(5)
	M.silent = max(M.silent, 5)
	M.tod = worldtime2text()
	..()
	return

/datum/reagent/toxin/zombiepowder/on_mob_delete(mob/M)
	M.status_flags &= ~FAKEDEATH
	..()

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen. Not a thing to be messed with."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/M)
	M.hallucination += 10
	..()
	return

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

/datum/reagent/toxin/plantbgone/reaction_obj(obj/O, reac_volume)
	if(istype(O,/obj/structure/alien/weeds/))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15,35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O,/obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O,/obj/effect/spacevine))
		var/obj/effect/spacevine/SV = O
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == VAPOR)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.wear_mask) // If not wearing a mask
				var/damage = min(round(0.4*reac_volume, 0.1),10)
				C.adjustToxLoss(damage)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	description = "A harmful toxic mixture to kill weeds. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75

/datum/reagent/toxin/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	description = "A harmful toxic mixture to kill pests. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1

/datum/reagent/toxin/pestkiller/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == VAPOR)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.wear_mask) // If not wearing a mask
				var/damage = min(round(0.4*reac_volume, 0.1),10)
				C.adjustToxLoss(damage)

/datum/reagent/toxin/spore
	name = "Spore Toxin"
	id = "spore"
	description = "A natural toxin produced by blob spores that inhibits vision when ingested."
	color = "#9ACD32"
	toxpwr = 1

/datum/reagent/toxin/spore/on_mob_life(mob/living/M)
	M.damageoverlaytemp = 60
	M.eye_blurry = max(M.eye_blurry, 3)
	..()
	return


/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin"
	id = "spore_burning"
	description = "A natural toxin produced by blob spores that induces combustion in its victim."
	color = "#9ACD32"
	toxpwr = 0.5

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/M)
	..()
	M.adjust_fire_stacks(2)
	M.IgniteMob()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative that induces confusion and drowsiness before putting its target to sleep."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 10)
			M.confused += 2
			M.drowsyness += 2
		if(10 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((current_cycle - 50)*REM)
	..()
	return

/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "A specially-engineered sedative disguised as beer. It induces instant sleep in its target."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/beer2/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((current_cycle - 50)*REM)
	..()
	return

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	id = "coffeepowder"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	id = "teapowder"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.5

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin"
	id = "mutetoxin"
	description = "A nonlethal poison that inhibits speech in its victim."
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/M)
	M.silent = max(M.silent, 3)
	..()

/datum/reagent/toxin/staminatoxin
	name = "Tirizene"
	id = "tirizene"
	description = "A nonlethal poison that causes extreme fatigue and weakness in its victim."
	color = "#6E2828"
	data = 13
	toxpwr = 0

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/M)
	M.adjustStaminaLoss(REM * data)
	data = max(data - 1, 3)
	..()

/datum/reagent/toxin/polonium
	name = "Polonium"
	id = "polonium"
	description = "An extremely radioactive material in liquid form. Ingestion often results in fatal irradiation."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/polonium/on_mob_life(mob/living/M)
	M.radiation += 4
	..()

/datum/reagent/toxin/histamine
	name = "Histamine"
	id = "histamine"
	description = "Histamine's effects become more dangerous depending on the dosage amount. They range from mildly annoying to incredibly lethal."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0

/datum/reagent/toxin/histamine/on_mob_life(mob/living/M)
	if(prob(50))
		switch(pick(1, 2, 3, 4))
			if(1)
				M << "<span class='danger'>You can barely see!</span>"
				M.eye_blurry = 3
			if(2)
				M.emote("cough")
			if(3)
				M.emote("sneeze")
			if(4)
				if(prob(75))
					M << "You scratch at an itch."
					M.adjustBruteLoss(2*REM)
	..()

/datum/reagent/toxin/histamine/overdose_process(mob/living/M)
	M.adjustOxyLoss(2*REM)
	M.adjustBruteLoss(2*REM)
	M.adjustToxLoss(2*REM)
	..()

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	description = "Formaldehyde, on its own, is a fairly weak toxin. It contains trace amounts of Histamine, very rarely making it decay into Histamine.."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/M)
	if(prob(5))
		holder.add_reagent("histamine", pick(5,15))
		holder.remove_reagent("formaldehyde", 1.2)
	else
		..()

/datum/reagent/toxin/venom
	name = "Venom"
	id = "venom"
	description = "An exotic poison extracted from highly toxic fauna. Causes scaling amounts of toxin damage and bruising depending and dosage. Often decays into Histamine."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/venom/on_mob_life(mob/living/M)
	toxpwr = 0.2*volume
	M.adjustBruteLoss((0.3*volume)*REM)
	if(prob(15))
		M.reagents.add_reagent("histamine", pick(5,10))
		M.reagents.remove_reagent("venom", 1.1)
	else
		..()

/datum/reagent/toxin/neurotoxin2
	name = "Neurotoxin"
	id = "neurotoxin2"
	description = "Neurotoxin will inhibit brain function and cause toxin damage before eventually knocking out its victim."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/neurotoxin2/on_mob_life(mob/living/M)
	if(M.brainloss + M.toxloss <= 60)
		M.adjustBrainLoss(1*REM)
		M.adjustToxLoss(1*REM)
	if(current_cycle >= 18)
		M.sleeping += 1
	..()

/datum/reagent/toxin/cyanide
	name = "Cyanide"
	id = "cyanide"
	description = "An infamous poison known for its use in assassination. Causes small amounts of toxin damage with a small chance of oxygen damage or a stun."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1.25

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/M)
	if(prob(5))
		M.losebreath += 1
	if(prob(8))
		M << "You feel horrendously weak!"
		M.Stun(2)
		M.adjustToxLoss(2*REM)
	..()

/datum/reagent/toxin/questionmark // food poisoning
	name = "Bad Food"
	id = "????"
	description = "????"
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/itching_powder
	name = "Itching Powder"
	id = "itching_powder"
	description = "A powder that induces itching upon contact with the skin. Causes the victim to scratch at their itches and has a very low chance to decay into Histamine."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/itching_powder/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.reagents.add_reagent("itching_powder", reac_volume)

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/M)
	if(prob(15))
		M << "You scratch at your head."
		M.adjustBruteLoss(0.2*REM)
	if(prob(15))
		M << "You scratch at your leg."
		M.adjustBruteLoss(0.2*REM)
	if(prob(15))
		M << "You scratch at your arm."
		M.adjustBruteLoss(0.2*REM)
	if(prob(3))
		M.reagents.add_reagent("histamine",rand(1,3))
		M.reagents.remove_reagent("itching_powder",1.2)
		return
	..()

/datum/reagent/toxin/initropidril
	name = "Initropidril"
	id = "initropidril"
	description = "A powerful poison with insidious effects. It can cause stuns, lethal breathing failure, and cardiac arrest."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/M)
	if(prob(25))
		var/picked_option = rand(1,3)
		switch(picked_option)
			if(1)
				M.Stun(3)
				M.Weaken(3)
			if(2)
				M.losebreath += 10
				M.adjustOxyLoss(rand(5,25))
			if(3)
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(!H.heart_attack)
						H.heart_attack = 1 // rip in pepperoni
						if(H.stat == CONSCIOUS)
							H.visible_message("<span class='userdanger'>[H] clutches at their chest as if their heart stopped!</span>")
					else
						H.losebreath += 10
						H.adjustOxyLoss(rand(5,25))
	..()

/datum/reagent/toxin/pancuronium
	name = "Pancuronium"
	id = "pancuronium"
	description = "An undetectable toxin that swiftly incapacitates its victim. May also cause breathing failure."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/M)
	if(current_cycle >= 10)
		M.SetParalysis(1)
	if(prob(20))
		M.losebreath += 4
	..()

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental"
	id = "sodium_thiopental"
	description = "Sodium Thiopental induces heavy weakness in its target as well as unconsciousness."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/M)
	if(current_cycle >= 10)
		M.sleeping += 1
	M.adjustStaminaLoss(10*REM)
	..()

/datum/reagent/toxin/sulfonal
	name = "Sulfonal"
	id = "sulfonal"
	description = "A stealthy poison that deals minor toxin damage and eventually puts the target to sleep."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/M)
	if(current_cycle >= 22)
		M.sleeping += 1
	..()

/datum/reagent/toxin/amanitin
	name = "Amanitin"
	id = "amanitin"
	description = "A very powerful delayed toxin. Upon full metabolization, a massive amount of toxin damage will be dealt depending on how long it has been in the victim's bloodstream."
	reagent_state = LIQUID
	color = "#CF3600"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/M)
	M.adjustToxLoss(current_cycle*3*REM)
	..()

/datum/reagent/toxin/lipolicide
	name = "Lipolicide"
	id = "lipolicide"
	description = "A powerful toxin that will destroy fat cells, massively reducing body weight in a short time. More deadly to those without nutriment in their body."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/M)
	if(!holder.has_reagent("nutriment"))
		M.adjustToxLoss(0.5*REM)
	M.nutrition -= 5 * REAGENTS_METABOLISM
	M.overeatduration = 0
	if(M.nutrition < 0)//Prevent from going into negatives.
		M.nutrition = 0
	..()

/datum/reagent/toxin/coniine
	name = "Coniine"
	id = "coniine"
	description = "Coniine metabolizes extremely slowly, but deals high amounts of toxin damage and stops breathing."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75

/datum/reagent/toxin/coniine/on_mob_life(mob/living/M)
	M.losebreath += 5
	..()

/datum/reagent/toxin/curare
	name = "Curare"
	id = "curare"
	description = "Causes slight toxin damage followed by chain-stunning and oxygen damage."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/curare/on_mob_life(mob/living/M)
	if(current_cycle >= 11)
		M.Weaken(3)
	M.adjustOxyLoss(1*REM)
	..()

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Heparin"
	id = "heparin"
	description = "A powerful anticoagulant. Victims will bleed uncontrollably and suffer scaling bruising."
	reagent_state = LIQUID
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/heparin/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.blood_max += 2
		H.adjustBruteLoss(1) //Brute damage increases with the amount they're bleeding
	..()

/datum/reagent/toxin/teslium //Teslium. Causes periodic shocks, and makes shocks against the target much more effective.
	name = "Teslium"
	id = "teslium"
	description = "An unstable, electrically-charged metallic slurry. Periodically electrocutes its victim, and makes electrocutions against them more deadly."
	reagent_state = LIQUID
	color = "#20324D" //RGB: 32, 50, 77
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	var/shock_timer = 0

/datum/reagent/toxin/teslium/on_mob_life(mob/living/M)
	shock_timer++
	if(shock_timer >= rand(5,30)) //Random shocks are wildly unpredictable
		shock_timer = 0
		M.electrocute_act(rand(5,20), "Teslium in their body", 1, 1) //Override because it's caused from INSIDE of you
		playsound(M, "sparks", 50, 1)
	..()

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Rotatium"
	id = "rotatium"
	description = "A constantly swirling, oddly colourful fluid. Causes the consumer's sense of direction and hand-eye coordination to become wild."
	reagent_state = LIQUID
	color = "#FFFF00" //RGB: 255, 255, 0 Bright ass yellow
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0
	var/rotate_timer = 0

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/M)
	rotate_timer++
	if(M.reagents.get_reagent_amount("rotatium") < 2)
		M.client.dir = NORTH
		..()
		return
	if(rotate_timer >= rand(5,30)) //Random rotations are wildly unpredictable and hilarious
		rotate_timer = 0
		M.client.dir = pick(NORTH, EAST, SOUTH, WEST)
	..()

/datum/reagent/toxin/rotatium/on_mob_delete(mob/living/M)
	M.client.dir = NORTH
	..()
//ACID


/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A strong mineral acid with the molecular formula H2SO4."
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour

/datum/reagent/toxin/acid/reaction_mob(mob/living/carbon/C, method=TOUCH, reac_volume)
	if(!istype(C))
		return
	reac_volume = round(reac_volume,0.1)
	if(method == INGEST)
		C.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(method == INJECT)
		C.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
		return
	C.acid_act(acidpwr, toxpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_obj(obj/O, reac_volume)
	if(istype(O.loc, /mob)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	O.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(reac_volume,0.1)
	for(var/obj/O in T)
		O.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric acid"
	id = "facid"
	description = "Fluorosulfuric acid is a an extremely corrosive chemical substance."
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	acidpwr = 20

/datum/reagent/toxin/wasting_toxin //Used by the changeling death sting.
	name = "Wasting Toxin"
	id = "wasting_toxin"
	description = "An insidious, biologically-produced poison. The body is barely capable of metabolizing it, meaning it will slowly kill them unless help is received."
	metabolization_rate = 0.3 * REAGENTS_METABOLISM
	color = rgb(51, 202, 63)
	toxpwr = 2

/datum/reagent/toxin/wasting_toxin/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.vessel)
			H.vessel.remove_reagent("blood",rand(1, 5)) //Drain blood with various effectiveness
	..()
	
/datum/reagent/toxin/bleach
	name = "Bleach"
	id = "bleach"
	description = "A powerful cleaner.Toxic if injested"
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 2

/datum/reagent/toxin/bleach/on_mob_life(mob/living/M)
	if(M && isliving(M) && M.color != initial(M.color))
		M.color = initial(M.color)
	..()
	return
/datum/reagent/toxin/bleach/reaction_mob(mob/living/M, reac_volume)
	if(M && isliving(M) && M.color != initial(M.color))
		M.color = initial(M.color)
	..()
/datum/reagent/toxin/bleach/reaction_obj(obj/O, reac_volume)
	if(O && O.color != initial(O.color))
		O.color = initial(O.color)
	..()
/datum/reagent/toxin/bleach/reaction_turf(turf/T, reac_volume)
	if(T && T.color != initial(T.color))
		T.color = initial(T.color)
	..()
