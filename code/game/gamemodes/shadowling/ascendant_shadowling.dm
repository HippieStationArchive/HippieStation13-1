/mob/living/simple_animal/ascendant_shadowling
	name = "ascendant shadowling"
	desc = "HOLY SHIT RUN THE FUCK AWAY"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shadowling_ascended"
	icon_living = "shadowling_ascended"
	verb_say = "telepathically thunders"
	verb_ask = "telepathically thunders"
	verb_exclaim = "telepathically thunders"
	verb_yell = "telepathically thunders"
	force_threshold = 55 // Pulse rifle shots, .357 bullets, and energy axes are the only things I can think of that get past this.
	health = 4500 // 75 pulse rifle shots would kill a shadowling.
	maxHealth = 4500
	speed = 0
	next_move_modifier = 0.2 // Attacks almost as fast as they can click.
	var/phasing = 0
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_MINIMUM

	response_help   = "pokes"
	response_disarm = "flails at"
	response_harm   = "flails at"

	harm_intent_damage = 0
	melee_damage_lower = 40 //Low force is fine since they attack at sanic speed.
	melee_damage_upper = 40
	attacktext = "rends"
	attack_sound = 'sound/weapons/slash.ogg'

	minbodytemp = 0
	maxbodytemp = INFINITY
	environment_smash = 3

	faction = list("faithless")

/mob/living/simple_animal/ascendant_shadowling/Process_Spacemove(movement_dir = 0)
	return 1 //copypasta from carp code

/mob/living/simple_animal/ascendant_shadowling/get_spans()
	return ..() | list(SPAN_REALLYBIG, SPAN_YELL) //MAKES THEM SHOUT WHEN THEY TALK

/*
/mob/living/simple_animal/ascendant_shadowling/ex_act(severity)
	return 0 //You think an ascendant can be hurt by bombs? HA

/mob/living/simple_animal/ascendant_shadowling/singularity_act()
	return 0 //Well hi, fellow god! How are you today?
*/