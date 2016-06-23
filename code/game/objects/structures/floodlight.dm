/obj/machinery/floodlight
	name = "floodlight"
	icon = 'icons/obj/floodlight.dmi'
	icon_state = "floodlight0_hatchclose"
	desc = "An industrial floodlight. It has units of power remaining."
	density = 1
	anchored = 0
	var/status = 0
	var/obj/item/weapon/stock_parts/cell/powerpack
	var/datum/effect_system/spark_spread/sparks = new
	var/health = 60
	var/maxhealth = 60
	var/broken = 0
	var/cover = 1
	var/hascell = 1
	var/brightness_on = 10

/obj/machinery/floodlight/construct
	icon_state = "floodlight0_hatchopen0"
	desc = "An industrial floodlight. It has no power source installed!."
	cover = 0
	hascell = 0
	brightness_on = 10

/obj/machinery/floodlight/New()
	sparks.set_up(2, 0, src)
	sparks.attach(src)
	powerpack = new /obj/item/weapon/stock_parts/cell/crap(src)
	desc = "An industrial floodlight. It has [powerpack.charge] units of power remaining."
	SSobj.processing |= src
	..()

/obj/machinery/floodlight/construct/New()
	sparks.set_up(2, 0, src)
	sparks.attach(src)
	powerpack = null
	desc = "An industrial floodlight. It has [powerpack.charge] units of power remaining."
	SSobj.processing |= src
	..()

/obj/machinery/floodlight/Destroy()
	qdel(sparks)
	sparks = null
	SSobj.processing.Remove(src)
	return ..()

/obj/machinery/floodlight/process()
	if(broken)
		return
	if(powerpack == null)
		desc = "An industrial floodlight. It has no power source installed!"
		turnoff()
		return
	if(status == 1)
		powerpack.use(2)
		desc = "An industrial floodlight. It has [powerpack.charge] units of power remaining."
		if(powerpack.charge <= 0)
			desc = "An industrial floodlight. It has [powerpack.charge] units of power remaining."
			turnoff()
			return


/obj/machinery/floodlight/attackby(obj/item/I, mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(I,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/X = I
		if(X.welding != 1)
			user << "You know, it needs to be on to work."
			return
		if(health == maxhealth)
			user << "It does not need repairs!"
			return
		if(do_mob(user, src, 20))
			playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
			X.remove_fuel(1, user)
			health = maxhealth
			update_health()
		return
	if(broken)
		user << "Its broken!"
		return
	if(istype(I, /obj/item/weapon/stock_parts/cell))
		if(powerpack == null)
			user << "<span class='notice'>You install [I] into [src]</span>"
			user.drop_item()
			powerpack = I
			I.forceMove(src)
			hascell = 1
			icon_state = "floodlight[status]_hatchopen[hascell]"
			desc = "An industrial floodlight. It has [powerpack.charge] units of power remaining."
		else
			user << "<span class='notice'>There is already a cell in the [src]!</span>"
		return
	if(istype(I, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_mob(user,	src, 20))
			if(anchored == 1)
				user << "You undo the ground bolts, freeing the [src]."
				anchored = 0
			else
				user << "You tighiten the ground bolts, bolting down the [src]."
				anchored = 1
			return
	if(istype(I, /obj/item/weapon/screwdriver))
		if(cover == 1)
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "You open the maintenance hatch."
			icon_state = "floodlight[status]_hatchopen[hascell]"
			cover = 0
		else
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "You close the maintenance hatch."
			icon_state = "floodlight[status]_hatchclose"
			cover = 1
		return

	if(I.force > 3)
		health = health - I.force
		playsound(loc, 'sound/weapons/smash.ogg', 50, 1)
		update_health()


/obj/machinery/floodlight/attack_hand(mob/user)
	if(broken)
		user << "Its broken!"
		return
	if(cover == 0)
		if(powerpack == null)
			return
		powerpack.loc = get_turf(user)
		powerpack = null
		hascell = 0
		turnoff()
		icon_state = "floodlight[status]_hatchopen[hascell]"
	else
		if(status == 1)
			turnoff()
			user << "You turn the [src] off."
			playsound(loc, 'sound/machines/lightswitch.ogg', 30, 1, -3)
			icon_state = "floodlight[status]_hatchclose"
		else
			if(powerpack != null)
				if(powerpack.charge <= 0)
					user << "The [src] has no power!"
					return
			else
				user << "The [src] has no power source installed!"
				return
			user << "You turn the [src] on."
			playsound(loc, 'sound/machines/lightswitch.ogg', 30, 1, -3)
			turnon()
			icon_state = "floodlight[status]_hatchclose"

/obj/machinery/floodlight/proc/turnoff()
	if(broken)
		return
	status = 0
	if(cover == 1)
		icon_state = "floodlight[status]_hatchclose"
	else
		icon_state = "floodlight[status]_hatchopen[hascell]"
	SetLuminosity(0)

/obj/machinery/floodlight/proc/turnon()
	status = 1
	SetLuminosity(brightness_on)

/obj/machinery/floodlight/proc/update_health()
	if(health <= 0)
		turnoff()
		sparks.start()
		health = 0
		broken = 1
		icon_state = "floodlight3"
		desc = "An industrial floodlight. She's dead Jim."
	if(health == maxhealth)
		broken = 0
		turnoff()
