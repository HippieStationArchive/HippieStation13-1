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
	var/brightness_on = 8
	var/rigged = 0
	var/wiredtoground = 0
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 40
	req_access = list(access_engine_equip)
	var/locked = 0
	var/charge = 0
	var/rawcharge = 0

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
	if(status == 0)
		desc = "An industrial floodlight. It's off."
		return
	if(powerpack)
		rawcharge = (powerpack.charge/powerpack.maxcharge * 100)
		charge = round(rawcharge, 0.1)
	if(wiredtoground == 1)
		if(surplus() < 40 && !powerpack)
			turnoff()
			desc = "An industrial floodlight. It's wired to the grid however the power is out! It has no power source!"
			return
		else if(surplus() < 40 && powerpack)
			powerpack.use(2)
			desc = "An industrial floodlight. It's connected to the grid, but is running on backup power due to grid failure! It has [charge]% charge remaining."
			if(powerpack.charge <= 0)
				desc = "An industrial floodlight. It's connected to the grid, but is running on backup power due to grid failure! The cell is empty."
				turnoff()
				return
			return
		if(!powerpack)
			desc = "An industrial floodlight. It's wired to the grid and has no internal power source!"
		else
			powerpack.give(2)
			desc = "An industrial floodlight. It's wired to the grid and has an internal power source(Charging: [charge]%)!"
		return
	if(!powerpack)
		desc = "An industrial floodlight. It has no power source installed!"
		turnoff()
		return
	if(status == 1)
		powerpack.use(2)
		desc = "An industrial floodlight. It has [charge]% charge remaining."
		if(powerpack.charge <= 0)
			desc = "An industrial floodlight. The cell is empty."
			turnoff()
			return


/obj/machinery/power/floodlight/attackby(obj/item/I, mob/user)
	user.changeNext_move(CLICK_CD_MELEE)

	if(istype(I,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/X = I
		if(X.welding != 1)
			user << "<span class='danger'>You know, it needs to be on to work.</span>"
			return
		if(health == maxhealth)
			user << "<span class='danger'>It does not need repairs!</span>"
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
		if(src.allowed(user) && cover != 0 && rigged == 0)
			src.locked = !src.locked
			user << "<span class='notice'>You [src.locked ? "lock" : "unlock"] the controls.</span>"
		else
			if(cover == 0)
				user << "<span class='danger'>Close the cover first!</span>"
			else if(rigged == 1)
				user << "<span class='danger'>The controls are broken!</span>"
			else
				user << "<span class='danger'>Access denied.</span>"
		return

	if(istype(I, /obj/item/weapon/stock_parts/cell))
		if(powerpack == null)
			user << "<span class='notice'>You install [I] into [src]</span>"
			user.drop_item()
			powerpack = I
			I.forceMove(src)
			icon_state = "floodlight[status]_hatchopen[(powerpack ? 1 : 0)]"
			desc = "An industrial floodlight. It has [charge]% charge remaining."
		else
			user << "<span class='notice'>There is already a cell in the [src]!</span>"
		return

	if(istype(I, /obj/item/weapon/wrench))

		if(locked)
			user << "<span class='danger'>The bolts are locked, unlock it first!</span>"
			return

		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_mob(user,	src, 20))
			if(anchored == 1)
				if(!connect_to_network())
					user << "<span class='notice'>You undo the ground bolts, freeing the [src].</span>"
					anchored = 0
					return
				user << "<span class='notice'>You undo the ground bolts, freeing the [src]. It is no longer connected to the powernet.</span>"
				anchored = 0
				wiredtoground = 0
				disconnect_from_network()
				return
			else
				if(connect_to_network())
					user << "<span class='notice'>You tighiten the ground bolts, bolting down the [src]. It has been connected to the powernet.</span>"
					anchored = 1
					wiredtoground = 1
					return
				user << "<span class='notice'>You tighiten the ground bolts, bolting down the [src].</span>"
				anchored = 1
			return
		return

	if(istype(I, /obj/item/weapon/screwdriver))
		if(locked == 1)
			user << "<span class='danger'>The controls are locked!</span>" //to prevent easy kills
			return
		if(cover == 1)
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "<span class='notice'>You open the maintenance hatch.</span>"
			icon_state = "floodlight[status]_hatchopen[(powerpack ? 1 : 0)]"
			cover = 0
		else
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "<span class='notice'>You close the maintenance hatch.</span>"
			icon_state = "floodlight[status]_hatchclose"
			cover = 1
		return

	if(istype(I, /obj/item/weapon/card/emag))
		message_admins("[user.ckey]([user]) emagged the floodlight at [src.loc]!")
		playsound(loc, 'sound/effects/sparks1.ogg', 50, 1)
		user << "<span class='danger'>You rig the floodlight to blow next time it is used!</span>"
		locked = 0
		rigged = 1

	if(istype(I, /obj/item/weapon/crowbar))
		if(cover == 0)
			if(powerpack)
				user << "<span class='danger'>Remove the cell first before deconstructing!</span>"
			else
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You begin deconstructing the [src]!</span>"
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
		user << "<span class='danger'>Its broken!</span>"
		return
	if(locked)
		user << "<span class='danger'>The controls are locked!</span>"
		return
	if(wiredtoground == 1 && surplus() < 40 && !powerpack)
		user << "<span class='danger'>There is no power in the connected powernet and no internal power source!</span>"
		turnoff()
		return
	if(cover == 0)
		if(powerpack == null)
			return
		powerpack.loc = get_turf(user)
		powerpack = null
		if(wiredtoground == 0)
			turnoff()
		icon_state = "floodlight[status]_hatchopen[(powerpack ? 1 : 0)]"
		user << "<span class='notice'>You remove the cell from the [src]</span>"
		return
	else
		if(status == 1)
			turnoff()
			user << "<span class='notice'>You turn the [src] off.</span>"
			playsound(loc, 'sound/machines/lightswitch.ogg', 30, 1, -3)
			icon_state = "floodlight[status]_hatchclose"
		else
			if(wiredtoground == 0)
				if(powerpack != null)
					if(powerpack.charge <= 0)
						user << "<span class='danger'>The [src] has no power!</span>"
						return
				else
					user << "<span class='danger'>The [src] has no power source installed!</span>"
					return
			else
				if(surplus() < 40 && powerpack)
					if(powerpack.charge <= 0)
						user << "<span class='danger'>The powernet is empty and the power source is drained!</span>"
						return
				if(surplus() < 40 && !powerpack)
					user << "<span class='danger'>The powernet is empty and there is no power source!</span>"
					return

			user << "<span class='notice'>You turn the [src] on.</span>"
			playsound(loc, 'sound/machines/lightswitch.ogg', 30, 1, -3)
			turnon()
			icon_state = "floodlight[status]_hatchclose"
			return
	if(cover == 0 && !powerpack)
		user << "<span class='danger'>The maintenance hatch is open!</span>"
		return

/obj/machinery/power/floodlight/proc/turnoff()
	if(rigged)
		src.visible_message("<span class='userdanger'>The [src] overloads and explodes! Emitting a blinding light!</span>")
		for(var/mob/living/carbon/M in range(8, src.loc))
			M.visible_message("<span class='disarm'><b>[M]</b> screams and collapses!</span>")
			M << "<span class='userdanger'><font size=3>AAAAGH!</font></span>"
			M.Weaken(4)
			M.Stun(4)
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
		icon_state = "floodlight[status]_hatchopen[(powerpack ? 1 : 0)]"
	SetLuminosity(0)

/obj/machinery/power/floodlight/proc/turnon()
	if(rigged)
		src.visible_message("<span class='userdanger'>The [src] overloads and explodes! Emitting a blinding light!</span>")
		for(var/mob/living/carbon/M in range(8, src.loc))
			M.visible_message("<span class='disarm'><b>[M]</b> screams and collapses!</span>")
			M << "<span class='userdanger'><font size=3>AAAAGH!</font></span>"
			M.Weaken(4)
			M.Stun(4)
			M.eye_stat += 8
		for(var/mob/living/carbon/X in range(3, src.loc))
			X.IgniteMob()
		explosion(src.loc, -1, 0, 2, 4, 0, flame_range = 4)
		qdel(src)
		return
	status = 1
	if(cover == 1)
		icon_state = "floodlight[status]_hatchclose"
	else
		icon_state = "floodlight[status]_hatchopen[(powerpack ? 1 : 0)]"
	SetLuminosity(brightness_on)

/obj/machinery/power/floodlight/proc/update_health()
	if(health <= 0)
		turnoff()
		sparks.start()
		health = 0
		broken = 1
		anchored = 0
		disconnect_from_network()
		locked = 0
		icon_state = "floodlight3"
		desc = "An industrial floodlight. She's dead Jim."
		wiredtoground = 0
	if(health == maxhealth)
		broken = 0
		turnoff()

/obj/machinery/power/floodlight/emp_act()
	health = 0
	update_health()
	if(powerpack != null)
		powerpack.charge = powerpack.charge - 500

