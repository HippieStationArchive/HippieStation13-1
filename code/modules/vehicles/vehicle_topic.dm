/obj/vehicle/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		interact(usr)

/obj/vehicle/interact(mob/user)
	if(user.incapacitated() || user.lying || !Adjacent(user))
		return
	user.face_atom(src)
	var/dat = "<h3>Vehicle menu</h3>"
	for(var/obj/item/P in parts)
		dat += build_text(P)
	dat += "</div>"

	var/datum/browser/popup = new(user, "vehicle", src.name, 500, 500)
	popup.set_content(dat)
	popup.open()


/obj/vehicle/Topic(href, href_list)
	if(usr.stat || !Adjacent(usr) || usr.lying)
		return
	if(href_list["parts"])
		var/obj/item/O = locate(href_list["parts"])
		var/obj/item/vehicle_parts/P = O
		if(locked)
			usr << "<span class ='warning'>the [src] is locked!</span>"
			return
		if(driver || occupants)
			usr << "<span class = 'warning'>You can't modify it while there are people inside!</span>"
			return
		if(P.part_type == "chassis")
			usr << "<span class ='notice'>You begin to completely dismantle [src]</span>"
			if(do_after(usr, 500, target = src))
				for(var/obj/item/L in parts)
					L.loc = get_turf(usr)
				usr << "<span class ='notice'>You completely dismantle [src]</span>"
				qdel(src)
			else
				usr << "<span class ='notice'>You stop dismantling [src]</span>"
		else
			usr << "<span class ='notice'>You begin removing [P]</span>"
			if(do_after(usr, 40, target = src))
				if(P.part_type == "seat")
					occupants_max--
				P.loc = get_turf(usr)
				parts -= P
				if(P.icon_state in overlays)
					overlays -= P.icon_state
				update_stats()
				usr << "<span class ='notice'>You sucessfully removed [P]</span>"
			else
				usr << "<span class ='warning'>You stop removing [P]</span>"
			interact(usr)



/obj/vehicle/proc/build_text(obj/item/P)
	. = ""
	var/name_text = ""

	name_text ="<a href='?src=\ref[src];parts=\ref[P]'>[P.name]</a>"
	. = "[name_text]<br>"