//Change organ status
/obj/item/organ/limb/proc/change_organ(var/type, var/noheal=0)
	status = type
	state_flags = ORGAN_FINE
	if(!noheal)
		burn_dam = 0
		brute_dam = 0
		brutestate = 0
		burnstate = 0
	update_organ_icon()
	if(owner)
		owner.updatehealth()
		owner.regenerate_icons()


//Drop the limb
/obj/item/organ/limb/proc/drop_limb(var/special=0)
	var/turf/T = get_turf(src.loc)
	var/mob/living/carbon/human/H 
	if(owner && ishuman(owner))
		T = get_turf(owner)
		H = owner
		if(!updated)
			update_limb(H)
		H.organs -= src
		owner = null

	brute_dam = brute_dam / 3
	burn_dam = burn_dam / 3
	bloodloss = 0

	for(var/obj/item/I in embedded_objects)
		embedded_objects -= I
		I.loc = T
	if(H && !H.has_embedded_objects())
		H.clear_alert("embeddedobject")
	src.loc = T

//Augment a limb
/obj/item/organ/limb/proc/augment(var/obj/item/I, var/def_zone, var/mob/user)
	if(!(state_flags & ORGAN_AUGMENTABLE))
		return

	if(!owner || !def_zone)
		return

	var/who = "[owner]'s"
	if(user == owner)
		who = "their"

	owner.visible_message("<span class='notice'>[user] has attatched [who] new limb!</span>")
	var/mob/living/carbon/C = owner //We do this because owner might be null-ed during drop_limb
	change_organ(ORGAN_ROBOTIC)
	user.drop_item()
	qdel(I)
	C.update_canmove()

//Dismember a limb
/obj/item/organ/limb/proc/dismember()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.dna.species:has_dismemberment) //human's species don't allow dismemberment
		return 0

	state_flags = ORGAN_AUGMENTABLE
	var/brutedam = brute_dam //brute damage before we drop the limb
	drop_limb()
	var/direction = pick(cardinal)
	var/turf/target = get_turf(H.loc)
	var/range = rand(2,max(throw_range/2, 2))
	spawn()
		for(var/i = 1; i < range; i++)
			var/turf/new_turf = get_step(target, direction)
			target = new_turf
			if(new_turf.density)
				break
		throw_at(target,throw_range,throw_speed)
	if(istype(H))
		var/obj/item/organ/limb/affecting = H.get_organ("chest")
		affecting.take_damage(Clamp(brutedam/2, 15, 50),0,1) //Damage the chest based on limb's existing damage (note that you get -10 max health per every missing limb anyway)
		H.visible_message("<span class='danger'><B>[H]'s [src] has been violently dismembered!</B></span>")
		H.drop_r_hand()
		H.drop_l_hand()
		H.update_canmove()
		H.regenerate_icons()
		H.emote("scream")
	return 1

/obj/item/organ/limb/head/drop_limb(var/special=0)
	if(special)
		return //Head doesn't drop :v
	var/mob/living/carbon/human/H = owner
	..()
	if(istype(H))
		//Drop all worn head items
		for(var/obj/item/I in list(H.glasses, H.ears, H.wear_mask, H.head))
			if(!H.unEquip(I))
				qdel(I)

		//Brain fuckery
		var/obj/item/organ/internal/brain/B = H.getorgan(/obj/item/organ/internal/brain)
		B.Remove(H)

		brainmob = B.brainmob
		B.brainmob = null
		brainmob.loc = src
		brainmob.container = src
		brainmob.stat = DEAD

		B.loc = src //P-put your brain in it
		brain = B

		name = "[H]'s head"
		update_icon()
		//Brain fuckery END

/obj/item/organ/limb/chest/dismember()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.dna.species:has_dismemberment) //human's species don't allow dismemberment
		return 0
	state_flags = ORGAN_AUGMENTABLE
	update_organ_icon()
	if(!owner)
		return 0
	owner.visible_message("<span class='danger'><B>[owner]'s internal organs spill out onto the floor!</B></span>")
	for(var/obj/item/organ/internal/O in owner.internal_organs)
		if(O.zone == "head")
			continue
		O.Remove(owner)
		O.loc = get_turf(owner)
		playsound(get_turf(owner), pick('sound/misc/splat.ogg', 'sound/misc/splort.ogg'), 80, 1)
	H.regenerate_icons()

/obj/item/organ/limb/chest/drop_limb(var/special=0)
	return

/obj/item/organ/limb/r_arm/drop_limb(var/special=0)
	if(owner && !special)
		if(owner.handcuffed)
			owner.handcuffed.loc = get_turf(owner)
			owner.handcuffed = null
			owner.update_inv_handcuffed(0)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.unEquip(H.gloves)
	..()

/obj/item/organ/limb/l_arm/drop_limb(var/special=0)
	if(owner && !special)
		if(owner.handcuffed)
			owner.handcuffed.loc = get_turf(owner)
			owner.handcuffed = null
			owner.update_inv_handcuffed(0)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.unEquip(H.gloves)
	..()

/obj/item/organ/limb/r_leg/drop_limb(var/special=0)
	if(owner && !special)
		owner.Weaken(2)
		if(owner.legcuffed)
			owner.legcuffed.loc = get_turf(owner)
			owner.legcuffed = null
			owner.update_inv_legcuffed(0)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.unEquip(H.shoes)
	..()

/obj/item/organ/limb/l_leg/drop_limb(var/special=0)
	if(owner && !special)
		owner.Weaken(2)
		if(owner.legcuffed)
			owner.legcuffed.loc = get_turf(owner)
			owner.legcuffed = null
			owner.update_inv_legcuffed(0)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.unEquip(H.shoes)
	..()

//Attach a limb (the limb still keeps all the flags and stuff, so it's probably unusable unless you do surgery to fix up augment wounds)
/mob/living/carbon/human/proc/attachLimb(var/obj/item/organ/limb/L, var/mob/user)
	var/obj/item/organ/limb/O = locate(L.type) in organs
	if(istype(O, /obj/item/organ/limb/head)) //If you want to perform head switcharoo you must decapitate them and transfer brains.
		user << "<span class='warning'>You cannot attach [L] to [src]!</span>"
		return
	if(istype(O))
		O.drop_limb(1)

	user.drop_item()
	L.loc = src
	L.owner = src
	organs += L
	L.update_organ_icon()
	if(istype(L, /obj/item/organ/limb/head)) //Transfer some head appearance vars over
		var/obj/item/organ/limb/head/U = L
		var/obj/item/organ/internal/brain/B = U.brain
		if(istype(B)) //Brain exists, do brain fuckery
			U.brainmob.container = null //Reset brainmob head var.
			U.brainmob.loc = U.brain //Throw mob into brain.
			U.brain.brainmob = U.brainmob //Set the brain to use the brainmob
			U.brainmob = null //Set head brainmob var to null
			U.brain = null //No more brain in here
			B.Insert(src) //Now insert the brain proper

		hair_color = U.hair_color
		hair_style = U.hair_style
		facial_hair_color = U.facial_hair_color
		facial_hair_style = U.facial_hair_style
		eye_color = U.eye_color
		lip_style = U.lip_style
		lip_color = U.lip_color
		if(U.real_name)
			real_name = U.real_name
		U.real_name = ""
		U.name = initial(U.name)

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
/mob/proc/has_active_hand(var/usable=0)
	return 1

/mob/living/carbon/human/has_active_hand(var/usable=0)
	var/obj/item/organ/limb/L
	if(hand)
		L = get_organ("l_arm")
	else
		L = get_organ("r_arm")
	if(!L || (usable && L.state_flags & ORGAN_AUGMENTABLE))
		return 0
	return 1

/mob/living/carbon/human/proc/has_left_hand(var/usable=0)
	var/obj/item/organ/limb/L
	L = get_organ("l_arm")
	if(!L || (usable && L.state_flags & ORGAN_AUGMENTABLE))
		return 0
	return 1
/mob/living/carbon/human/proc/has_right_hand(var/usable=0)
	var/obj/item/organ/limb/L
	L = get_organ("r_arm")
	if(!L || (usable && L.state_flags & ORGAN_AUGMENTABLE))
		return 0
	return 1