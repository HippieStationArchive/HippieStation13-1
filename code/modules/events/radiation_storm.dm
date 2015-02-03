/datum/round_event_control/radiation_storm
	name = "Radiation Storm" //blowout
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 2

/datum/round_event/radiation_storm
	var/list/protected_areas = list(/area/maintenance, /area/turret_protected/ai_upload, /area/turret_protected/ai_upload_foyer, /area/turret_protected/ai)


/datum/round_event/radiation_storm/setup()
	startWhen = rand(20, 40)
	endWhen = 40 //startWhen + rand(-10,10)

//	var/area/A
//	A = A.loc
//	if (!( istype(A, /area) ))
//		return

	//for(var/area/A in world)
		//if (A.z == 1)
			//A.dangalert()
			//world << "hey yo i made it look dangerous and shit"

/datum/round_event/radiation_storm/announce()
	var/eta_timer = (startWhen + rand(-5,5))
	priority_announce("High levels of radiation detected approching [station_name]. ETA: [eta_timer] seconds. Proceed to the nearest maintenance tunnel to take cover.", "Radiation Storm", 'sound/AI/radiation.ogg')
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !M.ear_deaf)
			M << sound('sound/AI/radiation_short.ogg', volume=50) //Alarm + AI voice! WOO!

/datum/round_event/radiation_storm/start()
	//for(var/area/A in world)
		//if (A.z == 1)
			//A.dangreset()
			//A.redglow()

	for(var/mob/C in mob_list)
		var/turf/T = get_turf(C)
		if(!T)			continue
		if(T.z != 1)	continue

		for(var/mob/M)
			if(M.client)
				shake_camera(M, 40, 1) //BOOM BOOM SHAKE THE ROOM
				spawn(40)
					shake_camera(M, 40, 1)
					spawn(40)
						shake_camera(M, 40, 1) //just to make you shit your pants

		var/skip = 0
		for(var/a in protected_areas)
			if(istype(T.loc, a))
				skip = 1
				continue

		if(skip)	continue

		if(locate(/obj/machinery/power/apc) in T)	//damn you maint APCs!!
			continue

		if(istype(C, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			H.apply_effect((rand(90, 150)), IRRADIATE, 0)
			if(prob(50))
				H.apply_effect((rand(300, 900)), IRRADIATE, 0)
			if(prob(75))
				randmutb(H)
				domutcheck(H, null, 1)
			else
				randmutg(H)
				domutcheck(H, null, 1)

		else if(istype(C, /mob/living/carbon/monkey))
			var/mob/living/carbon/monkey/M = C
			M.apply_effect((rand(90, 900)), IRRADIATE, 0)

		else if(istype(C, /mob/living/simple_animal))
			var/mob/living/simple_animal/M = C
			M.apply_effect((rand(90, 900)), IRRADIATE, 0)


/datum/round_event/radiation_storm/end()
	//for(var/area/A in world)
		//if (A.z == 1)
			//A.redglowreset()

	priority_announce("The radiation threat has passed. Please return to your workplaces.", "Radiation Storm")


//	var/area/A = the_station_areas
//	A = locate(the_station_areas)
//	if (!( istype(A, /area) ))
//		return
//	for(var/area/RA in A.related)
//		RA.dangerreset()