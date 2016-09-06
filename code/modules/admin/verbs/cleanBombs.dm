/client/proc/cleanBombs(mob/C in mob_list)
	set name = "Clean Bombs"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN))
		return
	if(!C || !C.ckey)
		return

	var/confirm = alert(usr, "Do you want to deactivate [C.name]'s bombs?", "Confirm", "Yes", "No")
	if(confirm == "No")
		return


	if(!C.ckey)
		usr << "<span class='danger'>Error, mob no longer has a ckey.</span>"
		return
	var/bomber = C.ckey
	var/count = 0
	var/tainted = 0

	for(var/obj/item/device/transfer_valve/bomb in ttv)
		tainted = 0
		for(var/fingerprints in bomb.fingerprintshidden)
			if(findtext(fingerprints, bomber))
				tainted = 1
				break

		if(!tainted)
			continue

		if(bomb.tank_one)
			bomb.tank_one.air_contents.oxygen = 0
			bomb.tank_one.air_contents.nitrogen = 0
			bomb.tank_one.air_contents.toxins = 0
			bomb.tank_one.air_contents.carbon_dioxide = 0
			bomb.tank_one.air_contents.temperature = T20C
			clearlist(bomb.tank_one.air_contents.trace_gases)
		if(bomb.tank_two)
			bomb.tank_two.air_contents.oxygen = 0
			bomb.tank_two.air_contents.nitrogen = 0
			bomb.tank_two.air_contents.toxins = 0
			bomb.tank_two.air_contents.carbon_dioxide = 0
			bomb.tank_two.air_contents.temperature = T20C
			clearlist(bomb.tank_two.air_contents.trace_gases)
		count++

	log_admin("[usr.name]([usr.ckey]) has deactivated [C.name]([bomber])'s bombs. [count] bombs were affected.")
	message_admins("[usr.name]([usr.ckey]) has deactivated [C.name]([bomber])'s bombs. [count] bombs were affected.")
	feedback_add_details("admin_verb","CB")  //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
