/datum/adminticket
	var/ID = ""
	var/user = ""
	var/uckey
	var/admin = "N/A"
	var/msg = ""
	var/resolved = "No"
	var/permckey = ""
	var/permuser = ""
	var/uID = ""
	var/active = "No"
	var/logs = list()
	var/replying = 0

client/proc/list_ahelps(var/user, var/resolved)
	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	if(resolved)
		user << "Current Ahelps:"
		for(var/datum/adminticket/T in admintickets)
			usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b>LOGS</b>"
			if(T.resolved == "No")
				usr << "	<b>Resolved:</b> [T.resolved] (resolve)"
			else
				usr << "	<b>Resolved:</b> [T.resolved] (unresolve)"
	else
		user << "Current Unresolved Ahelps:"
		for(var/datum/adminticket/T in admintickets)
			if(T.resolved == "No")
				usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
				usr << "	<b>Message:</b> [T.msg]"
				usr << "	<b>Handling Admin:</b> [T.admin]"
				usr << "	<b>Replied To:</b> [T.active]/<b>LOGS</b>"
				if(T.resolved == "No")
					usr << "	<b>Resolved:</b> [T.resolved] (resolve)"
				else
					usr << "	<b>Resolved:</b> [T.resolved] (unresolve)"
client/proc/ahelp_count(var/modifier)
	var/amount
	for(var/datum/adminticket/T in admintickets)
		switch(modifier)
			if(0)
				if(T.resolved == "No")
					amount++
			if(1)
				if(T.resolved == "Yes")
					amount++
			if(2)
				amount++

	return amount


/datum/adminticket/proc/listtickets()
	set category = "Admin"
	set name = "List Adminhelps"
	set desc = "List all current adminhelps"

	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	for(var/datum/adminticket/T in admintickets)
		count++

	if(count < 1)
		usr << "<b>Current Ahelps:</b>"
		usr << "	None"
		return

	usr << "<b>Current Ahelps:</b>"
	for(var/datum/adminticket/T in admintickets)
		usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
		usr << "	<b>Message:</b> [T.msg]"
		usr << "	<b>Handling Admin:</b> [T.admin]"
		usr << "	<b>Replied To:</b> [T.active]/<b>LOGS</b>"
		if(T.resolved == "No")
			usr << "	<b>Resolved:</b> [T.resolved] (resolve)"
		else
			usr << "	<b>Resolved:</b> [T.resolved] (unresolve)"

/datum/adminticket/proc/listunresolvedtickets()
	set category = "Admin"
	set name = "List Unresolved Adminhelps"
	set desc = "List all current unresolved adminhelps"

	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	for(var/datum/adminticket/T in admintickets)
		if(T.resolved =="No")
			count++

	if(count < 1)
		usr << "<b>Current Unresolved Ahelps:</b>"
		usr << "	None"
		return

	usr << "<b>Current Unresolved Ahelps:</b>"
	for(var/datum/adminticket/T in admintickets)
		if(T.resolved == "No")
			usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b>LOGS</b>"
			if(T.resolved == "No")
				usr << "	<b>Resolved:</b> [T.resolved] (resolve)"
			else
				usr << "	<b>Resolved:</b> [T.resolved] (unresolve)"

/client/proc/listhandlingahelp()
	set category = "Admin"
	set name = "View Handling Ahelps"
	set desc = "List all current handling ahelps"

	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	for(var/datum/adminticket/T in admintickets)
		if(T.resolved == "No" && T.admin == src.ckey)
			count++

	if(count < 1)
		usr << "<b>You don't have any ACTIVE ahelps!</b>"
		return

	for(var/datum/adminticket/T in admintickets)
		if(T.resolved == "No" && T.admin == src.ckey)
			usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b>LOGS</b>"
			if(T.resolved == "No")
				usr << "	<b>Resolved:</b> [T.resolved] <A HREF='?change_ahelp=[T.uID];resolve=1'>RESOLVE</A>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] (unresolve)"

/client/proc/createticket(var/player, var/message, var/uckey)
	var/datum/adminticket/A = new()
	A.user = player
	A.msg = message
	A.uckey = uckey
	A.permckey = uckey
	A.permuser = A.user
	admintickets += A
	A.logs += "ADMINHELP:[A.permckey]([A.permuser]: [A.msg]"

	var/index = 0
	for(var/datum/adminticket/T in admintickets)
		index++
		T.ID = index
		T.uID = "[T.permckey][T.ID]"

/client/proc/resolveticket(var/NuID)
	set category = "Admin"
	set name = "Resolve Adminhelp"
	set desc = "Resolve an adminhelp"

	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	if(NuID == "")
		var/tickettodelete = input("Please enter the Unique ID of the ticket that you want to resolve.", "Resolve Adminhelp") as text
		NuID = tickettodelete
	var/pass = 0
	var/datum/adminticket/ticket

	for(var/datum/adminticket/T in admintickets)
		if(T.uID == NuID && T.resolved == "No")
			T.resolved = "Yes"
			ticket = T
			pass = 1

	switch(pass)
		if(1)
			src << "<b>Adminhelp Resolved.</b>"
			message_admins("[src] has resolved [ticket.permckey]'s adminhelp (#[ticket.ID])")
		if(0)
			src << "<b>Error, there were no adminhelps found with that UID.</b>"

/client/verb/resolveticketself()
	set category = "Admin"
	set name = "Resolve My Adminhelp"
	set desc = "Resolve my own adminhelp"

	var/pass = 0
	var/datum/adminticket/ticket

	for(var/datum/adminticket/T in admintickets)
		if(T.permckey == src.ckey && T.resolved != "Yes")
			T.resolved = "Yes"
			ticket = T
			pass = 1

	switch(pass)
		if(1)
			src << "<b>You have resolved your current adminhelp.</b>"
			message_admins("[src] has resolved his adminhelp (#[ticket.ID])")
		if(0)
			src << "<b>Error, you do not have any active adminhelps.</b>"

/datum/adminticket/proc/viewlogs(var/NuID)
	var/dat = "<h3>View Logs for ahelp [NuID]</h3>"
	var/datum/adminticket/ticket

	var/pass = 0

	for(var/datum/adminticket/T in admintickets)
		if(NuID == T.uID)
			ticket = T
			pass = 1

	if(pass == 0)
		src << "Error, log system not found for [NuID]... "
		return

	dat += ticket.logs

	var/datum/browser/popup = new(user, "ahelp logs", ticket.permuser, 500, 500)
	popup.set_content(dat)
	popup.open()

/datum/adminticket/Topic(href, href_list)
	message_admins("PENIS")
	if(href_list["change_ahelp"])
		message_admins("PENIS")
		switch(href_list["resolve"])
			if("1")
				message_admins("PENIS")
			else
				message_admins("WAT")