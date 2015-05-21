/datum/round_event_control/radiation_storm
	name = "Radiation Storm" //blowout
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 2

/datum/round_event/radiation_storm
	var/list/protected_areas = list(/area/maintenance, /area/turret_protected/ai_upload, /area/turret_protected/ai_upload_foyer, /area/turret_protected/ai, /area/turret_protected/ai)
	var/list/protected_pool = list (/area/crew_quarters/pool)

/datum/round_event/radiation_storm/setup()
	startWhen = rand(20, 40)
	endWhen = 40 //startWhen + rand(-10,10)

//	var/area/A
//	A = A.loc
//	if (!( istype(A, /area) ))
//		return

	for(var/area/A in world)
		if (A.z == 1)
			A.dangalert()
			//world << "hey yo i made it look dangerous and shit"

/datum/round_event/radiation_storm/announce()
	var/eta_timer = (startWhen + rand(-5,5))
	priority_announce("High levels of radiation detected approching [station_name]. ETA: [eta_timer] seconds. Proceed to the nearest maintenance tunnel to take cover.", "Radiation Storm", 'sound/AI/radiation_shortv2.ogg')

	/*

	//i just want to point out how dumb this is. why not like, put the, you know, two sounds and, like, maybe, merge the two, possibly?

	//rather than doing this shit, which priority_announce() does anyway

	//i even did it in audacity for you, lmao

	//look this is really dumb to write but still lets not do a pointless search that will only very slightly affect processing anyway. lord knows this game doesn't need more of that shit -reds

	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !M.ear_deaf)
			M << sound('sound/AI/radiation_short.ogg', volume=50) //Alarm + AI voice! WOO!
	*/



/datum/round_event/radiation_storm/start()
	for(var/area/A in world)
		if (A.z == 1)
			A.dangreset()
			A.redglow()

	for(var/mob/C in mob_list)
		var/turf/T = get_turf(C)
		if(!T)			continue
		if(T.z != 1)	continue

		for(var/mob/M)
			playsound(M,'sound/ambience/blowout.ogg',50,0)
			if(M.client)
				shake_camera(M, 40, 1) //BOOM BOOM SHAKE THE ROOM
				spawn(((endWhen) * 0.33))
					shake_camera(M, 40, 1)
					spawn(((endWhen) * 0.66))
						shake_camera(M, 40, 1) //just to make you shit your pants

		var/skip = 0
		for(var/a in protected_areas)
			if(istype(T.loc, a))
				skip = 1
		for(var/a in protected_pool)
			if(istype(T.loc, a) && istype(T, /turf/simulated/pool/water))
				skip = 1
				continue

		if(skip)	continue

		if(locate(/obj/machinery/power/apc) in T)	//damn you maint APCs!!
			continue	//why is it maint apcs anyway. like they're not even checking power status...
			//but if there isn't one at all enjoy ur rads mr manhattan,
			//despite superman being in an unpowered apc hallway, effectively being just as empty as a maint w/out apcs,
			//not getting all that lovely kryponite all over him and inside him. what the fuck guys

			//ps i'm now waiting for no-apc maint blowout grff now l m a o

		if(istype(C, /mob/living/carbon))
			var/mob/living/carbon/H = C
			H.apply_effect((rand(90, 300)), IRRADIATE, 0)
			if(prob(50))
				H.apply_effect((rand(300, 900)), IRRADIATE, 0)
			if(prob(75))
				randmutb(H)
				domutcheck(H, null, 1)
			else
				randmutg(H)
				domutcheck(H, null, 1)
			spawn(((endWhen) * 0.33))
				H.apply_effect((rand(90, 300)), IRRADIATE, 0)
				if(prob(50))
					H.apply_effect((rand(300, 900)), IRRADIATE, 0)
				if(prob(75))
					randmutb(H)
					domutcheck(H, null, 1)
				else
					randmutg(H)
					domutcheck(H, null, 1)
				spawn(((endWhen) * 0.66))
					H.apply_effect((rand(90, 300)), IRRADIATE, 0)
					if(prob(50))
						H.apply_effect((rand(300, 900)), IRRADIATE, 0)
					if(prob(75))
						randmutb(H)
						domutcheck(H, null, 1)
					else
						randmutg(H)
						domutcheck(H, null, 1)
					spawn(((endWhen) * 0.99))					//now you can't just dodge the first wave and go back to buisness as usual
						H.apply_effect((rand(90, 300)), IRRADIATE, 0)
						if(prob(50))
							H.apply_effect((rand(300, 900)), IRRADIATE, 0)
						if(prob(75))
							randmutb(H)
							domutcheck(H, null, 1)
						else
							randmutg(H)
							domutcheck(H, null, 1)

		else if(istype(C, /mob/living/simple_animal))
			var/mob/living/simple_animal/M = C
			M.apply_damage((rand(90, 900)), TOX, null, 1) //this is what you get for not taking care of your pets!!!


/datum/round_event/radiation_storm/end()
	for(var/area/A in world)
		if (A.z == 1)
			A.redglowreset()

	priority_announce("The radiation threat has passed. Please return to your workplaces.", "Radiation Storm")


//	var/area/A = the_station_areas
//	A = locate(the_station_areas)
//	if (!( istype(A, /area) ))
//		return
//	for(var/area/RA in A.related)
//		RA.dangerreset()