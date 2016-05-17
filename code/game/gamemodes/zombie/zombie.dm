/datum/game_mode
	var/list/zombie_infectees = list()

/datum/game_mode/zombie
	name = "zombie"
	config_tag = "zombie"
	// antag_flag = ROLE_MONKEY

	required_players = 20
	required_enemies = 1
	recommended_enemies = 2

	restricted_jobs = list("Cyborg", "AI")

	reroll_friendly = 1 //This gamemode should mostly be a mulligan roundtype

	var/carriers_to_make = 1
	var/list/carriers = list()

	var/live_zombies = 0

	var/players_per_carrier = 11 //1 patient zero every 13 players

/datum/game_mode/zombie/pre_setup()
	carriers_to_make = max(round(num_players()/players_per_carrier, 1), 1)

	for(var/j = 0 to carriers_to_make)
		if (!antag_candidates.len)
			break
		var/datum/mind/carrier = pick(antag_candidates)
		carriers += carrier
		carrier.special_role = "Zombie Patient Zero"
		carrier.restricted_roles = restricted_jobs
		log_game("[carrier.key] (ckey) has been selected as a Zombie Virus carrier")
		antag_candidates -= carrier

	if(!carriers.len)
		return 0
	return 1


/datum/game_mode/zombie/announce()
	world << "<B>The current game mode is - zombie!</B>"
	world << "<B>One or more crewmembers have been infected with the Zombie VIrus! Crew: Contain the outbreak. Do not allow the zombies to infect more than 80% of the crew. \
				Zombies: Infect as many people as you can!</B>"

/datum/game_mode/zombie/post_setup()
	for(var/datum/mind/carriermind in carriers)
		zombie_infectees += carriermind

		var/datum/disease/D = new /datum/disease/zombie
		// D.visibility_flags = HIDDEN_SCANNER|HIDDEN_PANDEMIC
		D.holder = carriermind.current
		D.affected_mob = carriermind.current
		carriermind.current.viruses += D
	..()

/datum/game_mode/zombie/check_finished()
	if(SSshuttle.emergency.mode >= SHUTTLE_ENDGAME || station_was_nuked)
		return 1

	if(!round_converted)
		for(var/datum/mind/zombie_mind in zombie_infectees)
			continuous_sanity_checked = 1
			if(zombie_mind.current && zombie_mind.current.stat != DEAD)
				return 0

		for(var/mob/living/carbon/human/H in living_mob_list)
			if(H.mind)
				if(H.HasDisease(/datum/disease/zombie))
					return 0

	..()

/datum/game_mode/zombie/proc/check_zombie_victory()
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return 0
	for(var/mob/living/carbon/human/H in living_mob_list)
		if (H.HasDisease(/datum/disease/zombie))
			live_zombies++
	for(var/mob/living/simple_animal/hostile/zombie/Z in mob_list)
		if(Z.stat != DEAD)
			live_zombies++
	if(live_zombies >= (num_players() * 0.8)) //80% of the crew infected
		return 1
	else
		return 0

/datum/game_mode/proc/add_zombie(datum/mind/zombie_mind)
	if(zombie_mind)
		zombie_infectees |= zombie_mind
		zombie_mind.special_role = "Zombie"
		ticker.mode.update_zombie_icons_added(zombie_mind)

/datum/game_mode/proc/remove_zombie(datum/mind/zombie_mind)
	if(zombie_mind)
		zombie_infectees.Remove(zombie_mind)
		zombie_mind.special_role = null
		ticker.mode.update_zombie_icons_removed(zombie_mind)

/datum/game_mode/proc/update_zombie_icons()
	for(var/mob/living/simple_animal/hostile/zombie/Z in mob_list)
		if(Z.stat != DEAD)
			Z.UpdateInfectionImage()

/datum/game_mode/zombie/declare_completion()
	if(check_zombie_victory())
		feedback_set_details("round_end_result","win - zombies win")
		feedback_set("round_end_result",live_zombies)
		world << "<span class='userdanger'>The zombie infection has infected an overwhelming majority of the crew...</span>"
	else
		feedback_set_details("round_end_result","loss - staff stopped the zombies")
		feedback_set("round_end_result",live_zombies)
		world << "<span class='userdanger'>The staff managed to contain the zombie infestation!</span>"

/datum/game_mode/proc/update_zombie_icons_added(datum/mind/zombie_mind)
	var/datum/atom_hud/antag/zombie_hud = huds[ANTAG_HUD_ZOMBIE]
	zombie_hud.join_hud(zombie_mind.current)
	set_antag_hud(zombie_mind.current, "zombie")

/datum/game_mode/proc/update_zombie_icons_removed(datum/mind/zombie_mind)
	var/datum/atom_hud/antag/zombie_hud = huds[ANTAG_HUD_ZOMBIE]
	zombie_hud.leave_hud(zombie_mind.current)
	set_antag_hud(zombie_mind.current, null)