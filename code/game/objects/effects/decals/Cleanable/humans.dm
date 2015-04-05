/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's red and gooey. Perhaps it's the chef's cooking?"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	var/base_icon = 'icons/effects/blood.dmi' //For upcoming /vg/-style blood coloring
	var/basecolor = "#AE0C0C"
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/list/viruses = list()
	blood_DNA = list()
	var/mob/living/blood_source
	var/amount = 5
	var/creation_time = 0

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	..()

/obj/effect/decal/cleanable/blood/New()
	..()
	remove_ex_blood()
	creation_time = world.time

/obj/effect/decal/cleanable/blood/proc/remove_ex_blood() //removes existant blood on the turf
	if(src.loc && isturf(src.loc))
		for(var/obj/effect/decal/cleanable/blood/B in src.loc)
			if(B != src)
				qdel(B)

/obj/effect/decal/cleanable/blood/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1)
		return

	if(perp.shoes)
		perp.shoes:track_blood = max(amount,perp.shoes:track_blood)                //Adding blood to shoes
		if(!perp.shoes.blood_DNA)
			perp.shoes.blood_DNA = list()
		perp.shoes.blood_DNA = blood_DNA.Copy()
		// perp.shoes.track_blood_type = src.type
		if(istype(blood_source))
			perp.shoes.add_blood(blood_source) //This doesn't work half the time. We need a add_blood_from_dna proc.
		perp.update_inv_shoes()
	else
		perp.track_blood = max(amount,perp.track_blood)                                //Or feet
		if(!perp.feet_blood_DNA)
			perp.feet_blood_DNA = list()
		perp.feet_blood_DNA = blood_DNA.Copy()
		perp.feet_blood_color=basecolor //Currently unused

	amount -= 3
	if(amount < 0) amount = 0

/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		add_fingerprint(user)
		if (user.gloves)
			user << "<span class='notice'>You can't do that with gloves!</span>"
			return
		var/taken = rand(1,amount)
		amount -= taken
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

/obj/effect/effect/splatter/proc/GoTo(turf/T, var/n=rand(1, 3))
	for(var/i=0, i<=n, i++)
		if(!src)
			return
		if(splattering)
			return
		step_towards(src,T)
		if(!src)
			return
		sleep(2)
	qdel(src)

/obj/effect/effect/splatter/New()
	if (random_icon_states && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)
	..()

/obj/effect/effect/splatter/Bump(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_blood(blood_source)
	if(istype(A, /turf/simulated/wall))
		// var/turf/simulated/wall/T = A
		src.loc = A
		splattering = 1
		sleep(3)
		qdel(src)
		return

	qdel(src)

/obj/effect/effect/splatter/Crossed(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_blood(blood_source)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.wear_suit)
			H.wear_suit.add_blood(H)
			H.update_inv_wear_suit(0)    //updates mob overlays to show the new blood (no refresh)
		else if(H.w_uniform)
			H.w_uniform.add_blood(H)
			H.update_inv_w_uniform(0)    //updates mob overlays to show the new blood (no refresh)

	if(istype(A, /turf/simulated/wall))
		// var/turf/simulated/wall/T = A
		src.loc = A
		splattering = 1
		sleep(3)
		qdel(src)
		return

	if(amount <= 0)
		qdel(src)

/obj/effect/effect/splatter/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	if(istype(src.loc, /turf/simulated))
		src.loc.add_blood_floor(blood_source, 1)
	..()

//Splatter effect END

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null

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
	amount = 2

/obj/effect/decal/cleanable/blood/trail_holder/remove_ex_blood()
	return //Overwritten.

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

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/blood/gibs/remove_ex_blood()
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

/obj/effect/decal/cleanable/drip //it's seperate so it can stack drips
	name = "blood drip"
	desc = "Someone must've been bleeding."
	icon = 'icons/effects/drip.dmi'
	icon_state = "1"
	random_icon_states = list("1", "2", "3")
	gender = NEUTER
	layer = 2
	blood_DNA = list()
	var/mob/living/blood_source

/obj/effect/decal/cleanable/drip/New()
	..()
	pixel_x = rand(-6, 6)	//Randomizes postion
	pixel_y = rand(-6, 6)
	remove_ex_blood()

/obj/effect/decal/cleanable/drip/proc/remove_ex_blood() //removes excessive blood drips on the turf
	if(src.loc && isturf(src.loc))
		var/list/blood = list()
		//var/turf/T = src.loc
		for(var/obj/effect/decal/cleanable/drip/B in src.loc)
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