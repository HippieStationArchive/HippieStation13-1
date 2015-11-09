/mob/living/simple_animal/hostile/zombie
	name = "zombie"
	desc = "A horrifying, shambling carcass of what once resembled a human being."
	icon = 'icons/mob/human.dmi'
	icon_state = "zombie_s"
	icon_living = "zombie_s"
	icon_dead = "zombie_dead"
	turns_per_move = 5
	emote_see = list("groans", "roars")
	a_intent = "harm"
	maxHealth = 120
	health = 120
	speed = 2
	move_to_delay = 5
	harm_intent_damage = 8
	melee_damage_lower = 9
	melee_damage_upper = 20
	attacktext = "claws"
	attack_sound = list('sound/weapons/claw_strike1.ogg','sound/weapons/claw_strike2.ogg','sound/weapons/claw_strike3.ogg')
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	minbodytemp = 0
	maxbodytemp = 350
	unsuitable_atmos_damage = 10
	environment_smash = 1
	can_force_doors = 1 //Can force doors open like a champ
	robust_searching = 1
	stat_attack = 0
	gold_core_spawnable = 0 //No.
	faction = list("zombie")

	var/infection = 20 //Chance of infecting the victim.
	var/mob/living/carbon/human/stored_corpse = null

	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3)
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 8


/mob/living/simple_animal/hostile/zombie/attack_threshold_check(damage, damagetype = BRUTE)
	if(damage <= force_threshold || ignored_damage_types[damagetype])
		visible_message("<span class='warning'>[src] looks unharmed.</span>")
	else
		var/armor = run_armor_check("chest", "melee", "Your armor has protected you.", "Your armor has softened the hit.")
		apply_damage(damage, damagetype, "chest", armor)
		updatehealth()

/mob/living/simple_animal/hostile/zombie/getarmor(def_zone, type)
	if(istype(stored_corpse))
		return stored_corpse.getarmor(stored_corpse.get_organ(check_zone(def_zone), type))
	return 0

/mob/living/simple_animal/hostile/zombie/bullet_act(obj/item/projectile/P, def_zone)
	var/armor = run_armor_check(def_zone, P.flag, "","",P.armour_penetration)
	if(!P.nodamage)
		apply_damage(P.damage, P.damage_type, def_zone, armor)
	return P.on_hit(src, armor, def_zone)

/mob/living/simple_animal/hostile/zombie/AttackingTarget()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(ishuman(L) && prob(infection))
			var/mob/living/carbon/human/H = L
			attacktext = "bites"
			attack_sound = list('sound/weapons/bite.ogg')
			H.ContractDisease(new /datum/disease/transformation/zombie) //You. Got. INFECTED.

	target.attack_animal(src)
	attacktext = "claws"
	attack_sound = list('sound/weapons/claw_strike1.ogg','sound/weapons/claw_strike2.ogg','sound/weapons/claw_strike3.ogg')

/mob/living/simple_animal/hostile/zombie/death()
	..()
	if(stored_corpse)
		stored_corpse.loc = loc
		if(ckey)
			stored_corpse.ckey = src.ckey
		qdel(src)
		return