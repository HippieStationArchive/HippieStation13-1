/obj/item/weapon/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. Holds up to 5 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 3, 4, 5)
	volume = 5
	can_examine_reagents = 1
	banned_reagents = list("pacid","sacid")

/obj/item/weapon/reagent_containers/dropper/afterattack(obj/target, mob/user , proximity)
	if(!proximity) return
	if(!target.reagents) return

	if(reagents.total_volume > 0)
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			user << "<span class='notice'>[target] is full.</span>"
			return

		if(istype(target, /obj/item/weapon/reagent_containers/spray))
			var/obj/item/weapon/reagent_containers/RC = target // copied from glass regant checker
			for(var/bad_reg in RC.banned_reagents)
				if(reagents.has_reagent(bad_reg, 1)) //Message is a bit "Game-y" but I can't think up a better one.
					user << "<span class='warning'>A chemical in [src] is far too dangerous to transfer to [target]!</span>"
					return

		if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/cigarette)) //You can inject humans and food but you cant remove the shit.
			user << "<span class='notice'>You cannot directly fill [target].</span>"
			return

		var/trans = 0

		if(ismob(target))
			if(istype(target , /mob/living/carbon/human))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = null
				if(victim.wear_mask)
					if(victim.wear_mask.flags & MASKCOVERSEYES)
						safe_thing = victim.wear_mask
				if(victim.head)
					if(victim.head.flags & MASKCOVERSEYES)
						safe_thing = victim.head
				if(victim.glasses)
					if(!safe_thing)
						safe_thing = victim.glasses

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)
					trans = reagents.trans_to(safe_thing, amount_per_transfer_from_this)

					target.visible_message("<span class='danger'>[user] tries to squirt something into [target]'s eyes, but fails!</span>", \
											"<span class='userdanger'>[user] tries to squirt something into [target]'s eyes, but fails!</span>")
					spawn(5)
						reagents.reaction(safe_thing, TOUCH)

					user << "<span class='notice'>You transfer [trans] unit\s of the solution.</span>"
					update_icon()
					return

			target.visible_message("<span class='danger'>[user] squirts something into [target]'s eyes!</span>", \
									"<span class='userdanger'>[user] squirts something into [target]'s eyes!</span>")
			reagents.reaction(target, TOUCH)
			var/mob/M = target
			var/R
			if(reagents)
				for(var/datum/reagent/A in src.reagents.reagent_list)
					R += A.id + " ("
					R += num2text(A.volume) + "),"
			add_logs(user, M, "squirted", object="[R]")

		trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		user << "<span class='notice'>You transfer [trans] unit\s of the solution.</span>"
		update_icon()

	else

		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			user << "<span class='notice'>You cannot directly remove reagents from [target].</span>"
			return

		if(!target.reagents.total_volume)
			user << "<span class='notice'>[target] is empty.</span>"
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

		user << "<span class='notice'>You fill [src] with [trans] unit\s of the solution.</span>"

		update_icon()

/obj/item/weapon/reagent_containers/dropper/update_icon()
	if(reagents.total_volume<=0)
		icon_state = "dropper0"
	else
		icon_state = "dropper1"