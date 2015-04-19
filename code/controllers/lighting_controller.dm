var/datum/controller/lighting/lighting_controller = new

#define MC_AVERAGE(average, current) (0.8*(average) + 0.2*(current))

/datum/controller/lighting
	var/processing = 0
	var/processing_interval = 5	//setting this too low will probably kill the server. Don't be silly with it!
	var/process_cost = 0
	var/iteration = 0
	var/max_cpu_use = 98		//this is just to prevent it queueing up when the server is dying. Not a solution, just damage control while I rethink a lot of this and try out ideas.

	// var/lighting_states = 6

	var/list/changed_lights = list()		//list of all datum/light_source that need updating
	var/changed_lights_workload = 0			//stats on the largest number of lights (max changed_lights.len)
	var/list/changed_turfs = list()			//list of all turfs which may have a different light level
	var/changed_turfs_workload = 0			//stats on the largest number of turfs changed (max changed_turfs.len)


/datum/controller/lighting/New()
	// lighting_states = max( 0, length(icon_states(LIGHTING_ICON))-1 )
	if(lighting_controller != src)
		if(istype(lighting_controller,/datum/controller/lighting))
			Recover()	//if we are replacing an existing lighting_controller (due to a crash) we attempt to preserve as much as we can
			del(lighting_controller)
		lighting_controller = src


//Workhorse of lighting. It cycles through each light that needs updating. It updates their
//effects and then processes every turf in the queue, updating their lighting object's appearance
//Any light that returns 1 in check() deletes itself
//By using queues we are ensuring we don't perform more updates than are necessary
/datum/controller/lighting/proc/process()
	processing = 1
	spawn(0)
		set background = BACKGROUND_ENABLED
		while(1)
			if(processing && (world.cpu <= max_cpu_use))
				iteration++
				var/started = world.timeofday

				changed_lights_workload = MC_AVERAGE(changed_lights_workload, changed_lights.len)//max(changed_lights_workload,changed_lights.len)
				for(var/i=1, i<=changed_lights.len, i++)
					var/datum/light_source/L = changed_lights[i]
					if(L && !L.check())
						continue
					changed_lights.Cut(i,i+1)
					i--

				sleep(-1)

				changed_turfs_workload = MC_AVERAGE(changed_turfs_workload, changed_turfs.len)//max(changed_turfs_workload_max,changed_turfs.len)
				for(var/i=1, i<=changed_turfs.len, i++)
					var/turf/T = changed_turfs[i]
					if(T && T.lighting_changed)
						T.redraw_lighting()
				changed_turfs.Cut()		// reset the changed list

				process_cost = (world.timeofday - started)

			sleep(processing_interval)

//same as above except it attempts to shift ALL turfs in the world regardless of lighting_changed status
//Does not loop. Should be run prior to process() being called for the first time.
//Note: if we get additional z-levels at runtime (e.g. if the gateway thin ever gets finished) we can initialize specific
//z-levels with the z_level argument
/datum/controller/lighting/proc/initializeLighting(var/z_level)
	processing = 0
	spawn(-1)
		set background = BACKGROUND_ENABLED
		for(var/i=1, i<=changed_lights.len, i++)
			var/datum/light_source/L = changed_lights[i]
			if(L.check())
				changed_lights.Cut(i,i+1)
				i--

		var/z_start = 1
		var/z_finish = world.maxz
		if(z_level)
			z_level = round(z_level,1)
			if(z_level > 0 && z_level <= world.maxz)
				z_start = z_level
				z_finish = z_level

		for(var/k=z_start,k<=z_finish,k++)
			for(var/i=1,i<=world.maxx,i++)
				for(var/j=1,j<=world.maxy,j++)
					var/turf/T = locate(i,j,k)
					if(T)	T.init_lighting()

		changed_turfs.Cut()		// reset the changed list


//Used to strip valid information from an existing controller and transfer it to a replacement
//It works by using spawn(-1) to transfer the data, if there is a runtime the data does not get transfered but the loop
//does not crash
/datum/controller/lighting/proc/Recover()
	if(!istype(lighting_controller.changed_turfs,/list))
		lighting_controller.changed_turfs = list()
	if(!istype(lighting_controller.changed_lights,/list))
		lighting_controller.changed_lights = list()

	for(var/i=1, i<=lighting_controller.changed_lights.len, i++)
		var/datum/light_source/L = lighting_controller.changed_lights[i]
		if(istype(L))
			spawn(-1)			//so we don't crash the loop (inefficient)
				L.check()
				changed_lights += L		//If we didn't runtime then this will get transferred over

	for(var/i=1, i<=lighting_controller.changed_turfs.len, i++)
		var/turf/T = lighting_controller.changed_turfs[i]
		if(istype(T) && T.lighting_changed)
			spawn(-1)
				T.redraw_lighting()

	var/msg = "## DEBUG: [time2text(world.timeofday)] lighting_controller restarted. Reports:\n"
	for(var/varname in lighting_controller.vars)
		switch(varname)
			if("tag","type","parent_type","vars")	continue
			else
				var/varval1 = lighting_controller.vars[varname]
				var/varval2 = vars[varname]
				if(istype(varval1,/list))
					varval1 = "/list([length(varval1)])"
					varval2 = "/list([length(varval2)])"
				msg += "\t [varname] = [varval1] -> [varval2]\n"
	world.log << msg