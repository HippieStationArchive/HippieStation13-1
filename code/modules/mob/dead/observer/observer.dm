var/list/image/ghost_darkness_images = list() //this is a list of images for things ghosts should still be able to see when they toggle darkness
/mob/dead/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = MOB_LAYER + 1
	stat = DEAD
	density = 0
	canmove = 0
	anchored = 1	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	languages = ALL
	hud_possible = list(ANTAG_HUD_ADMIN)
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/atom/movable/following = null
	var/fun_verbs = 0
	var/image/ghostimage = null //this mobs ghost image, for deleting and stuff
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/seedarkness = 0
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

/mob/dead/observer/New(mob/body)
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
	see_in_dark = 100
	verbs += /mob/dead/observer/proc/dead_tele
	stat = DEAD

	ghostimage = image(src.icon,src,src.icon_state)
	ghost_darkness_images |= ghostimage
	updateallghostimages()
	var/turf/T
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost

		gender = body.gender
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				name = random_unique_name(gender)

		if(body)
			if(body.mind)
				body.mind.ghost = TRUE
			
			mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	if(!T)	T = pick(latejoin)			//Safety in case we cannot find the body's position
	loc = T

	if(!name)							//To prevent nameless ghosts
		name = random_unique_name(gender)
	real_name = name

	if(!fun_verbs)
		verbs -= /mob/dead/observer/verb/boo
		verbs -= /mob/dead/observer/verb/possess

	animate(src, pixel_y = 2, time = 10, loop = -1)
	..()

/mob/dead/observer/Destroy()
	if (ghostimage)
		ghost_darkness_images -= ghostimage
		qdel(ghostimage)
		ghostimage = null
		updateallghostimages()
	return ..()

/mob/dead/CanPass(atom/movable/mover, turf/target, height=0)
	return 1
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/ghostize(can_reenter_corpse = 1)
	if(key)
		if(!cmptext(copytext(key,1,2),"@")) //aghost
			var/mob/dead/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
			ghost.can_reenter_corpse = can_reenter_corpse
			ghost.key = key
			return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	var/mob/living/carbon/H = src

	var/confirm_ghost = FALSE

	if(stat != DEAD)
		succumb()

	if(stat == DEAD)
		ghostize(1)

	if(istype(H))
		if(H.dna)
			if(H.dna.check_mutation(CLUWNEMUT) && stat != DEAD)
				H << "Cluwnes cannot ghost until they've died! Find a natural means of death!"
				return
			else
				confirm_ghost = TRUE
		else
			confirm_ghost = TRUE
	else
		confirm_ghost = TRUE

	if(confirm_ghost)
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")

		if(response != "Ghost")	
			return	//didn't want to ghost after-all

		ghostize(0)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3

	return

/mob/dead/observer/Move(NewLoc, direct)
	if(NewLoc)
		loc = NewLoc
		for(var/obj/effect/step_trigger/S in NewLoc)
			S.Crossed(src)

		return
	loc = get_turf(src) //Get out of closets and such as a ghost
	if((direct & NORTH) && y < world.maxy)
		y++
	else if((direct & SOUTH) && y > 1)
		y--
	if((direct & EAST) && x < world.maxx)
		x++
	else if((direct & WEST) && x > 1)
		x--

	for(var/obj/effect/step_trigger/S in locate(x, y, z))	//<-- this is dumb
		S.Crossed(src)

/mob/dead/observer/is_active()
	return 0

/mob/dead/observer/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Station Time: [worldtime2text()]")
		if(ticker)
			if(ticker.mode)
				//world << "DEBUG: ticker not null"
				if(ticker.mode.name == "AI malfunction")
					var/datum/game_mode/malfunction/malf = ticker.mode
					//world << "DEBUG: malf mode ticker test"
					if(malf.malf_mode_declared && (malf.apcs > 0))
						stat(null, "Time left: [max(malf.AI_win_timeleft/malf.apcs, 0)]")

				for(var/datum/gang/G in ticker.mode.gangs)
					if(isnum(G.dom_timer))
						stat(null, "[G.name] Gang Takeover: [max(G.dom_timer, 0)]")

/mob/dead/observer/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"

	if(!client)	
		return

	if(!(mind && mind.current))
		src << "<span class='warning'>You have no body.</span>"
		return

	if(!can_reenter_corpse)
		src << "<span class='warning'>You cannot re-enter your body.</span>"
		return

	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		usr << "<span class='warning'>Another consciousness is in your body...It is resisting you.</span>"
		return

	mind.current.key = key

	var/mob/living/L = mind.current
	L.mind.ghost = FALSE

	return 1

/mob/dead/observer/proc/notify_cloning(var/message, var/sound)
	if(message)
		src << "<span class='ghostalert'>[message]</span>"
	src << "<span class='ghostalert'><a href=?src=\ref[src];reenter=1>(Click to re-enter)</a></span>"
	if(sound)
		src << sound(sound)

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"
	if(!istype(usr, /mob/dead/observer))
		usr << "Not when you're not dead!"
		return
	usr.verbs -= /mob/dead/observer/proc/dead_tele
	spawn(30)
		usr.verbs += /mob/dead/observer/proc/dead_tele
	var/A
	A = input("Area to jump to", "BOOYEA", A) as null|anything in sortedAreas
	var/area/thearea = A
	if(!thearea)	return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		usr << "No area available."

	usr.loc = pick(L)

/mob/dead/observer/verb/follow()
	set category = "Ghost"
	set name = "Orbit" // "Haunt"
	set desc = "Follow and orbit a mob."

	var/list/mobs = getpois()
	var/input = input("Please, select a mob!", "Haunt", null, null) as null|anything in mobs
	var/mob/target = mobs[input]
	ManualFollow(target)

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if (!istype(target))
		return

	var/icon/I = icon(target.icon,target.icon_state,target.dir)

	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	if(orbiting != target)
		src << "<span class='notice'>Now orbiting [target].</span>"

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)

/mob/dead/observer/orbit()
	..()
	//restart our floating animation after orbit is done.
	sleep 2  //orbit sets up a 2ds animation when it finishes, so we wait for that to end
	if (!orbiting) //make sure another orbit hasn't started
		pixel_y = 0
		animate(src, pixel_y = 2, time = 10, loop = -1)

/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/dead/observer)) //Make sure they're an observer!


		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		dest += getpois(mobs_only=1) //Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.loc = T
			else
				A << "This mob is not located in the game world."

/mob/dead/observer/verb/boo()
	set category = "Ghost"
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time) return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return


/mob/dead/observer/memory()
	set hidden = 1
	src << "<span class='danger'>You are dead! You have no mind to store memory!</span>"

/mob/dead/observer/add_memory()
	set hidden = 1
	src << "<span class='danger'>You are dead! You have no mind to store memory!</span>"

/mob/dead/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !(ghostvision)
	updateghostsight()
	usr << "You [(ghostvision?"now":"no longer")] have ghost vision."

/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"
	seedarkness = !(seedarkness)
	updateghostsight()

/mob/dead/observer/proc/updateghostsight()
	if (!seedarkness)
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
	else
		see_invisible = SEE_INVISIBLE_OBSERVER
		if (!ghostvision)
			see_invisible = SEE_INVISIBLE_LIVING;
	updateghostimages()

/proc/updateallghostimages()
	for (var/mob/dead/observer/O in player_list)
		O.updateghostimages()

/mob/dead/observer/proc/updateghostimages()
	if (!client)
		return
	if (seedarkness || !ghostvision)
		client.images -= ghost_darkness_images
	else
		//add images for the 60inv things ghosts can normally see when darkness is enabled so they can see them now
		client.images |= ghost_darkness_images
		if (ghostimage)
			client.images -= ghostimage //remove ourself

/mob/dead/observer/verb/possess()
	set category = "Ghost"
	set name = "Possess!"
	set desc= "Take over the body of a mindless creature!"

	var/list/possessible = list()
	for(var/mob/living/L in living_mob_list)
		if(!(L in player_list) && !L.mind)
			possessible += L

	var/mob/living/target = input("Your new life begins today!", "Possess Mob", null, null) as null|anything in possessible

	if(!target)
		return 0
	if(can_reenter_corpse || (mind && mind.current))
		if(alert(src, "Your soul is still tied to your former life as [mind.current.name], if you go foward there is no going back to that life. Are you sure you wish to continue?", "Move On", "Yes", "No") == "No")
			return 0
	if(target.key)
		src << "<span class='warning'>Someone has taken this body while you were choosing!</span>"
		return 0

	target.key = key
	mind.ghost = FALSE
	
	return 1


//this is a mob verb instead of atom for performance reasons
//see /mob/verb/examinate() in mob.dm for more info
//overriden here and in /mob/living for different point span classes and sanity checks
/mob/dead/observer/pointed(atom/A as mob|obj|turf in view())
	if(!..())
		return 0
	usr.visible_message("<span class='deadsay'><b>[src]</b> points to [A].</span>")
	return 1

/mob/dead/observer/verb/view_manfiest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += data_core.get_manifest()

	src << browse(dat, "window=manifest;size=387x420;can_close=1")

//this is called when a ghost is drag clicked to something.
/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over) return
	if (isobserver(usr) && usr.client.holder && isliving(over))
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

/mob/dead/observer/Topic(href, href_list)
	..()
	if(usr == src)
		if(href_list["follow"])
			var/atom/movable/target = locate(href_list["follow"])
			if(istype(target) && (target != src))
				ManualFollow(target)
		if(href_list["reenter"])
			reenter_corpse()

//We don't want to update the current var
//But we will still carry a mind.
/mob/dead/observer/mind_initialize()
	return
