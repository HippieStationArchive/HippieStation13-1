/* Contains:
 * Blood-related atom procs
 */

var/list/blood_splatter_icons = list()

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

//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/M)
	if(ishuman(M) && M.dna)
		var/mob/living/carbon/human/H = M
		if(NOBLOOD in H.dna.species.specflags)
			return 0
	if(rejects_blood())
		return 0
	if(!istype(M))
		return 0
	if(!check_dna_integrity(M))		//check dna is valid and create/setup if necessary
		return 0					//no dna!
	return

// /atom/proc/add_blood_from_DNA(given_DNA) //A DNA variant for convenience. We only save blood DNA on decals and stuff, and with implementation of footprints we need to inherit that somehow.
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

/obj/add_blood(mob/living/carbon/M)
	if(..() == 0)   return 0
	return add_blood_list(M)

/obj/item/add_blood(mob/living/carbon/M)
	var/blood_count = blood_DNA == null ? 0 : blood_DNA.len
	if(..() == 0)	return 0
	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_count && initial(icon) && initial(icon_state))
		//try to find a pre-processed blood-splatter. otherwise, make a new one
		var/index = blood_splatter_index()
		var/icon/blood_splatter_icon = blood_splatter_icons[index]
		if(!blood_splatter_icon)
			blood_splatter_icon = icon(initial(icon), initial(icon_state), , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
			blood_splatter_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
			blood_splatter_icon.Blend(icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
			blood_splatter_icon = fcopy_rsc(blood_splatter_icon)
			blood_splatter_icons[index] = blood_splatter_icon
		overlays += blood_splatter_icon
	return 1 //we applied blood to the item

/obj/item/clothing/gloves/add_blood(mob/living/carbon/M)
	if(..() == 0) return 0
	transfer_blood = rand(2, 4)
	bloody_hands_mob = M
	return 1

/turf/simulated/add_blood(mob/living/carbon/M)
	if(..() == 0)	return 0

	var/obj/effect/decal/cleanable/blood/B = locate() in contents	//check for existing blood splatter
	if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
		B = new /obj/effect/decal/cleanable/blood(src)			//make a bloood splatter if we couldn't find one
	B.add_blood_list(M)
	B.blood_source = M
	return 1 //we bloodied the floor

/mob/living/carbon/human/add_blood(mob/living/carbon/M)
	if(..() == 0)	return 0
	add_blood_list(M)
	bloody_hands = rand(2, 4)
	bloody_hands_mob = M
	update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle //Add bloody handwriting capabilities.
	return 1 //we applied blood to the person's hands

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

// Only adds blood on the floor -- Skie
/atom/proc/add_blood_floor(mob/living/carbon/M as mob, var/splatter = 0)
	if(istype(src, /turf/simulated))
		if(check_dna_integrity(M))	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/blood/B = locate() in contents
			if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
				if(!splatter)
					B = new(src)
				else
					B = new /obj/effect/decal/cleanable/blood/splatter(src)
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
			B.blood_source = M
			return B
		else if(istype(M, /mob/living/carbon/alien))
			var/obj/effect/decal/cleanable/xenoblood/B = locate() in contents
			if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
				if(!splatter)
					B = new(src)
				else
					B = new /obj/effect/decal/cleanable/xenoblood/xsplatter(src)
			B.blood_DNA["UNKNOWN BLOOD"] = "X*"
			return B
		else if(istype(M, /mob/living/silicon/robot))
			var/obj/effect/decal/cleanable/oil/B = locate() in contents
			if(!B || istype(B, /obj/effect/decal/cleanable/blood/trail_holder) || istype(B, /obj/effect/decal/cleanable/blood/trackss))
				if(!splatter)
					B = new(src)
				else
					B = new /obj/effect/decal/cleanable/oil/streak(src)
			return B

/atom/proc/add_blood_drip(mob/living/carbon/M as mob)
	if(!istype(M)) return
	if(istype(src, /turf/simulated))
		if(check_dna_integrity(M))	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/drip/B = new /obj/effect/decal/cleanable/drip(src)
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
			B.blood_source = M
		// else if(istype(M, /mob/living/carbon/alien))
		// else if(istype(M, /mob/living/silicon/robot))

/atom/proc/clean_blood()
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1