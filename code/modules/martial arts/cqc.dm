//Complete rework of the old CQC

#define CQC_COMBO "HHHHH"

/mob/living/carbon/human/proc/cqc_help()
	set name = "Recall CQC Training"
	set desc = "Try to remember some the basics of cqc."
	set category = "Martial Arts"

	usr << "<b><i>You remember the training from your former mentor...</i></b>"
	usr << "<span class='notice'>Roundhouse Kick</span>: Punch 5 times. Knocks the opponent unconscious."
	usr << "<span class='notice'>Robust Disarm</span>: Your disarms have no push chance, however, when you disarm someone the weapon is instantly put in your hands."
	usr << "<span class='notice'>Clinch</span>: Grab. 100% chance to instantly grab your opponent into aggressive. Can be reinforced into neckgrab quickly."
	usr << "<span class='notice'>Half-wing Choke</span>: Replaces normal choking. Faster to perform, also gives 20 staminaloss to opponent on attempted choke."
	usr << "<span class='notice'>Legsweep</span>: Harm intent w/ AGGRESSIVE grab in active hand. Cannot be performed on downed opponent. Sweeps the opponent off their feet for a while. Useful if you failed a clinch."
	usr << "<span class='notice'>Karate Chop</span>: Disarm intent w/ NECK grab in active hand. Cannot be performed on downed opponent. Makes target dizzy, gives them 20 staminaloss."
	usr << "<span class='notice'>Face Slam</span>: Harm intent w/ NECK grab in active hand. Cannot be performed on downed opponent. Slams opponent into the ground, knocking them unconscious. Only reccomended in 1v1 fights."
	usr << "<i>The arts of CQC are most effective as a surprise tactic. They were designed as a martial art that would aid a stealthy approach. Fighting multiple enemies with it would prove difficult.</i>"

/datum/martial_art/cqc
	name = "CQC"
	var/cooldown = 0
	var/damtype = BRUTE

/datum/martial_art/cqc/stamina //The safer type of cqc
	damtype = STAMINA

/datum/martial_art/cqc/teach(var/mob/living/carbon/human/H, make_temporary)
	..()
	H << "<span class = 'userdanger'>You know the basics of CQC!</span>"
	H << "<span class = 'danger'>Recall your teachings using the Recall CQC Training verb in the Martial Arts menu, in your verbs menu.</span>"
	H.verbs += /mob/living/carbon/human/proc/cqc_help

/datum/martial_art/cqc/remove(var/mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You forget the basics of CQC..</span>"
	H.verbs -= /mob/living/carbon/human/proc/cqc_help

/datum/martial_art/cqc/add_to_streak(element,mob/living/carbon/human/A,mob/living/carbon/human/D)
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

/datum/martial_art/cqc/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,CQC_COMBO))
		cooldown = world.time
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Combo(A,D)
		return 1
	return 0

/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D) //Same as Krav Maga
	A.do_attack_animation(D)
	add_logs(A, D, "disarmed", addition="(CQC)")
	if(prob(60))
		var/talked = 0
		if(D.pulling)
			D.visible_message("<span class='warning'>[A] has broken [D]'s grip on [D.pulling]!</span>")
			talked = 1
			D.stop_pulling()

		if(istype(D.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/lgrab = D.l_hand
			if(lgrab.affecting)
				D.visible_message("<span class='warning'>[A] has broken [D]'s grip on [lgrab.affecting]!</span>")
				talked = 1
			spawn(1)
				qdel(lgrab)
		if(istype(D.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/rgrab = D.r_hand
			if(rgrab.affecting)
				D.visible_message("<span class='warning'>[A] has broken [D]'s grip on [rgrab.affecting]!</span>")
				talked = 1
			spawn(1)
				qdel(rgrab)

		if(!talked)
			//Here we go. Robust disarming.
			//Reason why we do so much robust checking is because we need to prioritize active hand for the opponent's item.
			//HOWEVER, if the active hand actually contains nothing, we still should be able to snatch the weapon away from their OTHER hand.
			//Normal disarming works by only disarming the active hand. However, since we sacrifice the push chance, which drops BOTH items,
			//for this martial art, we allow the user to disarm the victim completely.
			var/list/possible = list() //Have a list to keep track of possible items to snatch.
			if(istype(D.l_hand, /obj/item))
				possible += D.l_hand
			if(istype(D.r_hand, /obj/item))
				possible += D.r_hand
			var/obj/item/I //Keep a picked "I" item variable.
			if(possible && possible.len) //If we have a list of possible items...
				if(D.hand) //Check which hand is active on the opponent. 1 = left hand, 0 = right hand.
					I = possible[D.hand] //Set the picked item to active hand.
				if(!I) //If active hand contains no weapon...
					I = pick(possible) //Pick the other hand.
			if(I && D.loc.allow_drop() && D.unEquip(I)) //We don't use drop_item due to the fact that it requires the item to be in active hand.
				A.put_in_hands(I) //Put the disarmed item in attacker's hands.
				D.visible_message("<span class='danger'>[A] has snatched [I] from [D]'s hands!</span>", \
									"<span class='userdanger'>[I] was snatched from your hands by [A]!</span>")
			else
				D.visible_message("<span class='danger'>[A] has disarmed [D]!</span>", \
								"<span class='userdanger'>[A] has disarmed [D]!</span>")
		playsound(D, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	else
		D.visible_message("<span class='danger'>[A] attempted to disarm [D]!</span>", \
							"<span class='userdanger'>[A] attempted to disarm [D]!</span>")
		playsound(D, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return 1

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(D.stat || D.lying)
		return 0 //Cannot perform combos on lying down opponents
	add_to_streak("H",A,D)
	if(check_streak(A,D))
		return 1
	add_logs(A, D, "punched", addition="(CQC)")
	A.do_attack_animation(D)
	var/msg = pick("punches", "strikes", "chops", "hits", "kicks")
	D.visible_message("<span class='danger'>[A] [msg] [D]!</span>", \
					  "<span class='userdanger'>[A] [msg] you!</span>")
	var/obj/item/organ/limb/L = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(L, "melee")
	D.apply_damage(rand(1,4), damtype, L, armor_block) //Low as fuck brute to compensate for combo potential
	playsound(get_turf(D), get_sfx("punch"), 50, 1, -2)
	A.changeNext_move(4) //Can attack quickly
	return 1

/datum/martial_art/cqc/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return 1 //You shouldn't be able to attack yourself
	D.grabbedby(A,1)
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		// if(A.dir == D.dir || prob(50)) //~100% chance to clinch when attacking from behind, otherwise it's 50% chance~
		//100% grab chance due to CQC gloves being too awkward and finicky otherwise. Much needed buff IMO.
		G.state = GRAB_AGGRESSIVE
		D.visible_message("<span class='danger'>[A] has [D] in a clinch! (Aggressive Grab)</span>", \
								"<span class='userdanger'>[A] has [D] in a clinch! (Aggressive Grab)</span>")
		add_logs(A, D, "aggro-grabbed", addition="(CQC)")
		// else
		// 	D.visible_message("<span class='danger'>[A] holds [D] down! (Passive Grab)</span>", \
		// 								"<span class='userdanger'>[A] holds [D] down (Passive Grab)!</span>")
		// 	add_logs(A, D, "grabbed", addition="(CQC)")
	return 1

/datum/martial_art/cqc/grab_reinforce_act(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D)
	switch(G.state)
		// if(GRAB_PASSIVE)
		// if(GRAB_AGGRESSIVE)
		if(GRAB_NECK)
			A.visible_message("<span class='danger'>[A] starts to perform a half-wing choke on [D]!</span>")
			G.icon_state = "kill1"
			A.adjustOxyLoss(5)
			A.adjustStaminaLoss(20)
			G.state = GRAB_UPGRADING
			if(do_after(A, round(50), target = D)) //Takes 5 seconds
				if(G.state == GRAB_KILL)
					return 1
				if(!D)
					qdel(G)
					return 1
				if(!A.canmove || A.lying)
					qdel(G)
					return 1
				G.state = GRAB_KILL
				A.visible_message("<span class='danger'>[A] performs a half-wing choke on [D]!</span>")
				var/origTransform = D.transform
				var/matrix/span1 = matrix(D.transform)
				span1.Turn(45)
				animate(D, transform = span1, time = 3)
				animate(D, transform = origTransform, time = 5, easing = BACK_EASING)
				add_logs(A, D, "half-wing choked", addition="(CQC)")

				A.changeNext_move(CLICK_CD_TKSTRANGLE)
				D.losebreath += 1
			else if(A)
				A.visible_message("<span class='warning'>[A] was unable to perform a half-wing choke on [D]!</span>")
				G.icon_state = "kill"
				G.name = "kill"
				G.state = GRAB_NECK
			return 1
		// if(GRAB_UPGRADING)
		// if(GRAB_KILL)
	return 0

/datum/martial_art/cqc/grab_attack_act(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D)
	switch(A.a_intent)
		if("disarm")
			if(G.state < GRAB_NECK)
				A << "<span class='warning'>You require a better grab to do a chop.</span>"
				return 1
			if(D.lying || D.stat)
				A << "<span class='warning'>Target must be standing up to do a chop.</span>"
				return 1
			if(D.buckled)
				A << "<span class='warning'>Target mustn't be buckled to do a chop.</span>"
				return 1
			D.visible_message("<span class='danger'>[A] karate-chops [D]!</span>", \
							  "<span class='userdanger'>[A] karate-chops you!</span>")
			D << "<span class='warning'>You feel confused...</span>"
			D.confused += 3 //Fucks with your movement
			D.adjustStaminaLoss(20)
			A.changeNext_move(20)
			add_logs(A, D, "karate-chopped", addition="(CQC)")
			playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 30, 1, -2)
		if("harm")
			if(D.lying || D.stat)
				A << "<span class='warning'>Target must be standing up to do this.</span>"
				return 1
			if(D.buckled)
				A << "<span class='warning'>Target mustn't be buckled to do this.</span>"
				return 1

			if(G.state == GRAB_AGGRESSIVE)
				D.visible_message("<span class='danger'>[A] legsweeps [D]!</span>", \
								  "<span class='userdanger'>[A] legsweeps you!</span>")
				playsound(get_turf(A), 'sound/weapons/judoslam.ogg', 50, 1, -1)
				shake_camera(D, 3, 1)
				add_logs(A, D, "legsweeped", addition="(CQC)")
				var/obj/item/organ/limb/L = D.get_organ("head")
				var/armor_block = D.run_armor_check(L, "melee")
				D.apply_damage(11, damtype, L, armor_block) //Slightly higher damage applied to head
				D.Weaken(3) //Weaken them for 3 ticks. Advantage is it bypasses armor for weaken.
				A.changeNext_move(20) //2 seconds delay before next move
				spawn(0) //Fancy animation
					for(var/i=1, i > -2, i--)
						A.dir = turn(A.dir, -90 * i)
						sleep(1)
				qdel(G)
			else if(G.state == GRAB_NECK)
				D.visible_message("<span class='danger'>[A] face-slams [D] on the ground, knocking them unconscious!</span>", \
								  "<span class='userdanger'>[A] face-slams you unconscious!</span>")
				playsound(get_turf(A), pick("swing_hit"), 50, 1, -1)
				shake_camera(D, 3, 1)
				add_logs(A, D, "face-slammed", addition="(CQC)")
				var/obj/item/organ/limb/L = D.get_organ("head")
				var/armor_block = D.run_armor_check(L, "melee")
				D.apply_damage(9, damtype, L, armor_block) //Low as fuck brute to compensate for combo potential
				D.apply_effect(10, PARALYZE, armor_block) //Will be decreased based on head armor, too
				A.do_bounce_anim_dir(SOUTH, 2, 2, easeout = BOUNCE_EASING)
				A.set_dir(EAST) //face the victim
				D.set_dir(SOUTH) //face up
				spawn(2)
					D.do_bounce_anim_dir(NORTH, 3, 4, easeout = BOUNCE_EASING)
				A.changeNext_move(30) //3 seconds delay before next move
				// A.Stun(3) //Sort of long stun
				qdel(G)
			else
				A << "<span class='warning'>You require a better grab to do this.</span>"
			return 1
		else
			return 0

/datum/martial_art/cqc/proc/Combo(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.set_dir(get_dir(A, get_step_away(A, D)))
	A.SpinAnimation(5,1)
	D.Stun(2)
	A.Stun(2)
	sleep(2)
	if(!A || !D) return
	A.set_dir(get_dir(A, D))
	A.stunned = 0
	A.update_canmove()
	playsound(A, get_sfx("punch"), 50, 1, -2)
	D.visible_message("<span class='danger'>[A] roundhouse kicks [D] unconscious!</span>", \
					  "<span class='userdanger'>[A] roundhouse kicks you unconscious!</span>")
	var/obj/item/organ/limb/L = D.get_organ("head")
	var/armor_block = D.run_armor_check(L, "melee")
	var/atom/throw_target = get_edge_target_turf(D, get_dir(A, get_step_away(D, A)))
	D.throw_at(throw_target, pick(2,4), 2)	//Throws the target away
	D.apply_damage(9, damtype, L, armor_block) //Low as fuck brute to compensate for combo potential
	D.apply_effect(8, PARALYZE, armor_block) //Will be decreased based on head armor, too
	A.do_attack_animation(D)
	shake_camera(D, 3, 1)
	playsound(D, pick("swing_hit"), 50, 1, -1)
	add_logs(A, D, "roundhouse kicked", addition="(CQC)")
	// A.Stun(2) //Stun for two ticks - ranging from 2 to 4 seconds
	A.changeNext_move(20) //Gives you a sensible delay

//ITEMS

/obj/item/clothing/gloves/cqc
	name = "fingerless gloves"
	desc = "Something oddly tactical about these gloves..."
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	permeability_coefficient = 0.05
	strip_delay = 80
	put_on_delay = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = -1 //Won't burn in fires
	var/datum/martial_art/cqc/style = new

/obj/item/clothing/gloves/cqc/holo
	name = "CQC VR Training Module"
	desc = "Gloves that let you train in the arts of CQC."
	style = new /datum/martial_art/cqc/stamina

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
 	combination attacks.</i></span>"
	var/datum/martial_art/cqc/D = new
	D.teach(user)
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
