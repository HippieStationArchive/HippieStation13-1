/proc/speciestest()

	for(var/client/C in clients)
		C.prefs.specialsnowflakes = null
		C.prefs.specialsnowflakes = list()


		var/list/datum/species/specialsnowflake = C.prefs.specialsnowflakes
		var/list/X = list()
		X.Add(/datum/species/lizard)
		X.Add(/datum/species/human)

		for(var/spath in X)
			if(spath == /datum/species)
				continue
			var/datum/species/S = new spath()
			specialsnowflake[S] = S.type
		C.prefs.save_character()
