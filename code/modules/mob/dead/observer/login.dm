/mob/dead/observer/Login()
	..()
	if(client.prefs.unlock_content)
		icon_state = client.prefs.ghost_form
		if (ghostimage)
			ghostimage.icon_state = src.icon_state
	ghost_orbit = client.prefs.ghost_orbit

	updateghostimages()


	update_interface()