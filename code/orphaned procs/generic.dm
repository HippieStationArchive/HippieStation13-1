/proc/mass_edit_client_dir()
	if(!usr)
		return
	var/ndir = input("Please enter the direction, 0 means all, -1 means cancel.","dir","0") as num|null
	if(ndir == 0 || ndir == -1)
		return
	for(var/mob/M in world)
		if(!M.client)
			continue
		M.client.dir = ndir
	return 1