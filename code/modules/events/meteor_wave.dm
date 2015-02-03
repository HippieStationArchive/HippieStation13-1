/datum/round_event_control/meteor_wave
	name = "Meteor Wave"
	typepath = /datum/round_event/meteor_wave
	weight = 5
	max_occurrences = 3

/datum/round_event/meteor_wave
	startWhen		= 6
	endWhen			= 66
	announceWhen	= 1

	var/wave_class = null
	var/spawn_amount = null
	//var/spawn_type = null //what type of meteors to spawn, this will eventually include 2x and even 3x meteors as well!!!!

/datum/round_event/meteor_wave/setup()
	wave_class = (rand(-25,20) + rand(-25,20) + rand(-25,20) + rand(-25,20) + rand(-25,20))
	//spawn_amount = null
	//spawn_type = null

	if(wave_class <= 0)
		wave_class = 1

	switch(wave_class) //spawn amount starts at the default (5) and goes from there
		if(-INFINITY to 0)
			spawn_amount = 5
		if(1 to 10)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(11 to 20)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(21 to 30)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(31 to 40)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(41 to 50)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(51 to 60)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(61 to 70)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(71 to 80)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(81 to 90)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(91 to 100)
			spawn_amount = (5 - rand(-1,4) + (wave_class / 2))
		if(101 to INFINITY) //badmins!!!!
			spawn_amount = 1000



/datum/round_event/meteor_wave/announce()
	priority_announce("A class [wave_class] meteor shower has been detected on a collision course with the station.", "Meteor Alert", 'sound/AI/meteors.ogg')
	/*for(var/area/A in world)
		if (A.z == 1)
			if(wave_class >= 61)
				A.alertalert()
			else if(wave_class >= 41 && wave_class <= 60)
				A.dangalert()
			else if(wave_class >= 21 && wave_class <= 40)
				A.warnalert()
			else if(wave_class >= 1 && wave_class <= 20)
				A.cautionalert()*/


/datum/round_event/meteor_wave/tick()
	if(IsMultiple(activeFor, 3))
		spawn_meteors(spawn_amount, meteors_normal) //meteor list types defined in gamemode/meteor/meteors.dm