/datum/surgery/teeth_reinsertion
	name = "teeth reinsertion"
	steps = list(/datum/surgery_step/handle_teeth)
	possible_locs = list("mouth")

//handle cavity
/datum/surgery_step/handle_teeth
	accept_hand = 1
	accept_any_item = 1
	time = 64
	var/obj/item/IC = null

/datum/surgery_step/handle_teeth/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1

	for(var/obj/item/organ/teeth/T in O.teeth)
		if(istype(T, /obj/item/organ/teeth))
			IC = T
			break
	if(istype(tool, /obj/item/organ/teeth))
		user.visible_message("<span class='notice'>[user] begins to insert [tool] into [target]'s [target_zone].</span>")
	else
		user.visible_message("<span class='notice'>[user] checks for teeth in [target]'s [target_zone].</span>")

/datum/surgery_step/handle_teeth/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(tool)
		if(IC)
			user.visible_message("<span class='notice'>[user] can't seem to fit [tool] in [target]'s [target_zone].</span>")
			return 0
		else
			user.visible_message("<span class='notice'>[user] inserts [tool] into [target]'s [target_zone]!</span>")
			user.drop_item()
			O.teeth += tool
			tool.loc = target
			return 1
	else
		if(IC)
			user.visible_message("<span class='notice'>[user] pulls [IC] out of [target]'s [target_zone]!</span>")
			user.put_in_hands(IC)
			O.teeth -= IC
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

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(O.teeth.len <= 0)
		user.visible_message("<span class='notice'>[target] has no teeth to speak of!</span>")
		return -1
	user.visible_message("[user] begins to wedge [tool] in [target]'s [parse_zone(target_zone)].", "<span class='notice'>You begin to wedge [tool] in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/human/target, target_zone, var/obj/item/weapon/reagent_containers/pill/tool, datum/surgery/surgery)
	if(!istype(tool))
		return 0
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(O.teeth.len <= 0)
		user.visible_message("<span class='notice'>[target] has no teeth to speak of!</span>")
		return -1

	user.drop_item()
	O.teeth += tool
	tool.loc = target

	var/datum/action/item_action/hands_free/activate_pill/P = new
	P.button_icon_state = tool.icon_state
	P.target = tool
	P.Grant(target)

	user.visible_message("[user] wedges [tool] into [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You wedge [tool] into [target]'s [parse_zone(target_zone)].</span>")
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