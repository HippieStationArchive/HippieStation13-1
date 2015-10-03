/*
 HUMANS
*/

/datum/species/human
	name = "Human"
	id = "human"
	roundstart = 0
	specflags = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	use_skintones = 1

/datum/species/human/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "mutationtoxin")
		H << "<span class='danger'>Your flesh rapidly mutates!</span>"
		H.dna.species = new /datum/species/slime()
		H.regenerate_icons()
		H.reagents.del_reagent(chem.type)
		H.faction |= "slime"
		return 1

/*
 LIZARDPEOPLE
*/

/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Lizardperson"
	id = "lizard"
	say_mod = "hisses"
	mutant_bodyparts = list("tail", "snout")
	default_color = "00FF00"
	roundstart = 0
	specflags = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/lizard
	blood_color = "#400040"

/datum/species/lizard/handle_speech(message)
	// jesus christ why
	if(copytext(message, 1, 2) != "*")
		message = replacetext(message, "s", "sss")

	return message




/datum/species/bird
	// flappy bird
	name = "Avian"
	id = "avian"
	say_mod = "squawks"
	default_color = "00FF00"
	roundstart = 0
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	attack_verb = "claws"
	attack_sound = 'sound/effects/claw.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/lizard


/datum/species/cat
	// catban
	name = "Tarajan"
	id = "tarajan"
	say_mod = "meows"
	default_color = "00FF00"
	roundstart = 0
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	attack_verb = "slash"
	attack_sound = 'sound/effects/claw.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/lizard
	mutations_to_have = list(CLUMSY)


/datum/species/bot
	// Why bother have borgs
	name = "IPC"
	id = "IPC"
	say_mod = "beeps"
	default_color = "00FF00"
	roundstart = 0
	specflags = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	attack_verb = "punch"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = null
	blood_color = "#030303" //Almost-completely-black



/*
 MACHINEPEOPLE
*/

///datum/species/machine
//	name = "Machine"
//	id = "machine"
//	say_mod = "beeps"
//	default_color = "000000"
//	roundstart = 1
//	specflags = list(NOBREATH,HEATRES,COLDRES,MUTCOLORS,EYECOLOR,LIPS)
//	attack_verb = "slash"
//	attack_sound = 'sound/weapons/wave.ogg'
//	miss_sound = 'sound/weapons/slashmiss.ogg'
//	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
//
///datum/species/machine/handle_speech(message)
//	//if(copytext(message, 1, 2) != "*")
//	//	message = replacetext(message, "s", stutter("ss"))
//
//	return message

/*
 PLANTPEOPLE
*/

/datum/species/plant
	// Creatures made of leaves and plant matter.
	name = "Plant"
	id = "plant"
	default_color = "59CE00"
	specflags = list(MUTCOLORS,EYECOLOR)
	attack_verb = "slice"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	blood_color = "#ee5c42"
	burnmod = 1.25
	heatmod = 1.5
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/plant

/datum/species/plant/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plantbgone")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/plant/on_hit(proj_type, mob/living/carbon/human/H)
	switch(proj_type)
		if(/obj/item/projectile/energy/floramut)
			if(prob(15))
				H.apply_effect((rand(30,80)),IRRADIATE)
				H.Weaken(5)
				for (var/mob/V in viewers(H))
					V.show_message("<span class='danger'>[H] writhes in pain as \his vacuoles boil.</span>", 3, "<span class='danger'>You hear the crunching of leaves.</span>", 2)
				if(prob(80))
					randmutb(H)
					domutcheck(H,null)
				else
					randmutg(H)
					domutcheck(H,null)
			else
				H.adjustFireLoss(rand(5,15))
				H.show_message("<span class='danger'>The radiation beam singes you!</span>")
		if(/obj/item/projectile/energy/florayield)
			H.nutrition = min(H.nutrition+30, NUTRITION_LEVEL_FULL)
	return

/*
 PODPEOPLE
*/

/datum/species/plant/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "Podperson"
	id = "pod"

/datum/species/plant/pod/spec_life(mob/living/carbon/human/H)
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
			H.heal_overall_damage(1,1)
			H.adjustToxLoss(-1)
			H.adjustOxyLoss(-1)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(2,0)

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
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/shadow
	blood_color = "#202020"

/datum/species/shadow/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		var/area/A = T.loc
		if(A)
			if(A.lighting_use_dynamic)	light_amount = T.lighting_lumcount
			else						light_amount =  10
		if(light_amount > 2) //if there's enough light, start dying
			H.take_overall_damage(1,1)
		else if (light_amount < 2) //heal in the dark
			H.heal_overall_damage(1,1)

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
	specflags = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR)
	hair_color = "mutcolor"
	hair_alpha = 150
	ignored_by = list(/mob/living/carbon/slime)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/slime
	blood_color = "#00688B"

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
	specflags = list(MUTCOLORS,EYECOLOR)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/slime
	blood_color = "#00688B"

/*
 GOLEMS
*/

/datum/species/golem
	// Animated beings of stone. They have increased defenses, and do not need to breathe. They're also slow as fuuuck.
	name = "Golem"
	id = "golem"

	specflags = list(NOBREATH,HEATRES,COLDRES,NOGUNS,NOBLOOD,RADIMMUNE,NOINJECT,VIRUSIMMUNE,HARDFEET)

	speedmod = 3
	armor = 55
	punchmod = 5
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_head, slot_w_uniform)
	nojumpsuit = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/golem
	blood_color = "#CDAA7D"


/*
 ADAMANTINE GOLEMS
*/

/datum/species/golem/adamantine
	name = "Adamantine Golem"
	id = "adamantine"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/golem/adamantine
	blood_color = "#CDAA7D"

/*
 Mr. Meeseeks
*/
/datum/species/golem/meeseeks
	name = "Mr. Meeseeks"
	id = "meeseeks_1"
	specflags = list(NOBREATH,HEATRES,COLDRES,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,HARDFEET)
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
	nojumpsuit = 1
	meat = null
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

		H.disabilities |= NERVOUS
		H.disabilities |= TOURETTES

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
		H.disabilities |= NEARSIGHTED
		H.disabilities |= COUGHING
		H.disabilities |= EPILEPSY
		max_brain_damage = 80
		stage_counter = 1 //to stop the spam of "I CAN'T TAKE IT"
	var/mob/living/carbon/human/MST = master

	if((MST && MST.stat == DEAD) || !MST)
		for(var/mob/M in viewers(7, H.loc))
			M << "<span class='warning'><b>[src]</b> smiles and disappers with a low pop sound.</span>"
		for(var/obj/item/W in H)
			H.unEquip(W)
		qdel(H)


/*
 FLIES
*/

/datum/species/fly
	// Humans turned into fly-like abominations in teleporter accidents.
	name = "Human?"
	id = "fly"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/fly
	blood_color = "#8B8B00"

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
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/skeleton
	specflags = list(NOBREATH,HEATRES,COLDRES,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,HARDFEET)
	blood_color = "#808080"

/datum/species/skeleton/alt
	//3spooky
	name = "Spooky Scary Skeleton"
	id = "skeleton"
	say_mod = "rattles"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/skeleton
	specflags = null
	blood_color = "#808080"

// Abductor
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

/*
 ZOMBIES
*/

/datum/species/zombie
	// 1spooky
	name = "Brain-Munching Zombie"
	id = "zombie"
	say_mod = "moans"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/human/mutant/zombie


/datum/species/zombie/handle_speech(message)
	var/list/message_list = text2list(message, " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, length(inserttext) - 2) == "..."))
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	return list2text(message_list, " ")
