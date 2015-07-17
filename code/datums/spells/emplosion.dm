/obj/effect/proc_holder/spell/targeted/emplosion
	name = "Emplosion"
	desc = "This spell emplodes an area."

	var/emp_heavy = 2
	var/emp_light = 3
	var/cast_sound = null

/obj/effect/proc_holder/spell/targeted/emplosion/cast(list/targets)
	if(cast_sound)
		playsound(usr.loc, cast_sound, 50, 1)

	for(var/mob/living/target in targets)
		empulse(target.loc, emp_heavy, emp_light)

	return