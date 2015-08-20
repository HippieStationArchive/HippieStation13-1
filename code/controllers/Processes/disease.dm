/datum/controller/process/disease

/datum/controller/process/disease/setup()
	name = "disease"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/disease/doWork()
	for(var/d in active_diseases)
		if(d)
			try
				d:process()
			catch(var/exception/e)
				continue
			scheck()
			continue
		active_diseases -= d
