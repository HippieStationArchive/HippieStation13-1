/datum/surgery/limb_manipulation
	name = "limb manipulation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/manipulate_limbs)
	species = list(/mob/living/carbon/human)
	possible_locs = list("chest", "head", "r_leg", "l_leg", "r_arm", "l_arm")
	requires_organic_bodypart = 0

/datum/surgery_step/manipulate_limbs
	time = 64
	name = "manipulate limbs"
	implements = list(/obj/item/organ/limb = 100)
	var/implements_detach = list(/obj/item/weapon/circular_saw = 100, /obj/item/weapon/melee/energy/sword/cyborg/saw = 100, /obj/item/weapon/melee/arm_blade = 75, /obj/item/weapon/twohanded/fireaxe = 50, /obj/item/weapon/hatchet = 35, /obj/item/weapon/kitchen/knife/butcher = 25)
	var/implements_mend = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/weldingtool = 70, /obj/item/weapon/lighter = 45, /obj/item/weapon/match = 20)
	var/current_type
	var/obj/item/organ/limb/I = null

/datum/surgery_step/manipulate_limbs/New()
	..()
	implements = implements + implements_detach + implements_mend

/datum/surgery_step/manipulate_limbs/tool_check(mob/user, obj/item/tool)
	if(istype(tool, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = tool
		if(!WT.isOn())	return 0

	else if(istype(tool, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/L = tool
		if(!L.lit)	return 0

	else if(istype(tool, /obj/item/weapon/match))
		var/obj/item/weapon/match/M = tool
		if(!M.lit)	return 0

	return 1


/datum/surgery_step/manipulate_limbs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	I = null
	target_zone = check_zone(target_zone)
	if(islimb(tool))
		current_type = "insert"
		I = tool
		if(target_zone != Bodypart2name(I))
			user << "<span class='notice'>There is already a limb in [target]'s [parse_zone(target_zone)]!</span>"
			return -1

		user.visible_message("[user] begins to insert [tool] into [target]'s stump.",
			"<span class='notice'>You begin to insert [tool] into [target]'s stump...</span>")

	else if(implement_type in implements_detach)
		current_type = "extract"
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/obj/item/organ/limb/I = H.get_organ(target_zone)
			if(!istype(I))
				user << "<span class='notice'>There is no removeable limb in [target]'s [parse_zone(target_zone)]!</span>"
				return -1

			user.visible_message("[user] begins to detach [target]'s [I].",
				"<span class='notice'>You begin to detach [target]'s [I]...</span>")

	else if(implement_type in implements_mend)
		current_type = "mend"
		user.visible_message("[user] begins to mend the incision in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You begin to mend the incision in [target]'s [parse_zone(target_zone)]...</span>")


/datum/surgery_step/manipulate_limbs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(current_type == "mend")
		user.visible_message("[user] mends the incision in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You mend the incision in [target]'s [parse_zone(target_zone)].</span>")
		if(islimb(surgery.organ))
			var/obj/item/organ/limb/L = surgery.organ
			L.state_flags = ORGAN_FINE
		return 1
	else if(current_type == "insert")
		I = tool
		user.drop_item()
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.attachLimb(I, user)

		user.visible_message("[user] inserts [tool] into [target]'s [parse_zone(target_zone)]!",
			"<span class='notice'>You insert [tool] into [target]'s [parse_zone(target_zone)].</span>")

	else if(current_type == "extract")
		if(I && I.owner == target)
			target.apply_damage(20,BRUTE,"chest")
			user.visible_message("[user] successfully detaches [target]'s [I]!",
				"<span class='notice'>You successfully detach [target]'s [I].</span>")
			add_logs(user, target, "surgically removed [I.name] from", addition="INTENT: [uppertext(user.a_intent)]")
			I.state_flags = ORGAN_AUGMENTABLE
			I.drop_limb()
			target.update_canmove()
			target.regenerate_icons()
		else
			user.visible_message("[user] can't seem to detach [parse_zone(target_zone)] from [target]!",
				"<span class='notice'>You can't detach [parse_zone(target_zone)] from [target]!</span>")
	return 0