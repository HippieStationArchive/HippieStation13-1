/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.
	var/dangerrating = 0				//How hard the objective is, essentially. Used for dishing out objectives and checking overall victory.
	var/martyr_compatible = 0			//If the objective is compatible with martyr objective, i.e. if you can still do it while dead.

/datum/objective/New(datum/mind/target, text, datum/mind/themind)
	..()
	if(target)
		src.target = target
	if(text)
		explanation_text = text
	if(themind)
		owner = themind
		owner.objectives += src

/datum/objective/proc/select_target()//for adminobjadd
	var/datum/mind/targ = input("Select a target if needed, otherwise hit cancel:", "Objective target") as null|anything in ticker.minds
	if(targ)
		target = targ
	return

/datum/objective/proc/requirements() //proc used for requirements,incase the objective can only exist if something else does.
	return 1

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/is_unique_objective(possible_target)
	for(var/datum/objective/O in owner.objectives)
		if(istype(O, type) && O.get_target() == possible_target)
			return 0
	return 1

/datum/objective/proc/get_target()
	return target

/datum/objective/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2) && is_unique_objective(possible_target))
			possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	update_explanation_text()
	return target

/datum/objective/proc/find_target_by_role(role, role_type=0, invert=0)//Option sets either to check assigned role or special role. Default to assigned., invert inverts the check, eg: "Don't choose a Ling"
	for(var/datum/mind/possible_target in ticker.minds)
		if((possible_target != owner) && ishuman(possible_target.current))
			var/is_role = 0
			if(role_type)
				if(possible_target.special_role == role)
					is_role++
			else
				if(possible_target.assigned_role == role)
					is_role++

			if(invert)
				if(is_role)
					continue
				target = possible_target
				break
			else if(is_role)
				target = possible_target
				break

	update_explanation_text()

/datum/objective/proc/update_explanation_text()
	//Default does nothing, override where needed

/datum/objective/proc/give_special_equipment()

/datum/objective/assassinate
	var/target_role_type=0
	dangerrating = 10
	martyr_compatible = 1

/datum/objective/assassinate/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/assassinate/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		return 0
	return 1

/datum/objective/assassinate/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Assassinate [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"


/datum/objective/mutiny
	var/target_role_type=0
	martyr_compatible = 1
	var/static/list/heads = list()

/datum/objective/mutiny/New(datum/mind/target, text, datum/mind/themind)
	..()
	if(!heads.len)
		heads = ticker.mode.get_living_heads()

/datum/objective/mutiny/select_target()
	var/datum/mind/targ = input("Select a target if needed, otherwise hit cancel:", "Objective target") as null|anything in heads
	if(targ)
		target = targ

/datum/objective/mutiny/find_target_by_role(role, role_type=0,invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/mutiny/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || !ishuman(target.current) || !target.current.ckey || !target.current.client)
			return 1
		var/turf/T = get_turf(target.current)
		if(T && (T.z > ZLEVEL_STATION) || target.current.client.is_afk())			//If they leave the station or go afk they count as dead for this
			return 2
		return 0
	return 1

/datum/objective/mutiny/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Assassinate or exile [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"



/datum/objective/maroon
	var/target_role_type=0
	dangerrating = 5
	martyr_compatible = 1

/datum/objective/maroon/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/maroon/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		if(target.current.onCentcom() || target.current.onSyndieBase())
			return 0
	return 1

/datum/objective/maroon/update_explanation_text()
	if(target && target.current)
		explanation_text = "Prevent [target.name], the [!target_role_type ? target.assigned_role : target.special_role], from escaping alive."
	else
		explanation_text = "Free Objective"



/datum/objective/debrain//I want braaaainssss
	var/target_role_type=0
	dangerrating = 20

/datum/objective/debrain/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/debrain/check_completion()
	if(!target)//If it's a free objective.
		return 1
	if( !owner.current || owner.current.stat==DEAD )//If you're otherwise dead.
		return 0
	if( !target.current || !isbrain(target.current) )
		return 0
	var/atom/A = target.current
	while(A.loc)			//check to see if the brainmob is on our person
		A = A.loc
		if(A == owner.current)
			return 1
	return 0

/datum/objective/debrain/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Steal the brain of [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"



/datum/objective/protect//The opposite of killing a dude.
	var/target_role_type=0
	dangerrating = 10
	martyr_compatible = 1

/datum/objective/protect/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/protect/check_completion()
	if(!target)			//If it's a free objective.
		return 1
	if(target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return 0
		return 1
	return 0

/datum/objective/protect/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Protect [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"



/datum/objective/hijack
	explanation_text = "Hijack the shuttle to ensure no loyalist Nanotrasen crew escape alive and out of custody."
	dangerrating = 25
	martyr_compatible = 0 //Technically you won't get both anyway.

/datum/objective/hijack/check_completion()
	if(!owner.current || owner.current.stat)
		return 0
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	if(issilicon(owner.current))
		return 0

	var/area/A = get_area(owner.current)
	if(SSshuttle.emergency.areaInstance != A)
		return 0

	for(var/mob/living/player in player_list)
		if(player.mind && player.mind != owner)
			if(player.stat != DEAD)
				if(istype(player, /mob/living/silicon)) //Borgs are technically dead anyways
					continue
				if(get_area(player) == A)
					if(!player.mind.special_role && !istype(get_turf(player.mind.current), /turf/simulated/floor/plasteel/shuttle/red))
						return 0
	return 1

/datum/objective/hijackclone
	explanation_text = "Hijack the emergency shuttle by ensuring only you (or your copies) escape."
	dangerrating = 25
	martyr_compatible = 0

/datum/objective/hijackclone/check_completion()
	if(!owner.current)
		return 0
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0

	var/area/A = SSshuttle.emergency.areaInstance

	for(var/mob/living/player in player_list) //Make sure nobody else is onboard
		if(player.mind && player.mind != owner)
			if(player.stat != DEAD)
				if(istype(player, /mob/living/silicon))
					continue
				if(get_area(player) == A)
					if(player.real_name != owner.current.real_name && !istype(get_turf(player.mind.current), /turf/simulated/floor/plasteel/shuttle/red))
						return 0

	for(var/mob/living/player in player_list) //Make sure at least one of you is onboard
		if(player.mind && player.mind != owner)
			if(player.stat != DEAD)
				if(istype(player, /mob/living/silicon))
					continue
				if(get_area(player) == A)
					if(player.real_name == owner.current.real_name && !istype(get_turf(player.mind.current), /turf/simulated/floor/plasteel/shuttle/red))
						return 1
	return 0

/datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."
	dangerrating = 25
	martyr_compatible = 1

/datum/objective/block/check_completion()
	if(!istype(owner.current, /mob/living/silicon))
		return 0
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 1

	var/area/A = SSshuttle.emergency.areaInstance

	for(var/mob/living/player in player_list)
		if(istype(player, /mob/living/silicon))
			continue
		if(player.mind)
			if(player.stat != DEAD)
				if(get_area(player) == A)
					return 0

	return 1


/datum/objective/escape
	explanation_text = "Escape on the shuttle or an escape pod alive and without being in custody."
	dangerrating = 5

/datum/objective/escape/check_completion()
	if(issilicon(owner.current))
		return 0
	if(isbrain(owner.current))
		return 0
	if(!owner.current || owner.current.stat == DEAD)
		return 0
	if(ticker.force_ending) //This one isn't their fault, so lets just assume good faith
		return 1
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	var/turf/location = get_turf(owner.current)
	if(!location)
		return 0

	if(istype(location, /turf/simulated/floor/plasteel/shuttle/red)) // Fails traitors if they are in the shuttle brig -- Polymorph
		return 0

	if(location.onCentcom() || location.onSyndieBase())
		return 1

	return 0

/datum/objective/escape/escape_with_identity
	dangerrating = 10
	var/target_real_name // Has to be stored because the target's real_name can change over the course of the round
	var/target_missing_id

/datum/objective/escape/escape_with_identity/find_target()
	target = ..()
	update_explanation_text()

/datum/objective/escape/escape_with_identity/update_explanation_text()
	if(target && target.current)
		target_real_name = target.current.real_name
		explanation_text = "Escape on the shuttle or an escape pod with the identity of [target_real_name], the [target.assigned_role]"
		var/mob/living/carbon/human/H
		if(ishuman(target.current))
			H = target.current
		if(H && H.get_id_name() != target_real_name)
			target_missing_id = 1
		else
			explanation_text += " while wearing their identification card"
		explanation_text += "." //Proper punctuation is important!

	else
		explanation_text = "Free Objective."

/datum/objective/escape/escape_with_identity/check_completion()
	if(!target_real_name)
		return 1
	if(!ishuman(owner.current))
		return 0
	var/mob/living/carbon/human/H = owner.current
	if(..())
		if(H.dna.real_name == target_real_name)
			if(H.get_id_name()== target_real_name || target_missing_id)
				return 1
	return 0


/datum/objective/survive
	explanation_text = "Stay alive until the end."
	dangerrating = 3

/datum/objective/survive/check_completion()
	if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
		return 0		//Brains no longer win survive objectives. --NEO
	if(!is_special_character(owner.current) && !isAI(owner.current)) //This fails borg'd traitors, does not fail traitor AIs
		return 0
	return 1


/datum/objective/martyr
	explanation_text = "Die a glorious death."
	dangerrating = 1

/datum/objective/martyr/check_completion()
	if(!owner.current) //Gibbed, etc.
		return 1
	if(owner.current && owner.current.stat == DEAD) //You're dead! Yay!
		return 1
	return 0


/datum/objective/nuclear
	explanation_text = "Destroy the station with a nuclear device."
	martyr_compatible = 1

/datum/objective/nuclear/check_completion()
	if(ticker && ticker.mode && ticker.mode.station_was_nuked)
		return 1
	return 0

var/global/list/possible_items = list()
/datum/objective/steal
	var/datum/objective_item/targetinfo = null //Save the chosen item datum so we can access it later.
	var/obj/item/steal_target = null //Needed for custom objectives (they're just items, not datums).
	dangerrating = 5 //Overridden by the individual item's difficulty, but defaults to 5 for custom objectives.
	martyr_compatible = 0

/datum/objective/steal/get_target()
	return steal_target

/datum/objective/steal/New(datum/mind/target, text, datum/mind/themind)
	..()
	if(!possible_items.len)//Only need to fill the list when it's needed.
		init_subtypes(/datum/objective_item/steal,possible_items)

/datum/objective/steal/find_target()
	var/approved_targets = list()
	for(var/datum/objective_item/possible_item in possible_items)
		if(is_unique_objective(possible_item.targetitem) && !(owner.current.mind.assigned_role in possible_item.excludefromjob))
			approved_targets += possible_item
	return set_target(safepick(approved_targets))

/datum/objective/steal/proc/set_target(datum/objective_item/item)
	if(item)
		targetinfo = item

		steal_target = targetinfo.targetitem
		explanation_text = "Steal [targetinfo.name]."
		dangerrating = targetinfo.difficulty
		give_special_equipment()
		return steal_target
	else
		explanation_text = "Free objective"
		return

/datum/objective/steal/select_target() //For admins setting objectives manually.
	var/list/possible_items_all = possible_items + "custom"
	var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
	if(!new_target) return

	if(new_target == "custom") //Can set custom items.
		var/custom_target = input(usr, "Specify the obj type or write 'marked' if you have marked the target object:", "Choose a target") as text|null
		if (!custom_target) return
		if(custom_target == "marked")
			if(usr.client)
				var/client/C = usr.client
				if(C.holder.marked_datum && istype(C.holder.marked_datum, /obj/item))
					steal_target = C.holder.marked_datum
		else if(text2path(custom_target))
			var/path = text2path(custom_target)
			if(ispath(path, /obj/item))
				steal_target = path
		var/custom_name = ""
		if(!steal_target)
			return
		if(ispath(steal_target))
			custom_name = initial(steal_target.name)
		else
			custom_name = steal_target.name
		explanation_text = "Steal[ispath(steal_target) ? " \a [custom_name]" : " the [custom_name]"]."

	else
		set_target(new_target)
	return steal_target

/datum/objective/steal/check_completion()
	if(!steal_target)	return 0
	if(!isliving(owner.current))	return 0
	var/list/all_items = owner.current.GetAllContents()	//this should get things in cheesewheels, books, etc.

	for(var/obj/I in all_items) //Check for items
		if(!ispath(steal_target))//if steal target's a marked item
			var/obj/item/targ = steal_target
			if(istype(I, targ.type))
				return 1
		if(istype(I, steal_target))//otherwise it's a path
			if(targetinfo && targetinfo.check_special_completion(I))//Returns 1 by default. Items with special checks will return 1 if the conditions are fulfilled.
				return 1
			else //If there's no targetinfo, then that means it was a custom objective. At this point, we know you have the item, so return 1.
				return 1

		if(targetinfo && I.type in targetinfo.altitems) //Ok, so you don't have the item. Do you have an alternative, at least?
			if(targetinfo.check_special_completion(I))//Yeah, we do! Don't return 0 if we don't though - then you could fail if you had 1 item that didn't pass and got checked first!
				return 1
	return 0

/datum/objective/steal/give_special_equipment()
	if(owner && owner.current && targetinfo)
		if(istype(owner.current, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = owner.current
			var/list/slots = list (
				"backpack" = slot_in_backpack,
				"left hand" = slot_l_hand,
				"right hand" = slot_r_hand,
			)
			for(var/eq_path in targetinfo.special_equipment)
				var/obj/O = new eq_path
				var/equip = H.equip_in_one_of_slots(O, slots, qdel_on_fail = 0)
				if(!equip) // if somehow it failed to put the special equip in your backpack/hands, put it under you. should never happen tho.
					O.loc = get_turf(H)
				H.update_icons()

var/global/list/possible_items_special = list()
/datum/objective/steal/special //ninjas are so special they get their own subtype good for them

/datum/objective/steal/special/New(datum/mind/target, text, datum/mind/themind)
	..()
	if(!possible_items_special.len)
		init_subtypes(/datum/objective_item/special,possible_items)
		init_subtypes(/datum/objective_item/stack,possible_items)

/datum/objective/steal/special/find_target()
	return set_target(pick(possible_items_special))



/datum/objective/steal/exchange
	dangerrating = 10
	martyr_compatible = 0

/datum/objective/steal/exchange/select_target()
	var/fact = input(usr, "What faction should this guy be?", "Faction selecting") as anything in list("red", "blue")
	var/targ = input(usr, "Who shall the target be?", "Target selecting") as null|anything in ticker.minds
	set_faction(fact, targ)
	return

/datum/objective/steal/exchange/proc/set_faction(faction,otheragent)
	target = otheragent
	if(faction == "red")
		targetinfo = new/datum/objective_item/unique/docs_blue
	else if(faction == "blue")
		targetinfo = new/datum/objective_item/unique/docs_red
	explanation_text = "Acquire [targetinfo.name] held by [target.current.real_name], the [target.assigned_role] and syndicate agent"
	steal_target = targetinfo.targetitem


/datum/objective/steal/exchange/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Acquire [targetinfo.name] held by [target.name], the [target.assigned_role] and syndicate agent"
	else
		explanation_text = "Free Objective"


/datum/objective/steal/exchange/backstab
	dangerrating = 3

/datum/objective/steal/exchange/backstab/set_faction(faction)
	if(faction == "red")
		targetinfo = new/datum/objective_item/unique/docs_red
	else if(faction == "blue")
		targetinfo = new/datum/objective_item/unique/docs_blue
	explanation_text = "Do not give up or lose [targetinfo.name]."
	steal_target = targetinfo.targetitem


/datum/objective/steal/disk
	dangerrating = 15
	martyr_compatible = 0
	targetinfo = new/datum/objective_item/steal/nukedisc_special
	steal_target = /obj/item/weapon/disk/nuclear
	explanation_text = "Survive the round with the Nuclear Authentication Disk in your possession, or escape with more telecrystals than any other traitor. Holding the disk grants you one additional telecrystal per minute. Be warned, other traitors are also after the disk."

/datum/objective/steal/disk/select_target()
	return

/datum/objective/steal/disk/check_completion()
	var/obj/item/device/uplink/O = owner.find_syndicate_uplink()
	if(!isliving(owner.current))	return 0
	if(O)
		var/leader = 1
		var/turf/location = get_turf(owner.current)
		for(var/mob/living/player in player_list)
			if(player.mind)
				if(player.mind.special_role && player.mind != owner)
					if(player.stat != DEAD)
						if(istype(player, /mob/living/silicon))
							continue
						if(player.onCentcom())
							if(!istype(get_turf(player), /turf/simulated/floor/plasteel/shuttle/red))
								var/obj/item/device/uplink/U = player.mind.find_syndicate_uplink()
								if(O.uses < U.uses) // Checks to see if anybody has more TC than you and is also on centcom
									leader = 0
		if(leader == 1 && location.onCentcom() && !istype(location, /turf/simulated/floor/plasteel/shuttle/red)) // If you have more TC than anybody else and get to centcom, you greentext, otherwise it checks to see if you have the disk.
			return 1
	var/list/all_items = owner.current.GetAllContents()
	for(var/obj/I in all_items)
		if(istype(I, steal_target))
			return 1
	return 0

/datum/objective/download
	dangerrating = 10

/datum/objective/download/select_target()
	return gen_amount_goal()

/datum/objective/download/proc/gen_amount_goal()
	target_amount = rand(10,20)
	explanation_text = "Download [target_amount] research level\s."
	return target_amount

/datum/objective/download/check_completion()//NINJACODE
	if(!ishuman(owner.current))
		return 0

	var/mob/living/carbon/human/H = owner.current
	if(!H || H.stat == DEAD)
		return 0

	if(!istype(H.wear_suit, /obj/item/clothing/suit/space/space_ninja))
		return 0

	var/obj/item/clothing/suit/space/space_ninja/SN = H.wear_suit
	if(!SN.s_initialized)
		return 0

	var/current_amount
	if(!SN.stored_research.len)
		return 0
	else
		for(var/datum/tech/current_data in SN.stored_research)
			if(current_data.level)
				current_amount += (current_data.level-1)
	if(current_amount<target_amount)
		return 0
	return 1



/datum/objective/capture
	dangerrating = 10

/datum/objective/capture/select_target()
	return gen_amount_goal()

/datum/objective/capture/proc/gen_amount_goal()
		target_amount = rand(5,10)
		explanation_text = "Capture [target_amount] lifeform\s with an energy net. Live, rare specimens are worth more."
		return target_amount

/datum/objective/capture/check_completion()//Basically runs through all the mobs in the area to determine how much they are worth.
	var/captured_amount = 0
	var/area/centcom/holding/A = locate()
	for(var/mob/living/carbon/human/M in A)//Humans.
		if(M.stat==2)//Dead folks are worth less.
			captured_amount+=0.5
			continue
		captured_amount+=1
	for(var/mob/living/carbon/monkey/M in A)//Monkeys are almost worthless, you failure.
		captured_amount+=0.1
	for(var/mob/living/carbon/alien/larva/M in A)//Larva are important for research.
		if(M.stat==2)
			captured_amount+=0.5
			continue
		captured_amount+=1
	for(var/mob/living/carbon/alien/humanoid/M in A)//Aliens are worth twice as much as humans.
		if(istype(M, /mob/living/carbon/alien/humanoid/royal/queen))//Queens are worth three times as much as humans.
			if(M.stat==2)
				captured_amount+=1.5
			else
				captured_amount+=3
			continue
		if(M.stat==2)
			captured_amount+=1
			continue
		captured_amount+=2
	if(captured_amount<target_amount)
		return 0
	return 1



/datum/objective/absorb
	dangerrating = 10

/datum/objective/absorb/select_target()
	return gen_amount_goal()

/datum/objective/absorb/proc/gen_amount_goal(lowbound = 4, highbound = 6)
	target_amount = rand (lowbound,highbound)
	if (ticker)
		var/n_p = 1 //autowin
		if (ticker.current_state == GAME_STATE_SETTING_UP)
			for(var/mob/new_player/P in player_list)
				if(P.client && P.ready && P.mind!=owner)
					n_p ++
		else if (ticker.current_state == GAME_STATE_PLAYING)
			for(var/mob/living/carbon/human/P in player_list)
				if(P.client && !(P.mind in ticker.mode.changelings) && P.mind!=owner)
					n_p ++
		target_amount = min(target_amount, n_p)

	explanation_text = "Extract [target_amount] compatible genome\s."
	return target_amount

/datum/objective/absorb/check_completion()
	if(owner && owner.changeling && owner.changeling.stored_profiles && (owner.changeling.absorbedcount >= target_amount))
		return 1
	else
		return 0



/datum/objective/destroy
	dangerrating = 10
	martyr_compatible = 1

/datum/objective/destroy/select_target()
	return find_target()

/datum/objective/destroy/find_target()
	var/list/possible_targets = active_ais(1)
	var/mob/living/silicon/ai/target_ai = pick(possible_targets)
	target = target_ai.mind
	update_explanation_text()
	return target

/datum/objective/destroy/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		return 0
	return 1

/datum/objective/destroy/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Destroy [target.name], the experimental AI."
	else
		explanation_text = "Free Objective"

/datum/objective/summon_guns
	explanation_text = "Steal at least five guns!"

/datum/objective/summon_guns/select_target()
	return

/datum/objective/summon_guns/check_completion()
	if(!isliving(owner.current))	return 0
	var/guncount = 0
	var/list/all_items = owner.current.GetAllContents()	//this should get things in cheesewheels, books, etc.
	for(var/obj/I in all_items) //Check for guns
		if(istype(I, /obj/item/weapon/gun))
			guncount++
	if(guncount >= 5)
		return 1
	else
		return 0
	return 0



////////////////////////////////
// Changeling team objectives //
////////////////////////////////

/datum/objective/changeling_team_objective //Abstract type
	martyr_compatible = 0	//Suicide is not teamwork!
	explanation_text = "Changeling Friendship!"
	var/min_lings = 3 //Minimum amount of lings for this team objective to be possible
	var/escape_objective_compatible = FALSE


//Impersonate department
//Picks as many people as it can from a department (Security,Engineer,Medical,Science)
//and tasks the lings with killing and replacing them
/datum/objective/changeling_team_objective/impersonate_department
	explanation_text = "Ensure X derpartment are killed, impersonated, and replaced by Changelings"
	var/command_staff_only = FALSE //if this is true, it picks command staff instead
	var/list/department_minds = list()
	var/list/department_real_names = list()
	var/department_string = ""


/datum/objective/changeling_team_objective/impersonate_department/proc/get_department_staff()
	department_minds = list()
	department_real_names = list()

	var/list/departments = list("Head of Security","Research Director","Chief Engineer","Chief Medical Officer")
	var/department_head = pick(departments)
	switch(department_head)
		if("Head of Security")
			department_string = "security"
		if("Research Director")
			department_string = "science"
		if("Chief Engineer")
			department_string = "engineering"
		if("Chief Medical Officer")
			department_string = "medical"

	var/ling_count = ticker.mode.changelings

	for(var/datum/mind/M in ticker.minds)
		if(M in ticker.mode.changelings)
			continue
		if(department_head in get_department_heads(M.assigned_role))
			if(ling_count)
				ling_count--
				department_minds += M
				department_real_names += M.current.real_name
			else
				break

	if(!department_minds.len)
		log_game("[type] has failed to find department staff, and has removed itself. the round will continue normally")
		owner.objectives -= src
		qdel(src)
		return


/datum/objective/changeling_team_objective/impersonate_department/proc/get_heads()
	department_minds = list()
	department_real_names = list()

	//Needed heads is between min_lings and the maximum possible amount of command roles
	//So at the time of writing, rand(3,6), it's also capped by the amount of lings there are
	//Because you can't fill 6 head roles with 3 lings

	var/needed_heads = rand(min_lings,command_positions.len)
	needed_heads = min(ticker.mode.changelings.len,needed_heads)

	var/list/heads = ticker.mode.get_living_heads()
	for(var/datum/mind/head in heads)
		if(head in ticker.mode.changelings) //Looking at you HoP.
			continue
		if(needed_heads)
			department_minds += head
			department_real_names += head.current.real_name
			needed_heads--
		else
			break

	if(!department_minds.len)
		log_game("[type] has failed to find department heads, and has removed itself. the round will continue normally")
		owner.objectives -= src
		qdel(src)
		return


/datum/objective/changeling_team_objective/impersonate_department/New(datum/mind/target, text, datum/mind/themind)
	..()
	if(command_staff_only)
		get_heads()
	else
		get_department_staff()

	update_explanation_text()


/datum/objective/changeling_team_objective/impersonate_department/update_explanation_text()
	..()
	if(!department_real_names.len || !department_minds.len)
		explanation_text = "Free Objective"
		return  //Something fucked up, give them a win

	if(command_staff_only)
		explanation_text = "Ensure changelings impersonate and escape as the following heads of staff: "
	else
		explanation_text = "Ensure changelings impersonate and escape as the following members of \the [department_string] department: "

	var/first = 1
	for(var/datum/mind/M in department_minds)
		var/string = "[M.name] the [M.assigned_role]"
		if(!first)
			string = ", [M.name] the [M.assigned_role]"
		else
			first--
		explanation_text += string

	if(command_staff_only)
		explanation_text += ", while the real heads are dead. This is a team objective."
	else
		explanation_text += ", while the real members are dead. This is a team objective."


/datum/objective/changeling_team_objective/impersonate_department/check_completion()
	if(!department_real_names.len || !department_minds.len)
		return 1 //Something fucked up, give them a win

	var/list/check_names = department_real_names.Copy()

	//Check each department member's mind to see if any of them made it to centcomm alive, if they did it's an automatic fail
	for(var/datum/mind/M in department_minds)
		if(M in ticker.mode.changelings) //Lings aren't picked for this, but let's be safe
			continue

		if(M.current)
			var/turf/mloc = get_turf(M.current)
			if(mloc.onCentcom() && (M.current.stat != DEAD))
				return 0 //A Non-ling living target got to centcomm, fail

	//Check each staff member has been replaced, by cross referencing changeling minds, changeling current dna, the staff minds and their original DNA names
	var/success = 0
	changelings:
		for(var/datum/mind/changeling in ticker.mode.changelings)
			if(success >= department_minds.len) //We did it, stop here!
				return 1
			if(ishuman(changeling.current))
				var/mob/living/carbon/human/H = changeling.current
				var/turf/cloc = get_turf(changeling.current)
				if(cloc && cloc.onCentcom() && (changeling.current.stat != DEAD)) //Living changeling on centcomm....
					for(var/name in check_names) //Is he (disguised as) one of the staff?
						if(H.dna.real_name == name)
							check_names -= name //This staff member is accounted for, remove them, so the team don't succeed by escape as 7 of the same engineer
							success++ //A living changeling staff member made it to centcomm
							continue changelings

	if(success >= department_minds.len)
		return 1
	return 0




//A subtype of impersonate_derpartment
//This subtype always picks as many command staff as it can (HoS,HoP,Cap,CE,CMO,RD)
//and tasks the lings with killing and replacing them
/datum/objective/changeling_team_objective/impersonate_department/impersonate_heads
	explanation_text = "Have X or more heads of staff escape on the shuttle disguised as heads, while the real heads are dead"
	command_staff_only = TRUE



//CREW OBJECTIVES
//Divided in departments, there are medical objectives, science objectives, etcetera.
//the var "objdone" is the total value of the objectives done. At roundend this value will show up how many researchers did their objectives. Must be declared
//separately for each department.
var/list/departments = list(/datum/objective/crew/research = "R&D", /datum/objective/crew/engineering = "Engineering", /datum/objective/crew/medical = "Medical", /datum/objective/crew/security = "Security", /datum/objective/crew/supply = "Supply", /datum/objective/crew/service = "Service", /datum/objective/crew/civilian = "Civilian")
var/list/deptpoints = list(/datum/objective/crew/research = 0, /datum/objective/crew/engineering = 0, /datum/objective/crew/medical = 0, /datum/objective/crew/security = 0, /datum/objective/crew/supply = 0, /datum/objective/crew/service = 0, /datum/objective/crew/civilian = 0)

/datum/objective/crew
	var/tracked = FALSE // if set to true,the objective will be checked every jobs subsystem fire() proc
	var/mytag
	var/jobs = "" //for objectives restricted to a job(ie research level to scientist, roboticists don't deal with that)(MUST BE A TEXT STRING,initial doesn't work on lists.

/datum/objective/crew/select_target()
	return

/datum/objective/crew/New(datum/mind/target, text, datum/mind/themind)
	..()
	update_explanation_text()
	if(tracked)
		trackedcrewobjs |= src

/datum/objective/crew/check_completion(win = 0)
	if(win)
		var/deptpath
		for(var/i in departments)
			if(departments[i] == mytag)
				deptpath = i
		deptpoints[deptpath]++

//RESEARCH
/datum/objective/crew/research
	mytag = "R&D"
	jobs = "Research Director#Scientist#Roboticist"

//------ Reach level X in research Y

/datum/objective/crew/research/level
	jobs = "Research Director#Scientist"
	var/datum/tech/tech
	var/wantedlevel

/datum/objective/crew/research/level/New(datum/mind/target, text, datum/mind/themind)
	tech = pick(typesof(/datum/tech) - /datum/tech)
	wantedlevel = rand(3,6)
	..()

/datum/objective/crew/research/level/check_completion()
	for(var/obj/machinery/r_n_d/server/S in machines)
		if(S.disabled)
			continue
		var/datum/tech/servertech = locate(tech) in S.files.known_tech
		if(servertech.level >= wantedlevel)
			..(1)
			return 1
	return 0

/datum/objective/crew/research/level/update_explanation_text()
	..()
	explanation_text = "Reach level [wantedlevel] in [initial(tech.name)]."

//------ Get a special slime

/datum/objective/crew/research/getslime
	jobs = "Research Director#Scientist"
	var/colorneeded

/datum/objective/crew/research/getslime/New(datum/mind/target, text, datum/mind/themind)
	..()
	colorneeded = pick("gold", "adamantine", "pink", "oil", "black")

/datum/objective/crew/research/getslime/check_completion()
	for(var/mob/living/simple_animal/slime/S in mob_list)
		if(S.colour == colorneeded)
			..(1)
			return 1

/datum/objective/crew/research/getslime/update_explanation_text()
	..()
	explanation_text = "Produce at least a single [colorneeded] slime."

//------ Make telesci great again

/datum/objective/crew/research/telesci
	jobs = "Research Director#Scientist"

/datum/objective/crew/research/telesci/check_completion()
	var/obj/machinery/computer/telescience/T = locate() in machines
	if(T && T.telepad)
		..(1)
		return 1

/datum/objective/crew/research/telesci/update_explanation_text()
	..()
	explanation_text = "Make telescience great again! Build a functional telescience computer, linked to a telepad."

//------ Make x bots of y type

/datum/objective/crew/research/bots
	jobs = "Research Director#Roboticist"
	var/obj/machinery/bot/bottype
	var/amt = 0

/datum/objective/crew/research/bots/New(datum/mind/target, text, datum/mind/themind)
	..()
	bottype = pick(typesof(/obj/machinery/bot) - /obj/machinery/bot/mulebot)
	amt = rand(2,4)

/datum/objective/crew/research/bots/check_completion()
	var/botamt = 0
	var/list/craftedbots = SSbot.processing - SSbot.roundstartbots
	for(var/obj/machinery/bot/B in craftedbots)
		if(istype(B, bottype))
			botamt++
	if(botamt >= amt)
		..(1)
		return 1

/datum/objective/crew/research/bots/update_explanation_text()
	..()
	explanation_text = "Craft at least [amt] number of [initial(bottype.name)]s and ensure they survive till the shift ends. Roundstart ones don't count, so name them!"

//------ Make x drones, so ghosts can fucking play too, it's a tragedy that there needs to be an objective to remember the roboticist about this

/datum/objective/crew/research/drones
	jobs = "Research Director#Roboticist"
	var/amt = 0

/datum/objective/crew/research/drones/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = rand(10,15)

/datum/objective/crew/research/drones/check_completion()
	var/droneamt = 0
	for(var/i in existing_shells)
		droneamt++
	for(var/mob/living/simple_animal/drone/D in living_mob_list)
		droneamt++
	if(droneamt >= amt)
		..(1)
		return 1

/datum/objective/crew/research/drones/update_explanation_text()
	..()
	explanation_text = "Build at least [amt] drones, doesn't matter if active or not, but they must be kept intact."

//------ Make x borgs and keep them alive till round end
/datum/objective/crew/research/borgs
	jobs = "Research Director#Roboticist"
	var/amt

/datum/objective/crew/research/borgs/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = rand(2,3)

/datum/objective/crew/research/borgs/check_completion()
	for(var/mob/living/silicon/robot/R in living_mob_list)
		if(R.stat != DEAD)
			amt--
	if(!amt)
		..(1)
		return 1

/datum/objective/crew/research/borgs/update_explanation_text()
	..()
	explanation_text = "Have at least [amt] alive cyborgs at the end of the shift."

//ENGINEERING
/datum/objective/crew/engineering
	mytag = "Engineering"
	jobs = "Chief Engineer#Station Engineer#Atmospheric Technician"

//------ Full smes

/datum/objective/crew/engineering/fullsmes
	jobs = "Chief Engineer#Station Engineer"
	var/powerrequired = 0

/datum/objective/crew/engineering/fullsmes/New(datum/mind/target, text, datum/mind/themind)
	..()
	powerrequired = rand(7,12)

/datum/objective/crew/engineering/fullsmes/check_completion()
	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != 1)
			continue
		powerrequired -= S.charge
		if(powerrequired <= 0)
			powerrequired = 0
			break
	if(!powerrequired)
		..(1)
		return 1

/datum/objective/crew/engineering/fullsmes/update_explanation_text()
	..()
	explanation_text = "Get the station's SMESes to a complessive charge of [powerrequired] millions of Watts. Keep in mind that each SMES can hold 3.3 millions of Watts."

//------ Both engines on
/datum/objective/crew/engineering/engines
	jobs = "Chief Engineer#Station Engineer"
	var/engines = 0

/datum/objective/crew/engineering/engines/check_completion()
	for(var/obj/singularity/sing in poi_list)
		if(sing.energy >= 500) // stage 3
			var/count = locate(/obj/machinery/field/containment) in ultra_range(30, sing, 1)
			if(count)
				engines++
				break
	for(var/obj/machinery/power/supermatter/sm in machines)
		if(sm.has_been_powered && !sm.damage)
			engines++
			break
	if(engines == 2)
		..(1)
		return 1

/datum/objective/crew/engineering/engines/update_explanation_text()
	..()
	explanation_text = "Set both the singularity and the supermatter and keep them safe and contained till the shift's end."

//------ Keep station in a decent state
/datum/objective/crew/engineering/integrity

/datum/objective/crew/engineering/integrity/check_completion()
	var/datum/station_state/end_state = new /datum/station_state()
	end_state.count()
	var/station_integrity = min(round( 100 * start_state.score(end_state), 0.1), 100)
	if(station_integrity >= 95)
		..(1)
		return 1

/datum/objective/crew/engineering/integrity/update_explanation_text()
	..()
	explanation_text = "Ensure that the station's integrity is up to 95% when the shift ends."

//------ Have no fire lit at round end
/datum/objective/crew/engineering/nofire
	jobs = "Chief Engineer#Atmospheric Technician"
	var/obj/machinery/computer/station_alert/alert

/datum/objective/crew/engineering/nofire/New(datum/mind/target, text, datum/mind/themind)
	..()
	alert = new()

/datum/objective/crew/engineering/nofire/check_completion()
	var/list/fires = alert.alarms["Fire"]
	if(!fires.len)
		..(1)
		return 1

/datum/objective/crew/engineering/nofire/update_explanation_text()
	..()
	explanation_text = "Ensure that there's no fire anywhere when the shift ends.Use the station alert console in atmospherics to check for fire alarms."

//------ Have all air alarms send no alert
/datum/objective/crew/engineering/airalarm
	jobs = "Chief Engineer#Atmospheric Technician"
	var/obj/machinery/computer/atmos_alert/check // used for its alert list,

/datum/objective/crew/engineering/airalarm/New(datum/mind/target, text, datum/mind/themind)
	..()
	check = new()

/datum/objective/crew/engineering/airalarm/check_completion()
	if(!check.priority_alarms.len)
		..(1)
		return 1

/datum/objective/crew/engineering/airalarm/update_explanation_text()
	..()
	explanation_text = "Have no priority alarms on the atmospheric alert console at shift end."

//MEDICAL

/datum/objective/crew/medical
	mytag = "Medical"
	jobs = "Chief Medical Officer#Medical Doctor#Chemist#Geneticist#Virologist"

//------ Corpses shall go in the morgue

/datum/objective/crew/medical/morgue
	jobs = "Chief Medical Officer#Medical Doctor#Geneticist"

/datum/objective/crew/medical/morgue/check_completion()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.stat == DEAD && H.z == 1)//only the station matters
			if(H.loc)
				if(H.loc.type == /obj/structure/bodycontainer/morgue)
					continue
				else
					return 0
	..(1)
	return 1

/datum/objective/crew/medical/morgue/update_explanation_text()
	..()
	explanation_text = "Have no corpses on the station outside morgues at shift end."

//------ Survivor rate must be kept high

/datum/objective/crew/medical/survivor
	jobs = "Chief Medical Officer#Medical Doctor"
	var/percneeded = 0

/datum/objective/crew/medical/survivor/New(datum/mind/target, text, datum/mind/themind)
	..()
	percneeded = rand(6,9)

/datum/objective/crew/medical/survivor/check_completion()
	var/num_survivors = 0
	for(var/mob/Player in mob_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD && !isbrain(Player))
				num_survivors++
	var/percentage = round((num_survivors/joined_player_list.len)*100, 0.1)
	if(percentage >= percneeded*10)
		..(1)
		return 1

/datum/objective/crew/medical/survivor/update_explanation_text()
	..()
	explanation_text = "Reach at least the [percneeded*10]% of survivors at shift end."

//------ Revive at least x people with a defib
/datum/objective/crew/medical/defib
	jobs = "Chief Medical Officer#Medical Doctor"
	var/peepsneeded = 0

/datum/objective/crew/medical/defib/New(datum/mind/target, text, datum/mind/themind)
	..()
	peepsneeded = rand(1,3)

/datum/objective/crew/medical/defib/check_completion()
	if(!owner)
		return
	var/list/fbdetails = details2list("medicalshit", " ", "|")
	if(!(owner.key in fbdetails))
		return
	var/value = fbdetails[owner.key]
	if(value)
		if(value >= peepsneeded)
			..(1)
			return 1

/datum/objective/crew/medical/defib/update_explanation_text()
	..()
	explanation_text = "Successfully defib at least [peepsneeded] people."

//------ End the round with a particular superpower(Xray, hulk, telekinesis, cold resistance)

/datum/objective/crew/medical/power
	jobs = "Chief Medical Officer#Geneticist"
	var/superpower

/datum/objective/crew/medical/power/New(datum/mind/target, text, datum/mind/themind)
	..()
	superpower = pick(HULK, XRAY, COLDRES, TK)

/datum/objective/crew/medical/power/check_completion()
	if(owner && owner.current)
		var/mob/living/carbon/human/H = owner.current
		if(istype(H))
			if(H.dna && H.dna.check_mutation(superpower))
				..(1)
				return 1

/datum/objective/crew/medical/power/update_explanation_text()
	..()
	explanation_text = "End the shift with [superpower]."

//------ Clone at least x people
/datum/objective/crew/medical/clone
	jobs = "Chief Medical Officer#Medical Doctor#Geneticist"
	var/peepstoclone = 0

/datum/objective/crew/medical/clone/New(datum/mind/target, text, datum/mind/themind)
	..()
	peepstoclone = rand(2,5)

/datum/objective/crew/medical/clone/check_completion()
	var/datum/feedback_variable/medicalfeedback = blackbox.find_feedback_datum("medicalshit")
	var/peepscloned = medicalfeedback.get_value()
	if(peepscloned >= peepstoclone)
		..(1)
		return 1

/datum/objective/crew/medical/clone/update_explanation_text()
	..()
	explanation_text = "Clone at least [peepstoclone] people."

//------ Make x amount of y healing chem
/datum/objective/crew/medical/makechem
	jobs = "Chief Medical Officer#Chemist"
	var/amount = 0
	var/chemid = ""
	var/chemname = ""

/datum/objective/crew/medical/makechem/New(datum/mind/target, text, datum/mind/themind)
	..()
	amount = rand(10,20) * 100
	var/list/blacklist = list(/datum/reagent/medicine, /datum/reagent/medicine/mine_salve, /datum/reagent/medicine/omnizine, /datum/reagent/medicine/antitoxin, /datum/reagent/medicine/syndicate_nanites, /datum/reagent/medicine/dexalin) + typesof(/datum/reagent/medicine/adminordrazine)
	var/list/possiblechems = typesof(/datum/reagent/medicine) - blacklist
	var/forlooptime = rand(3,5)
	for(var/i in 1 to forlooptime)
		if(i != forlooptime)
			var/datum/reagent/chempath = pick_n_take(possiblechems)
			chemid += "[initial(chempath.id)]#"
			chemname += "[initial(chempath.name)], "
		else
			var/datum/reagent/chempath = pick_n_take(possiblechems)
			chemid += "[initial(chempath.id)]"
			chemname += "[initial(chempath.name)]."

/datum/objective/crew/medical/makechem/check_completion()
	var/list/fbdetails = details2list("chemical_reaction", " ", "|")
	var/list/chemlist = splittext(chemid, "#")
	var/done = TRUE
	for(var/i in chemlist)
		if(i in fbdetails)
			if(fbdetails[i] >= round(amount/chemlist.len))
				continue
			else
				done = FALSE
		else
			done = FALSE
	if(done)
		..(1)
		return 1

/datum/objective/crew/medical/makechem/update_explanation_text()
	..()
	var/list/chemlist = splittext(chemid, "#")
	explanation_text = "Make at least [round(amount/chemlist.len)] units of each chemical: [chemname]"

//------ Have x chem in your bloodstream at round end, a must-have
/datum/objective/crew/medical/havechem
	jobs = "Chief Medical Officer#Chemist"
	var/chemid
	var/datum/reagent/chempath

/datum/objective/crew/medical/havechem/New(datum/mind/target, text, datum/mind/themind)
	..()
	var/list/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/fartium, /datum/reagent/drug/changelingAdrenaline2)
	chempath = pick(typesof(/datum/reagent/drug) - blacklist)
	chemid = initial(chempath.id)

/datum/objective/crew/medical/havechem/check_completion()
	if(owner && owner.current)
		var/mob/living/L = owner.current
		if(L.reagents)
			if(L.reagents.has_reagent(chemid))
				..(1)
				return 1

/datum/objective/crew/medical/havechem/update_explanation_text()
	..()
	explanation_text = "Have [initial(chempath.name)] in your bloodstream when the shift ends."

//------ Have a bottle with x symptom in the virology smartfridge.
/datum/objective/crew/medical/fridgesymp
	jobs = "Chief Medical Officer#Virologist"
	var/list/mergedcontents = list()
	var/list/requiredsymptoms = list()

/datum/objective/crew/medical/fridgesymp/New(datum/mind/target, text, datum/mind/themind)
	..()
	var/list/possiblesymptoms = typesof(/datum/symptom) - /datum/symptom
	for(var/i in 1 to rand(3,5))
		requiredsymptoms += pick_n_take(possiblesymptoms)


/datum/objective/crew/medical/fridgesymp/check_completion()
	for(var/obj/machinery/smartfridge/chemistry/virology/V in machines)
		mergedcontents += V.contents
	for(var/obj/item/weapon/reagent_containers/glass/bottle/B in mergedcontents)
		if(B.reagents)
			for(var/datum/reagent/blood/bl in B.reagents.reagent_list)
				var/list/virii = bl.data["viruses"]
				for(var/datum/disease/advance/A in virii)
					for(var/datum/symptom/S in A.symptoms)
						if(is_type_in_list(S, requiredsymptoms))
							requiredsymptoms -= S.type
	if(!requiredsymptoms.len)
		..(1)
		return 1

/datum/objective/crew/medical/fridgesymp/update_explanation_text()
	..()
	explanation_text = "Have the following symptoms anywhere inside your Virology Smartfridge:"
	for(var/i in 1 to requiredsymptoms.len)
		var/datum/symptom/symppath = requiredsymptoms[i]
		explanation_text += " [initial(symppath.name)]"
		if(i != requiredsymptoms.len)
			explanation_text += ", "

//SECURITY
/datum/objective/crew/security
	mytag = "Security"
	jobs = "Head of Security#Warden#Detective#Security Officer"

//------ Keep the armory guns in their locker
/datum/objective/crew/security/gunsinarmory
	jobs = "Head of Security#Warden"
	var/egunamt = 0
	var/laseramt = 0
	var/shotgunamt = 0
	var/ionrifle = 0
	var/ablative = 0

/datum/objective/crew/security/gunsinarmory/New(datum/mind/target, text, datum/mind/themind)
	..()
	egunamt = rand(1,3)
	laseramt = rand(1,3)
	shotgunamt = rand(1,4)
	ionrifle = rand(0,1)
	ablative = rand(0,1)

/datum/objective/crew/security/gunsinarmory/check_completion()
	var/area/ai_monitored/security/armory/S
	for(var/area/A in world)
		if(istype(A, /area/ai_monitored/security/armory))
			S = A
			break
	var/list/contents2check = area_contents(S)
	var/list/lockerscontents = list()
	var/completed = FALSE
	for(var/atom/AM in contents2check)
		if(istype(AM, /obj/structure/closet))
			lockerscontents += AM.contents
	for(var/atom/ATM in lockerscontents)
		switch(ATM.type)
			if(/obj/item/weapon/gun/energy/gun)
				egunamt--
			if(/obj/item/weapon/gun/energy/laser)
				laseramt--
			if(/obj/item/weapon/gun/projectile/shotgun/riot)
				shotgunamt--
			if(/obj/item/weapon/gun/energy/ionrifle)
				ionrifle--
			if(/obj/item/clothing/suit/armor/laserproof)
				ablative--
			else
				continue
		if((egunamt <= 0) && (laseramt <= 0) && (shotgunamt <= 0) &&  (ionrifle <= 0) && (ablative <= 0))
			completed = TRUE
			break //lil lag reducer
	if(!completed)
		for(var/atom/ATOM in contents2check)//usually the guns are in the locker,if not let's check the entire area
			switch(ATOM.type)
				if(/obj/item/weapon/gun/energy/gun)
					egunamt--
				if(/obj/item/weapon/gun/energy/laser)
					laseramt--
				if(/obj/item/weapon/gun/projectile/shotgun/riot)
					shotgunamt--
				if(/obj/item/weapon/gun/energy/ionrifle)
					ionrifle--
				if(/obj/item/clothing/suit/armor/laserproof)
					ablative--
				else
					continue
			if((egunamt <= 0) && (laseramt <= 0) && (shotgunamt <= 0) &&  (ionrifle <= 0) && (ablative <= 0))
				completed = TRUE
				break //lil lag reducer
	if(completed)
		..(1)
		return 1

/datum/objective/crew/security/gunsinarmory/update_explanation_text()
	..()
	explanation_text = "Have [egunamt] energy guns, [laseramt] laser guns[(ionrifle || ablative) ? "," : " and"] [shotgunamt] riot shotguns[ablative ? "," : " and"] [ionrifle ? "an ion rifle" : ""][ablative ? " and an ablative armor vest" : ""] in the armory when the shift ends."

//------ Get an arrested antag to centcom
/datum/objective/crew/security/arrestantag

/datum/objective/crew/security/arrestantag/check_completion()
	var/area/shuttle/escape/E
	for(var/area/A in world)
		if(istype(A, /area/shuttle/escape))
			E = A
			break
	for(var/turf/simulated/floor/plasteel/shuttle/red/R in area_contents(E))
		for(var/mob/living/carbon/human/H in R)
			if(H.mind)
				if(H.mind.special_role)
					..(1)
					return 1

/datum/objective/crew/security/arrestantag/update_explanation_text()
	..()
	explanation_text = "Have at least one human antagonist in the shuttle brig when the shift ends."

//------ Be sure your buddy escapes alive!
/datum/objective/crew/security/buddy
	jobs = "Security Officer"
	var/static/list/buddylist = list()//officer1 = officer2,  officer3 = officer4

/datum/objective/crew/security/buddy/requirements()
	buddylist |= owner.current
	find_target_by_role("Security Officer")
	if(!target)
		find_target_by_role("Detective")
		if(target)
			return // don't want the det to be busy protecting a random officer
	if(target && target.current && owner && owner.current)//should exist by now
		var/datum/objective/crew/security/buddy/B = new(themind = target)
		B.target = owner
		B.update_explanation_text()
		buddylist[owner.current] = target.current
	if(!target) //can't exist at this point
		if(src in buddylist)
			buddylist -= src
		return 0

/datum/objective/crew/security/buddy/check_completion()
	. = FALSE
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return
		return TRUE

/datum/objective/crew/security/buddy/update_explanation_text()
	..()
	explanation_text = "Party up with [target ? target.current : "ERROR AHELP THIS"] and ensure he doesn't die."

//------ Have your main outfit on you
/datum/objective/crew/security/outfit
	jobs = "Detective"
	var/datum/outfit/job/detective/D = /datum/outfit/job/detective

/datum/objective/crew/security/outfit/check_completion()
	if(owner && owner.current)
		var/mob/living/carbon/human/H = owner.current
		if((H.stat == DEAD) || !istype(H))
			return
		if(!istype(H.w_uniform, initial(D.uniform)))
			return
		if(!istype(H.shoes, initial(D.shoes)))
			return
		if(!istype(H.wear_suit, initial(D.suit)))
			return
		if(!istype(H.gloves, initial(D.gloves)))
			return
		if(!istype(H.head, initial(D.head)))
			return
		if(!locate(/obj/item/weapon/gun/projectile/revolver/detective) in H)
			return
		..(1)
		return 1

/datum/objective/crew/security/outfit/update_explanation_text()
	..()
	explanation_text = "Have the clothes you started with, along with your revolver, still on you when the shift ends."

//SUPPLY!
/datum/objective/crew/supply
	mytag = "Supply"
	jobs = "Head of Personnel#Quartermaster#Cargo Technician#Shaft Miner"

//------ Have x points at roundend
/datum/objective/crew/supply/points
	var/points = 0

/datum/objective/crew/supply/points/New(datum/mind/target, text, datum/mind/themind)
	..()
	points = rand(1000,2000)

/datum/objective/crew/supply/points/check_completion()
	if(SSshuttle.points >= points)
		..(1)
		return 1

/datum/objective/crew/supply/points/update_explanation_text()
	..()
	explanation_text = "Have at least [points] supply points at shift end. You can achieve this by shipping plasma, exotic plants, syndicate secret documents or research saved on disks."

//------ Have x mining points on your card at roundend
/datum/objective/crew/supply/miningpoints
	jobs = "Shaft Miner"
	var/points = 0

/datum/objective/crew/supply/miningpoints/New(datum/mind/target, text, datum/mind/themind)
	..()
	points = rand(10000,15000)

/datum/objective/crew/supply/miningpoints/check_completion()
	if(owner && owner.current)
		for(var/obj/item/weapon/card/id/I in owner.current)
			if(I.mining_points >= points)
				..(1)
				return 1

/datum/objective/crew/supply/miningpoints/update_explanation_text()
	..()
	explanation_text = "Have at least [points] mining points on any ID card in your inventory at shift end."

//------ Mine x types of y ore
/datum/objective/crew/supply/mineore
	jobs = "Shaft Miner"
	var/obj/item/weapon/ore/oretype
	var/oreamt = 0

/datum/objective/crew/supply/mineore/New(datum/mind/target, text, datum/mind/themind)
	..()
	var/divider = 1
	var/list/oretypes = list(/obj/item/weapon/ore/uranium = 2, /obj/item/weapon/ore/diamond = 4, /obj/item/weapon/ore/gold = 3, /obj/item/weapon/ore/silver = 3, /obj/item/weapon/ore/plasma = 1)
	oretype = pick(oretypes)
	divider = oretypes[oretype]
	oreamt = round(rand(30, 100)/divider)

/datum/objective/crew/supply/mineore/check_completion()
	var/list/details = details2list("ore_mined", " ", "|")
	var/textedpath = "[oretype]"
	if(textedpath in details)
		if(details[textedpath] >= oreamt)
			..(1)
			return 1

/datum/objective/crew/supply/mineore/update_explanation_text()
	..()
	explanation_text = "Mine at least [oreamt] [initial(oretype.name)]s."

//------ Ian shall stay alive till round end
/datum/objective/crew/supply/ianalive
	jobs = "Head of Personnel"

/datum/objective/crew/supply/ianalive/check_completion()
	if(locate(/mob/living/simple_animal/pet/dog/corgi/Ian) in living_mob_list)
		..(1)
		return 1

/datum/objective/crew/supply/ianalive/update_explanation_text()
	..()
	explanation_text = "Keep Ian alive till the shift ends."

//------ Make corgi puppies!
/datum/objective/crew/supply/puppies
	jobs = "Head of Personnel#Quartermaster#Cargo Technician"

/datum/objective/crew/supply/puppies/check_completion()
	if(locate(/mob/living/simple_animal/pet/dog/corgi/puppy) in living_mob_list)
		..(1)
		return 1

/datum/objective/crew/supply/puppies/update_explanation_text()
	..()
	explanation_text = "Find a way to make Ian breed."

//Service!
/datum/objective/crew/service
	mytag = "Service"
	jobs = "Bartender#Chef#Botanist#Janitor"

//Keep pete alive, even through he wants to murder you.
/datum/objective/crew/service/keeppete
	jobs = "Chef"

/datum/objective/crew/service/keeppete/check_completion()
	for(var/mob/living/simple_animal/hostile/retaliate/goat/G in living_mob_list)
		if(G.name == "Pete") //it's the only difference between the chef's goat and normal goats,bear with me
			..(1)
			return 1

/datum/objective/crew/service/keeppete/update_explanation_text()
	..()
	explanation_text = "Keep Pete alive till the shift ends."

//make x units of y drink
/datum/objective/crew/service/bartender
	jobs = "Bartender"
	var/amt = 0
	var/drinkname
	var/datum/reagent/drink

/datum/objective/crew/service/bartender/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = rand(50,100)
	var/datum/chemical_reaction/drinkpath = pick(typesof(/datum/chemical_reaction/drink) - /datum/chemical_reaction/drink)
	drinkname = initial(drinkpath.name)
	drink = initial(drinkpath.result)

/datum/objective/crew/service/bartender/check_completion()
	if(owner && owner.current)
		var/mob/M = owner.current
		for(var/i in M.contents)
			if(istype(i, /obj/item/weapon/reagent_containers))
				var/obj/item/weapon/reagent_containers/R = i
				if(R.reagents)
					if(R.reagents.has_reagent(drink, amt))
						..(1)
						return 1

/datum/objective/crew/service/bartender/update_explanation_text()
	..()
	explanation_text = "Have [amt] units of [drinkname] on you at shift end."

//------ Have x types of y plants at roundend
/datum/objective/crew/service/collectplants
	jobs = "Botanist"
	var/amt = 0
	var/list/plants = list()

/datum/objective/crew/service/collectplants/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = rand(70,100)
	var/loop = rand(3,5)
	var/list/blacklist = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/walkingmushroom)
	var/list/possibleplants = (typesof(/obj/item/weapon/reagent_containers/food/snacks/grown) - /obj/item/weapon/reagent_containers/food/snacks/grown) + (typesof(/obj/item/weapon/grown) - /obj/item/weapon/grown) - blacklist
	for(var/i in 1 to loop)
		var/path = "[pick_n_take(possibleplants)]"
		plants[path] = round(amt/loop)

/datum/objective/crew/service/collectplants/check_completion()
	if(owner && owner.current)
		var/mob/M = owner.current
		for(var/obj/item/weapon/storage/bag/plants/P in M.contents)
			for(var/obj/item/I in P)
				var/path = "[I.type]"
				if(path in plants)
					plants[path]--
		for(var/i in plants)
			if(plants[i])
				return 0
		..(1)
		return 1

/datum/objective/crew/service/collectplants/update_explanation_text()
	..()
	explanation_text = "Collect at least "
	for(var/i in 1 to plants.len)
		var/obj/item/plant = text2path(plants[i])
		explanation_text += "[plants[plants[i]]] [initial(plant.name)]"
		if(copytext(explanation_text, -1) != "s")
			explanation_text += "s"
		if(i != plants.len)
			explanation_text += ", "
	explanation_text += " and keep them in a plant bag at shift end."

//ensure that x areas is clean
/datum/objective/crew/service/clean
	jobs = "Janitor"
	var/list/areas = list()

/datum/objective/crew/service/clean/New(datum/mind/target, text, datum/mind/themind)
	..()
	var/list/possibleareas = list()
	for(var/A in teleportlocs) // a list with all station areas plus space
		if(istype(teleportlocs[A], /area/space))
			continue
		possibleareas |= teleportlocs[A]
	for(var/i in 1 to rand(1,2))
		areas |= pick_n_take(possibleareas)

/datum/objective/crew/service/clean/check_completion()
	for(var/area/A in areas)
		for(var/obj/effect/decal/cleanable/C in area_contents(A))
			return 0
	..(1)
	return 1

/datum/objective/crew/service/clean/update_explanation_text()
	..()
	explanation_text = "Ensure that "
	for(var/i in 1 to areas.len)
		var/area/A = areas[i]
		explanation_text += "[A.name]"
		if(i != areas.len)
			explanation_text += " and " //since it's either 1 or 2.
	explanation_text += " are completely clean when the shift ends. Please ask for permission before entering in certain places!"

//CIVILIAN! holy shit i didn't believe i'd reach this
/datum/objective/crew/civilian
	mytag = "Civilian"
	jobs = "Captain#Librarian#Lawyer#Chaplain#Clown#Mime#Assistant"

//keep dat fukken disk secure
/datum/objective/crew/civilian/datfukkendisk
	jobs = "Captain"

/datum/objective/crew/civilian/datfukkendisk/check_completion()
	if(owner && owner.current)
		var/obj/item/weapon/disk/nuclear/N = locate() in poi_list
		if(N)
			if((N in owner.current) && owner.current.onCentcom())
				..(1)
				return 1

/datum/objective/crew/civilian/datfukkendisk/update_explanation_text()
	..()
	explanation_text = "Defend the disk with your life and deliver it safely to centcom when the shift ends."

//don't break your vow
/datum/objective/crew/civilian/vow
	jobs = "Mime"

/datum/objective/crew/civilian/vow/check_completion()
	var/datum/feedback_variable/vowmade = blackbox.find_feedback_datum("vow_made")
	var/vow = vowmade.get_details()
	if(vow)
		return 0
	..(1)
	return 1

/datum/objective/crew/civilian/vow/update_explanation_text()
	..()
	explanation_text = "Don't break your vow ever."


//slip at least x people
/datum/objective/crew/civilian/slip
	jobs = "Clown"
	var/amt = 0

/datum/objective/crew/civilian/slip/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = rand(20,40)

/datum/objective/crew/civilian/slip/check_completion()
	var/list/dat = details2list("slips", " ", "|")
	for(var/i in dat)
		if(dat[i] == "/obj/item/device/pda/clown")
			amt--
	if(!amt)
		..(1)
		return 1

/datum/objective/crew/civilian/slip/update_explanation_text()
	..()
	explanation_text = "Slip the crew at least [amt] times with your PDA."

//write x articles of at least 100 characters (optional:have a photo attached to it too)
/datum/objective/crew/civilian/reporter
	jobs = "Librarian"
	var/articles = 0
	var/char = 100
	var/list/articleschecked = list()

/datum/objective/crew/civilian/reporter/New(datum/mind/target, text, datum/mind/themind)
	..()
	articles = rand(2,4)

/datum/objective/crew/civilian/reporter/check_completion()
	if(owner && owner.current)
		for(var/datum/newscaster/feed_channel/F in news_network.network_channels)
			if(findtext(F.author, owner.current.job))
				for(var/datum/newscaster/feed_message/message in F.messages)
					if(!(message in articleschecked))
						if(findtext(F.author, owner.current.job) && length(message.body) >= char)
							articleschecked += message
							..(1)
							return 1

/datum/objective/crew/civilian/reporter/update_explanation_text()
	..()
	explanation_text = "Make at least [articles] articles, they must be at least [char] characters long."

//get a petition done with at least x signs
/datum/objective/crew/civilian/petition
	jobs = "Lawyer"
	var/amt = 0
	var/list/signers = list()

/datum/objective/crew/civilian/petition/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = round(player_list.len/rand(3,4))

/datum/objective/crew/civilian/petition/check_completion()
	if(owner && owner.current)
		var/datum/feedback_variable/paperwork = blackbox.find_feedback_datum("paperwork")
		var/paperworkdetails = paperwork.get_details()
		var/list/listone = splittext(paperworkdetails, " ")
		var/list/signs = list()
		for(var/i in listone)
			var/list/temp = splittext(i, "|")
			signs += temp[1]
			signs[temp[1]] = temp[temp[1]]
		for(var/i in signs)
			if(i == "SIGN")
				var/signer = signs[i]
				if(!(signer in signers))
					signers |= signer
	if(signers.len >= amt)
		..(1)
		return 1

/datum/objective/crew/civilian/petition/update_explanation_text()
	..()
	explanation_text = "Do a petition about an argument of your choice and collect [amt] number of signs on a paper."

//play the effect of relics x times
/datum/objective/crew/civilian/relic
	jobs = "Chaplain"
	var/amt = 0

/datum/objective/crew/civilian/relic/New(datum/mind/target, text, datum/mind/themind)
	..()
	amt = rand(10,20)

/datum/objective/crew/civilian/relic/check_completion()
	var/datum/feedback_variable/relicfeedback = blackbox.find_feedback_datum("relic")
	var/relicvalue = relicfeedback.get_value()
	if(relicvalue >= amt)
		..(1)
		return 1

/datum/objective/crew/civilian/relic/update_explanation_text()
	..()
	explanation_text = "Manage to activate the effect of relics [amt] times. Use your bible in hand for a clue on how to do relics."

//Have a necklace full of cat teeths at roundend
/datum/objective/crew/civilian/diecats
	jobs = "Assistant"

/datum/objective/crew/civilian/diecats/requirements()
	var/catsexist = FALSE
	for(var/mob/living/carbon/human/H in player_list)
		if(H.dna && H.dna.species.id == "tajaran")
			catsexist = TRUE
	if(!catsexist)
		return 0

/datum/objective/crew/civilian/diecats/check_completion()
	if(owner && owner.current)
		var/mob/living/carbon/human/H = owner.current
		if(!istype(H))
			return 0
		var/obj/item/clothing/under/U = H.w_uniform
		if(U && U.hastie)
			var/obj/item/clothing/tie/necklace/N = U.hastie
			if(istype(N))
				if((N.ornaments.len == N.max_ornaments))
					var/allcatteeths = TRUE
					for(var/obj/item/stack/teeth/cat/C in N.ornaments)
						if(!istype(C))
							allcatteeths = FALSE
					if(!allcatteeths)
						return 0
					..(1)
					return 1

/datum/objective/crew/civilian/diecats/update_explanation_text()
	..()
	explanation_text = "Have a necklace full of tajaran teeths on your jumpsuit when the shift ends."

//don't get stunned, literally impossibru
/datum/objective/crew/civilian/nostun
	jobs = "Assistant"

/datum/objective/crew/civilian/nostun/check_completion()
	if(owner && owner.current)
		var/list/details = details2list("stuns", " ", "|")
		if(owner.key in details)
			return
		..(1)
		return 1

/datum/objective/crew/civilian/nostun/update_explanation_text()
	..()
	explanation_text = "Don't get stunned by energy guns, tasers and stunbatons till the shift ends."

