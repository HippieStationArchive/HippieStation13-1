/datum/round_event_control/revenant
	name = "Spawn Revenant"
	typepath = /datum/round_event/revenant
	max_occurrences = 3
	earliest_start = 0 //Meant to mix things up early-game.



/datum/round_event/revenant
	var/key_of_revenant



/datum/round_event/revenant/proc/get_revenant(var/end_if_fail = 0)
	key_of_revenant = null
	if(!key_of_revenant)
		var/list/candidates = get_candidates(BE_REVENANT)
		if(!candidates.len)
			if(end_if_fail)
				return 0
			return find_revenant()
		var/client/C = pick(candidates)
		key_of_revenant = C.key
	if(!key_of_revenant)
		if(end_if_fail)
			return 0
		return find_revenant()
	var/datum/mind/player_mind = new /datum/mind(key_of_revenant)
	player_mind.active = 1
	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(isturf(L.loc))
			switch(L.name)
				if("carpspawn")
					spawn_locs += L.loc
	if(!spawn_locs)
		return find_revenant()
	var/mob/living/simple_animal/revenant/revvie = new /mob/living/simple_animal/revenant/(pick(spawn_locs))
	player_mind.transfer_to(revvie)
	player_mind.assigned_role = "MODE"
	player_mind.special_role = "Revenant"
	ticker.mode.traitors |= player_mind
	revvie << 'sound/effects/ghost.ogg'
	message_admins("[player_mind] has been made into a Revenant by an event!")
	log_game("[key_of_revenant] was spawned as a Revenant by an event.")
	player_mind.store_memory("<span class='deadsay'>I am a revenant. My spectral form has been empowered. My only goal is to gather essence from the humans of [world.name].</span>")
	revvie << "<br>"
	revvie << "<span class='deadsay'><font size=3><b>You are a revenant!</b></font></span>"
	revvie << "<b>Your formerly mundane spirit has been infused with alien energies and empowered into a revenant.</b>"
	revvie << "<b>You are not dead, not alive, but somewhere in between. You are capable of very limited interaction with both worlds.</b>"
	revvie << "<b>You are invincible and invisible to everyone but other ghosts. Some abilities may change this.</b>"
	revvie << "<b>Your goal is to gather essence from humans. Your essence passively regenerates up to 25E over time. You can use the Harvest abilities to gather more from corpses.</b>"
	//revvie << "<b>Be sure to read the wiki page at https://tgstation13.org/wiki/Revenant !</b>" //Not added yet.
	revvie << "<br>"
	return 1



/datum/round_event/revenant/start()
	get_revenant()



/datum/round_event/revenant/proc/find_revenant()
	message_admins("Attempted to spawn a Revenant but there was no players available. Will try again momentarily, bear with me...")
	spawn(50)
		if(get_revenant(1))
			message_admins("Hooray! Situation has been resolved, [key_of_revenant] has been spawned as a Revenant.")
			log_game("[key_of_revenant] was spawned as a Revenant by an event.")
			return 0
		message_admins("Unfortunately, no candidates were available for becoming a Revenant. Shutting down. :(")
	return kill()