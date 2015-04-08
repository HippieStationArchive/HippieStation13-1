/obj/item/weapon/plasma_fist_scroll
	name = "Plasma Fist Scroll"
	desc = "Teaches the traditional wizard martial art."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	var/used = 0

/obj/item/weapon/plasma_fist_scroll/attack_self(mob/user as mob)
	if(!ishuman(user) || used)
		return
	var/mob/living/carbon/human/H = user
	var/datum/martial_art/plasma_fist/M = new()
	H.martial_art = M
	H.martial_arts += M
	used = 1
	desc += "It looks like it's magic was used up."

#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define PLASMA_COMBO "GHDDD"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"
	priority = 8
	max_streak_length = 7 //Increase it with longer combos added
	var/mob/living/carbon/human/lastmob //This is used for localized streaks. Streak will get cancelled if you switch victims.

/datum/martial_art/plasma_fist/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(lastmob != D) //Streaks should only be on the same mob.
		streak = "" //This cancels out the combos too
	lastmob = D //Assign the new lastmob
	if(findtext(streak,TORNADO_COMBO))
		streak = ""
		Tornado(A,D)
		return 1
	if(findtext(streak,THROWBACK_COMBO))
		streak = ""
		Throwback(A,D)
		return 1
	if(findtext(streak,PLASMA_COMBO))
		streak = ""
		Plasma(A,D)
		return 1
	return 0

/datum/martial_art/plasma_fist/proc/Tornado(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.say("TORNADO SWEEP!")
	A.changeNext_move(3) //Same cooldown for subsequent punches. Otherwise it throws you off.
	spawn(0)
		for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
			A.dir = i
			playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1, -1)
			sleep(1)
	var/obj/effect/proc_holder/spell/aoe_turf/repulse/R = new(null)
	var/list/turfs = list()
	for(var/turf/T in range(1,A))
		turfs.Add(T)
	R.cast(turfs)
	return

/datum/martial_art/plasma_fist/proc/Throwback(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] has hit [D] with Plasma Punch!</span>", \
								"<span class='userdanger'>[A] has hit [D] with Plasma Punch!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	D.adjustBruteLoss(15) //Should be pretty intense, getting punched so hard and all.
	D.adjust_fire_stacks(5)
	D.IgniteMob()
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 200, 3)
	A.say("HYAH!")
	A.changeNext_move(3) //Same cooldown for subsequent punches. Otherwise it throws you off.
	return

/datum/martial_art/plasma_fist/proc/Plasma(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	A.say("PLASMA FIST!")
	D.visible_message("<span class='danger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>", \
								"<span class='userdanger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>")
	var/obj/item/organ/brain/B = D.getorgan(/obj/item/organ/brain)
	if(B)
		B.loc = get_turf(D)
		B.transfer_identity(D)
		D.internal_organs -= B
	D.gib()
	return

/datum/martial_art/plasma_fist/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,rand(1,3)) //Low as hell damage because spammable
	A.changeNext_move(3) //Allows you to combo the FUCK out
	return 1

/datum/martial_art/plasma_fist/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,rand(1,3)) //Low as hell damage because spammable
	A.changeNext_move(3) //Allows you to combo the FUCK out
	return 1

/datum/martial_art/plasma_fist/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,rand(1,3)) //Low as hell damage because spammable
	A.changeNext_move(3) //Allows you to combo the FUCK out
	return 1