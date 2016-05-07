/obj/item/weapon/twohanded/bostaff
	name = "bo staff"
	desc = "A long, tall staff made of polished wood. Traditionally used in ancient old-Earth martial arts. Can be wielded to both kill and incapacitate."
	force = 10
	w_class = 4
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 24
	throwforce = 20
	throw_speed = 2
	attack_verb = list("smashed", "slammed", "whacked", "thwacked")
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bostaff0"
	block_chance = list(melee = 50, bullet = 50, laser = 50, energy = 50) //50% on everything

/obj/item/weapon/twohanded/bostaff/update_icon()
	icon_state = "bostaff[wielded]"
	return

/obj/item/weapon/twohanded/bostaff/attack(mob/target, mob/living/user)
	add_fingerprint(user)
	if((CLUMSY in user.disabilities) && prob(50))
		user << "<span class ='warning'>You club yourself over the head with [src].</span>"
		user.Weaken(3)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, "head")
		else
			user.take_organ_damage(2*force)
		return
	if(isrobot(target))
		return ..()
	if(!isliving(target))
		return ..()
	var/mob/living/carbon/C = target
	if(C.stat)
		user << "<span class='warning'>It would be dishonorable to attack a foe while they cannot retaliate.</span>"
		return
	switch(user.a_intent)
		if("disarm")
			if(!wielded)
				return ..()
			if(!ishuman(target))
				return ..()
			var/mob/living/carbon/human/H = target
			var/list/fluffmessages = list("[user] clubs [H] with [src]!", \
										  "[user] smacks [H] with the butt of [src]!", \
										  "[user] broadsides [H] with [src]!", \
										  "[user] smashes [H]'s head with [src]!", \
										  "[user] beats [H] with front of [src]!", \
										  "[user] twirls and slams [H] with [src]!")
			var/msg = pick(fluffmessages) //So the fluff message is the same for world and user
			H.visible_message("<span class='warning'>[msg]</span>", \
								   "<span class='userdanger'>[msg]</span>")
			playsound(get_turf(user), 'sound/effects/woodhit.ogg', 75, 1, -1)
			H.adjustStaminaLoss(rand(13,20))
			if(prob(10))
				H.visible_message("<span class='warning'>[H] collapses!</span>", \
									   "<span class='userdanger'>Your legs give out!</span>")
				H.Weaken(4)
			if(H.staminaloss && !H.sleeping)
				var/total_health = (H.health - H.staminaloss)
				if(total_health <= config.health_threshold_crit && !H.stat)
					H.visible_message("<span class='warning'>[user] delivers a heavy hit to [H]'s head, knocking them out cold!</span>", \
										   "<span class='userdanger'>[user] knocks you unconscious!</span>")
					H.sleeping += 30
					H.adjustBrainLoss(25)
			return
		else
			return ..()
	return ..()

/obj/item/weapon/twohanded/bostaff/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	if(wielded)
		return ..()
	return 0