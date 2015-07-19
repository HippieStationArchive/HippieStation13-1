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