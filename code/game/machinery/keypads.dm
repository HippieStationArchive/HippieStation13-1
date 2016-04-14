/obj/machinery/button/keypad
	name = "keypad"
	desc = "A remote control switch requiring a code input."
	icon_state = "keypad"
	skin = "keypad"
	var/password = ""
	var/max_digits = 4

/obj/machinery/button/keypad/New(loc, ndir = 0, built = 0)
	..()
	if(built)
		dir = ndir
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
		panel_open = 1
		update_icon()

	if(id && !built && !device && device_type)
		device = new device_type(src)

	if(id && istype(device, /obj/item/device/assembly/control))
		var/obj/item/device/assembly/control/A = device
		A.id = id

/obj/machinery/button/keypad/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "keypad-open"
		if(device)
			overlays += "keypad-device"
		if(board)
			overlays += "keypad-board"

	else
		if(stat & (NOPOWER|BROKEN))
			icon_state = "[skin]-p"
		else
			icon_state = skin

/obj/machinery/button/keypad/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/device/detective_scanner))
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		default_deconstruction_screwdriver(user, "keypad-open", "[skin]",W)
		update_icon()

	if(panel_open)
		if(!device && istype(W, /obj/item/device/assembly))
			if(!user.unEquip(W))
				user << "<span class='warning'>\The [W] is stuck to you!</span>"
				return
			W.loc = src
			device = W
			user << "<span class='notice'>You add [W] to \the [src].</span>"

		if(!board && istype(W, /obj/item/weapon/electronics/airlock))
			if(!user.unEquip(W))
				user << "<span class='warning'>\The [W] is stuck to you!</span>"
				return
			W.loc = src
			board = W
			user << "<span class='notice'>You add [W] to \the [src].</span>"

		if(!device && !board && istype(W, /obj/item/weapon/wrench))
			user << "<span class='notice'>You start unsecuring \the [src] frame...</span>"
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 40/W.toolspeed, target = src))
				user << "<span class='notice'>You unsecure \the [src] frame.</span>"
				transfer_fingerprints_to(new /obj/item/wallframe/button(get_turf(src)))
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				qdel(src)

		update_icon()
		return

	return attack_hand(user)

/obj/machinery/button/keypad/emag_act(mob/user)
	user << "<span class='warning'>The password has been set to nothing!</span>"
	password = ""
	playsound(loc, "sparks", 100, 1)

/obj/machinery/button/keypad/attack_ai(mob/user)
	if(!panel_open)
		return attack_hand(user)

/obj/machinery/button/keypad/attack_hand(mob/user)
	add_fingerprint(user)
	if(panel_open)
		if(device || board)
			if(device)
				device.loc = get_turf(src)
				device = null
			if(board)
				board.loc = get_turf(src)
				board = null
			update_icon()
			user << "<span class='notice'>You remove electronics from \the [src] frame.</span>"
		return

	if((stat & (NOPOWER|BROKEN)))
		return

	if(device && device.cooldown)
		return

	// use_power(5)
	// icon_state = "[skin]1"

	// if(device)
	// 	device.pulsed()

	// spawn(15)
	// 	update_icon()

// /obj/machinery/button/keypad/Topic(href, href_list)
// 	if(..())
// 		return
// 	usr.set_machine(src)
// 	if (href_list["auth"])
// 		if (auth)
// 			auth.loc = loc
// 			yes_code = 0
// 			auth = null
// 		else
// 			var/obj/item/I = usr.get_active_hand()
// 			if (istype(I, /obj/item/weapon/disk/nuclear))
// 				usr.drop_item()
// 				I.loc = src
// 				auth = I
// 	if (auth)
// 		if (href_list["type"])
// 			if (href_list["type"] == "E")
// 				if (code == r_code)
// 					yes_code = 1
// 					code = null
// 				else
// 					code = "ERROR"
// 			else
// 				if (href_list["type"] == "R")
// 					yes_code = 0
// 					code = null
// 				else
// 					lastentered = text("[]", href_list["type"])
// 					if (text2num(lastentered) == null)
// 						var/turf/LOC = get_turf(usr)
// 						message_admins("[key_name_admin(usr)] (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) tried to exploit a nuclear bomb by entering non-numerical codes: <a href='?_src_=vars;Vars=\ref[src]'>[lastentered]</a> ! ([LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])", 0)
// 						log_admin("EXPLOIT : [key_name(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: [lastentered] !")
// 					else
// 						code += lastentered
// 						if (length(code) > 5)
// 							code = "ERROR"
// 		if (yes_code)
// 			if (href_list["time"])
// 				var/time = text2num(href_list["time"])
// 				timeleft += time
// 				timeleft = min(max(round(timeleft), 60), 600)
// 			if (href_list["timer"])
// 				set_active()
// 			if (href_list["safety"])
// 				set_safety()
// 			if (href_list["anchor"])
// 				set_anchor()
// 	add_fingerprint(usr)
// 	for(var/mob/M in viewers(1, src))
// 		if ((M.client && M.machine == src))
// 			attack_hand(M)