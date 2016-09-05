/obj/machinery/cerealmaker
	name = "cereal maker"
	desc = "Now with Lawli'Os available!"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "cereal_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it making cereal already?

/obj/machinery/cerealmaker/attackby(obj/item/I, mob/user)
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
	if(!istype(I, /obj/item/weapon/reagent_containers/food/snacks/))
		user << "<span class='warning'>Budget cuts won't let you put that in there.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/cereal/))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	user << "<span class='notice'>You put [I] into [src].</span>"
	on = TRUE
	user.drop_item()
	I.loc = src
	icon_state = "cereal_on"
	sleep(200)
	icon_state = "cereal_off"
	var/obj/item/weapon/reagent_containers/food/snacks/cereal/S = new(get_turf(src))
	var/icon/img = icon(I.icon, I.icon_state)
	var/icon/cerealbox_icon = icon(initial(S.icon), "[S.icon_state]_mask", , 1)
	for(var/i = 1, i <= I.overlays.len, i++)
		// world << "[i], [I.overlays.len] len, \icon[I.overlays[i]] overlay"
		var/image/overlay = I.overlays[i]
		img.Blend(icon(overlay.icon, overlay.icon_state), ICON_OVERLAY)
	cerealbox_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
	cerealbox_icon.Blend(img, ICON_MULTIPLY) //adds item image and the remaining white areas become transparant
	cerealbox_icon = fcopy_rsc(cerealbox_icon)
	if(istype(I, /obj/item/weapon/reagent_containers/))
		var/obj/item/weapon/reagent_containers/food = I
		food.reagents.trans_to(S, food.reagents.total_volume)
	S.overlays += cerealbox_icon
	S.name = "box of [I] cereal"
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -7)
	on = FALSE
	qdel(I)

