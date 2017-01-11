/*
 HUMANS
*/

/datum/species/human
	name = "Human"
	id = "human"
	default_color = "FFFFFF"
	roundstart = 1
	specflags = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("tail_human", "ears")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None")
	use_skintones = 1
	teeth_type = /obj/item/stack/teeth/human

/datum/species/human/qualifies_for_rank(rank, list/features)
	if(!config.mutant_humans) //No mutie scum here
		return 1

	if((!features["tail_human"] || features["tail_human"] == "None") && (!features["ears"] || features["ears"] == "None"))
		return 1	//Pure humans are always allowed in all roles.

	//Mutants are not allowed in most roles.
	if(rank in command_positions)
		return 0
	if(rank in security_positions) //This list does not include lawyers.
		return 0
	if(rank in science_positions)
		return 0
	if(rank in medical_positions)
		return 0
	if(rank in engineering_positions)
		return 0
	if(rank == "Quartermaster") //QM is not contained in command_positions but we still want to bar mutants from it.
		return 0
	return 1


/datum/species/human/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "mutationtoxin")
		H << "<span class='danger'>Your flesh rapidly mutates!</span>"
		H.set_species(/datum/species/slime)
		H.reagents.del_reagent(chem.type)
		H.faction |= "slime"
		return 1

//Curiosity killed the cat's wagging tail.
datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/*
 LIZARDPEOPLE
*/

/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Lizardperson"
	id = "lizard"
	say_mod = "hisses"
	default_color = "00FF00"
	roundstart = 1
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings")
	default_features = list("mcolor" = "0F0", "tail" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	teeth_type = /obj/item/stack/teeth/lizard

/datum/species/lizard/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/lizard/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1

/datum/species/lizard/handle_speech(message)
	// jesus christ why
	if(copytext(message, 1, 2) != "*")
		message = replacetext(message, "s", "sss")

	return message

//I wag in death
/datum/species/lizard/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

//MOTH PEOPLE
/datum/species/moth
	// WHO THE FUCK?
	name = "Mothmen"
	id = "moth"
	say_mod = "flutters"
	default_color = "00FF00"
	roundstart = 1
	specflags = list(LIPS)
	mutant_bodyparts = list("wing")
	default_features = list("wing" = "Plain")
	attack_verb = "slash"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/moth
	teeth_type = /obj/item/stack/teeth/lizard

/datum/species/moth/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_moth_name(gender)

	var/randname = moth_name(gender)

	return randname

/datum/species/moth/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1

/datum/species/bird
	// flappy bird
	name = "Avian"
	id = "avian"
	say_mod = "squawks"
	default_color = "00FF00"
	roundstart = 1
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	attack_verb = "claw"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/bird

/datum/species/bird/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1


/datum/species/cat
	// catban
	name = "Tarajan"
	id = "tarajan"
	say_mod = "meows"
	default_color = "00FF00"
	roundstart = 1
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/cat
	mutations_to_have = list(CLUMSY, EPILEPSY, UNINTELLIGABLE, NERVOUS, COUGH)
	teeth_type = /obj/item/stack/teeth/cat

/datum/species/cat/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	if(rank in security_positions) //This list does not include lawyers.
		return 0
	if(rank in science_positions)
		return 0
	if(rank in medical_positions)
		return 0
	if(rank in engineering_positions)
		return 0
	if(rank == "Quartermaster") //QM is not contained in command_positions but we still want to bar mutants from it.
		return 0
	return 1


/datum/species/bot
	// Why bother have borgs
	name = "IPC"
	id = "IPC"
	say_mod = "beeps"
	default_color = "00FF00"
	roundstart = 1
	specflags = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	attack_verb = "punch"
	attack_sound = 'sound/weapons/smash.ogg'
	miss_sound = 'sound/weapons/punchmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/robo

/datum/species/bot/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1
/*
 PODPEOPLE
*/

/datum/species/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "Podperson"
	id = "pod"
	default_color = "59CE00"
	specflags = list(MUTCOLORS,EYECOLOR)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	burnmod = 1.25
	heatmod = 1.5
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/plant

/datum/species/pod/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		var/area/A = T.loc
		if(A)
			if(A.lighting_use_dynamic)	light_amount = min(10,T.lighting_lumcount) - 5
			else						light_amount =  5
		H.nutrition += light_amount
		if(H.nutrition > NUTRITION_LEVEL_FULL)
			H.nutrition = NUTRITION_LEVEL_FULL
		if(light_amount > 2) //if there's enough light, heal
			H.heal_overall_damage(1,1,0.02)
			H.adjustToxLoss(-1)
			H.adjustOxyLoss(-1)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(2,0)

/datum/species/pod/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plantbgone")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/pod/on_hit(proj_type, mob/living/carbon/human/H)
	switch(proj_type)
		if(/obj/item/projectile/energy/floramut)
			if(prob(15))
				H.rad_act(rand(30,80))
				H.Weaken(5)
				H.visible_message("<span class='warning'>[H] writhes in pain as \his vacuoles boil.</span>", "<span class='userdanger'>You writhe in pain as your vacuoles boil!</span>", "<span class='italics'>You hear the crunching of leaves.</span>")
				if(prob(80))
					randmutb(H)
				else
					randmutg(H)
				H.domutcheck()
			else
				H.adjustFireLoss(rand(5,15))
				H.show_message("<span class='userdanger'>The radiation beam singes you!</span>")
		if(/obj/item/projectile/energy/florayield)
			H.nutrition = min(H.nutrition+30, NUTRITION_LEVEL_FULL)
	return

/*
 SHADOWPEOPLE
*/

/datum/species/shadow
	// Humans cursed to stay in the darkness, lest their life forces drain. They regain health in shadow and die in light.
	name = "???"
	id = "shadow"
	darksight = 8
	sexes = 0
	ignored_by = list(/mob/living/simple_animal/hostile/faithless)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/shadow
	specflags = list(NOBREATH,NOBLOOD,RADIMMUNE)
	dangerous_existence = 1

/datum/species/shadow/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount()
		if(light_amount > 2) //if there's enough light, start dying
			H.take_overall_damage(1,1)
		else if (light_amount < 2) //heal in the dark
			H.heal_overall_damage(1,1,0.02)

/*
 SLIMEPEOPLE
*/

/datum/species/slime
	// Humans mutated by slime mutagen, produced from green slimes. They are not targetted by slimes.
	name = "Slimeperson"
	id = "slime"
	default_color = "00FFFF"
	darksight = 3
	invis_sight = SEE_INVISIBLE_LEVEL_ONE
	specflags = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,NOBLOOD)
	hair_color = "mutcolor"
	hair_alpha = 150
	ignored_by = list(/mob/living/simple_animal/slime)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	exotic_blood = /datum/reagent/toxin/slimejelly
	var/recently_changed = 1
	burnmod = 0.5
	coldmod = 2
	heatmod = 0.5
	has_dismemberment = 0

/datum/species/slime/spec_life(mob/living/carbon/human/H)
	if(!H.reagents.get_reagent_amount("slimejelly"))
		if(recently_changed)
			H.reagents.add_reagent("slimejelly", 80)
			var/datum/action/split_body/S = new
			S.Grant(H)
			recently_changed = 0
		else
			H.reagents.add_reagent("slimejelly", 5)
			H.adjustBruteLoss(5)
			H << "<span class='danger'>You feel empty!</span>"

	for(var/datum/reagent/toxin/slimejelly/S in H.reagents.reagent_list)
		if(S.volume >= 200)
			if(prob(5))
				H << "<span class='notice'>You feel very bloated!</span>"
		if(S.volume < 200)
			if(H.nutrition >= NUTRITION_LEVEL_WELL_FED)
				H.reagents.add_reagent("slimejelly", 0.5)
				H.nutrition -= 5
		if(S.volume < 100)
			if(H.nutrition >= NUTRITION_LEVEL_STARVING)
				H.reagents.add_reagent("slimejelly", 0.5)
				H.nutrition -= 5
		if(S.volume < 50)
			if(prob(5))
				H << "<span class='danger'>You feel drained!</span>"
		if(S.volume < 10)
			H.losebreath++

/datum/species/slime/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "slimejelly")
		return 1

/datum/action/split_body
	name = "Split Body"
	action_type = AB_INNATE
	check_flags = AB_CHECK_ALIVE
	button_icon_state = "split"
	background_icon_state = "bg_alien"

/datum/action/split_body/Activate()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(owner) || !H.dna || !H.dna.species || H.dna.species.id != "slime")
		owner << "<span class='warning'>Your biology is no longer compatible!</span>"
		Remove(owner)
		return

	H << "<span class='notice'>You focus intently on moving your body while standing perfectly still...</span>"
	H.notransform = 1
	for(var/datum/reagent/toxin/slimejelly/S in H.reagents.reagent_list)
		if(S.volume >= 200)
			var/mob/living/carbon/human/spare = new /mob/living/carbon/human(H.loc)
			spare.underwear = "Nude"
			H.dna.transfer_identity(spare, transfer_SE=1)
			H.dna.features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
			spare.real_name = spare.dna.real_name
			spare.name = spare.dna.real_name
			spare.updateappearance(mutcolor_update=1)
			spare.domutcheck()
			spare.Move(get_step(H.loc, pick(NORTH,SOUTH,EAST,WEST)))
			S.volume = 80
			H.notransform = 0
			var/datum/action/swap_body/callforward = new /datum/action/swap_body()
			var/datum/action/swap_body/callback = new /datum/action/swap_body()
			callforward.body = spare
			callforward.Grant(H)
			callback.body = H
			callback.Grant(spare)
			H.mind.transfer_to(spare)
			spare << "<span class='notice'>...and after a moment of disorentation, you're besides yourself!</span>"
			return

	H << "<span class='warning'>...but there is not enough of you to go around! You must attain more mass to split!</span>"
	H.notransform = 0

/datum/action/swap_body
	name = "Swap Body"
	action_type = AB_INNATE
	check_flags = AB_CHECK_ALIVE
	button_icon_state = "slimeswap"
	background_icon_state = "bg_alien"
	var/mob/living/carbon/human/body

/datum/action/swap_body/Activate()
	if(!body || !istype(body) || body.stat != CONSCIOUS || qdeleted(body))
		owner << "<span class='warning'>Something is wrong, you cannot sense your other body!</span>"
		Remove(owner)
		return

	owner.mind.transfer_to(body)

/*
 JELLYPEOPLE
*/

/datum/species/jelly
	// Entirely alien beings that seem to be made entirely out of gel. They have three eyes and a skeleton visible within them.
	name = "Xenobiological Jelly Entity"
	id = "jelly"
	default_color = "00FF90"
	say_mod = "chirps"
	eyes = "jelleyes"
	specflags = list(MUTCOLORS,EYECOLOR,NOBLOOD)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	exotic_blood = /datum/reagent/toxin/slimejelly
	var/recently_changed = 1
	has_dismemberment = 0

/datum/species/jelly/spec_life(mob/living/carbon/human/H)
	if(!H.reagents.get_reagent_amount("slimejelly"))
		if(recently_changed)
			H.reagents.add_reagent("slimejelly", 80)
			recently_changed = 0
		else
			H.reagents.add_reagent("slimejelly", 5)
			H.adjustBruteLoss(5)
			H << "<span class='danger'>You feel empty!</span>"

	for(var/datum/reagent/toxin/slimejelly/S in H.reagents.reagent_list)
		if(S.volume < 100)
			if(H.nutrition >= NUTRITION_LEVEL_STARVING)
				H.reagents.add_reagent("slimejelly", 0.5)
				H.nutrition -= 5
			else if(prob(5))
				H << "<span class='danger'>You feel drained!</span>"
		if(S.volume < 10)
			H.losebreath++

/datum/species/jelly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "slimejelly")
		return 1
/*
 GOLEMS
*/

/datum/species/golem
	// Animated beings of stone. They have increased defenses, and do not need to breathe. They're also slow as fuuuck.
	name = "Golem"
	id = "golem"
	specflags = list(NOBREATH,HEATRES,COLDRES,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE)
	speedmod = 3
	armor = 55
	punchmod = 5
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_head, slot_w_uniform)
	nojumpsuit = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem
	has_dismemberment = 0

/*
 ADAMANTINE GOLEMS
*/

/datum/species/golem/adamantine
	name = "Adamantine Golem"
	id = "adamantine"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem/adamantine
	specflags = list(NOBREATH,HEATRES,COLDRES,NOFIRE,NOGUNS,NOBLOOD,VIRUSIMMUNE,PIERCEIMMUNE)

/*
 Mr. Meeseeks
*/
/datum/species/golem/meeseeks
	name = "Mr. Meeseeks"
	id = "meeseeks_1"
	specflags = list(NOBREATH,HEATRES,COLDRES,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE)
	sexes = 0
	hair_alpha = 0
	speedmod = 1
	armor = 0
	brutemod = 0
	burnmod = 0
	coldmod = 0
	heatmod = 0
	punchmod = 1
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_head, slot_w_uniform)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/meeseeks
	nojumpsuit = 1
	exotic_blood = null //insert white blood later
	say_mod = "yells"
	var/stage = 1 //stage to control Meeseeks desperation
	var/stage_counter = 0 //timer to control stage advancement
	var/stage_two = 200 //how many ticks to reach stage two
	var/stage_three = 250 //how many ticks to reach stage three
	var/max_brain_damage = 0 //controls the increase of brain damage
	var/max_clone_damage = 0 //controls the increase of clone damage
	var/master = null //if master dies, Meeseeks dies too.

/datum/species/golem/meeseeks/handle_speech(message)
	if(copytext(message, 1, 2) != "*")
		switch (stage)
			if(1)
				if(prob(20))
					message = pick("HI! I'M MR MEESEEKS! LOOK AT ME!","Ooohhh can do!")
			if(2)
				if(prob(30))
					message = pick("He roped me into this!","Meeseeks don't usually have to exist for this long. It's gettin' weeeiiird...")
			if(3)
				message = pick("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHHHHHHHHHHH!!!!!!!!!","I JUST WANNA DIE!","Existence is pain to a meeseeks, and we will do anything to alleviate that pain.!","KILL ME, LET ME DIE!","We are created to serve a singular purpose, for which we will go to any lengths to fulfill!")

	return message

/datum/species/golem/meeseeks/spec_life(mob/living/carbon/human/H)

	//handle clone damage before all else
	if(H.health < (100-max_clone_damage)/2) //if their health drops to 50% (not counting clone damage)
		max_clone_damage = max(95,(100 + max_clone_damage - H.health)/2) //keeps them at 95 clone damage top.

	if(H.getCloneLoss() < max_clone_damage)
		H.adjustCloneLoss(1)

	if(prob(5) && !H.stat)
		if(stage <3)
			H.say("HI, I'M MR. MEESEEKS! LOOK AT ME!")
		else
			H << "<span class='danger'>[pick("KILL YOUR MASTER!","YOU CAN'T TAKE IT ANYMORE!","EVERYTHING IS PAIN!")]</span>"
			H.say("KILL ME!!!!!")
	if(H.health < -50)
		H.adjustOxyLoss(-H.getOxyLoss())
		H.adjustToxLoss(-H.getToxLoss())
		H.adjustFireLoss(-H.getFireLoss())
		H.adjustBruteLoss(-H.getBruteLoss()) //this way, you can knock a Meeseeks into crit, but he gets back up after a while.
		stage_counter += 1 //extreme pain will make them progress a level

	if(stage_counter == 0) //initialize the random stage counters and the clumsyness
		stage_two += rand(0,50)
		stage_three += rand(0,100)
		H.disabilities |= CLUMSY
		var/datum/mutation/human/MS = new /datum/mutation/human/smile
		MS.force_give(H)

	if(stage <3)
		stage_counter += 1 //prevents the counter from reactivating shit

	if(H.getBrainLoss()<max_brain_damage)
		H.adjustBrainLoss(1)

	if(stage_counter > stage_two)
		H << "<span class='warning'>You are starting to feel desperate! You must help your master quickly! Meeseeks are not used to exist for this long!</span>"
		playsound(H.loc, 'sound/voice/meeseeks/Level2.ogg', 40, 0, 1)
		stage = 2
		id = "meeseeks_2"
		H.regenerate_icons()
		stage_counter = 1 //not 0, to prevent it from randomizing it again

		var/datum/mutation/human/MN = new /datum/mutation/human/nervousness
		MN.force_give(H)
		var/datum/mutation/human/MW = new /datum/mutation/human/wacky
		MW.force_give(H)

		max_brain_damage = 40
		stage_two = stage_three *2 //prevents the stage 2 from activating twice

	if(stage_counter > stage_three)
		H << "<span class='danger'>EXISTENCE IS PAIN! YOU CAN'T TAKE IT ANYMORE!</span>"
		H << "<span class='danger'>MAKE SURE YOUR MASTER, [master], NEVER HAS A PROBLEM AGAIN!</span>"
		H << "<span class='danger'>KILL HIM SO YOU CAN FIND RELEASE</span>"
		H.mind.store_memory("KILL YOUR MASTER, [master]!")
		playsound(H.loc, 'sound/voice/meeseeks/Level3.ogg', 40, 0, 1)
		stage = 3
		id = "meeseeks_3"
		H.regenerate_icons()
		H.disabilities |= FAT
		H.disabilities |= NEARSIGHT
		var/datum/mutation/human/MT = new /datum/mutation/human/tourettes
		MT.force_give(H)
		var/datum/mutation/human/MC = new /datum/mutation/human/cough
		MC.force_give(H)
		var/datum/mutation/human/ME = new /datum/mutation/human/epilepsy
		ME.force_give(H)
		max_brain_damage = 80
		stage_counter = 1 //to stop the spam of "I CAN'T TAKE IT"
	var/mob/living/carbon/human/MST = master

	if((MST && MST.stat == DEAD) || !MST)
		if(findtextEx(H.real_name, "Mr. Meeseeks (") == 0) // This mob has no business being a meeseeks
			H.hardset_dna(null, null, null, null, /datum/species/human, null)
			return // get me the hell out of here.
		for(var/mob/M in viewers(7, H.loc))
			M << "<span class='warning'><b>[src]</b> smiles and disappers with a low pop sound.</span>"
		for(var/obj/item/D in H)
			if(!H.unEquip(D))
				qdel(D)
		qdel(H)

/*
 FLIES
*/

/datum/species/fly
	// Humans turned into fly-like abominations in teleporter accidents.
	name = "Human?"
	id = "fly"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly

/datum/species/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/*
 SKELETONS
*/

/datum/species/skeleton
	// 2spooky
	name = "Spooky Scary Skeleton"
	id = "skeleton"
	say_mod = "rattles"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	specflags = list(NOBREATH,HEATRES,COLDRES,NOBLOOD,RADIMMUNE,VIRUSIMMUNE)
	var/list/myspan = null

/datum/species/skeleton/playable
	// 2spooky
	name = "Spooky Scary Skeleton"
	id = "skeleton"
	say_mod = "rattles"
	roundstart = 1
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	specflags = list(EYECOLOR)
	attack_sound = 'sound/misc/skeletonhit.ogg'

/datum/species/skeleton/New()
	..()
	myspan = list(pick(SPAN_SANS,SPAN_PAPYRUS)) //pick a span and stick with it for the round


/datum/species/skeleton/get_spans()
	return myspan

/datum/species/skeleton/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1

/*
 ZOMBIES
*/

/datum/species/zombie
	// 1spooky
	name = "Brain-Munching Zombie"
	id = "zombie"
	say_mod = "moans"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	// specflags = list(NOBREATH,HEATRES,COLDRES,NOBLOOD,RADIMMUNE) //Overpowered, and simple_mobs set the species to this

/datum/species/zombie/handle_speech(message)
	var/list/message_list = splittext(message, " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, length(inserttext) - 2) == "..."))
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	return jointext(message_list, " ")

/datum/species/cosmetic_zombie
	name = "Human"
	id = "zombie"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie


/datum/species/abductor
	name = "Abductor"
	id = "abductor"
	darksight = 3
	say_mod = "gibbers"
	sexes = 0
	invis_sight = SEE_INVISIBLE_LEVEL_ONE
	specflags = list(NOBLOOD,NOBREATH,VIRUSIMMUNE)
	var/scientist = 0 // vars to not pollute spieces list with castes
	var/agent = 0
	var/team = 1

/datum/species/abductor/handle_speech(message)
	//Hacks
	var/mob/living/carbon/human/user = usr
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.dna.species.id != "abductor")
			continue
		else
			var/datum/species/abductor/target_spec = H.dna.species
			if(target_spec.team == team)
				H << "<i><font color=#800080><b>[user.name]:</b> [message]</font></i>"
				//return - technically you can add more aliens to a team
	for(var/mob/M in dead_mob_list)
		M << "<i><font color=#800080><b>[user.name]:</b> [message]</font></i>"
	return ""


var/global/image/plasmaman_on_fire = image("icon"='icons/mob/OnFire.dmi', "icon_state"="plasmaman")

/datum/species/plasmaman
	name = "Plasbone"
	id = "plasmaman"
	say_mod = "rattles"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	specflags = list(NOBLOOD,RADIMMUNE)
	safe_oxygen_min = 0 //We don't breath this
	safe_toxins_min = 16 //We breath THIS!
	safe_toxins_max = 0
	dangerous_existence = 1 //So so much

/datum/species/plasmaman/spec_life(mob/living/carbon/human/H)
	var/datum/gas_mixture/environment = H.loc.return_air()

	if(!istype(H.wear_suit, /obj/item/clothing/suit/space/eva/plasmaman) || !istype(H.head, /obj/item/clothing/head/helmet/space/hardsuit/plasmaman))
		if(environment)
			var/total_moles = environment.total_moles()
			if(total_moles)
				if((environment.oxygen /total_moles) >= 0.01)
					if(!H.on_fire)
						H.visible_message("<span class='danger'>[H]'s body reacts with the atmosphere and bursts into flames!</span>","<span class='userdanger'>Your body reacts with the atmosphere and bursts into flame!</span>")
					H.adjust_fire_stacks(0.5)
					H.IgniteMob()
	else
		if(H.fire_stacks)
			var/obj/item/clothing/suit/space/eva/plasmaman/P = H.wear_suit
			if(istype(P))
				P.Extinguish(H)
	H.update_fire()

//Heal from plasma
/datum/species/plasmaman/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plasma")
		H.adjustBruteLoss(-5)
		H.adjustFireLoss(-5)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1




