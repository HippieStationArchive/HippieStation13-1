/obj/item/device/remote_button/bwoink
	name = "bwoink button"
	desc = "Used to test remote functionality. Gives a pleasing bwoink."

	icon_state = "button_ping"

/obj/item/device/remote_button/bwoink/on_press(mob/user)
	playsound(get_turf(holder), 'sound/effects/adminhelp.ogg', 25, 0)

/obj/item/device/remote_button/bang
	name = "bang button"
	desc = "Used to test remote functionality. Gives a resounding bang."

	icon_state = "button_bang"

/obj/item/device/remote_button/bang/on_press(mob/user)
	playsound(get_turf(holder), 'sound/effects/bang.ogg', 25, 1)

/obj/item/device/remote_button/tong
	name = "tong button"
	desc = "Used to test remote functionality. Gives a solid tong."

	icon_state = "button_tong"

/obj/item/device/remote_button/tong/on_press(mob/user)
	playsound(get_turf(holder), 'sound/piano/Cn4.ogg', 25, 1)