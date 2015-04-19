/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = 5 // every .5 second
	lighting_controller.initializeLighting()

/datum/controller/process/lighting/doWork()
	lighting_controller.changed_lights_workload = \
		max(lighting_controller.changed_lights_workload, lighting_controller.changed_lights.len)

	for(var/datum/light_source/L in lighting_controller.changed_lights)
		if(L && L.check())
			lighting_controller.changed_lights.Remove(L)

		scheck()

	lighting_controller.changed_turfs_workload = \
		max(lighting_controller.changed_turfs_workload, lighting_controller.changed_turfs.len)

	for(var/turf/T in lighting_controller.changed_turfs)
		if(T && T.lighting_changed)
			T.redraw_lighting()

		scheck()

	if(lighting_controller.changed_turfs && lighting_controller.changed_turfs.len)
		lighting_controller.changed_turfs.len = 0 // reset the changed list
