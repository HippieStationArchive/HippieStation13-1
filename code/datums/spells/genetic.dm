/obj/effect/proc_holder/spell/targeted/genetic
	name = "Genetic"
	desc = "This spell inflicts a set of mutations and disabilities upon the target."

	var/disabilities = 0 //bits
	var/list/mutations = list() //mutation strings
	var/duration = 100 //deciseconds
	/*
		Disabilities
			1st bit - ?
			2nd bit - ?
			3rd bit - ?
			4th bit - ?
			5th bit - ?
			6th bit - ?
	*/

/obj/effect/proc_holder/spell/targeted/genetic/cast(list/targets)

	if(cast_sound)
		playsound(usr.loc, cast_sound, 50, 1)

	for(var/mob/living/target in targets)
		target.mutations.Add(mutations)
		target.disabilities |= disabilities
		target.update_mutations()	//update target's mutation overlays
		spawn(duration)
			if(target && !target.gc_destroyed)
				target.mutations.Remove(mutations)
				target.disabilities &= ~disabilities
				target.update_mutations()

	return