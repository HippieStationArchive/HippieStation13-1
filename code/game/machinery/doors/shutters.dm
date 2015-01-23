/obj/machinery/door/poddoor/shutters
	gender = PLURAL
	name = "shutters"
	desc = "Heavy duty metal shutters that open mechanically."
	icon = 'icons/obj/doors/shutters.dmi'
	layer = 3.1

/obj/machinery/door/poddoor/shutters/preopen
	icon_state = "open"
	density = 0
	opacity = 0


//shutters look like ass with things on top of them.

/obj/machinery/door/poddoor/shutters/New()
	..()
	layer = 3.1	//to handle /obj/machinery/door/New() resetting the layer.


/obj/machinery/door/poddoor/shutters/open(ignorepower = 0)
	..()
	layer = 3.1


/obj/machinery/door/poddoor/shutters/close(ignorepower = 0)
	..()
	layer = 3.1

/obj/machinery/door/poddoor/shutters_rubber
	gender = PLURAL
	name = "rubber shutters"
	desc = "Soft rubber shutters to prevent accidents."
	icon_state = "rubber_closed"
	preposition = "rubber_"

/obj/machinery/door/poddoor/shutters_rubber/preopen
	icon_state = "rubber_open"
	density = 0
	opacity = 0

/obj/machinery/door/poddoor/shutters_rubber/crush()
	for(var/mob/living/carbon/L in get_turf(src)) //Weaken instead of damage.
		L.Weaken(4)