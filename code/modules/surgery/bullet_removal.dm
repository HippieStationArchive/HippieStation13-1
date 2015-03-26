/datum/surgery/bulletremoval //Can also be used to remove /ANY/ type of object lodged into an organ.
	name = "bullet removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/remove_bullet, /datum/surgery_step/close) //Simple.
	species = list(/mob/living/carbon/human)
	location = "anywhere" //Check attempt_initate_surgery() (in code/modules/surgery/helpers) to see what this does if you can't tell
	has_multi_loc = 1 //Multi location stuff, See multiple_location_example.dm


/datum/surgery_step/remove_bullet
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/screwdriver = 70, /obj/item/weapon/wirecutters = 50, /obj/item/weapon/crowbar = 30)
	time = 20 //Low time for bullet extraction in case there are multiple lodged in.
	var/obj/item/organ/limb/L = null // L because "limb"
	allowed_organs = list("r_arm","l_arm","r_leg","l_leg","chest","head") //Although bullets cannot be lodged into heads, I still allow bullet extraction in case there are other things lodged in.

/datum/surgery_step/remove_bullet/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	L = new_organ
	if(L)
		user.visible_message("<span class ='notice'>[user] begins to look for the foreign objects in [target]'s [parse_zone(user.zone_sel.selecting)].</span>")
	else
		user.visible_message("<span class ='notice'>[user] looks for [target]'s [parse_zone(user.zone_sel.selecting)].</span>")

/datum/surgery_step/remove_bullet/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(L)
		if(ishuman(target))
			if(L.foreign_objects.len)
				var/obj/item/B = pick(L.foreign_objects) //Foreign objects should ALWAYS be items.
				var/msg = "[user] successfully extracts the foreign object from [target]'s [parse_zone(target_zone)]!"
				B.loc = get_turf(target)
				B.add_blood(target) //make it all bloody and shit
				L.foreign_objects -= B
				if(L.foreign_objects.len)
					surgery.status = 1 //If there are still foreign objects left, don't complete the surgery yet. Instead, go to first step and repeat.
					msg += " There's something else left..."
				else
					msg += " Seems like that was the last one."

				user.visible_message("<span class='notice'>[msg]</span>")
			else
				user.visible_message("<span class='notice'>[user] cannot find any foreign objects in [target]'s [parse_zone(target_zone)]. Time to close up the wound!</span>")
	else
		user.visible_message("<span class='notice'>[target] has no organic [parse_zone(target_zone)] there!</span>")
	return 1
