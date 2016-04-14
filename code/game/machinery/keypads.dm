//Wallframes
/obj/item/wallframe/keypad
	name = "keypad frame"
	desc = "Used for building keypads."
	icon_state = "keypad_frame"
	result_path = /obj/machinery/keypad
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
	var/password = ""

/obj/item/wallframe/keypad/attack_self(mob/user)
	if(!user)
		return 0
	if(!password)
		var/pass = input(user,"Please input a new password for this keypad.","Set Password") as null|num
		if(!pass)
			return
		if(!isnum(pass))
			user << "<span class='warning>The password must be a number!</span>"
			return
		if(length(pass) > 6)
			user << "<span class='warning>The password cannot be longer than 6 digits!</span>"
			return
		password = pass
		user << "<span class='notice'>You have set \the [src]'s password to [password].</span>"
	else
		user << "<span class='warning'>A password is already set for [src]!</span>" //To fix this, you need a multitool.
		return

/obj/item/wallframe/keypad/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/device/multitool))
		user.visible_message("<span class='warning'>[user.name] starts resetting the password on \the [src].</span>", \
							"<span class='notice'>You start resetting the password on \the [src] frame...</span>")
		playsound(src.loc, 'sound/effects/pop.ogg', 50, 1)
		if(do_after(user, 20, target = src))
			user.visible_message("<span class='warning'>[user.name] resets the password on \the [src]!</span>", \
								"<span class='notice'>You reset the password on \the [src] frame!</span>")
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 50, 1)
			password = ""
		return
	..()

/obj/item/wallframe/keypad/attach(turf/on_wall) //I hate how I have to copy-paste code just to prevent the wallframe from being deleted before actually transferring variables.
	if(result_path)
		playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
		usr.visible_message("[usr.name] attaches [src] to the wall.",
			"<span class='notice'>You attach [src] to the wall.</span>",
			"<span class='italics'>You hear clicking.</span>")
		var/ndir = get_dir(on_wall,usr)
		if(inverse)
			ndir = turn(ndir, 180)

		var/obj/machinery/keypad/O = new result_path(get_turf(usr), ndir, 1)
		transfer_fingerprints_to(O)
		O.password = password

	qdel(src)

//Machinery
/obj/machinery/keypad
	name = "keypad"
	desc = "A remote control switch requiring a code input."
	icon_state = "keypad"
	var/skin = "keypad"
	var/password = ""
	var/input = ""
	var/output = "" //what to display in place of input
	var/max_digits = 6
	var/obj/item/device/assembly/device
	var/device_type = null
	var/id = null
	var/wired = 1

/obj/machinery/keypad/New(loc, ndir = 0, built = 0)
	..()
	if(built)
		dir = ndir
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
		panel_open = 1
		wired = 0
		stat |= MAINT
		update_icon()

	if(id && !built && !device && device_type)
		device = new device_type(src)

	if(id && istype(device, /obj/item/device/assembly/control))
		var/obj/item/device/assembly/control/A = device
		A.id = id

/obj/machinery/keypad/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "keypad-open"
		if(wired)
			overlays += "keypad-wired"
		if(device)
			overlays += "keypad-device"
	else
		if(stat & (NOPOWER|BROKEN|MAINT))
			icon_state = "[skin]-p"
		else
			icon_state = skin

/obj/machinery/keypad/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/device/detective_scanner))
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		default_deconstruction_screwdriver(user, "keypad-open", "[skin]",W)
		update_icon()
		return

	if(panel_open)
		if(!wired && istype(W, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/C = W
			if(C.get_amount() < 5)
				user << "<span class='warning'>You need five lengths of cable for \the [src]!</span>"
				return
			user.visible_message("<span class='warning'>[user.name] adds cables to \the [src] frame.</span>", \
								"<span class='notice'>You start adding cables to \the [src] frame...</span>")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			if(do_after(user, 20, target = src))
				if (C.amount >= 5)
					C.use(5)
					wired = 1
					stat &= ~MAINT
					user << "<span class='notice'>You add cables to \the [src] frame.</span>"
					update_icon()
		if(!device && istype(W, /obj/item/device/assembly))
			if(!user.unEquip(W))
				user << "<span class='warning'>\The [W] is stuck to you!</span>"
				return
			W.loc = src
			device = W
			user << "<span class='notice'>You add [W] to \the [src].</span>"

		if(wired && istype(W, /obj/item/weapon/wirecutters))
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(loc)
			C.amount = 5
			user << "<span class='notice'>You cut the wires.</span>"
			stat |= MAINT
			wired = 0
			update_icon()

		if(!device && !wired && istype(W, /obj/item/weapon/wrench))
			user << "<span class='notice'>You start unsecuring \the [src] frame...</span>"
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 40/W.toolspeed, target = src))
				user << "<span class='notice'>You unsecure \the [src] frame.</span>"
				var/obj/item/wallframe/keypad/K = new(get_turf(src))
				transfer_fingerprints_to(K)
				K.password = password
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				qdel(src)

		update_icon()
		return

	return attack_hand(user)

/obj/machinery/keypad/emag_act(mob/user)
	user << "<span class='warning'>The password has been set to nothing!</span>"
	password = ""
	playsound(loc, "sparks", 100, 1)

/obj/machinery/keypad/attack_ai(mob/user)
	if(!panel_open)
		return attack_hand(user)

/obj/machinery/keypad/attack_hand(mob/user)
	add_fingerprint(user)
	if(panel_open)
		if(device)
			if(device)
				device.loc = get_turf(src)
				device = null
			update_icon()
			user << "<span class='notice'>You remove electronics from \the [src] frame.</span>"
		return

	if((stat & (NOPOWER|BROKEN|MAINT)))
		return

	if(device && device.cooldown)
		return

	var/dat
	dat += "<h3>Code:</h3>"
	if(output != "")
		dat += output
	else
		dat += " "
		for(var/i=1, i <= length(input), i++)
			dat += "*"
	dat += "<h3>Input:</h3>"
	dat += "<A href='?src=\ref[src];num=1'>1</A><A href='?src=\ref[src];num=2'>2</A><A href='?src=\ref[src];num=3'>3</A><BR>"
	dat += "<A href='?src=\ref[src];num=4'>4</A><A href='?src=\ref[src];num=5'>5</A><A href='?src=\ref[src];num=6'>6</A><BR>"
	dat += "<A href='?src=\ref[src];num=7'>7</A><A href='?src=\ref[src];num=8'>8</A><A href='?src=\ref[src];num=9'>9</A><BR>"
	dat += "<A href='?src=\ref[src];num=C'>C</A><A href='?src=\ref[src];num=0'>0</A><A href='?src=\ref[src];num=E'>E</A><BR>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "keypad", "Keypad", 240, 240)	//Set up the popup browser window
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.set_content(dat)
	popup.open()

/obj/machinery/keypad/Topic(href, href_list)
	if(..())
		return 0

	usr.set_machine(src)
	if(href_list["num"])
		if(href_list["num"] == "C")
			input = ""
		else if(href_list["num"] == "E")
			if(input != password)
				output = "ERROR"
				flick("[skin]-denied", src)
			else
				input = ""
				use_power(2)
				flick("[skin]1", src)

				if(device)
					device.pulsed()
		else
			if(length(input) < max_digits)
				input = input+"[href_list["num"]]"

	updateUsrDialog()
	output = ""
	add_fingerprint(usr)

/obj/machinery/keypad/power_change()
	..()
	update_icon()
