//if("10.0.0." in client.address) ban(src)

var/global/ipbanrange = null

var/global/iprangecheckvar = 2

/proc/iprangecheck()
	while(iprangecheckvar)
		world << "Its on"
		if(iprangecheckvar == 1)
			for(var/client/C in world)
				C.checkiprange()
		if(iprangecheckvar == 2)
			world << "Checkvar"
			for(var/client/C in world)
				world << "Its on"
				C.checkiprange1()
		sleep(100)

client/proc/checkiprange()

	if(ipbanrange in address)
		AddBan(ckey, computer_id, "Automatic IP range ban", "Auto", 0, 0, mob.lastKnownIP)
		message_admins("Banning [src] is using a similar IP range.")

client/proc/checkiprange1()

	if(ipbanrange in address)
		world << "address"
		message_admins("Warning, [src] is using a similar IP range.")
	else
		world << "Nope"
/proc/addIPban()
	var/input = input(usr,"BAN IP RANGE?","RANGE",null) as text|null
	ipbanrange = input
	message_admins("[usr.key] has added [input] to the ip ban range")