/var/global/datum/topic_state/default/default_state = new()


/datum/topic_state/default/can_use_topic(var/src_object, var/mob/user)
	return user.default_can_use_topic(src_object)


/mob/proc/default_can_use_topic(var/src_object)
	return NANO_CLOSE // By default no mob can do anything with NanoUI

/mob/dead/observer/default_can_use_topic()
	if(check_rights(R_ADMIN, 0, src))
		return NANO_INTERACTIVE				// Admins are more equal
	return NANO_UPDATE						// Ghosts can view updates

/mob/living/silicon/robot/default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. <= NANO_DISABLED)
		return

	// robots can interact with things they can see within their view range
	if((src_object in view(src)) && get_dist(src_object, src) <= src.client.view)
		return NANO_INTERACTIVE	// interactive (green visibility)
	return NANO_DISABLED			// no updates, completely disabled (red visibility)

/mob/living/silicon/robot/syndicate/default_can_use_topic(var/src_object)
	. = ..()
	if(. != NANO_INTERACTIVE)
		return

	if(istype(get_area(src), /area/syndicate_mothership) || istype(get_area(src), /area/shuttle/syndicate))	// If elsewhere, they can interact with everything on the syndicate shuttle
		return NANO_INTERACTIVE
	if(istype(src_object, /obj/machinery))				// Otherwise they can only interact with emagged machinery
		var/obj/machinery/Machine = src_object
		if(Machine.emagged)
			return NANO_INTERACTIVE
	return NANO_UPDATE

/mob/living/silicon/ai/default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if (. != NANO_INTERACTIVE)
		return

	// If an object is in view of the client and a camera then we can interact with it
	if ((src_object in view(eyeobj)) && cameranet.checkTurfVis(get_turf(src_object)))
		return NANO_INTERACTIVE

	return NANO_CLOSE

/mob/living/silicon/pai/default_can_use_topic(var/src_object)
	if((src_object == src || src_object == radio) && !stat)
		return NANO_INTERACTIVE
	else
		return ..()

/mob/living/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != NANO_CLOSE)
		if(loc)
			. = min(., loc.contents_nano_distance(src_object, src))
	if(NANO_INTERACTIVE)
		return NANO_UPDATE

/mob/living/carbon/human/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != NANO_CLOSE)
		. = min(., shared_living_nano_distance(src_object))
		if(. == NANO_UPDATE && dna.check_mutation(TK))	// If we have telekinesis and remain close enough, allow interaction.
			return NANO_INTERACTIVE