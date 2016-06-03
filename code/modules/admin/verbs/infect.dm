/client/proc/infect(mob/living/carbon/human/H in mob_list)
	set name = "Infect"
	set category = "Fun"

	if(!holder || !check_rights(R_FUN))
		return

	var/mob/living/target = H

	if(!ishuman(target))
		usr << "This can only be used on instances of type /mob/living/carbon/human"
		return

	if(alert(usr, "Are you sure you wish to infect [key_name(target)] with the zombie virus",  "Confirm Infection?" , "Yes" , "No") != "Yes")
		return

	if(alert(usr, "Do you want to alert the crew?", "Alert Crew?", "Yes", "No") == "Yes")
		priority_announce("Warning! Priority alert: Level 1 Viral Biohazard detected aboard [station_name()], all personnel please contain the outbreak. Your station is now under quarantine until further notice.", "Major Biohazard Alert")
		world << 'sound/misc/hazdet.ogg'

	if(alert(usr, "Do you want to set the alert level to Delta?", "Confirm Alert Level", "Yes", "No") == "Yes")
		set_security_level("delta")

	//not wotking
	//if(alert(usr, "Do you want to give the AI the quarantine law?", "Confirm Law Set", "Yes", "No") == "Yes")
	//	set_zeroth_law("<span class='danger'>PRIORITY LAW: CONTAIN THE OUTBREAK AT ALL COSTS. QARANTINE IS NOW IN EFFECT.</span>", null)

	log_admin("[usr.key] has infected [H.name]([H.key]) with the zombie virus.")
	message_admins("[usr.key]([usr.name]) has infected [H.key]([H.name]) with the zombie virus!")
	H.oldInfect(H)
