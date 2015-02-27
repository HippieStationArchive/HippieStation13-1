/datum/controller/process/garbage/setup()
	name = "garbage"
	schedule_interval = 20 // every 2 seconds

	if(!garbage)
		garbage = new

/datum/controller/process/garbage/doWork()
	garbage.process()
	scheck()