/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 20
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/effects/wep_misc/searwall.ogg'
	flag = "laser"
	eyeblur = 2

/obj/item/projectile/beam/practice
	name = "practice laser"
	damage = 0
	hitsound = null
	nodamage = 1

/obj/item/projectile/beam/scatter
	name = "laser pellet"
	icon_state = "scatterlaser"
	damage = 5

/obj/item/projectile/beam/focusedlaser
	name = "focused laser"
	icon_state = "focused"
	damage = 30

/obj/item/projectile/beam/laser/accelerator
	name = "accelerator laser"
	icon_state = "hyperlaser"
	range = 255
	damage = 15

/obj/item/projectile/beam/lowlaser
	name = "low laser"
	icon_state = "laser"
	damage = 15

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 40

/obj/item/projectile/beam/hyperlaser
	name = "hyper laser"
	icon_state = "hyperlaser"
	damage = 100

/obj/item/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	damage = 15
	irradiate = 30
	range = 15
	forcedodge = 1

/obj/item/projectile/beam/disabler
	name = "disabler beam"
	icon_state = "omnilaser"
	damage = 36
	damage_type = STAMINA
	flag = "energy"
	hitsound = 'sound/weapons/tap.ogg'
	eyeblur = 0

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage = 50

/obj/item/projectile/beam/pulse/on_hit(atom/target, blocked = 0)
	. = ..()
	if(istype(target,/turf/)||istype(target,/obj/structure/))
		target.ex_act(2)

/obj/item/projectile/beam/pulse/shot
	damage = 40

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage = 30

/obj/item/projectile/beam/emitter/singularity_pull()
	return //don't want the emitters to miss

/obj/item/projectile/beam/emitter/Destroy()
	return QDEL_HINT_PUTINPOOL

/obj/item/projectile/lasertag
	name = "laser tag beam"
	icon_state = "omnilaser"
	hitsound = null
	damage = 0
	damage_type = STAMINA
	flag = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	var/suit_types = list(/obj/item/clothing/suit/redtag, /obj/item/clothing/suit/bluetag)

/obj/item/projectile/lasertag/on_hit(atom/target, blocked = 0)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit))
			if(M.wear_suit.type in suit_types)
				M.adjustStaminaLoss(34)


/obj/item/projectile/lasertag/redtag
	icon_state = "laser"
	suit_types = list(/obj/item/clothing/suit/bluetag)

/obj/item/projectile/lasertag/bluetag
	icon_state = "bluelaser"
	suit_types = list(/obj/item/clothing/suit/redtag)

/obj/item/projectile/beam/gauss_low
	name = "gauss bolt"
	icon_state = "gauss_silenced"
	damage = 20
	damage_type = BRUTE
	hitsound = 'sound/weapons/pierce.ogg'

/obj/item/projectile/gauss_normal
	name = "gauss bolt"
	icon_state = "gauss"
	damage = 30
	damage_type = BRUTE
	hitsound = 'sound/weapons/pierce.ogg'

/obj/item/projectile/gauss_normal/on_hit(atom/target, blocked = 0, hit_zone)
	if(ismob(target))
		playsound(target, 'sound/weapons/rodgun_pierce.ogg', 50, 1)
		var/ichance = rand(1,5)
		if(ichance == 3)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/obj/item/organ/limb/O = H.get_organ(hit_zone)
				var/obj/item/stack/rods/R = new(H.loc)
				if(istype(O))
					R.add_blood(H)
					R.loc = H
					O.embedded_objects += R //Lodge the object into the limb
					H.update_damage_overlays() //Update the fancy embeds
					visible_message("<span class='warning'>The [R] has embedded into [H]'s [O]!</span>",
									"<span class='userdanger'>You feel [R] lodge into your [O]!</span>")
					playsound(H, 'sound/weapons/rodgun_pierce.ogg', 50, 1) //For super audible murder
					H.emote("scream")
			else
				playsound(target, 'sound/weapons/pierce.ogg', 50, 1)

/obj/item/projectile/gauss_overdrive
	name = "overdrive gauss bolt"
	icon_state = "gauss_overdrive"
	damage = 40
	damage_type = BRUTE
	hitsound = 'sound/weapons/pierce.ogg'

/obj/item/projectile/gauss_overdrive/on_hit(atom/target, blocked = 0, hit_zone)
	if(ishuman(target))
		var/dchance = rand(1, 5)
		if(dchance == 2)
			var/mob/living/carbon/human/H = target
			var/obj/item/organ/limb/O = H.get_organ(hit_zone)
			if(hit_zone != "chest" && hit_zone != "head")
				O.dismember()
				playsound(H.loc, 'sound/misc/crunch.ogg', 60, 1)
				playsound(H.loc, 'sound/misc/splat.ogg', 60, 1)
				var/obj/effect/decal/cleanable/blood/T = new/obj/effect/decal/cleanable/blood
				T.loc = H.loc