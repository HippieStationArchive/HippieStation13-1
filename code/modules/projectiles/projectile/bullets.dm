/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"
	var/mob_stuck_chance = 40 //For lodging bullets into limbs for extraction.

/obj/item/projectile/bullet/l85l//lethal l85
	damage = 15
	mob_stuck_chance = 10//much lower embed chance

/obj/item/projectile/bullet/l85s
	damage = 3
	nodamage = 0
	mob_stuck_chance = 0

/obj/item/projectile/bullet/l85s/on_hit(var/atom/target, var/blocked = 0)
	..()
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/M = target
		M.adjustStaminaLoss(rand(5,20))

/obj/item/projectile/bullet/weakbullet
	damage = 5
	stun = 5
	weaken = 5
	mob_stuck_chance = 0


/obj/item/projectile/bullet/weakbullet2
	damage = 15
	stun = 7
	weaken = 7
	mob_stuck_chance = 0

/obj/item/projectile/bullet/weakbullet3
	damage = 20
	//Syndicate pistol uses this, hence why there's no mob_stuck_chance

/obj/item/projectile/bullet/pellet
	name = "pellet"
	damage = 9 //15 //Nerfed because 5 pellets * 15 means a whopping 75 damage point-blank. Double-barreled shotgun has 2 rounds, so... yeah.
	mob_stuck_chance = 0 //Pellets don't get stuck in your limbs for balancing reasons

/obj/item/projectile/bullet/pellet/weak
	damage = 3
	stun = 5
	weaken = 5

/obj/item/projectile/bullet/midbullet
	damage = 20
	stun = 5
	weaken = 5

/obj/item/projectile/bullet/midbullet2
	damage = 25

/obj/item/projectile/bullet/midbullet3
	damage = 30

/obj/item/projectile/bullet/heavybullet
	damage = 35


/obj/item/projectile/bullet/stunshot
	name = "stunshot"
	damage = 5
	stun = 5
	weaken = 5
	mob_stuck_chance = 0

/obj/item/projectile/bullet/incendiary/on_hit(var/atom/target, var/blocked = 0)
	..()
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(1)
		M.IgniteMob()


/obj/item/projectile/bullet/incendiary/shell
	name = "incendiary slug"
	damage = 20

/obj/item/projectile/bullet/incendiary/shell/Move()
	..()
	var/turf/location = get_turf(src)
	if(istype(location))
		new/obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)

/obj/item/projectile/bullet/incendiary/shell/dragonsbreath
	name = "dragonsbreath round"
	damage = 5


/obj/item/projectile/bullet/meteorshot
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "dust"
	damage = 30
	weaken = 8
	stun = 8
	hitsound = 'sound/effects/meteorimpact.ogg'
	mob_stuck_chance = 0

/obj/item/projectile/bullet/meteorshot/on_hit(var/atom/target, var/blocked = 0)
	..()
	if(istype(target, /atom/movable))
		var/atom/movable/M = target
		var/atom/throw_target = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
		M.throw_at(throw_target, 3, 2)

/obj/item/projectile/bullet/meteorshot/New()
	..()
	SpinAnimation()


/obj/item/projectile/bullet/mime
	damage = 20

/obj/item/projectile/bullet/mime/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/M = target
		M.silent = max(M.silent, 10)


/obj/item/projectile/bullet/dart
	name = "dart"
	icon_state = "cbbolt"
	damage = 6
	mob_stuck_chance = 0

	New()
		..()
		flags |= NOREACT
		create_reagents(50)

	on_hit(var/atom/target, var/blocked = 0, var/hit_zone)
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/M = target
			if(M.can_inject(null,0,hit_zone)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				reagents.trans_to(M, reagents.total_volume)
				return 1
			else
				target.visible_message("<span class='danger'>The [name] was deflected!</span>", \
									   "<span class='userdanger'>You were protected against the [name]!</span>")
		flags &= ~NOREACT
		reagents.handle_reactions()
		return 1

/obj/item/projectile/bullet/dart/metalfoam
	New()
		..()
		reagents.add_reagent("aluminium", 15)
		reagents.add_reagent("foaming_agent", 5)
		reagents.add_reagent("pacid", 5)

//This one is for future syringe guns update
/obj/item/projectile/bullet/dart/syringe
	name = "syringe"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "syringeproj"

/obj/item/projectile/bullet/neurotoxin
	name = "neurotoxin spit"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 5
	mob_stuck_chance = 0

/obj/item/projectile/bullet/neurotoxin/on_hit(var/atom/target, var/blocked = 0)
	if(isalien(target))
		return 0
	..() // Execute the rest of the code.
