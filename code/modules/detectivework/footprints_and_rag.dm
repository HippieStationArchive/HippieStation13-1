
/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob


/obj/item/weapon/reagent_containers/glass/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose. Also smothering."
	w_class = 1
	icon = 'icons/obj/weapons.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 5)
	volume = 20
	spillable = 0
	var/smothering = 0

/obj/item/weapon/reagent_containers/glass/rag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] ties the [src.name] around their head and groans! It looks like--</span>")
	user.say("MY BRAIN HURTS!!")
	return (OXYLOSS)

/obj/item/weapon/reagent_containers/glass/rag/afterattack(atom/A, mob/user as mob, proximity, click_parameters)
	if(!proximity) return
	// if(istype(A, /obj/item/weapon/canvas) && user.a_intent != "harm") return //Rag can only be used to wipe tiny pixels away unless you have aggressive intent.
	if(iscarbon(A) && reagents && reagents.total_volume && (user.zone_sel.selecting == "mouth" || user.zone_sel.selecting == "head"))
		var/mob/living/carbon/C = A
		if(user.get_inactive_hand() == null || istype(user.get_inactive_hand(), /obj/item/weapon/grab))
			var/mob/living/carbon/human/H = C
			if(H && H.is_mouth_covered())
				user << "<span class='warning'>Remove [ H == user ? "your" : "their" ] mask!</span>"
				return
			if(user == C)
				reagents.reaction(C, INGEST)
				reagents.trans_to(C, amount_per_transfer_from_this)
				user << "<span class='notice'>You smother yourself with the damp rag.</span>"
			else
				if(smothering)
					user << "<span class='notice'>You're already smothering someone!</span>"
					return
				if(user.a_intent == "grab")
					// if(!(C.status_flags & CANPUSH))
					// 	return
					add_logs(user, C, "smothered")
					if(!istype(user.get_inactive_hand(), /obj/item/weapon/grab))
						var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(user, C)
						// if(C.buckled)
						// 	user << "<span class='notice'>You cannot grab [C], \he is buckled in!</span>"
						if(!G)	//the grab will delete itself in New if C is anchored
							return 0
						user.put_in_inactive_hand(G) //Autograb. The trick is to switch to grab intend and reinforce it for quick aggro grab.
						// G.state = GRAB_AGGRESSIVE
						C.LAssailant = user
						playsound(C.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -4)
						user.visible_message(
							"<span class='danger'>[user] has grabbed and smothered \the [C] with \the [src]!</span>",\
							"<span class='danger'>You grab and smother \the [C] with \the [src]!</span>",\
							"You hear some struggling and muffled cries of surprise")
					else
						playsound(C.loc, 'sound/weapons/thudswoosh.ogg', 20, 1, -4)
						user.visible_message(
							"<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>",\
							"<span class='danger'>You smother \the [C] with \the [src]!</span>",\
							"You hear some struggling and muffled cries of surprise")
					icon_state = "rag_smother"
					smothering = 1
					SSobj.processing.Add(src)
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

/obj/item/weapon/reagent_containers/glass/rag/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/weapon/reagent_containers/glass/rag/process()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		if(src != C.r_hand && src != C.l_hand) //THE DAMP RAG IS NOT IN HANDS, ABORT! (fixes an issue where you could smother people with damp rag in your pocket)
			smothering = 0
			SSobj.processing.Remove(src)
			icon_state = initial(icon_state)
			return
		var/obj/item/weapon/grab/G = C.l_hand
		if(!istype(G))
			G = C.r_hand
			if(!istype(G))
				smothering = 0
				SSobj.processing.Remove(src)
				icon_state = initial(icon_state)
				return
		if(!G.affecting)
			smothering = 0
			SSobj.processing.Remove(src)
			icon_state = initial(icon_state)
			return
		if(ishuman(G.affecting))
			var/mob/living/carbon/human/H = G.affecting
			if(H.is_mouth_covered())
				smothering = 0
				SSobj.processing.Remove(src)
				icon_state = initial(icon_state)
				return
			H.forcesay(list("-mppf!", "-hrgh!", "-mph!", "-pfhh!", "-mmf!"))
		if(reagents && reagents.total_volume)	//	check if it has any reagents at all
			handle_reagents(G.affecting)
	else
		smothering = 0
		SSobj.processing.Remove(src)
		icon_state = initial(icon_state)