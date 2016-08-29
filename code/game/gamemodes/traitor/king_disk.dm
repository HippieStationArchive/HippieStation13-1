/datum/game_mode/traitor/king_disk
	name = "king of the disk"
	config_tag = "king_disk"
	required_players = 35 // We aren't even hitting 45 players unfortunately.
	required_enemies = 8
	recommended_enemies = 10
	reroll_friendly = 0
	restricted_jobs = list("Cyborg", "AI")

	traitors_possible = 12
	num_modifier = 6

	var/list/target_list = list()
	var/list/late_joining_list = list()

/datum/game_mode/traitor/king_disk/announce()
	world << "<B>The current game mode is - King of the Disk!</B>"
	world << "<B>A bunch of rookie agents are all trying to steal the nuke disk to prove their worth to the Syndicate! Do not let them succeed!</B>"

/datum/game_mode/traitor/king_disk/equip_traitor(mob/living/carbon/human/traitor_mob, safety = 0)
	..()
	var/obj/item/device/uplink/U = traitor_mob.mind.find_syndicate_uplink()
	if(U)
		U.uses = 10

/datum/game_mode/traitor/king_disk/forge_traitor_objectives(datum/mind/traitor)
	// Steal the disk
	var/datum/objective/steal/disk/disk_objective = new
	disk_objective.owner = traitor
	disk_objective.give_special_equipment()
	traitor.objectives += disk_objective

	// Escape
	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = traitor
	traitor.objectives += escape_objective
	return

/datum/game_mode/traitor/king_disk/process()
	for(var/mob/M in living_mob_list)
		if(M.mind)
			var/datum/mind/traitor = M.mind
			var/list/all_items = traitor.current.GetAllContents()
			for(var/obj/item/weapon/disk/nuclear/N in all_items)
				if(traitor.special_role)
					if(N.king_timer >= 60)
						N.king_timer = 0
						var/mob/H = M
						if(traitor.special_role == "Mindslave")
							for(var/datum/objective/protect/P in traitor.objectives)
								if(P.target && P.target.current)
									all_items = P.target.current.GetAllContents()
									H = P.target.current
						for(var/obj/item/device/uplink/U in all_items)
							U.uses += 1
							H << "<span class='notice'>Your PDA vibrates softly. The Syndicate have rewarded you with an additional telecrystal for your possession of the disk.</span>"
							if(U.active)
								U.interact(H)
					else
						N.king_timer += 1
					return
	for(var/obj/item/weapon/disk/nuclear/N in poi_list)
		N.king_timer = 0
