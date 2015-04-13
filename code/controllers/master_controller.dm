//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_timeofday = world.timeofday
var/global/last_tick_duration = 0

var/global/air_processing_killed = 0
var/global/pipe_processing_killed = 0

/datum/controller/game_controller
	var/processing = 0
	var/breather_ticks = 2		//a somewhat crude attempt to iron over the 'bumps' caused by high-cpu use by letting the MC have a breather for this many ticks after every loop
	var/minimum_ticks = 20		//The minimum length of time between MC ticks

	var/air_cost 		= 0
	var/air_turfs		= 0
	var/air_groups		= 0
	var/air_highpressure= 0
	var/air_hotspots	= 0
	var/air_superconductivity = 0
	var/sun_cost		= 0
	var/mobs_cost		= 0
	var/diseases_cost	= 0
	var/machines_cost	= 0
	var/aibots_cost		= 0
	var/objects_cost	= 0
	var/networks_cost	= 0
	var/powernets_cost	= 0
	var/nano_cost		= 0
	var/events_cost		= 0
	var/ticker_cost		= 0
	var/gc_cost			= 0
	var/total_cost		= 0

	var/last_thing_processed

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		if(istype(master_controller))
			Recover()
			del(master_controller)
		master_controller = src

	if(!events)
		new /datum/controller/event()

	//if(!air_master)
	//	air_master = new /datum/controller/air_system()
	//	air_master.setup()

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		//job_master.LoadGimmickJobs()
		world << "<span class='userdanger'>Job setup complete</span>"

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()
	if(!ticker)						ticker = new /datum/controller/gameticker()
	//if(!emergency_shuttle)			emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()
	if(!supply_shuttle)				supply_shuttle = new /datum/controller/supply_shuttle()

/datum/controller/game_controller/proc/setup()
	world.tick_lag = config.Ticklag

	setup_objects()
	setupgenetics()
	setupfactions()

	//spawn(0)
	//	if(ticker)
	//		ticker.pregame()

/datum/controller/game_controller/proc/setup_objects()
	set background=1
	world << "<span class='userdanger'>Initializing objects...</span>"
	sleep(-1)
	for(var/atom/movable/object in world)
		object.initialize()

	world << "<span class='userdanger'>Initializing pipe networks...</span>"
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in world)
		machine.build_network()

	world << "<span class='userdanger'>Initializing atmos machinery...</span>"
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in world)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	world << "<span class='userdanger'>Making a mess...</span>"
	sleep(-1)
	for(var/turf/simulated/floor/F in world)
		F.MakeDirty()

	world << "<span class='userdanger'>Initializations complete.</span>"
	sleep(-1)


/datum/controller/game_controller/proc/process()
	processing = 1
	spawn(0)
		set background = BACKGROUND_ENABLED
		while(1)	//far more efficient than recursively calling ourself
			if(!Failsafe)	new /datum/controller/failsafe()

			var/currenttime = world.timeofday

			if((last_tick_timeofday - currenttime) > 1e5) //midnight rollover protection
				last_tick_timeofday -= MIDNIGHT_ROLLOVER

			last_tick_duration = (currenttime - last_tick_timeofday) / 10
			last_tick_timeofday = currenttime

			if(processing)
				var/timer
				var/start_time = world.timeofday
				controller_iteration++

				spawn(0)
					vote.process()

				//AIR
				spawn(0)
					if(!air_processing_killed)
						timer = world.timeofday
						last_thing_processed = air_master.type
						air_master.process()
						air_cost = (world.timeofday - timer) / 10
						global_activeturfs = air_master.active_turfs.len

				//SUN
				spawn(0)
					timer = world.timeofday
					last_thing_processed = sun.type
					sun.calc_position()
					sun_cost = (world.timeofday - timer) / 10

				//MOBS
				spawn(0)
					timer = world.timeofday
					process_mobs()
					mobs_cost = (world.timeofday - timer) / 10

				//DISEASES
				spawn(0)
					timer = world.timeofday
					process_diseases()
					diseases_cost = (world.timeofday - timer) / 10

				//MACHINES
				spawn(0)
					timer = world.timeofday
					process_machines()
					machines_cost = (world.timeofday - timer) / 10

				//BOTS
				spawn(0)
					timer = world.timeofday
					process_bots()
					aibots_cost = (world.timeofday - timer) / 10

				//OBJECTS
				spawn(0)
					timer = world.timeofday
					process_objects()
					objects_cost = (world.timeofday - timer) / 10

				//PIPENETS
				spawn(0)
					if(!pipe_processing_killed)
						timer = world.timeofday
						process_pipenets()
						networks_cost = (world.timeofday - timer) / 10

				//POWERNETS
				spawn(0)
					timer = world.timeofday
					process_powernets()
					powernets_cost = (world.timeofday - timer) / 10

				//NANO UIS
				spawn(0)
					timer = world.timeofday
					process_nano()
					nano_cost = (world.timeofday - timer) / 10

				//EVENTS
				spawn(0)
					timer = world.timeofday
					last_thing_processed = /datum/round_event
					events.process()
					events_cost = (world.timeofday - timer) / 10

				//TICKER
				spawn(0)
					timer = world.timeofday
					last_thing_processed = ticker.type
					ticker.process()
					ticker_cost = (world.timeofday - timer) / 10
				// GC
				spawn(0)
					timer = world.timeofday
					last_thing_processed = garbage.type
					garbage.process()
					gc_cost = (world.timeofday - timer) / 10

				var/end_time = world.timeofday
				if(end_time < start_time)
					start_time -= MIDNIGHT_ROLLOVER    //deciseconds in a day
				sleep( round(minimum_ticks - (end_time - start_time),1) )
			else
				sleep(10)

/*
/datum/controller/game_controller/proc/process_liquid()
	last_thing_processed = /datum/puddle
	var/i = 1
	while(i<=puddles.len)
		var/datum/puddle/Puddle = puddles[i]
		if(Puddle)
			Puddle.process()
			i++
			continue
		puddles.Cut(i,i+1)
*/

/datum/controller/game_controller/proc/process_mobs()
	for(var/mob/M in mob_list)
		if(!M.gc_destroyed)
			last_thing_processed = M.type
			M.Life()
			continue
		mob_list -= M

/datum/controller/game_controller/proc/process_diseases()
	for(var/datum/disease/Disease in active_diseases)
		last_thing_processed = Disease.type
		Disease.process()

/datum/controller/game_controller/proc/process_machines()
	for(var/obj/machinery/Machine in machines)
		if(!Machine.gc_destroyed)
			last_thing_processed = Machine.type
			if(Machine.process() != PROCESS_KILL)
				if(Machine)
					if(Machine.use_power)
						Machine.auto_use_power()
					continue
		machines -= Machine

/datum/controller/game_controller/proc/process_bots()
	for(var/obj/machinery/bot/Bot in aibots)
		if(!Bot.gc_destroyed)
			last_thing_processed = Bot.type
			spawn(0)
				Bot.bot_process()
			continue
		aibots -= Bot

/datum/controller/game_controller/proc/process_objects()
	for(var/obj/Object in processing_objects)
		if(!Object.gc_destroyed)
			last_thing_processed = Object.type
			Object.process()
			continue
		processing_objects -= Object

/datum/controller/game_controller/proc/process_pipenets()
	last_thing_processed = /datum/pipeline
	for(var/datum/pipeline/P in pipe_networks)
		P.process()

/datum/controller/game_controller/proc/process_powernets()
	last_thing_processed = /datum/powernet
	for(var/datum/powernet/Powernet in powernets)
		Powernet.reset()

/datum/controller/game_controller/proc/process_nano()
	for(var/datum/nanoui/ui in nanomanager.processing_uis)
		if(ui.src_object && ui.user)
			ui.process()
			continue
		nanomanager.processing_uis -= ui

/datum/controller/game_controller/proc/Recover()		//Mostly a placeholder for now.
	var/msg = "## DEBUG: [time2text(world.timeofday)] MC restarted. Reports:\n"
	for(var/varname in master_controller.vars)
		switch(varname)
			if("tag","type","parent_type","vars")	continue
			else
				var/varval = master_controller.vars[varname]
				if(istype(varval,/datum))
					var/datum/D = varval
					msg += "\t [varname] = [D.type]\n"
				else
					msg += "\t [varname] = [varval]\n"
	world.log << msg
