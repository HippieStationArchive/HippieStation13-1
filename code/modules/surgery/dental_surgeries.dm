/datum/surgery/teeth_reinsertion
	name = "teeth reinsertion"
	steps = list(/datum/surgery_step/handle_teeth)
	possible_locs = list("mouth")

//handle cavity
/datum/surgery_step/handle_teeth
	accept_hand = 1
	accept_any_item = 1
	time = 64

/datum/surgery_step/handle_teeth/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/organ/teeth/T, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(istype(T))
		if(O.teeth && O.teeth.amount >= O.teeth.max_amount)
			user << "<span class='notice'>All of [target]'s teeth are intact."
			return -1
		user.visible_message("<span class='notice'>[user] begins to insert [T] into [target]'s [target_zone].</span>")
	else
		user.visible_message("<span class='notice'>[user] checks for teeth in [target]'s [target_zone].</span>")

/datum/surgery_step/handle_teeth/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/organ/teeth/T, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(T)
		if(O.teeth) //Has teeth, check if they need "refilling"
			if(O.teeth.amount >= O.teeth.max_amount)
				user.visible_message("<span class='notice'>[user] can't seem to fit [T] in [target]'s [target_zone].</span>", "<span class='notice'>All of [target]'s teeth are intact.</span>")
				return 0
			var/amt = T.merge(O.teeth) //Try to merge provided teeth into person's teeth.
			user.visible_message("<span class='notice'>[user] inserts [amt] [T] into [target]'s [target_zone]!</span>")
			return 1
		else //No teeth to speak of.
			user.visible_message("<span class='notice'>[user] inserts all [T] into [target]'s [target_zone]!</span>")
			user.drop_item()
			O.teeth += T
			T.loc = target
			return 1
	else
		if(O.teeth)
			user.visible_message("<span class='notice'>[user] pulls all [O.teeth] out of [target]'s [target_zone]!</span>")
			user.put_in_hands(O.teeth)
			O.teeth = null
			return 1
		else
			user.visible_message("<span class='notice'>[user] doesn't find anything in [target]'s [target_zone].</span>")
			return 0

//DENTAL IMPLANTS
/datum/surgery/dental_implant
	name = "dental implant"
	steps = list(/datum/surgery_step/drill, /datum/surgery_step/insert_pill)
	possible_locs = list("mouth")

/datum/surgery_step/insert_pill
	name = "insert pill"
	implements = list(/obj/item/weapon/reagent_containers/pill = 100)
	time = 16

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/pill, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(!O.teeth)
		user.visible_message("<span class='notice'>[target] has no teeth to speak of!</span>")
		return -1
	if(O.teeth.implants.len >= O.teeth.amount / 4) //8 max pills seems reasonable enough.
		user.visible_message("<span class='notice'>There's no room for more implants in [target]'s teeth!</span>")
		return -1
	user.visible_message("[user] begins to wedge [pill] in [target]'s [parse_zone(target_zone)].", "<span class='notice'>You begin to wedge [pill] in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/human/target, target_zone, var/obj/item/weapon/reagent_containers/pill/pill, datum/surgery/surgery)
	if(!istype(pill))
		return 0
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(!O.teeth)
		user.visible_message("<span class='notice'>[target] has no teeth to speak of!</span>")
		return -1
	if(O.teeth.implants.len >= O.teeth.amount / 4) //8 max pills seems reasonable enough.
		user.visible_message("<span class='notice'>There's no room for more implants in [target]'s teeth!</span>")
		return -1

	user.drop_item()
	O.teeth.implants += pill
	pill.loc = target

	var/datum/action/item_action/hands_free/activate_pill/P = new
	P.button_icon_state = pill.icon_state
	P.target = pill
	P.Grant(target)

	user.visible_message("[user] wedges [pill] into [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You wedge [pill] into [target]'s [parse_zone(target_zone)].</span>")
	return 1

/datum/action/item_action/hands_free/activate_pill
	name = "activate pill"

/datum/action/item_action/hands_free/activate_pill/Trigger()
	if(CheckRemoval(owner))
		return 0
	owner << "<span class='caution'>You grit your teeth and burst the implanted [target]!</span>"
	if(target.reagents.total_volume)
		target.reagents.reaction(owner, INGEST)
		target.reagents.trans_to(owner, target.reagents.total_volume)
	qdel(target)
	return 1