#define EXT_BOUND	1
#define INT_BOUND	2
#define NO_BOUND	3

#define SIPHONING	0
#define RELEASING	1

/obj/machinery/atmospherics/components/unary/vent_pump
	icon_state = "vent_map"

	name = "air vent"
	desc = "Has a valve and pump attached to it"
	use_power = 1

	can_unwrench = 1

	welded = 0

	var/area/initial_loc
	level = 1
	var/area_uid
	var/id_tag = null

	var/on = 0
	var/pump_direction = RELEASING

	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0

	var/pressure_checks = EXT_BOUND
	//EXT_BOUND: Do not pass external_pressure_bound
	//INT_BOUND: Do not pass internal_pressure_bound
	//NO_BOUND: Do not pass either

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/radio_filter_out
	var/radio_filter_in

	var/cover = 0 //For hiding tiny objects in, 1 means cover is up, can hide.
	var/list/items = list() //Hidden items inside.

/obj/machinery/atmospherics/components/unary/vent_pump/on
	on = 1
	icon_state = "vent_out"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon
	pump_direction = SIPHONING

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/on
	on = 1
	icon_state = "vent_in"

/obj/machinery/atmospherics/components/unary/vent_pump/New()
	..()
	initial_loc = get_area(loc)
	if (initial_loc.master)
		initial_loc = initial_loc.master
	area_uid = initial_loc.uid
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/machinery/atmospherics/components/unary/vent_pump/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	radio_connection = null
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
		initial_loc = null
	return ..()

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume
	name = "large air vent"
	power_channel = EQUIP

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/New()
	..()
	var/datum/gas_mixture/air_contents = AIR1
	air_contents.volume = 1000

/obj/machinery/atmospherics/components/unary/vent_pump/update_icon_nopipes()
	overlays.Cut()
	if(showpipe)
		overlays += getpipeimage('icons/obj/atmospherics/components/unary_devices.dmi', "vent_cap", initialize_directions)

	if(welded)
		icon_state = "vent_welded"
		return

	if(!NODE1 || !on || stat & (NOPOWER|BROKEN))
		icon_state = "vent_off"
		return

	if(pump_direction & RELEASING)
		icon_state = "vent_out"
	else //pump_direction == SIPHONING
		icon_state = "vent_in"

/obj/machinery/atmospherics/components/unary/vent_pump/process_atmos()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if (!NODE1)
		on = 0
	//broadcast_status() // from now air alarm/control computer should request update purposely --rastaf0
	if(!on)
		return 0

	if(welded)
		return 0

	var/datum/gas_mixture/air_contents = AIR1
	var/datum/gas_mixture/environment = loc.return_air()
	var/environment_pressure = environment.return_pressure()

	if(pump_direction & RELEASING) //internal -> external
		var/pressure_delta = 10000

		if(pressure_checks&EXT_BOUND)
			pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
		if(pressure_checks&INT_BOUND)
			pressure_delta = min(pressure_delta, (air_contents.return_pressure() - internal_pressure_bound))

		if(pressure_delta > 0)
			if(air_contents.temperature > 0)
				var/transfer_moles = pressure_delta*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

				loc.assume_air(removed)
				air_update_turf()

	else //external -> internal
		var/pressure_delta = 10000
		if(pressure_checks&EXT_BOUND)
			pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
		if(pressure_checks&INT_BOUND)
			pressure_delta = min(pressure_delta, (internal_pressure_bound - air_contents.return_pressure()))

		if(pressure_delta > 0)
			if(environment.temperature > 0)
				var/transfer_moles = pressure_delta*air_contents.volume/(environment.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
				if (isnull(removed)) //in space
					return

				air_contents.merge(removed)
				air_update_turf()
	update_parents()

	return 1

//Radio remote control

/obj/machinery/atmospherics/components/unary/vent_pump/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency,radio_filter_in)

/obj/machinery/atmospherics/components/unary/vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"area" = src.area_uid,
		"tag" = src.id_tag,
		"device" = "AVP",
		"power" = on,
		"direction" = pump_direction?("release"):("siphon"),
		"checks" = pressure_checks,
		"internal" = internal_pressure_bound,
		"external" = external_pressure_bound,
		"timestamp" = world.time,
		"sigtype" = "status"
	)

	if(!initial_loc.air_vent_names[id_tag])
		var/new_name = "\improper [initial_loc.name] vent pump #[initial_loc.air_vent_names.len+1]"
		initial_loc.air_vent_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_vent_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1


/obj/machinery/atmospherics/components/unary/vent_pump/atmosinit()
	//some vents work his own spesial way
	radio_filter_in = frequency==1439?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==1439?(RADIO_TO_AIRALARM):null
	if(frequency)
		set_frequency(frequency)
	broadcast_status()
	..()

/obj/machinery/atmospherics/components/unary/vent_pump/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/components/unary/vent_pump/receive_signal([signal.debug_print()])")
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if("purge" in signal.data)
		pressure_checks &= ~EXT_BOUND
		pump_direction = SIPHONING

	if("stabalize" in signal.data)
		pressure_checks |= EXT_BOUND
		pump_direction = RELEASING

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("checks" in signal.data)
		pressure_checks = text2num(signal.data["checks"])

	if("checks_toggle" in signal.data)
		pressure_checks = (pressure_checks?0:NO_BOUND)

	if("direction" in signal.data)
		pump_direction = text2num(signal.data["direction"])

	if("set_internal_pressure" in signal.data)
		internal_pressure_bound = Clamp(
			text2num(signal.data["set_internal_pressure"]),
			0,
			ONE_ATMOSPHERE*50
		)

	if("set_external_pressure" in signal.data)
		external_pressure_bound = Clamp(
			text2num(signal.data["set_external_pressure"]),
			0,
			ONE_ATMOSPHERE*50
		)

	if("adjust_internal_pressure" in signal.data)
		internal_pressure_bound = Clamp(
			internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),
			0,
			ONE_ATMOSPHERE*50
		)

	if("adjust_external_pressure" in signal.data)
		external_pressure_bound = Clamp(
			external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),
			0,
			ONE_ATMOSPHERE*50
		)

	if("init" in signal.data)
		name = signal.data["init"]
		return

	if("status" in signal.data)
		spawn(2)
			broadcast_status()
		return //do not update_icon

		//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/components/unary/vent_pump/attackby(obj/item/W, mob/user, params)
	if (istype(W, /obj/item/weapon/wrench)&& !(stat & NOPOWER) && on)
		user << "<span class='warning'>You cannot unwrench this [src], turn it off first!</span>"
		return 1
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			playsound(loc, 'sound/items/Welder.ogg', 40, 1)
			user << "<span class='notice'>You begin welding the vent...</span>"
			if(do_after(user, 20/W.toolspeed, target = src))
				if(!src || !WT.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				if(!welded)
					user.visible_message("[user] welds the vent shut.", "<span class='notice'>You weld the vent shut.</span>", "<span class='italics'>You hear welding.</span>")
					welded = 1
				else
					user.visible_message("[user] unwelds the vent.", "<span class='notice'>You unweld the vent.</span>", "<span class='italics'>You hear welding.</span>")
					welded = 0
				update_icon()
				pipe_vision_img = image(src, loc, layer = 20, dir = dir)
			return 1
	if(istype(W, /obj/item/weapon/crowbar))
		// var/obj/item/weapon/crowbar/C = W
		playsound(loc, 'sound/items/Crowbar.ogg', 40, -2)
		cover = !cover
		user << "<span class='notice'>You pry [cover ? "off" : "in"] the vent cover.</span>"
		return 1
	if(cover)
		if(W.w_class <= 1 && !(locate(/obj/item) in items)) //Can hide small shit like ID's and emags in vents
			user << "<span class='notice'>You insert \the [W] inside \the [src]!</span>"
			user.drop_item()
			items += W
			W.loc = src
		else
			user << "<span class='notice'>You cannot seem to fit \the [W]!</span>"
		return 1
	else
		return ..()

/obj/machinery/atmospherics/components/unary/vent_pump/attack_hand(mob/user)
	if(cover)
		var/obj/item/I = locate() in items
		if(istype(I))
			user << "<span class='notice'>You take \the [I] out of [src]!</span>"
			user.put_in_hands(I)
			items -= I
		else
			user << "<span class='notice'>You can't find anything in \the [src]!</span>"
		return
	else
		..()

/obj/machinery/atmospherics/components/unary/vent_pump/examine(mob/user)
	..()
	if(welded)
		user << "It seems welded shut."
	if(cover)
		user << "It's cover is open."

/obj/machinery/atmospherics/components/unary/vent_pump/power_change()
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	update_icon_nopipes()

/obj/machinery/atmospherics/components/unary/vent_pump/Destroy()
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	..()


/obj/machinery/atmospherics/components/unary/vent_pump/can_crawl_through()
	return !welded

#undef INT_BOUND
#undef EXT_BOUND
#undef NO_BOUND

#undef SIPHONING
#undef RELEASING