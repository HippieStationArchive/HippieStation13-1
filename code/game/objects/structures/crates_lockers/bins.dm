/obj/structure/closet/crate/bin
	desc = "A trash bin, place your trash here for the janitor to collect."
	name = "trash bin"
	icon_crate = "largebins"
	icon_state = "largebins"
	anchored = 1
	sound_effect_open = 'sound/effects/bin_open.ogg'
	sound_effect_close = 'sound/effects/bin_close.ogg'
	var/animation = "animate_largebins"
	var/redlight = "largebinr"
	var/greenlight = "largebing"
	var/orangelight = "largebino"

/obj/structure/closet/crate/bin/New()
	..()
	update_icon()

/obj/structure/closet/crate/bin/update_icon()
	..()
	overlays.Cut()
	if(contents.len == 0)
		overlays += greenlight
	else if(contents.len >= storage_capacity)
		overlays += redlight
	else
		overlays += orangelight

/obj/structure/closet/crate/bin/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/storage/bag/trash))
		var/obj/item/weapon/storage/bag/trash/T = W
		user << "<span class='notice'>You fill the bag.</span>"
		for(var/obj/item/O in src)
			if(T.can_be_inserted(O, 1))
				O.loc = T
		T.update_icon()
		do_animate()
	else if(istype(W, /obj/item/weapon/wrench))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
	else if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		src.MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
	else
		..()

/obj/structure/closet/crate/bin/MouseDrop_T(atom/movable/O as mob|obj, mob/user)
	. = ..(O, user, 0, 0, 0)
	if(.)
		if(O != user)
			user.visible_message("<span class='warning'>[user] tries to stuff [O] into [src].</span>", \
							 	 "<span class='danger'>You try to stuff [O] into [src].</span>", \
							 	 "<span class='italics'>You hear clanging.</span>")
			if (!do_after(user, 40, target = src))
				return
			if(!..(O, user, 0, 0))
				return
			user.visible_message("<span class='warning'>[user] stuffs [O] into[src].</span>", \
							 	 "<span class='notice'>You stuff [O] into [src].</span>", \
							 	 "<span class='italics'>You hear a loud metal bang.</span>")
		insert(O, 1, !opened)
		if(opened)
			close()

/obj/structure/closet/crate/bin/open()
	. = ..()
	update_icon()

/obj/structure/closet/crate/bin/close()
	. = ..()
	update_icon()

/obj/structure/closet/crate/bin/proc/do_animate()
	playsound(src.loc, sound_effect_open, 15, 1, -3)
	flick(animation, src)
	spawn(13)
		playsound(src.loc, sound_effect_close, 15, 1, -3)
		update_icon()

/obj/structure/closet/crate/bin/insert(obj/item/I, include_mobs = 0, animate = 0)
	. = ..(I, include_mobs)
	if(animate && .)
		do_animate()

/obj/structure/closet/crate/bin/place(mob/user, obj/item/I)
	if(contents.len >= storage_capacity)
		return 1
	if(!opened && user.drop_item())
		insert(I, 0, 1)
		return 1
	return 0