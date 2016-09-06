/datum/admins/proc/Secrets()
	if(!check_rights(0))	return

	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"

	dat +={"
			<B>General Secrets</B><BR>
			<BR>
			<A href='?src=\ref[src];secrets=spawnselfdummy'>Spawn yourself as a Test Dummy</A><BR>
			<A href='?src=\ref[src];secrets=list_job_debug'>Show Job Debug</A><BR>
			<A href='?src=\ref[src];secrets=admin_log'>Admin Log</A><BR>
			<A href='?src=\ref[src];secrets=mentor_log'>Mentor Log</A><BR>
			<A href='?src=\ref[src];secrets=show_admins'>Show Admin List</A><BR>
			<BR>
			"}

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Admin Secrets</B><BR>
			<BR>
			<A href='?src=\ref[src];secrets=clear_virus'>Cure all diseases currently in existence</A><BR>
			<A href='?src=\ref[src];secrets=list_bombers'>Bombing List</A><BR>
			<A href='?src=\ref[src];secrets=check_antagonist'>Show current traitors and objectives</A><BR>
			<A href='?src=\ref[src];secrets=list_signalers'>Show last [length(lastsignalers)] signalers</A><BR>
			<A href='?src=\ref[src];secrets=list_lawchanges'>Show last [length(lawchanges)] law changes</A><BR>
			<A href='?src=\ref[src];secrets=showailaws'>Show AI Laws</A><BR>
			<A href='?src=\ref[src];secrets=showgm'>Show Game Mode</A><BR>
			<A href='?src=\ref[src];secrets=manifest'>Show Crew Manifest</A><BR>
			<A href='?src=\ref[src];secrets=DNA'>List DNA (Blood)</A><BR>
			<A href='?src=\ref[src];secrets=fingerprints'>List Fingerprints</A><BR><BR>
			<A href='?src=\ref[src];secrets=tdomereset'>Reset Thunderdome to default state</A><BR>
			<BR>
			<B>Shuttles</B><BR>
			<BR>
			<A href='?src=\ref[src];secrets=moveferry'>Move Ferry</A><BR>
			<A href='?src=\ref[src];secrets=moveminingshuttle'>Move Mining Shuttle</A><BR>
			<A href='?src=\ref[src];secrets=movelaborshuttle'>Move Labor Shuttle</A><BR>
			<BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"
			<B>Fun Secrets</B><BR>
			<BR>

			<A href='?src=\ref[src];secrets=virus'>Trigger a Virus Outbreak</A><BR>
			<A href='?src=\ref[src];secrets=monkey'>Turn all humans into monkeys</A><BR>
			<A href='?src=\ref[src];secrets=allspecies'>Change the species of all humans</A><BR>
			<A href='?src=\ref[src];secrets=power'>Make all areas powered</A><BR>
			<A href='?src=\ref[src];secrets=unpower'>Make all areas unpowered</A><BR>
			<A href='?src=\ref[src];secrets=quickpower'>Power all SMES</A><BR>
			<A href='?src=\ref[src];secrets=tripleAI'>Triple AI mode (needs to be used in the lobby)</A><BR>
			<A href='?src=\ref[src];secrets=traitor_all'>Everyone is the traitor</A><BR>
			<A href='?src=\ref[src];secrets=guns'>Summon Guns</A><BR>
			<A href='?src=\ref[src];secrets=magic'>Summon Magic</A><BR>
			<A href='?src=\ref[src];secrets=events'>Summon Events (Toggle)</A><BR>
			<A href='?src=\ref[src];secrets=onlyone'>There can only be one!</A><BR>
			<A href='?src=\ref[src];secrets=onlyme'>There can only be me!</A><BR>
			<A href='?src=\ref[src];secrets=retardify'>Make all players retarded</A><BR>
			<A href='?src=\ref[src];secrets=eagles'>Egalitarian Station Mode</A><BR>
			<A href='?src=\ref[src];secrets=blackout'>Break all lights</A><BR>
			<A href='?src=\ref[src];secrets=whiteout'>Fix all lights</A><BR>
			<A href='?src=\ref[src];secrets=floorlava'>The floor is lava! (DANGEROUS: extremely lame)</A><BR>
			<BR>
			<A href='?src=\ref[src];secrets=changebombcap'>Change bomb cap</A><BR>
			"}

	dat += "<BR>"

	if(check_rights(R_DEBUG,0))
		dat += {"
			<B>Security Level Elevated</B><BR>
			<BR>
			<A href='?src=\ref[src];secrets=maint_access_engiebrig'>Change all maintenance doors to engie/brig access only</A><BR>
			<A href='?src=\ref[src];secrets=maint_access_brig'>Change all maintenance doors to brig access only</A><BR>
			<A href='?src=\ref[src];secrets=infinite_sec'>Remove cap on security officers</A><BR>
			<BR>
			"}

	if(check_rights(R_PERMISSIONS,0))
		dat += {"
			<B>Super secret stuff</B><BR>
			<BR>
			<A href='?src=\ref[src];secrets=show_whitelist'>Show CID Whitelist</A><BR>
			<BR>
			"}

	usr << browse(dat, "window=secrets")
	return





/datum/admins/proc/Secrets_topic(item,href_list)
	var/datum/round_event/E
	var/ok = 0
	switch(item)
		if("spawnselfdummy")
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","TD")
			message_admins("[key_name_admin(usr)] spawned himself as a Test Dummy.")
			var/turf/T = get_turf(usr)
			var/mob/living/carbon/human/dummy/D = new /mob/living/carbon/human/dummy(T)
			usr.client.cmd_assume_direct_control(D)
			D.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(D), slot_w_uniform)
			D.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(D), slot_shoes)
			D.equip_to_slot_or_del(new /obj/item/weapon/card/id/admin(D), slot_wear_id)
			D.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(D), slot_ears)
			D.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(D), slot_back)
			D.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(D.back), slot_in_backpack)
			T.turf_animation('icons/effects/96x96.dmi',"beamin",-32,0,MOB_LAYER+1,'sound/misc/adminspawn.ogg',5)
			D.name = "Admin"
			D.real_name = "Admin"
			var/newname = ""
			newname = copytext(sanitize(input(D, "Before you step out as an embodied god, what name do you wish for?", "Choose your name.", "Admin") as null|text),1,MAX_NAME_LEN)
			if (!newname)
				newname = "Admin"
			D.name = newname
			D.real_name = newname

		if("admin_log")
			var/dat = "<B>Admin Log<HR></B>"
			for(var/l in admin_log)
				dat += "<li>[l]</li>"
			if(!admin_log.len)
				dat += "No-one has done anything this round!"
			usr << browse(dat, "window=admin_log")

		if("mentor_log")
			var/dat = "<B>Mentor Log<HR></B>"
			for(var/l in mentor_log)
				dat += "<li>[l]</li>"
			if(!mentor_log.len)
				dat += "No mentors have done anything this round!"
			usr << browse(dat, "window=mentor_log")

		if("list_job_debug")
			var/dat = "<B>Job Debug info.</B><HR>"
			if(SSjob)
				for(var/line in SSjob.job_debug)
					dat += "[line]<BR>"
				dat+= "*******<BR><BR>"
				for(var/datum/job/job in SSjob.occupations)
					if(!job)	continue
					dat += "job: [job.title], current_positions: [job.current_positions], total_positions: [job.total_positions] <BR>"
				usr << browse(dat, "window=jobdebug;size=600x500")

		if("show_admins")
			var/dat = "<B>Current admins:</B><HR>"
			if(admin_datums)
				for(var/ckey in admin_datums)
					var/datum/admins/D = admin_datums[ckey]
					dat += "[ckey] - [D.rank.name]<br>"
				usr << browse(dat, "window=showadmins;size=600x500")

		if("tdomereset")
			if(!check_rights(R_ADMIN))
				return
			var/delete_mobs = alert("Clear all mobs?","Confirm","Yes","No","Cancel")
			if(delete_mobs == "Cancel")
				return

			log_admin("[key_name(usr)] reset the thunderdome to default with delete_mobs==[delete_mobs].", 1)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] reset the thunderdome to default with delete_mobs==[delete_mobs].</span>")

			var/area/thunderdome = locate(/area/tdome/arena)
			if(delete_mobs == "Yes")
				for(var/mob/living/mob in thunderdome)
					qdel(mob) //Clear mobs
			for(var/obj/obj in thunderdome)
				if(!istype(obj,/obj/machinery/camera))
					qdel(obj) //Clear objects

			var/area/template = locate(/area/tdome/arena_source)
			template.copy_contents_to(thunderdome)

		if("clear_virus")

			var/choice = input("Are you sure you want to cure all disease?") in list("Yes", "Cancel")
			if(choice == "Yes")
				message_admins("[key_name_admin(usr)] has cured all diseases.")
				for(var/datum/disease/D in SSdisease.processing)
					D.cure(D)

		if("list_bombers")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Bombing List<HR>"
			for(var/l in bombers)
				dat += text("[l]<BR>")
			usr << browse(dat, "window=bombers")

		if("list_signalers")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing last [length(lastsignalers)] signalers.</B><HR>"
			for(var/sig in lastsignalers)
				dat += "[sig]<BR>"
			usr << browse(dat, "window=lastsignalers;size=800x500")

		if("list_lawchanges")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing last [length(lawchanges)] law changes.</B><HR>"
			for(var/sig in lawchanges)
				dat += "[sig]<BR>"
			usr << browse(dat, "window=lawchanges;size=800x500")

		if("moveminingshuttle")
			if(!check_rights(R_ADMIN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","ShM")
			if(!SSshuttle.toggleShuttle("mining","mining_home","mining_away"))
				message_admins("[key_name_admin(usr)] moved mining shuttle")
				log_admin("[key_name(usr)] moved the mining shuttle")

		if("movelaborshuttle")
			if(!check_rights(R_ADMIN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","ShL")
			if(!SSshuttle.toggleShuttle("laborcamp","laborcamp_home","laborcamp_away"))
				message_admins("[key_name_admin(usr)] moved labor shuttle")
				log_admin("[key_name(usr)] moved the labor shuttle")

		if("moveferry")
			if(!check_rights(R_ADMIN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","ShF")
			if(!SSshuttle.toggleShuttle("ferry","ferry_home","ferry_away"))
				message_admins("[key_name_admin(usr)] moved the centcom ferry")
				log_admin("[key_name(usr)] moved the centcom ferry")

		if("showailaws")
			if(!check_rights(R_ADMIN))
				return
			output_ai_laws()
		if("showgm")
			if(!check_rights(R_ADMIN))
				return
			if(!ticker || !ticker.mode)
				alert("The game hasn't started yet!")
			else if (ticker.mode)
				alert("The game mode is [ticker.mode.name]")
			else alert("For some reason there's a ticker, but not a game mode")
		if("manifest")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing Crew Manifest.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Position</th></tr>"
			for(var/datum/data/record/t in data_core.general)
				dat += "<tr><td>[t.fields["name"]]</td><td>[t.fields["rank"]]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=manifest;size=440x410")
		if("DNA")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing DNA from blood.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
			for(var/mob/living/carbon/human/H in mob_list)
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.dna.blood_type]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=DNA;size=440x410")
		if("fingerprints")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<B>Showing Fingerprints.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
			for(var/mob/living/carbon/human/H in mob_list)
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[md5(H.dna.uni_identity)]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=fingerprints;size=440x410")

		if("monkey")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","M")
			for(var/mob/living/carbon/human/H in mob_list)
				spawn(0)
					H.monkeyize()
			ok = 1

		if("allspecies")
			if(!check_rights(R_FUN))
				return
			var/result = input(usr, "Please choose a new species","Species") as null|anything in species_list
			if(result)
				log_admin("[key_name(usr)] turned all humans into [result]", 1)
				message_admins("\blue [key_name_admin(usr)] turned all humans into [result]")
				var/newtype = species_list[result]
				for(var/mob/living/carbon/human/H in mob_list)
					H.set_species(newtype)

		if("corgi")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","M")
			for(var/mob/living/carbon/human/H in mob_list)
				spawn(0)
					H.corgize()
			ok = 1

		if("tripleAI")
			if(!check_rights(R_FUN))
				return
			usr.client.triple_ai()
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","TriAI")

		if("power")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","P")
			log_admin("[key_name(usr)] made all areas powered", 1)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all areas powered</span>")
			power_restore()

		if("unpower")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","UP")
			log_admin("[key_name(usr)] made all areas unpowered", 1)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all areas unpowered</span>")
			power_failure()

		if("quickpower")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","QP")
			log_admin("[key_name(usr)] made all SMESs powered", 1)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] made all SMESs powered</span>")
			power_restore_quick()

		if("traitor_all")
			if(!check_rights(R_FUN))
				return
			if(!ticker || !ticker.mode)
				alert("The game hasn't started yet!")
				return
			var/objective = copytext(sanitize(input("Enter an objective")),1,MAX_MESSAGE_LEN)
			if(!objective)
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","TA([objective])")
			for(var/mob/living/carbon/human/H in player_list)
				if(H.stat == 2 || !H.client || !H.mind) continue
				if(is_special_character(H)) continue
				//traitorize(H, objective, 0)
				ticker.mode.traitors += H.mind
				H.mind.special_role = "traitor"
				var/datum/objective/new_objective = new
				new_objective.owner = H
				new_objective.explanation_text = objective
				H.mind.objectives += new_objective
				ticker.mode.greet_traitor(H.mind)
				//ticker.mode.forge_traitor_objectives(H.mind)
				ticker.mode.finalize_traitor(H.mind)
			for(var/mob/living/silicon/A in player_list)
				if(A.stat == 2 || !A.client || !A.mind) continue
				if(ispAI(A)) continue
				else if(is_special_character(A)) continue
				ticker.mode.traitors += A.mind
				A.mind.special_role = "traitor"
				var/datum/objective/new_objective = new
				new_objective.owner = A
				new_objective.explanation_text = objective
				A.mind.objectives += new_objective
				ticker.mode.greet_traitor(A.mind)
				ticker.mode.finalize_traitor(A.mind)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] used everyone is a traitor secret. Objective is [objective]</span>")
			log_admin("[key_name(usr)] used everyone is a traitor secret. Objective is [objective]")

		if("changebombcap")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","BC")

			var/newBombCap = input(usr,"What would you like the new bomb cap to be. (entered as the light damage range (the 3rd number in common (1,2,3) notation)) Must be between 4 and 128)", "New Bomb Cap", MAX_EX_LIGHT_RANGE) as num|null
			if (newBombCap < 4)
				return
			if (newBombCap > 128)
				newBombCap = 128

			MAX_EX_DEVESTATION_RANGE = round(newBombCap/4)
			MAX_EX_HEAVY_RANGE = round(newBombCap/2)
			MAX_EX_LIGHT_RANGE = newBombCap
			//I don't know why these are their own variables, but fuck it, they are.
			MAX_EX_FLASH_RANGE = newBombCap
			MAX_EX_FLAME_RANGE = newBombCap

			message_admins("<span class='boldannounce'>[key_name_admin(usr)] changed the bomb cap to [MAX_EX_DEVESTATION_RANGE], [MAX_EX_HEAVY_RANGE], [MAX_EX_LIGHT_RANGE]</span>")
			log_admin("[key_name(usr)] changed the bomb cap to [MAX_EX_DEVESTATION_RANGE], [MAX_EX_HEAVY_RANGE], [MAX_EX_LIGHT_RANGE]")


		if("lightsout")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","LO")
			message_admins("[key_name_admin(usr)] has broke a lot of lights")
			E = new /datum/round_event/electrical_storm{lightsoutAmount = 2}()

		if("blackout")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","BO")
			message_admins("[key_name_admin(usr)] broke all lights")
			for(var/obj/machinery/light/L in machines)
				L.broken()

		if("whiteout")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","WO")
			message_admins("[key_name_admin(usr)] fixed all lights")
			for(var/obj/machinery/light/L in machines)
				L.fix()

		if("floorlava")
			if(!check_rights(R_FUN))
				return
			if(floorIsLava)
				usr << "The floor is lava already."
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","LF")

			//Options
			var/length = input(usr, "How long will the lava last? (in seconds)", "Length", 180) as num
			length = min(abs(length), 1200)

			var/damage = input(usr, "How deadly will the lava be?", "Damage", 2) as num
			damage = min(abs(damage), 100)

			var/sure = alert(usr, "Are you sure you want to do this?", "Confirmation", "YES!", "Nah")
			if(sure == "Nah")
				return
			floorIsLava = 1

			message_admins("[key_name_admin(usr)] made the floor LAVA! It'll last [length] seconds and it will deal [damage] damage to everyone.")

			for(var/turf/simulated/floor/F in world)
				if(F.z == ZLEVEL_STATION)
					F.name = "lava"
					F.desc = "The floor is LAVA!"
					F.overlays += "lava"
					F.lava = 1

			spawn(0)
				for(var/i = i, i < length, i++) // 180 = 3 minutes
					if(damage)
						for(var/mob/living/carbon/L in living_mob_list)
							if(istype(L.loc, /turf/simulated/floor)) // Are they on LAVA?!
								var/turf/simulated/floor/F = L.loc
								if(F.lava)
									var/safe = 0
									for(var/obj/structure/O in F.contents)
										if(O.level > F.level && !istype(O, /obj/structure/window)) // Something to stand on and it isn't under the floor!
											safe = 1
											break
									if(!safe)
										L.adjustFireLoss(damage)


					sleep(10)

				for(var/turf/simulated/floor/F in world) // Reset everything.
					if(F.z == ZLEVEL_STATION)
						F.name = initial(F.name)
						F.desc = initial(F.desc)
						F.overlays.Cut()
						F.lava = 0
						F.update_icon()
				floorIsLava = 0
			return

		if("virus")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","V")
			switch(alert("Do you want this to be a random disease or do you have something in mind?",,"Make Your Own","Random","Choose"))
				if("Make Your Own")
					AdminCreateVirus(usr.client)
				if("Random")
					E = new /datum/round_event/disease_outbreak()
				if("Choose")
					var/virus = input("Choose the virus to spread", "BIOHAZARD") as null|anything in typesof(/datum/disease)
					E = new /datum/round_event/disease_outbreak{}()
					var/datum/round_event/disease_outbreak/DO = E
					DO.virus_type = virus

		if("retardify")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","RET")
			for(var/mob/living/carbon/human/H in player_list)
				H << "<span class='boldannounce'>You suddenly feel stupid.</span>"
				H.setBrainLoss(60)
			message_admins("[key_name_admin(usr)] made everybody retarded")

		if("eagles")//SCRAW
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","EgL")
			for(var/obj/machinery/door/airlock/W in machines)
				if(W.z == ZLEVEL_STATION && !istype(get_area(W), /area/bridge) && !istype(get_area(W), /area/crew_quarters) && !istype(get_area(W), /area/security/prison))
					W.req_access = list()
			message_admins("[key_name_admin(usr)] activated Egalitarian Station mode")
			priority_announce("Centcom airlock control override activated. Please take this time to get acquainted with your coworkers.", null, 'sound/AI/commandreport.ogg')

		if("guns")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","SG")
			var/survivor_probability = 0
			switch(alert("Do you want this to create survivors antagonists?",,"No Antags","Some Antags","All Antags!"))
				if("Some Antags")
					survivor_probability = 25
				if("All Antags!")
					survivor_probability = 100

			rightandwrong(0, usr, survivor_probability)

		if("magic")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","SM")
			var/survivor_probability = 0
			switch(alert("Do you want this to create survivors antagonists?",,"No Antags","Some Antags","All Antags!"))
				if("Some Antags")
					survivor_probability = 25
				if("All Antags!")
					survivor_probability = 100

			rightandwrong(1, usr, survivor_probability)

		if("events")
			if(!check_rights(R_FUN))
				return
			if(!SSevent.wizardmode)
				if(alert("Do you want to toggle summon events on?",,"Yes","No") == "Yes")
					summonevents()
					feedback_inc("admin_secrets_fun_used",1)
					feedback_add_details("admin_secrets_fun_used","SE")

			else
				switch(alert("What would you like to do?",,"Intensify Summon Events","Turn Off Summon Events","Nothing"))
					if("Intensify Summon Events")
						summonevents()
						feedback_inc("admin_secrets_fun_used",1)
						feedback_add_details("admin_secrets_fun_used","SE")
					if("Turn Off Summon Events")
						SSevent.toggleWizardmode()
						SSevent.resetFrequency()

		if("dorf")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","DF")
			for(var/mob/living/carbon/human/B in mob_list)
				B.facial_hair_style = "Dward Beard"
				B.update_hair()
			message_admins("[key_name_admin(usr)] activated dorf mode")

		if("onlyone")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","OO")
			usr.client.only_one()
//				message_admins("[key_name_admin(usr)] has triggered a battle to the death (only one)")

		if("onlyme")
			if(!check_rights(R_FUN))
				return
			feedback_inc("admin_secrets_fun_used",1)
			feedback_add_details("admin_secrets_fun_used","OM")
			only_me()

		if("maint_access_brig")
			if(!check_rights(R_DEBUG))
				return
			for(var/obj/machinery/door/airlock/maintenance/M in machines)
				M.check_access()
				if (access_maint_tunnels in M.req_access)
					M.req_access = list(access_brig)
			message_admins("[key_name_admin(usr)] made all maint doors brig access-only.")

		if("maint_access_engiebrig")
			if(!check_rights(R_DEBUG))
				return
			for(var/obj/machinery/door/airlock/maintenance/M in machines)
				M.check_access()
				if (access_maint_tunnels in M.req_access)
					M.req_access = list()
					M.req_one_access = list(access_brig,access_engine)
			message_admins("[key_name_admin(usr)] made all maint doors engineering and brig access-only.")

		if("infinite_sec")
			if(!check_rights(R_DEBUG))
				return
			var/datum/job/J = SSjob.GetJob("Security Officer")
			if(!J) return
			J.total_positions = -1
			J.spawn_positions = -1
			message_admins("[key_name_admin(usr)] has removed the cap on security officers.")

		if("show_whitelist")
			if(!check_rights(R_PERMISSIONS))
				return
			establish_db_connection()
			if (!dbcon.IsConnected())
				return
			var/dat = "<B>Current ckeys that are whitelisted:</B><HR>"
			var/DBQuery/query_check_ckey = dbcon.NewQuery("SELECT `ckey`, `computerid_1`, `computerid_2`, `computerid_3`, `datetime_1`, `datetime_2`, `datetime_3` FROM [format_table_name("spoof_check")] WHERE whitelist = '1'")
			if(query_check_ckey.Execute())
				while(query_check_ckey.NextRow())
					dat += "ckey:&ensp;[query_check_ckey.item[1]]<br>&emsp;cid_1:&ensp;[query_check_ckey.item[2]]&emsp;date:&ensp;[query_check_ckey.item[5]]<br>&emsp;cid_2:&ensp;[query_check_ckey.item[3]]&emsp;date:&ensp;[query_check_ckey.item[6]]<br>&emsp;cid_3:&ensp;[query_check_ckey.item[4]]&emsp;date:&ensp;[query_check_ckey.item[7]]<br>"
				usr << browse(dat, "window=showwhitelist;size=600x500")

	if(E)
		E.processing = 0
		if(E.announceWhen>0)
			if(alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No") == "No")
				E.announceWhen = -1
		E.processing = 1
	if (usr)
		log_admin("[key_name(usr)] used secret [item]")
		if (ok)
			world << text("<B>A secret has been activated by []!</B>", usr.key)