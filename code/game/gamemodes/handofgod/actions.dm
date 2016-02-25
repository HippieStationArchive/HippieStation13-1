/datum/action/innate/godspeak
	name = "Godspeak"
	button_icon_state = "godspeak"
	check_flags = AB_CHECK_ALIVE
	var/list/datum/mind/gods = list()

/datum/action/innate/godspeak/IsAvailable()
	if(..())
		if(gods.len)
			return 1
		return 0

/datum/action/innate/godspeak/Activate()
	var/msg = input(owner,"Speak to your [gods.len > 1 ? "gods" : "god"]","Godspeak","") as null|text
	if(!msg)
		return
	for(var/datum/mind/god in gods)
		god << "<span class='notice'><B>[owner]:</B> [msg]</span>"
	owner << "You say: [msg]"