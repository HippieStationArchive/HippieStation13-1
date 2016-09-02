/datum/round_event_control/radiation_storm
	name = "Radiation Storm" //blowout
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 2

/datum/round_event/radiation_storm
	var/list/protected_areas = list(/area/maintenance, /area/turret_protected/ai_upload, /area/turret_protected/ai_upload_foyer, /area/turret_protected/ai)


/datum/round_event/radiation_storm/setup()
	startWhen = rand(15, 30)
	endWhen = startWhen + rand(7,15)

/datum/round_event/radiation_storm/announce()
	var/eta_timer = (startWhen + rand(-5,5))
	priority_announce("High levels of radiation detected approaching [station_name]. ETA: [eta_timer] seconds. Proceed to the nearest maintenance tunnel to take cover.", "Radiation Storm", 'sound/AI/radiation.ogg')
	make_maint_all_access()
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !M.ear_deaf)
			M << sound('sound/AI/radiationstorm.ogg', volume=50)
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/wizard_station)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == ZLEVEL_STATION)
			AR.radalert()

/datum/round_event/radiation_storm/start()
	for(var/mob/C in mob_list)
		var/turf/T = get_turf(C)
		if(!T)			continue
		if(T.z != 1)	continue
		for(var/mob/M)
			M << sound('sound/ambience/blowout.ogg', volume=5)

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
			H.apply_effect((rand(150, 300)), IRRADIATE, 0)
			H.Jitter(25)
			H.Weaken(15)
			if(prob(80))
				H.apply_effect((rand(300, 900)), IRRADIATE, 0)
			if(prob(50))
				H.apply_effect ((rand(900, 1500)), IRRADIATE, 0) //unlucky bastards

		else if(istype(C, /mob/living/carbon/monkey))
			var/mob/living/carbon/monkey/M = C
			M.apply_effect((rand(90, 900)), IRRADIATE, 0)

		else if(istype(C, /mob/living/simple_animal))
			var/mob/living/simple_animal/M = C
			M.apply_effect((rand(90, 900)), IRRADIATE, 0)


/datum/round_event/radiation_storm/end()
	priority_announce("The radiation threat has passed. Please return to your workplaces.", "Radiation Storm")
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/wizard_station)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == ZLEVEL_STATION)
			AR.radclear()
	spawn(500)
		revoke_maint_all_access()