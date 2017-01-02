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
	fire_sound = "gunshot"
	action_button_name = null
	can_flashlight = 1
	flight_x_offset = 15
	flight_y_offset = 12
	can_knife = 1
	knife_x_offset = 15
	knife_y_offset = 12
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/pistol/ui_action_click()
	return

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
	flight_x_offset = 18
	knife_x_offset = 18
	fire_sound = list('sound/weapons/pistol_glock17_1.ogg','sound/weapons/pistol_glock17_2.ogg')
	pin = /obj/item/device/firing_pin/area/syndicate

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
	fire_sound = 'sound/weapons/pistol_m1911.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/deagle
	name = "Desert Eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	stamina_percentage = 0.6
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = 0
	fire_sound = 'sound/weapons/deagle.ogg'

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

/obj/item/weapon/gun/projectile/automatic/pistol/automag
	name = "Automag"
	desc = "A semi-automatic .44 AMP caliber handgun. A rare firearm generally only seen among the highest-ranking NanoTrasen officers. The caliber gives this weapon immense firepower in a fairly small size."
	icon_state = "automag"
	force = 10
	stamina_percentage = 0.6
	mag_type = /obj/item/ammo_box/magazine/m44
	can_suppress = 0
	can_flashlight = 0
	can_knife = 0
	w_class = 3
	fire_sound = 'sound/weapons/revolver_big.ogg'
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/pistol/automag/update_icon()
	..()
	icon_state = "automag[magazine ? "-[Ceiling(get_ammo(0)/7)*7]" : ""][chambered ? "" : "-e"]"
	return
/obj/item/weapon/gun/projectile/automatic/pistol/c05r
	name = "C05-R"
	desc = "A replica of an old Russian handgun. This one however, is chambered to fire .45 ACP. Generally seen wielded by New-Russian officers. Has the distinct ability to do a quick burst-fire."
	icon_state = "c05r"
	mag_type = /obj/item/ammo_box/magazine/c05r
	can_suppress = 0
	can_flashlight = 0
	can_knife = 0
	w_class = 2
	fire_sound = 'sound/weapons/pistol_glock17_1.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/c05r/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/pistol/luger
	name = "P057A Luger"
	desc = "A modern take on an ancient weapon, this one is chambered in .357 and is fairly uncommon. Loads from an internal-magazine, requiring either individually loading of cartridges or loading through a stripper-clip."
	icon_state = "p08"
	mag_type = /obj/item/ammo_box/magazine/luger
	can_suppress = 0
	can_flashlight = 0
	can_knife = 0
	w_class = 2
	fire_sound = 'sound/weapons/gunshot_beefy.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/luger/update_icon()
	..()
	icon_state = "p08[magazine ? "-[Ceiling(get_ammo(0)/10)*10]" : ""][chambered ? "" : "-e"]"
	return