/obj/item/weapon/gun/magic/staff/
	slot_flags = SLOT_BACK

/obj/item/weapon/gun/magic/staff/change
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	fire_sound = "sound/magic/Staff_Change.ogg"
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "staffofchange"
	item_state = "staffofchange"

/obj/item/weapon/gun/magic/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	fire_sound = "sound/magic/Staff_animation.ogg"
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "staffofanimation"
	item_state = "staffofanimation"

/obj/item/weapon/gun/magic/staff/moonlight_greatsword
	name = "moonlight greatsword"
	desc = "A sword that shines like the brilliant rays of the moon, unleashing its energy causes the blade to extend in a very wide slash. Acts as a magic catalyst. Must be charged through the life essence of a relatively healthy, advanced organism."
	fire_sound = "sound/magic/magic_laser.ogg"
	ammo_type = /obj/item/ammo_casing/magic/pellet
	icon_state = "moon_sword"
	item_state = "moon_sword"
	force = 20
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_charge = 0
	charges = 5
	max_charges = 5
	sharpness = IS_SHARP_ACCURATE

/obj/item/weapon/gun/magic/staff/moonlight_greatsword/attack(mob/living/target, mob/user)
	if(istype(target, /mob/living/carbon/human/))
		var/mob/living/carbon/human/H = target
		if(H.health >= 0)
			if(charges == 4)
				charges += 1
				user.visible_message("<span class='danger'>[src] is now fully charged!</span>")
				icon_state = "moon_sword_enc"
				update_icon()
			else
				charges += 1
			playsound(H, 'sound/magic/magic_charge.ogg', 80)
		else
			user.visible_message("<span class='notice'>[target] is too weak to charge [src]!</span>")
	else
		if(charges >= 5)
			user.visible_message("<span class='italics'>[src] is already fully charged!</span>")
		else
			user.visible_message("<span class='notice'>[target] is unsuitable for charging [src]!</span>")
	..()

/obj/item/weapon/gun/magic/staff/moonlight_greatsword/process_fire(mob/user)
	if(charges >= 5)
		charges = 0
		icon_state = "moon_sword"
		update_icon()
		..()
	else
		user.visible_message("<span class='danger'>[src] is not fully charged!</span>")
		return



/obj/item/weapon/gun/magic/staff/healing
	name = "staff of healing"
	desc = "An artefact that spits bolts of restoring magic which can remove ailments of all kinds and even raise the dead."
	fire_sound = "sound/magic/Staff_Healing.ogg"
	ammo_type = /obj/item/ammo_casing/magic/heal
	icon_state = "staffofhealing"
	item_state = "staffofhealing"

/obj/item/weapon/gun/magic/staff/chaos
	name = "staff of chaos"
	desc = "An artefact that spits bolts of chaotic magic that can potentially do anything."
	fire_sound = "sound/magic/Staff_Chaos.ogg"
	ammo_type = /obj/item/ammo_casing/magic/chaos
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1

/obj/item/weapon/gun/magic/staff/door
	name = "staff of door creation"
	desc = "An artefact that spits bolts of transformative magic that can create doors in walls."
	fire_sound = "sound/magic/Staff_Door.ogg"
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "staffofdoor"
	item_state = "staffofdoor"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1
