//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	var/unfoldedbag_path = /obj/structure/closet/body_bag
	w_class = 2

/obj/item/bodybag/attack_self(mob/user)
		var/obj/structure/closet/body_bag/R = new unfoldedbag_path(user.loc)
		R.add_fingerprint(user)
		qdel(src)


/obj/item/weapon/storage/box/bodybags
	name = "body bags"
	desc = "The label indicates that it contains body bags."
	icon_state = "bodybags"

/obj/item/weapon/storage/box/bodybags/New()
	..()
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)


/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	var/foldedbag_path = /obj/item/bodybag
	density = 0
	mob_storage_capacity = 2
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER //Makes an actual visual indication that this is a draggable object


/obj/structure/closet/body_bag/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/weapon/pen))
		var/t = stripped_input(user, "What would you like the label to be?", name, null, 53)
		if(user.get_active_hand() != I)
			return
		if(!in_range(src, user) && loc != user)
			return
		t = copytext(sanitize(t), 1, 53)	//max length of 64 - "body bag - " instead of MAX_MESSAGE_LEN, as per the hand labeler
		if(t)
			name = "body bag - "
			name += t
			overlays += "bodybag_label"
		else
			name = "body bag"
		return
	else if(istype(I, /obj/item/weapon/wirecutters))
		user << "<span class='notice'>You cut the tag off of [src].</span>"
		name = "body bag"
		overlays.Cut()


/obj/structure/closet/body_bag/close()
	if(..())
		density = 0
		return 1
	return 0


/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return 0
		if(opened)
			return 0
		if(contents.len)
			return 0
		visible_message("<span class='notice'>[usr] folds up [src].</span>")
		var/obj/item/bodybag/B = new foldedbag_path(get_turf(src))
		usr.put_in_hands(B)
		qdel(src)


/obj/structure/closet/body_bag/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened


// Bluespace bodybag

/obj/item/bodybag/bluespace
	name = "bluespace body bag"
	desc = "A folded bluespace body bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bluebodybag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/bluespace
	w_class = 2

/obj/structure/closet/body_bag/bluespace
	name = "bluespace body bag"
	desc = "A bluespace body bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bluebodybag_closed"
	icon_closed = "bluebodybag_closed"
	icon_opened = "bluebodybag_open"
	foldedbag_path = /obj/item/bodybag/bluespace
	density = 0
	mob_storage_capacity = 15
	max_mob_size = 2