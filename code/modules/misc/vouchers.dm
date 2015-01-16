//Ported from FPstation. Will fix up later.

/datum/voucherrewards
	var/name = "voucher"
	var/cost = 0
/datum/voucherrewards/C
	name = "test"
	cost = 3
var/global/vouchers = 0 //So badmins can't change this

/obj/machinery/voucher
	name = "Voucher Console"
	desc = "Used to spend vouchers."
	anchored = 1
	icon = 'icons/obj/terminals.dmi'
	icon_state = "redeem"
	var/screenstate = 0
	var/tempname = null
	var/special = 0
	var/tempreason = null
	var/research = 0

	var/list/voucher_rewards = list()
	var/tempcode = null
	New()
		var/list/Lines = file2list("data/consistent.ini")//Grabs the value from
		if(Lines.len)
			if(Lines[1])
				var/temp = text2num(Lines[1])
				if(temp >= 20)
					vouchers = 20
				else if(temp <= 0)
					vouchers = 0
				else
					vouchers = temp

	attackby(obj/item/I as obj, mob/living/user as mob)
		if (!(src.stat & (BROKEN | NOPOWER)))
			if(istype(I,/obj/item/weapon/card/emag))
				if(!emagged)
					emagged = 1
					user << "You emag the voucher machine."

	attack_hand(mob/living/user as mob)
		src.add_fingerprint(user)
		var/dat = "<B>Voucher Dispenser 301</B><BR>"
		dat += "<br><B>Number of Vouchers</b>: [vouchers]<br>"
		switch(screenstate)
			if(0)
				dat += "<A href='byond://?src=\ref[src];op=makevoucher'>Create a Voucher</A><BR>"
				dat += "<A href='byond://?src=\ref[src];op=order'>Obtaining Vouchers</A><BR>"
			if(1)
				if(vouchers >= 10)
					dat += "<A href='byond://?src=\ref[src];op=smes'>Power all SMES (10)</A><BR>"
				if(vouchers >= 7 && !research)
					dat += "<A href='byond://?src=\ref[src];op=res'>Research Jump Start (5)</A><BR>"
				dat += "<A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
			if(2)
				dat += "For reach shift the station survives; a voucher is stored. Spend vouchers to aid your fellow crew members."
				dat += "<A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return
	Topic(href, href_list)
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			switch(href_list["op"])
				if("makevoucher")
					screenstate = 1
				if("order")
					screenstate = 2
				if("namevoucher")
					var/input = input("Who is the recipient?.",,"")
					if(input)
						tempname = input
				if("reasonvoucher")
					var/input = input("What is the reason for this voucher?.",,"")
					if(input)
						tempreason = input
				if("createvoucher")
					new/obj/item/bodybag(src.loc)
					tempreason = null
					tempname = null
				if("mm")
					screenstate = 0
				if("res")
					research = 1
					new/obj/item/weapon/research/mini(src.loc)
					vouchers -= 7
				//	command_alert("Attention. A research jumpstart item has been purchased with vouchers and been approved. Destroy it in the Destructive Analyzer. Do not depend on this.")
					message_admins("([usr.key]/[usr.real_name]) has purchased a research jumpstart with vouchers.")
//				if("buycode")
//					getcode()
//					command_alert("Attention. An away mission opportunity has been purchased with vouchers and been approved. Please enter [tempcode] to your gateway computer. This code will not be repeated. Proceed with caution. Additionally memorize the gateway code listed on your main computer so you can return to the station.")
//					message_admins("([usr.key]/[usr.real_name]) has purchased an away mission code with vouchers.")
//					vouchers -= 10
				if("smes")
				//	command_alert("Attention. A powering of all SMES oppurtunity has been purchased with vouchers and been approved. Do not slack off in the future.")
					vouchers -= 10
					message_admins("([usr.key]/[usr.real_name]) has purchased refilled SMES with vouchers.")
					power_restore_quick()
//				if("emag")
//					special = 1
//					getcode()
//					usr << "We have received and approved of your request. Please enter [tempcode] into the gateway computer. This will be told only once. Additionally memorize the gateway code listed on the main gateway computer so you can return to the station."
//					message_admins("([usr.key]/[usr.real_name]) has purchased a syndicate hiding spot with vouchers.")
//					vouchers -= 10
		attack_hand(usr)
		return

/*
/obj/machinery/voucher/proc/getcode()//They will never, EVER get this twice per round.
	var/list/L = new/list()
	if(special)
		for(var/obj/machinery/stargate/center/special/gate in world)
			if(gate.station)	continue
			L.Add(gate)
		if(!L.len)	return
		var/obj/machinery/stargate/center/P = pick(L)
		if(P)
			tempcode = P.code
			special = 0
	else
		for(var/obj/machinery/stargate/center/gate in world)
			if(gate.type == /obj/machinery/stargate/center/special) continue
			if(gate.station)	continue
			L.Add(gate)
		if(!L.len)	return
		var/obj/machinery/stargate/center/P = pick(L)
		if(P)
			tempcode = P.code*/