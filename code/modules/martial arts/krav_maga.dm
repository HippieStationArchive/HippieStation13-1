/*
	This is martial art used by trained security personnel
*/

/datum/martial_art/krav_maga //Based on Goofball's idea
	name = "Krav Maga" //Name subject to change

/mob/living/carbon/human/proc/krav_maga_help()
	set name = "Krav Maga Tutorial"
	set desc = "Access the Krav Maga tutorial."
	set category = "Martial Arts"

	usr << "<b><i>You recall your Krav Maga teachings...</i></b>"
	usr << "<span class='notice'>Robust Disarm</span>: Your disarms have no push chance, however, when you disarm someone the weapon is instantly put in your hands."
	usr << "<span class='notice'>Pinning Down</span>: Pin your opponent down to immobilize them. Several ways to execute: reinforcing grab on top of someone will pin down. Attacking someone with a grab IN-HAND and disarm intent will also execute the move."
	usr << "<b><i>Most of your moves rely on intent cycling and grabs. Keep that in mind.</i></b>"

/datum/martial_art/krav_maga/teach(mob/living/carbon/human/H, make_temporary)
	..()
	H << "<span class = 'userdanger'>You know the arts of Krav Maga!</span>"
	H << "<span class = 'danger'>Recall your teachings using the Krav Maga Tutorial verb in the Martial Arts menu, in your verbs menu.</span>"
	H.verbs += /mob/living/carbon/human/proc/krav_maga_help

/datum/martial_art/krav_maga/remove(mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You forget the arts of Krav Maga..</span>"
	H.verbs -= /mob/living/carbon/human/proc/krav_maga_help

/datum/martial_art/krav_maga/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.do_attack_animation(D)
	add_logs(A, D, "disarmed", addition="(Krav Maga)")
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

/datum/martial_art/krav_maga/grab_reinforce_act(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(G.force_down && (!D.lying || D.loc != A.loc))
		A << "<span class='notice'>You're no longer pinning [D] down.</span>"
		G.force_down = 0

	switch(G.state)
		if(GRAB_PASSIVE)
			if(!G.allow_upgrade)
				return 0
			if(!D.lying || D.loc != A.loc)
				return 0
			A.visible_message("<span class='warning'>[A] pins [D] down to the ground (now hands)!</span>")
			playsound(get_turf(A), 'sound/weapons/grapple.ogg', 50, 1, -1)
			add_logs(A, D, "pinned down", addition="(Krav Maga)")
			G.force_down = 1
			D.Weaken(3)
			// step_towards(A,D)) //We're already on top, though, so this may be unneccesary.
			A.set_dir(EAST) //face the victim
			D.set_dir(SOUTH) //face up
			G.state = GRAB_AGGRESSIVE //Reduces your grab to aggro even from neckgrab
			G.icon_state = "reinforce1"
			G.last_upgrade = world.time
			return 1 //We have overriden the upgrade to aggro grab
		if(GRAB_AGGRESSIVE)
			if(G.force_down)
				A << "<span class='notice'>You're no longer pinning [D] down.</span>"
				G.force_down = 0
		// if(GRAB_NECK)
		// if(GRAB_UPGRADING)
		// if(GRAB_KILL)
	return 0

/datum/martial_art/krav_maga/grab_attack_act(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A.a_intent == "help")
		if(G.force_down)
			A << "<span class='warning'>You no longer pin [D] to the ground.</span>"
			G.force_down = 0
			return 1
	if(A.a_intent == "disarm") //Pin 'em down!
		// if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		// 	return
		if(G.state < GRAB_AGGRESSIVE)
			A << "<span class='warning'>You require a better grab to do a pindown.</span>"
			return 1
		if(!G.force_down)
			G.last_upgrade = world.time //So you can't upgrade into neckgrab instantly if you pindown late or something
			D.density = 0 //Fuckin dirty hack to check if we can step towards him
			if(!step_towards(A,D) && D.loc != A.loc)
				D.update_canmove()
				A << "<span class='warning'>You cannot reach [D] for a pindown!</span>"
				return 1
			A.visible_message("<span class='danger'>[A] is forcing [D] to the ground!</span>")
			playsound(get_turf(A), 'sound/weapons/grapple.ogg', 50, 1, -1)
			add_logs(A, D, "pinned down", addition="(Krav Maga)")
			G.force_down = 1
			D.Weaken(3) //update_canmove is called so prior density setting won't affect much
			A.set_dir(EAST) //face the victim
			D.set_dir(SOUTH) //face up
			G.state = GRAB_AGGRESSIVE
			G.icon_state = "grabbed1" //reset the icon state for the animation to replay
			G.icon_state = "reinforce1"
			A.changeNext_move(CLICK_CD_MELEE) //Give them some cooldown till next action
		else
			A << "<span class='warning'>You are already pinning [D] to the ground.</span>"
			return 1
		return 1
	return 0

/datum/martial_art/krav_maga/grab_process(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(G.force_down && (!D.lying || D.loc != A.loc))
		A << "<span class='notice'>You're no longer pinning [D] down.</span>"
		G.force_down = 0
		return 1
	if(G.state >= GRAB_AGGRESSIVE)
		if(G.force_down)
			if(D.loc != A.loc)
				G.force_down = 0
			else
				D.Weaken(3)
	return 0

/obj/item/clothing/gloves/krav_maga
	name = "Krav Maga gloves"
	desc = "Gloves that contain the power of Krav Maga."
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	put_on_delay = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	var/datum/martial_art/krav_maga/style = new

/obj/item/clothing/gloves/krav_maga/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_gloves)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

obj/item/clothing/gloves/krav_maga/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_gloves) == src)
		style.remove(H)
	return

/obj/item/weapon/the_arts_of_krav_maga
	name = "the arts of Krav Maga"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of fighting style."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"

/obj/item/weapon/the_arts_of_krav_maga/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	user << "<span class='notice'>You begin to read the scroll...</span>"
	user << "<span class='sciradio'><i>And all at once the secrets of the Krav Maga fill your mind. This basic form of close quarters combat has been imbued into this scroll. As you read through it, \
 	these secrets flood into your mind and body.<br>Your hand-to-hand combat has become much more effective. \
 	<br>To learn more about these combos, use the Recall Training ability in the Krav Maga tab.</i></span>"
	var/datum/martial_art/krav_maga/D = new
	D.teach(user)
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)