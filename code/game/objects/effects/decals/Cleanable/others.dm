/obj/effect/decal/cleanable/poop
	name = "poop"
	desc = "Holy shit, what is that smell?"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	random_icon_states = list("pfloor1","pfloor2","pfloor3","pfloor4")
	var/list/viruses = list()
	var/poop_DNA = list("UNKNOWN DNA" = "X*")
	bloodiness = MAX_SHOE_BLOODINESS
	blood_state = BLOOD_STATE_POOP

/obj/effect/decal/cleanable/poop/New()
	..()
	reagents.add_reagent("poop", 40)
	icon_state = pick("pfloor1","pfloor2","pfloor3","pfloor4")
	if(istype(loc,/turf/simulated))
		if(prob(30))
			var/turf/simulated/T = loc
			T.MakeSlippery(TURF_WET_WATER, 300) //30 seconds

/obj/effect/decal/cleanable/poop/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	viruses = null
	return ..()

/proc/poop_splatter(target)
	var/turf/T = get_turf(target)
	var/obj/effect/decal/cleanable/poop/GG = locate() in T.contents
	if(!GG)
		GG = new/obj/effect/decal/cleanable/poop(T)

/obj/effect/decal/cleanable/poop/footprints
	name = "footprints"
	icon = 'icons/effects/footprints.dmi'
	icon_state = "nothingwhatsoever"
	desc = "where might they lead?"
	gender = PLURAL
	random_icon_states = null
	var/entered_dirs = 0
	var/exited_dirs = 0
	blood_state = BLOOD_STATE_POOP //the icon state to load images from
	var/list/shoe_types = list()

/obj/effect/decal/cleanable/poop/footprints/Crossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.bloody_shoes[blood_state])
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			entered_dirs|= H.dir
			shoe_types |= H.shoes.type
	update_icon()

/obj/effect/decal/cleanable/poop/footprints/Uncrossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.bloody_shoes[blood_state])
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			exited_dirs|= H.dir
			shoe_types |= H.shoes.type
	update_icon()

//obj/effect/decal/cleanable/poop/footprints/update_icon()
	overlays.Cut()

	for(var/Ddir in cardinal)
		if(entered_dirs & Ddir)
			var/image/I
			if(bloody_footprints_cache["entered-[blood_state]-[Ddir]"])
				I = bloody_footprints_cache["entered-[blood_state]-[Ddir]"]
			else
				I =  image(icon,"[blood_state]1",dir = Ddir)
				bloody_footprints_cache["entered-[blood_state]-[Ddir]"] = I
			if(I)
				overlays += I
		if(exited_dirs & Ddir)
			var/image/I
			if(bloody_footprints_cache["exited-[blood_state]-[Ddir]"])
				I = bloody_footprints_cache["exited-[blood_state]-[Ddir]"]
			else
				I = image(icon,"[blood_state]2",dir = Ddir)
				bloody_footprints_cache["exited-[blood_state]-[Ddir]"] = I
			if(I)
				overlays += I

	alpha = BLOODY_FOOTPRINT_BASE_ALPHA+bloodiness


/obj/effect/decal/cleanable/poop/footprints/examine(mob/user)
	. = ..()
	if(shoe_types.len)
		. += "You recognise the footprints as belonging to:\n"
		for(var/shoe in shoe_types)
			var/obj/item/clothing/shoes/S = shoe
			. += "some <B>[initial(S.name)]</B> \icon[S]\n"

	user << .