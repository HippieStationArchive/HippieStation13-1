
/datum/objective/build
	dangerrating = 15
	martyr_compatible = 1


/datum/objective/build/proc/gen_amount_goal(lower, upper)
	target_amount = rand(lower, upper)
	explanation_text = "Build [target_amount] shrines."
	return target_amount


/datum/objective/build/check_completion()
	if(!owner || !owner.current)
		return 0

	var/shrines = 0
	if(what_rank(owner) == 3)
		var/mob/camera/god/G = owner.current
		for(var/obj/structure/divine/shrine/S in G.structures)
			S++

	return (shrines >= target_amount)



/datum/objective/deicide
	dangerrating = 20
	martyr_compatible = 1

/datum/objective/deicide/check_completion()
	if(target)
		if(target.current) //Gods are deleted when they lose
			return 0
	return 1


/datum/objective/deicide/find_target()
	if(!owner || !owner.current || target)
		return

	if(what_rank(owner) == 3)
		var/mob/camera/god/G = owner.current
		var/list/possibletargets = list()
		var/list/badgods = get_gods()
		for(var/mob/camera/god/badgod in badgods)
			if(badgod.side != G.side)
				possibletargets += badgod.mind // this is default code for only 1 deity as target. If you're gonna add more than one deicide, do what revs does aka forge objectives by making a deicide objective with target set manually
		if(possibletargets.len)
			target = pick(possibletargets)

	update_explanation_text()

/datum/objective/deicide/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Phase [target.name], the false god, out of this plane of existence."
	else
		explanation_text = "Free Objective"



/datum/objective/follower_block
	explanation_text = "Do not allow any followers of the false god to escape on the station's shuttle alive."
	dangerrating = 25
	martyr_compatible = 1

/datum/objective/follower_block/check_completion()
	var/side = is_in_any_team(owner)
	if(!side)
		return 0

	var/area/A = SSshuttle.emergency.areaInstance

	for(var/mob/living/player in player_list)
		if(player.mind && player.stat != DEAD && get_area(player) == A)
			if(is_in_any_team(player) != side)
				return 0
	return 1



/datum/objective/escape_followers
	dangerrating = 5


/datum/objective/escape_followers/proc/gen_amount_goal(lower,upper)
	target_amount = rand(lower,upper)
	explanation_text = "Your will must surpass this station. Having [target_amount] followers escape on the shuttle or pods will allow that."
	return target_amount


/datum/objective/escape_followers/check_completion()
	var/escaped = 0
	var/list/followers = list()
	if(what_rank(owner) == "God")
		var/mob/camera/god/G = owner.current
		followers = G.get_my_followers()
		for(var/mob/F in followers)
			if(F && F.stat != DEAD)
				if(F.onCentcom())
					escaped++

	return (escaped >= target_amount)


/datum/objective/sacrifice_prophet
	explanation_text = "A false prophet is preaching their god's faith on the station. Sacrificing them will show the mortals who the true god is."
	dangerrating = 10


/datum/objective/sacrifice_prophet/check_completion()
	var/mob/camera/god/G = owner.current
	if(istype(G))
		return G.prophets_sacrificed_in_name
	return 0
