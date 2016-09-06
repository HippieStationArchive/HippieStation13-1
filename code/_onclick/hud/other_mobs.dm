
/datum/hud/proc/unplayer_hud()
	return

/datum/hud/proc/ghost_hud()
	return

/datum/hud/proc/brain_hud(ui_style = 'icons/mob/screen_midnight.dmi')

	mymob.client.screen = list()
	mymob.client.screen += mymob.client.void

/datum/hud/proc/blob_hud(ui_style = 'icons/mob/screen_midnight.dmi')

	blobpwrdisplay = new /obj/screen()
	blobpwrdisplay.name = "blob power"
	blobpwrdisplay.icon_state = "block"
	blobpwrdisplay.screen_loc = ui_health
	blobpwrdisplay.layer = 20

	blobhealthdisplay = new /obj/screen()
	blobhealthdisplay.name = "blob health"
	blobhealthdisplay.icon_state = "block"
	blobhealthdisplay.screen_loc = ui_internal
	blobhealthdisplay.layer = 20

	mymob.client.screen = list()
	mymob.client.screen += list(blobpwrdisplay, blobhealthdisplay)
	mymob.client.screen += mymob.client.void

/datum/hud/proc/hoggod_hud(ui_style = 'icons/mob/screen_midnight.dmi')
	deity_health_display = new /obj/screen()
	deity_health_display.name = "Nexus Health"
	deity_health_display.icon_state = "deity_nexus"
	deity_health_display.screen_loc = ui_deityhealth
	deity_health_display.layer = 20

	deity_power_display = new /obj/screen()
	deity_power_display.name = "Faith"
	deity_power_display.icon_state = "deity_power"
	deity_power_display.screen_loc = ui_deitypower
	deity_power_display.layer = 20

	deity_follower_display = new /obj/screen()
	deity_follower_display.name = "Followers"
	deity_follower_display.icon_state = "deity_followers"
	deity_follower_display.screen_loc = ui_deityfollowers
	deity_follower_display.layer = 20

	mymob.client.screen = list()
	mymob.client.screen += list(deity_health_display, deity_power_display, deity_follower_display)