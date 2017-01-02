/datum/surgery/teeth_reinsertion
	name = "teeth reinsertion"
	steps = list(/datum/surgery_step/handle_teeth)
	possible_locs = list("mouth")

//handle cavity
/datum/surgery_step/handle_teeth
	accept_hand = 1
	accept_any_item = 1
	time = 64

/datum/surgery_step/handle_teeth/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/teeth/T, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(istype(T))
		if(O.get_teeth() >= O.max_teeth)
			user << "<span class='notice'>All of [target]'s teeth are intact."
			return -1
		user.visible_message("<span class='notice'>[user] begins to insert [T] into [target]'s [target_zone].</span>")
	else
		user.visible_message("<span class='notice'>[user] checks for teeth in [target]'s [target_zone].</span>")

/datum/surgery_step/handle_teeth/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/teeth/T, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(istype(T))
		if(O.get_teeth()) //Has teeth, check if they need "refilling"
			if(O.get_teeth() >= O.max_teeth)
				user.visible_message("<span class='notice'>[user] can't seem to fit [T] in [target]'s [target_zone].</span>", "<span class='notice'>All of [target]'s teeth are intact.</span>")
				return 0
			var/obj/item/stack/teeth/F = locate(T.type) in O.teeth_list //Look for same type of teeth inside target's mouth for merging
			var/amt = T.amount
			if(F)
				amt = T.merge(F) //Try to merge provided teeth into person's teeth.
			else
				amt = min(T.amount, O.max_teeth-O.get_teeth())
				T.use(amt)
				var/obj/item/stack/teeth/E = new T.type(target, amt)
				O.teeth_list += E
				// E.loc = target
				T = E
			user.visible_message("<span class='notice'>[user] inserts [amt] [T] into [target]'s [target_zone]!</span>")
			return 1
		else //No teeth to speak of.
			var/amt = min(T.amount, O.max_teeth)
			T.use(amt)
			var/obj/item/stack/teeth/F = new T.type(target, amt)
			O.teeth_list += F
			// F.loc = target
			T = F
			user.visible_message("<span class='notice'>[user] inserts [amt] [T] into [target]'s [target_zone]!</span>")
			return 1
	else
		if(O.teeth_list.len)
			user.visible_message("<span class='notice'>[user] pulls all teeth out of [target]'s [target_zone]!</span>")
			for(var/obj/item/stack/teeth/F in O.teeth_list)
				O.teeth_list -= F
				F.loc = get_turf(target)
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

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(tool.type == /obj/item/weapon/reagent_containers/pill)
		user.visible_message("[user] begins to wedge \the [tool] in [target]'s [parse_zone(target_zone)].", "<span class='notice'>You begin to wedge [tool] in [target]'s [parse_zone(target_zone)]...</span>")
		return 1
	else
		user << "<span class='warning'>You cannot insert the [tool] into " + (user == target ? "your" : "[target]'s") + " tooth!<span>"
		return -1

/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/target, target_zone, var/obj/item/weapon/reagent_containers/pill/tool, datum/surgery/surgery)
	if(!istype(tool))
		return 0

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/limb/head/organ = locate(/obj/item/organ/limb/head) in H.organs
		organ.dentals += tool

	user.drop_item()
	target.internal_organs += tool
	tool.loc = target

	var/datum/action/item_action/hands_free/activate_pill/P = new
	P.button_icon_state = tool.icon_state
	P.target = tool
	P.Grant(target)

	user.visible_message("[user] wedges \the [tool] into [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You wedge [tool] into [target]'s [parse_zone(target_zone)].</span>")
	return 1

/datum/action/item_action/hands_free/activate_pill
	name = "Activate Pill"

/datum/action/item_action/hands_free/activate_pill/Trigger()
	if(..() || CheckRemoval(owner))
		return 0
	owner << "<span class='caution'>You grit your teeth and burst the implanted [target]!</span>"
	add_logs(owner, null, "swallowed an implanted pill", target)
	if(target.reagents.total_volume)
		target.reagents.reaction(owner, INGEST)
		target.reagents.trans_to(owner, target.reagents.total_volume)

		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/obj/item/organ/limb/head/organ = locate(/obj/item/organ/limb/head) in H.organs
			organ.dentals -= target
	qdel(target)
	return 1