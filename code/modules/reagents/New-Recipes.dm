/datum/chemical_reaction/ointment //Heals burn damage on touch. Useful for patches.
	name = "Ointment"
	id = "ointment"
	result = "ointment"
	required_reagents = list("kelotane" = 1, "carbon" = 1, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/brutanol //Heals brute damage on touch. Useful for patches.
	name = "Brutanol"
	id = "brutanol"
	result = "brutanol"
	required_reagents = list("bicaridine" = 1, "carbon" = 1, "nitrogen" = 1)
	result_amount = 1

datum/reagent/pure_rainbow
	name = "Pure Rainbow"
	id = "pure_rainbow"
	description = "A solution of rainbows."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	var/list/potential_colors = list("#FF0000","#0000FF","#008000","#FFFF00")

/datum/chemical_reaction/pure_rainbow
	name = "pure_rainbow"
	id = "pure_rainbow"
	result = "pure_rainbow"
	required_reagents = list("unholywater" = 1, "foaming_agent" = 1)
	result_amount = 5

datum/reagent/pure_rainbow/reaction_mob(var/mob/living/M, var/volume)
	if(M && isliving(M))
		M.color = pick(potential_colors)
	..()
	return
datum/reagent/pure_rainbow/reaction_obj(var/obj/O, var/volume)
	if(O)
		O.color = pick(potential_colors)
	..()
	return
datum/reagent/pure_rainbow/reaction_turf(var/turf/T, var/volume)
	if(T)
		T.color = pick(potential_colors)
	..()
	return