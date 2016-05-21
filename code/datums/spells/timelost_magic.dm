/obj/effect/proc_holder/spell/aoe_turf/conjure/lostreflection //used only by Timelost spellcasters.
	name = "Timelost Reflection"
	desc = "Summon several reflections of your past to attack your enmies. Will also attack you if you aren't lost in time."
	charge_max = 400
	cast_sound = "sound/magic/CastSummon.ogg"

	summon_type = list(/mob/living/simple_animal/hostile/boss/timelost_reflection)
	summon_amt = 4
	summon_lifespan = 300 //aka you can't have more than 4 at any time without cooldown reductions
	range = 2
	summon_ignore_prev_spawn_points = 1

/obj/effect/proc_holder/spell/aoe_turf/conjure/forceofwill //used only by Timelost spellcasters.
	name = "Force of Will"
	desc = "Summon a total of 25 forcewalls randomly scattered troughout your vision range."
	charge_max = 400
	cast_sound = "sound/magic/CastSummon.ogg"

	summon_type = list(/obj/effect/forcefield)
	summon_amt = 25
	summon_lifespan = 250
	range = 7
	summon_ignore_prev_spawn_points = 1

/obj/effect/proc_holder/spell/aoe_turf/conjure/timebomb //used only by Timelost spellcasters.
	name = "Time Bomb"
	desc = "Summon a time bombs within your vision range that explodes after a short delay, then summons another one at a random location which does the exact same thing! Repeats itself 6 times."
	charge_max = 600
	cast_sound = "sound/magic/WandODeath.ogg"

	summon_type = list(/obj/effect/timebomb)
	summon_amt = 6
	summon_ignore_prev_spawn_points = 1
	range = 7

/obj/effect/proc_holder/spell/self/time_shield
	name = "Time Shield"
	desc = "Shields yourself within time. Prevents you from taking any damage. Doesn't help against stuns or anything else."
	human_req = 1
	clothes_req = 0
	charge_max = 600
	cooldown_min = 50
	invocation = "ONLY I CAN SHAPE TIME!"
	invocation_type = "shouts"
	school = "restoration"
	sound = 'sound/magic/Staff_Healing.ogg'

/obj/effect/proc_holder/spell/self/time_shield/cast(mob/living/carbon/human/user)
	user.visible_message("<span class='warning'>[user] fades into time and becomes immune to all damage!</span>", "<span class='notice'>You shield yourself within time!</span>")
	user.status_flags ^= GODMODE
	user.icon_state = "lost_spellcaster_shielded"
	spawn (100)
		user.icon_state = "lost_spellcaster"
		user.visible_message("<span class='warning'>[user] fades out of time and becomes vulnerable to damage!</span>", "<span class='notice'>Your shield vanishes!</span>")
		user.status_flags ^= GODMODE









//PHASE 2 SHIT
/obj/effect/proc_holder/spell/self/bladedash
	name = "Bladedash"
	desc = "Dashes 3 tiles forward, ignoring any obstructions and dealing 30 damage should your destination have somebody standing on it."
	human_req = 1
	clothes_req = 0
	charge_max = 50
	cooldown_min = 10
	school = "timelost"

/obj/effect/proc_holder/spell/self/bladedash/cast(mob/living/carbon/human/user)
	var/mob/living/carbon/human/H = user
	var/turf/destination = get_teleport_loc(H.loc,H,3,1,0,0,0,0)
	var/turf/mobloc = get_turf(H.loc)//Safety

	if(destination&&istype(mobloc, /turf))//So we don't teleport out of containers
		spawn(0)
			playsound(H.loc, "sparks", 50, 1)
			anim(mobloc,src,'icons/mob/mob.dmi',,"phaseout",,H.dir)

		H.loc = destination

		spawn(0)
			playsound(H.loc, 'sound/effects/phasein.ogg', 25, 1)
			playsound(H.loc, "sparks", 50, 1)
			anim(H.loc,H,'icons/mob/mob.dmi',,"phasein",,H.dir)

		spawn(0)
			destination.phase_damage_creatures(30,H)//Paralyse and damage mobs and mechas on the turf
	else
		H << "<span class='danger'>You cannot teleport out of lockers.</span>"
	return

/obj/effect/proc_holder/spell/aoe_turf/conjure/multiversetimelost
	name = "Timelost Multiverse"
	desc = "Summons a copy of yourself prior to losing yourself to time."
	charge_max = 800
	cast_sound = "sound/magic/CastSummon.ogg"

	summon_type = list(/mob/living/simple_animal/hostile/boss/timelost_multiverse)
	summon_amt = 1
	summon_lifespan = 600
	range = 1

/obj/effect/proc_holder/spell/self/shadowblend
	name = "Shadowblend"
	desc = "Blend with the shadows, making you immune to all attacks as well as causing all projectiles to pass trough you!"
	human_req = 1
	clothes_req = 0
	charge_max = 600
	cooldown_min = 50
	invocation = "ONLY I CAN SHAPE TIME!"
	invocation_type = "shouts"
	school = "timelost"
	sound = 'sound/magic/Staff_Healing.ogg'

/obj/effect/proc_holder/spell/self/shadowblend/cast(mob/living/carbon/human/user)
	user.visible_message("<span class='warning'>[user] blends into the shadows and becomes immune to all damage!</span>", "<span class='notice'>You blend with the shadows!</span>")
	user.status_flags ^= GODMODE
	user.alpha = 125
	user.density = 0
	spawn (100)
		user.visible_message("<span class='warning'>[user] reappears from the shadows and becomes vulnerable to damage!</span>", "<span class='notice'>You blend out of the shadows!</span>")
		user.status_flags ^= GODMODE
		user.alpha = 255
		user.density = 1

/obj/effect/proc_holder/spell/aoe_turf/conjure/delude
	name = "Delude"
	desc = "Summon a fuckton of illusions looking just like you."
	charge_max = 400
	cast_sound = "sound/magic/CastSummon.ogg"

	summon_type = list(/mob/living/simple_animal/hostile/boss/timelost_illusion)
	summon_amt = 8
	summon_lifespan = 200
	summon_ignore_prev_spawn_points = 1
	range = 1
