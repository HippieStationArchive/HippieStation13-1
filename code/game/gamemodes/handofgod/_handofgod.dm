#define CONDUIT_RANGE	15

var/global/list/global_handofgod_traptypes = list()
var/global/list/global_handofgod_structuretypes = list()
var/global/list/global_handofgod_itemtypes = list(/obj/item/weapon/banner, /obj/item/weapon/storage/backpack/bannerpack, /obj/item/clothing/suit/armor/plate/advocate, /obj/item/clothing/head/helmet/plate/advocate, /obj/item/clothing/gloves/plate, /obj/item/clothing/shoes/plate, /obj/item/weapon/claymore/hog)
var/global/list/teams = list("red", "blue") //so it can be accessed by mind.dm

/datum/game_mode/hand_of_god
	name = "hand of god"
	config_tag = "handofgod"
	antag_flag = ROLE_HOG_CULTIST		//Followers use ROLE_HOG_CULTIST, Gods are picked later on with ROLE_HOG_GOD

	required_players = 25
	required_enemies = 8
	recommended_enemies = 8
	restricted_jobs = list("Chaplain","AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel")


	var/list/datum/mind/followers = list()
	var/list/datum/mind/gods = list()


/datum/game_mode/hand_of_god/announce()
	world << "<B>The current game mode is - Hand of God!</B>"
	world << "<B>Two cults are onboard the station, seeking to overthrow the other, and anyone who stands in their way.</B>"
	world << "<B>Followers</B> - Complete your deity's objectives. Convert crewmembers to your cause by using your deity's nexus. Remember - there is no you, there is only the cult."
	world << "<B>Prophets</B> - Command your cult by the will of your deity.  You are a high-value target, so be careful!"
	world << "<B>Personnel</B> - Do not let any cult succeed in its mission. Loyalty implants and holy water will revert them to neutral, hopefully nonviolent crew."


/////////////
//Pre setup//
/////////////

/datum/game_mode/hand_of_god/pre_setup()
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	for(var/F in 1 to recommended_enemies)
		if(!antag_candidates.len)
			break
		var/datum/mind/follower = pick_n_take(antag_candidates)
		followers += follower
		follower.restricted_roles = restricted_jobs
		log_game("[follower.key] (ckey) has been selected as a follower, however teams have not been decided yet.")
//hud creation
	for(var/i in 1 to teams.len)
		huds += teams[i]
		huds[teams[i]] = new/datum/atom_hud/antag()
	return 1

//////////////
//Post Setup//
//////////////

//Pick followers to uplift into gods
/datum/game_mode/hand_of_god/post_setup()

	//Find viable gods
	var/list/god_possibilities = get_players_for_role(ROLE_HOG_GOD)
	god_possibilities &= followers
	if(god_possibilities.len < teams.len) //No candidates? just pick any follower regardless of prefs(We need 1 god per team)
		god_possibilities = followers

	//Make gods
	for(var/i in 1 to teams.len)
		var/datum/mind/god = pick_n_take(god_possibilities)
		if(god)
			gods += god
			add_god(god, teams[i])

	var/overflow = followers.len % teams.len //incase followers.len/teams.len has a remainder
	while(followers.len > overflow)
		for(var/T in teams)
			add_hog_follower(followers[1] , T )
			followers -= followers[1]
	for(var/datum/mind/follower in followers)
		add_hog_follower(follower, teams[rand(1, teams.len)])

	..()

	//Forge objectives
	//This is done here so that both gods exist
	for(var/datum/mind/god in gods)
		ticker.mode.forge_deity_objectives(god)

///////////////////
//Objective Procs//
///////////////////

/datum/game_mode/proc/forge_deity_objectives(datum/mind/deity)
	switch(rand(1,100))
		if(1 to 30)
			var/datum/objective/deicide/deicide = new
			deicide.owner = deity
			deicide.find_target()
			deity.objectives += deicide

			if(!(locate(/datum/objective/escape_followers) in deity.objectives))
				var/datum/objective/escape_followers/recruit = new
				recruit.owner = deity
				deity.objectives += recruit
				recruit.gen_amount_goal(8, 12)

		if(31 to 60)
			var/datum/objective/sacrifice_prophet/sacrifice = new
			sacrifice.owner = deity
			deity.objectives += sacrifice

			if(!(locate(/datum/objective/escape_followers) in deity.objectives))
				var/datum/objective/escape_followers/recruit = new
				recruit.owner = deity
				deity.objectives += recruit
				recruit.gen_amount_goal(8, 12)

		if(61 to 85)
			var/datum/objective/build/build = new
			build.owner = deity
			deity.objectives += build
			build.gen_amount_goal(8, 16)

			var/datum/objective/sacrifice_prophet/sacrifice = new
			sacrifice.owner = deity
			deity.objectives += sacrifice

			if(!(locate(/datum/objective/escape_followers) in deity.objectives))
				var/datum/objective/escape_followers/recruit = new
				recruit.owner = deity
				deity.objectives += recruit
				recruit.gen_amount_goal(8, 12)

		else
			if (!locate(/datum/objective/follower_block) in deity.objectives)
				var/datum/objective/follower_block/block = new
				block.owner = deity
				deity.objectives += block

///////////////
//Greet procs//
///////////////

/datum/game_mode/proc/greet_hog_follower(datum/mind/follower_mind)
	var/text = "You are a follower of the [is_in_any_team(follower_mind.current)] cult's deity!"
	follower_mind.current << "<span class='danger'><B>[text]</B></span>"
	follower_mind.store_memory(text)

/////////////////
//Convert procs//
/////////////////

/datum/game_mode/proc/add_hog_follower(datum/mind/follower_mind, team)
	var/mob/living/carbon/human/H = follower_mind.current
	if(isloyal(H))
		H.visible_message("<span class='danger'>[H]'s loyalty implant blocked the influence of the [team] deity!</span>","<span class='danger'>Your loyalty implant blocked the influence of the [team] deity!</span>")
		return 0
	var/side = is_in_any_team(follower_mind.current)
	if(side)
		H.visible_message("<span class='danger'>[H] already belongs to the [side] deity!</span>", "<span class='userdanger'>Your strong faith has blocked out the conversion attempt by the followers of the [team] deity.</span>")
		return 0
	var/obj/item/weapon/nullrod/N = locate() in H
	if(N)
		H.visible_message("<span class='danger'>A mysterious force prevents [H] to be converted!</span>", "<span class='userdanger'>Your null rod prevented the [team] deity from brainwashing you.</span>")
		return 0

	H.faction["team"] = "[team]"
	follower_mind.current << "<span class='danger'><FONT size = 3>You are now a follower of the [team] deity! Follow your deity's prophet in order to complete your deity's objectives. Convert crewmembers to your cause by using your deity's nexus. And remember - there is no you, there is only the cult.</FONT></span>"
	follower_mind.store_memory("You are now a follower of the [team] deity! Follow your deity's prophet in order to complete your deity's objectives. Convert crewmembers to your cause by using your deity's nexus. And remember - there is no you, there is only the cult.")
	follower_mind.special_role = "Follower"
	update_hog_icons_added(follower_mind, team) // watch out fam, this has to be after special_role gets set to work properly or hud image won't show up
	follower_mind.current.attack_log += "\[[time_stamp()]\] <font color='red'>Has been converted to the [team] follower cult!</font>"
	return 1


/datum/game_mode/proc/add_god(datum/mind/god_mind, team)
	remove_hog_follower(god_mind, announce = 0)
	var/text = ""
	text += "<span class='notice'>You are a deity!</span>"
	text += "<BR>You are a deity and are worshipped by a cult!  You are rather weak right now, but that will change as you gain more followers."
	text += "<BR>You will need to place an anchor to this world, a <b>Nexus</b>, in two minutes.  If you don't, one will be placed immediately below you."
	text += "<BR>Your <b>Follower</b> count determines how many people believe in you and are a part of your cult."
	text += "<BR>Your <b>Nexus Integrity</b> tells you the condition of your nexus.  If your nexus is destroyed, you will die. Place your Nexus on a safe, isolated place, that is still accessible to your followers."
	text += "<BR>Your <b>Faith</b> is used to interact with the world.  This will regenerate on its own, and it goes faster when you have more followers and power pylons."
	text += "<BR>The first thing you should do after placing your nexus is to <b>appoint a prophet</b>.  Only prophets can hear you talk, unless you use an expensive power."
	god_mind.current << text
	god_mind.store_memory(text)
	god_mind.current.attack_log += "\[[time_stamp()]\] <font color='red'>Has been made into a [team] deity!</font>"
	god_mind.special_role = "God"
	if(god_mind.current)
		god_mind.current.become_god(team)
	update_hog_icons_added(god_mind, team)

//////////////////
//Deconvert proc//
//////////////////

/datum/game_mode/proc/remove_hog_follower(datum/mind/follower_mind, announce = 1)//deconverts both
	follower_mind.special_role = null
	if(follower_mind.current)
		var/mob/living/carbon/human/H = follower_mind.current
		var/side = is_in_any_team(H)
		if(side)
			update_hog_icons_removed(follower_mind,side)
			H.faction["team"] = null

	if(announce)
		follower_mind.current.attack_log += "\[[time_stamp()]\] <font color='red'>Has been deconverted from a deity's cult!</font>"
		follower_mind.current.visible_message("<span class='danger'><b>[follower_mind.current]'s mind has been brainwashed!He's no longer a follower!</b></span>", "<span class='danger'><b>You've been brainwashed!You're no longer a follower!</b></span>")

//////////////////
//Mobhelper proc//
//////////////////

/proc/is_in_any_team(mob/A)
	if("team" in A.faction)
		var/side = A.faction["team"]
		return side
	else
		return 0

/proc/get_gods()
	var/list/godlist = list()
	for(var/mob/camera/god/G in mob_list)
		godlist += G
	return godlist

/proc/get_team_god(team)
	var/mob/camera/god/mygod
	var/list/gods = get_gods()
	for(var/mob/camera/god/G in gods)
		if(G.faction["team"] == team)
			mygod = G
			break
	return mygod

/proc/get_team_followers(team = "") // team is a text var like "blue"
	var/list/followers = list()
	for(var/mob/A in mob_list)
		if(is_in_any_team(A) == team)
			if(what_rank(A.mind) == 1)
				followers += A
	return followers

/proc/get_team_prophets(team = "")
	var/list/followers = get_team_followers(team)
	var/list/prophets = list()
	for(var/mob/A in followers)
		if(what_rank(A.mind) == 2)
			prophets += A
	return prophets

/proc/what_rank(datum/mind/A)
	switch(A.special_role)
		if("Follower")
			return 1
		if("Prophet")
			return 2
		if("God")
			return 3
		else
			return 0

//////////////////////
//Roundend Reporting//
//////////////////////


/datum/game_mode/hand_of_god/declare_completion()
	var/text = ""
	for(var/hogteam in teams)
		var/i = 1 //need this for prophet number
		var/datum/mind/god // from here we define various vars which we'll need
		var/list/datum/mind/mypeople = list()
		var/list/datum/mind/myprophets = list()
		var/objectives = ""
		var/win = 1   //did this team do all their objectives? defaults to yes, turns to no if an objective fails

		for(var/datum/mind/G in gods) //here we assign values to said vars
			if(G.faction["team"] == hogteam)
				god = G
		for(var/datum/mind/A in followers)
			if(A.current.faction["team"] == hogteam)
				mypeople += A
		for(var/datum/mind/A in mypeople)
			if(A.special_role == "Prophet")
				myprophets += A
				mypeople -= A // so we will only have normal followers in mypeople list,for later follower listing

		text += "<BR><font size=3 color='red'><B>The [hogteam] cult:</b></font>" //from here we actually used the vars made up here
		text += "<BR><B>[god.key]</B> was the [hogteam] deity, <B>[god.name]</B> ("
		if(god.current)
			if(god.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
		else
			text += "ceased existing"
		text += ")"
		for(var/datum/mind/prophet in myprophets)
			text += "<BR>The [i]/th [hogteam] prophet was <B>[prophet.name]</B> (<B>[prophet.key]</B>) (" // /th is used to make it appear like 1st, 2nd etc, thanks antur i love you
			if(prophet)
				if(prophet.current == DEAD)
					text += "killed"
				else
					text += "survived"
			else
				text += "ceased existing"
			text += "for their beliefs.)"
			i++
		text += "<BR><B>[hogteam] follower count: </B> [mypeople.len]"
		text += "<BR><B>[hogteam] followers:</B>"
		for(var/datum/mind/player in mypeople)
			text += "[player.name] ([player.key])"
		if(god.objectives.len)
			var/count = 1
			for(var/datum/objective/O in god.objectives)
				if(O.check_completion())
					objectives += "<BR><B>Objective #[count]</B>: [O.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("god_objective","[O.type]|SUCCESS")
				else
					objectives += "<BR><B>Objective #[count]</B>: [O.explanation_text] <font color='red'><B>Fail.</B></font>"
					feedback_add_details("god_objective","[O.type]|FAIL")
					win = 0 // looseeeer
				count++
		text += objectives
		if(win)
			text += "<BR><font color='green'><B>The [hogteam] cult and deity were successful!</B></font>"
			feedback_add_details("god_success","SUCCESS")
		else
			text += "<br><font color='red'><B>The [hogteam] cult and deity have failed!</B></font>"
			feedback_add_details("god_success","FAIL")
		text += "<BR>"
	world << text
	..()
	return 1

///////////////
//Hud  update//
///////////////

/datum/game_mode/proc/update_hog_icons_added(datum/mind/hog_mind,side)
	var/hud_key = side
	var/rank = what_rank(hog_mind)
	switch(rank)
		if(1)
			rank = "Follower"
		if(2)
			rank = "Prophet"
		if(3)
			rank = "God"
		else
			rank = 0
	if(hud_key)
		if(!huds[hud_key])
			for(var/i in 1 to teams.len)
				huds += teams[i]
				huds[teams[i]] = new/datum/atom_hud/antag()
		var/datum/atom_hud/antag/hog_hud = huds[hud_key]
		hog_hud.join_hud(hog_mind.current)
		if(rank != "God")
			set_antag_hud(hog_mind.current, "hog-[rank]")
			var/image/holder = new // code used to color our grey hud to the side we want
			var/image/myhud = hog_mind.current.hud_list[ANTAG_HUD]
			holder.appearance = myhud.appearance
			holder.color = "[side]"
			myhud.appearance = holder.appearance

/datum/game_mode/proc/update_hog_icons_removed(datum/mind/hog_mind,side)
	var/hud_key = side
	if(hud_key)
		var/datum/atom_hud/antag/hog_hud = huds[hud_key]
		hog_hud.leave_hud(hog_mind.current)
		set_antag_hud(hog_mind.current,null)
