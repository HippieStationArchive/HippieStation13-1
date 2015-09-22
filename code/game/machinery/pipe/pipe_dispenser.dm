/obj/machinery/pipedispenser
	name = "pipe dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/wait = 0

/obj/machinery/pipedispenser/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/pipedispenser/attack_hand(user as mob)
	if(..())
		return 1
	var/dat = {"
<b>Regular pipes:</b><BR>
<A href='?src=\ref[src];make=0;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=1;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=5;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=19;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=8;dir=1'>Manual Valve</A><BR>
<A href='?src=\ref[src];make=18;dir=1'>Digital Valve</A><BR>
<b>Devices:</b><BR>
<A href='?src=\ref[src];make=4;dir=1'>Connector</A><BR>
<A href='?src=\ref[src];make=7;dir=1'>Vent</A><BR>
<A href='?src=\ref[src];make=9;dir=1'>Gas Pump</A><BR>
<A href='?src=\ref[src];make=15;dir=1'>Passive Gate</A><BR>
<A href='?src=\ref[src];make=16;dir=1'>Volume Pump</A><BR>
<A href='?src=\ref[src];make=10;dir=1'>Scrubber</A><BR>
<A href='?src=\ref[src];makemeter=1'>Meter</A><BR>
<A href='?src=\ref[src];make=13;dir=1'>Gas Filter</A><BR>
<A href='?src=\ref[src];make=14;dir=1'>Gas Mixer</A><BR>
<b>Heat exchange:</b><BR>
<A href='?src=\ref[src];make=2;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=3;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=6;dir=1'>Junction</A><BR>
<A href='?src=\ref[src];make=17;dir=1'>Heat Exchanger</A><BR>
<b>Insulated pipes:</b><BR>
<A href='?src=\ref[src];make=11;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=12;dir=5'>Bent Pipe</A><BR>
"}


	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return 1
	if(!anchored|| !usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=pipedispenser")
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["make"])
		if(!wait)
			var/p_type = text2num(href_list["make"])
			var/p_dir = text2num(href_list["dir"])
			var/obj/item/pipe/P = new (/*usr.loc*/ src.loc, pipe_type=p_type, dir=p_dir)
			P.update()
			P.add_fingerprint(usr)
			wait = 1
			spawn(10)
				wait = 0
	if(href_list["makemeter"])
		if(!wait)
			new /obj/item/pipe_meter(/*usr.loc*/ src.loc)
			wait = 1
			spawn(15)
				wait = 0
	return

/obj/machinery/pipedispenser/attackby(var/obj/item/W as obj, var/mob/user as mob)
	add_fingerprint(user)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		usr << "<span class='notice'>You put [W] back into [src].</span>"
		user.drop_item()
		qdel(W)
		return
	else if (istype(W, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'>You begin to fasten \the [src] to the floor...</span>"
			if (do_after(user, 40, target = src))
				add_fingerprint(user)
				user.visible_message( \
					"[user] fastens \the [src].", \
					"<span class='notice'>You have fastened \the [src]. Now it can dispense pipes.</span>", \
					"You hear ratchet.")
				anchored = 1
				stat &= MAINT
				if (usr.machine==src)
					usr << browse(null, "window=pipedispenser")
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>"
			if (do_after(user, 20, target = src))
				add_fingerprint(user)
				user.visible_message( \
					"[user] unfastens \the [src].", \
					"<span class='notice'>You have unfastened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				anchored = 0
				stat |= ~MAINT
				power_change()
	else
		return ..()


/obj/machinery/pipedispenser/disposal
	name = "disposal pipe dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1.0

/*
//Allow you to push disposal pipes into it (for those with density 1)
/obj/machinery/pipedispenser/disposal/Crossed(var/obj/structure/disposalconstruct/pipe as obj)
	if(istype(pipe) && !pipe.anchored)
		qdel(pipe)

Nah
*/

//Allow you to drag-drop disposal pipes and transit tubes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/pipe as obj, mob/usr as mob)
	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if (!istype(pipe, /obj/structure/disposalconstruct) && !istype(pipe, /obj/structure/c_transit_tube) && !istype(pipe, /obj/structure/c_transit_tube_pod))
		return

	if (get_dist(usr, src) > 1 || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return 1

	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
<A href='?src=\ref[src];dmake=5'>Bin</A><BR>
<A href='?src=\ref[src];dmake=6'>Outlet</A><BR>
<A href='?src=\ref[src];dmake=7'>Chute</A><BR>
<A href='?src=\ref[src];dmake=8'>Sort Junction</A><BR>
"}

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["dmake"])
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			var/obj/structure/disposalconstruct/C = new (src.loc)
			switch(p_type)
				if(0)
					C.ptype = 0
				if(1)
					C.ptype = 1
				if(2)
					C.ptype = 2
				if(3)
					C.ptype = 4
				if(4)
					C.ptype = 5
				if(5)
					C.ptype = 6
					C.density = 1
				if(6)
					C.ptype = 7
					C.density = 1
				if(7)
					C.ptype = 8
					C.density = 1
				if(8)
					C.ptype = 9
			C.add_fingerprint(usr)
			C.update()
			wait = 1
			spawn(15)
				wait = 0
	return

//transit tube dispenser
//inherit disposal for the dragging proc
/obj/machinery/pipedispenser/disposal/transit_tube
	name = "transit tube dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1.0

/obj/machinery/pipedispenser/disposal/transit_tube/attack_hand(user as mob)
	if(..())
		return 1

	var/dat = {"<B>Transit Tubes:</B><BR>
<A href='?src=\ref[src];tube=0'>Straight Tube</A><BR>
<A href='?src=\ref[src];tube=1'>Straight Tube with Crossing</A><BR>
<A href='?src=\ref[src];tube=2'>Curved Tube</A><BR>
<A href='?src=\ref[src];tube=3'>Diagonal Tube</A><BR>
<A href='?src=\ref[src];tube=4'>Junction</A><BR>
<b>Station Equipment:</b><BR>
<A href='?src=\ref[src];tube=5'>Through Tube Station</A><BR>
<A href='?src=\ref[src];tube=6'>Terminus Tube Station</A><BR>
<A href='?src=\ref[src];tube=7'>Tube Blocker</A><BR>
<A href='?src=\ref[src];tube=8'>Transit Tube Pod</A><BR>
"}

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return


/obj/machinery/pipedispenser/disposal/transit_tube/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(!wait)
		if(href_list["tube"])
			var/tube_type = text2num(href_list["tube"])
			if(tube_type <= 4)
				var/obj/structure/c_transit_tube/C = new/obj/structure/c_transit_tube(src.loc)
				switch(tube_type)
					if(0)
						C.icon_state = "E-W"
					if(1)
						C.icon_state = "E-W-Pass"
					if(2)
						C.icon_state = "S-NE"
					if(3)
						C.icon_state = "NE-SW"
					if(4)
						C.icon_state = "W-NE-SE"
				C.add_fingerprint(usr)
			else
				switch(tube_type)
					if(5)
						var/obj/structure/c_transit_tube/station/C = new/obj/structure/c_transit_tube/station(src.loc)
						C.add_fingerprint(usr)
					if(6)
						var/obj/structure/c_transit_tube/station/reverse/C = new/obj/structure/c_transit_tube/station/reverse(src.loc)
						C.add_fingerprint(usr)
					if(7)
						var/obj/structure/c_transit_tube/station/block/C = new/obj/structure/c_transit_tube/station/block(src.loc)
						C.add_fingerprint(usr)
					if(8)
						var/obj/structure/c_transit_tube_pod/C = new/obj/structure/c_transit_tube_pod(src.loc)
						C.add_fingerprint(usr)
			wait = 1
			spawn(15)
				wait = 0
	return
