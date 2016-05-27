//The mob turns into another version of the mob when it dies. These mobs are not childs, in order to ensure that there are NO conflicts with previous phases.
//PHASE 1 AKA AoE spam mode
/mob/living/simple_animal/hostile/boss/timelost_spellcaster
	name = "timelost spellcaster"
	desc = "A spellcaster of the Wizard Federation, lost in time itself due to dabbling with magics."
	icon_state = "lost_spellcaster"
	icon_living = "lost_spellcaster" // doesn't die, turns into the second phase mob instead.
	emote_taunt = list("chants")
	speed = 1
	maxHealth = 250 //combined health if you include all phases is actually 1000. Remember, this is a boss mob.
	health = 250
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	move_to_delay = 20 //barely move at all, fitting for a boss
	faction = list("timelost")
	retreat_distance = 3 // casts magic, why should he actively pursue thy enemy
	minimum_distance = 0 //won't hesitate to bash at close range
	melee_damage_lower = 10
	melee_damage_upper = 10

	var/obj/effect/proc_holder/spell/aoe_turf/conjure/lostreflection/lostreflection = null
	var/obj/effect/proc_holder/spell/aoe_turf/repulse/repulse = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/forceofwill/willofforce = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/timebomb/timebomb = null
	var/obj/effect/proc_holder/spell/self/time_shield/timeshield = null

	var/next_cast = 0

/mob/living/simple_animal/hostile/boss/timelost_spellcaster/New()
	..()
	lostreflection = new /obj/effect/proc_holder/spell/aoe_turf/conjure/lostreflection
	lostreflection.clothes_req = 0
	lostreflection.human_req = 0
	lostreflection.player_lock = 0
	AddSpell(lostreflection)

	repulse = new /obj/effect/proc_holder/spell/aoe_turf/repulse
	repulse.clothes_req = 0
	repulse.human_req = 0
	repulse.player_lock = 0
	repulse.charge_max = 200
	AddSpell(repulse)

	willofforce = new /obj/effect/proc_holder/spell/aoe_turf/conjure/forceofwill
	willofforce.clothes_req = 0
	willofforce.human_req = 0
	willofforce.player_lock = 0
	AddSpell(willofforce)

	timeshield = new /obj/effect/proc_holder/spell/self/time_shield
	timeshield.human_req = 0
	timeshield.player_lock = 0
	AddSpell(timeshield)

	timebomb = new /obj/effect/proc_holder/spell/aoe_turf/conjure/timebomb
	timebomb.clothes_req = 0
	timebomb.human_req = 0
	timebomb.player_lock = 0
	AddSpell(timebomb)

/mob/living/simple_animal/hostile/boss/timelost_spellcaster/death(gibbed)
	if(health > 0)
		return
	else
		visible_message("<span class='userdanger'><font color ='green'>The [src] unsheathes his multiverse sword!</span>")
		new /mob/living/simple_animal/hostile/boss/timelost_spellcaster_multiverse_phase(src.loc)
		qdel(src)

/mob/living/simple_animal/hostile/boss/timelost_spellcaster/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time)
		if(lostreflection.cast_check(0,src))
			lostreflection.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(repulse.cast_check(0,src))
			repulse.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(willofforce.cast_check(0,src))
			willofforce.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(timeshield.cast_check(0,src))
			timeshield.choose_targets(src)
			next_cast = world.time + 10 
			return .
		if(timebomb.cast_check(0,src))
			timebomb.choose_targets(src)
			next_cast = world.time + 10 
			return .

/mob/living/simple_animal/hostile/boss/timelost_reflection
	name = "timelost reflection"
	desc = "A reflection of the timelost spellcaster's past. Better reflect upon your own past while you can."
	icon_state = "lost_spellcaster"
	icon_living = "lost_spellcaster" // just dissapear when they die
	emote_taunt = list("chants")
	speed = 1
	maxHealth = 21
	health = 21
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	faction = list("timelost")
	alpha = 125
	melee_damage_lower = 5
	melee_damage_upper = 5

/mob/living/simple_animal/hostile/boss/timelost_reflection/death()
	qdel(src)

/obj/effect/timebomb //doesn't do shit until it's qdel'd.
	anchored = 1
	name = "timebomb"
	desc = "If you don't want to get your face melted, now's the time to stop reading and start running."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "timebomb"
	layer = FLY_LAYER
	unacidable = 1
	mouse_opacity = 1

/obj/effect/timebomb/New()
	playsound(get_turf(src), 'sound/effects/alert.ogg', 100, 1, -1)
	spawn (30)
		explosion(src, 0, 0, 3, 0)
		qdel(src)

//PHASE 2 - AKA KAMIKAZE NINJA WIZARD MULTIVERSE WET DREAM MODE
/mob/living/simple_animal/hostile/boss/timelost_spellcaster_multiverse_phase
	name = "timelost spellcaster"
	desc = "A spellcaster of the Wizard Federation, lost in time itself due to dabbling with magics. Appears to be wielding the famous multiverse sword."
	icon_state = "2lost_spellcaster"
	icon_living = "2lost_spellcaster" // goes into the third and final phase when they die
	emote_taunt = list("chants")
	speed = 1
	maxHealth = 250 //combined health if you include all phases is actually 1000. Remember, this is a boss mob.
	health = 250
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	move_to_delay = 5 //moves significantly faster in this phase, in addition to his movement abilities. Still able to be kited.
	faction = list("timelost")
	melee_damage_lower = 30
	melee_damage_upper = 30

	var/obj/effect/proc_holder/spell/self/bladedash/bladedash = null
	var/obj/effect/proc_holder/spell/self/shadowblend/shadowblend = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/multiversetimelost/multiverse = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/delude/delude = null

	var/next_cast = 0

/mob/living/simple_animal/hostile/boss/timelost_spellcaster_multiverse_phase/New()
	..()
	bladedash = new /obj/effect/proc_holder/spell/self/bladedash
	bladedash.human_req = 0
	bladedash.player_lock = 0
	AddSpell(bladedash)

	multiverse = new /obj/effect/proc_holder/spell/aoe_turf/conjure/multiversetimelost
	multiverse.clothes_req = 0
	multiverse.human_req = 0
	multiverse.player_lock = 0
	AddSpell(multiverse)

	shadowblend = new /obj/effect/proc_holder/spell/self/shadowblend
	shadowblend.human_req = 0
	shadowblend.player_lock = 0
	AddSpell(shadowblend)

	delude = new /obj/effect/proc_holder/spell/aoe_turf/conjure/delude
	delude.human_req = 0
	delude.player_lock = 0
	AddSpell(delude)

/mob/living/simple_animal/hostile/boss/timelost_spellcaster_multiverse_phase/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time)
		if(multiverse.cast_check(0,src))
			multiverse.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(shadowblend.cast_check(0,src))
			shadowblend.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(delude.cast_check(0,src))
			delude.choose_targets(src)
			next_cast = world.time + 10
			return .
		if((get_dir(src,target) in list(SOUTH,EAST,WEST,NORTH)) && bladedash.cast_check(0,src)) //far enough that blade dash gets you closer to them
			src.dir = get_dir(src,target)
			bladedash.choose_targets(src)
			next_cast = world.time + 10 
			return .

/mob/living/simple_animal/hostile/boss/timelost_spellcaster_multiverse_phase/death()
	if(health > 0)
		return
	else
		visible_message("<span class='userdanger'><font color ='green'>The timelost spellcaster starts evaporating into time!</span>")
		new /obj/effect/timelost_transition(src.loc)
		qdel(src)

/obj/effect/timelost_transition
	anchored = 1
	name = "timelost spellcaster"
	desc = "Better evacuate everything within a square mile radius because you are about to transition into the final phase."
	icon = 'icons/mob/animal.dmi'
	icon_state = "3lost_spellcaster_intro"
	layer = FLY_LAYER
	unacidable = 1
	mouse_opacity = 1

/obj/effect/timelost_transition/New()
	spawn(70)
		new /mob/living/simple_animal/hostile/boss/timelost_spellcaster_final_phase(src.loc)
		qdel(src)


/mob/living/simple_animal/hostile/boss/timelost_multiverse //the mook that the second phase boss will use
	name = "multiverse reflection"
	desc = "An earlier incarnation of the timelost spellcaster."
	icon_state = "2lost_spellcaster_summon"
	icon_living = "2lost_spellcaster_summon" // just dissapear when they die
	emote_taunt = list("chants")
	speed = 1
	maxHealth = 100
	health = 100
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	move_to_delay = 5
	faction = list("timelost")
	melee_damage_lower = 15
	melee_damage_upper = 15

	var/obj/effect/proc_holder/spell/self/bladedash/bladedash = null
	var/obj/effect/proc_holder/spell/self/shadowblend/shadowblend

	var/next_cast = 0

/mob/living/simple_animal/hostile/boss/timelost_multiverse/New()
	..()
	bladedash = new /obj/effect/proc_holder/spell/self/bladedash
	bladedash.human_req = 0
	bladedash.player_lock = 0
	AddSpell(bladedash)

	shadowblend = new /obj/effect/proc_holder/spell/self/shadowblend
	shadowblend.human_req = 0
	shadowblend.player_lock = 0
	AddSpell(shadowblend)

/mob/living/simple_animal/hostile/boss/timelost_multiverse/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time)
		if(shadowblend.cast_check(0,src))
			shadowblend.choose_targets(src)
			next_cast = world.time + 10 
			return . 
		if((get_dir(src,target) in list(SOUTH,EAST,WEST,NORTH)) && bladedash.cast_check(0,src)) //far enough that blade dash gets you closer to them
			src.dir = get_dir(src,target)
			bladedash.choose_targets(src)
			next_cast = world.time + 10 
			return .

/mob/living/simple_animal/hostile/boss/timelost_multiverse/death()
	qdel(src)

/mob/living/simple_animal/hostile/boss/timelost_illusion
	name = "timelost spellcaster"
	desc = "Clearly a fake."
	icon_state = "2lost_spellcaster"
	icon_living = "2lost_spellcaster" // just dissapear when they die
	emote_taunt = list("chants")
	speed = 1
	maxHealth = 20
	health = 20
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	faction = list("timelost")
	melee_damage_lower = 1
	melee_damage_upper = 1

	faction = list("timelost")



// PHASE 3 AKA HE'S NOT DEAD YET?!
/mob/living/simple_animal/hostile/boss/timelost_spellcaster_final_phase
	name = "timelost spellcaster"
	desc = "A spellcaster of the Wizard Federation, lost in time itself due to dabbling with magics. Looks incredibly dangerous."
	icon_state = "3lost_spellcaster"
	icon_living = "3lost_spellcaster" // is qdel'd on death so that they can play their fancy schmancy animation
	emote_taunt = list("chants")
	speed = 1
	maxHealth = 500 //combined health if you include all phases is actually 1000. Remember, this is a boss mob.
	health = 500
	ignored_damage_types = list(BRUTE = 0, BURN = 0, TOX = 1, CLONE = 0, STAMINA = 1, OXY = 1) //Set 0 to receive that damage type, 1 to ignore
	vision_range = 7
	aggro_vision_range = 7
	idle_vision_range = 7
	move_to_delay = 5
	faction = list("timelost")
	melee_damage_lower = 30
	melee_damage_upper = 30

	var/obj/effect/proc_holder/spell/aoe_turf/repulse/repulse = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/multiversetimelost/multiverse = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/forceofwill/willofforce = null
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/timebomb/timebomb = null
	var/obj/effect/proc_holder/spell/self/bladedash/bladedash = null
	var/obj/effect/proc_holder/spell/self/shadowblend/shadowblend = null

	var/next_cast = 0

/mob/living/simple_animal/hostile/boss/timelost_spellcaster_final_phase/New()
	..()
	repulse = new /obj/effect/proc_holder/spell/aoe_turf/repulse
	repulse.clothes_req = 0
	repulse.human_req = 0
	repulse.player_lock = 0
	repulse.charge_max = 200
	AddSpell(repulse)

	willofforce = new /obj/effect/proc_holder/spell/aoe_turf/conjure/forceofwill
	willofforce.clothes_req = 0
	willofforce.human_req = 0
	willofforce.player_lock = 0
	AddSpell(willofforce)

	timebomb = new /obj/effect/proc_holder/spell/aoe_turf/conjure/timebomb
	timebomb.clothes_req = 0
	timebomb.human_req = 0
	timebomb.player_lock = 0
	AddSpell(timebomb)

	bladedash = new /obj/effect/proc_holder/spell/self/bladedash
	bladedash.human_req = 0
	bladedash.player_lock = 0
	AddSpell(bladedash)

	multiverse = new /obj/effect/proc_holder/spell/aoe_turf/conjure/multiversetimelost
	multiverse.clothes_req = 0
	multiverse.human_req = 0
	multiverse.player_lock = 0
	AddSpell(multiverse)

	shadowblend = new /obj/effect/proc_holder/spell/self/shadowblend
	shadowblend.human_req = 0
	shadowblend.player_lock = 0
	AddSpell(shadowblend)

/mob/living/simple_animal/hostile/boss/timelost_spellcaster_final_phase/death()
	if(health > 0)
		return
	else
		visible_message("<span class='userdanger'><font color ='red'>[src] is erased from time itself!</span>")
		qdel(src)

/mob/living/simple_animal/hostile/boss/timelost_spellcaster_final_phase/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time)
		if(timebomb.cast_check(0,src))
			timebomb.choose_targets(src)
			next_cast = world.time + 10 //longer cooldown since it is a big spooky ace ability and prevents combo-ing with timeshatter
			return .
		if(multiverse.cast_check(0,src))
			multiverse.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(shadowblend.cast_check(0,src))
			shadowblend.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(repulse.cast_check(0,src))
			repulse.choose_targets(src)
			next_cast = world.time + 10
			return .
		if(willofforce.cast_check(0,src))
			willofforce.choose_targets(src)
			next_cast = world.time + 10
			return .
		if((get_dir(src,target) in list(SOUTH,EAST,WEST,NORTH)) && bladedash.cast_check(0,src)) //far enough that blade dash gets you closer to them
			src.dir = get_dir(src,target)
			bladedash.choose_targets(src)
			next_cast = world.time + 10
			return .
