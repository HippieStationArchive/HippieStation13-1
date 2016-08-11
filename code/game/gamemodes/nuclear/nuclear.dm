/datum/game_mode
	var/list/datum/mind/syndicates = list()


/datum/game_mode/nuclear
	name = "nuclear emergency"
	config_tag = "nuclear"
	required_players = 20 // 20 players - 5 players to be the nuke ops = 15 players remaining
	required_enemies = 5
	recommended_enemies = 5
	antag_flag = ROLE_OPERATIVE
	enemy_minimum_age = 14

	var/const/agents_possible = 5 //If we ever need more syndicate agents.

	var/nukes_left = 1 // Call 3714-PRAY right now and order more nukes! Limited offer!
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level
	var/last_name = "Syndicate" //Last name of the syndicates, used for war declarations

/datum/game_mode/nuclear/announce()
	world << "<B>The current game mode is - Nuclear Emergency!</B>"
	world << "<B>A [syndicate_name()] Strike Force is approaching [station_name()]!</B>"
	world << "A nuclear explosive was being transported by Nanotrasen to a military base. The transport ship mysteriously lost contact with Space Traffic Control (STC). About that time a strange disk was discovered around [station_name()]. It was identified by Nanotrasen as a nuclear auth. disk and now Syndicate Operatives have arrived to retake the disk and detonate SS13! Also, most likely Syndicate star ships are in the vicinity so take care not to lose the disk!\n<B>Syndicate</B>: Reclaim the disk and detonate the nuclear bomb anywhere on SS13.\n<B>Personnel</B>: Hold the disk and <B>escape with the disk</B> on the shuttle!"

/datum/game_mode/nuclear/pre_setup()
	var/agent_number = 0
	if(antag_candidates.len > agents_possible)
		agent_number = agents_possible
	else
		agent_number = antag_candidates.len

	var/n_players = num_players()
	if(agent_number > n_players)
		agent_number = n_players/2

	while(agent_number > 0)
		var/datum/mind/new_syndicate = pick(antag_candidates)
		syndicates += new_syndicate
		antag_candidates -= new_syndicate //So it doesn't pick the same guy each time.
		agent_number--

	for(var/datum/mind/synd_mind in syndicates)
		synd_mind.assigned_role = "Syndicate"
		synd_mind.special_role = "Syndicate"//So they actually have a special role/N
		log_game("[synd_mind.key] (ckey) has been selected as a nuclear operative")
	return 1


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_synd_icons_added(datum/mind/synd_mind)
	var/datum/atom_hud/antag/opshud = huds[ANTAG_HUD_OPS]
	opshud.join_hud(synd_mind.current)
	set_antag_hud(synd_mind.current, "synd")

/datum/game_mode/proc/update_synd_icons_removed(datum/mind/synd_mind)
	var/datum/atom_hud/antag/opshud = huds[ANTAG_HUD_OPS]
	opshud.leave_hud(synd_mind.current)
	set_antag_hud(synd_mind.current, null)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/nuclear/post_setup()

	var/list/turf/synd_spawn = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "Syndicate-Spawn")
			synd_spawn += get_turf(A)
			continue

	var/obj/effect/landmark/uplinklocker = locate("landmark*Syndicate-Uplink")	//i will be rewriting this shortly
	var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")

	var/nuke_code = "[rand(10000, 99999)]"
	var/leader_selected = 0
	var/agent_number = 1
	var/spawnpos = 1

	for(var/datum/mind/synd_mind in syndicates)
		if(spawnpos > synd_spawn.len)
			spawnpos = 2
		synd_mind.current.loc = synd_spawn[spawnpos]

		forge_syndicate_objectives(synd_mind)
		greet_syndicate(synd_mind)
		equip_syndicate(synd_mind.current)

		if (nuke_code)
			synd_mind.store_memory("<B>Syndicate Nuclear Bomb Code</B>: [nuke_code]", 0, 0)
			synd_mind.current << "The nuclear authorization code is: <B>[nuke_code]</B>"

		if(!leader_selected)
			prepare_syndicate_leader(synd_mind, nuke_code)
			leader_selected = 1
		else
			synd_mind.current.real_name = "[syndicate_name()] Operative #[agent_number]"
			agent_number++
		spawnpos++
		update_synd_icons_added(synd_mind)

	if(uplinklocker)
		new /obj/structure/closet/syndicate/nuclear(uplinklocker.loc)
	if(nuke_spawn && synd_spawn.len > 0)
		var/obj/machinery/nuclearbomb/the_bomb = new /obj/machinery/nuclearbomb(nuke_spawn.loc)
		the_bomb.r_code = nuke_code

	return ..()


/datum/game_mode/proc/prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	var/leader_title = pick("Czar", "Boss", "Commander", "Chief", "Kingpin", "Director", "Overlord")
	spawn(1)
		NukeNameAssign(nukelastname(synd_mind.current),syndicates) //allows time for the rest of the syndies to be chosen
	synd_mind.current.real_name = "[syndicate_name()] [leader_title]"
	synd_mind.current << "<B>You are the Syndicate [leader_title] for this mission. You are responsible for the distribution of telecrystals and your ID is the only one who can open the launch bay doors.</B>"
	synd_mind.current << "<B>If you feel you are not up to this task, give your ID to another operative.</B>"
	synd_mind.current << "<B>In your hand you will find a special item capable of triggering a greater challenge for your team. Examine it carefully and consult with your fellow operatives before activating it.</B>"

	var/obj/item/device/nuclear_challenge/challenge = new /obj/item/device/nuclear_challenge
	synd_mind.current.equip_to_slot_or_del(challenge, slot_r_hand)

	var/list/foundIDs = synd_mind.current.search_contents_for(/obj/item/weapon/card/id)
	if(foundIDs.len)
		for(var/obj/item/weapon/card/id/ID in foundIDs)
			ID.name = "lead agent card"
			ID.access += access_syndicate_leader
	else
		message_admins("Warning: Nuke Ops spawned without access to leave their spawn area!")

	if (nuke_code)
		var/obj/item/weapon/paper/P = new
		P.info = "The nuclear authorization code is: <b>[nuke_code]</b>"
		P.name = "nuclear bomb code"
		var/mob/living/carbon/human/H = synd_mind.current
		P.loc = H.loc
		H.equip_to_slot_or_del(P, slot_r_hand, 0)
		H.update_icons()
	else
		nuke_code = "code will be provided later"
	return


/datum/game_mode/proc/forge_syndicate_objectives(datum/mind/syndicate)
	var/datum/objective/nuclear/syndobj = new
	syndobj.owner = syndicate
	syndicate.objectives += syndobj


/datum/game_mode/proc/greet_syndicate(datum/mind/syndicate, you_are=1)
	if (you_are)
		syndicate.current << "<span class='notice'>You are a [syndicate_name()] agent!</span>"
		syndicate.current << "<a href=[config.wikiurl]/index.php?title=Syndicate_guide>New to the Syndicate? Click here to be linked to the wiki guide on Nuclear Operatives.</a>"
	var/obj_count = 1
	for(var/datum/objective/objective in syndicate.objectives)
		syndicate.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return


/datum/game_mode/proc/random_radio_frequency()
	return 1337 // WHY??? -- Doohl


/datum/game_mode/proc/equip_syndicate(mob/living/carbon/human/synd_mob, telecrystals = TRUE, reinforcement_to_spawn)

	if(telecrystals)
		synd_mob.equipOutfit(/datum/outfit/syndicate)

	if(reinforcement_to_spawn == "Assault")
		synd_mob.equipOutfit(/datum/outfit/syndicate/no_crystals/assault)

	if(reinforcement_to_spawn == "Hacker")
		synd_mob.equipOutfit(/datum/outfit/syndicate/no_crystals/hacker)

	if(reinforcement_to_spawn == "Infiltrator")
		synd_mob.equipOutfit(/datum/outfit/syndicate/no_crystals/infiltrator)

	if(reinforcement_to_spawn == "Medical")
		synd_mob.equipOutfit(/datum/outfit/syndicate/no_crystals/medical)

	else
		synd_mob.equipOutfit(/datum/outfit/syndicate/no_crystals)
	return 1

/datum/game_mode/nuclear/check_win()
	if (nukes_left == 0)
		return 1
	return ..()


/datum/game_mode/proc/are_operatives_dead()
	for(var/datum/mind/operative_mind in syndicates)
		if (istype(operative_mind.current,/mob/living/carbon/human) && (operative_mind.current.stat!=2))
			return 0
	return 1

/datum/game_mode/nuclear/check_finished() //to be called by ticker
	if(replacementmode && round_converted == 2)
		return replacementmode.check_finished()
	if(SSshuttle.emergency.mode >= SHUTTLE_ENDGAME || station_was_nuked)
		return 1
	if(are_operatives_dead())
		if(bomb_set) //snaaaaaaaaaake! It's not over yet!
			return 0
	..()

/datum/game_mode/nuclear/declare_completion()
	var/disk_rescued = 1
	for(var/obj/item/weapon/disk/nuclear/D in poi_list)
		if(!D.onCentcom())
			disk_rescued = 0
			break
	var/crew_evacuated = (SSshuttle.emergency.mode >= SHUTTLE_ENDGAME)
	//var/operatives_are_dead = is_operatives_are_dead()


	//nukes_left
	//station_was_nuked
	//derp //Used for tracking if the syndies actually haul the nuke to the station	//no
	//herp //Used for tracking if the syndies got the shuttle off of the z-level	//NO, DON'T FUCKING NAME VARS LIKE THIS

	if      (!disk_rescued &&  station_was_nuked && !syndies_didnt_escape)
		feedback_set_details("round_end_result","win - syndicate nuke")
		world << "<FONT size = 3><B>Syndicate Major Victory!</B></FONT>"
		world << "<B>[syndicate_name()] operatives have destroyed [station_name()]!</B>"

	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - syndicate nuke - did not evacuate in time")
		world << "<FONT size = 3><B>Total Annihilation</B></FONT>"
		world << "<B>[syndicate_name()] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !station_was_nuked && nuke_off_station && !syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station")
		world << "<FONT size = 3><B>Crew Minor Victory</B></FONT>"
		world << "<B>[syndicate_name()] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !station_was_nuked && nuke_off_station && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station - did not evacuate in time")
		world << "<FONT size = 3><B>[syndicate_name()] operatives have earned Darwin Award!</B></FONT>"
		world << "<B>[syndicate_name()] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't lose the disk!"

	else if ((disk_rescued || SSshuttle.emergency.mode < SHUTTLE_ENDGAME) && are_operatives_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk secured - syndi team dead")
		world << "<FONT size = 3><B>Crew Major Victory!</B></FONT>"
		world << "<B>The Research Staff has saved the disc and killed the [syndicate_name()] Operatives</B>"

	else if ( disk_rescued )
		feedback_set_details("round_end_result","loss - evacuation - disk secured")
		world << "<FONT size = 3><B>Crew Major Victory</B></FONT>"
		world << "<B>The Research Staff has saved the disc and stopped the [syndicate_name()] Operatives!</B>"

	else if (!disk_rescued && are_operatives_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk not secured")
		world << "<FONT size = 3><B>Syndicate Minor Victory!</B></FONT>"
		world << "<B>The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name()] Operatives!</B>"

	else if (!disk_rescued &&  crew_evacuated)
		feedback_set_details("round_end_result","halfwin - detonation averted")
		world << "<FONT size = 3><B>Syndicate Minor Victory!</B></FONT>"
		world << "<B>[syndicate_name()] operatives recovered the abandoned authentication disk but detonation of [station_name()] was averted.</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !crew_evacuated)
		feedback_set_details("round_end_result","halfwin - interrupted")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Round was mysteriously interrupted!</B>"

	..()
	return


/datum/game_mode/proc/auto_declare_completion_nuclear()
	if( syndicates.len || (ticker && istype(ticker.mode,/datum/game_mode/nuclear)) )
		var/text = "<br><FONT size=3><B>The syndicate operatives were:</B></FONT>"
		var/purchases = ""
		var/TC_uses = 0
		for(var/datum/mind/syndicate in syndicates)
			text += printplayer(syndicate)
			for(var/obj/item/device/uplink/H in world_uplinks)
				if(H && H.uplink_owner && H.uplink_owner==syndicate.key)
					TC_uses += H.used_TC
					purchases += H.purchase_log
		text += "<br>"
		text += "(Syndicates used [TC_uses] TC) [purchases]"
		if(TC_uses==0 && station_was_nuked && !are_operatives_dead())
			text += "<BIG><IMG CLASS=icon SRC=\ref['icons/BadAss.dmi'] ICONSTATE='badass'></BIG>"
		world << text
	return 1


/proc/nukelastname(mob/M) //--All praise goes to NEO|Phyte, all blame goes to DH, and it was Cindi-Kate's idea. Also praise Urist for copypasta ho.
	var/randomname = pick(last_names)
	var/datum/game_mode/nuclear/N = ticker.mode 
	var/newname = copytext(sanitize(input(M,"You are the nuke operative [pick("Czar", "Boss", "Commander", "Chief", "Kingpin", "Director", "Overlord")]. Please choose a last name for your family.", "Name change",randomname)),1,MAX_NAME_LEN)

	if (!newname)
		newname = randomname

	else
		if (newname == "Unknown" || newname == "floor" || newname == "wall" || newname == "rwall" || newname == "_")
			M << "That name is reserved."
			return nukelastname(M)

	if(istype(N))
		N.last_name = capitalize(newname)

	return capitalize(newname)

/proc/NukeNameAssign(lastname,list/syndicates)
	for(var/datum/mind/synd_mind in syndicates)
		var/mob/living/carbon/human/H = synd_mind.current
		synd_mind.name = H.dna.species.random_name(H.gender,0,lastname)
		synd_mind.current.real_name = synd_mind.name
	return

/datum/outfit/syndicate
	name = "Syndicate Operative - Basic"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/weapon/storage/backpack
	ears = /obj/item/device/radio/headset/syndicate/alt
	id = /obj/item/weapon/card/id/syndicate
	belt = /obj/item/weapon/gun/projectile/automatic/pistol
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1)
	r_pocket = /obj/item/weapon/melee/combatknife

	var/tc = 20

/datum/outfit/syndicate/no_crystals
	tc = 0

/datum/outfit/syndicate/no_crystals/assault
	name = "Syndicate Operative - Assault"
	suit =	/obj/item/clothing/suit/space/hardsuit/syndi/elite
	r_hand = /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/ammo_box/magazine/m12g/buckshot=1,\
		/obj/item/ammo_box/magazine/m12g=1,\
		/obj/item/ammo_box/magazine/m12g/stun=1,\
		/obj/item/ammo_box/magazine/m12g/dragon=1)

/datum/outfit/syndicate/no_crystals/hacker
	name = "Syndicate Operative - Hacker"
	suit =	/obj/item/clothing/suit/space/syndicate/black/red
	head = /obj/item/clothing/head/helmet/space/syndicate/black/red
	l_pocket = /obj/item/device/multitool/ai_detect
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/aiModule/syndicate=1,\
		/obj/item/weapon/card/emag=1,\
		/obj/item/device/encryptionkey/binary=1,\
		/obj/item/ammo_box/magazine/m10mm=1,\
		/obj/item/ammo_box/magazine/m10mm=1,\
		/obj/item/weapon/c4=1)

/datum/outfit/syndicate/no_crystals/infiltrator
	name = "Syndicate Operative - Infiltrator"
	suit =	/obj/item/clothing/suit/space/syndicate/black/red
	head = /obj/item/clothing/head/helmet/space/syndicate/black/red
	uniform = /obj/item/clothing/under/chameleon
	shoes = /obj/item/clothing/shoes/sneakers/syndigaloshes
	mask = /obj/item/clothing/mask/gas/voice
	gloves = /obj/item/clothing/gloves/color/yellow
	belt = /obj/item/weapon/storage/belt/utility/full
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/gun/energy/kinetic_accelerator/crossbow=1,\
		/obj/item/weapon/gun/projectile/automatic/pistol=1,\
		/obj/item/ammo_box/magazine/m10mm=1,\
		/obj/item/weapon/card/id/syndicate=1)

/datum/outfit/syndicate/no_crystals/medical
	name = "Syndicate Operative - Medical"
	suit =	/obj/item/clothing/suit/space/syndicate/black/red
	head = /obj/item/clothing/head/helmet/space/syndicate/black/red
	r_hand = /obj/item/weapon/gun/medbeam
	l_hand = /obj/item/weapon/gun/projectile/automatic/l6_saw/toy
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/clothing/shoes/magboots/syndie=1,\
		/obj/item/ammo_box/foambox/riot=1)

/datum/outfit/syndicate/post_equip(mob/living/carbon/human/H)
	var/obj/item/device/radio/R = H.ears
	R.set_frequency(SYND_FREQ)
	R.freqlock = 1

	if(tc)
		var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(H)
		U.hidden_uplink.uplink_owner="[H.key]"
		U.hidden_uplink.uses = tc
		U.hidden_uplink.mode_override = /datum/game_mode/nuclear //Goodies
		H.equip_to_slot_or_del(U, slot_in_backpack)

	var/obj/item/weapon/implant/weapons_auth/W = new/obj/item/weapon/implant/weapons_auth(H)
	W.implant(H)
	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(H)
	E.implant(H)
	H.faction |= "syndicate"
	H.update_icons()
/datum/outfit/syndicate/full
	name = "Syndicate Operative - Full Kit"
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	suit = /obj/item/clothing/suit/space/hardsuit/syndi
	l_pocket = /obj/item/weapon/tank/internals/emergency_oxygen/engi
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol
	belt = /obj/item/weapon/storage/belt/military
	r_hand = /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
	l_hand = /obj/item/weapon/melee/combatknife
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/tank/jetpack/oxygen/harness=1,\
		/obj/item/weapon/pinpointer/nukeop=1)
	tc = 30
/datum/outfit/syndicate/full/post_equip(mob/living/carbon/human/H)
	..()

	var/obj/item/clothing/suit/space/hardsuit/syndi/suit = H.wear_suit
	suit.ToggleHelmet()
	var/obj/item/clothing/head/helmet/space/hardsuit/syndi/helmet = H.head
	helmet.attack_self(H)
	H.internal = H.l_store
