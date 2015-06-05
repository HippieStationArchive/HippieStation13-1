

/obj/machinery/pointshop
	name = "Shop-O-Tron 5000"
	desc = "Used to spend your monopoly space cash.."
	anchored = 1
	icon = 'icons/obj/vending.dmi'
	icon_state = "casino"
	var/list/records
	var/datum/preferences/loggedin = 0
	density = 1

	attack_hand(mob/living/user)
		interact(user)

	interact(user)
		var/dat
		if( (in_range(src, user) && isturf(loc)) || istype(user, /mob/living/silicon) )
			dat = "<B>Shop-O-Tron 5000</B><BR>"

			if(loggedin)
				dat += "<a href='?src=\ref[src];op=logout'>\[Logout\]</a><br>"

				dat += "<br><B>Number of Points</b>: [loggedin.points]<br>"

				dat += "<A href='?src=\ref[src];buy=1'>Bear Pelt Hat - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=2'>Festive Crown - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=3'>Xeno Hat - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=4'>Xeno Suit - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=5'>Ian shirt - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=6'>Bronze Heart Medal - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=7'>Point Gift - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=8'>Space Cash - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=9'>Pig Mask - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=10'>Lipstick - 1 Point</A><BR>"

			else
				dat += "<a href='?src=\ref[src];op=login'>\[Login - Biometric Scan\]</a><br>"

		user << browse(dat, "window=pointshop")
		return

	Topic(href, href_list)
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			switch(href_list["op"])
				if("login","logout")
					if(loggedin)
						loggedin = null
					else
						loggedin = usr.client.prefs
			if(loggedin && loggedin.points >= 1)
				var/buynum = text2num(href_list["buy"])

				switch(buynum)
					if(1)	new /obj/item/clothing/head/bearpelt(loc)
					if(2)	new /obj/item/clothing/head/festive(loc)
					if(3)	new /obj/item/clothing/head/xenos(loc)
					if(4)	new /obj/item/clothing/suit/xenos(loc)
					if(5)	new /obj/item/clothing/suit/ianshirt(loc)
					if(6)	new /obj/item/clothing/tie/medal/conduct(loc)
					if(8)	new /obj/item/weapon/spacecash/c10(loc)
					if(9)	new /obj/item/clothing/mask/pig(loc)
					if(10)	new /obj/item/weapon/lipstick/random(loc)
					else	return

				--loggedin.points
				loggedin.save_preferences()

			interact(usr)
