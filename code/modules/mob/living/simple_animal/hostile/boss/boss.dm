// Only here to serve as a filter, say you don't want boss mobs to spawn from gold slimes

/mob/living/simple_animal/hostile/boss
	name = "boss"
	desc = "clearly a menace to society"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

/mob/living/simple_animal/hostile/boss/death(gibbed)
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/boss/gib()
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/boss/dust()
	if(health > 0)
		return
	else
		..()
