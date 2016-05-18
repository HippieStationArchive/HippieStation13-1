/mob/living/simple_animal/hostile/oldzombie
	name = "zombie"
	desc = "A horrifying, shambling carcass of what once resembled a human being."
	icon = 'icons/mob/human.dmi'
	icon_state = "zombie_s"
	icon_living = "zombie_s"
	icon_dead = "zombie_dead"
	turns_per_move = 5
	speak_emote = list("groans")
	emote_see = list("groans")
	a_intent = "harm"
	maxHealth = 100
	health = 100
	speed = 3
	harm_intent_damage = 2
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "claws"
	attack_sound = list('sound/weapons/claw_strike1.ogg','sound/weapons/claw_strike2.ogg','sound/weapons/claw_strike3.ogg')
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 370
	unsuitable_atmos_damage = 10
	environment_smash = 1
	robust_searching = 1
	stat_attack = 2
	faction = list("zombie")
	var/mob/living/carbon/human/stored_corpse = null
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3)
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 8
	layer = MOB_LAYER - 0.1
	var/removingairlock = 0
	var/can_possess = 1
	var/startinfected = 1 //to check if they have ever been infected before.
	var/spam_flag_z = 0

/mob/living/simple_animal/hostile/oldzombie/AttackingTarget()
	..()
	var/mob/living/L = target
	if(istype(L, /mob))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.infected == 1)
				src << "<span class='userdanger'>[L] is already infected! Give them time!</span>"
			else
				var/infectchance = rand(1,3)
				if(infectchance == 2)
					if(H.startinfected == 1)
						src.maxHealth = src.maxHealth + 40
						src.health = src.health + 50
						src << "You just infected <b>[L]</b> for the first time! You have gained 40 HP making your max health <b>[src.maxHealth]</b> as well as restored <b>50 HP</b>!"
					src << "You infect <b>[L]!</b> Gaining 20 HP!"
					visible_message("<span class='danger'>[src] bites [L]!</span>")
					playsound(src.loc, 'sound/weapons/bite.ogg', 50, 1)
					H.infected = 1
					H << "That bite felt sore as hell! Its getting worse..."
					H.oldInfect(H)
					src << "<span class='userdanger'>They'll be getting up on their own, just give them a minute!</span>"
		else if (L.stat) //So they don't get stuck hitting a corpse
			visible_message("<span class='danger'>[src] begins tearing [L] apart!</span>")
			src << "<span class='danger'>You begin feasting on [L]...</span>"
			if(do_mob(src, L, 50))
				visible_message("<span class='danger'>[src] tears [L] to pieces!</span>")
				src << "You feast on <b>[L]</b>, restoring your health by <b>50</b>!"
				L.gib()
				src.health = src.health + 50
	/*
	else
		var/mob/living/carbon/human/H = L
		if(H.infected == 1)
			src << "<span class='userdanger'>[L] is already infected! Give them time!</span>"
		else
			var/infectchance = rand(1,3)
			if(infectchance == 2)
				if(H.startinfected == 1)
					src.maxHealth = src.maxHealth + 40
					src.health = src.health + 50
					src << "You just infected <b>[L]</b> for the first time! You have gained 40 HP making your max health <b>[src.maxHealth]</b> as well as restored <b>50 HP</b>!"
				src << "You infect <b>[L]!</b> Gaining 20 HP!"
				visible_message("<span class='danger'>[src] bites [L]!</span>")
				playsound(src.loc, 'sound/weapons/bite.ogg', 50, 1)
				H.infected = 1
				H.oldInfect(H)
	*/

	if(istype(target, /obj/machinery/door/airlock))
		if(!removingairlock)
			var/obj/machinery/door/airlock/A = target
			removingairlock = 1
			visible_message("<span class='danger'>[src] is tearing the airlock open!</span>")
			src << "<span class='notice'>You start tearing apart the airlock... It will take some time...</span>"
			playsound(src.loc, 'sound/machines/airlockzombieforce.ogg', 100, 1)
			playsound(src.loc, 'sound/hallucinations/growl3.ogg', 50, 1)
			if(do_mob(src, A, 150))
				playsound(src.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
				playsound(src.loc, 'sound/machines/airlockforced.ogg', 50, 1)
				var/obj/structure/door_assembly/door = new A.doortype(get_turf(A))
				door.density = 0
				door.anchored = 1
				door.name = "ravaged airlock"
				door.desc = "An airlock that has been torn apart. Looks like it won't be keeping much out now."
				qdel(A)
			removingairlock = 0
		else
			src << "<span class='notice'>You are already tearing an airlock apart!</span>"

/mob/living/simple_animal/hostile/oldzombie/death()
	..()
	src.faction = list("human")
	if(stored_corpse)
		if(ckey)
			stored_corpse.loc = loc
			stored_corpse.ckey = src.ckey
			stored_corpse << "<span class='userdanger'>You're down, but not quite out. You'll need another zombie to bite you in order to come back.</span>"
			//var/mob/living/simple_animal/hostile/oldzombie/holder/D = new/mob/living/simple_animal/hostile/oldzombie/holder(stored_corpse)
			//D.faction = list("human")
			qdel(src)
			qdel(stored_corpse)
	var/mob/living/carbon/human/D = new/mob/living/carbon/human
	D.loc = src.loc
	D.stat = DEAD
	D.set_species(/datum/species/zombie)
	D.infected = 0
	D.startinfected = 0
	D.faction = list("human")
	for(var/mob/dead/observer/ghost in player_list)
		if(src.real_name == ghost.real_name)
			ghost.reenter_corpse()
			break
	//ghost.reenter_corpse
	qdel(src)
	qdel(stored_corpse)


	//src << "<span class='userdanger'>You're down, but not quite out. You'll need another zombie to bite you in order to come back.</span>"

/*
/mob/living/simple_animal/hostile/zombie/death()
	..()
	if(stored_corpse)
		stored_corpse.loc = loc
		if(ckey)
			stored_corpse.ckey = src.ckey
			stored_corpse << "<span class='userdanger'>You're down, but not quite out. You'll need another zombie to bite you in order to come back.</span>"
			var/mob/living/simple_animal/hostile/oldzombie/holder/D = new/mob/living/simple_animal/hostile/oldzombie/holder(stored_corpse)
			D.faction = src.faction
		qdel(src)
		return
	src << "<span class='userdanger'>You're down, but not quite out. You'll need another zombie to bite you in order to come back.</span>"
*/

/*
/mob/living/simple_animal/hostile/oldzombie/proc/Infect(mob/living/carbon/human/H)
	if(H.startinfected == 1)
		H.faction = list("zombie")
		H << "That bite felt sore as hell! Its getting worse..."
		spawn(270)
			H << "<span class='userdanger'>Something really is not right..</span>"
			visible_message("<b>[H]</b> looks very pale...")
			H.adjustBruteLoss(H.health + 15)
			H.Weaken(5)
			H.stuttering = 5
			spawn(370)
				H << "<span class='userdanger'>You feel like you could pass out any second!</span>"
				visible_message("<b>[H]</b> begins staggering about!")
				H.adjustBruteLoss(H.health + 30)
				H.Weaken(10)
				H.stuttering = 10
				H.Stun(5)
				Zombify(H)
	else
		Zombify(H)
*/

/mob/living/simple_animal/hostile/oldzombie/New(turf/loc, provided_key)
	if(can_possess && (!provided_key || !client))
		notify_ghosts("A new NPC zombie has risen in [get_area(src)]! <a href=?src=\ref[src];ghostjoin=1>(Click to take control)</a>")
	..()

/mob/living/simple_animal/hostile/oldzombie/Topic(href, href_list)
	if(href_list["ghostjoin"] && can_possess)
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			attack_ghost(ghost)

/mob/living/simple_animal/hostile/oldzombie/attack_ghost(mob/user)
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
	user << "<b><font size = 3><font color = red>You have transformed into a Zombie. You exist only for one purpose: to spread the infection.</font color></font size></b>"
	user << "Clicking on the doors will let you <b>force-open</b> them."
	user << "Clicking on animal corpses will make you <b>feast</b> on them, restoring your health."
	user << "You will spread the infection through <b>bites</b>, if you manage to infect someone for the first time you gain HP!"
	user << "People will come back after you <b>bite</b> them. This has a random chance of happening when you attack someone."
	user << "You can revive other zombies by <b>attacking</b> them if they are dead!"

/mob/living/simple_animal/hostile/oldzombie/emote(act, m_type=1, message = null)
	if(stat)
		return
	if(act == "scream" && spam_flag_z == 0)
		visible_message("[src] roars!")
		playsound(src.loc, 'sound/hallucinations/veryfar_noise.ogg', 50, 1)
		spam_flag_z = 1
		spawn(40)
			spam_flag_z = 0
/*
/mob/living/simple_animal/hostile/oldzombie/proc/Zombify(mob/living/carbon/human/H)
	visible_message("<span class='danger'>[H] looks a bit odd..</span>")
	H << "<span class='userdanger'>You dont feel right! Somethings wrong! You dont feel...... Dead......</span>"
	H.faction = src.faction
	spawn(rand(100, 130))
		H.set_species(/datum/species/zombie)
		if(H.head) //So people can see they're a zombie
			var/obj/item/clothing/helmet = H.head
			if(!H.unEquip(helmet))
				qdel(helmet)
		if(H.wear_mask)
			var/obj/item/clothing/mask = H.wear_mask
			if(!H.unEquip(mask))
				qdel(mask)
		var/mob/living/simple_animal/hostile/oldzombie/Z = new /mob/living/simple_animal/hostile/oldzombie(H.loc)
		Z.faction = src.faction
		Z.appearance = H.appearance
		Z.transform = matrix()
		Z.pixel_y = 0
		for(var/mob/dead/observer/ghost in player_list)
			if(H.real_name == ghost.real_name)
				ghost.reenter_corpse()
				break
		Z.ckey = H.ckey
		H.stat = DEAD
		H.butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3) //So now you can carve them up when you kill them. Maybe not a good idea for the human versions.
		H.loc = Z
		Z.stored_corpse = H
		for(var/mob/living/simple_animal/hostile/oldzombie/holder/D in H) //Dont want to revive them twice
			qdel(D)
		visible_message("<span class='danger'>[Z] staggers to their feet!</span>")
		Z << "<b><font size = 3><font color = red>You have transformed into a Zombie. You exist only for one purpose: to spread the infection.</font color></font size></b>"
		Z << "Clicking on the doors will let you <b>force-open</b> them."
		Z << "Clicking on animal corpses will make you <b>feast</b> on them, restoring your health."
		Z << "You will spread the infection through <b>bites</b>, if you manage to infect someone for the first time you gain HP!"
		Z << "People will come back after you <b>bite</b> them. This has a random chance of happening when you attack someone."
		Z << "You can revive other zombies by <b>attacking</b> them if they are dead!"
		H.infected = 0
*/

/mob/living/simple_animal/hostile/oldzombie/holder
	name = "infection holder"
	icon_state = "none"
	icon_living = "none"
	icon_dead = "none"
	desc = "You shouldn't be seeing this."
	invisibility = INVISIBILITY_ABSTRACT
	unsuitable_atmos_damage = 0
	stat_attack = 2
	gold_core_spawnable = 0
	AIStatus = AI_OFF
	stop_automated_movement = 1
	density = 0

/mob/living/simple_animal/hostile/oldzombie/holder/New()
	..()
	if(src && istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		H.stat = DEAD
		H.butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3) //So now you can carve them up when you kill them. Maybe not a good idea for the human versions.
		//for(var/mob/living/simple_animal/hostile/oldzombie/holder/D in H) //Dont want to revive them twice
			//qdel(D)
		H.faction = list("zombie")
		H.infected = 0
	qdel(src)
