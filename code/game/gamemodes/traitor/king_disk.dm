/datum/game_mode/traitor/king_disk
	name = "king of the disk"
	config_tag = "king_disk"
	required_players = 35
	required_enemies = 8
	recommended_enemies = 10
	reroll_friendly = 0
	restricted_jobs = list("Cyborg", "AI")

	traitors_possible = 12
	num_modifier = 8

	var/list/target_list = list()
	var/list/late_joining_list = list()

/datum/game_mode/traitor/king_disk/announce()
	world << "<B>The current game mode is - King of the Disk!</B>"
	world << "<B>A bunch of rookie agents are all trying to steal the nuke disk to prove their worth to the Syndicate! Do not let them succeed!</B>"

/datum/game_mode/traitor/king_disk/equip_traitor(mob/living/carbon/human/traitor_mob, safety = 0)
	..()
	for(var/obj/item/device/uplink/U in world_uplinks)
		U.uses = 10

/datum/game_mode/traitor/king_disk/forge_traitor_objectives(datum/mind/traitor)
	// Steal the disk
	var/datum/objective/steal/disk/disk_objective = new
	disk_objective.owner = traitor
	disk_objective.give_special_equipment()
	traitor.objectives += disk_objective

	// Escape
	if(issilicon(traitor.current))
		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective
	else
		var/datum/objective/escape/escape_objective = new
		escape_objective.owner = traitor
		traitor.objectives += escape_objective
	return
