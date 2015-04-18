//New moves and bugfixes by Crystalwarrior160 - Original file only had suplex.

/obj/item/weapon/paper/Wrestling
	name = "paper - 'HOW TO WRASSLE LIKE A MOTHERFUCKER'"
	info = {"<h4>WELCOME TO THE CLUB</h4>
	Well lookie here, it's a new wrestler in town! You'll have to remember quite a few things to be an effective wrassler.<br>
	You can grab people with Grab and Disarm intents. When grabbed, you'll have to switch your hand to an empty one to perform any of the moves.<br>
	You can use harm intent to perform a backhand chop which will temporarily stun your target.<br>
	Help intent functions as normal - it shakes your target up. This will be useful in performing moves that require your target to stand up.<br>
	You can also climb tables by dragging and dropping yourself on them!<br>
	<font size=5><b>DA MOVES</b></font><br>
	<font size=4><b>Harm Intent</b></font><br>
	<b>Backhand Chop</b>: Can be performed by using harm intent. Stuns target.<br>
	<b>Chop Drop</b>: Perform on a laying down opponent. Causes damage.<br>
	<u>Grab moves</u><br>
	<b>Choke Slam</b>: Requires aggro grab. Puts your target down, stuns you for a little bit.<br>
	<b>Back Breaker</b>: Stronger move than Choke Slam. Requires Neck Grab.<br>
	<u>From-table Jumps</u><br>
	<b>Moonsault</b>: Span on top of a guy and put him down. Doesn't cause too much damage but has a long stun.<br>
	<b>Corkscrew Elbow Drop</b>: Performable on a guy who's laying down. Causes a lot of damage. Can be considered a finisher.<br>
	<font size=4><b>Disarm Intent</b></font><br>
	<u>Grab moves</u><br>
	<b>Suplex</b>: An easy grab move. Requires basic grab. Weakens both you and your target, you get weakened for less time, however. Moderate damage.<br>
	<b>Tombstone Piledriver</b>: Requires Neck Grab. Absolutely devastating damage, however, you receive quite a bit of stamina damage after performing it.<br>
	<u>From-table Jumps</u><br>
	<b>Cutter/RKO</b>: Target must be standing up. Moderate damage and long weaken on target.<br>
	<font size=4><b>Table Push</b></font><br>
	<b>Powerbomb</b>: Push someone on the table with a neckgrab. Can break tables that are not reinforced.<br>
	"}

/datum/martial_art/wrestling
	name = "Wrestling"
	priority = 9
	var/damtype = BRUTE

/datum/martial_art/wrestling/stamina //The safer type of wrassling
	damtype = STAMINA

/datum/martial_art/wrestling/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A == D) return 1 //You shouldn't be able to attack yourself
	if(D.lying)
		if(locate(/obj/structure/table) in get_turf(A))
			CorkscrewElbowDrop(A,D)
		else
			ChopDrop(A,D)
		return 1
	if(locate(/obj/structure/table) in get_turf(A))
		Moonsault(A,D)
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
	if(locate(/obj/structure/table) in get_turf(A))
		if(!D.lying)
			Cutter(A,D)
			return 1
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
		add_logs(A, D, "aggro-grabbed", addition="(Wrassling)")
	else
		D.visible_message("<span class='danger'>[A] holds [D] down! (Passive Grab)</span>", \
									"<span class='userdanger'>[A] holds [D] down (Passive Grab)!</span>")
		add_logs(A, D, "grabbed", addition="(Wrassling)")
	return 1

/datum/martial_art/wrestling/tablepush_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D, var/obj/item/weapon/grab/G, var/obj/structure/table/T)
	if(G.state >= GRAB_NECK)
		qdel(G)
		PowerBomb(A,D,T)
		return 1
	return 0

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
	A.SpinAnimation(6,1, easeout = ELASTIC_EASING)
	D.SpinAnimation(6,1, easeout = ELASTIC_EASING)
	sleep(3)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	D.forceMove(A.loc)
	affecting = D.get_organ("head")
	D.apply_damage(25, damtype, affecting, armor_block)
	affecting = A.get_organ("chest")
	armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(4, WEAKEN, armor_block)
	add_logs(A, D, "suplexed", addition="(Wrassling)")
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
	D.apply_damage(5, STAMINA, affecting, armor_block)
	D.apply_damage(5, damtype, affecting, armor_block)
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	add_logs(A, D, "backhand chopped", addition="(Wrassling)")
	shake_camera(D, 2, 1)
	D.stunned = 999 //This is a much better way to keep someone stunned for a short time due to the tick nature of AdjustStunned() proc
	D.update_canmove()
	sleep(20)
	if(!D) return
	D.stunned = 0
	D.update_canmove()
	return

/datum/martial_art/wrestling/proc/ChopDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] chop drops [D]!</span>", \
								"<span class='userdanger'>[A] chop drops [D]!</span>")
	A.forceMove(D.loc)
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(2, WEAKEN, armor_block)
	D.stunned = 999
	D.update_canmove()
	A.do_bounce_anim_dir(NORTH, 4, 8, easein = BACK_EASING, easeout = BOUNCE_EASING)
	playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
	sleep(4)
	if(D)
		D.stunned = 0
		D.update_canmove()
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	affecting = D.get_organ("chest")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(10, damtype, affecting, armor_block)
	D.apply_effect(2, WEAKEN, armor_block)
	A.changeNext_move(20) //Takes 2 seconds for another attack to pass
	playsound(D, pick("swing_hit"), 40, 1)
	add_logs(A, D, "chop dropped", addition="(Wrassling)")
	for(var/mob/M in range(1, D)) //Only shake camera for close-by people
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 2, 1) //Shorter shake
	return

/datum/martial_art/wrestling/proc/ChokeSlam(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] chokeslams [D]!</span>", \
								"<span class='userdanger'>[A] chokeslams [D]!</span>")
	A.forceMove(D.loc)
	A.stunned = 999 //Keeps both in place
	A.update_canmove()
	D.stunned = 999
	D.update_canmove()
	D.do_bounce_anim_dir(NORTH, 3, 8, easeout = BOUNCE_EASING)
	A.do_bounce_anim_dir(NORTH, 3, 4, easein = ELASTIC_EASING, easeout = BACK_EASING)
	A.forceMove(D.loc)
	playsound(D, 'sound/weapons/push_hard.ogg', 50, 1)
	sleep(4)
	if(A)
		A.stunned = 0
		A.update_canmove()
	if(D)
		D.stunned = 0
		D.update_canmove()
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	A.forceMove(D.loc)
	var/obj/item/organ/limb/affecting = D.get_organ("head")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(3, WEAKEN, armor_block)
	D.apply_damage(10, damtype, affecting, armor_block)
	shake_camera(D, 3, 1) //Chokeslammed into the ground
	playsound(D, pick("swing_hit"), 40, 1)
	add_logs(A, D, "chokeslammed", addition="(Wrassling)")
	return

/* Finishers */

/datum/martial_art/wrestling/proc/BackBreaker(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a BACKBREAKER on [D]!</span>", \
								"<span class='userdanger'>[A] performs a BACKBREAKER on [D]!</span>")
	D.forceMove(A.loc)
	D.dir = A.dir
	A.stunned = 999 //Keeps both in place
	A.update_canmove()
	D.stunned = 999
	D.update_canmove()
	D.do_bounce_anim_dir(NORTH, 4, 8, easeout = BOUNCE_EASING)
	A.do_bounce_anim_dir(NORTH, 2, 4, easein = CUBIC_EASING, easeout = BACK_EASING)
	A.forceMove(D.loc)
	playsound(D, 'sound/weapons/raise.ogg', 50, 1)
	sleep(5)
	if(A)
		A.stunned = 0
		A.update_canmove()
	if(D)
		D.stunned = 0
		D.update_canmove()
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	A.forceMove(D.loc)
	A.do_bounce_anim_dir(NORTH, 1, 8, easeout = BACK_EASING)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(5, WEAKEN, armor_block)
	D.apply_damage(30, damtype, affecting, armor_block)
	D.emote("scream")
	shake_camera(D, 3, 3) //His BACK got broken, shake the fuck out of his screen.
	playsound(D, pick("swing_hit"), 60, 1)
	add_logs(A, D, "performed a backbreaker on", addition="(Wrassling)")
	A.changeNext_move(30) //Takes 3 seconds for another attack to pass
	return

/datum/martial_art/wrestling/proc/TombstonePiledriver(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a TOMBSTONE PILEDRIVER on [D]!</span>", \
								"<span class='userdanger'>[A] performs a TOMBSTONE PILEDRIVER on [D]!</span>")
	A.AdjustStunned(2) //Keeps the attacker in place. 2 ticks should be enough for us
	A.do_bounce_anim_dir(NORTH, 2, 7, easein = CUBIC_EASING)
	D.AdjustStunned(2) //Keeps the attacked in place
	A.dir = SOUTH
	D.dir = SOUTH
	D.forceMove(A.loc)
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
	animate(D, transform = span3, time = speed, easing = ELASTIC_EASING)
	playsound(D, 'sound/weapons/raise.ogg', 40, 0, -1)
	sleep(10)
	if(D) //Safety check
		D.do_bounce_anim_dir(NORTH, 4, 10, easeout = BOUNCE_EASING)
		A.do_bounce_anim_dir(NORTH, 2, 10, easeout = BACK_EASING)
	sleep(2)
	if(D)
		D.transform = origTransform //This should fix the rotation
	if(!A || A.stat || !D || !A.Adjacent(D)) return //if, somehow, the attacker got fucked up or the victim got pulled away, let's end the move
	D.forceMove(A.loc)
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(40, STAMINA, affecting, armor_block) //This move will take lots of your stamina as a balancing measure
	affecting = D.get_organ("head")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(40, damtype, affecting, armor_block)
	D.emote("scream")
	D.apply_effect(7, WEAKEN, armor_block) //You got FUCKED UP.
	for(var/mob/M in range(4, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	playsound(D, pick("swing_hit"), 60, 0)
	add_logs(A, D, "tombstone piledrivered", addition="(Wrassling)")
	return

/* Performed from table */

/datum/martial_art/wrestling/proc/CorkscrewElbowDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a CORKSCREW ELBOW DROP on [D]!</span>", \
								"<span class='userdanger'>[A] performs a CORKSCREW ELBOW DROP on [D]!</span>")
	A.AdjustWeakened(2)
	A.do_bounce_anim_dir(NORTH, 6, 16, easein = BACK_EASING, easeout = BOUNCE_EASING)
	D.AdjustStunned(2) //Keeps the attacked in place
	for(var/i in list(NORTH, EAST, SOUTH, WEST))
		if(!A) break
		A.dir = i
		if(i == SOUTH)
			A.forceMove(D.loc)
		playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
		sleep(2)
	if(A) A.dir = NORTH
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(30, STAMINA, affecting, armor_block)
	affecting = D.get_organ("chest")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(35, damtype, affecting, armor_block)
	D.emote("scream")
	D.apply_effect(7, WEAKEN, armor_block)
	playsound(D, pick("swing_hit"), 60, 1)
	add_logs(A, D, "corkscrew elbow dropped", addition="(Wrassling)")
	for(var/mob/M in range(3, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	return

/datum/martial_art/wrestling/proc/Cutter(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs an RKO on [D]!</span>", \
								"<span class='userdanger'>[A] performs an RKO on [D]!</span>")
	A.AdjustWeakened(2)
	A.lying = 90
	A.pixel_x -= 6
	A.do_bounce_anim_dir(NORTH, 4, 16, easeout = BOUNCE_EASING)
	D.AdjustWeakened(2) //Keeps the attacked in place
	D.lying = 270
	D.pixel_x += 6
	D.do_bounce_anim_dir(NORTH, 5, 16, easeout = BOUNCE_EASING)
	var/todir = get_dir(A, D)
	playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
	A.forceMove(D.loc)
	sleep(3)
	if(D) D.Move(get_step(D,todir))
	if(A) A.Move(get_step(A,todir))
	sleep(2)
	if(A) A.pixel_x = initial(A.pixel_x)
	if(D) D.pixel_x = initial(D.pixel_x)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(30, STAMINA, affecting, armor_block)
	affecting = D.get_organ("chest")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(25, damtype, affecting, armor_block)
	D.emote("scream")
	D.apply_effect(7, WEAKEN, armor_block)
	playsound(D, pick("swing_hit"), 60, 1)
	add_logs(A, D, "RKO'd", addition="(Wrassling)")
	for(var/mob/M in range(3, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	return

/datum/martial_art/wrestling/proc/Moonsault(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] performs a MOONSAULT on [D]!</span>", \
								"<span class='userdanger'>[A] performs a MOONSAULT on [D]!</span>")
	A.AdjustStunned(2)
	A.dir = get_dir(D, A) //Reverse attacker's direction
	A.pixel_y += 8
	A.SpinAnimation(6,1)

	D.AdjustStunned(2) //Keeps the attacked in place
	playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
	sleep(2)
	A.forceMove(D.loc)
	playsound(A, 'sound/weapons/raise.ogg', 30, 0, -1)
	sleep(2)
	if(!A || A.stat || !D || !A.Adjacent(D)) return
	A.pixel_y = initial(A.pixel_y)
	var/obj/item/organ/limb/affecting = A.get_organ("chest")
	var/armor_block = A.run_armor_check(affecting, "melee")
	A.apply_effect(5, WEAKEN, armor_block)
	A.apply_damage(10, STAMINA, affecting, armor_block)
	A.do_bounce_anim_dir(NORTH, 2, 6, easein = BACK_EASING, easeout = BOUNCE_EASING)
	affecting = D.get_organ("chest")
	armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(15, damtype, affecting, armor_block) //Doesn't do too much damage compared to other moves
	D.apply_damage(30, STAMINA, affecting, armor_block) //Still does stamina damage to compensate
	D.do_bounce_anim_dir(NORTH, 2, 4, easein = BACK_EASING, easeout = BOUNCE_EASING)
	D.apply_effect(7, WEAKEN, armor_block)
	playsound(D, 'sound/weapons/push_hard.ogg', 60, 1) //Sound signalises that this is not a high-damage attack
	add_logs(A, D, "moonsaulted", addition="(Wrassling)")
	for(var/mob/M in range(2, D)) //Shaky camera effect
		if(!M.stat && !istype(M, /mob/living/silicon/ai))
			shake_camera(M, 3, 1)
	return

/* Grab moves performed as a table push */

/datum/martial_art/wrestling/proc/PowerBomb(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D, var/obj/structure/table/T)
	D.visible_message("<span class='danger'>[A] powerbombs [D] on the [T]!</span>", \
						"<span class='userdanger'>[A] powerbombs [D] on the [T]!</span>")
	A.stunned = 999
	A.do_bounce_anim_dir(NORTH, 4, 10, easein = BACK_EASING, easeout = BOUNCE_EASING)
	D.AdjustStunned(2)
	D.forceMove(A.loc)
	D.do_bounce_anim_dir(NORTH, 4, 16, easein = BACK_EASING, easeout = BOUNCE_EASING)
	playsound(D, 'sound/weapons/raise.ogg', 30, 0, -1)
	sleep(4)
	if(A)
		A.stunned = 0
	if(!A || A.stat || !D || !A.Adjacent(D) || !T) return
	D.forceMove(T.loc)
	var/obj/item/organ/limb/affecting = D.get_organ("chest")
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_effect(6, WEAKEN, armor_block)
	D.apply_damage(25, damtype, affecting, armor_block)
	// D.do_bounce_anim_dir(SOUTH, 4, 2, easein = BOUNCE_EASING)
	// A.do_bounce_anim_dir(SOUTH, 4, 2, easein = BOUNCE_EASING)
	playsound(D, pick("swing_hit"), 50, 1)
	add_logs(A, D, "powerbombed", addition="(Wrassling)")
	A.changeNext_move(20) //Takes 2 seconds for another attack to pass

	if(istype(T, /obj/structure/table/glass))
		T.visible_message("<span class='warning'>[T] breaks!</span>")
		playsound(T.loc, "shatter", 50, 1)
		new T.frame(T.loc)
		var/obj/item/weapon/shard/S = new(T.loc)
		D.adjustBruteLoss(5)
		var/obj/item/organ/limb/O = D.get_organ(ran_zone())
		if(istype(O))
			S.add_blood(D)
			S.loc = D
			O.embedded += S //Lodge the object into the limb
			D.update_damage_overlays() //Update the fancy embeds
			T.visible_message("<span class='warning'>The [S] has embedded into [D]'s [O.getDisplayName()]!</span>",
							"<span class='userdanger'>You feel [S] lodge into your [O.getDisplayName()]!</span>")
			D.emote("scream")
			D.adjustBloodLoss(0.01, O)
		qdel(T)
		return
	if(!istype(T, /obj/structure/table/reinforced) && !istype(T, /obj/structure/table/holotable)) //Cannot destroy reinforced or holotables
		T.table_destroy(1)