
/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	layer = 3.1 //so the stuffing animation isn't weird as shit
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/typeofmeat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	var/meat_produced = 0
	var/ignore_clothing = 0
	var/locked = 0 //Used to prevent mobs from breaking the feedin anim
	var/bloodToUse = "#A10808" //Either use green xenomorph blood or red human blood. Default red is #A10808
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in cardinal)
			var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					qdel(input_obj)
					break

		if(!input_plate)
			diary << "a [src] didn't find an input plate."
			return

/obj/machinery/gibber/autogibber/Bumped(atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate)
			M.loc = src
			M.gib()


/obj/machinery/gibber/New()
	..()
	src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/gibber(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	RefreshParts()

/obj/machinery/gibber/RefreshParts()
	var/gib_time = 40
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		meat_produced += 3 * B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		gib_time -= 5 * M.rating
		gibtime = gib_time
		if(M.rating >= 2)
			ignore_clothing = 1

/obj/machinery/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		var/image/I = image('icons/obj/kitchen.dmi', "grbloody")
		I.color = bloodToUse
		overlays += I
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	else if (operating)
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")
	else
		src.overlays += image('icons/obj/kitchen.dmi', "gridle")

/obj/machinery/gibber/clean_blood()
	..()
	dirty = 0
	update_icon()

/obj/machinery/gibber/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/gibber/container_resist()
	src.go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << "<span class='danger'>It's locked and running.</span>"
		return
	if(locked)
		user << "<span class='danger'>Wait for [occupant.name] to finish being loaded!</span>"
		return
	if(occupant)
		src.startgibbing(user)

/obj/machinery/gibber/attackby(obj/item/P, mob/user, params)
	if (istype(P, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = P
		if(!iscarbon(G.affecting))
			user << "<span class='danger'>This item is not suitable for the gibber!</span>"
			return
		var/mob/living/carbon/C = G.affecting
		if(C.buckled ||C.buckled_mob)
			user << "<span class='warning'>[C] is attached to something!</span>"
			return
		if(C.abiotic(1) && !ignore_clothing)
			user << "<span class='danger'>Subject may not have abiotic items on.</span>"
			return
		if(occupant)
			user << "<span class='warning'>There's already something inside!</span>"
			return
		user.visible_message("<span class='danger'>[user] starts to put [G.affecting] into the gibber!</span>")
		src.add_fingerprint(user)
		if(do_after(user, gibtime, target = src) && G && G.affecting && G.affecting == C && !C.buckled && !C.buckled_mob && !occupant)
			user.visible_message("<span class='danger'>[user] stuffs [G.affecting] into the gibber!</span>")
			if(C.client)
				C.client.perspective = EYE_PERSPECTIVE
				C.client.eye = src
			var/turf/prevloc = C.loc
			C.loc = src
			occupant = C
			qdel(G)
			update_icon()
			StuffAnim(prevloc)

	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", P))
		return

	if(exchange_parts(user, P))
		return

	if(default_pry_open(P))
		return

	if(default_unfasten_wrench(user, P))
		return

	default_deconstruction_crowbar(P)



/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "empty gibber"
	set src in oview(1)

	if(usr.incapacitated())
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	if (locked)
		return
	dropContents()
	update_icon()

/obj/machinery/gibber/proc/StuffAnim(var/turf/prevloc)
	if(!src.occupant)
		return

	src.locked = 1
	var/turf/newloc = src.loc
	if(prevloc) newloc = prevloc

	if(!isturf(newloc)) return
	var/obj/effect/overlay/feedee = new(newloc)
	feedee.name = src.occupant.name
	feedee.icon = getFlatIcon(src.occupant)

	var/matrix/span1 = matrix(feedee.transform)
	sleep (5)
	span1.Turn(60)
	var/matrix/span2 = matrix(feedee.transform)
	span2.Turn(120)
	var/matrix/span3 = matrix(feedee.transform)
	span3.Turn(180)
	animate(feedee, transform = span1, pixel_y = 15, time=2)
	animate(transform = span2, pixel_y = 25, time = 1) //If we instantly turn the guy 180 degrees he'll just pop out and in of existance all weird-like
	animate(transform = span3, time = 2, easing = ELASTIC_EASING)
	sleep(2)
	if(!feedee)
		locked = 0
		return
	feedee.loc = src.loc
	sleep(3)
	if(!feedee)
		locked = 0
		return
	feedee.layer = src.layer - 0.1
	animate(feedee, pixel_y = -5, time=20)
	sleep(5)
	if(!feedee)
		locked = 0
		return
	feedee.icon += icon('icons/obj/kitchen.dmi', "cuticon")
	sleep(15)
	if(feedee)
		qdel(feedee)
	locked = 0

/obj/machinery/gibber/proc/startgibbing(mob/user)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='italics'>You hear a loud metallic grinding sound.</span>")
		return
	use_power(1000)
	visible_message("<span class='italics'>You hear a loud squelchy grinding sound.</span>")
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
	src.operating = 1
	dirty = 1
	if(isalien(occupant))
		bloodToUse = "green"
	else
		bloodToUse = "#A10808"
	update_icon()
	var/image/blood = new('icons/obj/kitchen.dmi', "grinding")
	blood.color = bloodToUse
	overlays += blood
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
	var/sourcename = src.occupant.real_name
	var/sourcenutriment = src.occupant.nutrition / 15
	var/sourcetotalreagents = src.occupant.reagents.total_volume

	var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/allmeat[meat_produced]

	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		if(gibee.dna && gibee.dna.species)
			typeofmeat = gibee.dna.species.meat
		else
			typeofmeat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	else
		if(iscarbon(occupant))
			var/mob/living/carbon/C = occupant
			typeofmeat = C.type_of_meat
	for (var/i=1 to meat_produced)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/newmeat = new typeofmeat
		newmeat.name = sourcename + newmeat.name
		newmeat.subjectname = sourcename
		newmeat.reagents.add_reagent ("nutriment", sourcenutriment / meat_produced) // Thehehe. Fat guys go first
		src.occupant.reagents.trans_to (newmeat, round (sourcetotalreagents / meat_produced, 1)) // Transfer all the reagents from the
		allmeat[i] = newmeat

	add_logs(user, occupant, "gibbed")
	src.occupant.death(1)
	src.occupant.ghostize()
	qdel(src.occupant)
	spawn(src.gibtime)

		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/i=1 to meat_produced)
			var/obj/item/meatslab = allmeat[i]
			var/turf/Tx = locate(x - rand(1,3), y, z)
			meatslab.loc = src.loc
			if(Tx) //Honestly I don't think someone would build a gibber at the edge of the z-level but hey
				meatslab.throw_at(Tx,i,3)
		if(bloodToUse == "#A10808")
			new /obj/effect/gibspawner/human(loc)
		else
			new /obj/effect/gibspawner/xeno(loc)

		pixel_x = initial(pixel_x) //return to its spot after shaking
		src.operating = 0
		update_icon()


