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
			if(G.state >= GRAB_NECK && !D.lying) //Tombstone piledriver can only be performed on people standing up
				TombstonePiledriver(A,D) //Absolutely devastating
			else //Suplex, however, doesn't need that.
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
	sleep(3)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	affecting = D.get_organ("head")
	armor_block = A.run_armor_check(null, "melee")
	A.apply_effect(4, WEAKEN, armor_block)
	D.apply_damage(25, BRUTE, affecting, armor_block)
	playsound(D, pick("swing_hit"), 40, 1)
	for(var/mob/M in range(2, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	return

/datum/martial_art/wrestling/proc/BackhandChop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] backhand chops [D]!</span>", \
								"<span class='userdanger'>[A] backhand chops [D]!</span>")
	D.Move(get_step(D,A.dir))
	A.do_attack_animation(D)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(null, "melee")
	D.apply_damage(10, STAMINA, affecting, armor_block)
	D.apply_damage(5, BRUTE, affecting, armor_block)
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	shake_camera(D, 2, 1)
	D.stunned = 999 //This is a much better way to keep someone stunned for a short time due to the tick nature of AdjustStunned() proc
	D.update_canmove()
	sleep(10)
	if(!D) return
	D.stunned = 0
	D.update_canmove()
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
	for(var/mob/M in range(1, D)) //Only shake camera for close-by people
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 2, 1) //Shorter shake
	return

/datum/martial_art/wrestling/proc/CorkscrewElbowDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a CORKSCREW ELBOW DROP on [D]!</span>", \
								"<span class='userdanger'>[A] performs a CORKSCREW ELBOW DROP on [D]!</span>")
	A.AdjustWeakened(2)
	A.do_bounce_anim_dir(NORTH, 4, 16)
	D.AdjustStunned(2) //Keeps the attacked in place
	for(var/i in list(NORTH, EAST, SOUTH, WEST))
		A.dir = i
		if(i == SOUTH)
			A.forceMove(D.loc)
		playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
		sleep(2)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(30, STAMINA, affecting, armor_block)
	affecting = D.get_organ("chest")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(35, BRUTE, affecting, armor_block)
	D.emote("scream")
	D.apply_effect(7, WEAKEN, armor_block)
	playsound(D, pick("swing_hit"), 60, 1)
	for(var/mob/M in range(3, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	return

/datum/martial_art/wrestling/proc/TombstonePiledriver(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a TOMBSTONE PILEDRIVER on [D]!</span>", \
								"<span class='userdanger'>[A] performs a TOMBSTONE PILEDRIVER on [D]!</span>")
	A.AdjustStunned(2) //Keeps the attacker in place. 2 ticks should be enough for us
	A.do_bounce_anim_dir(NORTH, 2, 7)
	D.AdjustStunned(2) //Keeps the attacked in place
	A.dir = SOUTH
	D.dir = SOUTH
	var/origTransform = D.transform
	var/matrix/span1 = matrix(D.transform)
	span1.Turn(60) //Turn the attacked 60 degrees
	var/matrix/span2 = matrix(D.transform)
	span2.Turn(120)
	var/matrix/span3 = matrix(D.transform)
	span3.Turn(180) 
	var/speed = 10 / 3
	animate(D, transform = span1, time = speed) //If we instantly turn the guy 180 degrees he'll just pop out and in of existance all weird-like
	animate(D, transform = span2, time = speed)
	animate(D, transform = span3, time = speed)
	playsound(D, 'sound/weapons/raise.ogg', 40, 0, -1)
	sleep(10)
	if(D) //Safety check
		D.do_bounce_anim_dir(NORTH, 2, 10)
		A.do_bounce_anim_dir(NORTH, 2, 10)
	sleep(2)
	if(D)
		D.transform = origTransform //This should fix the rotation
	if(!A || A.stat || !D || !A.Adjacent(D)) return //if, somehow, the attacker got fucked up or the victim got pulled away, let's end the move

	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(40, STAMINA, affecting, armor_block) //This move will take lots of your stamina as a balancing measure
	affecting = D.get_organ("head")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(40, BRUTE, affecting, armor_block)
	D.emote("scream")
	D.apply_effect(7, WEAKEN, armor_block) //You got FUCKED UP.
	for(var/mob/M in range(4, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	playsound(D, pick("swing_hit"), 60, 0)
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
	A.do_bounce_anim_dir(NORTH, 2, 4)
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	sleep(4)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	var/obj/item/organ/limb/affecting = D.get_organ("head")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(3, WEAKEN, armor_block)
	D.apply_damage(10, BRUTE, affecting, armor_block)
	D.stunned = 0
	A.stunned = 0
	A.update_canmove()
	D.update_canmove()
	shake_camera(D, 3, 1) //Chokeslammed into the ground
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
	A.do_bounce_anim_dir(NORTH, 2, 4)
	playsound(D, 'sound/weapons/raise.ogg', 50, 1)
	sleep(5)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	A.do_bounce_anim_dir(NORTH, 1, 8)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(5, WEAKEN, armor_block)
	D.apply_damage(30, BRUTE, affecting, armor_block)
	D.stunned = 0
	A.stunned = 0
	A.update_canmove()
	D.update_canmove()
	D.emote("scream")
	shake_camera(D, 3, 3) //His BACK got broken, shake the fuck out of his screen.
	playsound(D, pick("swing_hit"), 60, 1)
	A.changeNext_move(30) //Takes 3 seconds for another attack to pass
	return