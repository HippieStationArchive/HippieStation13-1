//Dismember a limb
/obj/item/organ/limb/proc/dismember()
	state_flags = ORGAN_AUGMENTABLE
	drop_limb()
	var/direction = pick(cardinal)
	step(src,direction)

	if(owner)
		owner.apply_damage(30, BRUTE, "chest") //Chest houses most of the limbs, sooo..
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/obj/item/organ/limb/affecting = H.get_organ("chest")
			affecting.take_damage(0,0,1) //Your arm's off, ofcourse you're gonna bleed!
		owner.visible_message("<span class='danger'><B>[owner]'s [src] has been violently dismembered!</B></span>")
		owner.drop_r_hand()
		owner.drop_l_hand()
		owner.update_canmove()
		owner.regenerate_icons()
		owner.emote("scream")
		playsound(get_turf(owner), pick('sound/misc/splat.ogg', 'sound/misc/splort.ogg'), 80, 1)

/obj/item/organ/limb/head/dismember()
	state_flags = ORGAN_AUGMENTABLE
	if(!owner)
		return
	owner.visible_message("<span class='danger'><B>[owner] doesn't look too good...</B></span>")
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

//Attach a limb (the limb still keeps all the flags and stuff, so it's probably unusable unless you do surgery to fix up augment wounds)
/mob/living/carbon/human/proc/attachLimb(var/obj/item/organ/limb/L, var/mob/user)
	if(locate(L.type) in organs)
		return

	user.drop_item()
	L.loc = src
	organs += L

	var/who = "[src]'s"
	if(user == src)
		who = "their"

	visible_message("<span class='notice'>[user] has attatched [who] new limb!</span>")
	update_canmove()

//Limb numbers
/mob/living/carbon/human/proc/get_num_arms(var/usable=0)
	. = 0
	for(var/obj/item/organ/limb/affecting in organs)
		var/pass = usable ? !(affecting.state_flags & ORGAN_AUGMENTABLE) : 1
		var/part = affecting.body_part
		if(part == ARM_RIGHT && pass)
			.++
		if(part == ARM_LEFT && pass)
			.++

/mob/living/carbon/human/proc/get_num_legs(var/usable=0)
	. = 0
	for(var/obj/item/organ/limb/affecting in organs)
		var/pass = usable ? !(affecting.state_flags & ORGAN_AUGMENTABLE) : 1
		var/part = affecting.body_part
		if(part == LEG_RIGHT && pass)
			.++
		if(part == LEG_LEFT && pass)
			.++

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


//Drop dummy limb
/obj/item/organ/limb/proc/drop_limb()
	if(!owner)
		return
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		update_limb(H)
		H.organs -= src

	bloodloss = 0

	var/turf/T = get_turf(owner)
	src.loc = T

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