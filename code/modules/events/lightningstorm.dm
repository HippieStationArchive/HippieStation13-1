/datum/round_event_control/anomaly/anomaly_electricstorm
	name = "Anomaly: Electric Storm"
	typepath = /datum/round_event/anomaly/anomaly_electric
	max_occurrences = 1
	weight = 20

/datum/round_event/anomaly/anomaly_electric
	startWhen = 10
	announceWhen = 3
	endWhen = 85

/datum/round_event/anomaly/anomaly_electric/announce()
	priority_announce("Electric anomaly detected on long range scanners. Please look out for lightning strikes.", "Anomaly Alert")
	callthunder()
/datum/round_event/anomaly/anomaly_electric/start()
	return



/datum/round_event/anomaly/anomaly_electric/end()
	return