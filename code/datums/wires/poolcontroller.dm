/datum/wires/poolcontroller
	holder_type = /obj/machinery/poolcontroller
	randomize = TRUE

/datum/wires/poolcontroller/New()
	wires = list(
			WIRE_POOLDRAIN,
			WIRE_SAFETY,
			WIRE_SHOCK)
	..()

/datum/wires/poolcontroller/interactable(mob/user)
	var/obj/machinery/poolcontroller/P = holder
	if(!istype(L, /mob/living/silicon))
		if(P.seconds_electrified)
			if(P.shock(L, 100))
				return FALSE
	if(P.panel_open)
		return TRUE
	return FALSE

/datum/wires/poolcontroller/get_status()
	var/obj/machinery/poolcontroller/P = holder
	var/list/status = list()
	status += "<BR>The orange light is [P.drainable ? "blinking" : "off"].<BR>"
	status += "The blue light is [P.emagged ? "flashing" : "off"].<BR>"
	status += "The red light is [P.seconds_electrified ? "on" : "off"].<BR>"
	return status

/datum/wires/poolcontroller/on_pulsed(wire)
	var/obj/machinery/poolcontroller/P = holder
	switch(wire)
		if(WIRE_POOLDRAIN)
			P.drainable = 0
		if(WIRE_SAFETY)
			if(P.emagged)
				P.emagged = 0
			if(!P.emagged)
				P.emagged = 1
		if(WIRE_SHOCK)
			P.seconds_electrified = 30


/datum/wires/poolcontroller/on_cut(wire, mend)
	var/obj/machinery/poolcontroller/P = holder
	switch(wire)
		if(WIRE_POOLDRAIN)
			if(mend)
				P.drainable = 0
			else
				P.drainable = 1
		if(WIRE_SAFETY)
			if(mend)
				P.emagged = 0
		if(WIRE_SHOCK)
			if(mend)
				P.seconds_electrified = 0
			else
				P.seconds_electrified = -1
