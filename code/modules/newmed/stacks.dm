/obj/item/stack/gauze
	name = "gauze"
	singular_name = "gauze"
	icon = 'icons/obj/medicine.dmi'
	desc = "Roll of gauze used to stop bleeding."
	icon_state = "gauze"
	origin_tech = "biotech=1"
	amount = 5
	max_amount = 5
	w_class = 1
	throw_speed = 3
	throw_range = 7
	var/reduce = 1 //How much bloodloss do we remove?

/obj/item/stack/gauze/attack(mob/living/carbon/M as mob, mob/user as mob)

	if (M.stat == 2)
		var/t_him = "it"
		if (M.gender == MALE)
			t_him = "him"
		else if (M.gender == FEMALE)
			t_him = "her"
		user << "<span class='danger'>\The [M] is dead, you cannot help [t_him]!</span>"
		return

	if (!istype(M, /mob/living/carbon/human))
		user << "<span class='danger'>\The [src] cannot be applied to [M]!</span>"
		return 1

	if(!user.IsAdvancedToolUser())
		user << "<span class='danger'>You don't have the dexterity to do this!</span>"
		return 1

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))

	if(affecting.status == ORGAN_ORGANIC) //Limb must be organic to be healed - RR
		affecting.bloodloss = max(0, min(affecting.bloodloss - reduce, 1))
	else
		user << "<span class='notice'>Medicine won't work on a robotic limb!</span>"
		return

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

	use(1)

/obj/item/stack/gauze/piece
	name = "makeshift gauze"
	singular_name = "gauze"
	icon = 'icons/obj/medicine.dmi'
	desc = "A torn up cloth used to stop bleeding."
	icon_state = "gauzepiece"
	// origin_tech = "biotech=1"
	amount = 2
	max_amount = 2
	w_class = 1
	throw_range = 4 //It's just a piece
	reduce = 0.5 //Going above 0.5 bloodloss takes some effort lol