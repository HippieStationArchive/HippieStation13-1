/obj/item/clothing/tie/necklace
	name = "necklace"
	w_class = 2
	desc = "Can attach teeth to it."
	icon = 'icons/obj/trophys.dmi'
	icon_state = "necklace_red"
	var/list/ornaments = list() //Teeth attached to this.
	var/max_ornaments = 16
	var/updatecolor = "red"
	item_color = "necklace" //Workaround, necklace color won't show up on person but whether or not teeth are on it will

/obj/item/clothing/tie/necklace/New()
	..()
	update_icon()

/obj/item/clothing/tie/necklace/update_icon()
	icon_state = "necklace_[updatecolor]"
	item_color = "necklace"
	overlays.Cut()
	if(ornaments && ornaments.len)
		item_color = "necklace_teeth"
		var/i = 0
		for(var/obj/item/I in ornaments)
			if(i >= 10) break //Too many teeth already, no room to display anymore
			var/image/img = image(icon,src,"o_[I.icon_state]")
			if(img)
				i++
				//X for tooth number N = necklace center X - tooth spacing * tooth count / 2 + tooth spacing * N
				var/necklace_center_x = 14
				var/tooth_spacing = 2
				img.pixel_x = necklace_center_x - tooth_spacing * min(ornaments.len, 10) / 2 + tooth_spacing * i
				//TODO: Make below if checks a single calculation like pixel_x
				if(img.pixel_x < 11 || img.pixel_x > 19)
					img.pixel_y += 1
				if(img.pixel_x < 9 || img.pixel_x > 21)
					img.pixel_y += 1
				if(img.pixel_x < 8 || img.pixel_x > 22)
					img.pixel_y += 1

				overlays += img

/obj/item/clothing/tie/necklace/examine(mob/user)
	..()
	user << "It contains:"
	for(var/obj/item/I in ornaments)
		var/getname = I.name
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			getname = S.singular_name
		user << "\icon[I] \a [getname]"

/obj/item/clothing/tie/necklace/attack_self(mob/user)
	if(ornaments.len)
		user << "You shuffle the ornaments on the necklace."
		ornaments = shuffle(ornaments)
		update_icon()

/obj/item/clothing/tie/necklace/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters))
		new /obj/item/stack/cable_coil(user.loc, 4, updatecolor)
		for(var/obj/item/I in ornaments)
			I.loc = user.loc
		user << "You cut the necklace."
		qdel(src)
		return
	if(istype(W, /obj/item/stack/teeth))
		if(ornaments.len >= max_ornaments)
			user << "There's no room for \the [src]!"
			return
		var/obj/item/stack/teeth/O = W
		var/obj/item/stack/teeth/T = new O.type(user, 1)
		T.copy_evidences(src)
		T.add_fingerprint(user)
		ornaments += T
		T.loc = src
		O.use(1) //Take some teeth from the teeth stack
		update_icon()
		user << "You add one [T] to \the [src]."

/obj/item/stack/teeth/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/cable_coil))
		src.add_fingerprint(user)
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 4)
			usr << "<span class='danger'>You need at least 4 lengths to make a necklace!</span>"
			return
		var/obj/item/clothing/tie/necklace/N = new (usr.loc)
		N.updatecolor = C.item_color
		var/obj/item/stack/teeth/T = new src.type(user, 1)
		T.copy_evidences(src)
		T.add_fingerprint(user)
		src.use(1) //Take some teeth from the teeth stack
		N.ornaments += T
		T.loc = N
		N.update_icon()
		C.use(4) //Take some cables
	else
		..()