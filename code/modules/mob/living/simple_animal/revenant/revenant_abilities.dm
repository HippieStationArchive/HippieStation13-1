//Harvest Essence: The bread and butter of the revenant. The basic way of harvesting additional essence. Works on unconscious/dead humans.
/obj/effect/proc_holder/spell/targeted/revenant_drain_lesser
	name = "Lesser Harvest (0E)"
	desc = "Siphons the lingering spectral essence from a human, empowering yourself."
	panel = "Revenant Abilities"
	charge_max = 100 //Short cooldown
	clothes_req = 0
	range = 5
	var/essence_drained = 0
	var/draining
	var/list/drained_mobs = list() //Cannot harvest the same mob twice

/obj/effect/proc_holder/spell/targeted/revenant_drain_lesser/cast(list/targets, var/mob/living/simple_animal/revenant/user = usr)
	for(var/mob/living/carbon/human/target in targets)
		spawn(0)
			if(draining)
				user << "<span class='warning'>You are already siphoning the essence of a soul!</span>"
				return
			if(target in drained_mobs)
				user << "<span class='warning'>[target]'s soul is dead and empty.</span>"
				return
			if(!target.stat)
				user << "<span class='notice'>This being's soul is too strong to harvest.</span>"
				if(prob(10))
					target << "You feel as if you are being watched."
				return
			draining = 1
			essence_drained = 1
			user << "<span class='notice'>You search for the still-living soul of [target].</span>"
			sleep(10)
			if(target.ckey)
				user << "<span class='notice'>Their soul burns with intelligence.</span>"
				essence_drained += 3
			if(target.stat == UNCONSCIOUS)
				user << "<span class='notice'>They still cling to life, but are not powerful enough to resist. A large amount of essence lies unguarded.</span>"
				essence_drained += 5
			else if(target.stat == DEAD)
				user << "<span class='notice'>They have passed on.</span>"
				essence_drained += 1
			sleep(20)
			switch(essence_drained)
				if(1 to 2)
					user << "<span class='info'>[target] will not yield much essence. Still, every bit counts.</span>"
				if(3 to 4)
					user << "<span class='info'>[target] will yield an average amount of essence.</span>"
				if(5 to INFINITY)
					user << "<span class='info'>Such a feast! [target] will yield much essence to you.</span>"
			sleep(30)
			user << "<span class='danger'>You begin siphoning essence from [target]'s soul. You can not move while this is happening.</span>"
			if(target.stat != DEAD)
				target << "<span class='warning'>You feel a horribly unpleasant draining sensation as your grip on life weakens...</span>"
			user.icon_state = "revenant_draining"
			user.notransform = 1
			user.revealed = 1
			user.invisibility = 0
			target.visible_message("<span class='warning'>[target] suddenly rises slightly into the air, their skin turning an ashy gray.</span>")
			target.Beam(user,icon_state="drain_life",icon='icons/effects/effects.dmi',time=50)
			target.death(0)
			target.visible_message("<span class='warning'>[target] gently slumps back onto the ground.</span>")
			user.icon_state = "revenant_idle"
			user.change_essence_amount(essence_drained * 5, 0, 0, target)
			user << "<span class='info'>[target]'s soul has been considerably weakened and will yield no more essence for the time being.</span>"
			user.revealed = 0
			user.notransform = 0
			user.invisibility = INVISIBILITY_OBSERVER
			drained_mobs.Add(target)
			draining = 0


//Greater Harvest; basically just a buffed version of normal harvest, works on living mobs.
/obj/effect/proc_holder/spell/targeted/revenant_drain_greater
	name = "Unlock: Greater Harvest (125E)"
	desc = "Siphons the lingering spectral essence from a human, empowering yourself."
	panel = "Revenant Abilities (Locked)"
	charge_max = 3000 //Loooooong cooldown
	clothes_req = 0
	range = -1
	include_user = 1
	var/essence_drained = 0
	var/draining
	var/list/drained_mobs = list()
	var/locked = 1

/obj/effect/proc_holder/spell/targeted/revenant_drain_greater/cast(list/targets, var/mob/living/simple_animal/revenant/user = usr)
	if(locked && essence_check(125, 1))
		usr << "<span class='info'>You have unlocked Greater Harvest!</span>"
		name = "Greater Harvest (0E)"
		locked = 0
		range = 7
		include_user = 0
		panel = "Revenant Abilities"
		charge_counter = charge_max
		return
	if(locked)
		charge_counter = charge_max
		return
	for(var/mob/living/carbon/human/target in targets)
		spawn(0)
			if(draining)
				user << "<span class='warning'>You are already siphoning the essence of a soul!</span>"
				return
			if(target in drained_mobs)
				user << "<span class='warning'>[target]'s soul is dead and empty.</span>"
				return
			draining = 1
			essence_drained = 2
			user << "<span class='notice'>You paralyze [target] and begin searching through their soul.</span>"
			target << "<span class='danger'><b>Your muscles suddenly tense up. You can't move!</b></span"
			target.notransform = 1
			sleep(10)
			if(target.ckey)
				user << "<span class='notice'>Their soul burns with intelligence.</span>"
				essence_drained += 2
			if(!target.stat)
				user << "<span class='notice'>Lovely prey! Their soul is bright and living. This will be delicious...</span>"
				essence_drained += 6
			else if(target.stat == UNCONSCIOUS)
				user << "<span class='notice'>They still cling to life, but are not powerful enough to resist. A large amount of essence lies unguarded.</span>"
				essence_drained += 4
			else if(target.stat == DEAD)
				user << "<span class='notice'>They have passed on.</span>"
				essence_drained += 2
			sleep(20)
			switch(essence_drained)
				if(5 to 6)
					user << "<span class='info'>[target] will not yield much essence. Still, every bit counts.</span>"
				if(7 to 9)
					user << "<span class='info'>[target] will yield an average amount of essence.</span>"
				if(10 to INFINITY)
					user << "<span class='info'>Such a feast! [target] will yield much essence to you.</span>"
			sleep(30)
			user << "<span class='danger'>You begin siphoning essence from [target]'s soul. You can not move while this is happening.</span>"
			target << "<span class='warning'>You feel a horribly unpleasant draining sensation and begin to fade...</span>"
			user.icon_state = "revenant_draining"
			user.notransform = 1
			user.revealed = 1
			user.invisibility = 0
			target.visible_message("<span class='warning'>[target] suddenly rises slightly into the air, their skin turning an ashy gray.</span>")
			target.Beam(user,icon_state="drain_life",icon='icons/effects/effects.dmi',time=50)
			target.notransform = 0
			target.death(0)
			target.visible_message("<span class='warning'>[target] gently slumps back onto the ground.</span>")
			user.change_essence_amount(essence_drained * 5, 0, 0, target)
			user.icon_state = "revenant_idle"
			user << "<span class='info'>[target]'s soul has been all but destroyed. It will take some time for it to recuperate.</span>"
			user.revealed = 0
			user.notransform = 0
			user.invisibility = INVISIBILITY_OBSERVER
			drained_mobs.Add(target)
			draining = 0


//Transmit: the revemant's only direct way to communicate. Sends a single message silently to a single mob for 5E.
/obj/effect/proc_holder/spell/targeted/revenant_transmit
	name = "Unlock: Transmit (5E)"
	desc = "Telepathically transmits a message to the target."
	panel = "Revenant Abilities (Locked)"
	charge_max = 50
	clothes_req = 0
	range = -1
	include_user = 1
	var/locked = 1

/obj/effect/proc_holder/spell/targeted/revenant_transmit/cast(list/targets)
	if(locked && essence_check(5, 1))
		usr << "<span class='info'>You have unlocked Transmit!</span>"
		name = "Transmit (5E)"
		locked = 0
		charge_counter = charge_max
		panel = "Revenant Abilities"
		range = 7
		include_user = 0
		return
	if(locked)
		charge_counter = charge_max
		return
	if(!essence_check(5))
		charge_counter = charge_max
		return
	for(var/mob/living/M in targets)
		spawn(0)
			var/msg = stripped_input(usr, "What do you wish to tell \the [M.name]?.", null, "")
			usr << "<span class='info'><b>You transmit to [M.name]:</b> [msg]</span>"
			M << "<span class='deadsay'><b>Suddenly a strange voice resonates in your head...</b></span><i> [msg]</I>"


//Overload Light: Breaks a light that's online and sends out lightning bolts to all nearby people.
/obj/effect/proc_holder/spell/aoe_turf/revenant_light
	name = "Unlock: Overload Light (25E)"
	desc = "Directs a large amount of essence into an electrical light, causing an impressive light show."
	panel = "Revenant Abilities (Locked)"
	charge_max = 300
	clothes_req = 0
	range = 5
	var/locked = 1

/obj/effect/proc_holder/spell/aoe_turf/revenant_light/cast(list/targets, var/mob/living/simple_animal/revenant/user = usr)
	if(locked && essence_check(25, 1))
		user << "<span class='info'>You have unlocked Overload Light!</span>"
		name = "Overload Light (25E)"
		panel = "Revenant Abilities"
		locked = 0
		charge_counter = charge_max
		return
	if(locked)
		charge_counter = charge_max
		return
	if(!essence_check(25))
		charge_counter = charge_max
		return
	for(var/turf/T in targets)
		spawn(0)
			for(var/obj/machinery/light/L in T.contents)
				spawn(0)
					if(!L.on)
						return
					L.visible_message("<span class='warning'><b>\The [L] suddenly flares brightly and begins to spark!</span>")
					sleep(20)
					for(var/mob/living/M in orange(4, L))
						if(M == user)
							return
						M.Beam(L,icon_state="lightning",icon='icons/effects/effects.dmi',time=5)
						M.electrocute_act(25, "[L.name]")
						playsound(M, 'sound/machines/defib_zap.ogg', 50, 1, -1)


//Strangulate: Does a lethal amount of oxygen damage to a single target. Costs a decent amount of essence.
/obj/effect/proc_holder/spell/targeted/revenant_strangulate
	name = "Unlock: Strangulate (30E)"
	desc = "Cuts off oxygen to the target, knocking them into critical condition."
	panel = "Revenant Abilities (Locked)"
	charge_max = 600
	clothes_req = 0
	range = -1
	include_user = 1
	var/locked = 1

/obj/effect/proc_holder/spell/targeted/revenant_strangulate/cast(list/targets, var/mob/living/simple_animal/revenant/user = usr)
	if(locked && essence_check(30, 1))
		user << "<span class='info'>You have unlocked Strangulate!</span>"
		name = "Strangulate (30E)"
		panel = "Revenant Abilities"
		locked = 0
		range = 3
		charge_counter = charge_max
		return
	if(locked)
		charge_counter = charge_max
		return
	if(!essence_check(30))
		charge_counter = charge_max
		return
	for(var/mob/living/carbon/human/target in targets)
		spawn(0)
			if(!ishuman(target))
				user << "<span class='warning'>You can only asphyxiate a human.</span>"
				user.change_essence_amount(30, 0, 1, null)
				charge_counter = charge_max
				return
			target.visible_message("<span class='warning'>[target] lets out a choked gasp and clutches at their neck!</span>", \
							  	   "<span class='warning'><b>You feel a titanic pressure around your neck, cutting off your breath!</b></span>")
			target.Stun(3)
			for(var/i = 0, i < 10, i++)
				target.adjustOxyLoss(12)
				sleep(10)


//Life Tap: Drains one 'strike' to gain 50E
/obj/effect/proc_holder/spell/targeted/revenant_life_tap
	name = "Unlock: Life Tap (25E)"
	desc = "Draws from your own life tool to gain more essence. Can only be cast three times."
	panel = "Revenant Abilities (Locked)"
	charge_max = 600
	clothes_req = 0
	range = -1
	include_user = 1
	var/locked = 1

/obj/effect/proc_holder/spell/targeted/revenant_life_tap/cast(list/targets, var/mob/living/simple_animal/revenant/user = usr)
	if(locked && essence_check(25, 1))
		user << "<span class='info'>You have unlocked Life Tap!</span>"
		name = "Life Tap (0E)"
		panel = "Revenant Abilities"
		locked = 0
		charge_counter = charge_max
		return
	if(locked)
		charge_counter = charge_max
		return
	for(var/mob/living/simple_animal/revenant/target in targets)
		if(!target.strikes)
			target << "<span class='warning'>You cannot do this again - you would only die.</span>"
		target.strikes--
		target << "<span class='info'>You convert your own life into energy.[target.strikes ? "" : " This is the last time you can do this."]</span>"
		target.change_essence_amount(50, 0, 0, "your life pool")