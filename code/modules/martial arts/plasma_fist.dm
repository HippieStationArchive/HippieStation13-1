/mob/living/carbon/human/proc/plasma_fist_help()
	set name = "Plasma Fist Tutorial"
	set desc = "Access the Plasma Fist tutorial."
	set category = "Martial Arts"

	usr << "<span class='notice'>You have learned the arcane arts of <span class='userdanger'>PLASMA FIST!</span></span>"
	usr << "<span class='notice'>You have four available combos to perform:</span>"
	usr << "<span class='notice'><B>TORNADO COMBO!</B> Harm, Harm, Disarm (HHD)</span>"
	usr << "<span class='notice'><B>THROWBACK PUNCH!</B> Disarm, Harm, Disarm (DHD)</span>"
	usr << "<span class='notice'><B>KNOCKOUT KICK!</B> Grab, Grab, Harm (GGH)</span>"
	usr << "<span class='notice'><B>THE ULTIMATE PLASMA FIST TECHNIQUE! Harm, Disarm, Disarm, Disarm, Harm (HDDDH)</span>"

#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define KNOCKOUT_COMBO "GGH"
#define PLASMA_COMBO "HDDDH"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"
	max_streak_length = 7 //Increase it with longer combos added
	var/cooldown = 0

/datum/martial_art/plasma_fist/teach(var/mob/living/carbon/human/H, make_temporary)
	..()
	H << "<span class = 'userdanger'>You have learned the ancient martial art of Plasma Fist!</span>"
	H << "<span class = 'danger'>Recall your teachings using the Plasma Fist Tutorial verb in the Martial Arts menu, in your verbs menu.</span>"
	H.verbs += /mob/living/carbon/human/proc/plasma_fist_help

/datum/martial_art/plasma_fist/remove(var/mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You forget the ancient martial art of Plasma Fist..</span>"
	H.verbs -= /mob/living/carbon/human/proc/plasma_fist_help

/datum/martial_art/plasma_fist/add_to_streak(var/element,var/mob/living/carbon/human/A,var/mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
	if(cooldown + 60 < world.time)
		streak = element //Set the streak to the element to clear out our streak without fucking up the new combo about to be performed.
	else
		streak = streak+element
	cooldown = world.time
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	if(istype(A))
		A.hud_used.combo_object.update_icon(streak, 60)

/datum/martial_art/plasma_fist/basic_hit(mob/living/carbon/human/A,mob/living/carbon/human/D, var/atk_verb="punched")
	A.do_attack_animation(D)
	playsound(D.loc, get_sfx("punch"), 25, 1, -1)
	D.visible_message("<span class='danger'>[A] has [atk_verb] [D]!</span>", \
								"<span class='userdanger'>[A] has [atk_verb] [D]!</span>")
	D.apply_damage(rand(1,3), BRUTE)
	add_logs(A, D, "[atk_verb]", addition="(Plasma Fist)")
	return 1

/datum/martial_art/plasma_fist/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,TORNADO_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		cooldown = world.time
		Tornado(A,D)
		return 1
	if(findtext(streak,THROWBACK_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		cooldown = world.time
		Throwback(A,D)
		return 1
	if(findtext(streak,KNOCKOUT_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		cooldown = world.time
		Knockout(A,D)
		return 1
	if(findtext(streak,PLASMA_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		cooldown = world.time
		Plasma(A,D)
		return 1
	return 0

/datum/martial_art/plasma_fist/proc/Tornado(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_logs(A, D, "tornado sweeped", addition="(Plasma Fist)")
	A.say("TORNADO SWEEP!")
	A.changeNext_move(5) //Longer cooldown due to the nature of the move
	spawn(0)
		for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
			A.dir = i
			playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1)
			sleep(1)
	var/obj/effect/proc_holder/spell/aoe_turf/repulse/R = new(null)
	var/list/turfs = list()
	for(var/turf/T in range(1,A))
		turfs.Add(T)
	R.cast(turfs)
	return

/datum/martial_art/plasma_fist/proc/Throwback(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_logs(A, D, "plasma punched", addition="(Plasma Fist)")
	D.visible_message("<span class='danger'>[A] has hit [D] with Plasma Punch!</span>", \
								"<span class='userdanger'>[A] has hit [D] with Plasma Punch!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1)
	D.adjustBruteLoss(15) //Should be pretty intense, getting punched so hard and all.
	D.adjust_fire_stacks(5)
	D.IgniteMob()
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 200, 3)
	A.say("PLASMA PUNCH!")
	A.changeNext_move(2) //Same cooldown for subsequent punches. Otherwise it throws you off.
	return

/datum/martial_art/plasma_fist/proc/Knockout(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_logs(A, D, "knocked down", addition="(Plasma Fist)")
	D.visible_message("<span class='danger'>[A] has knocked down [D] with a kick!</span>", \
								"<span class='userdanger'>[A] has knocked down [D] with a kick!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1)
	D.adjustBruteLoss(6) //Decentish damage. It racks up to 16 if the victim hits a wall.
	D.Weaken(2)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 2, 2)
	A.say("PLASMA KICK!")
	A.changeNext_move(2) //Same cooldown for subsequent combos. Otherwise it throws you off.
	return

/datum/martial_art/plasma_fist/proc/Plasma(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1)
	playsound(D.loc, pick("explosion"), 30, 1) //So it's pretty radcore
	add_logs(A, D, "plasma fisted", addition="(Plasma Fist)")
	A.say("PLASMA FIST!")
	A.emote("scream")
	D.visible_message("<span class='danger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>", \
								"<span class='userdanger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>")
	var/obj/item/organ/internal/brain/B = D.getorgan(/obj/item/organ/internal/brain)
	if(B)
		B.loc = get_turf(D)
		B.transfer_identity(D)
		D.internal_organs -= B
	D.gib()
	return

/datum/martial_art/plasma_fist/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return //You shouldn't be able to attack yourself
	add_to_streak("H",A,D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,"punched")
	spawn(2) //There's a weird problem where if you attack someone on the ground it will reset changeNext_move. This is an attempt to fix it
		A.changeNext_move(0) //Allows you to combo the FUCK out
	return 1

/datum/martial_art/plasma_fist/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return //You shouldn't be able to attack yourself
	add_to_streak("D",A,D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,"kicked")
	spawn(2) //There's a weird problem where if you attack someone on the ground it will reset changeNext_move. This is an attempt to fix it
		A.changeNext_move(0) //Allows you to combo the FUCK out
	return 1

/datum/martial_art/plasma_fist/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return //You shouldn't be able to attack yourself
	add_to_streak("G",A,D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,"chopped")
	spawn(2) //There's a weird problem where if you attack someone on the ground it will reset changeNext_move. This is an attempt to fix it
		A.changeNext_move(0) //Allows you to combo the FUCK out
	return 1

//ITEMS

/obj/item/weapon/plasma_fist_scroll
	name = "frayed scroll"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	var/used = 0

/obj/item/weapon/plasma_fist_scroll/attack_self(mob/user)
	if(!ishuman(user))
		return
	if(!used)
		var/mob/living/carbon/human/H = user
		var/datum/martial_art/plasma_fist/F = new/datum/martial_art/plasma_fist(null)
		F.teach(H)
		used = 1
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"