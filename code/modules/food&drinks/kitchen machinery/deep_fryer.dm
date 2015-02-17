//Warning: something here may or may not cause client crashes. I suspect it was the overly long names deepfryer caused.
//"Tuples" system brought back. See if it crashes anymore.

//Extra vars
/obj/item
	var/fry_amt = 0 //Amount of times this object was fried

/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it deep frying already?
	var/obj/item/frying = null	//What's being fried RIGHT NOW?

/obj/machinery/deepfryer/examine()
	..()
	if(frying)
		usr << "You can make out [frying] in the oil."

var/list/deepfry_icons = list()

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(on)
		user << "<span class='notice'>[src] is still active!</span>"
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
	if(istype(I, /obj/item/weapon/grab) || istype(I, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		user << "<span class='warning'>That would probably break [I].</span>"
		return
	// if(istype(I, /obj/item/weapon/disk/nuclear)) //Don't give chef the nuke disk. Seriously.
	// 	user << "Central Command would kill you if you deep fried that."
	// 	return
	user << "<span class='notice'>You put [I] into [src].</span>"
	on = TRUE
	user.drop_item()
	frying = I
	frying.loc = src
	icon_state = "fryer_on"
	sleep(200)

	if(frying && frying.loc == src)
		icon_state = "fryer_off"
		on = FALSE
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		// if(frying.fry_amt > 3 && prob(frying.fry_amt * 5)) //Don't overfry shit!
		// 	visible_message("<span class='danger'>[I] [pick("breaks", "crumbles", "burns")] in [src]!</span>")
		// 	new /obj/effect/decal/cleanable/ash(loc)
		// 	qdel(frying)
		// 	return

		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		if(istype(frying, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = frying
			food.reagents.trans_to(S, food.reagents.total_volume)

		// DEEPFRY OVERLAYS.

		// Horribly broken: causes crashes on clients due to the fact that it stacks deepfry overlays.
		// Also, uses initial icon_state instead of current one so the overlay itself can be weird for some items.

		// world << deepfry_icons.len
		// var/index = frying.blood_splatter_index()
		// var/icon/deepfry_icon = deepfry_icons[index]
		// if(!deepfry_icon)
		// 	deepfry_icon = icon(initial(frying.icon), initial(frying.icon_state), , 1)		//we only want to apply deepfry to the initial icon_state for each object
		// 	for(var/i = 1, i <= frying.overlays.len, i++)
		// 		var/image/overlay = frying.overlays[i]
		// 		deepfry_icon.Blend(icon(overlay.icon, overlay.icon_state), ICON_OVERLAY)
		// 	deepfry_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
		// 	deepfry_icon.Blend(icon('icons/effects/overlays.dmi', "itemfry"), ICON_MULTIPLY) //adds deepfry and the remaining white areas become transparant
		// 	deepfry_icon = fcopy_rsc(deepfry_icon)
		// 	deepfry_icon += rgb(0,0,0,128) //add alpha
		// 	deepfry_icons[index] = deepfry_icon
		// 	// world << "Creating deepfry icon for [frying]"
		// else
		// 	// world << "Deepfry for [frying] already exists."
		// 	frying.overlays.Remove(deepfry_icon) //To prevent client crashes caused by stacking deepfry overlays
		// 	//Based on varedit data it still lets like two deepfry overlays at once /SOMETIMES/. Needs testing.

		S.icon = frying.icon
		S.icon_state = frying.icon_state
		S.color = "#FFAD33"
		S.overlays += frying.overlays
		// S.overlays += deepfry_icon
		S.color = frying.color //keeps the grill

		S.name = frying.name //In case the if check for length fails so we don't name it "Deep Fried Food Holder Obj"
		if(length(S.name) < 500) //S.name = "[pick("extra", "super", "hyper", "mega", "ultra")] deep fried [initial(frying.name)]"
			S.name = "deep fried [frying.name]"
		S.fry_amt = frying.fry_amt + 1
		// var/tuple = tuple(S.fry_amt) //quadruple grilled nuke disk, woo --Causes lots of problems. Doesn't work correctly with cereals and other custom foods.
		// if(tuple)
		// 	tuple = "[tuple] "
		// if(findtext(frying.prepo, "grilled"))
		// 	var/a = tuple(frying.grill_amt)
		// 	if(a) a = "[a] "
		// 	S.prepo = "[tuple]deep fried [a]grilled "
		// else
		// 	S.prepo = "[tuple]deep fried "
		S.desc = I.desc
		if(istype(I, /obj/item/weapon/disk/nuclear))
			S.desc = "Welp. I guess Centcomm will have to bluespace ANOTHER nuke disk now."
		qdel(frying)

/obj/machinery/deepfryer/attack_hand(mob/user)
	if(on && frying)
		user << "<span class='notice'>You pull [frying] from [src]! It looks like you were just in time!</span>"
		user.put_in_hands(frying)
		frying = null
		icon_state = "fryer_off"
		on = FALSE
		return
	..()