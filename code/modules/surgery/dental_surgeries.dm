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

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/pill, datum/surgery/surgery)
	var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in target.organs
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(!O.get_teeth())
		user.visible_message("<span class='notice'>[target] has no teeth to speak of!</span>")
		return -1
	if(O.dentals.len >= O.get_teeth() / 4) //8 max pills for 32-toothed people seems reasonable enough.
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
	if(!O.get_teeth())
		user.visible_message("<span class='notice'>[target] has no teeth to speak of!</span>")
		return -1
	if(O.dentals.len >= O.get_teeth() / 4) //8 max pills seems reasonable enough.
		user.visible_message("<span class='notice'>There's no room for more implants in [target]'s teeth!</span>")
		return -1

	user.drop_item()
	O.dentals += pill
	pill.loc = O

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
	var/obj/item/weapon/reagent_containers/food/drinks/P = target //Pill
	if(ishuman(owner) && istype(P))
		var/mob/living/carbon/human/H = owner
		var/obj/item/organ/limb/head/O = locate(/obj/item/organ/limb/head) in H.organs
		if(!O || !O.get_teeth())
			H << "<span class='caution'>You have no teeth to burst \the [P]!</span>"
			return 0
		H << "<span class='caution'>You grit your teeth and burst the implanted [P]!</span>"
		add_logs(owner, H, "bursted the implanted", P.reagentlist(P))
		if(P.reagents.total_volume)
			P.reagents.reaction(H, INGEST)
			P.reagents.trans_to(H, P.reagents.total_volume)
		qdel(P)
		return 1
	return 0