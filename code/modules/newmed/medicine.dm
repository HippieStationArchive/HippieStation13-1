/obj/item/weapon/reagent_containers/medical
	name = "medical pack"
	icon = 'icons/obj/medicine.dmi'
	// amount = 5
	// max_amount = 5
	w_class = 1
	throw_speed = 3
	throw_range = 7
	volume = 50
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(2,5,10,15,25,30)
	//flags = OPENCONTAINER //Nah. Let's reserve that for patches.
	can_examine_reagents = 1
	// var/heal_brute = 0
	// var/heal_burn = 0

/obj/item/weapon/reagent_containers/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(reagents.total_volume <= 0)
		user << "<span class='notice'>You ran out of [src]!</span>"
		qdel(src)
		return
	if (M.stat == 2)
		var/t_him = "it"
		if (M.gender == MALE)
			t_him = "him"
		else if (M.gender == FEMALE)
			t_him = "her"
		user << "<span class='danger'>\The [M] is dead, you cannot help [t_him]!</span>"
		return

	if (!istype(M))
		user << "<span class='danger'>\The [src] cannot be applied to [M]!</span>"
		return 1

	if(!user.IsAdvancedToolUser())
		user << "<span class='danger'>You don't have the dexterity to do this!</span>"
		return 1

	if (istype(M, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = M
		var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))

		if(affecting.status == ORGAN_ORGANIC) //Limb must be organic to be healed
			// if (affecting.heal_damage(src.heal_brute, src.heal_burn, 0))
			// 	H.update_damage_overlays(0)

			// M.updatehealth()
			for(var/datum/reagent/R in reagents.reagent_list)
				R.reaction_mob(M, TOUCH, amount_per_transfer_from_this, user.zone_sel.selecting)
		else
			user << "<span class='notice'>Medicine won't work on a robotic limb!</span>"
			return
	else
		for(var/datum/reagent/R in reagents.reagent_list)
			R.reaction_mob(M, TOUCH, amount_per_transfer_from_this, user.zone_sel.selecting)

	if (user)
		if (M != user)
			user.visible_message( \
				"<span class='notice'>[user] has applied [src] on [M].</span>", \
				"<span class='notice'>You apply \the [src] to [M].</span>" \
			)
		else
			var/t_himself = "itself"
			if (user.gender == MALE)
				t_himself = "himself"
			else if (user.gender == FEMALE)
				t_himself = "herself"

			user.visible_message( \
				"<span class='notice'>[M] applied [src] on [t_himself].</span>", \
				"<span class='notice'>You apply \the [src] on yourself.</span>" \
			)

	reagents.trans_to(M, amount_per_transfer_from_this)
	if(reagents.total_volume <= 0)
		user << "<span class='notice'>You ran out of [src]!</span>"
		qdel(src)

/obj/item/weapon/reagent_containers/medical/bruise_pack
	name = "bruise pack"
	desc = "A bruise pack containing reagents to treat blunt-force trauma. On the label it says: \"10u of brutanol heals 40 damage. Do the math for rest.\""
	icon_state = "brutepack"
	// heal_brute = 60
	origin_tech = "biotech=1"

/obj/item/weapon/reagent_containers/medical/bruise_pack/New()
	..()
	reagents.add_reagent("brutanol", 50)

/obj/item/weapon/reagent_containers/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns. On the back of the bottle it says: \"10u of ointment heals 40 damage. Do the math for rest.\""
	gender = PLURAL
	icon_state = "ointment"
	// heal_burn = 40
	origin_tech = "biotech=1"

/obj/item/weapon/reagent_containers/medical/ointment/New()
	..()
	reagents.add_reagent("ointment", 50)

/obj/item/weapon/reagent_containers/chempatch
	name = "chemical patch"
	desc = "It's a medical patch usually available to the chemists. Best used for reagents that react on touch."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "patch"
	w_class = 1
	throw_speed = 3
	throw_range = 7
	volume = 20
	var/divider = 4 //Divides volume transferred by val for balancing reasons. The patch is still deleted on application.
	flags = INJECTABLE //| NOBLUDGEON - Unneccesary, we overwrite attack proc already
	// amount_per_transfer_from_this = 10
	// possible_transfer_amounts = list(2,5,10,15,25,30)
	// can_examine_reagents = 1

/obj/item/weapon/reagent_containers/chempatch/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(reagents.total_volume <= 0)
		user << "<span class='notice'>The [src] doesn't contain any reagents!</span>"
		return

	if (M.stat == 2)
		var/t_him = "it"
		if (M.gender == MALE)
			t_him = "him"
		else if (M.gender == FEMALE)
			t_him = "her"
		user << "<span class='danger'>\The [M] is dead, you cannot help [t_him]!</span>"
		return

	if (!istype(M))
		user << "<span class='danger'>\The [src] cannot be applied to [M]!</span>"
		return 1

	if(!user.IsAdvancedToolUser())
		user << "<span class='danger'>You don't have the dexterity to do this!</span>"
		return 1

	if (user)
		if (M != user)
			user.visible_message("<span class='danger'>[user] is trying to apply a [src] on [M]!</span>", \
							"<span class='userdanger'>[user] is trying to apply a [src] on [M]!</span>")
			if(do_mob(user, M, 15))
				user.visible_message( \
					"<span class='danger'>[user] has applied [src] on [M]!</span>", \
					"<span class='userdanger'>You apply \the [src] to [M].</span>" \
				)
			else
				user << "<span class='danger'>You fail to apply \the [src] to [M]!</span>"
				return
		else
			var/t_himself = "itself"
			if (user.gender == MALE)
				t_himself = "himself"
			else if (user.gender == FEMALE)
				t_himself = "herself"

			user.visible_message( \
				"<span class='notice'>[M] applied [src] on [t_himself].</span>", \
				"<span class='notice'>You apply \the [src] on yourself.</span>" \
			)


	if (istype(M, /mob/living/carbon/human))

		//var/mob/living/carbon/human/H = M
		//var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))

		// if(affecting.status == ORGAN_ORGANIC) //Limb must be organic to be healed
			// if (affecting.heal_damage(src.heal_brute, src.heal_burn, 0))
			// 	H.update_damage_overlays(0)

			// M.updatehealth()
		for(var/datum/reagent/R in reagents.reagent_list)
			R.reaction_mob(M, TOUCH, reagents.total_volume*2, user.zone_sel.selecting) //Reaction is multiplied by 2 for effectiveness
		// else
		// 	user << "<span class='notice'>Medicine won't work on a robotic limb!</span>"
		// 	return
	else
		for(var/datum/reagent/R in reagents.reagent_list)
			R.reaction_mob(M, TOUCH, reagents.total_volume, user.zone_sel.selecting)

	reagents.trans_to(M, reagents.total_volume/divider) //So you can't reliably sleeptox people with patches or whatever
	qdel(src)

//Update fancy patch reagent thing
/obj/item/weapon/reagent_containers/chempatch/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/chempatch/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/chempatch/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/chempatch/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/chempatch/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/medicine.dmi', src, "patch_reagents")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/weapon/reagent_containers/chempatch/brutanol
	name = "brutanol patch"
	desc = "It's a medical brutanol patch to heal brute damage."
	icon_state = "patch_med"

/obj/item/weapon/reagent_containers/chempatch/brutanol/New()
	..()
	reagents.add_reagent("brutanol", 10)

/obj/item/weapon/reagent_containers/chempatch/ointment
	name = "ointment patch"
	desc = "It's a medical ointment patch to heal brute damage."
	icon_state = "patch_med"

/obj/item/weapon/reagent_containers/chempatch/ointment/New()
	..()
	reagents.add_reagent("ointment", 10)

/obj/item/weapon/reagent_containers/chempatch/syndbrutanol
	name = "brutanol patch"
	desc = "Syndicate-brand brutanol patch designed to heal those nasty wounds. Also stops bleeding. Extremely robust."
	icon_state = "patch_synd"

/obj/item/weapon/reagent_containers/chempatch/syndbrutanol/New()
	..()
	reagents.add_reagent("brutanol", 15)
	reagents.add_reagent("inaprovaline", 5)

/obj/item/weapon/reagent_containers/chempatch/syndointment
	name = "ointment patch"
	desc = "Syndicate-brand ointment patch designed to heal those nasty burns. Extremely robust."
	icon_state = "patch_synd"

/obj/item/weapon/reagent_containers/chempatch/syndointment/New()
	..()
	reagents.add_reagent("ointment", 20)