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
	var/list/potential_colors = list("#FF0000","#FF7F00","#FFFF00","#00FF00","#0000FF","#4B0082","#8B00FF")

/datum/chemical_reaction/pure_rainbow
	name = "pure_rainbow"
	id = "pure_rainbow"
	result = "pure_rainbow"
	required_reagents = list("redcrayonpowder" = 1, "orangecrayonpowder" = 1, "yellowcrayonpowder" = 1, "greencrayonpowder" = 1, "bluecrayonpowder" = 1, "purplecrayonpowder" = 1)
	result_amount = 6

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

/datum/chemical_reaction/tirizene //Causes staminaloss
	name = "Tirizene"
	id = "tirizene"
	result = "tirizene"
	required_reagents = list("ethanol" = 1, "tea" = 1, "chlorine" = 1) //We need more instances of food&drinks reagents used to mix chems
	result_amount = 2