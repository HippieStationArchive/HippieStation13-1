#define EGG_INCUBATION_TIME 120 //in seconds

/mob/living/simple_animal/hostile/headcrab
	name = "headslug"
	desc = "Absolutely not de-beaked or harmless. Keep away from corpses."
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
	health = 50
	maxHealth = 50
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = list("creature")
	robust_searching = 1
	stat_attack = 2
	environment_smash = 0
	speak_emote = list("squeaks")
	ventcrawler = 2
	var/datum/mind/origin
	var/egg_lain = 0
	speed = 0 //So you can actually fucking outrun the massive lynchsquad going after you
	gold_core_spawnable = 0
	ventcrawl_speed = 5 //It's a tiny lil' piece of shit, he should be able to crawl into vents quick.

/mob/living/simple_animal/hostile/headcrab/proc/Infect(mob/living/carbon/victim)
	var/obj/item/organ/internal/body_egg/changeling_egg/egg = new(victim)
	egg.Insert(victim)
	egg.burst_time = world.time + EGG_INCUBATION_TIME*10
	if(origin)
		egg.origin = origin
	else if(mind) // Let's make this a feature
		egg.origin = mind
	for(var/obj/item/organ/internal/I in src)
		I.loc = egg
	visible_message("<span class='warning'>[src] plants something in [victim]'s flesh!</span>", \
					"<span class='danger'>We inject our egg into [victim]'s body!</span>")
	egg_lain = 1

/mob/living/simple_animal/hostile/headcrab/AttackingTarget()
	if(egg_lain)
		target.attack_animal(src)
		return
	if(iscarbon(target) && !ismonkey(target))
		// Changeling egg can survive in aliens!
		var/mob/living/carbon/C = target
		if(C.stat == DEAD)
			if(getorgan(/obj/item/organ/internal/body_egg/alien_embryo))
				src << "<span class='userdanger'>A foreign presence repels us from this body. Perhaps we should try to infest another?</span>"
				return
			if(getorgan(/obj/item/organ/internal/body_egg/changeling_egg))
				src << "<span class='userdanger'>One of us has already planted thier seed in this body! Perhaps we should try to infest another?</span>"
				return
			Infect(target)
			src << "<span class='userdanger'>With our egg laid, our death approaches rapidly...</span>"
			spawn(100)
				death()
			return
	target.attack_animal(src)

/obj/item/organ/internal/body_egg/changeling_egg
	name = "changeling egg"
	desc = "Twitching and disgusting."
	origin_tech = "biotech=7" // You need to be really lucky to obtain it.
	var/datum/mind/origin
	var/burst_time = 0

/obj/item/organ/internal/body_egg/changeling_egg/egg_process()
	// Changeling eggs grow in dead people
	if(world.time < burst_time)
		return

	Pop()
	Remove(owner)
	qdel(src)

/obj/item/organ/internal/body_egg/changeling_egg/proc/Pop()
	var/mob/living/carbon/monkey/M = new(owner)

	owner.stomach_contents += M

	for(var/obj/item/organ/internal/I in src)
		I.Insert(M, 1)

	if(!origin && owner.mind)
		origin = owner.mind

	if(origin)
		origin.transfer_to(M)
		if(!origin.changeling)
			M.make_changeling()
		if(origin.changeling.can_absorb_dna(M, owner))
			origin.changeling.add_profile(owner, M)

		origin.changeling.purchasedpowers += new /obj/effect/proc_holder/changeling/humanform(null)
		M.key = origin.key

		var/datum/mind/M2 = M.mind

		if(M2)
			M2.ghost = FALSE

	owner.gib()

#undef EGG_INCUBATION_TIME
