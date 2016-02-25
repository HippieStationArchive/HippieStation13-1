/datum/action/innate/godspeak
	name = "Godspeak"
	button_icon_state = "godspeak"
	action_type = AB_INNATE
	check_flags = AB_CHECK_ALIVE
	var/list/datum/mind/gods = list()

/datum/action/innate/godspeak/IsAvailable()
	if(..())
		if(gods.len)
			return 1
		gods = get_team_gods(is_in_any_team(owner.mind)) // so it'll refresh automatically everytime you click to check if there are new gods
		return 0

/datum/action/innate/godspeak/Activate()
	active = 1
	var/msg = input(owner,"Speak to your [gods.len > 1 ? "gods" : "god"]","Godspeak","") as null|text
	if(!msg)
		return
	for(var/mob/camera/god/god in gods)
		god << "<span class='notice'><B>[owner]:</B> [msg]</span>"
	owner << "You say: [msg]"
	active = 0