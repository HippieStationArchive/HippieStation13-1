var/global/list/object_profiling = list()
/datum/controller/process/obj
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/obj/setup()
	name = "obj"
	schedule_interval = 20 // every 2 seconds
	updateQueueInstance = new

/datum/controller/process/obj/started()
	..()
	if (!processing_objects)
		processing_objects = list()

/datum/controller/process/obj/doWork()
	if(processing_objects)
		for(var/o in processing_objects)
			if(o)
				try
					o:process()
				catch(var/exception/e)
					continue
				scheck()
				continue
			processing_objects -= o
