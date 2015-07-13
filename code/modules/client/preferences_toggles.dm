//toggles
/client/verb/toggle_ghost_ears()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob speech, and only speech of nearby mobs"
	prefs.toggles ^= CHAT_GHOSTEARS
	src << "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_sight()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob emotes, and only emotes of nearby mobs"
	prefs.toggles ^= CHAT_GHOSTSIGHT
	src << "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_whispers()
	set name = "Show/Hide GhostWhispers"
	set category = "Preferences"
	set desc = ".Toggle between hearing all whispers, and only whispers of nearby mobs"
	prefs.toggles ^= CHAT_GHOSTWHISPER
	src << "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTWHISPER) ? "see all whispers in the world" : "only see whispers from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Show/Hide RadioChatter"
	set category = "Preferences"
	set desc = "Toggle seeing radiochatter from nearby radios and speakers"
	if(!holder) return
	prefs.toggles ^= CHAT_RADIO
	prefs.save_preferences()
	usr << "You will [(prefs.toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from nearby radios or speakers"
	feedback_add_details("admin_verb","THR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences"
	set desc = "Toggle hearing a notification when admin PMs are recieved"
	if(!holder)	return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	usr << "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive."
	feedback_add_details("admin_verb","AHS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc ="Toggles seeing deadchat"
	prefs.toggles ^= CHAT_DEAD
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat."
	feedback_add_details("admin_verb","TDV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences"
	set desc = "Toggles seeing prayers"
	prefs.toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat."
	feedback_add_details("admin_verb","TP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/togglePRs()
	set name = "Show/Hide Pull Request Announcements"
	set category = "Preferences"
	set desc = "Toggles receiving a notification when new pull requests are created."
	prefs.toggles ^= CHAT_PULLR
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_PULLR) ? "now" : "no longer"] see new pull request announcements."
	feedback_add_details("admin_verb","TPullR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		src << "You will now hear music in the game lobby."
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		src << "You will no longer hear music in the game lobby."
		if(istype(mob, /mob/new_player))
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jamsz
	feedback_add_details("admin_verb","TLobby") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/togglemidis()
	set name = "Hear/Silence Midis and Sound Files"
	set category = "Preferences"
	set desc = "Toggles hearing sounds uploaded by admins"
	prefs.toggles ^= SOUND_MIDI
	prefs.save_preferences()
	if(prefs.toggles & SOUND_MIDI)
		src << "You will now hear any sounds uploaded by admins."
		if(admin_sound)
			src << admin_sound
	else
		src << "You will no longer hear sounds uploaded by admins; any currently playing sound files and midis have been disabled."
		if(admin_sound && !(admin_sound.status & SOUND_PAUSED))
			admin_sound.status |= SOUND_PAUSED
			src << admin_sound
			admin_sound.status ^= SOUND_PAUSED
	feedback_add_details("admin_verb","TMidi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles seeing OutOfCharacter chat"
	prefs.toggles ^= CHAT_OOC
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel."
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"
	prefs.toggles ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles & SOUND_AMBIENCE)
		src << "You will now hear ambient sounds."
	else
		src << "You will no longer hear ambient sounds."
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb","TAmbi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//be special
/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."
	var/role_flag = be_special_flags[role]
	if(!role_flag)	return
	prefs.be_special ^= role_flag
	prefs.save_preferences()
	src << "You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible)."
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_member_publicity()
	set name = "Toggle Membership Publicity"
	set category = "Preferences"
	set desc = "Toggles whether other players can see that you are a BYOND member (OOC blag icon/colours)."
	prefs.toggles ^= MEMBER_PUBLIC
	prefs.save_preferences()
	src << "Others can[(prefs.toggles & MEMBER_PUBLIC) ? "" : "not"] see whether you are a byond member."

var/list/ghost_forms = list("ghost","ghostking","ghostian2","ghost_red","ghost_black", \
							"ghost_blue","ghost_yellow","ghost_green","ghost_pink", \
							"ghost_cyan","ghost_dblue","ghost_dred","ghost_dgreen", \
							"ghost_dcyan","ghost_grey","ghost_dyellow","ghost_dpink")
/client/verb/pick_form()
	set name = "Choose Ghost Form"
	set category = "Preferences"
	set desc = "Choose your preferred ghostly appearance."
	if(!is_content_unlocked())	return
	var/new_form = input(src, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in ghost_forms
	if(new_form)
		prefs.ghost_form = new_form
		prefs.save_preferences()
		if(istype(mob,/mob/dead/observer))
			mob.icon_state = new_form

/client/verb/toggle_intent_style()
	set name = "Toggle Intent Selection Style"
	set category = "Preferences"
	set desc = "Toggle between directly clicking the desired intent or clicking to rotate through."
	prefs.toggles ^= INTENT_STYLE
	src << "[(prefs.toggles & INTENT_STYLE) ? "Clicking directly on intents selects them." : "Clicking on intents rotates selection clockwise."]"
	prefs.save_preferences()
	feedback_add_details("admin_verb","ITENTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_autothrow() //For grenades
	set name = "Enable/disable autothrow"
	set category = "Preferences"
	set desc = "Toggles whether or not your intent will be set to throw when you arm grenades"
	prefs.toggles ^= INTENT_AUTOTHROW
	prefs.save_preferences()
	src << "You will [(prefs.toggles & INTENT_AUTOTHROW) ? "now" : "no longer"] have your intent set to throw when you arm grenades/etc."
	feedback_add_details("admin_verb","TAutoThrow") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_vox() //For grenades
	set name = "Enable/disable Vox"
	set category = "Preferences"
	set desc = "Toggles whether or not you will hear Vox messages."
	prefs.toggles ^= SOUND_VOX
	prefs.save_preferences()
	src << "You will [(prefs.toggles & SOUND_VOX) ? "no longer" : "now"] hear Vox."
	feedback_add_details("admin_verb","TVox") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
		//Nigger code that doesn't fucking work.... ~Nexendia
// This needs a toggle because you people are awful and spammed terrible music //Nigga I just want this cause I hate fun  ~Nexendia
/client/verb/toggle_instruments()
	set name = "Hear/Silence Instruments"
	set category = "Preferences"
	set desc = "Toggles hearing musical instruments like the violin and piano"
	prefs.toggles ^= SOUND_INSTRUMENTS
	prefs.save_preferences()
	src << "You will [(prefs.toggles & SOUND_INSTRUMENTS) ? "no longer" : "now"] hear Instruments."
	feedback_add_details("admin_verb","TInstru") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

*/