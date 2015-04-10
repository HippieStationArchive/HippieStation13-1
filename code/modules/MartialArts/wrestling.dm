/datum/martial_art/wrestling
	name = "Wrestling"
	priority = 9

/datum/martial_art/wrestling/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return 1 //You shouldn't be able to attack yourself
	if(D.lying) //Can't really perform choke slam or back breaker on downed opponent
		if(locate(/obj/structure/table) in get_turf(A))
			CorkscrewElbowDrop(A,D)
		else
			ChopDrop(A,D)
		return 1
	if(istype(A.get_inactive_hand(),/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = A.get_inactive_hand()
		if(G.affecting == D)
			if(G.state == GRAB_AGGRESSIVE)
				ChokeSlam(A,D)
			else if(G.state >= GRAB_NECK)
				BackBreaker(A,D)
			else if(G.state < GRAB_AGGRESSIVE)
				A << "<span class='notice'>You must have an upgraded grab to perform anything!</span>"
			return 1
	BackhandChop(A,D)
	return 1

/datum/martial_art/wrestling/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return 1 //You shouldn't be able to attack yourself
	if(istype(A.get_inactive_hand(),/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = A.get_inactive_hand()
		if(G.affecting == D)
			Suplex(A,D)
			return 1
	grab_act(A,D)
	return 1

/datum/martial_art/wrestling/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return 1 //You shouldn't be able to attack yourself
	D.grabbedby(A,1)
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G && prob(50))
		G.state = GRAB_AGGRESSIVE
		D.visible_message("<span class='danger'>[A] has [D] in a clinch! (Aggressive Grab)</span>", \
								"<span class='userdanger'>[A] has [D] in a clinch! (Aggressive Grab)</span>")
	else
		D.visible_message("<span class='danger'>[A] holds [D] down! (Passive Grab)</span>", \
									"<span class='userdanger'>[A] holds [D] down (Passive Grab)!</span>")
	return 1

/datum/martial_art/wrestling/onEquip(var/mob/living/carbon/human/H)
	if(istype(H))
		H.canTableClimb = 1
		return 1
	return 0

/datum/martial_art/wrestling/onDropped(var/mob/living/carbon/human/H)
	if(istype(H))
		H.canTableClimb = 0
		return 1
	return 0

//DA MOVES

/datum/martial_art/wrestling/proc/Suplex(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] suplexes [D]!</span>", \
								"<span class='userdanger'>[A] suplexes [D]!</span>")
	D.forceMove(A.loc)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(5, WEAKEN, armor_block)
	A.SpinAnimation(10,1)
	D.SpinAnimation(10,1)
	spawn(3)
		affecting = D.get_organ("head")
		armor_block = A.run_armor_check(null, "melee")
		A.apply_effect(4, WEAKEN, armor_block)
		D.apply_damage(25, BRUTE, affecting, armor_block)
		playsound(D, pick("swing_hit"), 40, 1)
	return

/datum/martial_art/wrestling/proc/BackhandChop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] backhand chops [D]!</span>", \
								"<span class='userdanger'>[A] backhand chops [D]!</span>")
	D.Move(get_step(D,A.dir))
	A.do_attack_animation(D)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(null, "melee")
	D.AdjustStunned(2) //2 tick stun
	D.apply_damage(10, STAMINA, affecting, armor_block)
	D.apply_damage(5, BRUTE, affecting, armor_block)
	A.changeNext_move(16) //Cooldown to prevent spamfests
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	return

/datum/martial_art/wrestling/proc/ChopDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] chop drops [D]!</span>", \
								"<span class='userdanger'>[A] chop drops [D]!</span>")
	A.do_attack_animation(D)
	spawn(1)
		A.forceMove(D.loc)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(10, BRUTE, affecting, armor_block)
	D.apply_effect(2, WEAKEN, armor_block)
	affecting = A.get_organ("chest")
	armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(1, WEAKEN, armor_block)
	A.changeNext_move(20) //Takes 2 seconds for another attack to pass
	playsound(D, pick("swing_hit"), 40, 1)
	return

/datum/martial_art/wrestling/proc/CorkscrewElbowDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a CORKSCREW ELBOW DROP on [D]!</span>", \
								"<span class='userdanger'>[A] performs a CORKSCREW ELBOW DROP on [D]!</span>")
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.AdjustWeakened(2)
	A.do_bounce_anim_dir(NORTH, 4, 16)
	D.AdjustStunned(2) //Keeps the attacked in place
	for(var/i in list(NORTH, EAST, SOUTH, WEST))
		A.dir = i
		if(i == SOUTH)
			A.forceMove(D.loc)
		playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
		sleep(2)
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(30, STAMINA, affecting, armor_block)
	affecting = D.get_organ("chest")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(35, BRUTE, affecting, armor_block)
	D.emote("scream")
	D.apply_effect(7, WEAKEN, armor_block)
	playsound(D, pick("swing_hit"), 60, 1)
	return

/datum/martial_art/wrestling/proc/ChokeSlam(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] chokeslams [D]!</span>", \
								"<span class='userdanger'>[A] chokeslams [D]!</span>")
	A.forceMove(D.loc)
	A.stunned = 999 //Keeps both in place
	A.update_canmove()
	D.stunned = 999
	D.update_canmove()
	D.do_bounce_anim_dir(NORTH, 2, 8)
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	sleep(4)
	var/obj/item/organ/limb/affecting = D.get_organ("head")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(3, WEAKEN, armor_block)
	D.apply_damage(10, BRUTE, affecting, armor_block)
	D.stunned = 0
	A.stunned = 0
	A.update_canmove()
	D.update_canmove()
	playsound(D, pick("swing_hit"), 40, 1)
	return

/datum/martial_art/wrestling/proc/BackBreaker(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a BACKBREAKER on [D]!</span>", \
								"<span class='userdanger'>[A] performs a BACKBREAKER on [D]!</span>")
	D.forceMove(A.loc)
	A.stunned = 999 //Keeps both in place
	A.update_canmove()
	D.stunned = 999
	D.update_canmove()
	D.do_bounce_anim_dir(NORTH, 2, 8)
	playsound(D, 'sound/weapons/raise.ogg', 50, 1)
	sleep(5)
	A.do_bounce_anim_dir(NORTH, 1, 8)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(5, WEAKEN, armor_block)
	D.apply_damage(30, BRUTE, affecting, armor_block)
	D.stunned = 0
	A.stunned = 0
	A.update_canmove()
	D.update_canmove()
	playsound(D, pick("swing_hit"), 60, 1)
	A.changeNext_move(30) //Takes 3 seconds for another attack to pass
	return