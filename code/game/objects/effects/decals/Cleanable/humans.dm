#define DRYING_TIME 5 * (60*10) //How many minutes does it take for our blood to dry up? Change the first number to change mins.

/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's red and gooey. Perhaps it's the chef's cooking?"
	var/dryname = "dried blood"
	var/drydesc = "It's dry and crusty. Someone is not doing their job."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	blood_DNA = list()
	var/list/viruses = list()
	var/amount = 5
	var/nostep = 0 //used by onwall bloods
	var/creation_time = 0

	var/base_icon = 'icons/effects/blood.dmi'
	var/basecolor = "#A10808" //Color when wet

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	..()

/obj/effect/decal/cleanable/blood/New(loc, var/spawncolor)
	..()
	if(spawncolor)
		basecolor = spawncolor
	update_icon()
	creation_time = world.time
	remove_ex_blood()
	spawn(DRYING_TIME * (amount+1))
		dry()

/obj/effect/decal/cleanable/blood/proc/remove_ex_blood() //removes existant blood on the turf
	if(src.loc && isturf(src.loc))
		for(var/obj/effect/decal/cleanable/blood/B in src.loc)
			if(B != src)
				if (B.blood_DNA)
					blood_DNA |= B.blood_DNA.Copy()
				qdel(B)

/obj/effect/decal/cleanable/blood/update_icon()
	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

/obj/effect/decal/cleanable/blood/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1 || nostep)
		return

	if(perp.shoes && !perp.buckled)//Adding blood to shoes
		var/obj/item/clothing/shoes/S = perp.shoes
		if(istype(S))
			S.blood_color = basecolor
			S.track_blood = max(amount,S.track_blood)
			if(!S.blood_overlay)
				S.generate_blood_overlay()
			if(!S.blood_DNA)
				S.blood_DNA = list()
				S.blood_overlay.color = basecolor
				S.overlays += S.blood_overlay
			if(S.blood_overlay && S.blood_overlay.color != basecolor)
				S.blood_overlay.color = basecolor
				S.overlays.Cut()
				S.overlays += S.blood_overlay
			S.blood_DNA |= blood_DNA.Copy()
	else
		perp.feet_blood_color = basecolor
		perp.track_blood = max(amount,perp.track_blood)
		if(!perp.feet_blood_DNA)
			perp.feet_blood_DNA = list()
		perp.feet_blood_DNA |= blood_DNA.Copy()

	perp.update_inv_shoes(1)
	amount -= 3
	if(amount < 0) amount = 0

/obj/effect/decal/cleanable/blood/proc/dry()
	name = dryname
	desc = drydesc
	color = adjust_brightness(color, -50)
	amount = 0

/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		add_fingerprint(user)
		var/taken = rand(1,amount)
		amount -= taken
		if (user.gloves)
			user << "<span class='notice'>You get some of \the [src] on your gloves.</span>"
			user.gloves.blood_DNA |= blood_DNA.Copy()
			var/obj/item/clothing/gloves/G = user.gloves
			G.transfer_blood += taken
			G.blood_color = basecolor
		else
			user << "<span class='notice'>You get some of \the [src] on your hands.</span>"
			if (!user.blood_DNA)
				user.blood_DNA = list()
			user.blood_DNA |= blood_DNA.Copy()
			user.bloody_hands += taken
			user.hand_blood_color = basecolor

		user.update_inv_gloves(1)
		user.verbs += /mob/living/carbon/human/proc/bloody_doodle

/obj/effect/decal/cleanable/blood/splatter
	name = "blood splatter"
	desc = "Someone must've been gutted in front of this."
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")
	amount = 3

/obj/effect/decal/cleanable/blood/splatter/remove_ex_blood() //removes existant blood splatters on the turf. Handled this way because we adjust pixel offset most of the time.
	if(src.loc && isturf(src.loc))
		for(var/obj/effect/decal/cleanable/blood/splatter/B in src.loc)
			if(B != src)
				qdel(B)

//New splatter effect
/obj/effect/effect/splatter //Used for blood effects coming outta ya
	name = "blood splatter"
	icon = 'icons/effects/blood.dmi'
	anchored = 1.0
	// layer = 3
	pass_flags = PASSTABLE | PASSGRILLE
	var/list/viruses = list()
	blood_DNA = list()
	var/mob/living/blood_source
	var/random_icon_states = list("splatter1", "splatter2", "splatter3")
	var/amount = 3
	var/splattering = 0
	var/turf/prev_loc
	var/skip = 0 //Skip creation of blood when destroyed?
	var/basecolor = "#A10808" //Color of the blood

/obj/effect/effect/splatter/proc/GoTo(turf/T, var/n=rand(1, 3))
	for(var/i=0, i<=n, i++)
		if(!src)
			return
		if(splattering)
			return
		prev_loc = loc
		step_towards(src,T)
		if(!src)
			return
		sleep(2)
	qdel(src)

/obj/effect/effect/splatter/New()
	if (random_icon_states && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)
	..()
	prev_loc = loc //Just so we are sure prev_loc exists
	update_icon()

/obj/effect/effect/splatter/update_icon()
	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

/obj/effect/effect/splatter/Bump(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_blood(blood_source)
	if(istype(A, /turf/simulated/wall))
		if(istype(prev_loc)) //var definition already checks for type
			src.loc = A
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			skip = 1
			sleep(3)
			var/obj/effect/decal/cleanable/blood/B = prev_loc.add_blood_floor(blood_source, 1)
			//Adjust pixel offset to make splatters appear on the wall
			if(istype(B))
				B.pixel_x = dir & EAST ? 32 : (dir & WEST ? -32 : 0)
				B.pixel_y = dir & NORTH ? 32 : (dir & SOUTH ? -32 : 0)
				B.basecolor = basecolor
				B.nostep = 1
				update_icon()
			qdel(src)
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			src.loc = A //Either way we got this.
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			sleep(3)
			qdel(src)
		return

	qdel(src)

/obj/effect/effect/splatter/Crossed(atom/A)
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
			src.loc = A
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			skip = 1
			sleep(3)
			var/obj/effect/decal/cleanable/blood/B = prev_loc.add_blood_floor(blood_source, 1)
			//Adjust pixel offset to make splatters appear on the wall
			if(istype(B))
				B.pixel_x = dir & EAST ? 32 : (dir & WEST ? -32 : 0)
				B.pixel_y = dir & NORTH ? 32 : (dir & SOUTH ? -32 : 0)
				B.basecolor = basecolor
				B.nostep = 1
				update_icon()
			qdel(src)
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			src.loc = A //Either way we got this.
			splattering = 1 //So "Bump()" and "Crossed()" procs aren't called at the same time
			sleep(3)
			qdel(src)
		return

	if(amount <= 0)
		qdel(src)

/obj/effect/effect/splatter/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	if(istype(src.loc, /turf/simulated) && !skip)
		src.loc.add_blood_floor(blood_source, 1)
	..()

//Splatter effect END

/obj/effect/decal/cleanable/blood/trail_holder //It wasn't specified WHY this isn't a child of blood so now it is.
	name = "blood"
	icon_state = "blank"
	desc = "Your instincts say you shouldn't be following these."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	random_icon_states = null
	var/list/existing_dirs = list()
	//blood_DNA = list()
	//var/mob/living/blood_source
	amount = 0 //Footprints are looking weiiiiiiiird

/obj/effect/decal/cleanable/blood/trail_holder/remove_ex_blood()
	return //Overwritten.

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/gibs.dmi'
	base_icon = 'icons/effects/gibs.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	var/fleshcolor = "#FFCA95" //Placeholder color

/obj/effect/decal/cleanable/blood/gibs/update_icon()
	var/image/giblets = new(base_icon, "[icon_state]_flesh", dir)
	if(!fleshcolor || fleshcolor == "rainbow")
		fleshcolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	giblets.color = fleshcolor

	var/icon/blood = new(base_icon,"[icon_state]",dir)
	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	blood.Blend(basecolor,ICON_MULTIPLY)

	icon = blood
	overlays.Cut()
	overlays += giblets

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/blood/gibs/remove_ex_blood()
    return

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibtorso") //"gibhead" icon missing for now

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions)
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
	name = "blood drip"
	desc = "Someone must've been bleeding."
	dryname = "dried blood drip"
	drydesc = "It's dry and crusty. Someone is not doing their job."
	icon = 'icons/effects/drip.dmi'
	icon_state = "1"
	random_icon_states = list("1", "2", "3")
	layer = 2
	var/mob/living/blood_source
	amount = 0

/obj/effect/decal/cleanable/blood/drip/New()
	..()
	pixel_x = rand(-6, 6)	//Randomizes pixel
	pixel_y = rand(-6, 6)
	remove_ex_blood()

/obj/effect/decal/cleanable/blood/drip/remove_ex_blood() //removes excessive blood drips on the turf
	if(src.loc && isturf(src.loc))
		var/list/blood = list()
		//var/turf/T = src.loc
		for(var/obj/effect/decal/cleanable/blood/drip/B in src.loc)
			blood += B
		if(blood.len > 4) //fuk ye this works
			qdel(pick(blood))

/obj/effect/decal/cleanable/blood/palmprint
	name = "bloody palmprint"
	desc = "Huh. Scary."
	gender = NEUTER
	random_icon_states = list("palmprint1", "palmprint2")
	amount = 0

/obj/effect/decal/cleanable/blood/palmprint/remove_ex_blood() //INFINITE WALL PALMPRINTS WOOO
	return