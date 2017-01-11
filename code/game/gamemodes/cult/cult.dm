//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/datum/game_mode
	var/list/datum/mind/cult = list()
	var/list/cult_objectives = list()


/proc/iscultist(mob/living/M)
	return istype(M) && M.mind && ticker && ticker.mode && (M.mind in ticker.mode.cult)

/proc/is_sacrifice_target(datum/mind/mind)
	if(ticker.mode.name == "cult")
		var/datum/game_mode/cult/cult_mode = ticker.mode
		if(mind == cult_mode.sacrifice_target)
			return 1
	return 0

/proc/is_convertable_to_cult(datum/mind/mind)
	if(!istype(mind))	return 0
	if(!istype(mind.current, /mob/living/carbon)) return 0
	if(istype(mind.current, /mob/living/carbon/human) && (mind.assigned_role in list("Captain", "Chaplain")))	return 0
	if(jobban_isbanned(mind.current, "catban")) return 0
	if(jobban_isbanned(mind.current, "cluwneban")) return 0
	if(isloyal(mind.current))
		return 0
	if (ticker.mode.name == "cult")		//redundent?
		if(is_sacrifice_target(mind))	return 0
	return 1

/proc/cultist_commune(mob/living/user, clear = 0, say = 0, message)
	if(!message)
		return
	if(say)
		user.say("O bidai nabora se[pick("'","`")]sma!")
	else
		user.whisper("O bidai nabora se[pick("'","`")]sma!")
	sleep(10)
	if(!user)
		return
	if(say)
		user.say(message)
	else
		user.whisper(message)
	for(var/mob/M in mob_list)
		if(iscultist(M) || (M in dead_mob_list))
			if(clear || !ishuman(user))
				M << "<span class='boldannounce'><i>[(ishuman(user) ? "Acolyte" : "Construct")] [user]:</i> [message]</span>"
			else //Emergency comms
				M << "<span class='ghostalert'><i>Acolyte ???:</i> [message]</span>"
	log_say("[user.real_name]/[user.key] : [message]")



/datum/game_mode/cult
	name = "cult"
	config_tag = "cult"
	antag_flag = ROLE_CULTIST
	restricted_jobs = list("Chaplain","AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel")
	protected_jobs = list()
	required_players = 20
	required_enemies = 6
	recommended_enemies = 6
	enemy_minimum_age = 14


	var/finished = 0

	var/eldergod = 1 //for the summon god objective

	var/acolytes_needed = 10 //for the survive objective
	var/acolytes_survived = 0

	var/datum/mind/sacrifice_target = null//The target to be sacrificed


/datum/game_mode/cult/announce()
	world << "<B>The current game mode is - Cult!</B>"
	world << "<B>Some crewmembers are attempting to start a cult!<BR>\nCultists - complete your objectives. Convert crewmembers to your cause by using the convert rune. Remember - there is no you, there is only the cult.<BR>\nPersonnel - Do not let the cult succeed in its mission. Brainwashing them with the chaplain's bible reverts them to whatever Centcom-allowed faith they had.</B>"


/datum/game_mode/cult/pre_setup()
	if(prob(50))
		cult_objectives += "survive"
		cult_objectives += "sacrifice"
	else
		cult_objectives += "eldergod"
		cult_objectives += "sacrifice"

	if(num_players() >= 30)
		recommended_enemies = 9	// 3+3+3 - d' magic number o' magic numbars mon
		acolytes_needed = 15

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	acolytes_needed = round(num_players()/5,1) //Scales the escape requirement with the amount of people in the round; for every 5 players, one cultist added to the count, i.e. 25 players = 5 to escape
	acolytes_needed = Clamp(acolytes_needed, 1, 15) //Max at 15 and minimum at 1 - before the update, people rarely got even 15

	for(var/cultists_number = 1 to recommended_enemies)
		if(!antag_candidates.len)
			break
		var/datum/mind/cultist = pick(antag_candidates)
		antag_candidates -= cultist
		cult += cultist
		cultist.special_role = "Cultist"
		cultist.restricted_roles = restricted_jobs
		log_game("[cultist.key] (ckey) has been selected as a cultist")

	return (cult.len>=required_enemies)


/datum/game_mode/cult/post_setup()
	modePlayer += cult
	if("sacrifice" in cult_objectives)
		var/list/possible_targets = get_unconvertables()

		if(!possible_targets.len)
			message_admins("Cult Sacrifice: Could not find unconvertable target, checking for convertable target.")
			for(var/mob/living/carbon/human/player in player_list)
				if(player.mind && !(player.mind in cult))
					possible_targets += player.mind

		if(possible_targets.len > 0)
			sacrifice_target = pick(possible_targets)
			if(!sacrifice_target)
				message_admins("Cult Sacrifice: ERROR -  Null target chosen!")
		else
			message_admins("Cult Sacrifice: Could not find unconvertable or convertable target. WELP!")

	for(var/datum/mind/cult_mind in cult)
		equip_cultist(cult_mind.current)
		update_cult_icons_added(cult_mind)
		cult_mind.current << "<span class='userdanger'>You are a member of the cult!</span>"
		cult_mind.current << "<a href=[config.wikiurl]/index.php?title=Cult_Basics>First time cultist? Click here to be linked to the wiki guide on cultists.</a>"
		memorize_cult_objectives(cult_mind)
	..()


/datum/game_mode/cult/proc/memorize_cult_objectives(datum/mind/cult_mind)
	for(var/obj_count = 1,obj_count <= cult_objectives.len,obj_count++)
		var/explanation
		switch(cult_objectives[obj_count])
			if("survive")
				explanation = "Our knowledge must live on. Make sure at least [acolytes_needed] acolytes escape on the shuttle to spread their work on an another station."
			if("sacrifice")
				if(sacrifice_target)
					explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. You will need the Sacrifice rune and three acolytes to do so."
				else
					explanation = "Free objective."
			if("eldergod")
				explanation = "Summon Nar-Sie via the rune 'Call Forth The Geometer'. It will only work if nine acolytes stand on and around it."
		cult_mind.current << "<B>Objective #[obj_count]</B>: [explanation]"
		cult_mind.memory += "<B>Objective #[obj_count]</B>: [explanation]<BR>"

/datum/game_mode/proc/equip_cultist(mob/living/carbon/human/mob)
	if(!istype(mob))
		return
	mob.cult_add_comm()
	if (mob.mind)
		if (mob.mind.assigned_role == "Clown")
			mob << "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself."
			mob.dna.remove_mutation(CLOWNMUT)


	var/obj/item/weapon/paper/talisman/supply/T = new(mob)
	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)
	var/where = mob.equip_in_one_of_slots(T, slots)
	if(!where)
		mob << "Unfortunately, you weren't able to get a talisman. This is very bad and you should adminhelp immediately."
	else
		mob << "<span class='danger'>You have a talisman in your [where], one that will help you start the cult on this station. Use it well, and remember - you are not the only one.</span>"
		mob.update_icons()
		if(where == "backpack")
			var/obj/item/weapon/storage/B = mob.back
			B.orient2hud(mob)
			B.show_to(mob)
		return 1


/datum/game_mode/proc/add_cultist(datum/mind/cult_mind) //BASE
	if (!istype(cult_mind))
		return 0
	if(!(cult_mind in cult) && is_convertable_to_cult(cult_mind))
		cult_mind.current.Paralyse(5)
		cult += cult_mind
		cult_mind.current.cult_add_comm()
		cult_mind.special_role = "Cultist"
		update_cult_icons_added(cult_mind)
		cult_mind.current.attack_log += "\[[time_stamp()]\] <span class='danger'>Has been converted to the cult!</span>"
		return 1


/datum/game_mode/cult/add_cultist(datum/mind/cult_mind) //INHERIT
	if (!..(cult_mind))
		return
	memorize_cult_objectives(cult_mind)


/datum/game_mode/proc/remove_cultist(datum/mind/cult_mind, show_message = 1)
	if(cult_mind in cult)
		cult -= cult_mind
		cult_mind.current.verbs -= /mob/living/proc/cult_innate_comm
		cult_mind.current.Paralyse(5)
		cult_mind.current << "<span class='userdanger'>An unfamiliar white light flashes through your mind, cleansing the taint of the Dark One and all your memories as its servant.</span>"
		cult_mind.memory = ""
		update_cult_icons_removed(cult_mind)
		cult_mind.current.attack_log += "\[[time_stamp()]\] <span class='danger'>Has renounced the cult!</span>"
		if(show_message)
			for(var/mob/M in viewers(cult_mind.current))
				M << "<span class='big'>[cult_mind.current] looks like they just reverted to their old faith!</span>"

/datum/game_mode/proc/update_cult_icons_added(datum/mind/cult_mind)
	var/datum/atom_hud/antag/culthud = huds[ANTAG_HUD_CULT]
	culthud.join_hud(cult_mind.current)
	set_antag_hud(cult_mind.current, "cult")

/datum/game_mode/proc/update_cult_icons_removed(datum/mind/cult_mind)
	var/datum/atom_hud/antag/culthud = huds[ANTAG_HUD_CULT]
	culthud.leave_hud(cult_mind.current)
	set_antag_hud(cult_mind.current, null)

/datum/game_mode/cult/proc/get_unconvertables()
	var/list/ucs = list()
	for(var/mob/living/carbon/human/player in player_list)
		if(player.mind && !is_convertable_to_cult(player.mind))
			ucs += player.mind
	return ucs


/datum/game_mode/cult/proc/check_cult_victory()
	var/cult_fail = 0
	if(cult_objectives.Find("survive"))
		cult_fail += check_survive() //the proc returns 1 if there are not enough cultists on the shuttle, 0 otherwise
	if(cult_objectives.Find("eldergod"))
		cult_fail += eldergod //1 by default, 0 if the elder god has been summoned at least once
	if(cult_objectives.Find("sacrifice"))
		if(sacrifice_target && !sacrificed.Find(sacrifice_target)) //if the target has been sacrificed, ignore this step. otherwise, add 1 to cult_fail
			cult_fail++

	return cult_fail //if any objectives aren't met, failure


/datum/game_mode/cult/proc/check_survive()
	acolytes_survived = 0
	for(var/datum/mind/cult_mind in cult)
		if (cult_mind.current && cult_mind.current.stat != DEAD)
			if(cult_mind.current.onCentcom() || cult_mind.current.onSyndieBase())
				acolytes_survived++
	if(acolytes_survived>=acolytes_needed)
		return 0
	else
		return 1


/datum/game_mode/cult/declare_completion()

	if(!check_cult_victory())
		feedback_set_details("round_end_result","win - cult win")
		feedback_set("round_end_result",acolytes_survived)
		world << "<span class='greentext'>The cult wins! It has succeeded in serving its dark master!</span>"
	else
		feedback_set_details("round_end_result","loss - staff stopped the cult")
		feedback_set("round_end_result",acolytes_survived)
		world << "<span class='redtext'>The staff managed to stop the cult!</span>"

	var/text = ""

	if(cult_objectives.len)
		text += "<br><b>The cultists' objectives were:</b>"
		for(var/obj_count=1, obj_count <= cult_objectives.len, obj_count++)
			var/explanation
			switch(cult_objectives[obj_count])
				if("survive")
					if(!check_survive())
						explanation = "Make sure at least [acolytes_needed] acolytes escape on the shuttle. ([acolytes_survived] escaped) <span class='greenannounce'>Success!</span>"
						feedback_add_details("cult_objective","cult_survive|SUCCESS|[acolytes_needed]")
					else
						explanation = "Make sure at least [acolytes_needed] acolytes escape on the shuttle. ([acolytes_survived] escaped) <span class='boldannounce'>Fail.</span>"
						feedback_add_details("cult_objective","cult_survive|FAIL|[acolytes_needed]")
				if("sacrifice")
					if(sacrifice_target)
						if(sacrifice_target in sacrificed)
							explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. <span class='greenannounce'>Success!</span>"
							feedback_add_details("cult_objective","cult_sacrifice|SUCCESS")
						else if(sacrifice_target && sacrifice_target.current)
							explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. <span class='boldannounce'>Fail.</span>"
							feedback_add_details("cult_objective","cult_sacrifice|FAIL")
						else
							explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. <span class='boldannounce'>Fail (Gibbed).</span>"
							feedback_add_details("cult_objective","cult_sacrifice|FAIL|GIBBED")
				if("eldergod")
					if(!eldergod)
						explanation = "Summon Nar-Sie. <span class='greenannounce'>Success!</span>"
						feedback_add_details("cult_objective","cult_narsie|SUCCESS")
					else
						explanation = "Summon Nar-Sie. <span class='boldannounce'>Fail.</span>"
						feedback_add_details("cult_objective","cult_narsie|FAIL")
			text += "<br><B>Objective #[obj_count]</B>: [explanation]"

	world << text
	..()
	return 1


/datum/game_mode/proc/auto_declare_completion_cult()
	if( cult.len || (ticker && istype(ticker.mode,/datum/game_mode/cult)) )
		var/text = "<br><font size=3><b>The cultists were:</b></font>"
		for(var/datum/mind/cultist in cult)
			text += printplayer(cultist)

		text += "<br>"

		world << text
