/obj/item/humanpokeball
	name = "Rapid Human Restraint Device"
	desc = "An insidious device that utilises a series of compact springs, gas canisters and bluespace technology to rapidly bind a victim in a blindfold, muzzle and straightjacket in order to capture and restrain them for nefarious purposes."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "bluespaceball"
	item_state = "bluespaceball"
	w_class = 1 //Hide one in your ass in case of emergencies
	force = 0
	throwforce = 0
	throw_range = 7



/mob/living/carbon/human/hitby(atom/movable/AM, blocked = 0)

	..()
	if(istype(AM,/obj/item/humanpokeball))
		unEquip(wear_mask) //Will probably screw over people who need to use internals.
		unEquip(wear_suit) // Might screw over people wearing suits in space.
		unEquip(glasses)
		equipOutfit(/datum/outfit/pokeball)
		apply_effect(2, WEAKEN) //Straight jackets do not slow movement, this should give the user enough time to run over and snag the guy.

		visible_message("<span class='danger'>Success! The [src] was caught!</span>", \
					"<span class='userdanger'>The device wraps restraints around your body and pulls them tight!</span>")
		qdel(AM)


