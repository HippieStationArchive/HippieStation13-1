/datum/dmm_object_collection
	var/list/objects = list()
	var/list/grid = list()
	var/x_size
	var/y_size
	var/turf/location // Filled after collection is placed
	var/list/turfs = list()
	var/name

	// Because associative lists are a pain in byond
	var/list/place_last_turfs = list()
	var/list/place_last_objects = list()

/datum/dmm_object_collection/proc/GetObjectFromId(var/id)
	for(var/datum/dmm_object/obj in objects)
		if(obj.id == id)
			return obj
	return 0

/datum/dmm_object_collection/proc/HandleEdgeCases()
	for(var/turf/T in turfs)

		if(istype(T,/turf/simulated))
			SSair.remove_from_active(T)
			T.CalculateAdjacentTurfs()
			SSair.add_to_active(T,1)

		var/area/turf_area = get_area(T)
		if(turf_area.lighting_use_dynamic)
			turf_area.SetDynamicLighting()

		for(var/obj/machinery/light/L in T)
			L.update(0)

		for(var/atom/movable/M in T)
			M.initialize()

		for(var/obj/machinery/power/apc/A in T)
			A.reassign_area()

/datum/dmm_object_collection/proc/Place(var/turf/origin, var/template_name)
	name = template_name

	for(var/turf/T in block(origin, locate(origin.x + (x_size - 1), origin.y + (y_size - 1), origin.z)))
		for(var/atom/movable/M in T)
			if(istype(M, /mob))
				var/mob/mob = M
				if(mob.client || mob.key)
					continue
			qdel(M)
		qdel(T)

	var/area/A = new()
	A.name = template_name
	A.lighting_use_dynamic = DYNAMIC_LIGHTING_ENABLED
	A.requires_power = 1

	for(var/y = 0; y < y_size; y++)
		var/list/row = grid["[y]"]
		var/x = 0
		for(var/datum/dmm_object/object in row)
			turfs += object.Instantiate(locate(origin.x + x, origin.y + y, origin.z), ((!object.HasArea()) && (!object.GetSubByType(/turf/space, 0))) ? A : null)
			x++

	spawn(10)
		for(var/turf/T in place_last_turfs)
			var/datum/dmm_sub_object/sub = place_last_objects[place_last_turfs.Find(T)]
			var/atom/last = new sub.object_path(T)
			for(var/or in sub.var_overrides)
				last.vars[or] = sub.var_overrides[or]

	location = origin

	HandleEdgeCases()

	return 1

/datum/dmm_object_collection/proc/Reset()
	Delete()

	spawn(10)
		Place(location, name)

/datum/dmm_object_collection/proc/Delete(var/delete_src = 0, var/remove_from_list = 0)
	if(remove_from_list)
		SStemplate.placed_templates -= src

	for(var/turf/T in block(location, locate(location.x + (x_size - 1), location.y + (y_size - 1), location.z)))
		for(var/atom/movable/M in T)
			if(istype(M, /mob))
				var/mob/mob = M
				if(mob.client || mob.key)
					continue
			qdel(M)

			T.ChangeTurf(/turf/space)

		if(delete_src)
			qdel(src)

/datum/dmm_object
	var/id
	var/list/sub_objects = list()
	var/datum/dmm_object_collection/parent

	// We want the turf first and area second.
/datum/dmm_object/proc/SortSubObjects()
	var/datum/dmm_sub_object/sub = GetSubByType(/turf)
	if(sub)
		sub_objects.Swap(1, sub_objects.Find(sub))
		sub = null
	sub = GetSubByType(/area)
	if(sub)
		sub_objects.Swap(2, sub_objects.Find(sub))
		sub = null

	listclearnulls(sub_objects)

	return sub_objects

/datum/dmm_object/proc/Instantiate(var/turf/position, var/area/AR)
	for(var/datum/dmm_sub_object/sub in SortSubObjects())
		if(!sub.object_path)
			continue

		if(sub.object_path in config.place_last)
			parent.place_last_turfs += position
			parent.place_last_objects += sub

			continue
		try
			var/atom/A = new sub.object_path(position)
			for(var/or in sub.var_overrides)
				A.vars[or] = sub.var_overrides[or]

			if(AR && istype(A, /turf))
				AR.contents.Add(A)

		catch(var/exception/ex)
			message_admins("Error while creating template object: [ex.name]: [ex.desc] @ [ex.file] L:[ex.line]. Additional info: object_path = [sub.object_path] position = [position ? position : "null"]")
			break

	return position

/datum/dmm_object/proc/GetSubByType(var/path, var/strict = 0)
	for(var/datum/dmm_sub_object/sub in sub_objects)
		if(strict)
			if(istype(sub.object_path, path))
				return sub
		else
			if(sub.object_path == path)
				return sub

	return 0

	// Has area other than space
/datum/dmm_object/proc/HasArea()
	var/datum/dmm_sub_object/sub = GetSubByType(/area)
	return (sub && sub.object_path != /area/space)

/datum/dmm_sub_object
	var/object_path
	var/list/var_overrides = list()

/datum/dmm_sub_object/proc/SanitizeOverrides()
	for(var/key in var_overrides)
		var/value = var_overrides[key]

		if(istext(value) && (text2num(value) == null))
			value = replacetext(value, "\"", "")

			if(copytext(value, 1, 9) == "newlist(")
				var_overrides[key] = splittext(copytext(value, 9, findtext(value, ")")), ",")
				continue

		else if(text2num(value) != null)
			value = text2num(value)

		var_overrides[key] = value

/datum/dmm_parser

/datum/dmm_parser/proc/GetCollection(var/list/lines)
	var/datum/dmm_object_collection/collection = new()

	var/mb = 0 // Map block
	var/mb_row = 1
	var/id_el = 0 // id extra-length (e.g. "a" extra length is 0, "aa" extra length is 1)

	var/row_count = 0
	for(var/line in lines)
		if(copytext(line, 1, 2) == "(")
			mb = 1
			continue
		if(copytext(line, 1) == "\"}")
			mb = 0
			continue
		if(mb)
			row_count++
			continue
		mb = 0

	var/datum/dmm_object/object
	for(var/line in lines)
		if(!line || !length(line))
			continue

		if(copytext(line, 1, 2) == "\"" && copytext(line, 2, 3) != "}")
			object = new()
			object.id = copytext(line, 2, findtext(line, "\"", 2))
			object.parent = collection
			id_el = length(object.id) - 1

			var/sp_pos = findtext(line, "(") // Starting Parenthesis
			var/lp_pos = findtext(line, ")", length(line) - 1) // Last Parenthesis
			var/inner_text = copytext(line, sp_pos + 1, lp_pos)
			var/comma_pos = findtext(line, ",")

			var/list/path_groups = list()

			var/list/cb_starting_positions = list()
			var/list/cb_ending_positions = list()

			var/cb_start = findtext(line, "{")
			while(cb_start)
				var/cb_end = findtext(line, "}", cb_start)
				cb_starting_positions += cb_start
				cb_ending_positions += cb_end

				cb_start = findtext(line, "{", cb_end + 1)

			// Extract each comma-seperated path out of the text
			if(comma_pos)
				path_groups.Add(copytext(line, sp_pos + 1, comma_pos))
				var/next_comma_pos
				do
					next_comma_pos = findtext(line, ",", comma_pos + 1)

					// Ignore commas in {} blocks
					for(var/c in cb_starting_positions)
						while(next_comma_pos in (c to cb_ending_positions[cb_starting_positions.Find(c)]))
							next_comma_pos = findtext(line, ",", next_comma_pos + 1)

					if(next_comma_pos)
						path_groups.Add(copytext(line, comma_pos + 1, next_comma_pos))
						comma_pos = next_comma_pos
					else
						path_groups.Add(copytext(line, comma_pos + 1, lp_pos))

				while(next_comma_pos)
			else
				path_groups.Add(inner_text)

			var/datum/dmm_sub_object/sub
			for(var/pi in path_groups)
				sub = new()

				var/cbs_pos = findtext(pi, "{") // Curly-brace starting position
				var/cbe_pos = findtext(pi, "}") // Curly-brace ending position

				if(cbs_pos)
					var/obj_path = text2path(copytext(pi, 1, cbs_pos))
					if(length(obj_path) <= 0)
						sub.object_path = obj_path
					else
						sub = null
						continue

					var/string = copytext(pi, cbs_pos + 1, cbe_pos)

					var/list/quote_sp = list() // Quote starting positions
					var/list/quote_ep = list() // Quote ending positions

					var/quote_start = findtext(string, "\"")
					while(quote_start)
						var/quote_end = findtext(string, "\"", quote_start + 1)

						quote_sp += quote_start
						quote_ep += quote_end

						quote_start = findtext(string, "\"", quote_end + 1)

					// Start hack. Why? Because byond.
					var/list/string_list = list()
					var/next_sc_pos
					var/sc_pos = 0
					if(sc_pos != null)
						do
							next_sc_pos = findtext(string, ";", sc_pos + 1)

							// Ignore commas in quote blocks
							for(var/sc in quote_sp)
								while(next_sc_pos in (sc to quote_ep[quote_sp.Find(sc)]))
									next_sc_pos = findtext(string, ";", next_sc_pos + 1)

							if(!length(string_list) && findtext(string, ";"))
								var/part = copytext(string, sc_pos + 1, next_sc_pos)
								string_list.Add(part)
								sc_pos = (length(part) + 1)
								next_sc_pos = findtext(string, ";", sc_pos + 1)
								continue

							if(next_sc_pos)
								string_list.Add(copytext(string, sc_pos + 1, next_sc_pos))
								sc_pos = next_sc_pos
							else
								string_list.Add(copytext(string, sc_pos + 1, length(string) + 1))
						while(next_sc_pos)

					var/list/space_removal_list = list()
					var/list/space_removal_pass2 = list()

					for(var/s in string_list)
						if(copytext(s, 1, 2) == " ")
							space_removal_list += copytext(s, 2)
							continue
						space_removal_list += s

					for(var/s in space_removal_list)
						var/equal_pos = findtext(s, "=")
						space_removal_pass2 += "[copytext(s, 1, equal_pos - 1)]=[copytext(s, equal_pos + 2)]"

					var/list/overrides = list()
					for(var/s in space_removal_pass2)
						var/key = copytext(s, 1, findtext(s, "="))
						overrides += key
						var/value = copytext(s, length(key) + 2)
						overrides[key] = value

						// End hack.

					sub.var_overrides = overrides
				else
					sub.object_path = text2path(pi)

				sub.SanitizeOverrides()
				object.sub_objects += sub

			collection.objects += object

		if(copytext(line, 1, 2) == "(") // Starting map block
			mb = 1
			continue

		else if(copytext(line, 1) == "\"}") // Ending map block
			mb = 0
			continue

		if(mb)
			var/list/row_list = list()
			for(var/i = 0; i < length(line); i += (id_el + 1))
				row_list += collection.GetObjectFromId(copytext(line, i + 1, i + 2 + id_el))
			collection.grid["[(row_count - mb_row)]"] = row_list
			mb_row++

	collection.y_size = length(collection.grid)
	collection.x_size = length(collection.grid["1"])

	return collection
