/obj/item/weapon/gun/magic/staff
	slot_flags = SLOT_BACK

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

/obj/item/weapon/gun/magic/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_animation.ogg"
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "staffofanimation"
	item_state = "staffofanimation"

/obj/item/weapon/gun/magic/staff/healing
	name = "staff of healing"
	desc = "An artefact that spits bolts of restoring magic which can remove ailments of all kinds and even raise the dead. Can be used as a crutch."
	fire_sound = "sound/magic/Staff_Healing.ogg"
	ammo_type = /obj/item/ammo_casing/magic/heal
	icon_state = "staffofhealing"
	item_state = "staffofhealing"

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


// Lord Staves

/obj/item/weapon/gun/magic/staff/staffofrevenant
	name = "staff of revenant"
	desc = "A cursed artifact that starts off weak, but you can drain the souls of dead bodies in order to make it more powerful! Activate the staff in hand to see how many souls you have and, if you have enough, make your staff stronger."
	fire_sound = "sound/magic/WandODeath.ogg"
	ammo_type = /obj/item/ammo_casing/magic/staffofrevenant
	icon_state = "staffofrevenant"
	item_state = "staffofrevenant"
	w_class = 4
	max_charges = 1
	recharge_rate = 10
	no_den_usage = 1
	var/revenant_level = 0
	var/revenant_damage = 20 // doesn't actually change the damage, only used for the inhand activation
	var/revenant_souls = 0
	var/list/drained_mobs = list() //Cannot harvest the same mob twice

/obj/item/weapon/gun/magic/staff/staffofrevenant/attack(mob/living/carbon/human/target, mob/living/user)
	if(target.stat & DEAD)
		if(istype(target, /mob/living/carbon/human))
			if(!(target in drained_mobs))
				playsound(src,'sound/magic/Staff_Chaos.ogg',40,1)
				user.visible_message("<font color=purple>[user] drains [target] their soul with [src]!</font>", "<span class='notice'>You use [src] to drain [target]'s soul, empowering your weapon!</span>")
				revenant_souls++
				drained_mobs.Add(target)
			else
				user << "<span class='warning'>[target]'s soul is dead and empty.</span>"
				return
		else
			user << "<span class='warning'>[target] isn't human!</span>"
			return
	..()

obj/item/weapon/gun/magic/staff/staffofrevenant/attack_self(mob/living/user)
	if(revenant_level == 0)
		if(revenant_souls >= 5)
			user << "<font color=purple>As you focus on the staff, you witness the crystal emanating a bright shine, before receeding again. The staff hums at an eerie tone, and has managed to become much stronger...</font>"
			max_charges = 2
			charges = 2
			recharge_rate = 9
			chambered = new /obj/item/ammo_casing/magic/staffofrevenant/level1(src)
			revenant_level = 1
			revenant_damage = 25
	else if(revenant_level == 1)
		if(revenant_souls >= 10)
			user << "<font color=purple>Once again, you glance at the staff, sparks now emanating from it as it begins to grow in power. You hear silent wailing around you, as you begin your descent into madness...</font>"
			max_charges = 3
			charges = 3
			recharge_rate = 8
			chambered = new /obj/item/ammo_casing/magic/staffofrevenant/level2(src)
			revenant_level = 2
			revenant_damage = 30
			user << 'sound/spookoween/ghost_whisper.ogg'
	else if(revenant_level == 2)
		if(revenant_souls >= 15)
			user << "<font color=purple>You only give a quick glimpse at the staff, as you hear the screams of the fallen emanating from the staff's crystal. Your powers grow even stronger...</font>"
			max_charges = 4
			charges = 4
			recharge_rate = 7
			chambered = new /obj/item/ammo_casing/magic/staffofrevenant/level3(src)
			revenant_level = 3
			revenant_damage = 35
			user << 'sound/hallucinations/veryfar_noise.ogg'
	else if(revenant_level == 3)
		if(revenant_souls >= 20)
			user << "<font color=purple>You only give a quick glimpse at the staff, as you hear the screams of the fallen emanating from the crystal mounted ontop of the staff, echoing throughout the station. Your powers grow even stronger...</font>"
			max_charges = 5
			charges = 5
			recharge_rate = 6
			chambered = new /obj/item/ammo_casing/magic/staffofrevenant/level4(src)
			revenant_level = 4
			revenant_damage = 40
			world << 'sound/hallucinations/i_see_you1.ogg'
			world << "<font color=purple><b>\"Your end draws near...\"</b></font>"
	else if(revenant_level == 4)
		if(revenant_souls >= 25) // if you reach this point, you pretty much won already
			user << "<font color=purple>Just merely thinking of the power you have acquired is enough to trigger the staff's final evolution... It's destructive powers lets out an even louder wailing than last time, so loud that it echoes throughout the entire station, alerting those still standing that its futile to resist now...</font>"
			max_charges = 6
			charges = 6
			recharge_rate = 5
			chambered = new /obj/item/ammo_casing/magic/staffofrevenant/level5(src)
			revenant_level = 5
			revenant_damage = 60
			world << "<font size=5 color=purple><b>\"UNLIMITED... POWER!\"</b></font>"
			world << 'sound/hallucinations/wail.ogg'
	else if(revenant_level == 5)
		if(revenant_souls >= 50) // if you reaaally go the extra mile to cement your victory
			user << "<font color=purple>The Staff... Somehow, you managed to do what no necrolord had ever managed, to awaken the staff further than this... It does not even seem to react, but you can feel it! The staff, it has become so much more potent! None can stand in your way!</font>"
			chambered = new /obj/item/ammo_casing/magic/staffofrevenant/level666(src)
			max_charges = 15
			charges = 15
			recharge_rate = 1
			revenant_level = 666
			revenant_damage = 200
			world << "<font size=5 color=purple><b>COWER BEFORE ME MORTALS!</b></font>"
			world << 'sound/hallucinations/wail.ogg'

	if(revenant_level <= 4)
		user << "<font color=purple><b>Your [name] has [revenant_souls] souls contained within. Your power will grow every fifth soul...</b></font>"
		user << "<font color=purple>It has a maximum charge of [max_charges], with a recharge rate of [recharge_rate]. Each projectile deals [revenant_damage] damage.</font>"
	else if(revenant_level == 5)
		user << "<font color=purple><b>Your [name] has [revenant_souls] souls contained within. Your power can only grow if you absorb a total of 50 souls...</b></font>"
		user << "<font color=purple>It has a maximum charge of [max_charges], with a recharge rate of [recharge_rate]. Each projectile deals [revenant_damage] damage.</font>"
	else if(revenant_level == 666)
		user << "<font color=purple><b>Your [name] has [revenant_souls] souls contained within. Your power can not possibly grow any further...</b></font>"
		user << "<font color=purple>It has a maximum charge of [max_charges], with a recharge rate of [recharge_rate]. Each projectile instantly gibs a target.</font>"

/obj/item/weapon/gun/magic/staff/staffofrevenant/admin
	fire_sound = "sound/magic/WandODeath.ogg"
	ammo_type = /obj/item/ammo_casing/magic/staffofrevenant/level666
	max_charges = 15
	recharge_rate = 1
	revenant_level = 666
	revenant_damage = 200
	revenant_souls = 1337
