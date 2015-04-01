/datum/surgery/embedded_removal
	name = "removal of embedded objects"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/remove_object, /datum/surgery_step/close) //Simple and similar to bullet removal.
	species = list(/mob/living/carbon/human)
	location = "anywhere"
	has_multi_loc = 1


/datum/surgery_step/remove_object
	time = 32
	allowed_organs = list("r_arm","l_arm","r_leg","l_leg","chest","head")
	accept_hand = 1
	var/obj/item/organ/limb/L = null


/datum/surgery_step/remove_object/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	L = new_organ
	if(L)
		user.visible_message("<span class='notice'>[user] looks for objects embedded in [target]'s [parse_zone(user.zone_sel.selecting)].</span>")
	else
		user.visible_message("<span class='notice'>[user] looks for [target]'s [parse_zone(user.zone_sel.selecting)].</span>")


/datum/surgery_step/remove_object/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(L)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/objects = 0
			for(var/obj/item/I in L.embedded)
				objects++
				I.loc = get_turf(H)
				if(I.pinned) //You REALLY won't be able to perform surgery on a pinned down dude, since he's standing up, but just a precaution...
					H.do_pindown(H.pinned_to, 0)
					H.pinned_to = null
					H.anchored = 0
					H.update_canmove()
					I.pinned = null
				if(istype(I, /obj/item/weapon/paper))
					var/obj/item/weapon/paper/P = I
					P.attached = null
					I.update_icon()
				L.embedded -= I
				H.update_damage_overlays()

			if(objects > 0)
				user.visible_message("<span class='notice'>[user] sucessfully removes [objects] objects from [H]'s [L.getDisplayName()]!</span>")
			else
				user.visible_message("<span class='notice'>[user] finds no objects embedded in [H]'s [L.getDisplayName()].</span>")

	else
		user.visible_message("<span class='notice'>[user] can't find [target]'s [parse_zone(user.zone_sel.selecting)], let alone any objects embedded in it!</span>")

	return 1