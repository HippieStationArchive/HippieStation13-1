/obj/machinery/washing_machine
	name = "washing machine"
	desc = "Gets rid of those pesky bloodstains, or your money back!"
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_10"
	density = 1
	anchored = 1
	var/state = 1
	//1 = empty, open door
	//2 = empty, closed door
	//3 = full, open door
	//4 = full, closed door
	//5 = running
	//6 = blood, open door
	//7 = blood, closed door
	//8 = blood, running
	var/panel = 0
	//0 = closed
	//1 = open
	var/gibs_ready = 0
	var/obj/crayon
	var/working = 0 //To remove the sleep()

/obj/machinery/washing_machine/verb/start()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.restrained() || !usr.canmove || working)
		return

	if( state != 4 )
		usr << "The washing machine cannot run in this state."
		return

	if( locate(/mob,contents) )
		state = 8
	else
		state = 5
	update_icon()
	if(locate(/obj/item/weapon/wrench) in contents)
		flash_and_shake(src, "#FF0000", 2 , 100, xdif = 3, ydif = 3)
		visible_message("<span class='danger'>[src] begins to shake violently!", "<span class='italics'>You hear various bangs</span>")
	working = 1
	spawn(200)

		for(var/atom/A in contents)
			A.clean_blood()

			for(var/atom/B in A.contents)
				B.clean_blood()

		//Tanning!
		for(var/obj/item/stack/sheet/hairlesshide/HH in contents)
			var/obj/item/stack/sheet/wetleather/WL = new(src)
			WL.amount = HH.amount
			qdel(HH)

		//Corgi costume says goodbye
		for(var/obj/item/clothing/suit/hooded/ian_costume/IC in contents)
			new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi(src)
			qdel(IC)

		if(crayon)
			var/wash_color
			if(istype(crayon,/obj/item/toy/crayon))
				var/obj/item/toy/crayon/CR = crayon
				wash_color = CR.colourName
			else if(istype(crayon,/obj/item/weapon/stamp))
				var/obj/item/weapon/stamp/ST = crayon
				wash_color = ST.item_color

			if(wash_color)
				for(var/obj/item/clothing/I in contents)
					I.color = wash_color //Simply recolor the items.
					I.desc = I.desc + (length(I.desc) > 0 ? " " : "") + "It looks soaked in [wash_color] tincture."

					var/list/colors = list("light brown", "brown", "cyan", "fingerless", "combat", "tactical", "yellowgreen", "darkred", "lightred", "maroon", "red", "orange", "rainbow", "lightgreen", "green", "lightpurple", "purple", "gold", "darkblue", "lightblue", "aqua", "blue", "yellow", "black", "grey", "gray", "white", "latex", "nitrile", "budget insulated", "insulated", "captain's")

					for(var/old_color in colors)
						if(findtext(I.name, old_color))
							I.name = n_replace(I.name, old_color, wash_color)
							break

					for(var/obj/item/clothing/J in I.contents)
						J.color = wash_color
						J.desc = J.desc + (length(J.desc) > 0 ? " " : "") + "It looks soaked in [wash_color] tincture."

						for(var/old_color in colors)
							if(findtext(J.name, old_color))
								J.name = n_replace(J.name, old_color, wash_color)
								break
			qdel(crayon)
			crayon = null

		if(locate(/obj/item/weapon/wrench) in contents)
			state = 1
			for(var/atom/movable/O in contents)
				O.loc = get_turf(src)
				O.throw_at(get_edge_target_turf(src,pick(NORTH, SOUTH, EAST, WEST)), 500, 9, zone="chest")
			update_icon()
			working = 0
			visible_message("<span class='danger'>[src] shoots open, ejecting it's contents in various directions!", "<span class='italics'>You hear a loud BANG.</span>")
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			return
		if( locate(/mob,contents) )
			state = 7
			gibs_ready = 1
		else
			state = 4
		update_icon()
		working = 0

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	sleep(20)
	if(state in list(1,3,6) )
		usr.loc = src.loc


/obj/machinery/washing_machine/update_icon()
	icon_state = "wm_[state][panel]"

/obj/machinery/washing_machine/attackby(obj/item/weapon/W, mob/user, params)
	/*if(istype(W,/obj/item/weapon/screwdriver))
		panel = !panel
		user << "\blue you [panel ? "open" : "close"] the [src]'s maintenance panel"*/
	if(istype(W,/obj/item/toy/crayon) ||istype(W,/obj/item/weapon/stamp))
		if( state in list(	1, 3, 6 ) )
			if(!crayon)
				if(!user.drop_item())
					return
				crayon = W
				crayon.loc = src
			else
				..()
		else
			..()
	else if(istype(W,/obj/item/weapon/grab))
		if((state == 1))
			var/obj/item/weapon/grab/G = W
			if(iscorgi(G.affecting))
				G.affecting.loc = src
				qdel(G)
				state = 3
		else
			..()
	else if(istype(W,/obj/item/stack/sheet/hairlesshide) || istype(W,/obj/item/clothing) || istype(W,/obj/item/weapon/bedsheet) || istype(W,/obj/item/weapon/wrench))

		if(istype(W,/obj/item/clothing))
			var/obj/item/clothing/C = W
			if(!C.can_be_washed)
				user << "This item does not fit."
				return
		if(W.flags & NODROP) //if "can't drop" item
			user << "<span class='warning'>\The [W] is stuck to your hand, you cannot put it in the washing machine!</span>"
			return

		if(contents.len < 5)
			if ( state in list(1, 3) )
				if(!user.drop_item())
					return
				W.loc = src
				state = 3
			else
				user << "<span class='warning'>You can't put the item in right now!</span>"
		else
			user << "<span class='warning'>The washing machine is full!</span>"

	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user)
	switch(state)
		if(1)
			state = 2
		if(2)
			state = 1
			for(var/atom/movable/O in contents)
				O.loc = src.loc
		if(3)
			state = 4
		if(4)
			state = 3
			for(var/atom/movable/O in contents)
				O.loc = src.loc
			crayon = null
			state = 1
		if(5)
			user << "<span class='danger'>The [src] is busy.</span>"
		if(6)
			state = 7
		if(7)
			if(gibs_ready)
				gibs_ready = 0
				if(locate(/mob,contents))
					var/mob/M = locate(/mob,contents)
					M.gib()
			for(var/atom/movable/O in contents)
				O.loc = src.loc
			crayon = null
			state = 1


	update_icon()