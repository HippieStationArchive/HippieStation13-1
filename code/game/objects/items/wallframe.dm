/obj/item/wallframe
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT*2)
	flags = CONDUCT
	origin_tech = "materials=1;engineering=1"
	icon = 'icons/obj/wallframe.dmi'
	item_state = "syringe_kit"
	w_class = 2
	var/result_path
	var/inverse = 0 // For inverse dir frames like light fixtures.
	var/powerless = 0 // does the wallframe need power or not, 1 if yes 0 if no

/obj/item/wallframe/proc/try_build(turf/on_wall)
	if(get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(on_wall, usr)
	if(!(ndir in cardinal))
		return
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if(!istype(loc, /turf/simulated/floor))
		usr << "<span class='warning'>You cannot place [src] on this spot!</span>"
		return
	if(!powerless && A.requires_power == 0 || istype(A, /area/space))
		usr << "<span class='warning'>You cannot place [src] in this area!</span>"
		return
	if(gotwallitem(loc, ndir, inverse*2))
		usr << "<span class='warning'>There's already an item on this wall!</span>"
		return

	return 1

/obj/item/wallframe/proc/attach(turf/on_wall)
	var/obj/O
	if(result_path)
		playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
		usr.visible_message("[usr.name] attaches [src] to the wall.",
			"<span class='notice'>You attach [src] to the wall.</span>",
			"<span class='italics'>You hear clicking.</span>")
		var/ndir = get_dir(on_wall,usr)
		if(inverse)
			ndir = turn(ndir, 180)

		O = new result_path(get_turf(usr), ndir, 1)
		transfer_fingerprints_to(O)

	qdel(src)
	return O


/obj/item/wallframe/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/screwdriver))
		// For camera-building borgs
		var/turf/T = get_step(get_turf(user), user.dir)
		if(istype(T, /turf/simulated/wall))
			T.attackby(src, user, params)


	var/metal_amt = round(materials[MAT_METAL]/MINERAL_MATERIAL_AMOUNT)
	var/glass_amt = round(materials[MAT_GLASS]/MINERAL_MATERIAL_AMOUNT)

	if(istype(W, /obj/item/weapon/wrench) && (metal_amt || glass_amt))
		user << "<span class='notice'>You dismantle [src].</span>"
		if(metal_amt)
			new /obj/item/stack/sheet/metal(get_turf(src), metal_amt)
		if(glass_amt)
			new /obj/item/stack/sheet/glass(get_turf(src), glass_amt)
		qdel(src)



// APC HULL
/obj/item/wallframe/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs"
	icon_state = "apc_frame"
	result_path = /obj/machinery/power/apc
	inverse = 1


/obj/item/wallframe/apc/try_build(turf/on_wall)
	if(!..())
		return
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (A.get_apc())
		usr << "<span class='warning'>This area already has APC!</span>"
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			usr << "<span class='warning'>There is another network terminal here!</span>"
			return
		else
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(loc)
			C.amount = 10
			usr << "<span class='notice'>You cut the cables and disassemble the unused power terminal.</span>"
			qdel(T)
	return 1

// BUTTONS
/obj/item/wallframe/button
	name = "button frame"
	desc = "Used for building buttons."
	icon_state = "button_frame"
	result_path = /obj/machinery/button
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)

//FIRE EXTINGUISHER CABINET
/obj/item/wallframe/extinguishercabinet
	name = "extinguisher cabinet frame"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher. Apply on wall."
	icon_state = "extinguisher_frame"
	result_path = /obj/structure/extinguisher_cabinet/empty
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
	powerless = 1

//NEWSCASTER
/obj/item/wallframe/newscaster
	name = "newscaster frame"
	desc = "Used to build newscasters, just secure to the wall."
	icon_state = "newscaster"
	materials = list(MAT_METAL=14000, MAT_GLASS=8000)
	result_path = /obj/machinery/newscaster

/obj/item/weapon/electronics // why the fuck is this here...?i don't even
	desc = "Looks like a circuit. Probably is."
	icon = 'icons/obj/module.dmi'
	icon_state = "door_electronics"
	item_state = "electronic"
	flags = CONDUCT
	w_class = 2
	origin_tech = "engineering=2;programming=1"
	materials = list(MAT_METAL=50, MAT_GLASS=50)
