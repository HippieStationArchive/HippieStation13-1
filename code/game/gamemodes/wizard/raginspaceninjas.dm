/datum/game_mode
	var/list/datum/mind/ninjas = list()

/datum/game_mode/ragin_space_ninjas
	name = "ragin' space ninjas"
	config_tag = "raginspaceninjas"
	antag_flag = ROLE_NINJA
	required_players = 20
	required_enemies = 1
	recommended_enemies = 1
	enemy_minimum_age = 0
	round_ends_with_antag_death = 1
	var/helping_station
	var/spawn_loc
	var/list/spawn_locs = list()

/datum/game_mode/ragin_space_ninjas/announce()
	world << "<B>The current game mode is - Ragin' Space Ninjas!</B>"
	world << "<B>A horde of angry <span class='danger'>SPACE NINJAS</span> are amassing outside the station! Repel these troublemakers!</B>"

/datum/game_mode/ragin_space_ninjas/pre_setup()
	if(!spawn_loc)
		for(var/obj/effect/landmark/L in landmarks_list)
			if(isturf(L.loc))
				switch(L.name)
					if("ninjaspawn","carpspawn")
						spawn_locs += L.loc

	var/datum/mind/ninja = pick(antag_candidates)
	ninja += ninja
	modePlayer += ninja
	ninja.assigned_role = "Space Ninja"
	ninja.special_role = "Space Ninja"
	if(!spawn_locs.len)
		ninja.current << "<span class='boldannounce'>A starting location for you could not be found, please report this bug!</span>"
		return 0
	for(var/datum/mind/nin in ninja)
		spawn_loc = pick(spawn_locs)
		if(!spawn_loc)
			ninja.current << "<span class='boldannounce'>A starting location for you could not be found, please report this bug!</span>"
			return 0
		nin.current.loc = spawn_loc

	return 1


/datum/game_mode/ragin_space_ninjas/post_setup()
	for(var/datum/mind/ninja in ninjas)
		log_game("[ninja.key] (ckey) has been selected as a Space Ninja")
		ninja.current.equip_space_ninja
		forge_ninja_objectives(ninja)
		greet_ninja(ninja)
	..()
	return

/datum/game_mode/ragin_space_ninjas/forge_objectives()
	helping_station = rand(0,1)
	var/list/possible_targets = list()
	for(var/datum/mind/M in ticker.minds)
		if(M.current && M.current.stat != DEAD)
			if(istype(M.current,/mob/living/carbon/human))
				if(M.special_role)
					possible_targets[M] = 0						//bad-guy
				else if(M.assigned_role in command_positions)
					possible_targets[M] = 1						//good-guy

	var/list/objectives = list(1,2,3,4)
	while(ninja.objectives.len < 6)	//still not enough objectives!
		switch(pick_n_take(objectives))
			if(1)	//research
				var/datum/objective/download/O = new /datum/objective/download()
				O.owner = Mind
				O.gen_amount_goal()
				ninja.objectives += O

			if(2)	//steal
				var/datum/objective/steal/special/O = new /datum/objective/steal/special()
				O.owner = Mind
				ninja.objectives += O

			if(3)	//protect/kill
				if(!possible_targets.len)	continue
				var/selected = rand(1,possible_targets.len)
				var/datum/mind/M = possible_targets[selected]
				var/is_bad_guy = possible_targets[M]
				possible_targets.Cut(selected,selected+1)

				if(is_bad_guy ^ helping_station)			//kill (good-ninja + bad-guy or bad-ninja + good-guy)
					var/datum/objective/assassinate/O = new /datum/objective/assassinate()
					O.owner = Mind
					O.target = M
					O.explanation_text = "Slay \the [M.current.real_name], the [M.assigned_role]."
					ninja.objectives += O
				else										//protect
					var/datum/objective/protect/O = new /datum/objective/protect()
					O.owner = Mind
					O.target = M
					O.explanation_text = "Protect \the [M.current.real_name], the [M.assigned_role], from harm."
					ninja.objectives += O
			if(4)	//debrain/capture
				if(!possible_targets.len)	continue
				var/selected = rand(1,possible_targets.len)
				var/datum/mind/M = possible_targets[selected]
				var/is_bad_guy = possible_targets[M]
				possible_targets.Cut(selected,selected+1)

				if(is_bad_guy ^ helping_station)			//debrain (good-ninja + bad-guy or bad-ninja + good-guy)
					var/datum/objective/debrain/O = new /datum/objective/debrain()
					O.owner = Mind
					O.target = M
					O.explanation_text = "Steal the brain of [M.current.real_name]."
					ninja.objectives += O
				else										//capture
					var/datum/objective/capture/O = new /datum/objective/capture()
					O.owner = Mind
					O.gen_amount_goal()
					ninja.objectives += O
			else
				break

	//Add a survival objective since it's usually broad enough for any round type.
	var/datum/objective/O = new /datum/objective/survive()
	O.owner = ninja
	ninja.objectives += O

/datum/game_mode/ragin_space_ninjas/check_finished()
	var/ninjas_alive = 0
	for(var/datum/mind/ninja in ninjas)
		if(!istype(ninja.current,/mob/living/carbon))
			continue
		if(istype(ninja.current,/mob/living/carbon/brain))
			continue
		if(ninja.current.stat==DEAD)
			continue
		if(ninja.current.stat==UNCONSCIOUS)
			continue
		ninjas_alive++
	if(!time_checked)
		time_checked = world.time
	if(ninjas_alive)
		if(world.time > time_checked + time_check)
			time_checked = world.time
			make_more_ninjas()

	else
		make_more_ninjas()
	return ..()

/datum/game_mode/ragin_space_ninjas/proc/make_more_ninjas()

	if(making_ninja)
		return 0
	making_ninja = 1
	ninjas_made++
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	spawn(rand(spawn_delay_min, spawn_delay_max))
		message_admins("The Spider Clan has sent another angry ninja")
		for(var/mob/dead/observer/G in player_list)
			if(G.client && !G.client.holder && !G.client.is_afk() && (ROLE_NINJA in G.client.prefs.be_special))
				if(!jobban_isbanned(G, ROLE_NINJA) && !jobban_isbanned(G, "Syndicate"))
					if(age_check(G.client))
						candidates += G
		if(!candidates.len)
			message_admins("No applicable ghosts for the next Ninja, asking ghosts instead.")
			var/time_passed = world.time
			for(var/mob/dead/observer/G in player_list)
				if(!jobban_isbanned(G, ROLE_NINJA) && !jobban_isbanned(G, "Syndicate"))
					if(age_check(G.client))
						spawn(0)
							switch(alert(G, "Do you wish to be considered for the position of Spider Clan 'diplomat'?","Please answer in 30 seconds!","Yes","No"))
								if("Yes")
									if((world.time-time_passed)>300)//If more than 30 game seconds passed.
										continue
									candidates += G
								if("No")
									continue

			sleep(300)
		if(!candidates.len)
			message_admins("This is awkward, sleeping until another ninja check...")
			making_ninja = 0
			ninjas_made--
			return
		else
			shuffle(candidates)
			for(var/mob/i in candidates)
				if(!i || !i.client) continue //Dont bother removing them from the list since we only grab one ninja

				theghost = i
				break

		if(theghost)
			spawn_loc = pick(spawn_locs)
			if(!spawn_loc)
				ninja.current << "<span class='boldannounce'>A starting location for you could not be found, please report this bug!</span>"
				return 0
			newninja = create_space_ninja(spawn_loc)
			theghost.mind.transfer_to(newninja)
			ninja.current.equip_space_ninja
			forge_ninja_objectives(newninja.mind)
			greet_ninja(ninja.mind)
			making_ninja = 0
			return 1

/datum/game_mode/ragin_space_ninjas/proc/greet_ninja()
	ninja.store_memory("I am an elite mercenary assassin of the mighty Spider Clan. A <font color='red'><B>SPACE NINJA</B></font>!")
	ninja.store_memory("Suprise is my weapon. Shadows are my armor. Without them, I am nothing. (//initialize your suit by right clicking on it, to use abilities like stealth)!")
	ninja.store_memory("Officially, [helping_station?"Nanotrasen":"The Syndicate"] are my employer.")

	ninja.current << "<span class='boldannounce'>You are the Space Ninja!</span>"
	ninja.current << "<B>Your employers, [helping_station?"Nanotrasen":"The Syndicate"] have given you the following objectives:</B>"

	var/obj_count = 1
	for(var/datum/objective/objective in ninja.objectives)
		ninja.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++

	if(istype(ninja.current.wear_suit,/obj/item/clothing/suit/space/space_ninja))
		//Should be true but we have to check these things.
		var/obj/item/clothing/suit/space/space_ninja/N = ninja.current.wear_suit
		ninja.current.randomize_param()

	ninja.current.internal = ninja.current.s_store
	if(ninja.current.internals)
		ninja.current.internals.icon_state = "internal1"

	ninja << sound('sound/effects/ninja_greeting.ogg') //so ninja you probably wouldn't even know if you were made one
