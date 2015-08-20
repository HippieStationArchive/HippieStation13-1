/datum/controller/process/disease
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/disease/setup()
	name = "disease"
	schedule_interval = 20 // every 2 seconds
	updateQueueInstance = new

/datum/controller/process/disease/doWork()
	for(var/d in active_diseases)
		if(d)
			try
				d:process()
			catch(var/exception/e)
				world.Error(e)
				continue
			scheck()
			continue
		active_diseases -= d
