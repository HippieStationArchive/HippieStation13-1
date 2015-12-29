//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/item/weapon/electronics/airlock
	name = "airlock electronics"

	req_access = list(access_maint_tunnels)

	var/list/accesses = null
	var/one_access = 0 //If the door should require ALL or only ONE of the listed accesses.
	var/last_configurator = null
	var/locked = 1

/obj/item/weapon/electronics/airlock/attack_self(mob/user)
	if (!user) return
	interact(user)

/obj/item/weapon/electronics/airlock/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/item/weapon/electronics/airlock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, force_open = 0)
	SSnano.try_update_ui(user, src, ui_key, ui, force_open = force_open)
	if (!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", name, 975, 415, state = hands_state)
		ui.open()

/obj/item/weapon/electronics/airlock/get_ui_data()
	var/list/data = list()
	var/list/regions = list()

	for(var/i in 1 to 7)
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in get_region_accesses(i))
			var/list/access = list()
			access["name"] = get_access_desc(j)
			access["id"] = j
			access["req"] = (j in src.accesses)
			accesses[++accesses.len] = access
		region["name"] = get_region_accesses_name(i)
		region["accesses"] = accesses
		regions[++regions.len] = region
	data["regions"] = regions
	data["oneAccess"] = one_access

	return data

/obj/item/weapon/electronics/airlock/Topic(href, href_list)
	if(..())
		return

	if(href_list["access"])
		if(href_list["access"] == "clear")
			accesses = list()
			one_access = 0
		else if(href_list["access"] == "one")
			one_access = !one_access
		else
			var/access = text2num(href_list["access"])
			if (!(access in accesses))
				accesses += access
			else
				accesses -= access