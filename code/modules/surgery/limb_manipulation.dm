/datum/surgery/limb_manipulation
	name = "limb manipulation"
	steps = list(/datum/surgery_step/incise_or_mend, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/manipulate_limbs)
	species = list(/mob/living/carbon/human)
	possible_locs = list("chest", "head", "r_leg", "l_leg", "r_arm", "l_arm")
	requires_organic_bodypart = 0

/datum/surgery_step/incise_or_mend
	name = "make incision or mend the muscles"
	implements = list()
	var/implements_incise = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/melee/energy/sword = 75, /obj/item/weapon/kitchen/knife = 65, /obj/item/weapon/shard = 45)
	var/implements_mend = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/weldingtool = 70, /obj/item/weapon/lighter = 45, /obj/item/weapon/match = 20)
	var/current_type = ""
	time = 16

/datum/surgery_step/incise_or_mend/New()
	..()
	implements = implements + implements_incise + implements_mend

/datum/surgery_step/incise_or_mend/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	target_zone = check_zone(target_zone)
	time = initial(time)
	if(implement_type in implements_incise)
		user.visible_message("[user] begins to make an incision in [target]'s [parse_zone(target_zone)].", "<span class='notice'>You begin to make an incision in [target]'s [parse_zone(target_zone)]...</span>")
	else
		current_type = "mend"
		time = 10
		user.visible_message("[user] begins to mend the muscles in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You begin to mend the muscles in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/incise_or_mend/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(current_type == "mend")
		user.visible_message("[user] mends the muscles in [target]'s [parse_zone(target_zone)]!",
			"<span class='notice'>You mend the muscles in [target]'s [parse_zone(target_zone)]!</span>")
		var/obj/item/organ/limb/I
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			I = H.get_organ(target_zone)
		if(istype(I))
			I.state_flags = ORGAN_FINE
			I.update_organ_icon()
			target.regenerate_icons()
			target.update_canmove()
		surgery.complete(target)
	else
		user.visible_message("[user] succeeds!", "<span class='notice'>You succeed.</span>")
	return 1

/datum/surgery_step/manipulate_limbs
	time = 64
	name = "manipulate limbs"
	implements = list()
	var/implements_detach = list(/obj/item/weapon/circular_saw = 100, /obj/item/weapon/melee/energy/sword/cyborg/saw = 100, /obj/item/weapon/melee/arm_blade = 75, /obj/item/weapon/twohanded/fireaxe = 50, /obj/item/weapon/hatchet = 35, /obj/item/weapon/kitchen/knife/butcher = 25)
	var/implements_mend = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/weldingtool = 70, /obj/item/weapon/lighter = 45, /obj/item/weapon/match = 20)
	var/implements_sever = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/melee/energy/sword = 75, /obj/item/weapon/kitchen/knife = 65, /obj/item/weapon/shard = 45)
	var/current_type = ""
	var/obj/item/organ/limb/I = null
	var/obj/item/robot_parts/RP = null

/datum/surgery_step/manipulate_limbs/New()
	..()
	implements = implements + implements_detach + implements_mend + implements_sever

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
	time = initial(time)
	if(implement_type in implements_detach)
		current_type = "extract"
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			I = H.get_organ(target_zone)
			if(!istype(I))
				user << "<span class='notice'>There is no removeable limb in [target]'s [parse_zone(target_zone)]!</span>"
				return -1

			user.visible_message("[user] begins to detach [target]'s [I].",
				"<span class='notice'>You begin to detach [target]'s [I]...</span>")
	else if(implement_type in implements_mend)
		current_type = "mend"
		time = 10
		user.visible_message("[user] begins to mend the incision in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You begin to mend the incision in [target]'s [parse_zone(target_zone)]...</span>")
	else if(implement_type in implements_sever)
		current_type = "sever"
		time = 30
		user.visible_message("[user] begins to sever the muscles in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You begin to sever the muscles in [target]'s [parse_zone(target_zone)]...</span>")


/datum/surgery_step/manipulate_limbs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(current_type == "mend")
		user.visible_message("[user] mends the incision in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You mend the incision in [target]'s [parse_zone(target_zone)].</span>")
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			I = H.get_organ(target_zone)
		if(istype(I))
			I.state_flags = ORGAN_FINE
			I.update_organ_icon()
			target.regenerate_icons()
			target.update_canmove()
	else if(current_type == "sever")
		user.visible_message("[user] severs the muscles in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You severs the muscles in [target]'s [parse_zone(target_zone)].</span>")
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			I = H.get_organ(target_zone)
		if(istype(I))
			I.state_flags = ORGAN_AUGMENTABLE
			I.update_organ_icon()
			target.regenerate_icons()
			target.update_canmove()
	else if(current_type == "extract")
		if(I && I.owner == target)
			target.apply_damage(20,BRUTE,"chest")
			user.visible_message("[user] successfully detaches [target]'s [I]!",
				"<span class='notice'>You successfully detach [target]'s [I].</span>")
			add_logs(user, target, "surgically removed [I.name] from", addition="INTENT: [uppertext(user.a_intent)]")
			I.state_flags = ORGAN_AUGMENTABLE
			I.update_organ_icon()
			I.drop_limb() //If you saw the chest off, well, all you're getting is a whole lot of nothing (severing muscles tho.)
			target.update_canmove()
			target.regenerate_icons()
		else
			user.visible_message("[user] can't seem to detach [parse_zone(target_zone)] from [target]!",
				"<span class='notice'>You can't detach [parse_zone(target_zone)] from [target]!</span>")
	return 1