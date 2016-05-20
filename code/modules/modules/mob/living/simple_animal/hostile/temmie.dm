/mob/living/simple_animal/hostile/temmie
	name = "Temmie"
	desc = "You feel your nose running as you realize you're allergic."
	icon = 'icons/mob/animal.dmi'
	icon_state = "temmie"
	icon_living = "temmie"
	icon_dead = "temmie_dead"
	gender = MALE
	maxHealth = 60
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "pokes"
	attack_sound = 'sound/weapons/tap.ogg'
	speak = list("Hoi!!")
	speak_emote = list("mews")
	emote_hear = list("meows", "mews")
	emote_taunt = list("Looks at")
	speak_chance = 1
	taunt_chance = 50
	turns_per_move = 7
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 2)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	gold_core_spawnable = 1
	faction = list("temmie")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 5
	pass_flags = PASSTABLE