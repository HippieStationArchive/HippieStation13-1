/mob/living/silicon/ai/death(gibbed)
	if(stat == DEAD)
		return
	if(!gibbed)
		emote("me", 1, "sparks and its screen flickers, its systems slowly coming to a halt.")
	stat = DEAD


	if("[icon_state]_dead" in icon_states(src.icon,1))
		icon_state = "[icon_state]_dead"
	else
		icon_state = "ai_dead"

	anchored = 0 //unbolt floorbolts
	update_canmove()
	if(eyeobj)
		eyeobj.setLoc(get_turf(src))
	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	shuttle_caller_list -= src
	SSshuttle.autoEvac()

	if(explosive)
		spawn(10)
			message_admins("The AI has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> who was controlled by [key_name_admin(src)]")
			log_game("The AI has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> who was controlled by [key_name_admin(src)]")
			explosion(src.loc, 3, 6, 12, 15)

	for(var/obj/machinery/ai_status_display/O in world) //change status
		if(src.key)
			spawn( 0 )
			O.mode = 2
			if (istype(loc, /obj/item/device/aicard))
				loc.icon_state = "aicard-404"

	tod = worldtime2text() //weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)

	return ..(gibbed)
