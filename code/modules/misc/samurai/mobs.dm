

/mob/living/simple_animal/hostile/skel
	name = "Skeleton"
	desc = "Defense against the dark arts has nothing against this thing."
	icon = 'icons/mob/animal.dmi'
	speak_emote = list("moans")
	//icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton"
	health = 10
	maxHealth = 10
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = "rattles"
	attack_sound = 'sound/mob/samurai/skeletonhit.ogg'
	faction = "creature"

	Life()
		..()
		if(stat == 2)
			new/obj/effect/decal/remains/human/skel(src.loc)
			playsound(src.loc, 'sound/mob/samurai/SkeletonPile.ogg', 50, 1)
			visible_message("\red [src] falls down in a heap.")
			del(src)
			return

	Move()
		..()
		if(prob(15))
			var/Z = rand(1,2)
			switch(Z)
				if(1)
					playsound(src.loc, 'sound/mob/samurai/skelestep1.ogg', 50, 1)
				if(2)
					playsound(src.loc, 'sound/mob/samurai/skelestep2.ogg', 50, 1)




/mob/living/simple_animal/hostile/samureye
	name = "Samur-Eye"
	desc = "I see."
	icon = 'icons/mob/critter.dmi'
	icon_state = "samureye"
	pass_flags = PASSBLOB
	health = 200
	melee_damage_lower = 1
	melee_damage_upper = 5
	var/samurainame
	attacktext = "attacks"
	attack_sound = 'sound/weapons/genhit1.ogg'

/mob/living/simple_animal/hostile/samureye/attack_paw(mob/living/carbon/monkey/M as mob)
	attack_hand(M)

/mob/living/simple_animal/hostile/samureye/attack_alien(mob/living/carbon/M as mob)
	attack_hand(M)

/mob/living/simple_animal/hostile/samureye/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(isliving(M))
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/C = M
			if(prob(25) && !C.weakened)
				C.weakened = 5
				C << "The Samur-Eye knocks you down."
				src << "You have knocked [C.name] down. Attack again to take over."
				return
			if(C.weakened)
				ghostize(C)
				spawn(0)
					C.name = samurainame
					C.real_name = samurainame
					C.equip_samurai()
					C.ckey = src.ckey
					C.key = src.key
					C.client = src.client
				return










/obj/effect/decal/remains/human/skel
	name = "remains"
	desc = "They look like human remains."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = 0

	New()
		spawn(200)
			visible_message("The human remains reanimates!")
			spawn(1)
				new/mob/living/simple_animal/hostile/skel(src.loc)
				playsound(src.loc, 'sound/mob/samurai/SkeletonReanimate.ogg', 50, 1)
				del(src)
				return
