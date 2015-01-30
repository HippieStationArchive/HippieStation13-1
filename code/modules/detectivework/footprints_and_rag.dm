
/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob



/proc/blood_incompatible(donor,receiver)

	var/donor_antigen = copytext(donor,1,lentext(donor))
	var/receiver_antigen = copytext(receiver,1,lentext(receiver))
	var/donor_rh = findtext("+",donor)
	var/receiver_rh = findtext("+",receiver)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0


/obj/item/weapon/reagent_containers/glass/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 20
	can_be_placed_into = null
	// var/smothered_mob = null //Used for process()

/obj/item/weapon/reagent_containers/glass/rag/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	var/mob/living/carbon/C = A
	if(ismob(C) && reagents && reagents.total_volume && (user.zone_sel.selecting == "mouth" || user.zone_sel.selecting == "head"))
		if(user.get_inactive_hand() == null || istype(user.get_inactive_hand(), /obj/item/weapon/grab))
			if(user == C)
				reagents.reaction(C, INGEST)
				reagents.trans_to(C, amount_per_transfer_from_this)
				user << "<span class='notice'>You smother yourself with the damp rag.</span>"
			else
				if(user.a_intent == "grab")
					// if(!(C.status_flags & CANPUSH))
					// 	return

					add_logs(user, C, "smothered")
					if(!istype(user.get_inactive_hand(), /obj/item/weapon/grab))
						var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(user, C)
						if(C.buckled)
							user << "<span class='notice'>You cannot grab [C], \he is buckled in!</span>"
						if(!G)	//the grab will delete itself in New if C is anchored
							return 0
						user.put_in_inactive_hand(G) //Autograb. The trick is to switch to grab intend ant reinforce it for quick aggro grab.
						// G.state = GRAB_AGGRESSIVE
						// icon_state = "reinforce"
						C.LAssailant = user
						playsound(C.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						user.visible_message("<span class='danger'>[user] has grabbed and smothered \the [C] with \the [src]!</span>", "<span class='danger'>You grab and smother \the [C] with \the [src]!</span>", "You hear some struggling and muffled cries of surprise")
					else
						playsound(C.loc, 'sound/weapons/thudswoosh.ogg', 20, 1, -1)
						user.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='danger'>You smother \the [C] with \the [src]!</span>", "You hear some struggling and muffled cries of surprise")
					handle_reagents(C)
				else
					user << "<span class='notice'>You need to be on grab intent to smother someone!</span>"
		return
	else
		if(istype(A) && src in user)
			user.visible_message("[user] starts to wipe down [A] with [src]!")
			if(do_after(user,30))
				user.visible_message("[user] finishes wiping off the [A]!")
				//Shameless copy pasta from mop code
				if(reagents.has_reagent("water", 1) || reagents.has_reagent("holywater", 1))
					A.clean_blood()
					for(var/obj/effect/O in A)
						if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
							qdel(O)
				reagents.reaction(A)
				reagents.remove_any(amount_per_transfer_from_this)

/obj/item/weapon/reagent_containers/glass/rag/proc/handle_reagents(mob/living/carbon/C)
	if(iscarbon(C))
		reagents.reaction(C, INGEST)
		reagents.trans_to(C, 2)
		return
	reagents.remove_any(2)

// /obj/item/weapon/reagent_containers/glass/rag/process() //WHY DOESN'T THIS WORK
// 	if(iscarbon(loc))
// 		var/mob/living/carbon/C = loc
// 		var/obj/item/weapon/grab/G = C.l_hand
// 		if(!istype(G))
// 			G = C.r_hand
// 			if(!istype(G))
// 				return
// 	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
// 		handle_reagents()