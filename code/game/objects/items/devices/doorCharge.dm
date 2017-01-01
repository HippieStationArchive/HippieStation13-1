/obj/item/device/doorCharge
	name = "airlock charge"
	desc = null //Different examine for traitors
	item_state = "electronic"
	icon_state = "doorCharge"
	w_class = 2
	throw_range = 4
	throw_speed = 1
	force = 3
	attack_verb = list("blown up", "exploded", "detonated")
	materials = list(MAT_METAL=50, MAT_GLASS=30)
	origin_tech = "syndicate=3;combat=2,"

/obj/item/device/doorCharge/ex_act(severity, target)
	switch(severity)
		if(1)
			visible_message("<span class='warning'>[src] detonates!</span>")
			message_admins("A door charge has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> last touched by [key_name_admin(fingerprintslast)]")
			log_game("A door charge has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> last touched by [key_name_admin(fingerprintslast)]")
			explosion(src.loc,0,2,1,flame_range = 4)
			qdel(src)
		if(2)
			if(prob(50))
				ex_act(1)
		if(3)
			if(prob(25))
				ex_act(1)

/obj/item/device/doorCharge/examine(mob/user)
	..()
	if(user.mind in ticker.mode.traitors) //No nuke ops because the device is excluded from nuclear
		user << "A small explosive device that can be used to sabotage airlocks to cause an explosion upon opening. To apply, remove the airlock's maintenance panel and place it within."
	else
		user << "A small, suspicious object that feels lukewarm when held."
