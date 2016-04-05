/obj/machinery/computer/emergency_shuttle
	name = "emergency shuttle console"
	desc = "For shuttle control."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	var/auth_need = 3
	var/list/authorized = list()


/obj/machinery/computer/emergency_shuttle/attackby(obj/item/weapon/card/W, mob/user, params)
	if(stat & (BROKEN|NOPOWER))	return
	if(!istype(W, /obj/item/weapon/card))
		return
	if(SSshuttle.emergency.mode != SHUTTLE_DOCKED)
		return
	if(!user)
		return
	if(SSshuttle.emergency.timeLeft() < 11)
		return
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
		if(SSshuttle.emergency.mode != SHUTTLE_DOCKED || user.get_active_hand() != W)
			return 0

		var/seconds = SSshuttle.emergency.timeLeft()
		if(seconds <= 10)
			return 0

		switch(choice)
			if("Authorize")
				if(!authorized.Find(W:registered_name))
					authorized += W:registered_name
					if(auth_need - authorized.len > 0)
						message_admins("[key_name_admin(user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) has authorized early shuttle launch ",0,1)
						log_game("[key_name(user)] has authorized early shuttle launch in ([x],[y],[z])")
						minor_announce("[auth_need - authorized.len] more authorization(s) needed until shuttle is launched early",null,1)
					else
						message_admins("[key_name_admin(user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) has launched the emergency shuttle [seconds] seconds before launch.",0,1)
						log_game("[key_name(user)] has launched the emergency shuttle in ([x],[y],[z]) [seconds] seconds before launch.")
						minor_announce("The emergency shuttle will launch in 10 seconds",null,1)
						SSshuttle.emergency.setTimer(100)

			if("Repeal")
				if(authorized.Remove(W:registered_name))
					minor_announce("[auth_need - authorized.len] authorizations needed until shuttle is launched early")

			if("Abort")
				if(authorized.len)
					minor_announce("All authorizations to launch the shuttle early have been revoked.")
					authorized.Cut()

/obj/machinery/computer/emergency_shuttle/emag_act(mob/user)
	if(!emagged && SSshuttle.emergency.mode == SHUTTLE_DOCKED)
		var/time = SSshuttle.emergency.timeLeft()
		message_admins("[key_name_admin(user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) has emagged the emergency shuttle  [time] seconds before launch.",0,1)
		log_game("[key_name(user)] has emagged the emergency shuttle in ([x],[y],[z]) [time] seconds before launch.")
		minor_announce("The emergency shuttle will launch in 10 seconds", "SYSTEM ERROR:",null,1)
		SSshuttle.emergency.setTimer(100)
		emagged = 1

/obj/machinery/computer/supplycomp
	name = "supply shuttle console"
	desc = "Used to order supplies."
	icon_screen = "supply"
	req_access = list(access_cargo)
	circuit = /obj/item/weapon/circuitboard/supplycomp
	verb_say = "flashes"
	verb_ask = "flashes"
	verb_exclaim = "flashes"
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/hacked = 0
	var/can_order_contraband = 0
	var/last_viewed_group = "categories"

/obj/machinery/computer/supplycomp/New()
	..()

	var/obj/item/weapon/circuitboard/supplycomp/board = circuit
	can_order_contraband = board.contraband_enabled

/obj/machinery/computer/ordercomp
	name = "supply ordering console"
	desc = "Used to order supplies from cargo staff."
	icon_screen = "request"
	circuit = /obj/item/weapon/circuitboard/ordercomp
	verb_say = "flashes"
	verb_ask = "flashes"
	verb_exclaim = "flashes"
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/last_viewed_group = "categories"

/obj/machinery/computer/shuttle/white_ship
	name = "White Ship Console"
	desc = "Used to control the White Ship."
	circuit = /obj/item/weapon/circuitboard/white_ship
	shuttleId = "whiteship"
	possible_destinations = "whiteship_ss13;whiteship_home;whiteship_z4"
