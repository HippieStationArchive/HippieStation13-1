//shows a list of clients we could send PMs to, then forwards our choice to cmd_Mentor_pm
/client/proc/cmd_mentor_pm_panel()
	set category = "Mentor"
	set name = "Mentor PM"
	if(!holder)
		src << "<font color='red'>Error: Mentor-PM-Panel: Only Mentors may use this command.</font>"
		return
	var/list/client/targets[0]
	for(var/client/T)
		targets["[T]"] = T

	var/list/sorted = sortList(targets)
	var/target = input(src,"To whom shall we send a message?","Mentor PM",null) in sorted|null
	cmd_mentor_pm(targets[target],null)
	feedback_add_details("Mentor_verb","APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//takes input from cmd_mentor_pm_context, cmd_Mentor_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_mentor_pm(whom, msg)
	var/client/C
	if(istext(whom))
		C = directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)	src << "<font color='red'>Error: Mentor-PM: Client not found.</font>"
		else		mentorhelp(msg)	//Mentor we are replying to left. Mentorhelp instead
		return

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message to [key_name_mentor(C, 0, 0)]") as text|null

		if(!msg)	return
		if(!C)
			if(holder)	src << "<font color='red'>Error: Mentor-PM: Client not found.</font>"
			else		mentorhelp(msg)	//Mentor we are replying to has vanished, Mentorhelp instead
			return

	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return

	msg = emoji_parse(msg)

	C << "<font color='red'>Mentor PM: <b>[key_name_mentor(src, C, 1)]</b>: [msg]</font>"
	src << "<font color='blue'>Mentor PM: <b>[key_name_mentor(C, src, 1)]</b>: [msg]</font>"

	//we don't use message_Mentors here because the sender/receiver might get it too
	for(var/client/X in mentors)
		if(X.key!=key && X.key!=C.key)	//check client/X is an Mentor and isn't the sender or recipient
			X << "<B><font color='blue'>Mentor PM: [key_name_mentor(src, X, 0)]-&gt;[key_name_mentor(C, X, 0)]:</B> \blue [msg]</font>" //inform X
