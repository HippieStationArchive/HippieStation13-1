// Rigatoni brass knuckles.

/datum/martial_art/rigatoni
	name = "Rigatoni Knuckles"

/datum/martial_art/rigatoni/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] [pick("punches", "kicks", "chops", "hits", "slams")] [D]!</span>", \
					  "<span class='userdanger'>[A] hits you!</span>")
	D.apply_damage(10, BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
	D.apply_damage(10,STAMINA)
	add_logs(A, D, "knuckled", "(Rigatoni Knuckles)")
	if(D.getStaminaLoss() > 50)
		var/knockout_prob = D.getStaminaLoss() + rand(-15,15)
		if((D.stat != DEAD) && prob(knockout_prob))
			D.visible_message("<span class='danger'>[A] has knocked [D] out with a haymaker!</span>", \
								"<span class='userdanger'>[A] has knocked [D] out with a haymaker!</span>")
			D.apply_effect(10,WEAKEN)
			D.SetSleeping(5)
			D.forcesay(hit_appends)
		else if(D.lying)
			D.forcesay(hit_appends)
	return 1

/obj/item/clothing/gloves/brassknuckles
	name = "brass knuckles"
	desc = "Heavy brass knuckles.. you could do some damage with these!"
	icon_state = "brassknuckles"
	item_state = null
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

