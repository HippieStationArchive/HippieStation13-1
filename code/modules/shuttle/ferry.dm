/obj/machinery/computer/shuttle/ferry
	name = "transport ferry console"
	circuit = /obj/item/weapon/circuitboard/ferry
	shuttleId = "ferry"
	possible_destinations = "ferry_home;ferry_away"


/obj/machinery/computer/shuttle/ferry/request
	name = "ferry console"
	circuit = /obj/item/weapon/circuitboard/ferry/request
	var/cooldown //prevents spamming admins
	possible_destinations = "ferry_home"
	admin_controlled = 1

/obj/machinery/computer/shuttle/ferry/request/Topic(href, href_list)
	..()
	if(href_list["request"])
		if(cooldown)
			return
		cooldown = 1
		usr << "<span class='notice'>Your request has been recieved by Centcom.</span>"
		admins << "<b>FERRY: <font color='blue'>[key_name_admin(usr)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) (<A HREF='?_src_=holder;secrets=moveferry'>Move Ferry</a>)</b> is requesting to move the transport ferry to Centcom.</font>"
		spawn(600) //One minute cooldown
			cooldown = 0