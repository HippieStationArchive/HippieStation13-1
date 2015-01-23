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
	icon = 'icons/obj/doors/shutters.dmi'
	icon_state = "rubber_closed"

/obj/machinery/door/poddoor/shutters_rubber/preopen
	icon_state = "rubber_open"
	density = 0
	opacity = 0

/obj/machinery/door/poddoor/shutters_rubber/crush()
	for(var/mob/living/carbon/L in get_turf(src)) //Weaken instead of damage.
		L.Weaken(4)

//Due to the absolute ass that is poddoor/shutters code I'll have to copy paste a bunch of shit.

/obj/machinery/door/poddoor/shutters_rubber/New()
	..()
	layer = 3.1	//to handle /obj/machinery/door/New() resetting the layer.


/obj/machinery/door/poddoor/shutters_rubber/open(ignorepower = 0)
	..()
	layer = 3.1


/obj/machinery/door/poddoor/shutters_rubber/close(ignorepower = 0)
	..()
	layer = 3.1

/obj/machinery/door/poddoor/shutters_rubber/open(ignorepower = 0)
	if(operating)
		return
	if(!density)
		return
	if(!ignorepower && (stat & NOPOWER))
		return

	operating = 1
	flick("rubber_opening", src)
	icon_state = "rubber_open"
	playsound(src.loc, 'sound/machines/blast_door.ogg', 100, 1)
	SetOpacity(0)
	sleep(5)
	density = 0
	sleep(5)
	air_update_turf(1)
	update_freelook_sight()
	operating = 0

	if(auto_close)
		spawn(auto_close)
			// Checks for being able to close are in close().
			close()

	return 1


/obj/machinery/door/poddoor/shutters_rubber/close(ignorepower = 0)
	if(operating)
		return
	if(density)
		return
	if(!ignorepower && (stat & NOPOWER))
		return

	operating = 1
	flick("rubber_closing", src)
	icon_state = "rubber_closed"
	SetOpacity(1)
	air_update_turf(1)
	update_freelook_sight()
	sleep(5)
	playsound(src.loc, 'sound/machines/blast_door.ogg', 100, 1)
	crush()
	density = 1
	sleep(5)

	operating = 0