var/list/mentor_datums = list()

/datum/mentors
	var/client/owner	= null

/datum/mentors/New(ckey)
	if(!ckey)
		ERROR("Mentor datum created without a ckey argument. Datum has been deleted")
		del(src)
		return
	mentor_datums[ckey] = src

/datum/mentors/proc/associate(client/C)
	if(istype(C))
		owner = C
		mentors |= C

/datum/mentors/proc/disassociate()
	if(owner)
		mentors -= owner
		owner = null

/client/proc/dementor()
	mentor_datums -= ckey
	return 1

/proc/check_mentor()
	if(usr && usr.client)
		var/mentor = mentor_datums[usr.client.ckey]
		if(mentor || check_rights(R_ADMIN,0))
			return 1

	return 0