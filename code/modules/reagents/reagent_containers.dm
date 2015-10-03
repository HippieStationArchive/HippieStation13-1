/obj/item/weapon/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = 1
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/list/banned_reagents = list() //List of reagent IDs we reject.

/obj/item/weapon/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	if(usr.stat || !usr.canmove || usr.restrained())
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this = N

/obj/item/weapon/reagent_containers/New()
	..()
	if (!possible_transfer_amounts)
		src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT
	create_reagents(volume)

/obj/item/weapon/reagent_containers/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/weapon/reagent_containers/afterattack(obj/target, mob/user , flag)
	return

/obj/item/weapon/reagent_containers/proc/reagentlist(var/obj/item/weapon/reagent_containers/snack) //Attack logs for regents in pills
	var/data
	if(snack.reagents.reagent_list && snack.reagents.reagent_list.len) //find a reagent list if there is and check if it has entries
		for (var/datum/reagent/R in snack.reagents.reagent_list) //no reagents will be left behind
			data += "[R.id]([R.volume] units); " //Using IDs because SOME chemicals(I'm looking at you, chlorhydrate-beer) have the same names as other chemicals.
		return data
	else return "No reagents"

/obj/item/weapon/reagent_containers/proc/canconsume(mob/eater, mob/user)
	if(!eater.SpeciesCanConsume())
		return 0
	//Check for covering mask
	var/obj/item/clothing/cover = eater.get_item_by_slot(slot_wear_mask)

	if(isnull(cover)) // No mask, do we have any helmet?
		cover = eater.get_item_by_slot(slot_head)
	else
		var/obj/item/clothing/mask/covermask = cover
		if(covermask.alloweat) // Specific cases, clownmask for example.
			return 1

	if(!isnull(cover))
		if((cover.flags & HEADCOVERSMOUTH) || (cover.flags & MASKCOVERSMOUTH))
			var/who = (isnull(user) || eater == user) ? "your" : "their"

			if(istype(cover, /obj/item/clothing/mask/))
				user << "<span class='warning'>You have to remove [who] mask first!</span>"
			else
				user << "<span class='warning'>You have to remove [who] helmet first!</span>"

			return 0
	return 1

/obj/item/weapon/reagent_containers/throw_impact(atom/target,mob/thrower)
	..()

	if(!reagents.total_volume || !is_open_container())
		return

	if(ismob(target) && target.reagents)
		reagents.total_volume *= rand(5,10) * 0.1 //Not all of it makes contact with the target
		var/mob/M = target
		var/R
		target.visible_message("<span class='danger'>[M] has been splashed with something!</span>", \
						"<span class='userdanger'>[M] has been splashed with something!</span>")
		if(reagents)
			for(var/datum/reagent/A in reagents.reagent_list)
				R += A.id + " ("
				R += num2text(A.volume) + "),"

		if(thrower)
			add_logs(thrower, M, "splashed", object="[R]")
		reagents.reaction(target, TOUCH)

	else if(!target.density || target.throwpass)
		if(thrower && thrower.mind && thrower.mind.assigned_role == "Bartender")
			visible_message("<span class='notice'>[src] lands onto the [target.name] without spilling a single drop.</span>")
			return

	else
		visible_message("<span class='notice'>[src] spills its contents all over [target].</span>")
		reagents.reaction(target, TOUCH)
	reagents.clear_reagents()