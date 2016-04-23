/datum/surgery_step/replace
	name = "sever muscules"
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/wirecutters = 55)
	time = 32


/datum/surgery_step/replace/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/state = 0
	var/obj/item/organ/limb/L = surgery.organ
	if(istype(L))
		state = !(L.state_flags & ORGAN_AUGMENTABLE)
	user.visible_message("[user] begins to [state ? "sever" : "mend"] the muscles on [target]'s [parse_zone(user.zone_sel.selecting)].", "<span class ='notice'>You begin to [state ? "sever" : "mend"] the muscles on [target]'s [parse_zone(user.zone_sel.selecting)]...</span>")

/datum/surgery_step/replace/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/limb/L = surgery.organ
	if(istype(L))
		L.state_flags = (L.state_flags & ORGAN_AUGMENTABLE) ? ORGAN_FINE : ORGAN_AUGMENTABLE
	user.visible_message("[user] succeeds!", "<span class='notice'>You [(L.state_flags & ORGAN_AUGMENTABLE) ? "sever" : "mend"] the muscle on [target]'s [parse_zone(user.zone_sel.selecting)].</span>")
	return 1

/datum/surgery/limb_manipulation
	name = "limb manipulation"
	steps = list(/datum/surgery_step/replace)
	species = list(/mob/living/carbon/human)
	possible_locs = list("r_arm","l_arm","r_leg","l_leg","chest","head")