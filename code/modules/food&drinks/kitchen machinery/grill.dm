//Extra vars
/obj/item
	var/grill_amt = 0 //Amount of times this object was grilled

/obj/machinery/foodgrill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "grill_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it grilling food already?
	var/obj/item/grilling = null	//What's being grilled RIGHT NOW?

/obj/machinery/foodgrill/examine()
	..()
	if(grilling)
		usr << "There's [grilling] on the grill."

/obj/machinery/foodgrill/attack_hand(mob/user)
	if(on && grilling)
		user << "<span class='notice'>You pull [grilling] from [src], not letting it finish!</span>"
		// grilling.color = img.color
		user.put_in_hands(grilling)
		grilling = null
		icon_state = "grill_off"
		overlays.Cut()
		on = FALSE
		return
	..()

/obj/machinery/foodgrill/attackby(obj/item/I, mob/user) //TODO: Deeprfy people when emagged
	if(on)
		user << "<span class='notice'>[src] is already processing, please wait.</span>"
		return
	if(istype(I,/obj/item/weapon/wrench))
		if(!anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			anchored = 1
			user << "You wrench [src] in place."
			return
		else if(anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			anchored = 0
			user << "You unwrench [src]."
			return
	if(!anchored)
		user << "The machine must be anchored to be usable!"
		return
	if(istype(I, /obj/item/weapon/grab)||istype(I, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		user << "<span class='warning'>That would probably break [I].</span>"
		return
	user << "<span class='notice'>You put [I] onto [src].</span>"
	on = TRUE
	user.drop_item()
	grilling = I
	grilling.loc = src
	icon_state = "grill_on"

	var/image/img = new(I.icon, I.icon_state)
	img.overlays += I.overlays
	img.pixel_y = 5
	overlays += img
	sleep(200)
	if(!on || !grilling)
		overlays.Cut()
		on = FALSE
		icon_state = "grill_off"
		qdel(img)
		return
	overlays.Cut()
	on = FALSE
	icon_state = "grill_off"
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)

	// if(grilling.grill_amt > 3 && prob(grilling.grill_amt * 5)) //Don't overgrill shit, too!
	// 	visible_message("<span class='danger'>[grilling] [pick("breaks", "crumbles", "burns")] in [src]!</span>")
	// 	new /obj/effect/decal/cleanable/ash(loc)
	// 	qdel(grilling)
	// 	return
	if(istype(grilling, /obj/item/weapon/reagent_containers/))
		var/obj/item/weapon/reagent_containers/food = grilling
		food.reagents.add_reagent("nutriment", 5)
		food.reagents.remove_reagent("vitamin", 5) //Downside I guess
		food.reagents.trans_to(grilling, food.reagents.total_volume)
	grilling.loc = get_turf(src)
	grilling.color = "#A34719"
	// grilling.name = I.name
	I.grill_amt++
	if(length(grilling.name) < 500) //grilling.name = "[pick("extra", "super", "hyper", "mega", "ultra")] grilled [initial(grilling.name)]"
		grilling.name = "grilled [grilling.name]"
	// var/tuple = tuple(I.grill_amt) //quadruple grilled nuke disk, woo
	// if(tuple)
	// 	tuple = "[tuple] "
	// if(findtext(grilling.prepo, "deep fried"))
	// 	var/a = tuple(grilling.fry_amt)
	// 	if(a) a = "[a] "
	// 	grilling.prepo = "[a]deep fried [tuple]grilled "
	// else
	// 	grilling.prepo = "[tuple]grilled "
	grilling = null
	qdel(img)