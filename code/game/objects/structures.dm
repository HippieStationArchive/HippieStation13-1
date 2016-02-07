/obj/structure
	icon = 'icons/obj/structures.dmi'
	pressure_resistance = 8

/obj/structure/New()
	..()
	if(smooth)
		smooth_icon(src)
		smooth_icon_neighbors(src)
		icon_state = ""
	if(ticker)
		cameranet.updateVisibility(src)

/obj/structure/blob_act()
	if(prob(50))
		qdel(src)

/obj/structure/Destroy()
	if(ticker)
		cameranet.updateVisibility(src)
	if(opacity)
		UpdateAffectingLights()
	if(smooth)
		smooth_icon_neighbors(src)
	return ..()

/obj/structure/mech_melee_attack(obj/mecha/M)
	if(M.damtype == BRUTE)
		visible_message("<span class='danger'>[M.name] has hit [src].</span>")
		return 1
	return 0
