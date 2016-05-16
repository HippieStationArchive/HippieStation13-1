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
	environment_smash = 1 //Can smash tables and lockers, etc.
	can_force_doors = 1 //Can force doors open like a champ
	robust_searching = 1
	stat_attack = 1 //Can attack unconscious players
	gold_core_spawnable = 0 //No.
	faction = list("zombie")
	languages = ZOMBIE

	var/infection = 25 //Chance of infecting the victim.
	var/mob/living/carbon/human/stored_corpse = null
	var/original_corpse_ckey = null

	var/list/z_armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

	var/can_possess = 1 //Whether or not this zombie can be possessed by ghosts

	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3)
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 5

/mob/living/simple_animal/hostile/zombie/attack_threshold_check(damage, damagetype = BRUTE)
	var/picked_zone = ran_zone("chest", 65)
	var/armor = run_armor_check(picked_zone, damagetype)
	apply_damage(damage, damagetype, picked_zone, armor)

/mob/living/simple_animal/hostile/zombie/getarmor(def_zone, type)
	return z_armor[type]

/mob/living/simple_animal/hostile/zombie/bullet_act(obj/item/projectile/P, def_zone) //Copy-pasted mob/living/bullet_act so armor works
	var/armor = run_armor_check(def_zone, P.flag, "","",P.armour_penetration)
	if(!P.nodamage)
		apply_damage(P.damage, P.damage_type, def_zone, armor)
	return P.on_hit(src, armor, def_zone)

/mob/living/simple_animal/hostile/zombie/New(turf/loc, provided_key)
	if(can_possess && (!provided_key || !client))
		notify_ghosts("A new NPC zombie has risen in [get_area(src)]! <a href=?src=\ref[src];ghostjoin=1>(Click to take control)</a>")
	..()

/mob/living/simple_animal/hostile/zombie/Topic(href, href_list)
	if(href_list["ghostjoin"] && can_possess)
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			attack_ghost(ghost)

/mob/living/simple_animal/hostile/zombie/attack_ghost(mob/user)
	if(!can_possess)
		user << "This zombie cannot be possessed!"
		return
	if(ckey && client)
		user << "The zombie is already controlled by a player."
		return
	if(stat)
		user << "The zombie is dead!"
		return
	var/be_zombie = alert("Become a zombie? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(be_zombie == "No")
		return
	if(ckey && client)
		user << "The zombie is already controlled by a player."
		return
	if(stat)
		user << "The zombie is dead!"
		return
	key = user.key

/mob/living/simple_animal/hostile/zombie/Login()
	..()
	UpdateInfectionImage()
	if(mind)
		ticker.mode.add_zombie(mind)
	src << "<b><font size = 3><font color = red>You have transformed into a Zombie. You exist only for one purpose: to spread the infection.</font color></font size></b>"
	src << "Clicking on the doors will let you <b>force-open</b> them. Time taken depends on if the door is bolted, welded or both."
	src << "Clicking on animal corpses will make you <b>feast</b> on them, restoring your health."
	src << "You will spread the infection through <b>bites</b>. they have a random chance of happening when you attack a human being."
	src << "The zombie disease will make zombies <b>even out of dead humans</b>. Therefore it's better to kill your victims as soon as possible."

/mob/living/simple_animal/hostile/zombie/Logout()
	..()
	if(mind)
		ticker.mode.update_zombie_icons_removed(mind)
	UpdateInfectionImage()

/mob/living/simple_animal/hostile/zombie/AttackingTarget()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(ishuman(L))
			if(prob(infection))
				var/mob/living/carbon/human/H = L
				attacktext = "bites"
				attack_sound = list('sound/weapons/bite.ogg')
				var/datum/disease/zombie/Z = new()
				if(H.ContractDisease(Z)) //This does checks for bioclothes, etc.
					src << "<span class='userdanger'>You have succesfully infected [H]!</span>"
					UpdateInfectionImage()
				else
					if(H.HasDisease(Z))
						src << "<span class='userdanger'>[H] is already infected!</span>"
					else
						src << "<span class='userdanger'>You couldn't quite bite into [H].</span>"
					qdel(Z) //Delete the disease due to contract failure. Otherwise controller might shit itself.
		else if (L.stat) //Not human, feast!
			playsound(loc, 'sound/weapons/slice.ogg', 50, 1, -1)
			visible_message("<span class='danger'>[src] begins consuming [L]!</span>",\
							"<span class='userdanger'>You begin feasting on [L]...</span>")
			if(do_mob(src, L, 60))
				visible_message("<span class='danger'>[src] tears [L] to pieces!</span>",\
								"<span class='userdanger'>You feast on [L], restoring your health!</span>")
				L.gib()
				revive()
			return

	target.attack_animal(src)
	attacktext = "claws"
	attack_sound = list('sound/weapons/claw_strike1.ogg','sound/weapons/claw_strike2.ogg','sound/weapons/claw_strike3.ogg')

/mob/living/simple_animal/hostile/zombie/death()
	..()
	if(stored_corpse)
		stored_corpse.loc = get_turf(src)
		if(mind)
			mind.transfer_to(stored_corpse)
		else
			stored_corpse.key = key
		qdel(src)

/mob/living/carbon/human/proc/Zombify()
	// if(istype(loc, /mob/living/simple_animal/hostile/zombie)) return
	set_species(/datum/species/zombie)
	var/mob/living/simple_animal/hostile/zombie/Z = new /mob/living/simple_animal/hostile/zombie(loc, ckey)
	if(wear_suit)
		var/obj/item/clothing/suit/armor/A = wear_suit
		if(A.armor)
			Z.z_armor = A.armor //Set zombie's armor to that
	Z.health = Z.maxHealth
	Z.faction = list("zombie")
	Z.appearance = appearance
	Z.transform = matrix()
	Z.pixel_y = 0
	if(stat != DEAD)
		death(0)
	loc = Z
	for(var/mob/dead/observer/ghost in player_list)
		if(real_name == ghost.real_name)
			ghost.reenter_corpse()
			break
	if(mind)
		mind.transfer_to(Z)
	else
		Z.key = key
	Z.stored_corpse = src
	ticker.mode.add_zombie(Z.mind)
	playsound(Z.loc, pick('sound/effects/bodyscrape-01.ogg', 'sound/effects/bodyscrape-02.ogg'), 40, 1, -2)
	Z.visible_message("<span class='danger'>[Z] staggers to their feet!</span>")

/mob/living/simple_animal/hostile/zombie/proc/UpdateInfectionImage()
	if (client)
		for(var/image/I in client.images)
			if(dd_hasprefix_case(I.icon_state, "zvirus"))
				qdel(I)
		for (var/mob/living/carbon/human/H in mob_list)
			if(H.HasDisease(/datum/disease/zombie))
				var/datum/disease/zombie/Z = locate() in H.viruses
				if(Z)
					var/I = image('icons/mob/zombie.dmi', loc = H, icon_state = "zvirus[Z.stage]")
					client.images += I