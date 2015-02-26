//Subtypes at the bottom of file
/obj/structure/closet/guncase
	name = "gun closet"
	desc = "It's a secure locker that contains guns."
	icon = 'icons/obj/guncases.dmi'
	icon_state = "wood_e"
	density = 1
	anchored = 1
	icon_closed = "wood"
	icon_opened = "wood_o"
	// icon_closed = "wood_secure"
	// icon_opened = "wood_o"
	// icon_locked = "wood_locked"
	// icon_broken = "wood_broken"
	// icon_off = "wood_broken"
	// guntype = '/obj/item/weapon/gun' //Not sure if this is even valid
	// wall_mounted = 0
	health = 200 //So it's more emitter/laser-resistant
	large = 0 //So humans cannot be stuffed in
	storage_capacity = 10 //May be a little OP, who knows

// /obj/structure/closet/guncase/place(mob/user, obj/item/I)
// 	if(istype(I, /obj/item/weapon/gun) && opened)
// 		return 1
// 	else
// 		..(user, I)

/obj/structure/closet/guncase/examine()
	..()
	if(contents.len > 0)
		usr << "\blue It contains:"
		for(var/obj/item/I in src)
			//Slightly modified atmo examine code
			var/f_name = "\a [I]."
			if(I.blood_DNA)
				if(gender == PLURAL)
					f_name = "some "
				else
					f_name = "a "
				f_name += "<span class='danger'>blood-stained</span> [I.name]!"

			usr << "\icon[I] \blue[f_name]"
	else
		usr << "\blue It is currently empty."

/obj/structure/closet/guncase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/weapon/gun))
			if(contents.len >= storage_capacity)
				user << "<span class='notice'>[src] is full!</span>"
				return
			user.drop_item(W)
			insert(W)
			update_icon()
		else
			// src.attack_hand(user)
			user << "<span class='notice'>[src] cannot hold [W].</span>"
	else
		..(W, user)

/obj/structure/closet/guncase/attack_hand(mob/user as mob, toggle)
	src.add_fingerprint(user)

	if(opened && contents.len > 0 && !toggle)
		// for(var/obj/item/I in contents)
		// 	user << I
		var/obj/item/I = input("Select item you want to take.", "Closet") in src
		if(I && in_range(src, user))
			I.loc = src.loc
			user.put_in_hands(I)
			user << "<span class='notice'>You take [I] out of [src].</span>"
			update_icon()
	else if(!src.toggle())
		user << "<span class='notice'>It won't budge!</span>"

/obj/structure/closet/guncase/update_icon()
	..()
	if(contents.len <= 0)
		icon_state += "_e"

/obj/structure/closet/guncase/insert(obj/item/I)

	if(contents.len >= storage_capacity)
		return -1

	//TODO: Check for "guntype" var when comparing types to avoid "insert" overwrites for custom guncases
	if(!istype(I, /obj/item/weapon/gun))
		return 0

	I.loc = src
	return 1

/obj/structure/closet/guncase/open()
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	// src.dump_contents() //We don't want to dump all the guns the guncase contains.
	src.opened = 1
	update_icon()
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	// density = 0 //Keep the density
	return 1

/obj/structure/closet/guncase/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	// take_contents() //Unneccesary, we are handling this in attack_hand.
	src.opened = 0
	update_icon()
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
	// density = 1
	return 1

/obj/structure/closet/guncase/energy
	name = "energy gun closet"
	desc = "It's a secure locker that typically contains energy-based weaponry."
	icon = 'icons/obj/guncases.dmi'
	icon_state = "wood"
	icon_closed = "wood"
	icon_opened = "wood_o"

/obj/structure/closet/guncase/energy/New()
	..()
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/ionrifle(src)

/obj/structure/closet/guncase/ballistic
	name = "ballistic gun closet"
	desc = "It's a secure locker that typically contains ballistic weaponry."
	icon = 'icons/obj/guncases.dmi'
	icon_state = "metal"
	icon_closed = "metal"
	icon_opened = "metal_o"

/obj/structure/closet/guncase/ballistic/New()
	..()
	new /obj/item/weapon/gun/projectile/shotgun/riot(src)
	new /obj/item/weapon/gun/projectile/shotgun/riot(src)
	new /obj/item/weapon/gun/projectile/shotgun/riot(src)