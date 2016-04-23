//Change organ status
/obj/item/organ/limb/proc/change_organ(var/type)
	status = type
	state_flags = ORGAN_FINE
	burn_dam = 0
	brute_dam = 0
	brutestate = 0
	burnstate = 0

	if(owner)
		owner.updatehealth()
		owner.regenerate_icons()


//Drop the limb
/obj/item/organ/limb/proc/drop_limb()
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!updated)
			update_limb(H)
		H.organs -= src
		owner = null

	bloodloss = 0

	var/turf/T = get_turf(src)
	src.loc = T

//Augment a limb
/obj/item/organ/limb/proc/augment(var/obj/item/I, var/mob/user)
	if(!(state_flags & ORGAN_AUGMENTABLE))
		return

	if(!owner)
		return

	var/who = "[owner]'s"
	if(user == owner)
		who = "their"

	owner.visible_message("<span class='notice'>[user] has attatched [who] new limb!</span>")
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(istype(I, /obj/item/robot_parts))
			var/obj/item/robot_parts/RP = I
			var/obj/item/organ/limb/L = H.get_organ(Bodypart2name(RP.body_part))
			if(istype(L))
				L.drop_limb()
	change_organ(ORGAN_ROBOTIC)
	user.drop_item()
	qdel(I)
	owner.update_canmove()

//Dismember a limb
/obj/item/organ/limb/proc/dismember()
	state_flags = ORGAN_AUGMENTABLE
	var/mob/living/carbon/human/H = owner
	drop_limb()
	var/direction = pick(cardinal)
	step(src,direction)

	if(istype(H))
		H.apply_damage(30, BRUTE, "chest") //Chest houses most of the limbs, sooo..
		var/obj/item/organ/limb/affecting = H.get_organ("chest")
		affecting.take_damage(0,0,1) //Your arm's off, ofcourse you're gonna bleed!
		H.visible_message("<span class='danger'><B>[H]'s [src] has been violently dismembered!</B></span>")
		H.drop_r_hand()
		H.drop_l_hand()
		H.update_canmove()
		H.regenerate_icons()
		H.emote("scream")
		playsound(get_turf(H), pick('sound/misc/splat.ogg', 'sound/misc/splort.ogg'), 80, 1)

/obj/item/organ/limb/head/dismember()
	state_flags = ORGAN_AUGMENTABLE
	if(!owner)
		return
	owner.visible_message("<span class='danger'><B>[owner] doesn't look too good...</B></span>")
	return

/obj/item/organ/limb/head/drop_limb()
	return

/obj/item/organ/limb/chest/dismember()
	state_flags = ORGAN_AUGMENTABLE

	if(!owner)
		return
	owner.visible_message("<span class='danger'><B>[owner]'s internal organs spill out onto the floor!</B></span>")
	for(var/obj/item/organ/O in owner.internal_organs)
		if(istype(O, /obj/item/organ/internal/brain))
			continue
		owner.internal_organs -= O
		O.loc = get_turf(owner)
		playsound(get_turf(owner), pick('sound/misc/splat.ogg', 'sound/misc/splort.ogg'), 80, 1)
	return

/obj/item/organ/limb/chest/drop_limb()
	return

/obj/item/organ/limb/r_arm/dismember()
	..()

	if(!owner)
		return
	if(owner.handcuffed)
		owner.handcuffed.loc = get_turf(owner)
		owner.handcuffed = null
		owner.update_inv_handcuffed(0)

/obj/item/organ/limb/l_arm/dismember()
	..()

	if(!owner)
		return
	if(owner.handcuffed)
		owner.handcuffed.loc = get_turf(owner)
		owner.handcuffed = null
		owner.update_inv_handcuffed(0)

/obj/item/organ/limb/r_leg/dismember()
	..()

	if(!owner)
		return
	if(owner.legcuffed)
		owner.legcuffed.loc = get_turf(owner)
		owner.legcuffed = null
		owner.update_inv_legcuffed(0)

/obj/item/organ/limb/l_leg/dismember()
	..()

	if(!owner)
		return
	if(owner.legcuffed)
		owner.legcuffed.loc = get_turf(owner)
		owner.legcuffed = null
		owner.update_inv_legcuffed(0)


//Attach a limb (the limb still keeps all the flags and stuff, so it's probably unusable unless you do surgery to fix up augment wounds)
/mob/living/carbon/human/proc/attachLimb(var/obj/item/organ/limb/L, var/mob/user)
	var/obj/item/organ/limb/O = locate(L.type) in organs
	if(istype(O))
		O.drop_limb()

	user.drop_item()
	L.loc = src
	L.owner = src
	organs += L

	var/who = "[src]'s"
	if(user == src)
		who = "their"

	visible_message("<span class='notice'>[user] has attatched [who] new limb!</span>")
	update_canmove()
	updatehealth()
	regenerate_icons()

//Limb numbers
/mob/proc/get_num_arms(var/usable=0)
	return 2
/mob/proc/get_num_legs(var/usable=0)
	return 2

/mob/living/carbon/human/get_num_arms(var/usable=0)
	. = 0
	for(var/obj/item/organ/limb/affecting in organs)
		var/pass = usable ? !(affecting.state_flags & ORGAN_AUGMENTABLE) : 1
		var/part = affecting.body_part
		if(part == ARM_RIGHT && pass)
			.++
		if(part == ARM_LEFT && pass)
			.++

/mob/living/carbon/human/get_num_legs(var/usable=0)
	. = 0
	for(var/obj/item/organ/limb/affecting in organs)
		var/pass = usable ? !(affecting.state_flags & ORGAN_AUGMENTABLE) : 1
		var/part = affecting.body_part
		if(part == LEG_RIGHT && pass)
			.++
		if(part == LEG_LEFT && pass)
			.++

//Helper for cleaner code, used in lots of places to substitute for limb.name stuffs
/proc/Bodypart2name(var/part)
	. = 0
	if(islimb(part))
		var/obj/item/organ/limb/L = part
		part = L.body_part
	switch(part)
		if(CHEST)
			. = "chest"
		if(HEAD)
			. = "head"
		if(ARM_RIGHT)
			. = "r_arm"
		if(ARM_LEFT)
			. = "l_arm"
		if(LEG_RIGHT)
			. = "r_leg"
		if(LEG_LEFT)
			. = "l_leg"

//Helper for quickly creating a new limb - used by augment code in species.dm spec_attacked_by
/proc/newBodyPart(var/type)
	var/_path = text2path("/obj/item/organ/limb/[type]")
	if(!_path||!ispath(_path))
		return

	var/obj/item/L = new _path
	return L

//Mob has their active hand
/mob/proc/has_active_hand()
	return 1

/mob/living/carbon/human/has_active_hand()
	var/obj/item/organ/limb/L
	if(hand)
		L = get_organ("l_arm")
	else
		L = get_organ("r_arm")
	if(!L)
		return 0
	return 1