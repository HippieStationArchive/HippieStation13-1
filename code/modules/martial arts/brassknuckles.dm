// Rigatoni brass knuckles.

/datum/martial_art/rigatoni
	name = "Rigatoni Knuckles"


/datum/martial_art/rigatoni/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A << "<span class='warning'>Can't grab with brass knuckles!</span>"
	return 1

/datum/martial_art/rigatoni/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] [pick("punches", "kicks", "chops", "hits", "slams")] [D]!</span>", \
					  "<span class='userdanger'>[A] hits you!</span>")
	D.apply_damage(10, BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
	return 1


/datum/martial_art/rigatoni/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A << "<span class='warning'>Can't disarm with brass knuckles!</span>"
	return 1


/obj/item/clothing/gloves/brassknuckles
	var/datum/martial_art/rigatoni/style = new

/obj/item/clothing/gloves/brassknuckles/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_gloves)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

/obj/item/clothing/gloves/brassknuckles/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_gloves) == src)
		style.remove(H)
	return
