// HIVE MIND UPLOAD/DOWNLOAD DNA
var/list/datum/dna/hivemind_bank = list()

/obj/effect/proc_holder/changeling/hivemind_upload
	name = "Hive Channel DNA"
	desc = "Allows us to channel DNA in the airwaves to allow other changelings to absorb it."
	chemical_cost = 10
	evopoints_cost = 0

/obj/effect/proc_holder/changeling/hivemind_upload/sting_action(var/mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/list/names = list()
	for(var/datum/changelingprofile/prof in changeling.stored_profiles)
		if(!(prof in hivemind_bank))
			names += prof.name

	if(names.len <= 0)
		user << "<span class='notice'>The airwaves already have all of our DNA.</span>"
		return

	var/chosen_name = input("Select a DNA to channel: ", "Channel DNA", null) as null|anything in names
	if(!chosen_name)
		return

	var/datum/changelingprofile/chosen_dna = changeling.get_dna(chosen_name)
	if(!chosen_dna)
		return

	hivemind_bank += chosen_dna
	user << "<span class='notice'>We channel the DNA of [chosen_name] to the air.</span>"
	feedback_add_details("changeling_powers","HU")
	return 1

/obj/effect/proc_holder/changeling/hivemind_download
	name = "Hive Absorb DNA"
	desc = "Allows us to absorb DNA that has been channeled to the airwaves. Does not count towards absorb objectives."
	chemical_cost = 10
	evopoints_cost = 0

/obj/effect/proc_holder/changeling/hivemind_download/can_sting(mob/living/carbon/user)
	if(!..())
		return
	var/datum/changeling/changeling = user.mind.changeling
	var/datum/changelingprofile/first_prof = changeling.stored_profiles[1]
	if(first_prof.name == user.real_name)//If our current DNA is the stalest, we gotta ditch it.
		user << "<span class='warning'>We have reached our capacity to store genetic information! We must transform before absorbing more.</span>"
		return
	return 1

/obj/effect/proc_holder/changeling/hivemind_download/sting_action(mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/list/names = list()
	for(var/datum/changelingprofile/hivemind_prof in hivemind_bank)
		for(var/datum/changelingprofile/stored_prof in changeling.stored_profiles)
			if(stored_prof.name != hivemind_prof.name)
				names[hivemind_prof.name] = hivemind_prof

	if(names.len <= 0)
		user << "<span class='notice'>There's no new DNA to absorb from the air.</span>"
		return

	var/S = input("Select a DNA absorb from the air: ", "Absorb DNA", null) as null|anything in names
	if(!S)	return

	var/datum/changelingprofile/chosen_prof = names[S]
	if(!chosen_prof)
		return

	for(var/datum/changelingprofile/stored_prof in changeling.stored_profiles)
		if(chosen_prof.name == stored_prof.name)
			user << "<span class='notice'>We already have that DNA!</span>"
			return

	changeling.add_profile(chosen_prof, user)

	user << "<span class='notice'>We absorb the DNA of [chosen_prof] from the air.</span>"
	feedback_add_details("changeling_powers","HD")
	return 1
