/datum/controller/process/air/setup()
	name = "air"
	schedule_interval = 20 // every 2 seconds
	if(!air_master)
		air_master = new
		air_master.setup()

/datum/controller/process/air/doWork()
	air_master.process_air()
	//if(!air_processing_killed)
		//if(!air_master.process_air()) //Runtimed.
			//air_master.failed_ticks++

			//if(air_master.failed_ticks > 5)
			//	world << "<SPAN CLASS='danger'>RUNTIMES IN ATMOS TICKER.  Killing air simulation!</SPAN>"
			//	world.log << "### AIR SHUTDOWN"

			//	message_admins("AIRALERT: Shutting down! status: [air_master.tick_progress]")
			//	log_admin("AIRALERT: Shutting down! status: [air_master.tick_progress]")

			//	air_processing_killed = TRUE
			//	air_master.failed_ticks = 0
