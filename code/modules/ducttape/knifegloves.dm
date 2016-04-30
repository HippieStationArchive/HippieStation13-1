/obj/item/clothing/gloves/knife
	name = "knife gloves"
	desc = "Now a lethal excuse to punch your crewmates. Might penetrate armor."
	icon_state = "boxing"
	item_state = "boxing"
	item_color = ""
	put_on_delay = 60
	var/datum/martial_art/knifegloves/style = new

/obj/item/clothing/gloves/knife/CheckParts()
	var/obj/item/clothing/gloves/boxing/B = locate() in contents
	if(B)
		icon_state = B.icon_state
		item_color = B.item_color
		update_icon()

/obj/item/clothing/gloves/knife/update_icon()
	overlays.Cut()
	overlays += image(icon=icon,icon_state="boxing_knives")
	item_state = "boxing[item_color]_knives"

/obj/item/clothing/gloves/knife/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_gloves)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

/obj/item/clothing/gloves/knife/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_gloves) == src)
		style.remove(H)
	return

//Martial Art
/datum/martial_art/knifegloves
	name = "Knife Gloves"

/datum/martial_art/knifegloves/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A << "<span class='warning'>Can't disarm with these gloves!</span>"
	return 1

/datum/martial_art/knifegloves/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A << "<span class='warning'>Can't grab with these gloves!</span>"
	return 1

/datum/martial_art/knifegloves/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.do_attack_animation(D)
	var/atk_verb = pick("sharp left hook","sharp right hook","straight stab")
	var/damage = rand(8, 12)

	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee","","",15)

	playsound(D.loc, list('sound/weapons/knifegloves1.ogg','sound/weapons/knifegloves2.ogg'), 50, 1)

	var/dmgcheck = D.apply_damage(damage, BRUTE, affecting, armor_block)
	if(!dmgcheck)
		D.visible_message("<span class='danger'>[A] has attempted to hit [D] with a [atk_verb]!</span>", \
								"<span class='userdanger'>[A] has attempted to [D] with a [atk_verb]!</span>")
		return 1
	D.visible_message("<span class='danger'>[A] has hit [D] with a [atk_verb]!</span>", \
							"<span class='userdanger'>[A] has hit [D] with a [atk_verb]!</span>")

	if(prob(25))
		A.gloves.add_blood(D) //Bloodify the gloves
	add_logs(A, D, "stab-punched", object=A.gloves)
	return 1