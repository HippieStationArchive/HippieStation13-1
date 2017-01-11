/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to



/turf/simulated/proc/burn_tile()

/turf/simulated/proc/MakeSlippery(wet_setting = TURF_WET_WATER, time=790) // 1 = Water, 2 = Lube,  time=790 default value aka 79 seconds like before.
	if(wet >= wet_setting)
		return
	wet = wet_setting
	if((wet_setting == TURF_WET_WATER) || (wet_setting == TURF_WET_LUBE))
		if(wet_overlay)
			overlays -= wet_overlay
			wet_overlay = null
		var/turf/simulated/floor/F = src
		if(istype(F))
			wet_overlay = image('icons/effects/water.dmi', src, "wet_floor_static")
		else
			wet_overlay = image('icons/effects/water.dmi', src, "wet_static")
		overlays += wet_overlay

	spawn(time) // Purely so for visual effect
		if(!istype(src, /turf/simulated)) //Because turfs don't get deleted, they change, adapt, transform, evolve and deform. they are one and they are all.
			return
		MakeDry(wet_setting)

/turf/simulated/proc/MakeDry(wet_setting = TURF_WET_WATER)
	if(wet > wet_setting)
		return
	wet = TURF_DRY
	if(wet_overlay)
		overlays -= wet_overlay

/turf/simulated/Entered(atom/A, atom/OL)
	..()
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		switch(wet)
			if(TURF_WET_WATER)
				if(!M.slip(4, 2, null, NO_SLIP_WHEN_WALKING))
					M.inertia_dir = 0
				return
			if(TURF_WET_LUBE)
				M.slip(0, 7, null, (SLIDE|GALOSHES_DONT_HELP))

/turf/simulated/ChangeTurf(var/path)
	. = ..()
	smooth_icon_neighbors(src)
