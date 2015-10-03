/*
 * Contains:
 * Variable defintions moved from detectivework module
 * Blood-related procs for atoms, items, turfs, etc.
 */
var/list/blood_splatter_icons = list()

/atom
	var/list/blood_DNA
	var/blood_color

/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0

	var/list/feet_blood_DNA
	var/feet_blood_color

	var/list/hand_blood_DNA = list()
	var/hand_blood_color

/obj/item
	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes
	var/track_blood = 0
	var/track_blood_color
	var/mob/living/carbon/human/bloody_tracks_mob

/*
 * Atoms
 */

/atom/proc/blood_splatter_index()
	return "\ref[initial(icon)]-[initial(icon_state)]"

/atom/proc/add_blood_list(mob/living/carbon/M)
	// Returns 1 if we had blood already
	if(!istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()
	//if this blood isn't already in the list, add it
	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
	return 1

// //returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/M as mob)
	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	blood_color = "#A10808"
	if(rejects_blood())
		return 0
	if(!istype(M))
		return 0
	if(!check_dna_integrity(M))		//check dna is valid and create/setup if necessary
		return 0					//no dna!
	if(M.dna)
		blood_color = M.dna.species.blood_color
		if(NOBLOOD in M.dna.species.specflags)
			return 0
	return 1

// OLD VERSION
// /atom/proc/add_blood(mob/living/carbon/M)
// 	if(ishuman(M) && M.dna)
// 		var/mob/living/carbon/human/H = M
// 		if(NOBLOOD in H.dna.species.specflags)
// 			return 0
// 	if(rejects_blood())
// 		return 0
// 	if(!istype(M))
// 		return 0
// 	if(!check_dna_integrity(M))		//check dna is valid and create/setup if necessary
// 		return 0					//no dna!
// 	return

/atom/proc/rejects_blood()
	return 0

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

		/*for(var/datum/disease/D in M.viruses)
			var/datum/disease/newDisease = D.Copy(1)
			this.viruses += newDisease
			newDisease.holder = this*/

/atom/proc/add_blood_drip(mob/living/carbon/M as mob)
	if(!istype(M)) return
	if(istype(src, /turf/simulated))
		if(check_dna_integrity(M))	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/blood/drip/B = new(src, M.dna.species.blood_color)
			if(istype(B))
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
				// B.update_icon()
			// B.blood_source = M
		// else if(istype(M, /mob/living/carbon/alien))
		// else if(istype(M, /mob/living/silicon/robot))

/atom/proc/clean_blood()
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1

/*
 * Turfs
 */

/turf/simulated/add_blood(mob/living/carbon/M)
	if (!..())
		return 0
	var/found_color
	if(M.dna && M.dna.species.blood_color)
		found_color = M.dna.species.blood_color
	var/obj/effect/decal/cleanable/blood/B = locate() in contents	//check for existing blood splatter
	if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
		B = new /obj/effect/decal/cleanable/blood(src, found_color)			//make a bloood splatter if we couldn't find one
	B.add_blood_list(M)
	// B.basecolor = found_color
	// B.update_icon()
	// B.blood_source = M
	return 1 //we bloodied the floor

// Only adds blood on the floor -- Skie
/atom/proc/add_blood_floor(mob/living/carbon/M as mob, var/splatter = 0)
	if(istype(src, /turf/simulated))
		if(check_dna_integrity(M))	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/blood/B = locate() in contents
			if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
				if(!splatter)
					B = new(src, M.dna.species.blood_color)
				else
					B = new /obj/effect/decal/cleanable/blood/splatter(src, M.dna.species.blood_color)
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
			// B.basecolor = M.dna.species.blood_color
			// B.update_icon()
			return B
		else if(istype(M, /mob/living/carbon/alien))
			var/obj/effect/decal/cleanable/blood/xeno/B = locate() in contents
			if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
				if(!splatter)
					B = new(src)
				else
					B = new /obj/effect/decal/cleanable/blood/xeno(src)
			B.blood_DNA["UNKNOWN BLOOD"] = "X*"
			// B.update_icon()
			return B
		else if(istype(M, /mob/living/silicon/robot))
			var/obj/effect/decal/cleanable/blood/oil/B = locate() in contents
			if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
				if(!splatter)
					B = new(src)
				else
					B = new /obj/effect/decal/cleanable/blood/oil/streak(src)
			// B.update_icon()
			return B

/*
 * Items
 */

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		overlays.Remove(blood_overlay)
	if(istype(src, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = src
		G.transfer_blood = 0

// /obj/item/clothing/gloves/clean_blood() //Redundant. See above.
// 	. = ..()
// 	if(.)
// 		transfer_blood = 0
// 		bloody_hands_mob = null

/obj/item/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(src, /obj/item/weapon/melee/energy))
		return

	//if we haven't made our blood_overlay already
	if( !blood_overlay )
		generate_blood_overlay()

	//apply the blood-splatter overlay if it's not the same blood.
	if(blood_overlay && blood_overlay.color != blood_color)
		blood_overlay.color = blood_color
		overlays.Cut() //This will ruin custom overlays...
		update_icon() //So this is why you have your overlays made in update_icon
		overlays += blood_overlay

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA[M.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
	return 1 //we applied blood to the item

/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparent
	//not sure if this is worth it. It attaches the blood_overlay to every item of the same type if they don't have one already made.
	for(var/obj/item/A in world)
		if(A.type == type && !A.blood_overlay)
			A.blood_overlay = image(I)

/obj/item/clothing/gloves/add_blood(mob/living/carbon/M)
	if(..() == 0) return 0
	transfer_blood = rand(2, 4)
	bloody_hands_mob = M
	return 1

//Fuck this overlay code. It broke me when I tried to repurpose it for deepfry overlays. ~Crystalwarrior

// /obj/item/add_blood(mob/living/carbon/M)
// 	var/blood_count = blood_DNA == null ? 0 : blood_DNA.len
// 	if(..() == 0)	return 0
// 	//apply the blood-splatter overlay if it isn't already in there
// 	if(!blood_count && initial(icon) && initial(icon_state))
// 		//try to find a pre-processed blood-splatter. otherwise, make a new one
// 		var/index = blood_splatter_index()
// 		var/icon/blood_splatter_icon = blood_splatter_icons[index]
// 		if(!blood_splatter_icon)
// 			blood_splatter_icon = icon(initial(icon), initial(icon_state), , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
// 			blood_splatter_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
// 			blood_splatter_icon.Blend(icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
// 			blood_splatter_icon = fcopy_rsc(blood_splatter_icon)
// 			blood_splatter_icons[index] = blood_splatter_icon
// 		overlays += blood_splatter_icon
// 	return 1 //we applied blood to the item

/*
 * Other
 */

/obj/add_blood(mob/living/carbon/M)
	if (!..())
		return 0
	return add_blood_list(M)

/mob/living/carbon/human/add_blood(mob/living/carbon/M)
	if (!..())
		return 0
	if(!add_blood_list(M))
		return 0
	bloody_hands = rand(2, 4)
	bloody_hands_mob = M
	hand_blood_color = blood_color
	update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle //Add bloody handwriting capabilities.
	return 1 //we applied blood to the person's hands

/mob/living/carbon/human/clean_blood(var/clean_feet)
	..() // Clear the Blood_DNA list
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(clean_feet)
			if(shoes)
				if(H.shoes.clean_blood())
					var/obj/item/clothing/shoes/S = shoes
					S.track_blood = 0 //No footprints
					// S.blood_DNA = null
					H.update_inv_shoes(0)
			else
				feet_blood_color = null
				del(feet_blood_DNA)
				H.update_inv_shoes(0)
			return
		if(H.gloves)
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)
		else
			if(H.bloody_hands)
				H.bloody_hands = 0
				H.bloody_hands_mob = null
				H.update_inv_gloves(0)
	update_icons()	//apply the now updated overlays to the mob

/mob/living/carbon/proc/wash() //Fully wash the human
	if(src.r_hand)
		src.r_hand.clean_blood()
	if(src.l_hand)
		src.l_hand.clean_blood()
	if(src.back)
		if(src.back.clean_blood())
			src.update_inv_back(0)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/washgloves = 1
		var/washshoes = 1
		var/washmask = 1
		var/washears = 1
		var/washglasses = 1

		H.track_blood = 0 //No footprints for bare feet
		if(H.wear_suit)
			washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
			washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

		if(H.head)
			washmask = !(H.head.flags_inv & HIDEMASK)
			washglasses = !(H.head.flags_inv & HIDEEYES)
			washears = !(H.head.flags_inv & HIDEEARS)

		if(H.wear_mask)
			if (washears)
				washears = !(H.wear_mask.flags_inv & HIDEEARS)
			if (washglasses)
				washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
		if(washgloves)
			H.clean_blood()//We call this proc on human because clean_blood will automatically clean either gloves or hands.
			H.update_inv_gloves(0)
		if(washshoes)
			H.clean_blood(1) //The number is a bool to clean shoes/feet.
			H.update_inv_shoes(0)

		if(washmask)
			if(H.wear_mask && H.wear_mask.clean_blood())
				H.update_inv_wear_mask(0)
			if(H.spraypaint)
				H.spraypaint = null
				H.update_body()
		if(H.glasses && washglasses)
			if(H.glasses.clean_blood())
				H.update_inv_glasses(0)
		if(H.ears && washears)
			if(H.ears.clean_blood())
				H.update_inv_ears(0)
		if(H.belt)
			if(H.belt.clean_blood())
				H.update_inv_belt(0)
	else
		if(src.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
			if(src.wear_mask.clean_blood())
				src.update_inv_wear_mask(0)