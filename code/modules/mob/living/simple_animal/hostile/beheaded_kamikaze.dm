/mob/living/simple_animal/hostile/beheaded_kamikaze
	name = "beheaded kamikaze"
	desc = "You can't be serious."
	icon_state = "clown" //placeholder
	icon_living = "clown" //placeholder
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

	var/taunt_length = 10
	taunt_length = taunt_length + rand(10,20)
	var/taunt = "AAAAA"

	for(var/i=1; i<=taunt_length; i++)
		taunt += 'A'

	taunt += 'GH!!!'
	speak = list(taunt)

/mob/living/simple_animal/hostile/beheaded_kamikaze/Move()
	playsound(src, 'sound/voice/attackkamikaze.ogg', 80)
	for (var/mob/M in orange(2,usr))
		if(!istype(M, /mob/living/simple_animal/hostile/beheaded_kamikaze))
			death()
	..()

/mob/living/simple_animal/hostile/beheaded_kamikaze/death()
	new /obj/effect/gibspawner/human(get_turf(src))
	explosion(src, 0, 0, 2, 1)
	..(1)
	qdel(src)
