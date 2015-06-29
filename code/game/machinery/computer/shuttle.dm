/obj/machinery/computer/emergency_shuttle
	name = "emergency shuttle console"
	desc = "For shuttle control."
	icon_state = "shuttle"
	var/auth_need = 3.0
	var/list/authorized = list(  )
	l_color = "#7BF9FF"

/obj/machinery/computer/emergency_shuttle/attackby(var/obj/item/weapon/card/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))	return
	if(emergency_shuttle.location != DOCKED)
		user << "The shuttle is already in motion."
		return
	if (!( istype(W, /obj/item/weapon/card) ) || !( ticker ) || emergency_shuttle.location != DOCKED || !( user ) || emergency_shuttle.timeleft() < 11)	return
	if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if (istype(W, /obj/item/device/pda))
			var/obj/item/device/pda/pda = W
			W = pda.id
		if (!W:access) //no access
			user << "The access level of [W:registered_name]\'s card is not high enough. "
			return

		var/list/cardaccess = W:access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			user << "The access level of [W:registered_name]\'s card is not high enough. "
			return

		if(!(access_heads in W:access)) //doesn't have this access
			user << "The access level of [W:registered_name]\'s card is not high enough. "
			return 0

		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		if(emergency_shuttle.location != DOCKED && user.get_active_hand() != W)
			return 0
		switch(choice)
			if("Authorize")
				if (emergency_shuttle.location == DOCKED)
					src.authorized -= W:registered_name
					src.authorized += W:registered_name
					if (src.auth_need - src.authorized.len > 0)
						message_admins("[key_name(user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) has authorized early shuttle launch in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
						log_game("[user.ckey]([user]) has authorized early shuttle launch in ([x],[y],[z])")
						minor_announce("[src.auth_need - src.authorized.len] more authorization(s) needed until shuttle is launched early",null,1)
					else
						var/time = emergency_shuttle.timeleft()
						message_admins("[key_name(user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) has launched the emergency shuttle in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) [time] seconds before launch.",0,1)
						log_game("[user.ckey]([user]) has launched the emergency shuttle in ([x],[y],[z]) [time] seconds before launch.")
						minor_announce("The emergency shuttle will launch in 10 seconds",null,1)
						emergency_shuttle.online = 1
						emergency_shuttle.settimeleft(10)
						//src.authorized = null
						del(src.authorized)
						src.authorized = list(  )
				else
					user << "The shuttle is already in motion."
			if("Repeal")
				src.authorized -= W:registered_name
				minor_announce("[src.auth_need - src.authorized.len] authorizations needed until shuttle is launched early")

			if("Abort")
				minor_announce("All authorizations to launch the shuttle early have been revoked.")
				src.authorized.len = 0
				src.authorized = list(  )
	return

/obj/machinery/computer/emergency_shuttle/emag_act(mob/user as mob)
	var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")
	if(!emagged)
		if(emergency_shuttle.location == DOCKED)
			switch(choice)
				if("Launch")
					var/time = emergency_shuttle.timeleft()
					message_admins("[key_name(user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) has emagged the emergency shuttle in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) [time] seconds before launch.",0,1)
					log_game("[user.ckey]([user]) has emagged the emergency shuttle in ([x],[y],[z]) [time] seconds before launch.")
					minor_announce("The emergency shuttle will launch in 10 seconds", "SYSTEM ERROR:",null,1)
					emergency_shuttle.settimeleft( 10 )
					emagged = 1
				if("Cancel")
					return