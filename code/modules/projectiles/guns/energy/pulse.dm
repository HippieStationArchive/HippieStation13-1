/obj/item/weapon/gun/energy/pulse
	name = "pulse rifle"
	desc = "A heavy-duty, multifaceted energy rifle with three modes. Preferred by front-line combat personnel."
	icon_state = "pulse"
	item_state = "pulse"
	w_class = 4
	force = 10
	stamina_percentage = 0.3
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	cell_type = "/obj/item/weapon/stock_parts/cell/pulse"

/obj/item/weapon/gun/energy/pulse/attack_self(mob/living/user)
	select_fire(user)

/obj/item/weapon/gun/energy/pulse/emp_act(severity)
	return

/obj/item/weapon/gun/energy/pulse/loyalpin

/obj/item/weapon/gun/energy/pulse/carbine
	name = "pulse carbine"
	desc = "A compact variant of the pulse rifle with less firepower but easier storage."
	w_class = 3
	slot_flags = SLOT_BELT
	icon_state = "pulse_carbine"
	item_state = "pulse"
	cell_type = "/obj/item/weapon/stock_parts/cell/pulse/carbine"
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12
	can_knife = 1
	knife_x_offset = 18
	knife_y_offset = 12

/obj/item/weapon/gun/energy/pulse/carbine/loyalpin

/obj/item/weapon/gun/energy/pulse/pistol
	name = "pulse pistol"
	desc = "A pulse rifle in an easily concealed handgun package with low capacity."
	w_class = 2
	slot_flags = SLOT_BELT
	icon_state = "pulse_pistol"
	item_state = "gun"
	cell_type = "/obj/item/weapon/stock_parts/cell/pulse/pistol"
	can_charge = 0

/obj/item/weapon/gun/energy/pulse/pistol/loyalpin


/obj/item/weapon/gun/energy/pulse/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty energy rifle built for pure destruction."
	cell_type = "/obj/item/weapon/stock_parts/cell/infinite"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse)

/obj/item/weapon/gun/energy/pulse/destroyer/attack_self(mob/living/user)
	user << "<span class='danger'>[src.name] has three settings, and they are all DESTROY.</span>"

/obj/item/weapon/gun/energy/pulse/pistol/m1911
	name = "\improper M1911-P"
	desc = "A compact pulse core in a classic handgun frame for Nanotrasen officers. It's not the size of the gun, it's the size of the hole it puts through people."
	icon_state = "m1911"
	item_state = "gun"
	cell_type = "/obj/item/weapon/stock_parts/cell/infinite"

/obj/item/weapon/gun/energy/pulse/plasmoid
	name = "plasma rifle"
	desc = "An experimental heavy duty energy rifle with standard laser and electrode fire modes and an experimental plasma mode with a high energy draw which fires a burst of 3 superhot plasmoids that immolate targets, the range is limited however."
	icon_state = "plasmoidr"
	item_state = "plasmoidr"
	slot_flags = SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/plasmoid/burst, /obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
