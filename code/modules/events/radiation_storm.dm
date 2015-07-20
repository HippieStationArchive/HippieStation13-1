/datum/round_event_control/radiation_storm
	name = "Radiation Storm" //blowout
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 2

/datum/round_event/radiation_storm
	var/list/protected_areas = list(/area/maintenance, /area/turret_protected/ai_upload, /area/turret_protected/ai_upload_foyer, /area/turret_protected/ai)


/datum/round_event/radiation_storm/setup()
	startWhen = rand(20, 40)
	endWhen = startWhen + rand(-10,10)

/datum/round_event/radiation_storm/announce()
	var/eta_timer = (startWhen + rand(-5,5))
	priority_announce("High levels of radiation detected approching [station_name]. ETA: [eta_timer] seconds. Proceed to the nearest maintenance tunnel to take cover.", "Radiation Storm", 'sound/AI/radiation_shortv2.ogg')
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !M.ear_deaf)
			M << sound('sound/AI/radiation_short.ogg', volume=50) //Alarm + AI voice! WOO!

/datum/round_event/radiation_storm/start()
	spawn(60 + (endWhen) + (startWhen)) // Announce fix
		priority_announce("The radiation threat has passed. Please return to your workplaces.", "Radiation Storm")

	for(var/mob/C in mob_list)
		var/turf/T = get_turf(C)
		if(!T)			continue
		if(T.z != 1)	continue

		for(var/mob/M)
			playsound(M,'sound/ambience/blowout.ogg',20,0) //TURN THAT SHIT WAAAY THE FUCK DOWN
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
				continue

		if(skip)	continue

		if(locate(/obj/machinery/power/apc) in T)
			continue

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

// Dont need this as we can pull the vars up there and broadcast it too.
///datum/round_event/radiation_storm/end()
//	spawn(60 + endWhen + startWhen)
//		priority_announce("The radiation threat has passed. Please return to your workplaces. TEST", "Radiation Storm")
