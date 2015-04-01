/mob
	var/turf/pinned_to = null

/obj
	var/pinned = null //Used for unpinning a person when he's trying to take the embedded rod out

//This is so hacky, jeez
/turf
	var/pinned = null //Used to track the turf's destruction so as to release the poor pinned dude

/turf/Del()
	if(src.pinned)
		var/mob/living/carbon/human/H = src.pinned
		H.anchored = 0
		H.pinned_to = null
		H.do_pindown(src, 0)
		H.update_canmove()
	..()

/turf/ChangeTurf(var/path)
	if(src.pinned)
		var/mob/living/carbon/human/H = src.pinned
		H.anchored = 0
		H.pinned_to = null
		H.do_pindown(src, 0)
		H.update_canmove()
	..()

//Rod stuff
/obj/item/projectile/rod
	name = "metal rod"
	icon_state = "rod"
	damage = 10 //+ rod embeds itself in you. + you bleed.
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"

/obj/item/ammo_casing/rod
	name = "rod casing"
	desc = "You shouldn't be able to see this."
	projectile_type = /obj/item/projectile/rod

/obj/item/projectile/rod/on_hit(atom/target, blocked = 0, hit_zone)
	if(ismob(target))
		playsound(target, 'sound/weapons/rodgun_pierce.ogg', 50, 1)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/obj/item/organ/limb/O = H.get_organ(hit_zone)
			var/obj/item/stack/rods/R = new(H.loc)
			if(istype(O))
				R.add_blood(H)
				R.loc = H
				O.embedded += R //Lodge the object into the limb
				H.update_damage_overlays() //Update the fancy embeds
				visible_message("<span class='warning'>The [R] has embedded into [H]'s [O.getDisplayName()]!</span>",
								"<span class='userdanger'>You feel [R] lodge into your [O.getDisplayName()]!</span>")
				playsound(H, 'sound/weapons/rodgun_pierce.ogg', 50, 1) //For super audible murder
				H.emote("scream")
				H.adjustBloodLoss(0.01, O)
				var/turf/T = get_step(H, dir)
				if(istype(T) && T.density && !H.pinned_to) //Can only pin someone once.
					H.pinned_to = T
					T.pinned = H
					H.anchored = 1 //to preserve my sanity.
					H.update_canmove()
					H.do_pindown(T, 1)
					R.pinned = T
	else
		playsound(target, 'sound/weapons/pierce.ogg', 50, 1)

//Gun itself
//TODO:	Add wall pinning. Basically check if there's a wall behind the human that was hit by the rod and if so pin him to that wall.
//		Should deal additional damage + increase the time it takes to remove the rod. When the rod is taken out, unpin the dude.
/obj/item/weapon/gun/rodgun
	name = "rod gun"
	desc = "An absolutely devastating weapon usually used by the syndicate engineers."
	icon = 'icons/obj/staples.dmi'
	icon_state = "rodgun"
	item_state = "gun"
	m_amt = 15000
	w_class = 3.0
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 6
	origin_tech = "combat=2;syndicate=5"
	fire_sound = 'sound/weapons/rodgun_fire.ogg'
	recoil = 1
	var/ammo_type = /obj/item/ammo_casing/rod
	var/rods = 1
	var/maxrods = 3

//Info
/obj/item/weapon/gun/rodgun/update_icon()
	..()
	overlays.Cut()
	if(rods > 0)
		overlays += "rg_loaded"

/obj/item/weapon/gun/rodgun/examine(mob/user)
	..()
	user << "[rods] / [maxrods] rods loaded."

//Reloading
/obj/item/weapon/gun/rodgun/attackby(obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		if(rods < maxrods)
			var/obj/item/stack/rods/R = I
			var/amt = maxrods - rods
			if(R.amount < amt)
				amt = R.amount
			R.amount -= amt
			if (R.amount <= 0)
				user.unEquip(R, 1)
				qdel(R)
			rods += amt
			update_icon()
			playsound(user, 'sound/weapons/rodgun_reload.ogg', 50, 1)
			user << "<span class='notice'>You insert [amt] rods in \the [src]. Now it contains [rods] rods."
		else
			user << "<span class='notice'>\The [src] is already full!</span>"

//Fire overwrite stolen from magic wand code
/obj/item/weapon/gun/rodgun/afterattack(atom/target as mob, mob/living/user as mob, flag)
	newshot()
	..()

/obj/item/weapon/gun/rodgun/can_shoot()
	return rods > 0

/obj/item/weapon/gun/rodgun/proc/newshot()
	if(rods > 0 && chambered)
		chambered.newshot()
	return

/obj/item/weapon/gun/rodgun/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		rods--//... drain a charge
	return

/obj/item/weapon/gun/rodgun/New()
	..()
	chambered = new ammo_type(src)

// /obj/item/weapon/gun/rodgun/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, var/message = 1, params)
// 	add_fingerprint(user)

// 	if(rods > 0)
// 		if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
// 			shoot_live_shot(user, 1, target)
// 		else
// 			shoot_live_shot(user)
// 		rods--
// 	else
// 		shoot_with_empty_chamber(user)

// 	update_icon()

// 	if(user.hand)
// 		user.update_inv_l_hand(0)
// 	else
// 		user.update_inv_r_hand(0)