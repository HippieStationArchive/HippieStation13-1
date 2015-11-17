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
	stat_attack = 1
	gold_core_spawnable = 0 //No.
	faction = list("zombie")
	languages = ZOMBIE

	var/infection = 20 //Chance of infecting the victim.
	var/mob/living/carbon/human/stored_corpse = null
	var/original_corpse_ckey = null

	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3)
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 5

/mob/living/simple_animal/hostile/zombie/New(turf/loc, provided_key)
	ckey = provided_key
	if(!provided_key || !client)
		notify_ghosts("A new NPC zombie has risen in [get_area(src)]! <a href=?src=\ref[src];ghostjoin=1>(Click to take control)</a>")
	..()

/mob/living/simple_animal/hostile/zombie/Topic(href, href_list)
	if(href_list["ghostjoin"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			attack_ghost(ghost)

/mob/living/simple_animal/hostile/zombie/attack_ghost(mob/user)
	if(ckey && client)
		user << "The zombie is already controlled by a player."
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
	src << "<b>You have transformed into a Zombie. You exist only for one purpose: to spread the infection.</b>"
	src << "<b>Clicking on the doors will let you force-open them. Time taken depends on if the door is bolted, welded or both.</b>"
	src << "<b>Clicking on animal corpses will make you feast on them, restoring your health.</b>"
	src << "<b>You will spread the infection through BITES. they have a random chance of happening when you attack a human being.</b>"
	src << "<b>The zombie disease will make zombies even out of dead humans, but you can only spread it to living humans. Therefore it's not important to keep your victims alive.</b>"

/mob/living/simple_animal/hostile/zombie/AttackingTarget()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(ishuman(L))
			if(prob(infection))
				var/mob/living/carbon/human/H = L
				attacktext = "bites"
				attack_sound = list('sound/weapons/bite.ogg')
				H.ContractDisease(new /datum/disease/transformation/zombie) //You. Got. INFECTED.
		else if (L.stat) //Not human, feast!
			playsound(loc, 'sound/weapons/slice.ogg', 50, 1, -1)
			visible_message("<span class='danger'>[src] begins consuming [L]!</span>",\
							"<span class='userdanger'>You begin feasting on [L]...</span>")
			if(do_mob(src, L, 80))
				visible_message("<span class='danger'>[src] tears [L] to pieces!</span>",\
								"<span class='userdanger'>You feast on [L], restoring your health!</span>")
				L.gib()
				src.revive()
				return

	target.attack_animal(src)
	attacktext = "claws"
	attack_sound = list('sound/weapons/claw_strike1.ogg','sound/weapons/claw_strike2.ogg','sound/weapons/claw_strike3.ogg')

/mob/living/simple_animal/hostile/zombie/death()
	..()
	if(stored_corpse)
		stored_corpse.loc = loc
		if(ckey)
			stored_corpse.ckey = src.ckey //This can potentially let ghosts get cloned from a zombie corpse
		qdel(src)
		return

/proc/Zombify(mob/living/carbon/human/H)
	if(!istype(H)) return
	H.death(1)
	H.update_canmove()
	H.set_species(/datum/species/zombie)
	ticker.mode.add_zombie(H.mind)
	for(var/mob/dead/observer/ghost in player_list)
		if(H.real_name == ghost.real_name)
			ghost.reenter_corpse()
			break
	var/mob/living/simple_animal/hostile/zombie/Z = new /mob/living/simple_animal/hostile/zombie(H.loc, H.ckey)
	if(H.wear_suit)
		var/obj/item/clothing/suit/armor/A = H.wear_suit
		if(A.armor && A.armor["melee"])
			Z.maxHealth += A.armor["melee"] //That zombie's got armor, I want armor!
	Z.health = Z.maxHealth
	Z.faction = list("zombie")
	Z.appearance = H.appearance
	Z.transform = matrix()
	Z.pixel_y = 0
	H.stat = DEAD
	H.loc = Z
	Z.original_corpse_ckey = H.ckey
	Z.stored_corpse = H
	playsound(Z.loc, pick('sound/effects/bodyscrape-01.ogg', 'sound/effects/bodyscrape-02.ogg'), 40, 1, -2)
	Z.visible_message("<span class='danger'>[Z] staggers to their feet!</span>")