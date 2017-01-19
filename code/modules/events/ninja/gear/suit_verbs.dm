//Moved all this shit into one file -QC

///////////Bullshit Begins///////////////
/*
This section has been moved from suit_verbs_handlers.dm
Remove and replace if it causes issues.
-QC

Contents:
- Procs that add ninja verbs to ninjas
- Procs that remove ninja verbs from ninjas
- Procs that add ninjasuit verbs to ninjas
- Procs that remove ninjasuit verbs from ninjas

*/

/obj/item/clothing/suit/space/space_ninja/proc/grant_equip_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/init
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth
	n_gloves.verbs += /obj/item/clothing/gloves/space_ninja/proc/toggled

	s_initialized = 1


/obj/item/clothing/suit/space/space_ninja/proc/remove_equip_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/init
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/stealth
	if(n_gloves)
		n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled

	s_initialized = 0


/obj/item/clothing/suit/space/space_ninja/proc/grant_ninja_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjaboost
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjanet
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninja_sword_recall

	s_initialized=1
	slowdown=0


/obj/item/clothing/suit/space/space_ninja/proc/remove_ninja_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjaboost
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjanet
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninja_sword_recall

///////////////Bullshit Ends///////////////////


/*
Energy Net:
It will teleport people to a holding facility after 30 seconds. (Check the process() proc to change where teleport goes)
It is possible to destroy the net by the occupant or someone else.
*/

/obj/item/clothing/suit/space/space_ninja/proc/ninjanet(mob/living/carbon/C in oview())//Only living carbon mobs.
	set name = "Energy Net (20E)"
	set desc = "Captures a fallen opponent in a net of energy. Will teleport them to a holding facility after 30 seconds."
	set category = null
	set src = usr.contents

	if(!ninjacost(200,N_STEALTH_CANCEL) && iscarbon(C))
		var/mob/living/carbon/human/H = affecting
		if(C.client)//Monkeys without a client can still step_to() and bypass the net. Also, netting inactive people is lame.
			if(!locate(/obj/effect/energy_net) in C.loc)//Check if they are already being affected by an energy net.
				for(var/turf/T in getline(H.loc, C.loc))
					if(T.density)//Don't want them shooting nets through walls. It's kind of cheesy.
						H << "<span class='warning'>You may not use an energy net through solid obstacles!</span>"
						return
				spawn(0)
					H.Beam(C,"n_beam",,15)
				H.say("Get over here!")
				var/obj/effect/energy_net/E = new /obj/effect/energy_net(C.loc)
				E.layer = C.layer+1//To have it appear one layer above the mob.
				H.visible_message("<span class='danger'>[H] caught [C] with an energy net!</span>","<span class='notice'>You caught [C] with an energy net!</span>")
				E.affecting = C
				E.master = H
				spawn(0)//Parallel processing.
					E.process(C)
			else
				H << "<span class='warning'>They are already trapped inside an energy net!</span>"
		else
			H << "<span class='warning'>They will bring no honor to your Clan!</span>"
	return


//The actual net


/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1//Can't pass through.
	opacity = 0//Can see through.
	mouse_opacity = 1//So you can hit it with stuff.
	anchored = 1//Can't drag/grab the trapped mob.

	var/health = 25//How much health it has.
	var/mob/living/affecting = null//Who it is currently affecting, if anyone.
	var/mob/living/master = null//Who shot web. Will let this person know if the net was successful or failed.



/obj/effect/energy_net/proc/healthcheck()
	if(health <=0)
		density = 0
		if(affecting)
			var/mob/living/carbon/M = affecting
			M.anchored = 0
			for(var/mob/O in viewers(src, 3))
				O.show_message("[M.name] was recovered from the energy net!", 1, "<span class='italics'>You hear a grunt.</span>", 2)
			if(!isnull(master))//As long as they still exist.
				master << "<span class='userdanger'>ERROR</span>: unable to initiate transport protocol. Procedure terminated."
		qdel(src)
	return



/obj/effect/energy_net/process(mob/living/carbon/M)
	var/check = 30//30 seconds before teleportation. Could be extended I guess.
	var/mob_name = affecting.name//Since they will report as null if terminated before teleport.
	//The person can still try and attack the net when inside.

	M.notransform = 1 //No moving for you!

	while(!isnull(M)&&!isnull(src)&&check>0)//While M and net exist, and 30 seconds have not passed.
		check--
		sleep(10)

	if(isnull(M)||M.loc!=loc)//If mob is gone or not at the location.
		if(!isnull(master))//As long as they still exist.
			master << "<span class='userdanger'>ERROR</span>: unable to locate \the [mob_name]. Procedure terminated."
		qdel(src)//Get rid of the net.
		M.notransform = 0
		return

	if(!isnull(src))//As long as both net and person exist.
		//No need to check for countdown here since while() broke, it's implicit that it finished.

		density = 0//Make the net pass-through.
		invisibility = 101//Make the net invisible so all the animations can play out.
		health = INFINITY//Make the net invincible so that an explosion/something else won't kill it while, spawn() is running.
		for(var/obj/item/W in M)
			if(istype(M,/mob/living/carbon/human))
				if(W==M:w_uniform)	continue//So all they're left with are shoes and uniform.
				if(W==M:shoes)	continue
			M.unEquip(W)

		spawn(0)
			playsound(M.loc, 'sound/effects/sparks4.ogg', 50, 1)
			anim(M.loc,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

		M.loc = pick(holdingfacility)//Throw mob in to the holding facility.
		M << "<span class='danger'>You appear in a strange place!</span>"

		spawn(0)
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, M.loc)
			spark_system.start()
			playsound(M.loc, 'sound/effects/phasein.ogg', 25, 1)
			playsound(M.loc, 'sound/effects/sparks2.ogg', 50, 1)
			anim(M.loc,M,'icons/mob/mob.dmi',,"phasein",,M.dir)
			qdel(src)//Wait for everything to finish, delete the net. Else it will stop everything once net is deleted, including the spawn(0).

		for(var/mob/O in viewers(src, 3))
			O.show_message("[M] vanishes!", 1, "<span class='italics'>You hear sparks flying!</span>", 2)

		if(!isnull(master))//As long as they still exist.
			master << "<span class='notice'><b>SUCCESS</b>: transport procedure of \the [affecting] complete.</span>"
		M.notransform = 0

	else//And they are free.
		M << "<span class='notice'>You are free of the net!</span>"
		M.notransform = 0
	return



/obj/effect/energy_net/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	healthcheck()
	..()



/obj/effect/energy_net/ex_act(severity, target)
	switch(severity)
		if(1)
			health-=50
		if(2)
			health-=50
		if(3)
			health-=prob(50)?50:25
	healthcheck()
	return



/obj/effect/energy_net/blob_act()
	health-=50
	healthcheck()
	return



/obj/effect/energy_net/hitby(AM as mob|obj)
	..()
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()
	return



/obj/effect/energy_net/attack_hulk(mob/living/carbon/human/user)
	..(user, 1)
	user.visible_message("<span class='danger'>[user] rips the energy net apart!</span>", \
								"<span class='notice'>You easily destroy the energy net.</span>")
	health-=50
	healthcheck()



/obj/effect/energy_net/attack_paw(mob/user)
	return attack_hand()



/obj/effect/energy_net/attack_alien(mob/living/user)
	user.do_attack_animation(src)
	if (islarva(user))
		return
	playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
	health -= rand(10, 20)
	if(health > 0)
		user.visible_message("<span class='danger'>[user] claws at the energy net!</span>", \
					 "\green You claw at the net.")
	else
		user.visible_message("<span class='danger'>[user] slices the energy net apart!</span>", \
						 "\green You slice the energy net to pieces.")
	healthcheck()
	return



/obj/effect/energy_net/attackby(obj/item/weapon/W, mob/user, params)
	var/aforce = W.force
	health = max(0, health - aforce)
	healthcheck()
	..()
	return

/*
Adrenaline Boost:
Wakes the user so they are able to do their thing. Also injects a decent dose of radium.
Movement impairing would indicate drugs and the like.
*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost()
	set name = "Adrenaline Boost"
	set desc = "Inject a secret chemical that will counteract all movement-impairing effect."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost(0,N_ADRENALINE))//Have to make sure stat is not counted for this ability.
		var/mob/living/carbon/human/H = affecting
		H.SetParalysis(0)
		H.SetStunned(0)
		H.SetWeakened(0)

		H.stat = 0//At least now you should be able to teleport away or shoot ninja stars.
		spawn(30)//Slight delay so the enemy does not immedietly know the ability was used. Due to lag, this often came before waking up.
			H.say(pick("A CORNERED FOX IS MORE DANGEROUS THAN A JACKAL!","HURT ME MOOORRREEE!","IMPRESSIVE!"))
		spawn(70)
			if(reagents.total_volume)
				var/fraction = min(a_transfer/reagents.total_volume, 1)
				reagents.reaction(H, INJECT, fraction)
			reagents.trans_id_to(H, "radium", a_transfer)
			H << "<span class='danger'>You are beginning to feel the after-effect of the injection.</span>"
		a_boost--
		s_coold = 3
	return


/*
EM Pulse:
Disables nearby tech equipment.
*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjapulse()
	set name = "EM Burst (25E)"
	set desc = "Disable any nearby technology with a electro-magnetic pulse."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost(250,N_STEALTH_CANCEL))
		var/mob/living/carbon/human/H = affecting
		playsound(H.loc, 'sound/effects/EMPulse.ogg', 60, 2)
		empulse(H, 4, 6) //Procs sure are nice. Slightly weaker than wizard's disable tch.
		s_coold = 2
	return


//Smoke bomb
/obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke()
	set name = "Smoke Bomb"
	set desc = "Blind your enemies momentarily with a well-placed smoke bomb."
	set category = "Ninja Ability"
	set popup_menu = 0//Will not see it when right clicking.

	if(!ninjacost(0,N_SMOKE_BOMB))
		var/mob/living/carbon/human/H = affecting
		var/datum/effect_system/smoke_spread/bad/smoke = new
		smoke.set_up(4, H.loc)
		smoke.start()
		playsound(H.loc, 'sound/effects/bamf.ogg', 50, 2)
		s_bombs--
		H << "<span class='notice'>There are <B>[s_bombs]</B> smoke bombs remaining.</span>"
		s_coold = 1
	return


//Throwing Stars
/obj/item/clothing/suit/space/space_ninja/proc/ninjastar()
	set name = "Create Throwing Stars (1E)"
	set desc = "Creates some throwing stars"
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost(10))
		var/mob/living/carbon/human/H = affecting
		var/slot = H.hand ? slot_l_hand : slot_r_hand

		if(H.equip_to_slot_or_del(new /obj/item/weapon/throwing_star/ninja(H), slot))
			H << "<span class='notice'>A throwing star has been created in your hand!</span>"

		H.throw_mode_on() //So they can quickly throw it.


/obj/item/weapon/throwing_star/ninja
	name = "ninja throwing star"
	throwforce = 30
	embedded_pain_multiplier = 6



//Stealth Field
/obj/item/clothing/suit/space/space_ninja/proc/toggle_stealth()
	var/mob/living/carbon/human/U = affecting
	if(!U)
		return
	if(s_active)
		cancel_stealth()
	else
		if(cell.charge <= 0)
			U << "<span class='warning'>You don't have enough power to enable Stealth!</span>"
			return
		s_active=!s_active
		animate(U, alpha = 0,time = 15)
		U.visible_message("<span class='warning'>[U.name] vanishes into thin air!</span>", \
						"<span class='notice'>You are now invisible to normal detection.</span>")
	return


/obj/item/clothing/suit/space/space_ninja/proc/cancel_stealth()
	var/mob/living/carbon/human/U = affecting
	if(!U)
		return 0
	if(s_active)
		s_active=!s_active
		animate(U, alpha = 255, time = 15)
		U.visible_message("<span class='warning'>[U.name] appears from thin air!</span>", \
						"<span class='notice'>You are now visible.</span>")
		return 1
	return 0


/obj/item/clothing/suit/space/space_ninja/proc/stealth()
	set name = "Toggle Stealth"
	set desc = "Utilize the internal CLOAK-tech device to activate or deactivate stealth-camo."
	set category = "Ninja Equip"

	if(!s_busy)
		toggle_stealth()
	else
		affecting << "<span class='danger'>Stealth does not appear to work!</span>"


/*
Sword Recall:
Recalls Energy Sword to hand if the ninja loses it like a dunce.
*/
/obj/item/clothing/suit/space/space_ninja/proc/ninja_sword_recall()
	set name = "Recall Energy Katana (Variable Cost)"
	set desc = "Teleports the Energy Katana linked to this suit to it's wearer, cost based on distance."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/mob/living/carbon/human/H = affecting

	var/cost = 0
	var/inview = 1

	if(!energyKatana)
		H << "<span class='warning'>Could not locate Energy Katana!</span>"
		return

	if(energyKatana in H)
		return

	var/distance = get_dist(H,energyKatana)

	if(!(energyKatana in view(H)))
		cost = distance //Actual cost is cost x 10, so 5 turfs is 50 cost.
		inview = 0

	if(!ninjacost(cost))
		if(istype(energyKatana.loc, /mob/living/carbon))
			var/mob/living/carbon/C = energyKatana.loc
			C.unEquip(energyKatana)

			//Somebody swollowed my sword, probably the clown doing a circus act.
			if(energyKatana in C.stomach_contents)
				C.stomach_contents -= energyKatana

			if(energyKatana in C.internal_organs)
				C.internal_organs -= energyKatana

		energyKatana.loc = get_turf(energyKatana)

		if(inview) //If we can see the katana, throw it towards ourselves, damaging people as we go.
			energyKatana.spark_system.start()
			playsound(H, "sparks", 50, 1)
			H.visible_message("<span class='danger'>\the [energyKatana] flies towards [H]!</span>","<span class='warning'>You hold out your hand and \the [energyKatana] flies towards you!</span>")
			energyKatana.throw_at(H, distance+1, energyKatana.throw_speed)

		else //Else just TP it to us.
			energyKatana.returnToOwner(H,1)


/*
Teleport:
Allows the ninja to teleport.
*/


//Handles elporting while grabbing someone
/obj/item/clothing/suit/space/space_ninja/proc/handle_teleport_grab(turf/T, mob/living/H)
	if(istype(H.get_active_hand(),/obj/item/weapon/grab))//Handles grabbed persons.
		var/obj/item/weapon/grab/G = H.get_active_hand()
		G.affecting.loc = locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z)//variation of position.
	if(istype(H.get_inactive_hand(),/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = H.get_inactive_hand()
		G.affecting.loc = locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z)//variation of position.
	return


//Jaunt
/obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt()
	set name = "Phase Jaunt (10E)"
	set desc = "Utilizes the internal VOID-shift device to rapidly transit in direction facing."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost(100,N_STEALTH_CANCEL))
		var/mob/living/carbon/human/H = affecting
		var/turf/destination = get_teleport_loc(H.loc,H,9,1,3,1,0,1)
		var/turf/mobloc = get_turf(H.loc)//Safety

		if(destination&&istype(mobloc, /turf))//So we don't teleport out of containers
			spawn(0)
				playsound(H.loc, "sparks", 50, 1)
				anim(mobloc,src,'icons/mob/mob.dmi',,"phaseout",,H.dir)

			handle_teleport_grab(destination, H)
			H.loc = destination

			spawn(0)
				spark_system.start()
				playsound(H.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(H.loc, "sparks", 50, 1)
				anim(H.loc,H,'icons/mob/mob.dmi',,"phasein",,H.dir)

			spawn(0)
				destination.phase_damage_creatures(20,H)//Paralyse and damage mobs and mechas on the turf
			s_coold = 1
		else
			H << "<span class='danger'>The VOID-shift device is malfunctioning, <B>teleportation failed</B>.</span>"
	return


//Right-Click teleport: It's basically admin "jump to turf"
/obj/item/clothing/suit/space/space_ninja/proc/ninjashift(turf/T in oview())
	set name = "Phase Shift (20E)"
	set desc = "Utilizes the internal VOID-shift device to rapidly transit to a destination in view."
	set category = null//So it does not show up on the panel but can still be right-clicked.
	set src = usr.contents//Fixes verbs not attaching properly for objects. Praise the DM reference guide!

	if(!ninjacost(200,N_STEALTH_CANCEL))
		var/mob/living/carbon/human/H = affecting
		var/turf/mobloc = get_turf(H.loc)//To make sure that certain things work properly below.
		if((!T.density)&&istype(mobloc, /turf))
			spawn(0)
				playsound(H.loc, 'sound/effects/sparks4.ogg', 50, 1)
				anim(mobloc,src,'icons/mob/mob.dmi',,"phaseout",,H.dir)

			handle_teleport_grab(T, H)
			H.loc = T

			spawn(0)
				spark_system.start()
				playsound(H.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(H.loc, 'sound/effects/sparks2.ogg', 50, 1)
				anim(H.loc,H,'icons/mob/mob.dmi',,"phasein",,H.dir)

			spawn(0)//Any living mobs in teleport area are gibbed.
				T.phase_damage_creatures(20,H)//Paralyse and damage mobs and mechas on the turf
			s_coold = 1
		else
			H << "<span class='danger'>You cannot teleport into solid walls or from solid matter</span>"
	return



//This section handles how much the above abilities cost.
/obj/item/clothing/suit/space/space_ninja/proc/ninjacost(cost = 0, specificCheck = 0)
	var/mob/living/carbon/human/H = affecting
	if((H.stat || H.incorporeal_move) && (specificCheck != N_ADRENALINE))//Will not return if user is using an adrenaline booster since you can use them when stat==1.
		H << "<span class='danger'>You must be conscious and solid to do this.</span>"//It's not a problem of stat==2 since the ninja will explode anyway if they die.
		return 1

	var/actualCost = cost*10
	if(cost && cell.charge < actualCost)
		H << "<span class='danger'>Not enough energy.</span>"
		return 1
	else
		//This shit used to be handled individually on every proc.. why even bother with a universal check proc then?
		cell.charge-=(actualCost)

	switch(specificCheck)
		if(N_STEALTH_CANCEL)
			cancel_stealth()//Get rid of it.
		if(N_SMOKE_BOMB)
			if(!s_bombs)
				H << "<span class='danger'>There are no more smoke bombs remaining.</span>"
				return 1
		if(N_ADRENALINE)
			if(!a_boost)
				H << "<span class='danger'>You do not have any more adrenaline boosters.</span>"
				return 1
	return (s_coold)//Returns the value of the variable which counts down to zero.

