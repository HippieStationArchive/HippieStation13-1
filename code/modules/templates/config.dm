var/datum/template/template_config

/datum/template
	var/place_amount_min = 1
	var/place_amount_max = 3

	var/list/chances = list()
	var/list/ignore_types = list()
	var/list/zs = list()
	var/list/place_last = list()
	var/tries = 10
	var/directory

/datum/template/proc/load(filename)
	var/list/lines = file2list(filename)
	for(var/t in lines)
		if(!t)	continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue
		switch(name)
			if("zs")
				zs += value
			if("place_last")
				place_last += value
			if("tries")
				tries = value
			if("directory")
				directory = value
			if("place_amount_min")
				place_amount_min = value
			if("place_amount_max")
				place_amount_max = value