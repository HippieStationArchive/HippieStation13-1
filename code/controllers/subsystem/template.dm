var/datum/subsystem/template/SStemplate

/datum/subsystem/template
	var/list/placed_templates = list()
	var/datum/dmm_parser/parser

/datum/subsystem/template/New()
	NEW_SS_GLOBAL(SStemplate)
	parser = new()
	priority = -2

/datum/subsystem/template/Initialize()
		PlaceTemplates()
		SSmachine.makepowernets()
		..()

/datum/subsystem/template/proc/PlaceTemplateAt(var/turf/location, var/path, var/name)
	set background = 1

	var/datum/dmm_object_collection/collection = parser.GetCollection(file2list(path))
	collection.Place(location, name)
	SSmachine.makepowernets()
	return collection

/datum/subsystem/template/proc/PlaceTemplates()
	set background = 1

	var/list/picked = PickTemplates()
	var/started = world.timeofday

	for(var/template in picked)
		var/list/size = GetTemplateSize(template)

		var/x = size[1]
		var/y = size[2]

		var/tries = config.tries
		var/turf/origin
		do
			var/turf/pick = locate(rand(1, world.maxx), rand(1, world.maxy), text2num(pick(config.zs)))

			// Keep a buffer of TRANSITIONEDGE+10 between the edges of the map
			if(((pick.x + x) >= (world.maxx - TRANSITIONEDGE - 10)) || (pick.x < (TRANSITIONEDGE + 10)))
				continue
			if(((pick.y + y) >= (world.maxy - TRANSITIONEDGE - 10)) || (pick.y < (TRANSITIONEDGE + 10)))
				continue

			var/list/turfs = block(pick, locate(pick.x + x, pick.y + y, pick.z))

			var/breakout = 0
			for(var/turf/T in turfs)
				if(!(istype(T, /turf/space)))
					breakout = 1
					break

			tries--

			if(breakout)
				continue

			origin = pick
		while(!origin && tries > 0)

		var/reversed = reverse_text(template)
		var/name = reverse_text(copytext(reversed, 1, findtext(reversed, "/")))

		var/datum/dmm_object_collection/collection = PlaceTemplateAt(origin, template, name)
		placed_templates += collection

		// Wait for templates to spawn before continuing so they don't spawn into each other.

	log_game("Finished placing templates after [time2text((world.timeofday - started), "mm:ss")]")
	world << "\red <b>Finished placing random structures...</b>"

/datum/subsystem/template/proc/PickTemplates()
	set background = 1
	var/list/picked = list()
	config.place_amount_min = min(config.place_amount_min, GetTemplateCount())
	config.place_amount_max = min(config.place_amount_max, GetTemplateCount())

	var/pick_num = rand(config.place_amount_min, config.place_amount_max)

	log_game("TEMPL: Picking [pick_num] template(s).")

	while(pick_num > length(picked))
		var/list/category_templates = GetTemplatesFromCategory("spacegen")

		if(length(category_templates) <= 0)
			continue

		var/picked_template = category_templates[rand(1, length(category_templates))]

		if(!picked_template)
			continue

		var/formatted = "[config.directory]/spacegen/[picked_template]"
		if(formatted in picked)
			continue

		log_game("TEMPL: Picked template: [picked_template]")

		picked += formatted

	return picked
