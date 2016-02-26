/mob/camera/god/proc/ability_cost(cost = 0,structures = 0, requires_conduit = 0, can_place_near_enemy_nexus = 0)
	if(faith < cost)
		src << "<span class='danger'>You lack the faith!</span>"
		return 0

	if(structures)
		if(!isturf(loc) || istype(loc, /turf/space))
			src << "<span class='danger'>Your structure would just float away, you need stable ground!</span>"
			return 0

		var/turf/T = get_turf(src)
		if(T)
			if(T.density)
				src << "<span class='danger'>There is something blocking your structure!</span>"
				return 0

			for(var/atom/movable/AM in T)
				if(AM == src)
					continue
				if(AM.density)
					src << "<span class='danger'>There is something blocking your structure!</span>"
					return 0

	if(requires_conduit)
		//Organised this way as there can be multiple conduits, so it's more likely to be a conduit check.
		var/valid = 0
		for(var/obj/structure/divine/conduit/C in conduits)
			if(get_dist(src, C) <= CONDUIT_RANGE)
				valid++
				break

		if(!valid)
			if(get_dist(src, god_nexus) <= CONDUIT_RANGE)
				valid++
		if(!valid)
			src << "<span class='danger'>You must be near your Nexus or a Conduit to do this!</span>"
			return 0

	if(!can_place_near_enemy_nexus)
		var/mob/camera/god/enemy
		var/list/gods = get_gods()
		for(var/mob/camera/god/badgod in gods)
			if(badgod.side != side)
				enemy = badgod

		if(enemy && istype(enemy))
			if(enemy.god_nexus && (get_dist(src,enemy.god_nexus) <= CONDUIT_RANGE*2))
				src << "<span class='danger'>You are too close to the other god's stronghold!</span>"
				return 0

	return 1

/mob/camera/god/verb/returntonexus()
	set category = "Deity"
	set name = "Goto Nexus"
	set desc = "Teleports you to your next instantly."

	if(god_nexus)
		Move(get_turf(god_nexus))
	else
		src << "You don't even have a Nexus, construct one."


/mob/camera/god/verb/jumptofollower()
	set category = "Deity"
	set name = "Jump to Follower"
	set desc = "Teleports you to one of your followers."
	var/list/followerminds = get_my_followers()
	var/list/following = list()
	for(var/datum/mind/A in followerminds)
		if(A.current)
			following += A.current
	if(!following.len)
		src << "You are unaligned, and thus do not have followers"
		return

	var/mob/choice = input("Choose a follower","Jump to Follower") as null|anything in following
	if(choice)
		Move(get_turf(choice))


/mob/camera/god/verb/newprophet()
	set category = "Deity"
	set name = "Appoint Prophet (100)"
	set desc = "Appoint one of your followers as your Prophet, who can hear your words"

	var/list/followersmind = get_my_followers()
	var/list/followersmob = list()

	if(!ability_cost(100))
		return
	if(!side)
		src << "You are unalligned, and thus do not have prophets"
		return
	var/datum/mind/old_proph = get_my_prophet()

	if(old_proph && old_proph.current && old_proph.current.stat != DEAD)
		src << "You can only have one prophet alive at a time."
		return

	for(var/datum/mind/A in followersmind)
		if(A.current)
			followersmob += A.current

	var/mob/choice = input("Choose a follower to make into your prophet","Prophet Uplifting") as null|anything in followersmob
	if(choice && choice.stat != DEAD && choice.mind)
		src << "You choose [choice] as your prophet."
		choice.mind.special_role = "Prophet"
		var/datum/faction/HOG/M = choice.mind.faction
		if(M)//should never fail
			M.members[choice.mind] = "Prophet"
		var/datum/action/innate/godspeak/action = new /datum/action/innate/godspeak()
		action.gods.Add(src)
		action.Grant(choice)
		//endround text thingy
		if(istype(ticker.mode, /datum/game_mode/hand_of_god))
			var/datum/game_mode/hand_of_god/mygamemode = ticker.mode
			mygamemode.prophets |= choice.mind // add only if not already in,we don't want double minds in our list


		//Prophet gear
		var/mob/living/carbon/human/H = choice
		var/popehat = /obj/item/clothing/head/helmet/plate/advocate/prophet
		var/popestick = /obj/item/weapon/godstaff

		if(!istype(H))
			return // we aren't gonna gear up mobs who have no slots
		if(popehat)
			var/obj/item/clothing/head/helmet/plate/advocate/prophet/P = new popehat(side = src.side) // using src to not get confused

			H.unEquip(H.head)
			H << "<span class='boldnotice'>A powerful hat has been bestowed upon your head.</span>"
			if(!(H.equip_to_slot_if_possible(P,slot_head,0,1,1)))
				P.loc = get_turf(H) // so this gets put on the floor if for some reasons it fails to get on yer head

		if(popestick)
			var/obj/item/weapon/godstaff/G = new popestick(side = src.side)
			G.god = src
			var/success = ""
			if(!H.put_in_any_hand_if_possible(G, qdel_on_fail = 0, disable_warning = 1, redraw_mob = 1))
				if(!H.equip_to_slot_if_possible(G,slot_in_backpack,0,1,1))
					G.loc = get_turf(H)
					success = "It is on the floor..."
				else
					success = "It is in your backpack..."
			else
				success = "It is in your hands..."

			if(success)
				H << "<span class='boldnotice'>A powerful staff has been bestowed upon you, you can use this to convert the false god's structures!</span>"
				H << "<span class=boldnotice'>[success]</span>"
		//end prophet gear
		ticker.mode.update_hog_icons_added(choice.mind, side)

		add_faith(-100)


/mob/camera/god/verb/talk(msg as text)
	set category = "Deity"
	set name = "Talk to Anyone (20)"
	set desc = "Allows you to send a message to anyone, regardless of their faith."
	if(!ability_cost(20))
		return
	var/mob/choice = input("Choose who you wish to talk to", "Talk to ANYONE") as null|anything in mob_list
	if(choice)
		var/original = msg
		log_say("Hand of God: [capitalize(side)] God/[key_name(src)] > [choice] : [msg]")
		msg = "<B>You hear a voice coming from everywhere and nowhere... <i>[msg]</i></B>"
		choice << msg
		src << "You say the following to [choice], [original]"
		add_faith(-20)


/mob/camera/god/verb/smite()
	set category = "Deity"
	set name = "Smite (40)"
	set desc = "Hits anything under you with a moderate amount of damage."

	if(!ability_cost(40,requires_conduit = 1))
		return
	if(!range(7,god_nexus))
		src << "You lack the strength to smite this far from your nexus."
		return

	var/has_smitten = 0 //Hast thou been smitten, infidel?
	for(var/mob/living/L in get_turf(src))
		if(L.mind && is_in_any_team(L.mind) == side)
			return
		L.adjustFireLoss(5)
		L.adjustBruteLoss(5)
		L.Weaken(10)
		L << "<span class='danger'><B>You feel the wrath of [name]!<B></span>"
		has_smitten = 1
	if(has_smitten)
		add_faith(-40)


/mob/camera/god/verb/disaster()
	set category = "Deity"
	set name = "Invoke Disaster (300)" //difficult to reach without lots of followers
	set desc = "Tug at the fibres of reality itself and bend it to your whims!"

	if(!ability_cost(300, requires_conduit = 1))
		return

	var/event = pick(/datum/round_event/meteor_wave, /datum/round_event/communications_blackout, /datum/round_event/radiation_storm, /datum/round_event/carp_migration,
	/datum/round_event/spacevine, /datum/round_event/vent_clog, /datum/round_event/wormholes)
	if(event)
		new event()
		add_faith(-300)


/mob/camera/god/verb/constructnexus()
	set category = "Deity"
	set name = "Construct Nexus"
	set desc = "Instantly creates your nexus, You can only do this once, make sure you're happy with it!"

	if(!ability_cost(structures = 1))
		return

	place_nexus()


/mob/camera/god/verb/movenexus()
	set category = "Deity"
	set name = "Relocate Nexus (50)"
	set desc = "Instantly relocates your nexus to an existing translocator belonging to your faith, this destroys the translocator in the process"

	if(ability_cost(50) && god_nexus)
		var/list/translocators = list()
		for(var/obj/structure/divine/translocator/TL in structures)
			translocators["[TL.name] ([get_area(TL)])"] = TL

		if(!translocators.len)
			src << "<span class='warning'>You have no translocators!</span>"
			return

		var/picked = input(src,"Choose a translocator","Relocate Nexus") as null|anything in translocators
		if(!picked)
			return
		var/obj/structure/divine/translocator/TR = translocators[picked]
		if(!istype(TR))
			return
		var/turf/Tturf = get_turf(TR)
		god_nexus.forceMove(Tturf)
		add_faith(-50)
		qdel(TR)

/mob/camera/god/verb/construct_structures()
	set category = "Deity"
	set name = "Construct Structure (75)"
	set desc = "Create the foundation of a divine object."

	if(!ability_cost(75,1,1))
		return

	structure_construction_ui(src)


/mob/camera/god/verb/construct_traps()
	set category = "Deity"
	set name = "Construct Trap (20)"
	set desc = "Creates a ward or trap."

	if(!ability_cost(20,1,1))
		return

	trap_construction_ui(src)
