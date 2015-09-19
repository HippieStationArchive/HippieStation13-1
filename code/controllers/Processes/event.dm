/datum/controller/process/event
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/event/setup()
	name = "event"

/datum/controller/process/event/doWork()
	events.process()
	//updateQueueInstance.init(events, "process")
	//updateQueueInstance.Run()

/datum/controller/process/event/onFinish()
	events.checkEvent()
