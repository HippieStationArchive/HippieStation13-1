/obj/effect/proc_holder/spell/targeted/explosion
	name = "Explosion"
	desc = "This spell explodes an area."

	var/ex_severe = 1
	var/ex_heavy = 2
	var/ex_light = 3
	var/ex_flash = 4

	action_icon_state = "emp"

/obj/effect/proc_holder/spell/targeted/explosion/cast(list/targets)

	if(cast_sound)
		playsound(usr.loc, cast_sound, 50, 1)

	for(var/mob/living/target in targets)
		explosion(target.loc,ex_severe,ex_heavy,ex_light,ex_flash)


	return