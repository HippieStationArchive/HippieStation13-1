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
	maxHealth = 150
	health = 150
	speed = 2
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
	var/numinfected = 10
	var/selfrevive = 0
	var/forcedoor = 0
	var/airlocktime = 200
	var/superform = 0
	var/superformtime = 100
	var/canpierce = 0
	languages = ZOMBIE

/mob/living/simple_animal/hostile/oldzombie/AttackingTarget()
	..()
	var/mob/living/L = target
	if(istype(L, /mob))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.infected == 1)
				src << "<span class='userdanger'>[L] is already infected! Give them time!</span>"
			else
				var/infectchance = rand(1,5)
				if(infectchance == 2 && H.health < 20)
					. = 1 // Default to returning true.
					if(H.dna && PIERCEIMMUNE in H.dna.species.specflags)
						. = 0
					if(H.wear_suit && H.wear_suit.flags & THICKMATERIAL)
						. = 0
					if(!. && src && canpierce == 0)
						// Might need re-wording.
						src << "<span class='alert'>There is no exposed flesh or thin material that you are able to pierce, you can purchase Piercing Teeth in the upgrades tab however.</span>"
					else
						if(H.startinfected == 1)
							src.adjustBruteLoss(-50)
							src << "You just infected <b>[L]</b> for the first time! You have restored 50 HP! And gained <b>3</b> additional infection points!"
							src.numinfected = src.numinfected + 3
						src << "You infect <b>[L]!</b> restoring 20 HP!"
						visible_message("<span class='danger'>[src] bites [L]!</span>")
						playsound(src.loc, 'sound/weapons/bite.ogg', 50, 1)
						src.adjustBruteLoss(-20)
						H.infected = 1
						H << "<span class='danger'>That bite felt sore as hell! It's getting worse....</span>"
						H.oldInfect(H)
						src.numinfected = src.numinfected + 2
						src << "You gain <b>1</b> infection point!"
						src << "You now have <b>[src.numinfected]</b> infection points!"
						src << "<span class='userdanger'>They'll be getting up on their own, just give them a minute!</span>"
		else if (L.stat) //So they don't get stuck hitting a corpse
			visible_message("<span class='danger'>[src] begins tearing [L] apart!</span>")
			src << "<span class='danger'>You begin feasting on [L]...</span>"
			if(do_mob(src, L, 50))
				visible_message("<span class='danger'>[src] tears [L] to pieces!</span>")
				src << "You feast on <b>[L]</b>, restoring your health by <b>50</b>!"
				src << "You gain <b>1</b> infection point for feasting on <b>[L]</b>!"
				src.numinfected = src.numinfected + 2
				L.gib()
				src.adjustBruteLoss(-50)

	if(istype(target, /obj/machinery/door/airlock))
		if(src.forcedoor == 1 || removingairlock == 1)
			if(!removingairlock)
				var/obj/machinery/door/airlock/A = target
				removingairlock = 1
				visible_message("<span class='danger'>[src] is tearing the airlock open!</span>")
				src << "<span class='notice'>You start tearing apart the airlock... It will take [src.airlocktime / 10] seconds!</span>"
				playsound(src.loc, 'sound/machines/airlockzombieforce.ogg', 100, 1)
				playsound(src.loc, 'sound/hallucinations/growl3.ogg', 50, 1)
				if(do_mob(src, A, src.airlocktime))
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
		else
			src << "You have not unlocked this ability yet! Purchase it in the zombie tab!"
/*
/mob/living/simple_animal/hostile/oldzombie/verb/levelupspeed()
	set name = "Evolve Speed(Cost: 1)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.speed <= -2)
			target << "Maxed out!"
		else
			if(target.numinfected > 0)
				target.speed = target.speed - 0.1
				target.numinfected = target.numinfected - 1
				target << "You increased your speed by 0.1, speed now at <b>[target.speed]</b>!"
				target << "You now have <b>[target.numinfected]</b> infection points!"
			else
				target << "You don't have enough infection points! You need <b>1</b> more!"
*/
/*
/mob/living/simple_animal/hostile/oldzombie/verb/levelupattack()
	set name = "Evolve Attack(Cost: 1)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.melee_damage_upper >= 60)
			target << "Maxed out!"
		else
			if(target.numinfected > 0)
				target.melee_damage_lower = target.melee_damage_lower + 2
				target.melee_damage_upper = target.melee_damage_upper + 2
				target.numinfected = target.numinfected - 1
				target << "You increased your attack by 2, attack lower now at <b>[target.melee_damage_lower]</b> and upper now at <b>[target.melee_damage_upper]</b>!"
				target << "You now have <b>[target.numinfected]</b> infection points!"
			else
				target << "You don't have enough infection points! You need <b>1</b> more!"
*/
/*
/mob/living/simple_animal/hostile/oldzombie/verb/leveluphealth()
	set name = "Evolve Health(Cost: 1)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.maxHealth >= 300)
			target << "Maxed out!"
		else
			if(target.numinfected > 0)
				target.maxHealth = target.maxHealth + 10
				target.adjustBruteLoss(-10)
				target.numinfected = target.numinfected - 1
				target << "You increased your health by 10, max health now at <b>[target.maxHealth]</b>!"
				target << "You now have <b>[target.numinfected]</b> infection points!"
			else
				target << "You don't have enough infection points! You need <b>1</b> more!"
*/
/mob/living/simple_animal/hostile/oldzombie/verb/selfrevive()
	set name = "Self Revive(Cost: 7)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.selfrevive == 1)
			target << "Already purchased!"
		else
			if(target.numinfected >= 7)
				target.selfrevive = 1
				target.numinfected = target.numinfected - 7
				target << "You will now self revive after a short amount of time! Only once though!"
				target << "You now have <b>[target.numinfected]</b> infection points!"
			else
				target << "You don't have enough infection points! You need <b>[7 - target.numinfected]</b> more!"

/mob/living/simple_animal/hostile/oldzombie/verb/forcedoor()
	set name = "Force Doors(Cost: 3)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.forcedoor == 1)
			target << "Already purchased!"
		else
			if(target.numinfected >= 3)
				target.forcedoor = 1
				target.numinfected = target.numinfected - 3
				target << "You are now able to force open doors! Click on one to open it!"
				target << "You now have <b>[target.numinfected]</b> infection points!"
			else
				target << "You don't have enough infection points! You need <b>[3 - target.numinfected]</b> more!"

/mob/living/simple_animal/hostile/oldzombie/verb/piercingteeth()
	set name = "Piercing Teeth(Cost: 3)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.canpierce == 1)
			target << "Already purchased!"
		else
			if(target.numinfected >= 3)
				target.canpierce = 1
				target.numinfected = target.numinfected - 3
				target << "You are now able to pierce through hardsuits and bio suits!"
				target << "You now have <b>[target.numinfected]</b> infection points!"
			else
				target << "You don't have enough infection points! You need <b>[3 - target.numinfected]</b> more!"

/mob/living/simple_animal/hostile/oldzombie/verb/restorehealth()
	set name = "Regen Health(Cost: 6)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.numinfected >= 4)
			target.adjustBruteLoss(-target.health)
			target << "You regenerate, restoring your health!"
			target.numinfected = target.numinfected - 6
			target << "You now have <b>[target.numinfected]</b> infection points!"
		else
			target << "You don't have enough infection points! You need <b>[6 - target.numinfected]</b> more!"

/mob/living/simple_animal/hostile/oldzombie/verb/airlockfaster()
	set name = "Airlock Force Time(Cost: 1)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "You can't do this while in superform!"
	else
		if(target.forcedoor == 1)
			if(target.airlocktime <= 20)
				target << "Maxed out!"
			else
				if(target.numinfected > 0)
					target.airlocktime = target.airlocktime - 10
					target.numinfected = target.numinfected - 1
					target << "You will now open doors in <b>[target.airlocktime / 10]</b> seconds!"
					target << "You now have <b>[target.numinfected]</b> infection points!"
				else
					target << "You don't have enough infection points! You need <b>1</b> more!"
		else
			target << "You have not purchaed <b>force doors</b> yet!"
/*
/mob/living/simple_animal/hostile/oldzombie/verb/superform()
	set name = "Ultimate Form(Cost: 25)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superform == 1)
		target << "Already in superform!"
	else
		if(target.numinfected >= 25)
			if(alert(target, "Are you sure? This can't be undone.", "Confirm","Yes", "No") == "Yes")
				var/mob/living/simple_animal/hostile/bigzed/scrake/S = new/mob/living/simple_animal/hostile/bigzed/scrake
				S.loc = target.loc
				S.move_to_delay = 3
				S.maxHealth = 500
				S.health = 500
				S.ckey = target.ckey
				S.faction = list("zombie")
				visible_message("<span class = 'userdanger'>[target] mutates! Forming a large chansaw like arm! AHHH!</span>")
				playsound(S.loc, 'sound/voice/bigzeds/scrakerage5.ogg', 50, 1)
				S << "<span class='userdanger'>You are on the zombies team! Fight with them!</span>"
				qdel(target)
		else target << "You don't have enough infection points! You need <b>[15 - target.numinfected]</b> more!"
*/
/*
/mob/living/simple_animal/hostile/oldzombie/verb/superform()
	set name = "Super Form(Cost: 10)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr

	if(target.superform == 1)
		target << "Already Purchased!"
	else
		if(target.numinfected >= 10)
			target.numinfected = numinfected - 10
			target << "You now have <b>[target.numinfected]</b> infection points!"
			takesuperform(target)
		else
			target << "You don't have enough infection points! You need <b>[10 - target.numinfected]</b> more!"
*/
/*
/mob/living/simple_animal/hostile/oldzombie/verb/upgradesuperform()
	set name = "Upgrade Super Form(Cost: 2)"
	set category = "Zombie"

	var/mob/living/simple_animal/hostile/oldzombie/target = usr
	if(target.superformtime >= 300)
		target << "Maxed out!"
	else
		if(target.numinfected >= 2)
			target.superformtime = target.superformtime + 10
			target.numinfected = numinfected - 2
			target << "You will now take super form for <b>[target.superformtime / 10]</b> seconds!"
			target << "You now have <b>[target.numinfected]</b> infection points!"
		else
			target << "You don't have enough infection points! You need <b>[2 - target.numinfected]</b> more!"
*/
/*
/mob/living/simple_animal/hostile/oldzombie/proc/takesuperform(mob/living/simple_animal/hostile/oldzombie/Z)
	var/oldmaxhealth = Z.maxHealth
	var/oldhealth = Z.health
	var/oldmelee_lower = Z.melee_damage_lower
	var/oldmelee_upper = Z.melee_damage_upper
	var/oldforcedoor = Z.forcedoor
	var/oldairlocktime = Z.airlocktime
	var/oldspeed = Z.speed
	visible_message("<span class='userdanger'>[Z] takes on super form! Watch out!")
	Z << "<span class='danger'>We take on our super form! Making us almost invinsible!</span>"
	Z << "This will last for <b>[Z.superformtime / 10]</b> seconds!"
	Z.maxHealth = 2000
	Z.health = 2000
	Z.melee_damage_lower = 40
	Z.melee_damage_upper = 40
	Z.superform = 1
	Z.speed = 0
	Z.airlocktime = 10
	Z.forcedoor = 1
	playsound(Z.loc, 'sound/voice/bigzeds/scrakerage5.ogg', 50, 1)
	spawn(Z.superformtime)
		Z.maxHealth = oldmaxhealth
		Z.health = oldhealth
		Z.melee_damage_lower = oldmelee_lower
		Z.melee_damage_upper = oldmelee_upper
		Z.forcedoor = oldforcedoor
		Z.airlocktime = oldairlocktime
		Z.speed = oldspeed
		Z.superform = 0
*/
/mob/living/simple_animal/hostile/oldzombie/Stat()
	..()
	if(statpanel("Status"))
		stat("Infection Points", numinfected)
		stat("", null)
		var/sts
		if(selfrevive == 1)
			sts = "Yes"
		else
			sts = "No"
		stat("Self Revive", sts)
		var/stsdoor
		if(forcedoor == 1)
			stsdoor = "Yes"
		else
			stsdoor = "No"
		stat("Foce Doors", stsdoor)
		var/super
		if(superform == 1)
			super = "YES!!!!"
		else
			super = "No"
		stat("Super Form", super)

/mob/living/simple_animal/hostile/oldzombie/death()
	..()
	src.faction = list("human")
	if(stored_corpse)
		if(ckey)
			stored_corpse.loc = loc
			stored_corpse.ckey = src.ckey
			if(src.selfrevive == 1)
				stored_corpse << "<span class='userdanger'>You will now come back as you purchased self revive! However you will not come back again unless you purchase it again, you have lost all upgrades too!</span>"
				stored_corpse.oldInfect(stored_corpse)
				stored_corpse.numinfectedh = src.numinfected
			else
				stored_corpse << "<span class='userdanger'>You're down, but not quite out. You'll need another zombie to bite you in order to come back.</span>"
			qdel(src)
	else
		var/mob/living/carbon/human/D = new/mob/living/carbon/human
		D.loc = src.loc
		D.ckey = src.ckey
		D.stat = DEAD
		D.set_species(/datum/species/zombie)
		D.infected = 0
		D.startinfected = 0
		D.faction = list("human")
		D.adjustBruteLoss(200)
		for(var/mob/dead/observer/ghost in player_list)
			if(src.real_name == ghost.real_name)
				ghost.reenter_corpse()
				break
		//ghost.reenter_corpse
		if(src.selfrevive == 1)
			D << "<span class='userdanger'>You will now come back as you purchased self revive! However you will not come back again unless you purchase it again, you have lost all upgrades too!</span>"
			D.oldInfect(D)
			D.numinfectedh = src.numinfected
		else
			D << "<span class='userdanger'>You're down, but not quite out. You'll need another zombie to bite you in order to come back.</span>"
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
	user << "<b><font size = 3><font color = red>You have transformed into a Zombie. You exist only for one purpose: to spread the infection.</font color></font size></b>"
	user << "Clicking on the doors will let you <b>force-open</b> them."
	user << "Clicking on animal corpses will make you <b>feast</b> on them, restoring your health."
	user << "You will spread the infection through <b>bites</b>, if you manage to infect someone for the first time you gain HP!"
	user << "People will come back after you <b>bite</b> them. This has a random chance of happening when you attack someone."
	user << "You can revive other zombies by <b>attacking</b> them if they are dead!"
	user << "You can upgrade your stats via the Zombie tab! Every person you infect you gain <b>1</b> infection point, if they were infected for the first time you gain <b>3</b>!"
	key = user.key

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
