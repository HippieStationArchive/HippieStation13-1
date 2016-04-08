//Used by the gang of the same name. Uses combos. Basic attacks bypass armor and never miss
#define WRIST_WRENCH_COMBO "DD"
#define BACK_KICK_COMBO "HG"
#define STOMACH_KNEE_COMBO "GH"
#define HEAD_KICK_COMBO "DHH"
#define ELBOW_DROP_COMBO "HDHDH"
/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"

/datum/martial_art/the_sleeping_carp/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,WRIST_WRENCH_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		wristWrench(A,D)
		return 1
	if(findtext(streak,BACK_KICK_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		backKick(A,D)
		return 1
	if(findtext(streak,STOMACH_KNEE_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		kneeStomach(A,D)
		return 1
	if(findtext(streak,HEAD_KICK_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		headKick(A,D)
		return 1
	if(findtext(streak,ELBOW_DROP_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		elbowDrop(A,D)
		return 1
	return 0

/datum/martial_art/the_sleeping_carp/proc/wristWrench(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.stunned && !D.weakened)
		D.visible_message("<span class='warning'>[A] grabs [D]'s wrist and wrenches it sideways!</span>", \
						  "<span class='userdanger'>[A] grabs your wrist and violently wrenches it to the side!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.drop_item()
		D.apply_damage(5, BRUTE, pick("l_arm", "r_arm"))
		D.Stun(2)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/backKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A.dir == D.dir && !D.stat && !D.weakened)
		D.visible_message("<span class='warning'>[A] kicks [D] in the back!</span>", \
						  "<span class='userdanger'>[A] kicks you in the back, making you stumble and fall!</span>")
		step_to(D,get_step(D,D.dir),1)
		D.Weaken(4)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/kneeStomach(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		D.visible_message("<span class='warning'>[A] knees [D] in the stomach!</span>", \
						  "<span class'userdanger'>[A] winds you with a knee in the stomach!</span>")
		D.audible_message("<b>[D]</b> gags!")
		D.losebreath += 3
		D.Stun(1)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/headKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		D.visible_message("<span class='warning'>[A] kicks [D] in the head!</span>", \
						  "<span class='userdanger'>[A] kicks you in the jaw!</span>")
		D.apply_damage(20, BRUTE, "head")
		D.drop_item()
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 75, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/elbowDrop(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(D.weakened || D.resting || D.stat)
		D.visible_message("<span class='warning'>[A] elbow drops [D]!</span>", \
						  "<span class='userdanger'>[A] piledrives you with their elbow!</span>")
		if(D.stat)
			D.death() //FINISH HIM!
		D.apply_damage(50, BRUTE, "chest")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 100, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",A,D)
	if(check_streak(A,D))
		return 1
	..()
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE //Instant aggressive grab

/datum/martial_art/the_sleeping_carp/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",A,D)
	if(check_streak(A,D))
		return 1
	D.visible_message("<span class='danger'>[A] [pick("punches", "kicks", "chops", "hits", "slams")] [D]!</span>", \
					  "<span class='userdanger'>[A] hits you!</span>")
	D.apply_damage(10, BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
	return 1


/datum/martial_art/the_sleeping_carp/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",A,D)
	if(check_streak(A,D))
		return 1
	return ..()

/mob/living/carbon/human/proc/sleeping_carp_help()
	set name = "Sleeping Carp Training"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Martial Arts"

	usr << "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>"
	usr << "<span class='notice'>Wrist Wrench</span>: Disarm Disarm. Forces opponent to drop item in hand."
	usr << "<span class='notice'>Back Kick</span>: Harm Grab. Opponent must be facing away. Knocks down."
	usr << "<span class='notice'>Stomach Knee</span>: Grab Harm. Knocks the wind out of opponent and stuns."
	usr << "<span class='notice'>Head Kick</span>: Disarm Harm Harm. Decent damage, forces opponent to drop item in hand."
	usr << "<span class='notice'>Elbow Drop</span>: Harm Disarm Harm Disarm Harm. Opponent must be on the ground. Deals huge damage, instantly kills anyone in critical condition."

//ITEMS

/obj/item/weapon/sleeping_carp_scroll
	name = "mysterious scroll"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of martial art."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"

/obj/item/weapon/sleeping_carp_scroll/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	user << "<span class='notice'>You begin to read the scroll...</span>"
	user << "<span class='sciradio'><i>And all at once the secrets of the Sleeping Carp fill your mind. The ancient clan's martial teachings have been imbued into this scroll. As you read through it, \
 	these secrets flood into your mind and body.<br>You now know the martial techniques of the Sleeping Carp. Your hand-to-hand combat has become much more effective, and you may now perform powerful \
 	combination attacks.<br>To learn more about these combos, use the Sleeping Carp Training ability in the Martial Arts tab.</i></span>"
	user.verbs += /mob/living/carbon/human/proc/sleeping_carp_help
	var/datum/martial_art/the_sleeping_carp/theSleepingCarp = new(null)
	theSleepingCarp.teach(user)
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)