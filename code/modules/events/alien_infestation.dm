/datum/round_event_control/alien_infestation
	name = "Alien Infestation"
	typepath = /datum/round_event/alien_infestation
	latest_start = 15000//ayylmaos will now spawn every 20 to 25 minutes. As this is a range of 5 minutes as opposed to around
	//30 before(round length of 50 minutes - 20 minimum start time), weight is increased by 6x the default 5 to 30 to supplement this.
	weight = 30

/datum/round_event/alien_infestation
	announceWhen	= 400

	var/spawncount = 1
	var/successSpawn = 0	//So we don't make a command report if nothing gets spawned.


/datum/round_event/alien_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(2, 3)

/datum/round_event/alien_infestation/kill()
	if(!successSpawn && control)
		control.occurrences--
	return ..()

/datum/round_event/alien_infestation/announce()
	if(successSpawn)
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg')


/datum/round_event/alien_infestation/start()

	var/list/vents = list()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in machines)
		if(qdeleted(temp_vent))
			continue
		if(temp_vent.loc.z == ZLEVEL_STATION && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.PARENT1
			if(temp_vent_parent.other_atmosmch.len > 20)	//Stops Aliens getting stuck in small networks. See: Security, Virology
				vents += temp_vent

	var/list/candidates = get_candidates(ROLE_ALIEN, ALIEN_AFK_BRACKET)

	while(spawncount > 0 && vents.len && candidates.len)
		var/obj/vent = pick_n_take(vents)
		var/client/C = pick_n_take(candidates)

		var/mob/living/carbon/alien/larva/new_xeno = new(vent.loc)
		new_xeno.key = C.key
		new_xeno.amount_grown = new_xeno.max_grown

		spawncount--
		successSpawn = 1