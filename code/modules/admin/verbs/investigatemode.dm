/proc/toggleinvmode(mob/M as mob in player_list)
	set name = "Toggle Investigate Mode"
	set category = "Special Verbs"
	if(M.client)
		if(M.client.invmode)
			log_admin("[key_name(usr)] has left build mode.")
			M.client.invmode = 0
			M.client.show_popup_menus = 1
			for(var/obj/effect/imode/buildholder/H)
				if(H.cl == M.client)
					qdel(H)
		else
			message_admins("[key_name(usr)] has entered build mode.")
			log_admin("[key_name(usr)] has entered build mode.")
			M.client.invmode = 1
			M.client.show_popup_menus = 0

			var/obj/effect/imode/buildholder/H = new/obj/effect/imode/buildholder()
			var/obj/effect/imode/buildhelp/B = new/obj/effect/imode/buildhelp(H)
			B.master = H
			var/obj/effect/imode/buildmode/C = new/obj/effect/imode/buildmode(H)
			C.master = H
			var/obj/effect/imode/buildquit/D = new/obj/effect/imode/buildquit(H)
			D.master = H

			H.buildhelp = B
			H.buildmode = C
			H.buildquit = D

			M.client.screen += B
			M.client.screen += C
			M.client.screen += D
			H.cl = M.client

/obj/effect/imode//Cleaning up the tree a bit
	density = 1
	anchored = 1
	layer = 20
	dir = NORTH
	icon = 'icons/misc/buildmode.dmi'
	var/obj/effect/imode/buildholder/master = null


/obj/effect/imode/buildhelp
	icon = 'icons/misc/buildmode.dmi'
	icon_state = "invmode1"
	screen_loc = "NORTH,WEST+1"

/obj/effect/imode/buildhelp/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("left"))
		switch(master.cl.invmode)
			if(1)
				master.cl.invmode = 2
				src.icon_state = "invmode2"
			if(2)
				master.cl.invmode = 3
				src.icon_state = "invmode3"
			if(3)
				master.cl.invmode = 1
				src.icon_state = "invmode1"

	return 1


/obj/effect/imode/buildquit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

/obj/effect/imode/buildquit/Click()
	toggleinvmode(master.cl.mob)
	return 1

/obj/effect/imode/buildholder
	density = 0
	anchored = 1
	var/client/cl = null
	var/obj/effect/imode/builddir/builddir = null
	var/obj/effect/imode/buildhelp/buildhelp = null
	var/obj/effect/imode/buildmode/buildmode = null
	var/obj/effect/imode/buildquit/buildquit = null
	var/atom/movable/throw_atom = null

/obj/effect/imode/mode
	icon_state = "build"
	screen_loc = "NORTH,WEST+2"
	var/varholder = "name"
	var/valueholder = "derp"
	var/objholder = /obj/structure/closet

/obj/effect/imode/buildmode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("left"))
		switch(master.cl.invmode)
			if(1)
				master.cl.invmode = 2
				usr << "\red View mode: Click to find every mob in your view, seeable or not."
				src.icon_state = "buildmode2"
			if(2)
				master.cl.invmode = 3
				usr << "\red Valve Mode: Click canister to check its open/closed log. Click anything else to locate them all."
				src.icon_state = "buildmode3"
			if(3)
				master.cl.invmode = 1
				src.icon_state = "buildmode4"
				usr << "\red Print Mode: Click to check for fingerprints on objects."
	return 1


/proc/inv_click(var/mob/user, invmode, params, var/obj/object)
	var/obj/effect/imode/buildholder/holder = null
	for(var/obj/effect/imode/buildholder/H)
		if(H.cl == user.client)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)

	switch(invmode)
		if(1)
			if(istype(object,/atom) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				var/atom/T = object
				if(T.fingerprints)
					usr << "\blue [T.name] has the following fingerprints:"
					for(var/X in T.fingerprintshidden)
						usr << "\blue [X]"
				else
					usr << "\blue No prints found for this object."
		if(2)
			if(istype(object,/atom/) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				var/mob/living/T = object
				if(T)
					usr << "\blue In your view, either in sight or hidden are the following mobs:"
					for(T in range(7,usr))
						usr << "\blue [T.key] as [T.real_name] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>[T.x],[T.y],[T.z](JMP)</A>"
		if(3)
			if(istype(object,/atom/) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				var/obj/machinery/portable_atmospherics/canister/T = object
				if(istype(T,/obj/machinery/portable_atmospherics/canister))
					usr << "\blue [T.name] has been opened/closed:"
					for(var/X in T.release_log)
						usr << "\blue [X]"
				else
					usr << "\blue Listing all canisters in z1:"
					for(T in world)
						if(T.z != 1)
							continue
						usr << "[T.name] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>[T.x],[T.y],[T.z](JMP)</A> Currenly: [T.valve_open?("\green Open"):("\red Closed")]"