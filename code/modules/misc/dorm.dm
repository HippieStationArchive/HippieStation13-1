/obj/machinery/dorms_console
	name = "Dorm Console"
	desc = "Used to reserve dorms."
	anchored = 1 //WHY DID YOU PUT THIS IN SPACE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_available"
	var/owner = null //owners name
	var/job = null //owners job
	var/used = 0 //If it has an owner
	var/access = null
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/takemoney = 0
	var/joke = 0 //haha

//For the themes
	var/chosentheme = 0 //One console; one theme
	var/doorstatus = 0
	var/money = 0 //money money money, for buying things!



/obj/machinery/dorms_console/power_change()
	..()
	update_icon()

/obj/machinery/dorms_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "dorm_off")
			icon_state = "dorm_off"
		else
			if(icon_state == "dorm_off")
				icon_state = "dorm_available"



/obj/machinery/dorms_console/attack_hand(mob/living/user as mob)
	if(owner == user.real_name)
		var/dat = "<B>Your New Room Device:</B><BR>"
		dat += "Owner: [owner]<BR>"
		dat += "Job: [job]<BR>"
		if(doorstatus == 0)
			dat += "<A href='byond://?src=\ref[src];op=doorbolt'>Door Bolt Status: Unlocked</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=doorunbolt'>Door Bolt Status: Locked</A><BR>"
		dat += "<B>Please refer to the paper that was printed by this device.</B><BR>"
		dat += "<br>"
		dat += "<br>"
		if(money >= 10)
			dat += "Space Cash Deals!"
			dat += "<br>"
			dat += "Points: [money]"
			dat += "<br>"
			dat += "<A href='byond://?src=\ref[src];op=bluesheet'>Blue Sheet (10 Points)</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=redsheet'>Red Sheet (10 Points)</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=greensheet'>Green Sheet (10 Points)</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=yellowsheet'>Yellow Sheet (10 Points)</A><BR>"
		dat += "<br>"
		if(chosentheme == 0)
			dat += "<A href='byond://?src=\ref[src];op=asstheme'>Assistant Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=shuttheme'>Shuttle Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=medtheme'>Medical Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=themewood'>Wood Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=themescience'>Science Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=themesec'>Security Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=themeai'>Green Circuit Theme</A><BR>"
		dat += "<br>"
		dat += "<br><b><u>Remember! Style is the key to the future! Also remember that your chosen theme is final!</b></u><HR> "
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return

	else
		if(used == 0)
			user << "You check the computer to see that the room is vacant. Swipe your ID to bind it to you!"
		else
			user << "You check the computer to see that the room is owned by [owner], the [job]."
	return
/obj/machinery/dorms_console/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		var/area/A = get_area(src.loc)
		var/list/L = A.get_contents()
		if(!A)return
		switch(href_list["op"])
			if("bluesheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/blue( src.loc )
					money += -10
			if("redsheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/red( src.loc )
					money += -10
			if("greensheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/green( src.loc )
					money += -10
			if("yellowsheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/yellow( src.loc )
					money += -10
			if("asstheme")
				chosentheme = 1
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "plating"
			if("shuttheme")
				chosentheme = 1
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "shuttlefloor"
			if("themewood")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "wood"
				chosentheme = 1
			if("themescience")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "whitepurplefull"
				chosentheme = 1
			if("themetraitor")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "whitepurplefull"
				chosentheme = 1
			if("themesec")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "redfull"
				chosentheme = 1
			if("themeai")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "gcircuit"
				chosentheme = 1
			if("themesanta")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "redgreenfull"
				chosentheme = 1
			if("doorbolt")
				for(var/obj/machinery/door/airlock/D in L)
					if(doorstatus == 0)
						D.locked = 1
						D.update_icon()
						doorstatus = 1
			if("doorunbolt")
				for(var/obj/machinery/door/airlock/D in L)
					if(doorstatus == 1)
						D.locked = 0
						D.update_icon()
						doorstatus = 0
		attack_hand(usr)
		return


/obj/machinery/dorms_console/attackby(obj/item/I as obj, mob/living/user as mob)
	if (!(src.stat & (BROKEN | NOPOWER)))
		if(istype(I,/obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/ID = I
			if(used == 0)
				user << "You bind your self to the [name] console! Please refer to the now printed out instruction paper!"
				used = 1
				owner = ID.registered_name
				job = ID.assignment
			else
				user << "The console rejects your ID card because it has already been bound to someone!"
	/*	if(istype(I,/obj/item/stack/tile/wood))
			if(themewood == 0)
				themewood = 1
				user << "The console scans your item; uploading the 'Wood' design to its theme database."
		if(istype(I,/obj/item/device/assembly/igniter))
			if(themescience == 0)
				themescience = 1
				user << "The console scans your item; uploading the 'Science' design to its theme database."
		if(istype(I,/obj/item/weapon/storage/firstaid))
			if(thememed == 0)
				thememed = 1
				user << "The console scans your item; uploading the 'Medical' design to its theme database."
	*/
		if(istype(I, /obj/item/device/multitool))
			user << "\blue You hold up the multitool to the console. This will take some time to wipe its settings!"
			if(do_after(user, 200))
				user << "\blue After some time; you short out the magnetic ID strip on the console; reseting it to factory default."
				owner = null
				job = null
				used = 0

		if(istype(I, /obj/item/weapon/spacecash/c10))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 1
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c20))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 2
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c50))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 5
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c100))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 10
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c200))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 20
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c500))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 50
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0


		if(istype(I, /obj/item/weapon/spacecash/c1000))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue Hahahaha, theres no such thing as a 1000 space cash bill; but you insert it anyway!"
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 100
							user << "The space cash is recognized by the machine and increases the total credits; but your money is fake so why question it."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; obviously your fake money won't work, so you should try it again anyway."
							takemoney = 0

	else
		user << "The machine isn't functioning correctly."




//Autoname
/obj/machinery/dorms_console/New()
	..()
	spawn(10)
		var/area/A = get_area(src)
		if(A)
			for(var/obj/machinery/dorms_console/C in world)
				if(C == src) continue
			name = "[A.name] Dorm Computer"
			if(!A)return
//Goes through every related area and returns a list of the contents
/area/proc/get_contents()
	var/list/content = new/list()
	for(var/area/A in related)//related also contains the current sub area
		if(!A) continue
		content += A.contents
	return uniquelist(content)//Unique list might not be needed but is here just in case
