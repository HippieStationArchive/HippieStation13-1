/mob/living/carbon/human/gib_animation(var/animate)
	..(animate, "gibbed-h")

/mob/living/carbon/human/dust_animation(var/animate)
	..(animate, "dust-h")

/mob/living/carbon/human/dust(var/animation = 1)
	..()

/mob/living/carbon/human/spawn_gibs()
	if(dna)
		hgibs(loc, viruses, dna)
	else
		hgibs(loc, viruses, null)

/mob/living/carbon/human/spawn_dust()
	new /obj/effect/decal/remains/human(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)	return
	if(healths)		healths.icon_state = "health5"
	stat = DEAD
	dizziness = 0
	jitteriness = 0

	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	if(!gibbed)
		emote("deathgasp") //let the world KNOW WE ARE DEAD

		update_canmove()
		if(client) blind.layer = 0

	if(dna)
		dna.species.spec_death(gibbed,src)

	tod = worldtime2text()		//weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)
	if(ticker && ticker.mode)
//		world.log << "k"
		sql_report_death(src)
		ticker.mode.check_win()		//Calls the rounds wincheck, mainly for wizard, malf, and changeling now
	return ..(gibbed)

/mob/living/carbon/human/end_animation(var/animate) //This is the best place to handle this in
	for(var/obj/item/organ/limb/L in organs)
		if(L.embedded.len)
			for(var/obj/item/I in L.embedded)
				L.embedded -= I
				I.loc = get_turf(src)
				if(istype(I, /obj/item/weapon/paper))
					var/obj/item/weapon/paper/P = I
					P.attached = null
					I.update_icon()
				var/atom/target = get_edge_target_turf(I, get_dir(I, get_step_away(I, I)))
				I.throw_at(target, rand(1, 3), 1)
	if(l_hand)
		var/obj/item/E = l_hand
		E.loc = get_turf(src)
		var/atom/Ltarg = get_edge_target_turf(E, get_dir(E, get_step_away(E, E)))
		E.throw_at(Ltarg, rand(1, 3), 1)
	if(r_hand)
		var/obj/item/R = r_hand
		R.loc = get_turf(src)
		var/atom/Rtarg = get_edge_target_turf(R, get_dir(R, get_step_away(R, R)))
		R.throw_at(Rtarg, rand(1, 3), 1)
	..()

/mob/living/carbon/human/proc/makeSkeleton()
	if(!check_dna_integrity(src))	return
	status_flags |= DISFIGURED
	dna.species = new /datum/species/skeleton(src)
	return 1

/mob/living/carbon/proc/ChangeToHusk()
	if(HUSK in mutations)	return
	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	return 1

/mob/living/carbon/human/ChangeToHusk()
	. = ..()
	if(.)
		update_hair()
		update_body()

/mob/living/carbon/proc/Drain()
	ChangeToHusk()
	mutations |= NOCLONE
	return 1
