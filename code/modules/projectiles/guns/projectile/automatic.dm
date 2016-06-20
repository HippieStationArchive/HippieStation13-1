/obj/item/weapon/gun/projectile/automatic
	origin_tech = "combat=4;materials=2"
	w_class = 3
	var/alarmed = 0
	var/select = 1
	can_suppress = 1
	burst_size = 3
	fire_delay = 1	//Pre-rebase fire rate, nothing to see here.
	spread = 3 //Additional spread added to the projectiles once auto firerate is selected.
	mag_load_sound = 'sound/effects/wep_magazines/smg_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/smg_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/smg_chamber.ogg'
	action_button_name = "Toggle Firemode"
	fire_sound = 'sound/weapons/Machinegun.ogg'

/obj/item/weapon/gun/projectile/automatic/proto
	name = "Prototype SMG"
	desc = "A prototype three-round burst 9mm submachine gun, designated 'SABR'. Has a threaded barrel for suppressors."
	icon_state = "saber"
	mag_type = /obj/item/ammo_box/magazine/smgm9mm

/obj/item/weapon/gun/projectile/automatic/proto/unrestricted

/obj/item/weapon/gun/projectile/automatic/update_icon()
	..() //overlays.Cut() is called in parent
	if(!select)
		overlays += "[initial(icon_state)]semi"
	if(select == 1)
		overlays += "[initial(icon_state)]burst"
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	if(istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if(istype(AM, mag_type))
			if(magazine)
				user << "<span class='notice'>You perform a tactical reload on \the [src], replacing the magazine.</span>"
				magazine.loc = get_turf(src.loc)
				magazine.update_icon()
				magazine = null
			else
				user << "<span class='notice'>You insert the magazine into \the [src].</span>"
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			chamber_round()
			A.update_icon()
			update_icon()
			return 1

/obj/item/weapon/gun/projectile/automatic/ui_action_click()
	burst_select()

/obj/item/weapon/gun/projectile/automatic/proc/burst_select()
	var/mob/living/carbon/human/user = usr
	select = !select
	if(!select)
		burst_size = 1
		fire_delay = 0
		spread = 0
		user << "<span class='notice'>You switch to semi-automatic.</span>"
	else
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		spread = initial(spread)
		user << "<span class='notice'>You switch to [burst_size]-rnd burst.</span>"

	playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/can_shoot()
	return get_ammo()

/obj/item/weapon/gun/projectile/automatic/proc/empty_alarm()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(src.loc, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/c20r
	name = "C-20r SMG"
	desc = "A bullpup two-round burst .45 SMG, designated 'C-20r'. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/smgm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	fire_delay = 2
	burst_size = 2
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/c20r/unrestricted

/obj/item/weapon/gun/projectile/automatic/c20r/New()
	..()
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/c20r/afterattack()
	..()
	empty_alarm()
	return

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	icon_state = "c20r[magazine ? "-[Ceiling(get_ammo(0)/4)*4]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/wt550
	name = "Automatic Security Rifle"
	desc = "An outdated personal defence weapon. Uses 9mm rounds and is designated the WT-550 Automatic Rifle."
	icon_state = "wt550"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/wt550m9
	fire_delay = 2
	can_suppress = 0
	burst_size = 0
	mag_load_sound = 'sound/effects/wep_magazines/ar_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ar_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ar_chamber.ogg'
	fire_sound = 'sound/weapons/Gunshot_beefy.ogg'

/obj/item/weapon/gun/projectile/automatic/wt550/ui_action_click()
	return

/obj/item/weapon/gun/projectile/automatic/wt550/update_icon()
	..()
	icon_state = "wt550[magazine ? "-[Ceiling(get_ammo(0)/4)*4]" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "Mini-Uzi"
	desc = "De oozi naihn millahmeada, for when you really want someone dead."
	icon_state = "mini-uzi"
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/uzim9mm
	burst_size = 4
	spread = 10

/obj/item/weapon/gun/projectile/automatic/ak922
	name = "AK-922"
	desc = "A New-Russia standard-issue battle rifle chambered in 7.62x39mm. Packs a punch and is built out of strong materials with an old yet reliable build."
	icon_state = "ak922"
	item_state = "ak922"
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_box/magazine/ak922
	can_suppress = 0
	fire_sound = 'sound/weapons/handcannon.ogg'
	fire_delay = 1
	burst_size = 3
	spread = 6
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12
	can_knife = 1
	knife_x_offset = 18
	knife_y_offset = 12
	mag_load_sound = 'sound/effects/wep_magazines/ak922_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ak922_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ak922_chamber.ogg'

/obj/item/weapon/gun/projectile/automatic/ak922/afterattack()
	..()
	empty_alarm()
	return

/obj/item/weapon/gun/projectile/automatic/ak922/update_icon()
	..()
	icon_state = "ak922[magazine ? "-[Ceiling(get_ammo(0)/5)*5]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/ak922/gold
	icon_state = "ak922gold"
	item_state = "ak922gold"
	desc = "Damn son! Now that's a nice gun!"
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/ak922/gold/update_icon()
	..()
	icon_state = "ak922gold[magazine ? "-[Ceiling(get_ammo(0)/5)*5]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/c90
	name = "Syndicate Carbine"
	desc = "A three-round burst 5.56x45mm toploading carbine, designated 'C-90'. Has an attached underbarrel grenade launcher which can be toggled on and off."
	icon_state = "c90"
	item_state = "c90"
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/m556
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	can_suppress = 0
	var/obj/item/weapon/gun/projectile/revolver/grenadelauncher/underbarrel
	burst_size = 3
	fire_delay = 2
	spread = 6
	mag_load_sound = 'sound/effects/wep_magazines/ar_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ar_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ar_chamber.ogg'
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12
	can_knife = 1
	knife_x_offset = 18
	knife_y_offset = 12
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/c90/New()
	..()
	underbarrel = new /obj/item/weapon/gun/projectile/revolver/grenadelauncher(src)
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/c90/unrestricted

/obj/item/weapon/gun/projectile/automatic/c90/unrestricted/New()
	..()
	underbarrel = new /obj/item/weapon/gun/projectile/revolver/grenadelauncher(src)
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/c90/afterattack(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack(target, user, flag, params)
	else
		..()
		return
/obj/item/weapon/gun/projectile/automatic/c90/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self()
			underbarrel.attackby(A, user, params)
	else
		..()
/obj/item/weapon/gun/projectile/automatic/c90/update_icon()
	..()
	overlays.Cut()
	switch(select)
		if(0)
			overlays += "[initial(icon_state)]semi"
		if(1)
			overlays += "[initial(icon_state)]burst"
		if(2)
			overlays += "[initial(icon_state)]gren"
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"
	return
/obj/item/weapon/gun/projectile/automatic/c90/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			user << "<span class='notice'>You switch to [burst_size]-rnd burst.</span>"
		if(1)
			select = 2
			user << "<span class='notice'>You switch to grenades.</span>"
		if(2)
			select = 0
			burst_size = 1
			fire_delay = 0
			user << "<span class='notice'>You switch to semi-auto.</span>"
	playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/tommygun
	name = "Tommy Gun"
	desc = "Based on the classic 'Chicago Typewriter'."
	icon_state = "tommygun"
	item_state = "shotgun"
	w_class = 3
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	fire_sound = 'sound/weapons/tommygun_shoot.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	spread = 7
	mag_load_sound = 'sound/effects/wep_magazines/bulldog_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/bulldog_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/bulldog_chamber.ogg'

/obj/item/weapon/gun/projectile/automatic/ar
	name = "NT Assault Rifle"
	desc = "A robust assault rile used by Nanotrasen fighting forces."
	icon_state = "arg"
	item_state = "arg"
	slot_flags = 0
	origin_tech = "combat=5;materials=1"
	mag_type = /obj/item/ammo_box/magazine/m556
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 1
	spread = 3
	mag_load_sound = 'sound/effects/wep_magazines/ar_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ar_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ar_chamber.ogg'
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12
	can_knife = 1
	knife_x_offset = 18
	knife_y_offset = 12

/obj/item/weapon/gun/projectile/automatic/pistol/mac10
	name = "Mac-10 SMG"
	desc = "An old SMG, these used to be easily and cheaply mass-produced firearms. Their small size also made them great for concealing, however, the accuracy is anything but decent."
	icon_state = "mac10"
	mag_type = /obj/item/ammo_box/magazine/mac10
	can_suppress = 0
	w_class = 2
	spread = 10
	burst_size = 3
	fire_delay = 1
	fire_sound = 'sound/weapons/gunshot_smg.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/mac10/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/alc
	name = "Automatic Laser Carbine"
	desc = "This modern, state-of-the-art energy weapon uses specialized disposable plasma cartridges in a small magazine similar to ballistic firearms. Advanced cooling technology allows for the ALC to be fired in short bursts. However, the unusual method of loading results in some inaccuracy compared to traditional energy weapons."
	icon_state = "alc"
	item_state = "alc"
	mag_type = /obj/item/ammo_box/magazine/alc
	can_suppress = 0
	w_class = 3
	spread = 4
	burst_size = 3
	fire_delay = 1.5
	fire_sound = 'sound/weapons/laser.ogg'
	mag_load_sound = 'sound/effects/wep_magazines/ar_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ar_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ar_chamber.ogg'

/obj/item/weapon/gun/projectile/automatic/alc/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/alc/afterattack()
	..()
	empty_alarm()
	return

/obj/item/weapon/gun/projectile/automatic/alc/update_icon()
	..()
	icon_state = "alc[magazine ? "-[Ceiling(get_ammo(0)/9)*8]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/aks74
	name = "AKS-740U"
	desc = "An earlier model of the AK platform, this fires a lower caliber cartridge and is a lighter weight than its AK-922 counterpart. Remains quite deadly regardless and functions similarly."
	icon_state = "aks74"
	item_state = "ak922"
	mag_type = /obj/item/ammo_box/magazine/aks74
	can_suppress = 0
	w_class = 3
	spread = 6
	burst_size = 3
	fire_delay = 1
	fire_sound = 'sound/weapons/tommygun_shoot.ogg'
	mag_load_sound = 'sound/effects/wep_magazines/ak922_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ak922_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ak922_chamber.ogg'

/obj/item/weapon/gun/projectile/automatic/aks74/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/xmg80
	name = "AA-XMG80"
	desc = "A state-of-the-art, high-tech assault rifle manufactured by Aussec Armory. Comes with a 2x red dot sight. Utilizes the uncommon 6.8x43mm caseless ammunition, which is light while still allowing for superior armor-piercing capability and high velocity. Often called 'The Shredder' for its immense damage potential, which also results in this firearm being banned in NanoTrasen-controlled sectors for being 'too messy' and expensive."
	icon_state = "xmg80"
	item_state = "c20r"
	mag_type = /obj/item/ammo_box/magazine/xmg80
	can_suppress = 0
	w_class = 3
	spread = 2
	burst_size = 4
	fire_delay = 1
	force = 10
	stamina_percentage = 0.5
	origin_tech = "combat=6;materials=4;syndicate=8"
	fire_sound = 'sound/weapons/gunshot_g36.ogg'
	mag_load_sound = 'sound/effects/wep_magazines/ar_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/ar_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/ar_chamber.ogg'

/obj/item/weapon/gun/projectile/automatic/xmg80/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/xmg80/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()
