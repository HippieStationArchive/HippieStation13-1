/mob/living/simple_animal/hostile/pizza
	name = "Meat pizza"
	desc = "A living pizza."
	icon_state = "pizzularity_idle"
	icon_living = "pizzularity_idle"
	icon_dead = "pizzularity_idle"
	icon_gib = "pizzularity"
	speak_chance = 0
	turns_per_move = 5
	// meat_type = "/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza"
	// meat_amount = 1
	response_help = "attempts to touch"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speed = 0
	maxHealth = 200
	health = 100

	harm_intent_damage = 0
	melee_damage_lower = 1
	melee_damage_upper = 4
	attacktext = "chomps"
	attack_sound = 'sound/effects/phasein.ogg'
	var/pizza_type = "/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza"
	var/power = 0//How many things it has eaten

	//Space pizza aren't affected by cold.
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
	attack_same = 1
	faction = list("pizza")

/mob/living/simple_animal/hostile/pizza/Life()
	..()
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			icon_state = "pizzularity_idle"

		if(HOSTILE_STANCE_ATTACK)
			icon_state = "pizzularity"

		if(HOSTILE_STANCE_ATTACKING)
			icon_state = "pizzularity"


/mob/living/simple_animal/hostile/pizza/Process_Spacemove(var/movement_dir = 0)
	return 1	//No drifting in space for meat pizza!	//original comment STOLEN

/mob/living/simple_animal/hostile/pizza/FindTarget()
	. = ..()
	if(.)
		emote("me", 1, "looks at [.]!")

/mob/living/simple_animal/hostile/pizza/AttackingTarget()
	// . =..()
	// var/mob/living/target = .
	if(istype(target,/mob/living/simple_animal/hostile/pizza))
		var/mob/living/simple_animal/hostile/pizza/pizza = target
		power += pizza.power + 5//Merge them
		health += pizza.health - pizza.maxHealth //Making sure meatpizza only takes the other meatpizza's bonus health
		pizza.Die()
		return

	var/teleloc = target.loc
	for(var/atom/movable/stuff in teleloc)
		if(!stuff.anchored && stuff.loc)
			do_teleport(stuff, stuff, 10)
			LoseTarget()
			playsound(src.loc, 'sound/effects/phasein.ogg', 30, 1)
	power++

	if(power >= 10)
		power = 0
		health += 10
		if(health > maxHealth)
			health = maxHealth

	// damage_resistance = Clamp(damage_resistance, 0, 50)
	return

/mob/living/simple_animal/hostile/pizza/Bumped(M as mob|obj)
	target = M
	AttackTarget()
	return

/mob/living/simple_animal/hostile/pizza/Die()
	src.visible_message("<b>[src]</b> collapses!")
	if(pizza_type)
		new pizza_type(src.loc)
	del(src)
	return