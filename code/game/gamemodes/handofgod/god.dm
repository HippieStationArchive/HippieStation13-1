
/mob/camera/god
	name = "deity" //Auto changes to the player's deity name/random name
	real_name = "deity"
	icon = 'icons/mob/mob.dmi'
	icon_state = "marker"
	invisibility = INVISIBILITY_OBSERVER
	see_in_dark = 0
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	languages = HUMAN | MONKEY | ALIEN | ROBOT | SLIME | DRONE | SWARMER
	hud_possible = list(ANTAG_HUD)
	mouse_opacity = 0 //can't be clicked

	var/faith = 100 //For initial prophet appointing/stupid purchase
	var/max_faith = 100
	var/side //Red or Blue for the gamemode
	var/obj/structure/divine/nexus/god_nexus = null //The source of the god's power in this realm, kill it and the god is kill
	var/nexus_required = FALSE //If the god dies from losing it's nexus, defaults to off so that gods don't instantly die at roundstart
	var/followers_required = 0 //Same as above
	var/alive_followers = 0
	var/list/structures = list()
	var/prophets_sacrificed_in_name = 0
	var/list/conduits = list()
	var/image/ghostimage = null //For observer with darkness off visiblity

/mob/camera/god/New(location, team)
	..()
	side = team
	color = side
	update_icons()
	build_hog_construction_lists()

	//Force nexuses after 2 minutes in hand of god mode
	addtimer(src,"forceplacenexus",1200)

/mob/camera/god/proc/get_my_followers()
	var/list/myfollowers = get_team_followers(side)
	return myfollowers

/mob/camera/god/proc/get_my_prophet()
	var/datum/mind/prophet
	var/list/myprophets = get_team_prophets(side)
	for(var/datum/mind/A in myprophets)
		if(A.current && A.current.stat != DEAD)
			prophet = A
	return prophet

/mob/camera/god/proc/check_prophet()
	var/list/myprophets = get_team_prophets(side)
	if(myprophets.len > 1) // if there's more than one prophet shit's gonna break,we only want1 prophet
		var/datum/mind/proptoremove = pick_n_take(myprophets)
		var/datum/faction/HOG/myfac = proptoremove.faction // should always exist
		myfac.members[proptoremove] = "Follower"
		proptoremove.current << "<span class='notice'>A prophet already exist, you're now a normal follower!</span>"
		ticker.mode.update_hog_icons_added(proptoremove, side)

/mob/camera/god/Destroy()
	var/list/followers = get_my_followers()
	for(var/datum/mind/F in followers)
		if(F.current)
			F.current << "<span class='danger'>Your god is DEAD!</span>"
			ticker.mode.remove_hog_follower(F)
	ghost_darkness_images -= ghostimage
	updateallghostimages()
	return ..()

/mob/camera/god/proc/forceplacenexus()
	if(god_nexus)
		return

	if(ability_cost(structures = 1))
		place_nexus()

	else
		if(blobstart.len) //we're on invalid turf, try to pick from blobstart
			loc = pick(blobstart)
		place_nexus() //if blobstart fails, places on dense turf, but better than nothing
	src << "<span class='danger'>You failed to place your nexus, and it has been placed for you!</span>"


/mob/camera/god/update_icons()
	if(ghostimage)
		ghost_darkness_images -= ghostimage

	ghostimage = image(icon,src,icon_state)
	ghostimage.color = color
	ghost_darkness_images |= ghostimage
	updateallghostimages()

/mob/camera/god/Stat()
	..()
	if(statpanel("Status"))
		if(god_nexus)
			stat("Nexus health: ", god_nexus.health)
		stat("Followers: ", alive_followers)
		stat("Faith: ", "[faith]/[max_faith]")


/mob/camera/god/Login()
	..()
	sync_mind()
	update_health_hud()

/mob/camera/god/proc/update_health_hud()
	if(god_nexus && hud_used && hud_used.deity_health_display)
		hud_used.deity_health_display.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'> <font color='lime'>[god_nexus.health]   </font></div>"


/mob/camera/god/proc/add_faith(faith_amt)
	if(faith_amt)
		faith = round(Clamp(faith+faith_amt, 0, max_faith))
		if(hud_used && hud_used.deity_power_display)
			hud_used.deity_power_display.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'> <font color='cyan'>[faith]  </font></div>"



/mob/camera/god/proc/place_nexus()
	if(god_nexus || (z != 1))
		return 0
	if(!ability_cost(structures = 1))
		return 0

	var/obj/structure/divine/nexus/N = new(get_turf(src))
	N.assign_deity(src)
	god_nexus = N
	nexus_required = TRUE
	verbs -= /mob/camera/god/verb/constructnexus
	var/list/followers = get_my_followers()
	var/area/A = get_area(src)
	for(var/datum/mind/F in followers)
		if(F.current)
			F.current << "<span class='boldnotice'>Your god's nexus is in \the [A.name]</span>"
	verbs += /mob/camera/god/verb/movenexus
	update_health_hud()

/mob/camera/god/verb/freeturret()
	set category = "Deity"
	set name = "Free Turret (0)"
	set desc = "Place a single turret, for 0 faith."

	if(!ability_cost(structures = 1,requires_conduit = 1))
		return
	new /obj/structure/divine/defensepylon(get_turf(src), src)
	verbs -= /mob/camera/god/verb/freeturret

/mob/camera/god/proc/update_followers()
	alive_followers = 0
	var/list/all_followers = get_my_followers() + get_my_prophet() // prophets are people too!

	for(var/datum/mind/F in all_followers)
		if(F && F.current && F.current.stat != DEAD)
			alive_followers++

	if(hud_used && hud_used.deity_follower_display)
		hud_used.deity_follower_display.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'> <font color='red'>[alive_followers]     </font></div>"


/mob/camera/god/proc/check_death()
	if(!alive_followers)
		src << "<span class='userdanger'>You no longer have any followers. You shudder as you feel your existence cease...</span>"
		if(god_nexus && !qdeleted(god_nexus))
			god_nexus.visible_message("<span class='danger'>\The [src] suddenly disappears!</span>")
			qdel(god_nexus)
		qdel(src)


/mob/camera/god/say(msg)
	if(!msg)
		return
	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "You cannot send IC messages (muted)."
			return
		if(client.handle_spam_prevention(msg,MUTE_IC))
			return
	if(stat)
		return

	god_speak(msg)


/mob/camera/god/proc/god_speak(msg)
	log_say("Hand of God: [capitalize(side)] God/[key_name(src)] : [msg]")
	msg = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	msg = say_quote(msg, get_spans())
	var/rendered = "<font color='#045FB4'><i><span class='game say'>Divine Telepathy, <span class='name'>[name]</span> <span class='message'>[msg]</span></span></i></font>"

	var/datum/mind/myprop = get_my_prophet()
	for(var/mob/M in mob_list)
		if(isobserver(M) || (M.mind && M.mind == myprop))//if the mob is a ghost, or if the mob is my team's prophet
			M.show_message(rendered, 2)
	src << rendered


/mob/camera/god/emote(act,m_type = 1 ,msg = null)
	return


/mob/camera/god/Move(NewLoc, Dir = 0)
	loc = NewLoc



/mob/camera/god/Topic(href, href_list)
	if(href_list["create_structure"])
		if(!ability_cost(cost = 75,structures = 1,requires_conduit = 1))
			return

		var/obj/structure/divine/construct_type = text2path(href_list["create_structure"]) //it's a path but we need to initial() some vars
		if(!construct_type)
			return

		add_faith(-75)
		var/obj/structure/divine/construction_holder/CH = new(get_turf(src), G = src)
		CH.setup_construction(construct_type)
		CH.visible_message("<span class='notice'>[src] has created a transparent, unfinished [initial(construct_type.name)]. It can be finished by adding materials.</span>")
		src << "<span class='boldnotice'>You may click a construction site to cancel it, but only faith is refunded.</span>"
		structure_construction_ui(src)
		return

	if(href_list["place_trap"])
		if(!ability_cost(cost = 20,structures = 1,requires_conduit = 1))
			return

		var/atom/trap_type = text2path(href_list["place_trap"])
		if(!trap_type)
			return

		src << "You lay \a [initial(trap_type.name)]"
		add_faith(-20)
		new trap_type(get_turf(src))
		return

	..()


/mob/camera/god/proc/structure_construction_ui(mob/camera/god/user)
	var/dat = ""
	for(var/t in global_handofgod_structuretypes)
		if(global_handofgod_structuretypes[t])
			var/obj/structure/divine/apath = global_handofgod_structuretypes[t]
			dat += "<center><B>[capitalize(t)]</B></center><BR>"
			var/imgstate = "[initial(apath.icon_state)]"
			var/icon/I = icon('icons/obj/hand_of_god_structures.dmi',imgstate)
			if(initial(apath.overlay))
				var/icon/teamoverlay = initial(apath.overlay)
				teamoverlay.Blend("[side]")
				I.Blend(teamoverlay, ICON_OVERLAY)
			var/img_component = lowertext(t)
			//I hate byond, but atleast it autocaches these so it's only 1*number_of_structures worth of actual calls
			user << browse_rsc(I,"hog_structure-[img_component].png")
			dat += "<center><img src='hog_structure-[img_component].png' height=64 width=64></center>"
			dat += "Description: [initial(apath.desc)]<BR>"
			dat += "<center><a href='?src=\ref[src];create_structure=[apath]'>Construct [capitalize(t)]</a></center><BR><BR>"

	var/datum/browser/popup = new(src, "structures","Construct Structure",350,500)
	popup.set_content(dat)
	popup.open()


/mob/camera/god/proc/trap_construction_ui(mob/camera/god/user)
	var/dat = ""
	for(var/t in global_handofgod_traptypes)
		if(global_handofgod_traptypes[t])
			var/obj/structure/divine/trap/T = global_handofgod_traptypes[t]
			dat += "<center><B>[capitalize(t)]</B></center><BR>"
			var/icon/I = icon('icons/obj/hand_of_god_structures.dmi',"[initial(T.icon_state)]")
			var/img_component = lowertext(t)
			user << browse_rsc(I,"hog_trap-[img_component].png")
			dat += "<center><img src='hog_trap-[img_component].png' height=64 width=64></center>"
			dat += "Description: [initial(T.desc)]<BR>"
			dat += "<center><a href='?src=\ref[src];place_trap=[T]'>Place [capitalize(t)]</a></center><BR><BR>"

	var/datum/browser/popup = new(src, "traps", "Place Trap",350,500)
	popup.set_content(dat)
	popup.open()