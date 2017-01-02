/obj/machinery/door/poddoor
	name = "blast door"
	desc = "A heavy duty blast door that opens mechanically."
	icon = 'icons/obj/doors/blastdoor.dmi'
	icon_state = "closed"
	var/id = 1
	var/auto_close = 0 // Time in seconds to automatically close when opened, 0 if it doesn't.
	sub_door = 1
	explosion_block = 3
	heat_proof = 1
	var/sound_open = 'sound/machines/blast_door.ogg'
	var/sound_close = 'sound/machines/blast_door.ogg'

/obj/machinery/door/poddoor/preopen
	icon_state = "open"
	density = 0
	opacity = 0

/obj/machinery/door/poddoor/ert
	desc = "A heavy duty blast door that only opens for dire emergencies."

/obj/machinery/door/poddoor/Bumped(atom/AM)
	if(density)
		return 0
	else
		return ..()


/obj/machinery/door/poddoor/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)

	if(istype(I, /obj/item/weapon/twohanded/fireaxe))
		var/obj/item/weapon/twohanded/fireaxe/F = I
		if(!F.wielded)
			return
	else if(!istype(I, /obj/item/weapon/crowbar))
		return

	if(stat & NOPOWER)
		open(1)	//ignore the usual power requirement.

/obj/machinery/door/poddoor/attack_animal(mob/living/simple_animal/M)
	if(!istype(M)) return
	if(!M.can_force_doors) return
	if(!density) return //Not even an obstacle, don't bother
	var/delay = 50 + (!(stat & NOPOWER) * 550) //60 seconds (a whole minute) for powered-up blastdoor. This makes Bridge the safest place from Zombies.
	M.visible_message("<span class='danger'>[M] is trying to force open \the [src]!</span>",
					"<span class='warning'>You try to force open \the [src] (This is going to take [delay/10] seconds).</span>")
	if(do_after(M, delay, target = src))
		M.visible_message("<span class='danger'>[M] forces open \the [src]!</span>",
						"<span class='warning'>You force open \the [src]!</span>")
		open(1)

/obj/machinery/door/poddoor/open(ignorepower = 0)
	if(operating)
		return
	if(!density)
		return
	if(!ignorepower && (stat & NOPOWER))
		return

	operating = 1
	flick("opening", src)
	icon_state = "open"
	playsound(src.loc, sound_open, 100, 1)
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


/obj/machinery/door/poddoor/close(ignorepower = 0)
	if(operating)
		return
	if(density)
		return
	if(!ignorepower && (stat & NOPOWER))
		return

	operating = 1
	flick("closing", src)
	icon_state = "closed"
	playsound(src.loc, sound_close, 100, 1)
	SetOpacity(1)
	sleep(5)
	density = 1
	// sleep(5)
	air_update_turf(1)
	update_freelook_sight()
	// sleep(5)
	crush()
	sleep(5)
	operating = 0


//"BLAST" doors are obviously stronger than regular doors when it comes to BLASTS.
/obj/machinery/door/poddoor/ex_act(severity, target)
	switch(severity)
		if(1)
			if(prob(80))
				qdel(src)
			else
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(2, 1, src)
				s.start()
		if(2)
			if(prob(20))
				qdel(src)
			else
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(2, 1, src)
				s.start()

		if(3)
			if(prob(80))
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(2, 1, src)
				s.start()

