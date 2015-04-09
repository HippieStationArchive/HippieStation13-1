/datum/martial_art/wrestling
	name = "Wrestling"
	priority = 9

/datum/martial_art/wrestling/proc/Suplex(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] suplexes [D]!</span>", \
								"<span class='userdanger'>[A] suplexes [D]!</span>")
	D.forceMove(A.loc)
	var/armor_block = D.run_armor_check(null, "melee")
	D.apply_effect(5, WEAKEN, armor_block)
	A.SpinAnimation(10,1)

	D.SpinAnimation(10,1)
	spawn(3)
		armor_block = A.run_armor_check(null, "melee")
		A.apply_effect(4, WEAKEN, armor_block)
		D.apply_damage(25, BRUTE, null, armor_block)
		playsound(D, pick("swing_hit"), 40, 1)
	return

/datum/martial_art/wrestling/proc/BackhandChop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] backhand chops [D]!</span>", \
								"<span class='userdanger'>[A] backhand chops [D]!</span>")
	D.Move(get_step(D,A.dir))
	var/armor_block = D.run_armor_check(null, "melee")
	D.apply_effect(0.5, STUN, armor_block)
	D.apply_damage(10, STAMINA, null, armor_block)
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	return

/datum/martial_art/wrestling/proc/ChopDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] chop drops [D]!</span>", \
								"<span class='userdanger'>[A] chop drops [D]!</span>")
	A.do_attack_animation(D)
	spawn(1)
		A.forceMove(D.loc)
	var/armor_block = D.run_armor_check(null, "melee")
	D.apply_damage(10, BRUTE, null, armor_block)
	D.apply_effect(2, WEAKEN, armor_block)
	armor_block = A.run_armor_check(null, "melee")
	D.apply_effect(1, WEAKEN, armor_block)
	A.changeNext_move(20) //Takes 2 seconds for another attack to pass
	playsound(D, pick("swing_hit"), 40, 1)
	return

/datum/martial_art/wrestling/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	// if(istype(A.get_inactive_hand(),/obj/item/weapon/grab))
	// 	var/obj/item/weapon/grab/G = A.get_inactive_hand()
	// 	if(G.affecting == D)
	// 		ChopDrop(A,D)
	// 		return 1
	if(D.lying)
		ChopDrop(A,D)
		return 1
	BackhandChop(A,D)
	return 1

/datum/martial_art/wrestling/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(istype(A.get_inactive_hand(),/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = A.get_inactive_hand()
		if(G.affecting == D)
			Suplex(A,D)
			return 1
	grab_act(A,D)
	return 1

/datum/martial_art/wrestling/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.grabbedby(A,1)
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G && prob(50))
		G.state = GRAB_AGGRESSIVE
		D.visible_message("<span class='danger'>[A] has [D] in a clinch!</span>", \
								"<span class='userdanger'>[A] has [D] in a clinch!</span>")
	else
		D.visible_message("<span class='danger'>[A] holds [D] down!</span>", \
									"<span class='userdanger'>[A] holds [D] down!</span>")
	return 1

//BROKEN: Doesn't remove tableclimbing when dropped.
// /datum/martial_art/wrestling/onEquip(var/mob/living/carbon/human/H)
// 	if(istype(H))
// 		H.canTableClimb = 1
// 		return 1
// 	return 0

// /datum/martial_art/wrestling/onDropped(var/mob/living/carbon/human/H)
// 	if(istype(H))
// 		H.canTableClimb = 0
// 		return 1
// 	return 0