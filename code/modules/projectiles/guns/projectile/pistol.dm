/obj/item/weapon/gun/projectile/automatic/pistol
	name = "stetchkin pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon_state = "pistol"
	w_class = 2
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 1
	burst_size = 1
	fire_delay = 0
	mag_load_sound = 'sound/effects/wep_magazines/handgun_generic_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/handgun_generic_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/generic_chamber.ogg'
	action_button_name = null

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol/g17
	name = "Glock 17"
	desc = "A classic 9mm handgun with a large magazine capacity. Used by security teams everywhere."
	icon_state = "glock17"
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/g17

/obj/item/weapon/gun/projectile/automatic/pistol/g17/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol/m1911
	name = "M1911"
	desc = "A classic .45 handgun with a small magazine capacity."
	icon_state = "m1911"
	w_class = 3
	mag_type = /obj/item/ammo_box/magazine/m45
	can_suppress = 0

/obj/item/weapon/gun/projectile/automatic/pistol/deagle
	name = "Desert Eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = 0

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/gold
	desc = "A gold plated desert eagle folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"
