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
	var/mob

client/proc/list_ahelps(var/user, var/resolved)
	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	if(resolved)
		user << "Current Ahelps:"
		for(var/datum/adminticket/T in admintickets)
			var/ref_mob = "\ref[T.mob]"
			usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Controls:</b> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>)"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			if(T.resolved == "No")
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

	else
		user << "Current Unresolved Ahelps:"
		for(var/datum/adminticket/T in admintickets)
			if(T.resolved == "No")
				var/ref_mob = "\ref[T.mob]"
				usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
				usr << "	<b>Controls:</b> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>)"
				usr << "	<b>Message:</b> [T.msg]"
				usr << "	<b>Handling Admin:</b> [T.admin]"
				usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
				if(T.resolved == "No")
					usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
				else
					usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

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
	set category = "Admin Help"
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
		var/ref_mob = "\ref[T.mob]"
		usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
		usr << "	<b>Controls:</b> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>)"
		usr << "	<b>Message:</b> [T.msg]"
		usr << "	<b>Handling Admin:</b> [T.admin]"
		usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
		if(T.resolved == "No")
			usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
		else
			usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/datum/adminticket/proc/listunresolvedtickets()
	set category = "Admin Help"
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
			var/ref_mob = "\ref[T.mob]"
			usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Controls:</b> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>)"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			if(T.resolved == "No")
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/client/proc/listhandlingahelp()
	set category = "Admin Help"
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
			var/ref_mob = "\ref[T.mob]"
			usr << "<span class='adminnotice'><b><font color=red>#[T.ID] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Controls:</b> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>)"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			if(T.resolved == "No")
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/client/verb/viewmyahelp()
	set category = "Admin"
	set name = "View my Ahelps"
	set desc = "List your ahelps"

	var/count = 0

	for(var/datum/adminticket/T in admintickets)
		if(T.permckey == src.ckey)
			count++

	if(count < 1)
		usr << "<b>You don't have any ahelps!</b>"
		return

	usr << "<b>Resolved Ahelps</b>"

	var/rpass = 0

	for(var/datum/adminticket/T in admintickets)
		if(T.permckey == src.ckey && T.resolved == "Yes")
			rpass = 1
			usr << "<span class='adminnotice'><b><font color=red>Adminhelp ID: #[T.ID] </font></b></class>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			usr << "	<b>Resolved:</b> [T.resolved]"

	if(rpass == 0)
		usr << "	None"

	usr << "<b>Unresolved Ahelps</b>"

	var/upass = 0

	for(var/datum/adminticket/T in admintickets)
		if(T.permckey == src.ckey && T.resolved == "No")
			upass = 1
			usr << "<span class='adminnotice'><b><font color=red>Adminhelp ID: #[T.ID] </font></b></class>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			usr << "	<b>Resolved:</b> [T.resolved]"

	if(upass == 0)
		usr << "	None"

/client/proc/createticket(var/player, var/message, var/uckey, var/mob)
	var/datum/adminticket/A = new()
	A.user = player
	A.msg = message
	A.uckey = uckey
	A.permckey = uckey
	A.permuser = A.user
	admintickets += A
	A.logs += "<b>ADMINHELP:</b> [A.permckey]([A.permuser]): [A.msg]"
	A.mob = mob

	var/index = 0
	for(var/datum/adminticket/T in admintickets)
		index++
		T.ID = index
		T.uID = "[T.permckey][T.ID]"

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

/client/proc/resolvehandlingahelp()
	set category = "Admin Help"
	set name = "Resolve Handling Ahelp"
	set desc = "Resolve my own adminhelp"

	if(!check_rights(R_BAN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	var/datum/adminticket/ticket

	for(var/datum/adminticket/T in admintickets)
		if(T.admin == src.ckey && T.resolved != "Yes")
			count++
			ticket = T

	if(count >= 1)
		usr << "<b>Adminhelp #[ticket.ID]([ticket.uID]) resolved.</b>"
		message_admins("Adminhelp ID: #[ticket.ID]([ticket.uID]) was resolved by [usr.ckey]")
		ticket.user << "<b>Your adminhelp (#[ticket.ID]) has been resolved by [usr.ckey]<b>"
		ticket.user << 'sound/machines/twobeep.ogg'
		ticket.resolved = "Yes"

	if(count < 1)
		usr << "<b>You are not currently handling any adminhelps!</b>"

/datum/adminticket/proc/viewlogs(var/NuID, mob/user)
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

	dat += "<table>"
	for(var/text in ticket.logs)
		dat += "<tr><td>[text]</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "ahelp logs", ticket.permuser, 500, 500)
	popup.set_content(dat)
	popup.open()

/datum/adminticket/Topic(href, href_list)
	if(href_list["view_logs"])
		var/datum/adminticket/T = locate(href_list["view_logs"])
		viewlogs(T.uID, usr)
	if(href_list["resolve"])
		var/datum/adminticket/T = locate(href_list["resolve"])
		if(T.resolved == "Yes")
			message_admins("Adminhelp ID: #[T.ID]([T.uID]) was unresolved by [usr.ckey]")
			T.user << "<b>Your adminhelp (#[T.ID]) has been unresolved by [usr.ckey]</b>"
			T.user << 'sound/machines/twobeep.ogg'
			T.resolved = "No"
		else
			message_admins("Adminhelp ID: #[T.ID]([T.uID]) was resolved by [usr.ckey]")
			T.user << "<b>Your adminhelp (#[T.ID]) has been resolved by [usr.ckey]</b>"
			T.user << 'sound/machines/twobeep.ogg'
			T.resolved = "Yes"