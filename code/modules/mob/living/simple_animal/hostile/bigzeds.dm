/mob/living/simple_animal/hostile/bigzed
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 1, OXY = 0)
	environment_smash = 1
	vision_range = 9
	robust_searching = 1
	aggro_vision_range = 9
	idle_vision_range = 9
	can_force_doors = 1
	faction = list("zeds")
	move_to_delay = 5 //This actually controls the speed when chasing
	var/move = 1 //Used to make stomp sound skip every step so it's not as annoying.
	var/raged = 1

/mob/living/simple_animal/hostile/bigzed/scrake
	name = "Scrake"
	desc = "Bloody hell what's that thing he's got on his arm?"
	icon_state = "scrake"
	icon_living = "scrake"
	icon_dead = "scrake_dead"
	emote_see = list("roars", "rages")
	speed = 5
	maxHealth = 300
	health = 300
	attacktext = "chainsaws"
	attack_sound = "sound/weapons/chainsword.ogg"
	harm_intent_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 40
	gold_core_spawnable = 1

/mob/living/simple_animal/hostile/bigzed/Life()
	if(istype(src, /mob/living/simple_animal/hostile/bigzed/scrake)) //For when I make the fleshpound. They'll both act differently when raged.
		if(health <= 140)
			move_to_delay = 2
			if(raged)
				var/rageVoices = list('sound/voice/bigzeds/scrakerage1.ogg','sound/voice/bigzeds/scrakerage2.ogg','sound/voice/bigzeds/scrakerage3.ogg', 'sound/voice/bigzeds/scrakerage4.ogg', 'sound/voice/bigzeds/scrakerage5.ogg')
				playsound(src, pick(rageVoices), 80)
				visible_message("<span class='userdanger'>The scrake begins to rage! Oh shit.</span>")
			raged = 0
	..()

/mob/living/simple_animal/hostile/bigzed/Move()
	if(move >= 1)
		playsound(src, 'sound/mecha/mechstep.ogg', 50, 1)
		move = 0
	else
		move++
	..()

/mob/living/simple_animal/hostile/bigzed/New()
	if(istype(src, /mob/living/simple_animal/hostile/bigzed/scrake)) //Both types of bigzeds will have different spawn sounds.
		if(global.scrake_cooldown == 1)
			playsound(src, 'sound/voice/bigzeds/scrakespawnroar.ogg', 65, 0, 20)
			global.scrake_cooldown = 0
			spawn(100)
				global.scrake_cooldown = 1
	..()

var/scrake_cooldown = 1 //Used to keep from spawn sound stacking if multiple are spawned.
