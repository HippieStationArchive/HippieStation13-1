#define FILTER_NOTHING			""
//very cleverly using the gas IDs so as to simplify a bunch of logic
#define FILTER_PLASMA			"plasma"
#define FILTER_OXYGEN			"o2"
#define FILTER_NITROGEN			"n2"
#define FILTER_CARBONDIOXIDE	"co2"
#define FILTER_NITROUSOXIDE		"n2o"

/obj/machinery/atmospherics/components/trinary/filter
	icon_state = "filter_off"
	density = 0
	name = "gas filter"
	can_unwrench = 1
	var/on = 0
	var/target_pressure = ONE_ATMOSPHERE
	var/filter_type = FILTER_PLASMA
	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/components/trinary/filter/flipped
	icon_state = "filter_off_f"
	flipped = 1

/obj/machinery/atmospherics/components/trinary/filter/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/components/trinary/filter/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/components/trinary/filter/update_icon()
	overlays.Cut()
	for(var/direction in cardinal)
		if(direction & initialize_directions)
			var/obj/machinery/atmospherics/node = findConnecting(direction)
			if(node)
				overlays += getpipeimage('icons/obj/atmospherics/components/trinary_devices.dmi', "cap", direction, node.pipe_color)
				continue
			overlays += getpipeimage('icons/obj/atmospherics/components/trinary_devices.dmi', "cap", direction)
	..()

/obj/machinery/atmospherics/components/trinary/filter/update_icon_nopipes()

	if(!(stat & NOPOWER) && on && NODE1 && NODE2 && NODE3)
		icon_state = "filter_on[flipped?"_f":""]"
		return

	icon_state = "filter_off[flipped?"_f":""]"

/obj/machinery/atmospherics/components/trinary/filter/power_change()
	var/old_stat = stat
	..()
	if(stat & NOPOWER)
		on = 0
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/components/trinary/filter/process_atmos()
	..()
	if(!on)
		return 0
	if(!(NODE1 && NODE2 && NODE3))
		return 0

	var/datum/gas_mixture/air1 = AIR1
	var/datum/gas_mixture/air2 = AIR2
	var/datum/gas_mixture/air3 = AIR3

	var/output_starting_pressure = air3.return_pressure()

	if(output_starting_pressure >= target_pressure)
		//No need to mix if target is already full!
		return 1

	//Calculate necessary moles to transfer using PV=nRT

	var/pressure_delta = target_pressure - output_starting_pressure
	var/transfer_moles

	if(air1.temperature > 0)
		transfer_moles = pressure_delta*air3.volume/(air1.temperature * R_IDEAL_GAS_EQUATION)

	//Actually transfer the gas

	if(transfer_moles > 0)
		var/datum/gas_mixture/removed = air1.remove(transfer_moles)

		if(!removed)
			return
		var/datum/gas_mixture/filtered_out = new
		filtered_out.temperature = removed.temperature

		if(filter_type && removed.gases[filter_type])
			filtered_out.assert_gas(filter_type)
			filtered_out.gases[filter_type][MOLES] = removed.gases[filter_type][MOLES]
			removed.gases[filter_type][MOLES] = 0
			if(filter_type == FILTER_PLASMA && removed.gases["agent_b"])
				filtered_out.assert_gas("agent_b")
				filtered_out.gases["agent_b"][MOLES] = removed.gases["agent_b"][MOLES]
				removed.gases["agent_b"][MOLES] = 0
			removed.garbage_collect()
		else
			filtered_out = null

		air2.merge(filtered_out)
		air3.merge(removed)

	update_parents()

	return 1

/obj/machinery/atmospherics/components/trinary/filter/atmosinit()
	set_frequency(frequency)
	return ..()

/obj/machinery/atmospherics/components/trinary/filter/attack_hand(mob/user)
	if(!src.allowed(usr))
		usr << "<span class='danger'>Access denied.</span>"
		return
	..()

/obj/machinery/atmospherics/components/trinary/filter/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
																	datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_filter", name, 430, 140, master_ui, state)
		ui.open()

/obj/machinery/atmospherics/components/trinary/filter/get_ui_data()
	var/data = list()
	data["on"] = on
	data["set_pressure"] = round(target_pressure)
	data["max_pressure"] = round(MAX_OUTPUT_PRESSURE)
	data["filter_type"] = filter_type
	return data

/obj/machinery/atmospherics/components/trinary/filter/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("power")
			on = !on
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", "atmos")
		if("pressure")
			switch(params["pressure"])
				if("max")
					target_pressure = MAX_OUTPUT_PRESSURE
				if("custom")
					target_pressure = max(0, min(MAX_OUTPUT_PRESSURE, safe_input("Pressure control", "Enter new output pressure (0-[MAX_OUTPUT_PRESSURE] kPa):", target_pressure)))
			investigate_log("was set to [target_pressure] kPa by [key_name(usr)]", "atmos")
		if("filter")
			filter_type = params["mode"]
			var/filtering_name = "nothing"
			switch(filter_type)
				if(FILTER_PLASMA)
					filtering_name = "plasma"
				if(FILTER_OXYGEN)
					filtering_name = "oxygen"
				if(FILTER_NITROGEN)
					filtering_name = "nitrogen"
				if(FILTER_CARBONDIOXIDE)
					filtering_name = "carbon dioxide"
				if(FILTER_NITROUSOXIDE)
					filtering_name = "nitrous oxide"
			investigate_log("was set to filter [filtering_name] by [key_name(usr)]", "atmos")
	update_icon()
	return 1