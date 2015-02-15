/proc/speciestest()

	for(var/client/C in clients)
		C.prefs.specialsnowflakes = null
		sleep(1)
		C.prefs.specialsnowflakes = list()


		var/list/datum/species/specialsnowflake = C.prefs.specialsnowflakes
		var/list/X = list()

		X.Add(/datum/species/human)
		X.Add(/datum/species/lizard)
		for(var/spath in X)
			if(spath == /datum/species)
				continue
			var/datum/species/S = new spath()
			specialsnowflake[S] = S.type
		C.prefs.save_character()




/proc/speciestest3()

	for(var/client/C in clients)
		C.prefs.specialsnowflakes = null
		sleep(1)
		C.prefs.specialsnowflakes = list()


		var/list/datum/species/specialsnowflake = C.prefs.specialsnowflakes

		specialsnowflake += /datum/species/human
		specialsnowflake += /datum/species/lizard
		C.prefs.save_character()
/proc/speciestest2()

	for(var/client/C in clients)
		C.prefs.specialsnowflakes = null
		C.prefs.specialsnowflakes = list()


		var/list/datum/species/specialsnowflake = C.prefs.specialsnowflakes
		var/list/X = list()

		X.Add(/datum/species/human)
		X.Add(/datum/species/bird)
		X.Add(/datum/species/bot)
		X.Add(/datum/species/lizard)
		X.Add(/datum/species/cat)
		for(var/spath in X)
			if(spath == /datum/species)
				continue
			var/datum/species/S = new spath()
			specialsnowflake[S] = S.type
		sleep(1)
		C.prefs.save_character()

