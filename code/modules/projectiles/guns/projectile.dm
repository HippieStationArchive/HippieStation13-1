/obj/item/weapon/gun/projectile
	desc = "Now comes in flavors like GUN. Uses 10mm ammo, for some reason"
	name = "projectile gun"
	icon_state = "pistol"
	origin_tech = "combat=2;materials=2"
	w_class = 3
	materials = list(MAT_METAL=1000)

	var/mag_type = /obj/item/ammo_box/magazine/m10mm //Removes the need for max_ammo and caliber info
	var/obj/item/ammo_box/magazine/magazine
	var/mag_load_sound = 'sound/effects/wep_magazines/handgun_generic_load.ogg'
	var/mag_unload_sound = 'sound/effects/wep_magazines/handgun_generic_unload.ogg'
	var/chamber_sound = 'sound/effects/wep_magazines/generic_chamber.ogg'
	
	var/can_sawn = FALSE

/obj/item/weapon/gun/projectile/New()
	..()
	if (!magazine)
		magazine = new mag_type(src)
	chamber_round()
	update_icon()
	return

/obj/item/weapon/gun/projectile/update_icon()
	overlays.Cut()
	if(F)
		var/iconF = "flight"
		if(F.on)
			iconF = "flight_on"
		overlays += image(icon = 'icons/obj/guns/attachments.dmi', icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset)
	if(knife)
		var/iconK = "knife"
		overlays += image(icon = 'icons/obj/guns/attachments.dmi', icon_state = iconK, pixel_x = knife_x_offset, pixel_y = knife_y_offset)

/obj/item/weapon/gun/projectile/process_chamber(eject_casing = 1, empty_chamber = 1)
//	if(in_chamber)
//		return 1
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(isnull(AC) || !istype(AC))
		chamber_round()
		return
	if(eject_casing)
		AC.loc = get_turf(src) //Eject casing onto ground.
		AC.SpinAnimation(10, 1) //next gen special effects
		playsound(loc, pick('sound/effects/wep_misc/casing_bounce1.ogg', 'sound/effects/wep_misc/casing_bounce2.ogg', 'sound/effects/wep_misc/casing_bounce3.ogg'), 80)
	if(empty_chamber)
		chambered = null
	chamber_round()
	return

/obj/item/weapon/gun/projectile/proc/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round()
		chambered.loc = src
	return

/obj/item/weapon/gun/projectile/can_shoot()
	if(!magazine || !magazine.ammo_count(0))
		return 0
	return 1

/obj/item/weapon/gun/projectile/attackby(obj/item/A, mob/user, params)
	..()
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			user << "<span class='notice'>You load a new magazine into \the [src].</span>"
			chamber_round()
			A.update_icon()
			update_icon()
			playsound(loc, mag_load_sound, 80)	//First val = volume, second = rand (pitch), third = fadeout rate
			return 1
		else if (magazine)
			user << "<span class='notice'>There's already a magazine in \the [src].</span>"
	if(istype(A, /obj/item/weapon/suppressor))
		if(can_suppress)
			if(!suppressed && !knife && !F)
				if(!user.unEquip(A))
					return
				user << "<span class='notice'>You screw [A] onto [src].</span>"
				suppressed = A
				fire_sound = 'sound/weapons/Gunshot_silenced.ogg'
				w_class += 1 //so pistols do not fit in pockets when suppressed
				A.loc = src
				update_icon()
				return
			else
				user << "<span class='warning'>[src] already has an attachment!</span>"
				return
		else
			user << "<span class='warning'>You can't seem to figure out how to fit [A] on [src]!</span>"
			return
	return 0

/obj/item/weapon/gun/projectile/attack_hand(mob/user)
	if(loc == user)
		if(suppressed && can_unsuppress)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You unscrew [suppressed] from [src].</span>"
			user.put_in_hands(suppressed)
			fire_sound = initial(fire_sound)
			w_class = initial(w_class)
			suppressed = 0
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/attack_self(mob/living/user)
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(magazine)
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine.update_icon()
		magazine = null
		playsound(loc, mag_unload_sound, 80)
		user << "<span class='notice'>You pull the magazine out of \the [src].</span>"
	else if(chambered)
		AC.loc = get_turf(src)
		AC.SpinAnimation(10, 1)
		chambered = null
		playsound(loc, chamber_sound, 80)
		user << "<span class='notice'>You unload the round from \the [src]'s chamber.</span>"
	else
		user << "<span class='notice'>There's no magazine in \the [src].</span>"
	update_icon()
	return


/obj/item/weapon/gun/projectile/examine(mob/user)
	..()
	user << "Has [get_ammo()] round\s remaining."

/obj/item/weapon/gun/projectile/proc/get_ammo(countchambered = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets

/obj/item/weapon/gun/projectile/suicide_act(mob/user)
	if (src.chambered && src.chambered.BB && !src.chambered.BB.nodamage)
		user.visible_message("<span class='suicide'>[user] is putting the barrel of the [src.name] in \his mouth.  It looks like \he's trying to commit suicide.</span>")
		sleep(25)
		if(user.l_hand == src || user.r_hand == src)
			process_fire(user, user, 0, zone_override = "head")
			user.visible_message("<span class='suicide'>[user] blows \his brains out with the [src.name]!</span>")
			return(BRUTELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to blow \his brains out with the [src.name]! It looks like \he's trying to commit suicide!</b></span>")
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1, -1)
		return (OXYLOSS)

/obj/item/weapon/suppressor
	name = "suppressor"
	desc = "A universal syndicate small-arms suppressor for maximum espionage."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "suppressor"
	w_class = 2