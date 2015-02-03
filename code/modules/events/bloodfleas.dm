/datum/round_event_control/bloodflea_invasion
	name = "Bloodflea Invasion"
	typepath = /datum/round_event/bloodflea_invasion
	weight = 10
	earliest_start = 6000
	max_occurrences = 20

/datum/round_event/bloodflea_invasion
	announceWhen = 60
	startWhen = 50

	var/fleas = 3
	var/spawncount = 6

/datum/round_event/bloodflea_invasion/setup()
	startWhen = rand(40, 60)
	spawncount = rand(2, 6)

/datum/round_event/bloodflea_invasion/announce()
	priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg')

/datum/round_event/bloodflea_invasion/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			// if(temp_vent.parent.other_atmosmch.len > 20)	//Stops fleas getting stuck in small networks. See: Security, Virology
			vents += temp_vent

	while(spawncount > 0 && vents.len)
		var/obj/vent = pick_n_take(vents)
		fleas = rand(1, 6) //God help you if you have to fight a swarm of 6 fleas.
		for(var/i = 0, i < fleas, i++)
			new /mob/living/simple_animal/hostile/space_funeral/bloodflea(vent.loc)