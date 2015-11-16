/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's red and gooey. Perhaps it's the chef's cooking?"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/list/viruses = list()
	var/nostep = 0 //used by onwall bloods
	blood_DNA = list()
	blood_state = BLOOD_STATE_HUMAN
	bloodiness = MAX_SHOE_BLOODINESS

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	viruses = null
	return ..()

/obj/effect/decal/cleanable/blood/New()
	..()
	if(src.type == /obj/effect/decal/cleanable/blood)
		if(src.loc && isturf(src.loc))
			for(var/obj/effect/decal/cleanable/blood/B in src.loc)
				if(B != src)
					if (B.blood_DNA)
						blood_DNA |= B.blood_DNA.Copy()
					qdel(B)

/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/effect/decal/cleanable/blood/hitsplatter
	name = "blood splatter"
	pass_flags = PASSTABLE | PASSGRILLE
	random_icon_states = list("hitsplatter1", "hitsplatter2", "hitsplatter3")
	var/splattering = 0
	var/turf/prev_loc
	var/mob/living/blood_source
	var/skip = 0 //Skip creation of blood when destroyed?
	var/amount = 3

/obj/effect/decal/cleanable/blood/hitsplatter/proc/GoTo(turf/T, var/n=rand(1, 3))
	for(var/i in 1 to n)
		if(!src)
			return
		if(splattering)
			return
		prev_loc = loc
		step_towards(src,T)
		if(!src)
			return
		sleep(2)
	if(T.contents.len)
		for(var/obj/item/I in T.contents)
			I.add_blood(blood_source)
	qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/New()
	..()
	prev_loc = loc //Just so we are sure prev_loc exists


/obj/effect/decal/cleanable/blood/hitsplatter/Bump(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_blood(blood_source)
	if(istype(A, /turf/simulated/wall))
		if(istype(prev_loc)) //var definition already checks for type
			loc = A
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			skip = 1
			sleep(3)
			var/mob/living/carbon/human/H = blood_source
			if(istype(H))
				var/obj/effect/decal/cleanable/blood/splatter/B = new(prev_loc)
				//Adjust pixel offset to make splatters appear on the wall
				if(istype(B))
					B.pixel_x = dir & EAST ? 32 : (dir & WEST ? -32 : 0)
					B.pixel_y = dir & NORTH ? 32 : (dir & SOUTH ? -32 : 0)
					B.nostep = 1
			qdel(src)
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			loc = A //Either way we got this.
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			sleep(3)
			qdel(src)
		return

	qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Crossed(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_blood(blood_source)
		amount--
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.wear_suit)
			H.wear_suit.add_blood(H)
			H.update_inv_wear_suit(0)    //updates mob overlays to show the new blood (no refresh)
		else if(H.w_uniform)
			H.w_uniform.add_blood(H)
			H.update_inv_w_uniform(0)    //updates mob overlays to show the new blood (no refresh)
		amount--

	if(istype(A, /turf/simulated/wall))
		if(istype(prev_loc)) //var definition already checks for type
			loc = A
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			skip = 1
			sleep(3)
			var/mob/living/carbon/human/H = blood_source
			if(istype(H))
				var/obj/effect/decal/cleanable/blood/splatter/B = new(prev_loc)
				//Adjust pixel offset to make splatters appear on the wall
				if(istype(B))
					B.pixel_x = dir & EAST ? 32 : (dir & WEST ? -32 : 0)
					B.pixel_y = dir & NORTH ? 32 : (dir & SOUTH ? -32 : 0)
					B.nostep = 1
			qdel(src)
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			loc = A //Either way we got this.
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			sleep(3)
			qdel(src)
		return

	if(amount <= 0)
		qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Destroy()
	if(istype(loc, /turf/simulated) && !skip)
		blood_splatter(loc,blood_source,1)
	..()

//Splatter effect END

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null

/obj/effect/decal/cleanable/trail_holder //not a child of blood on purpose
	name = "blood"
	icon_state = "ltrails_1"
	desc = "Your instincts say you shouldn't be following these."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	random_icon_states = null
	var/list/existing_dirs = list()
	blood_DNA = list()


/obj/effect/decal/cleanable/trail_holder/can_bloodcrawl_in()
	return 1


/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")

/obj/effect/decal/cleanable/blood/gibs/New()
	..()
	reagents.add_reagent("liquidgibs", 5)

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(src.loc)
				for(var/datum/disease/D in src.viruses)
					var/datum/disease/ND = D.Copy(1)
					b.viruses += ND
					ND.holder = b
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's red."
	gender = PLURAL
	icon = 'icons/effects/drip.dmi'
	icon_state = "1"
	random_icon_states = list("1","2","3","4","5")
	bloodiness = 0
	var/list/drips = list()

/obj/effect/decal/cleanable/blood/drip/New()
	..()
	spawn(1)
		drips |= icon_state

/obj/effect/decal/cleanable/blood/drip/can_bloodcrawl_in()
	return 1


//BLOODY FOOTPRINTS
/obj/effect/decal/cleanable/blood/footprints
	name = "footprints"
	icon = 'icons/effects/footprints.dmi'
	icon_state = "nothingwhatsoever"
	desc = "where might they lead?"
	gender = PLURAL
	random_icon_states = null
	var/entered_dirs = 0
	var/exited_dirs = 0
	blood_state = BLOOD_STATE_HUMAN //the icon state to load images from
	var/list/shoe_types = list()

/obj/effect/decal/cleanable/blood/footprints/Crossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.bloody_shoes[blood_state])
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			entered_dirs|= H.dir
			shoe_types |= H.shoes.type
	update_icon()

/obj/effect/decal/cleanable/blood/footprints/Uncrossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.bloody_shoes[blood_state])
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			exited_dirs|= H.dir
			shoe_types |= H.shoes.type
	update_icon()

/obj/effect/decal/cleanable/blood/footprints/update_icon()
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


/obj/effect/decal/cleanable/blood/footprints/examine(mob/user)
	. = ..()
	if(shoe_types.len)
		. += "You recognise the footprints as belonging to:\n"
		for(var/shoe in shoe_types)
			var/obj/item/clothing/shoes/S = shoe
			. += "some <B>[initial(S.name)]</B> \icon[S]\n"

	user << .


/obj/effect/decal/cleanable/blood/footprints/can_bloodcrawl_in()
	if((blood_state != BLOOD_STATE_OIL) && (blood_state != BLOOD_STATE_NOT_BLOODY))
		return 1
	return 0

