/datum/round_event_control/spawn_swarmer
	name = "Spawn Swarmer Shell"
	typepath = /datum/round_event/spawn_swarmer
	weight = 7
	max_occurrences = 1 //Only once okay fam
	earliest_start = 18000 //30 minutes


/datum/round_event/spawn_swarmer


/datum/round_event/spawn_swarmer/start()
	if(find_swarmer())
		return 0
	if(!the_gateway)
		return 0
	new /obj/item/unactivated_swarmer(get_turf(the_gateway))
	if(prob(25)) //25% chance to announce it to the crew
		var/swarmer_report = "<font size=3><b>[command_name()] High-Priority Update</b></span>"
		swarmer_report += "<br><br>Our long-range sensors have detected an odd signal emanating from an area of space north of the holodeck. We recommend immediate investigation of your gateway, as something may have come \
		through."
		print_command_report(swarmer_report,"Classified [command_name()] Update")
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", 'sound/AI/commandreport.ogg')


/datum/round_event/spawn_swarmer/proc/find_swarmer()
	for(var/mob/living/M in mob_list)
		if(istype(M, /mob/living/simple_animal/hostile/swarmer) && M.client) //If there is a swarmer with an active client, we've found our swarmer
			return 1
	return 0
