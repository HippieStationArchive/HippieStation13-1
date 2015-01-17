/client/verb/mentorhelp(msg as text)
	set category = "Mentor"
	set name = "Mentorhelp"

	//remove out adminhelp verb temporarily to prevent spamming of mentors.
	src.verbs -= /client/verb/mentorhelp
	spawn(300)
		src.verbs += /client/verb/mentorhelp	// 30 second cool-down for mentorhelp

	//clean the input msg
	if(!msg)	return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return
	if(!mob)	return						//this doesn't happen

	msg = "<span class='mentornotice'><font color='purple'>New Mentor PM From: <b>[key_name_mentor(src, 1)] :</b> [msg]</font></span>"


	for(var/client/X in mentors)
		X << 'sound/New_Sound/Items/Bikehorn2.ogg'
		X << msg

	//show it to the person adminhelping too
	src << "<span class='mentornotice'>PM to-<b>Mentors</b>: [msg]</span>"
	return

/proc/key_name_mentor(var/whom, var/include_link = null, var/include_name = 1)
	var/mob/M
	var/client/C
	var/key
	var/ckey

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
		ckey = C.ckey
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
		ckey = M.ckey
	else if(istext(whom))
		key = whom
		ckey = ckey(whom)
		C = directory[ckey]
		if(C)
			M = C.mob
	else
		return "*invalid*"

	. = ""

	if(!ckey)
		include_link = 0

	if(key)
		if(include_link)
			. += "<a href='?mentor_msg=[ckey]'>"

		if(C && C.holder && C.holder.fakekey && !include_name)
			. += "Administrator"
		else
			. += key
		if(!C)
			. += "\[DC\]"

		if(include_link)
			. += "</a>"
	else
		. += "*no key*"

	if(include_name && M)
		if(M.real_name)
			. += "/([M.real_name])"
		else if(M.name)
			. += "/([M.name])"

	return .