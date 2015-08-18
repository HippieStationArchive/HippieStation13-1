/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/proc/burn_tile()

/turf/simulated/proc/MakeSlippery(var/wet_setting = 1) // 1 = Water, 2 = Lube
	if(wet >= wet_setting)
		return
	wet = wet_setting
	if(wet_setting == 1)
		if(wet_overlay)
			overlays -= wet_overlay
			wet_overlay = null
		wet_overlay = image('icons/effects/water.dmi', src, "wet_floor_static")
		overlays += wet_overlay

	spawn(rand(790, 820)) // Purely so for visual effect
		if(!istype(src, /turf/simulated)) //Because turfs don't get deleted, they change, adapt, transform, evolve and deform. they are one and they are all.
			return
		if(wet > wet_setting) return
		wet = 0
		if(wet_overlay)
			overlays -= wet_overlay

/turf/simulated/Entered(atom/A, atom/OL)
	..()
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)	return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M

			if(H.pinned_to) //Pinning removal on forced movement... please don't yell at me, this is the only way to reliably do it
				H.do_pindown(H.pinned_to, 0)
				H.pinned_to = null
				H.anchored = 0
				H.update_canmove()

			var/bloodcolor
			// Tracking blood
			var/list/blood_DNA = list()
			var/new_track_blood = 0
			var/obj/item/clothing/shoes/S
			if(H.shoes)
				S = H.shoes
				if(S.track_blood && S.blood_DNA)
					blood_DNA |= S.blood_DNA.Copy()
					bloodcolor = S.blood_color
					new_track_blood = S.track_blood
			else
				if(H.track_blood && H.feet_blood_DNA)
					blood_DNA |= H.feet_blood_DNA.Copy()
					bloodcolor = H.feet_blood_color
					new_track_blood = H.track_blood

			if (blood_DNA.len)
				src.AddTracks(/obj/effect/decal/cleanable/blood/trackss/footprints,blood_DNA,H.dir,0,new_track_blood,bloodcolor) // Coming
				new_track_blood -= 0.5
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/trackss/footprints,blood_DNA,0,H.dir,new_track_blood,bloodcolor) // Going
					new_track_blood -= 0.5

			if(S)
				S.track_blood = new_track_blood
			else
				H.track_blood = new_track_blood

			blood_DNA = null

		switch (src.wet)
			if(1) //wet floor
				if(!M.slip(4, 2, null, (NO_SLIP_WHEN_WALKING|STEP)))
					M.inertia_dir = 0
				return

			if(2) //lube
				M.slip(0, 7, null, (STEP|SLIDE|GALOSHES_DONT_HELP))

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodamt,var/bloodcolor="#A10808")
	// world.log << "Called AddTracks for turf"
	var/obj/effect/decal/cleanable/blood/trackss/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodamt, bloodcolor)