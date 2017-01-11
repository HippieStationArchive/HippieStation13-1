#define UPGRADE_COOLDOWN	40
#define UPGRADE_KILL_TIMER	100

/obj/item/weapon/grab
	name = "grab"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "reinforce"
	flags = NOBLUDGEON | ABSTRACT

	var/mob/living/affecting = null
	var/mob/living/assailant = null
	var/state = GRAB_PASSIVE

	var/allow_upgrade = 1
	var/last_upgrade = 0
	var/last_hit_zone = 0
	var/force_down = 0 //Reason why this is not in the appropriate Krav Maga martial art is because of resisting out of pindowns.
	var/dancing = 0 //determines if assailant and affecting keep looking at each other. Basically a wrestling position
	var/headbutt_cooldown = 0
	layer = 21
	item_state = "nothing"
	w_class = 5.0


/obj/item/weapon/grab/New(mob/user, mob/victim)
	..()
	loc = user
	assailant = user
	affecting = victim

	if(affecting.anchored || !user.Adjacent(victim) || issilicon(victim))
		qdel(src)
		return
	affecting.grabbed_by += src

	//check if assailant is grabbed by victim as well
	if(assailant.grabbed_by)
		for (var/obj/item/weapon/grab/G in assailant.grabbed_by)
			if(G.assailant == affecting && G.affecting == assailant)
				G.dancing = 1
				G.adjust_position()
				dancing = 1
	adjust_position()

//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/weapon/grab/proc/get_mob_if_throwable()
	if(affecting)
		if(affecting.buckled)
			return null
		if(assailant.swimming) //Can't throw people while in the pool
			return null
		if(state >= GRAB_AGGRESSIVE)
			return affecting
	return null

/obj/item/weapon/grab/process()
	if(!confirm())
		return 0

	if(ishuman(affecting) && ishuman(assailant))
		var/mob/living/carbon/human/A = assailant //Attacker
		var/mob/living/carbon/human/D = affecting //Defender
		var/datum/martial_art/attacker_style = A.martial_art
		if(attacker_style && attacker_style.grab_process(src,A,D))
			return 0

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0

		if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0

		//disallow upgrading past aggressive if we're being grabbed aggressively
		for(var/obj/item/weapon/grab/G in affecting.grabbed_by)
			if(G == src) continue
			if(G.state >= GRAB_AGGRESSIVE)
				allow_upgrade = 0

		if(allow_upgrade)
			if(state < GRAB_AGGRESSIVE)
				icon_state = "reinforce"
			else
				icon_state = "reinforce1"
		else
			icon_state = "!reinforce"
	else
		if(!affecting.buckled)
			affecting.loc = assailant.loc
			if(istype(affecting, /mob/living/carbon))
				affecting.swimming = assailant.swimming //Double check then make sure grabbing someone out of the pool changes the var.

	if(state >= GRAB_AGGRESSIVE)
		var/h = affecting.hand
		affecting.hand = 0
		affecting.drop_item()
		affecting.hand = 1
		affecting.drop_item()
		affecting.hand = h

		var/hit_zone = assailant.zone_sel.selecting
		var/announce = 0
		if(hit_zone != last_hit_zone)
			announce = 1
		last_hit_zone = hit_zone
		if(ishuman(affecting))
			switch(hit_zone)
				if("mouth")
					if(announce)
						assailant.visible_message("<span class='warning'>[assailant] covers [affecting]'s mouth!</span>")
					if(affecting.silent < 3)
						affecting.silent = 3
				if("eyes")
					if(announce)
						assailant.visible_message("<span class='warning'>[assailant] covers [affecting]'s eyes!</span>")
					if(affecting.eye_blind < 3)
						affecting.eye_blind = 3

	if(state >= GRAB_NECK)
		if(!affecting.buckled)
			affecting.loc = assailant.loc
		affecting.Stun(3) //Before the stun was wayyy too long.
		//No choking for neckgrab, reinforce your grabs instead.

	if(state >= GRAB_KILL)
		affecting.Weaken(3)	//Should keep you down unless you get help.
		affecting.stuttering = max(affecting.stuttering, 5) //It will hamper your voice, being choked and all.
		affecting.losebreath = min(affecting.losebreath + 5, 7) //Choke 'em out!
		if(assailant.swimming == 1)//Oh pool why are you so complicated
			affecting.Weaken(2)	//Should keep you down unless you get help.
			affecting.losebreath = min(affecting.losebreath + 5, 7)
			if(isliving(affecting))
				var/mob/living/L = affecting
				L.adjustOxyLoss(15) //Drowning is fast mang.
	adjust_position()

/obj/item/weapon/grab/attack_self()
	s_click()

/obj/item/weapon/grab/attackby(var/atom/A, var/mob/living/user)
	s_click()

/obj/item/weapon/grab/attack_hand()
	s_click()

//Updating pixelshift, position and direction
//Gets called on process, when the grab gets upgraded or the assailant moves
/obj/item/weapon/grab/proc/adjust_position()
	if(affecting.buckled || !assailant.canmove || assailant.lying || !confirm()) //So people don't get randomly teleported or something
		return
	var/easing = LINEAR_EASING
	var/time = 5
	if(affecting.lying && state != GRAB_KILL)
		animate(affecting, pixel_x = 0, pixel_y = -4, time, 1, easing)
		affecting.layer = 3.9
		if(force_down)
			affecting.set_dir(SOUTH) //face up
		return

	var/shift = 0
	var/adir = get_dir(assailant, affecting)
	// if(affecting.loc = assailant.loc)
	// 	adir = assailant.dir //Fixes some weird animation issues
	affecting.layer = 4
	switch(state)
		if(GRAB_PASSIVE)
			shift = 8
			if(dancing) //look at partner
				shift = 10
				time = 3
				easing = SINE_EASING
				assailant.set_dir(get_dir(assailant, affecting))
		if(GRAB_AGGRESSIVE)
			shift = 12
		if(GRAB_NECK, GRAB_UPGRADING)
			shift = -10
			adir = assailant.dir
			affecting.set_dir(assailant.dir)
			affecting.loc = assailant.loc
		if(GRAB_KILL)
			shift = 0
			adir = 1
			affecting.set_dir(SOUTH)//face up
			affecting.loc = assailant.loc

	var/Pixel_x = 0
	var/Pixel_y = 0
	if(adir & NORTH)
		Pixel_y = -shift
		affecting.layer = 3.9
	if(adir & SOUTH)
		Pixel_y = shift
	if(adir & WEST)
		Pixel_x = shift
	if(adir & EAST)
		Pixel_x =-shift

	animate(affecting, pixel_x = Pixel_x, pixel_y = Pixel_y, time, 1, easing)

/obj/item/weapon/grab/proc/s_click()
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(assailant.next_move > world.time)
		return
	if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return
	if(!assailant.canmove || assailant.lying || !confirm()) //If you're trying to reinforce grab on someone who yackety saxxed away, it shouldn't teleport them to you or something.
		qdel(src)
		return
	if(ishuman(affecting) && ishuman(assailant))
		var/mob/living/carbon/human/A = assailant //Attacker
		var/mob/living/carbon/human/D = affecting //Defender
		var/datum/martial_art/attacker_style = A.martial_art
		if(attacker_style && attacker_style.grab_reinforce_act(src,A,D))
			return

	last_upgrade = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		assailant.visible_message("<span class='warning'>[assailant] has grabbed [affecting] aggressively (now hands)!</span>")
		state = GRAB_AGGRESSIVE
		// icon_state = "grabbed1"
		icon_state = "reinforce1"
	else if(state < GRAB_NECK)
		if(isslime(affecting))
			assailant << "<span class='notice'>You squeeze [affecting], but nothing interesting happens.</span>"
			return
		assailant.visible_message("<span class='warning'>[assailant] has reinforced \his grip on [affecting] (now neck)!</span>")
		state = GRAB_NECK
		assailant.set_dir(get_dir(assailant, affecting)) //Make assailant face affecting
		if(!affecting.buckled)
			affecting.loc = assailant.loc
		icon_state = "grabbed+1"
		assailant.set_dir(get_dir(assailant, affecting))
		add_logs(assailant, affecting, "neck-grabbed")
		if(!iscarbon(assailant))
			affecting.LAssailant = null
		else
			affecting.LAssailant = assailant
		affecting.update_canmove() //Make them stand up for a hostage hold
		icon_state = "kill"
		name = "kill"
	else if(state < GRAB_UPGRADING)
		assailant.visible_message("<span class='danger'>[assailant] starts to tighten \his grip on [affecting]'s neck!</span>")
		icon_state = "kill1"
		state = GRAB_UPGRADING
		if(do_after(assailant, UPGRADE_KILL_TIMER, target = affecting))
			if(state == GRAB_KILL)
				return
			if(!affecting)
				qdel(src)
				return
			if(!assailant.canmove || assailant.lying)
				qdel(src)
				return
			state = GRAB_KILL
			assailant.visible_message("<span class='danger'>[assailant] has tightened \his grip on [affecting]'s neck!</span>")
			add_logs(assailant, affecting, "strangled")

			assailant.changeNext_move(CLICK_CD_TKSTRANGLE)
			affecting.losebreath += 5
		else if(assailant)
			assailant.visible_message("<span class='warning'>[assailant] was unable to tighten \his grip on [affecting]'s neck!</span>")
			icon_state = "kill"
			name = "kill"
			state = GRAB_NECK

	adjust_position()


//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/weapon/grab/proc/confirm()
	if(!assailant || !affecting)
		qdel(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) )
			qdel(src)
			return 0

	return 1


/obj/item/weapon/grab/attack(mob/M, mob/user)
	if(!affecting)
		return 0
	assailant.changeNext_move(0) //Attacking with grab shouldn't add a delay to your next action (fucks with reinforcing grab). Set this to CLICK_CD_MELEE or whatevs in a_intent case checks if you need it.
	if(M == affecting)
		if(ishuman(M) && ishuman(assailant))
			var/mob/living/carbon/human/A = assailant //Attacker
			var/mob/living/carbon/human/D = affecting //Defender
			var/datum/martial_art/attacker_style = A.martial_art
			if(attacker_style && attacker_style.grab_attack_act(src, A,D))
				return 0
			if(assailant.a_intent == "grab")
				s_click()
				return 0

	if(M == assailant && state >= GRAB_AGGRESSIVE)
		if( (ishuman(user) && (user.disabilities & FAT) && ismonkey(affecting) ) || ( isalien(user) && iscarbon(affecting) ) )
			var/mob/living/carbon/attacker = user
			user.visible_message("<span class='danger'>[user] is attempting to devour \the [affecting]!</span>")
			if(istype(user, /mob/living/carbon/alien/humanoid/hunter) || istype(affecting, /mob/living/simple_animal/mouse))
				if(!do_mob(user, affecting)||!do_after(user, 30, target = affecting)) return 0
			else
				if(!do_mob(user, affecting)||!do_after(user, 100, target = affecting)) return 0
			user.visible_message("<span class='danger'>[user] devours \the [affecting]!</span>")
			affecting.loc = user
			attacker.stomach_contents.Add(affecting)
			qdel(src)


	add_logs(user, affecting, "attempted to put", src, "into [M]")

/obj/item/weapon/grab/dropped()
	qdel(src)

/obj/item/weapon/grab/Del()
	if(affecting)
		if(!affecting.buckled)
			affecting.pixel_x = initial(affecting.pixel_x)
			affecting.pixel_y = affecting.get_standard_pixel_y_offset(affecting.lying) //used to be an animate, not quick enough for del'ing
		affecting.layer = initial(affecting.layer)
		affecting.grabbed_by -= src
		affecting.update_canmove()
	..()

/obj/item/weapon/grab/Destroy()
	if(affecting)
		if(!affecting.buckled)
			affecting.pixel_x = initial(affecting.pixel_x)
			affecting.pixel_y = affecting.get_standard_pixel_y_offset(affecting.lying) //used to be an animate, not quick enough for del'ing
		affecting.layer = initial(affecting.layer)
		affecting.grabbed_by -= src
		affecting.update_canmove()
	..()

#undef UPGRADE_COOLDOWN
#undef UPGRADE_KILL_TIMER