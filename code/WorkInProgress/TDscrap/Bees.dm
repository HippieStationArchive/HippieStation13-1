/obj/item/clothing/suit/armor/beebox
	name = "Bee Box"
	desc = "A largish beebox that goes over the entire waist, and is supported by straps"
	icon_state = "beebox"
	item_state = "beebox"
	armor = list(melee = 10, bullet = 1, laser = 1, energy = 1, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/beesuit
	name = "Dr. BEES' suit"
	desc = "It's a tight spandex suit with a big B in the center of it"
	icon_state = "beesuit"
	item_state = "armor"
	item_color = "beesuit"
	can_adjust = 0

/obj/item/clothing/shoes/beeboots
	name = "BEE Boots"
	desc = "Modified combat boots, has the scent of honey on them."
	icon_state = "beeboots"
	item_state = "beeboots"
	armor = list(melee = 25, bullet = 25, laser = 25, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/gloves/beegloves
	name = "Bee Attack Gloves"
	desc = "These gloves are absolutely covered in honey!"
	icon_state = "beegloves"
	item_state = "beegloves"
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

/obj/item/clothing/head/beehat
	name = "Bee"
	desc = "ITS A DAMN BEE, PUT IT ON YOUR HEAD"
	icon_state = "beehat"
	item_state = "beehat"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/mask/beecowl
	name = "Bee Cowl"
	desc = "JUST YOUR AVERAGE WASP-THEMED SUPER HERO BY DAY!"
	icon_state = "beecowl"
	item_state = "beecowl"
	flags = BLOCKHAIR | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	w_class = 2

/obj/item/weapon/grenade/spawnergrenade/beenade
	name = "Bee-nade"
	spawner_type = /mob/living/simple_animal/hostile/bee
	icon_state = "beenade"
	deliveryamt = 5
	origin_tech = "materials=3;magnets=4;syndicate=4"

/mob/living/simple_animal/hostile/bee
	name = "giant space bee"
	desc = "A giant, angry space bee"
	icon_state = "giantbee"
	icon_living = "giantbee"
	icon_dead = "giantbee_dead"
	icon_gib = "giantbee_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/honeycomb
	meat_amount = 2
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speed = 0
	maxHealth = 25
	health = 25
	harm_intent_damage = 8
	melee_damage_lower = 7
	melee_damage_upper = 10
	attacktext = "stings"
	attack_sound = 'sound/effects/beebuzz.ogg'
	//Space bees aren't affected by cold.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 1500

	faction = list("bees")

/mob/living/simple_animal/bee
	name = "Domesticated space bee"
	desc = "A Domesticated space bee, it's stinger has been surgically removed"
	icon_state = "giantbee"
	icon_living = "giantbee"
	icon_dead = "giantbee_dead"
	icon_gib = "giantbee_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/honeycomb
	meat_amount = 2
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speed = 0
	maxHealth = 25
	health = 25
	attacktext = "stings"
	attack_sound = 'sound/effects/beebuzz.ogg'
	//Space bees aren't affected by cold.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 1500

	faction = list("bees")



// THE BEEHAIRLER! AKA Sechailer modified to play DR BEEEEEES sounds
/obj/item/clothing/mask/beecowl/beehailer
	name = "Dr. Bee's Cowl"
	desc = "A cowl with a built in cassette deck! It appears to be preloaded with a unremovable cassette however."
	action_button_name = "BEES"
	icon_state = "beecowl"
	var/cooldown = 0
	var/aggressiveness = 2
	ignore_maskadjust = 0
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | BLOCKHAIR
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS

/obj/item/clothing/mask/beecowl/beehailer/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(aggressiveness)
			if(1)
				user << "<span class='notice'>You set the restrictor to the middle position, but all the settings are marked BEES.</span>"
				aggressiveness = 2
			if(2)
				user << "<span class='notice'>You set the restrictor to the last position, but all the settings are marked BEES.</span>"
				aggressiveness = 3
			if(3)
				user << "<span class='notice'>You set the restrictor to the first position, but all the settings are marked BEES.</span>"
				aggressiveness = 1
			if(4)
				user << "<span class='danger'>You adjust the restrictor but nothing happens, probably because its broken.</span>"
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(aggressiveness != 4)
			user << "<span class='danger'>You broke it!</span>"
			aggressiveness = 4
	else
		..()

/obj/item/clothing/mask/beecowl/beehailer/attack_self()
	bees()

/obj/item/clothing/mask/beecowl/beehailer/verb/bees()
	set category = "Object"
	set name = "BEES"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(!can_use(usr))
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null
	var/phrase_sound = null


	if(cooldown < world.time - 50) // Modified Sechailer code, doesn't need the aggressiveness, but will leave it for compatability reasons
		switch(aggressiveness)
			if(1)
				phrase = rand(1,7)
			if(2)
				phrase = rand(1,7)
			if(3)
				phrase = rand(1,7)
			if(4)
				phrase = rand(8,8)

		switch(phrase)	//sets the properties of the chosen phrase
			if(1)
				phrase_text = "Dr. BEEEES"
				phrase_sound = "drbees"
			if(2)
				phrase_text = "A large influx of bees ought to put a stop to that!"
				phrase_sound = "alargeinflux"
			if(3)
				phrase_text = "My briefcase full of bees ought to put a stop to that!"
				phrase_sound = "briefcasefullofbees"
			if(4)
				phrase_text = "On International bring a shit ton of bees to work day!"
				phrase_sound = "shittonofbees"
			if(5)
				phrase_text = "LATER THAT VERY SAME BEE"
				phrase_sound = "laterthatverysamebee"
			if(6)
				phrase_text = "BEES ARE MY ART"
				phrase_sound = "Beearemyart"
			if(7)
				phrase_text = "IF PEOPLE DONT LIKE MY BEES, THEY CAN VOICE THEIR OPINION OR VOTE WITH THEIR WALLETS"
				phrase_sound = "votewithwallet"
			if(8)
				phrase_text = "AGH NO, NOT THE BEES, NOT THE BEES, AHHHHHHGAHAGHAGH"
				phrase_sound = "notthebees"

		usr.visible_message("[usr]'s Cowl: <font color='black' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/complionator/bees/[phrase_sound].ogg", 100, 0, 4)
		cooldown = world.time

datum/reagent/consumable/honey
	name = "Honey"
	id = "honey"
	description = "Some gooey honey, nothing really special about this"
	color = "##a98307" // rgb: 169, 131, 7

/obj/item/weapon/reagent_containers/food/snacks/honeycomb
	name = "Honey Comb"
	desc = "A honey comb, full of delicious honey"
	icon_state = "honeycomb"

/obj/item/weapon/reagent_containers/food/snacks/honeycomb/New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("honey", 10)
		src.bitesize = 3



datum/reagent/consumable/ethanol/drbeedrink
	name = "Dr. Bee's Special Cocktail "
	id = "drbeedrink"
	description = "You know what this drink needs? More BEEES!"
	color = "#f6c21b" // rgb: 246, 194, 27
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 50

/datum/chemical_reaction/drbeedrink
	name = "Dr. Bee's Special Cocktail"
	id = "drbeedrink"
	result = "drbeedrink"
	required_reagents = list("honey" = 1, "gin" = 1)
	result_amount = 2

datum/reagent/consumable/ethanol/drbeedrink/on_mob_life(var/mob/living/M as mob)
	if(M.getOxyLoss() && prob(80))
		M.adjustOxyLoss(-1)
	if(M.getBruteLoss() && prob(80))
		M.heal_organ_damage(1,0)
	if(M.getFireLoss() && prob(80))
		M.heal_organ_damage(0,1)
	if(M.getToxLoss() && prob(80))
		M.adjustToxLoss(-1)
	if(M.dizziness !=0)
		M.dizziness = max(0,M.dizziness-3)
	if(M.confused !=0)
		M.confused = max(0,M.confused - 1)
	holder.remove_reagent(id, metabolization_rate/M.metabolism_efficiency)
	return

