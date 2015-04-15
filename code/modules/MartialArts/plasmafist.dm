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
	H.martial_arts += M
	if(!H.martial_art) //Check if he already has a martial art "equipped"
		H.martial_art = M
	user << "<span class='notice'>You have learned the arcane arts of <span class='userdanger'>PLASMA FIST!</span></span>"
	user << "<span class='notice'>You have four available combos to perform:</span>"
	user << "<span class='notice'><B>TORNADO COMBO!</B> Harm, Harm, Disarm (HHD)</span>"
	user << "<span class='notice'><B>THROWBACK PUNCH!</B> Disarm, Harm, Disarm (DHD)</span>"
	user << "<span class='notice'><B>KNOCKOUT KICK!</B> Grab, Grab, Harm (GGH)</span>"
	user << "<span class='notice'><B>THE ULTIMATE PLASMA FIST TECHNIQUE! Grab, Harm, Disarm, Disarm, Disarm (GHDDD)</span>"
	user << "<span class='notice'>Check your memory to remember these techniques again.</span>"
	if(H.mind)
		H.mind.store_memory(\
{"<HR>You have learned the arcane arts of <B>PLASMA FIST!</B><BR>
You have four available combos to perform:<BR>
<B>TORNADO COMBO!</B><BR>  Harm, Harm, Disarm (HHD)<BR>
<B>THROWBACK PUNCH!</B><BR>  Disarm, Harm, Disarm (DHD)<BR>
<B>KNOCKOUT KICK!</B><BR>  Grab, Grab, Harm (GGH)<BR>
<B>THE ULTIMATE PLASMA FIST TECHNIQUE!</B><BR>  Grab, Harm, Disarm, Disarm, Disarm (GHDDD)
<HR>"}\
)
	used = 1
	desc += "It looks like it's magic was used up."

#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define KNOCKOUT_COMBO "GGH"
#define PLASMA_COMBO "GHDDD"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"
	priority = 8
	max_streak_length = 7 //Increase it with longer combos added
	var/cooldown = 0

/datum/martial_art/plasma_fist/add_to_streak(var/element,var/mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
	if(cooldown + 100 < world.time)
		cooldown = world.time
		streak = element //Set the streak to the element to clear out our streak without fucking up the new combo about to be performed.
	else
		streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	return

/datum/martial_art/plasma_fist/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,TORNADO_COMBO))
		streak = ""
		cooldown = world.time
		Tornado(A,D)
		return 1
	if(findtext(streak,THROWBACK_COMBO))
		streak = ""
		cooldown = world.time
		Throwback(A,D)
		return 1
	if(findtext(streak,KNOCKOUT_COMBO))
		streak = ""
		cooldown = world.time
		Knockout(A,D)
		return 1
	if(findtext(streak,PLASMA_COMBO))
		streak = ""
		cooldown = world.time
		Plasma(A,D)
		return 1
	return 0

/datum/martial_art/plasma_fist/proc/Tornado(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_logs(A, D, "tornado sweeped", addition="(Plasma Fist)")
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
	add_logs(A, D, "plasma punched", addition="(Plasma Fist)")
	D.visible_message("<span class='danger'>[A] has hit [D] with Plasma Punch!</span>", \
								"<span class='userdanger'>[A] has hit [D] with Plasma Punch!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	D.adjustBruteLoss(15) //Should be pretty intense, getting punched so hard and all.
	D.adjust_fire_stacks(5)
	D.IgniteMob()
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 200, 3)
	A.say("PLASMA PUNCH!")
	A.changeNext_move(3) //Same cooldown for subsequent punches. Otherwise it throws you off.
	return

/datum/martial_art/plasma_fist/proc/Knockout(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_logs(A, D, "knocked down", addition="(Plasma Fist)")
	D.visible_message("<span class='danger'>[A] has knocked down [D] with a kick!</span>", \
								"<span class='userdanger'>[A] has knocked down [D] with a kick!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	D.adjustBruteLoss(17) //Pretty hefty damage.
	D.Weaken(1.5) //Approx. 3 seconds weaken. Due to the nature of ticks, however, it's as good as RNG.
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 2, 2)
	A.say("PLASMA KICK!")
	A.changeNext_move(3) //Same cooldown for subsequent combos. Otherwise it throws you off.
	return

/datum/martial_art/plasma_fist/proc/Plasma(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	playsound(D.loc, pick("explosion"), 30, 1) //So it's pretty radcore
	add_logs(A, D, "plasma fisted", addition="(Plasma Fist)")
	A.say("PLASMA FIST!")
	A.emote("scream")
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
	if(A == D) return //You shouldn't be able to attack yourself
	add_to_streak("H")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,rand(1,3)) //Low as hell damage because spammable
	A.changeNext_move(3) //Allows you to combo the FUCK out
	return 1

/datum/martial_art/plasma_fist/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return //You shouldn't be able to attack yourself
	add_to_streak("D")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,rand(1,3)) //Low as hell damage because spammable
	A.changeNext_move(3) //Allows you to combo the FUCK out
	return 1

/datum/martial_art/plasma_fist/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return //You shouldn't be able to attack yourself
	add_to_streak("G")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D,rand(1,3)) //Low as hell damage because spammable
	A.changeNext_move(3) //Allows you to combo the FUCK out
	return 1