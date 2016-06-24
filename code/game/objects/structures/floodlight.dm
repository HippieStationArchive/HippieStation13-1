/obj/machinery/power/floodlight
	name = "floodlight"
	icon = 'icons/obj/floodlight.dmi'
	icon_state = "floodlight0_hatchopen0"
	desc = "An industrial floodlight. It has units of power remaining."
	density = 1
	anchored = 0
	var/status = 0
	var/obj/item/weapon/stock_parts/cell/powerpack
	var/datum/effect_system/spark_spread/sparks = new
	var/health = 60
	var/maxhealth = 60
	var/broken = 0
	var/cover = 0
	var/hascell = 0
	var/brightness_on = 6
	var/rigged = 0
	var/wiredtoground = 0
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 40
	req_access = list(access_engine_equip)
	var/locked = 0

/obj/machinery/power/floodlight/New()
	sparks.set_up(2, 0, src)
	sparks.attach(src)
	powerpack = null
	turnoff()
	update_health()
	desc = "An industrial floodlight. It has no power source installed!"
	SSobj.processing |= src
	..()

/obj/machinery/power/floodlight/Destroy()
	qdel(sparks)
	sparks = null
	SSobj.processing.Remove(src)
	return ..()

/obj/machinery/power/floodlight/process()
	if(broken)
		return
	if(powerpack == null)
		hascell = 0
	if(status == 0)
		desc = "An industrial floodlight. Its off."
		return
	if(wiredtoground == 1)
		if(surplus() < 40 && hascell == 0)
			turnoff()
			desc = "An industrial floodlight. It's wired to the grid however the power is out! It has no power source!"
			hascell = 0
			return
		else if(surplus() < 40 && hascell == 1)
			powerpack.use(2)
			desc = "An industrial floodlight. Its connected to the grid, but is running on backup power due to grid failure! It has [powerpack.charge] units of power remaining."
			if(powerpack.charge <= 0)
				desc = "An industrial floodlight. Its connected to the grid, but is running on backup power due to grid failure! The cell is empty."
				turnoff()
				return
			return
		if(hascell == 0)
			desc = "An industrial floodlight. It's wired to the grid and has no internal power source!"
		else
			powerpack.give(2)
			desc = "An industrial floodlight. It's wired to the grid and has an internal power source(Charging: [powerpack.charge])!"
		return
	if(hascell == 0)
		desc = "An industrial floodlight. It has no power source installed!"
		turnoff()
		return
	if(status == 1)
		powerpack.use(2)
		desc = "An industrial floodlight. It has [powerpack.charge] units of power remaining."
		if(powerpack.charge <= 0)
			desc = "An industrial floodlight. The cell is empty."
			turnoff()
			return


/obj/machinery/power/floodlight/attackby(obj/item/I, mob/user)
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

	if(istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/device/pda))
		if(src.allowed(user) && cover != 0)
			src.locked = !src.locked
			user << "<span class='notice'>You [src.locked ? "lock" : "unlock"] the controls.</span>"
		else
			if(cover == 0)
				user << "Close the cover first!"
			else
				user << "<span class='danger'>Access denied.</span>"
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

		if(locked)

		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_mob(user,	src, 20))
			if(anchored == 1)
				if(!connect_to_network())
					user << "You undo the ground bolts, freeing the [src]."
					anchored = 0
					return
				user << "You undo the ground bolts, freeing the [src]. It is no longer connected to the powernet."
				anchored = 0
				wiredtoground = 0
				return
			else
				if(connect_to_network())
					user << "You tighiten the ground bolts, bolting down the [src]. It has been connected to the powernet."
					anchored = 1
					wiredtoground = 1
					return
				user << "You tighiten the ground bolts, bolting down the [src]."
				anchored = 1
			return
		return

	if(istype(I, /obj/item/weapon/screwdriver))
		if(locked == 1)
			user << "The controls are locked!" //to prevent easy kills
			return
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

	if(istype(I, /obj/item/weapon/card/emag))
		message_admins("[user] emagged the floodlight at [src.loc]!")
		playsound(loc, 'sound/effects/sparks1.ogg', 50, 1)
		user << "<span class='danger'>You rig the floodlight to blow next time it is used!</span>"
		rigged = 1

	if(istype(I, /obj/item/weapon/crowbar))
		if(cover == 0)
			if(hascell == 1)
				user << "Remove the cell first before deconstructing."
			else
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "You begin deconstructing the [src]!"
				if(do_mob(user, src, 40))
					var/obj/item/stack/sheet/metal/S = new
					S.amount = 15
					S.loc = user.loc
					qdel(src)
					return
		return

	if(I.force > 3)
		user.visible_message("<span class='danger'>[user] hits the light with the [I]!</span>")
		health = health - I.force
		playsound(loc, 'sound/weapons/smash.ogg', 50, 1)
		update_health()


/obj/machinery/power/floodlight/attack_hand(mob/user)
	if(broken)
		user << "Its broken!"
		return
	if(locked)
		user << "The controls are locked!"
		return
	if(wiredtoground == 1 && surplus() < 40 && hascell == 0)
		user << "There is no power in the connected powernet and no internal power source!"
		turnoff()
		return
	if(cover == 0)
		if(powerpack == null)
			return
		powerpack.loc = get_turf(user)
		powerpack = null
		hascell = 0
		if(wiredtoground == 0)
			turnoff()
		icon_state = "floodlight[status]_hatchopen[hascell]"
		user << "You remove the cell from the [src]"
		return
	else
		if(status == 1)
			turnoff()
			user << "You turn the [src] off."
			playsound(loc, 'sound/machines/lightswitch.ogg', 30, 1, -3)
			icon_state = "floodlight[status]_hatchclose"
		else
			if(wiredtoground == 0)
				if(powerpack != null)
					if(powerpack.charge <= 0)
						user << "The [src] has no power!"
						return
				else
					user << "The [src] has no power source installed!"
					return
			else
				if(surplus() < 40 && hascell == 1)
					if(powerpack.charge <= 0)
						user << "The powernet is empty and the power source is drained!"
						return
				if(surplus() < 40 && hascell == 0)
					user << "The powernet is empty and the power source is drained!"
					return

			user << "You turn the [src] on."
			playsound(loc, 'sound/machines/lightswitch.ogg', 30, 1, -3)
			turnon()
			icon_state = "floodlight[status]_hatchclose"
			return
	if(cover == 0 && hascell == 0)
		user << "The maintenance hatch is open!"
		return

/obj/machinery/power/floodlight/proc/turnoff()
	if(rigged)
		src.visible_message("<span class='userdanger'>The [src] overloads and explodes! Emitting a blinding light!</span>")
		for(var/mob/living/carbon/M in range(8, src.loc))
			M.visible_message("<span class='disarm'><b>[M]</b> screams and collapses!</span>")
			M << "<span class='userdanger'><font size=3>AAAAGH!</font></span>"
			M.Weaken(7) //hella stunned
			M.Stun(7)
			M.eye_stat += 8
		for(var/mob/living/carbon/X in range(3, src.loc))
			X.IgniteMob()
		explosion(src.loc, -1, 0, 2, 4, 0, flame_range = 4)
		qdel(src)
		return
	if(broken)
		return
	status = 0
	if(cover == 1)
		icon_state = "floodlight[status]_hatchclose"
	else
		icon_state = "floodlight[status]_hatchopen[hascell]"
	SetLuminosity(0)

/obj/machinery/power/floodlight/proc/turnon()
	if(rigged)
		src.visible_message("<span class='userdanger'>The [src] overloads and explodes! Emitting a blinding light!</span>")
		for(var/mob/living/carbon/M in range(8, src.loc))
			M.visible_message("<span class='disarm'><b>[M]</b> screams and collapses!</span>")
			M << "<span class='userdanger'><font size=3>AAAAGH!</font></span>"
			M.Weaken(7) //hella stunned
			M.Stun(7)
			M.eye_stat += 8
		for(var/mob/living/carbon/X in range(3, src.loc))
			X.IgniteMob()
		explosion(src.loc, -1, 0, 2, 4, 0, flame_range = 4)
		qdel(src)
		return
	status = 1
	SetLuminosity(brightness_on)

/obj/machinery/power/floodlight/proc/update_health()
	if(health <= 0)
		turnoff()
		sparks.start()
		health = 0
		broken = 1
		locked = 0
		icon_state = "floodlight3"
		desc = "An industrial floodlight. She's dead Jim."
	if(health == maxhealth)
		broken = 0
		turnoff()

/obj/machinery/power/floodlight/emp_act()
	health = 0
	update_health()
	if(powerpack != null)
		powerpack.charge = powerpack.charge - 500

