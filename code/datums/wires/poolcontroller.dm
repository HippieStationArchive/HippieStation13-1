/datum/wires/poolcontroller
	random = 4
	holder_type = /obj/machinery/poolcontroller
	wire_count = 4

var/const/POOL_WIRE_DRAIN = 1
var/const/POOL_WIRE_EMAG = 2
var/const/POOL_WIRE_ELECTRIFY = 4

/datum/wires/poolcontroller/CanUse(var/mob/living/L)
	var/obj/machinery/poolcontroller/P = holder
	if(!istype(L, /mob/living/silicon))
		if(P.seconds_electrified)
			if(P.shock(L, 100))
				return 0
	if(P.panel_open)
		return 1
	return 0

/datum/wires/poolcontroller/Interact(var/mob/living/user)
	if(CanUse(user))
		var/obj/machinery/poolcontroller/P = holder
		P.attack_hand(user)

/datum/wires/poolcontroller/GetInteractWindow()
	var/obj/machinery/poolcontroller/P = holder
	. += ..()
	. += "<BR>The orange light is [P.drainable ? "blinking" : "off"].<BR>"
	. += "The blue light is [P.emagged ? "flashing" : "off"].<BR>"
	. += "The red light is [P.seconds_electrified ? "on" : "off"].<BR>"

/datum/wires/poolcontroller/UpdatePulsed(var/index)
	var/obj/machinery/poolcontroller/P = holder
	switch(index)
		if(POOL_WIRE_DRAIN)
			P.drainable = 0
		if(POOL_WIRE_EMAG)
			if(P.emagged)
				P.emagged = 0
			if(!P.emagged)
				P.emagged = 1
		if(POOL_WIRE_ELECTRIFY)
			P.seconds_electrified = 30


/datum/wires/poolcontroller/UpdateCut(var/index, var/mended)
	var/obj/machinery/poolcontroller/P = holder
	switch(index)
		if(POOL_WIRE_DRAIN)
			if(mended)
				P.drainable = 0
			else
				P.drainable = 1
		if(POOL_WIRE_EMAG)
			if(mended)
				P.emagged = 0
		if(POOL_WIRE_ELECTRIFY)
			if(mended)
				P.seconds_electrified = 0
			else
				P.seconds_electrified = -1