//Used by special forces, developed by The Boss and Naked Snake. Uses combos. Basic attacks bypass armor and never miss
#define Cqc3_COMBO "HHH"
/datum/martial_art/cqc
	name = "CQC"

/datum/martial_art/cqc/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,Cqc3_COMBO))
		streak = ""
		Cqc3(A,D)
		return 1
	if(streak != "")
		switch(streak)
			if("leg_sweep")
				streak = ""
				leg_sweep(A,D)
				return 1
			if("quick_choke")
				streak = ""
				quick_choke(A,D)
				return 1
		return 0
	return 0

/datum/martial_art/cqc/teach(var/mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You know the basics of CQC!</span>"
	H << "<span class = 'danger'>Recall your teachings using the Recall Training verb in the CQC menu, in your verbs menu.</span>"
	H.verbs += /mob/living/carbon/human/proc/cqc_help
	H.verbs += /mob/living/carbon/human/proc/leg_sweep
	H.verbs += /mob/living/carbon/human/proc/quick_choke

/datum/martial_art/cqc/remove(var/mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You forget the basics of CQC..</span>"
	H.verbs -= /mob/living/carbon/human/proc/cqc_help
	H.verbs -= /mob/living/carbon/human/proc/leg_sweep
	H.verbs -= /mob/living/carbon/human/proc/quick_choke

/datum/martial_art/cqc/proc/Cqc3(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.stunned && !D.weakened)
		D.visible_message("<span class='warning'>[A] sweeps [D]'s foot and makes them fall!</span>", \
						  "<span class='userdanger'>[A] sweeps your foot and you fall!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.drop_item()
		D.apply_damage(5, BRUTE, pick("l_leg", "r_leg"))
		D.Weaken(2)

/datum/martial_art/cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='warning'>[A] grapples [D]!</span>", \
						  "<span class='userdanger'>[A] grapples you!</span>")
	..()
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE
		playsound(get_turf(D), 'sound/weapons/grapple.ogg', 50, 1, -1)
		D.Stun(2)

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	add_to_streak("H")
	add_logs(A, D, "punched")
	A.do_attack_animation(D)
	D.visible_message("<span class='danger'>[A] [pick("punches", "strikes", "chops", "hits")] [D]!</span>", \
					  "<span class='userdanger'>[A] hits you!</span>")
	D.apply_damage(10, BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
	return 1

/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
		D.visible_message("<span class='warning'>[A] slams [D] onto the ground!</span>", \
						  "<span class='userdanger'>[A] slams you onto the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/judoslam.ogg', 50, 1, -1)
		D.drop_item()
		D.apply_damage(15, BRUTE, pick("chest"))
		D.Weaken(3)
		A.Stun(3)
		return 1

/mob/living/carbon/human/proc/cqc_help()
	set name = "Recall Training"
	set desc = "Try to remember some the basics of cqc."
	set category = "CQC"

	usr << "<b><i>You remember the training from your former mentor...</i></b>"
	usr << "<span class='notice'>Three Hit Combo</span>: Harm Harm Harm. Drops the opponent."
	usr << "<span class='notice'>Judo Slam</span>: Disarm. Slams the opponent on the ground, at the cost of limited mobility."
	usr << "<span class='notice'>Quick Choke</span>:Mutes and Deprives the opponent of oxygen for a short time, but at the cost of limited mobility"
	usr << "<span class='notice'>Leg Sweep</span>:Knocks an enemy down, doesn't do much damage."

/datum/martial_art/cqc/proc/leg_sweep(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(D.stat || D.weakened)
		return 0
	D.visible_message("<span class='warning'>[A] leg sweeps [D]!</span>", \
					  	"<span class='userdanger'>[A] leg sweeps you!</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.Weaken(1)
	A.Stun(2)
	return 1

/datum/martial_art/cqc/proc/quick_choke(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='warning'>[A] grabs and chokes [D]!</span>", \
				  	"<span class='userdanger'>[A] grabs and chokes you!</span>")
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, 1, -1)
	D.losebreath += 5
	D.adjustOxyLoss(15)
	D.silent += 6
	A.Stun(3)

	return 1

/mob/living/carbon/human/proc/leg_sweep()
	set name = "Leg Sweep"
	set desc = "Sets your next move to the Leg Sweep."
	set category = "CQC"
	usr << "<b><i>Your next attack will be a Leg Sweep.</i></b>"
	martial_art.streak = "leg_sweep"

/mob/living/carbon/human/proc/quick_choke()
	set name = "Quick Choke"
	set desc = "Sets your next move to the Quick Choke."
	set category = "CQC"
	usr << "<b><i>Your next attack will be a Quick Choke.</i></b>"
	martial_art.streak = "quick_choke"

//ITEMS

/obj/item/clothing/gloves/cqc
	name = "tactical gloves"
	var/datum/martial_art/cqc/style = new

/obj/item/clothing/gloves/cqc/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_gloves)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

obj/item/clothing/gloves/cqc/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_gloves) == src)
		style.remove(H)
	return

/obj/item/weapon/the_basics_of_cqc
	name = "the basics of cqc"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of fighting style."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"

/obj/item/weapon/the_basics_of_cqc/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	user << "<span class='notice'>You begin to read the scroll...</span>"
	user << "<span class='sciradio'><i>And all at once the secrets of the CQC fill your mind. This basic form of close quarters combat has been imbued into this scroll. As you read through it, \
 	these secrets flood into your mind and body.<br>You now know the martial techniques of the The Boss. Your hand-to-hand combat has become much more effective, and you may now perform powerful \
 	combination attacks.<br>To learn more about these combos, use the Recall Training ability in the CQC tab.</i></span>"
	user.verbs += /mob/living/carbon/human/proc/cqc_help
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)