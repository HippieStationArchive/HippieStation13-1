/obj/item/weapon/gun/magic/staff
	slot_flags = SLOT_BACK
	
/obj/item/weapon/gun/magic/staff/attack(atom/target, mob/living/user)
	if(target == user)
		return
	..()

/obj/item/weapon/gun/magic/staff/afterattack(atom/target, mob/living/user)
	if(!charges)
		shoot_with_empty_chamber(user)
		return
	if(target == user)
		if(no_den_usage)
			var/area/A = get_area(user)
			if(istype(A, /area/wizard_station))
				user << "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].<span>"
				return
			else
				no_den_usage = 0
		zap_self(user)
	else
		..()
	update_icon()
	
/obj/item/weapon/gun/magic/staff/proc/zap_self(mob/living/user)
	user.visible_message("<span class='danger'>[user] zaps \himself with [src].</span>")
	playsound(user, fire_sound, 50, 1)
	user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> zapped \himself with a <b>[src]</b>"

/obj/item/weapon/gun/magic/staff/update_slowdown(mob/user)
	var/mob/living/carbon/human/H = user
	var/slow = 0
	if(istype(H))
		slow = (H.get_num_legs(1) < 2) ? -2 : 0 //Negates slowdown caused by lack of a leg
	return slow


/obj/item/weapon/gun/magic/staff/change
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_Change.ogg"
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "staffofchange"
	item_state = "staffofchange"
	
/obj/item/weapon/gun/magic/staff/change/zap_self(mob/living/user)
	..()
	wabbajack(user)
	charges--

/obj/item/weapon/gun/magic/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_animation.ogg"
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "staffofanimation"
	item_state = "staffofanimation"
	
/obj/item/weapon/gun/magic/staff/animate/zap_self()
	return

/obj/item/weapon/gun/magic/staff/healing
	name = "staff of healing"
	desc = "An artefact that spits bolts of restoring magic which can remove ailments of all kinds and even raise the dead. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_Healing.ogg"
	ammo_type = /obj/item/ammo_casing/magic/heal
	icon_state = "staffofhealing"
	item_state = "staffofhealing"
	
/obj/item/weapon/gun/magic/staff/healing/zap_self(mob/living/user)
	user.revive()
	user << "<span class='notice'>You feel great!</span>"
	charges--
	..()

/obj/item/weapon/gun/magic/staff/chaos
	name = "staff of chaos"
	desc = "An artefact that spits bolts of chaotic magic that can potentially do anything. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_Chaos.ogg"
	ammo_type = /obj/item/ammo_casing/magic/chaos
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1

/obj/item/weapon/gun/magic/staff/chaos/zap_self(mob/living/user)
	var/randomize = pick("poly","door","heal","animate","teleport","fireball","death","nothing")
	switch(randomize)
		if("poly")
			..()
			wabbajack(user)
			charges--
		if("door")
			charges--
			..()
		if("heal")
			user.revive()
			user << "<span class='notice'>You feel great!</span>"
			charges--
			..()
		if("animate")
			charges--
			..()
		if("teleport")
			do_teleport(user, user, 10)
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(3, user.loc)
			smoke.start()
			charges--
			..()
		if("fireball")
			explosion(user.loc, -1, 0, 2, 3, 0, flame_range = 2)
			charges--
			..()
		if("death")
			var/message ="<span class='warning'>You irradiate yourself with pure energy! "
			message += pick("Do not pass go. Do not collect 200 zorkmids.</span>","You feel more confident in your spell casting skills.</span>","You Die...</span>","Do you want your possessions identified?</span>")
			user << message
			user.adjustOxyLoss(500)
			charges--
			..()
		if("nothing")
			charges--
			..()
		else
			return

/obj/item/weapon/gun/magic/staff/door
	name = "staff of door creation"
	desc = "An artefact that spits bolts of transformative magic that can create doors in walls. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_Door.ogg"
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "staffofdoor"
	item_state = "staffofdoor"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1
	
/obj/item/weapon/gun/magic/staff/door/zap_self()
	return
