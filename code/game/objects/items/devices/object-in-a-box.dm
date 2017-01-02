/obj/item/device/object_in_a_box
	name = "honk-in-a-box"
	desc = "Used to dispense a big object at your location, such as a structure."
	icon_state = "object-in-a-box"
	w_class = 4
	origin_tech = "materials=2"
	hitsound = 'sound/weapons/tap.ogg'
	var/obj/contained = null

/obj/item/device/object_in_a_box/New(loc, master)
	..()
	contained = new master
	name = "[contained.name]-in-a-box"
	var/image/img = image("icon"=contained, "layer"=FLOAT_LAYER)
	img.transform /= 3
	img.pixel_x -= 3
	img.pixel_y -= 1
	overlays += img

/obj/item/device/object_in_a_box/attack_self(mob/user)
	if(contained)
		user << "<span class='notice'>You start activating \the [src]...</span>"
		if(do_after(user, 50, target = user))
			contained.loc = get_turf(src)
			contained = null
			user.visible_message("<span class='danger'>[user] activates \the [src]!</span>", "<span class='notice'>You activate \the [src]!</span>")
			qdel(src)
		else return
	return