/mob/living/simple_animal/hostile/beheaded_kamikaze
	name = "beheaded kamikaze"
	desc = "You can't be serious."
	icon_state = "headlesskamikaze"
	icon_living = "headlesskamikaze"
	speak_chance = 80
	emote_taunt = list("screams", "yells")
	taunt_chance = 80
	speed = 0
	maxHealth = 7
	health = 7
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	environment_smash = 1
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	var/taunt = "AAAAA"

/mob/living/simple_animal/hostile/beheaded_kamikaze/New()
	..()
	var/taunt_length = rand(10,20)
	for(var/n in 1 to 5)
		taunt = initial(taunt)
		taunt_length = rand(10,20)
		for(var/i in 1 to taunt_length)
			taunt += "A"
		taunt += "AA!!!"
		speak += list(taunt)


/mob/living/simple_animal/hostile/beheaded_kamikaze/Move()
	playsound(src, 'sound/voice/attackkamikaze.ogg', 80)
	for (var/mob/living/M in orange(2,usr))
		if(!istype(M, /mob/living/simple_animal/hostile/beheaded_kamikaze))
			death()
	..()

/mob/living/simple_animal/hostile/beheaded_kamikaze/death()
	new /obj/effect/gibspawner/human(get_turf(src))
	explosion(src, 0, 0, 3, 0)
	..(1)
	qdel(src)
