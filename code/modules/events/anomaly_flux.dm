/datum/round_event_control/anomaly/anomaly_flux
	name = "Anomaly: Hyper-Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_flux
	startWhen = 3
	announceWhen = 20
	endWhen = 80


/datum/round_event/anomaly/anomaly_flux/announce()
	priority_announce("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")


/datum/round_event/anomaly/anomaly_flux/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T.loc)


/datum/round_event/anomaly/anomaly_flux/end()
	if(newAnomaly.loc)//If it hasn't been neutralized, it's time to blow up.
		message_admins("A Hyper-Energetic Flux Anomaly has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[newAnomaly.x];Y=[newAnomaly.y];Z=[newAnomaly.z]'>([newAnomaly.x],[newAnomaly.y],[newAnomaly.z])</a>")
		log_game("A Hyper-Energetic Flux Anomaly has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[newAnomaly.x];Y=[newAnomaly.y];Z=[newAnomaly.z]'>([newAnomaly.x],[newAnomaly.y],[newAnomaly.z])</a>")
		explosion(newAnomaly, 1, 4, 16, 18) //Low devastation, but hits a lot of stuff.
		qdel(newAnomaly)