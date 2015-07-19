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