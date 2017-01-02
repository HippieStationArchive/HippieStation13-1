#define AUTOLATHE_MAIN_MENU       1
#define AUTOLATHE_CATEGORY_MENU   2
#define AUTOLATHE_SEARCH_MENU     3

/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1

	var/operating = 0
	anchored = 1
	var/list/L = list()
	var/list/LL = list()
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/hack_wire
	var/disable_wire
	var/shock_wire
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	var/busy = 0
	var/prod_coeff
	var/datum/wires/autolathe/wires = null

	var/datum/design/being_built
	var/datum/research/files = /datum/research/autolathe
	var/list/datum/design/matching_designs
	var/selected_category
	var/screen = 1
	var/default_icon = "autolathe"
	var/metalanim = "autolathe_r"
	var/glassanim = "autolathe_o"
	var/making = "autolathe_n"
	var/maintpanel = "autolathe_t"
	var/board = /obj/item/weapon/circuitboard/autolathe

	var/datum/material_container/materials

	var/list/categories = list(
							"Tools",
							"Electronics",
							"Construction",
							"T-Comm",
							"Security",
							"Machinery",
							"Medical",
							"Assembly",
							"Misc"
							)

/obj/machinery/autolathe/New()
	..()
	component_parts = list()
	component_parts += new board(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	materials = new /datum/material_container(src, list(MAT_METAL=1, MAT_GLASS=1))
	RefreshParts()

	wires = new(src)
	files = new files(src)
	matching_designs = list()

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
	qdel(materials)
	materials = null
	return ..()

/obj/machinery/autolathe/interact(mob/user)
	if(!is_operational())
		return

	if(shocked && !(stat & NOPOWER))
		shock(user,50)

	var/dat

	if(panel_open)
		dat = wires.GetInteractWindow()

	else
		switch(screen)
			if(AUTOLATHE_MAIN_MENU)
				dat = main_win(user)
			if(AUTOLATHE_CATEGORY_MENU)
				dat = category_win(user,selected_category)
			if(AUTOLATHE_SEARCH_MENU)
				dat = search_win(user)

	var/datum/browser/popup = new(user, "autolathe", name, 400, 500)
	popup.set_content(dat)
	popup.open()

	return

/obj/machinery/autolathe/attackby(obj/item/O, mob/user, params)
	if (busy)
		user << "<span class=\"alert\">The autolathe is busy. Please wait for completion of previous operation.</span>"
		return 1

	if(default_deconstruction_screwdriver(user, maintpanel, default_icon, O))
		updateUsrDialog()
		return

	if(exchange_parts(user, O))
		return

	if (panel_open)
		if(istype(O, /obj/item/weapon/crowbar))
			materials.retrieve_all()
			default_deconstruction_crowbar(O)
			return 1
		else
			attack_hand(user)
			return 1
	if (stat)
		return 1

	var/material_amount = materials.get_item_material_amount(O)
	if(!material_amount)
		user << "<span class='warning'>This object does not contain sufficient amounts of metal or glass to be accepted by the autolathe.</span>"
		return 1
	if(!materials.has_space(material_amount))
		user << "<span class='warning'>The autolathe is full. Please remove metal or glass from the autolathe in order to insert more.</span>"
		return 1
	if(!user.unEquip(O))
		user << "<span class='warning'>\The [O] is stuck to you and cannot be placed into the autolathe.</span>"
		return 1

	busy = 1
	var/inserted = materials.insert_item(O)
	if(inserted)
		if(istype(O,/obj/item/stack))
			if (O.materials[MAT_METAL])
				flick(metalanim,src)//plays metal insertion animation
			if (O.materials[MAT_GLASS])
				flick(glassanim,src)//plays glass insertion animation
			user << "<span class='notice'>You insert [inserted] sheet[inserted>1 ? "s" : ""] to the autolathe.</span>"
			use_power(inserted*100)
		else
			user << "<span class='notice'>You insert a material total of [inserted] to the autolathe.</span>"
			use_power(max(500,inserted/10))
			qdel(O)
	busy = 0
	src.updateUsrDialog()

/obj/machinery/autolathe/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/autolathe/attack_hand(mob/user)
	if(..(user, 0))
		return
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return
	if (!busy)
		if(href_list["menu"])
			screen = text2num(href_list["menu"])

		if(href_list["category"])
			selected_category = href_list["category"]

		if(href_list["make"])

			var/turf/T = loc

			/////////////////
			//href protection
			being_built = files.FindDesignByID(href_list["make"]) //check if it's a valid design
			if(!being_built)
				return

			var/is_stack = ispath(being_built.build_path, /obj/item/stack)
			var/max_multiplier = min(   50-38*!is_stack, //We're making the max_multiplier up to 12 for non-stacks because who the fuck would want 50 bonesaws?!
										being_built.materials[MAT_METAL] ?round(materials.amount(MAT_METAL)/being_built.materials[MAT_METAL]):INFINITY,
										being_built.materials[MAT_GLASS]?round(materials.amount(MAT_GLASS)/being_built.materials[MAT_GLASS]):INFINITY)

			var/multiplier = href_list["multiplier"] //Not converting it immediately because we wanna check if it's custom or not.
			if (multiplier == "custom")
				multiplier =  min(max( 0,round(input("How many of these would you like to build? (Up to [max_multiplier])")  as num) ),max_multiplier)
				if(busy || multiplier <= 0)  //The first arg is in case others use the lathe while you're using it.
					usr << "<span class='warning'>Lathe is either busy or invalid input.</span>"
					return
			else
				multiplier = text2num(href_list["multiplier"])
			/////////////////

			var/coeff = (is_stack ? 1 : 2 ** prod_coeff) //stacks are unaffected by production coefficient
			var/metal_cost = being_built.materials[MAT_METAL]
			var/glass_cost = being_built.materials[MAT_GLASS]

			var/power = max(2000, (metal_cost+glass_cost)*multiplier/5)

			//If we have enough materials (multiplier and coeff accounted for)
			if((materials.amount(MAT_METAL) >= metal_cost*multiplier/coeff) && (materials.amount(MAT_GLASS) >= glass_cost*multiplier/coeff))
				busy = 1
				use_power(power)
				flick(making,src)
				spawn(is_stack*32/coeff + !is_stack*32*multiplier/coeff)
					use_power(power)
					if(is_stack)
						var/list/materials_used = list(MAT_METAL=metal_cost*multiplier, MAT_GLASS=glass_cost*multiplier)
						materials.use_amount(materials_used)

						for(var/obj/item/stack/S in T)
							if(multiplier <= 0)
								break
							if(S.amount >= S.max_amount)
								continue
							var/to_transfer = S.max_amount - S.amount
							if(to_transfer < multiplier)
								S.amount += to_transfer
								multiplier -= to_transfer
								S.update_icon()
								continue
							else
								S.amount += multiplier
								multiplier = 0
								S.update_icon()
								break
						if(multiplier)
							var/obj/item/stack/N = new being_built.build_path(T)
							N.autolathe_crafted(src)
							N.amount = multiplier
							N.update_icon()
					else
						var/list/materials_used // Declaring it out here so we don't have to declare it every single time in the loop.
						for(var/i = 0, i<multiplier, i++)
							materials_used = list(MAT_METAL=metal_cost/coeff, MAT_GLASS=glass_cost/coeff)
							materials.use_amount(materials_used)

							var/obj/item/new_item
							if(ispath(being_built.build_path, /obj/structure)) // if we're making a structure, make an object-in-a-box item that dispenses said structure on use, or everything runtimes
								new_item = new /obj/item/device/object_in_a_box(T, being_built.build_path)
							else
								new_item = new being_built.build_path(T)
							new_item.autolathe_crafted(src)
							new_item.materials = materials_used.Copy()
					busy = 0
					src.updateUsrDialog()

		if(href_list["search"])
			matching_designs.Cut()

			for(var/datum/design/D in files.known_designs)
				if(findtext(D.name,href_list["to_search"]))
					matching_designs.Add(D)

		if(href_list["remove_mat"] && href_list["material"])
			var/amount = text2num(href_list["remove_mat"])
			var/material = href_list["material"]
			amount = round(amount, 1)
			if(amount <= 0 || amount > materials.amount(material)) //href protection
				return

			materials.retrieve_sheets(amount, material)
	else
		usr << "<span class=\"alert\">The autolathe is busy. Please wait for completion of previous operation.</span>"

	updateUsrDialog()

	return

/obj/machinery/autolathe/RefreshParts()
	var/tot_rating = 0
	prod_coeff = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		tot_rating += MB.rating
	tot_rating *= 25000
	materials.max_amount = tot_rating * 3
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		prod_coeff += M.rating - 1

/obj/machinery/autolathe/proc/main_win(mob/user)
	var/dat = "<div class='statusDisplay'><h3>Autolathe Menu:</h3><br>"
	dat += "<b>Total amount:</b> [materials.total_amount] / [materials.max_amount] cm<sup>3</sup><br>"
	dat += output_available_resources() + "<br>"

	dat += "<form name='search' action='?src=\ref[src]'>\
	<input type='hidden' name='src' value='\ref[src]'>\
	<input type='hidden' name='search' value='to_search'>\
	<input type='hidden' name='menu' value='[AUTOLATHE_SEARCH_MENU]'>\
	<input type='text' name='to_search'>\
	<input type='submit' value='Search'>\
	</form><hr>"

	var/line_length = 1
	dat += "<table style='width:100%' align='center'><tr>"

	for(var/C in categories)
		if(line_length > 2)
			dat += "</tr><tr>"
			line_length = 1

		dat += "<td><A href='?src=\ref[src];category=[C];menu=[AUTOLATHE_CATEGORY_MENU]'>[C]</A></td>"
		line_length++

	dat += "</tr></table></div>"
	return dat

/obj/machinery/autolathe/proc/category_win(mob/user,selected_category)
	var/dat = "<A href='?src=\ref[src];menu=[AUTOLATHE_MAIN_MENU]'>Return to main menu</A>"
	dat += "<div class='statusDisplay'><h3>Browsing [selected_category]:</h3><br>"
	dat += "<b>Total amount:</b> [materials.total_amount] / [materials.max_amount] cm<sup>3</sup><br>"
	dat += "<b>Metal amount:</b> [materials.amount(MAT_METAL)] cm<sup>3</sup><br>"
	dat += "<b>Glass amount:</b> [materials.amount(MAT_GLASS)] cm<sup>3</sup><br>"

	for(var/datum/design/D in files.known_designs)
		if(!(selected_category in D.category))
			continue

		if(disabled || !can_build(D))
			dat += "<span class='linkOff'>[D.name]</span>"
		else
			dat += "<a href='?src=\ref[src];make=[D.id];multiplier=1'>[D.name]</a>"

		var/max_multiplier = min(50,
									D.materials[MAT_METAL] ?round(materials.amount(MAT_METAL)/D.materials[MAT_METAL]):INFINITY,
									D.materials[MAT_GLASS]?round(materials.amount(MAT_GLASS)/D.materials[MAT_GLASS]):INFINITY)
		if(ispath(D.build_path, /obj/item/stack))
			if (max_multiplier>=10 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=10'>x10</a>"
			if (max_multiplier>=25 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=25'>x25</a>"
			if(max_multiplier > 0 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=[max_multiplier]'>x[max_multiplier]</a>"
		else
			if (max_multiplier>=3 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=3'>x3</a>"
			if (max_multiplier>=5 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=5'>x5</a>"
			if(max_multiplier > 0 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=custom'>Set</a>"

		dat += "[get_design_cost(D)]<br>"

	dat += "</div>"
	return dat

/obj/machinery/autolathe/proc/search_win(mob/user)
	var/dat = "<A href='?src=\ref[src];menu=[AUTOLATHE_MAIN_MENU]'>Return to main menu</A>"
	dat += "<div class='statusDisplay'><h3>Search results:</h3><br>"
	dat += "<b>Total amount:</b> [materials.total_amount] / [materials.max_amount] cm<sup>3</sup><br>"
	dat += "<b>Metal amount:</b> [materials.amount(MAT_METAL)] cm<sup>3</sup><br>"
	dat += "<b>Glass amount:</b> [materials.amount(MAT_GLASS)] cm<sup>3</sup><br>"

	for(var/datum/design/D in matching_designs)
		if(disabled || !can_build(D))
			dat += "<span class='linkOff'>[D.name]</span>"
		else
			dat += "<a href='?src=\ref[src];make=[D.id];multiplier=1'>[D.name]</a>"

		var/max_multiplier = min(50,
									D.materials[MAT_METAL] ?round(materials.amount(MAT_METAL)/D.materials[MAT_METAL]):INFINITY,
									D.materials[MAT_GLASS]?round(materials.amount(MAT_GLASS)/D.materials[MAT_GLASS]):INFINITY)
		if(ispath(D.build_path, /obj/item/stack))
			if (max_multiplier>=10 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=10'>x10</a>"
			if (max_multiplier>=25 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=25'>x25</a>"
			if(max_multiplier > 0 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=[max_multiplier]'>x[max_multiplier]</a>"
		else
			if (max_multiplier>=3 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=3'>x3</a>"
			if (max_multiplier>=5 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=5'>x5</a>"
			if(max_multiplier > 0 && !disabled)
				dat += " <a href='?src=\ref[src];make=[D.id];multiplier=custom'>Set</a>"

		dat += "[get_design_cost(D)]<br>"

	dat += "</div>"
	return dat

/obj/machinery/autolathe/proc/can_build(datum/design/D)
	var/coeff = (ispath(D.build_path,/obj/item/stack) ? 1 : 2 ** prod_coeff)

	if(D.materials[MAT_METAL] && (materials.amount(MAT_METAL) < (D.materials[MAT_METAL] / coeff)))
		return 0
	if(D.materials[MAT_GLASS] && (materials.amount(MAT_GLASS) < (D.materials[MAT_GLASS] / coeff)))
		return 0
	return 1

/obj/machinery/autolathe/proc/get_design_cost(datum/design/D)
	var/coeff = (ispath(D.build_path,/obj/item/stack) ? 1 : 2 ** prod_coeff)
	var/dat
	if(D.materials[MAT_METAL])
		dat += "[D.materials[MAT_METAL] / coeff] metal "
	if(D.materials[MAT_GLASS])
		dat += "[D.materials[MAT_GLASS] / coeff] glass"
	return dat

/obj/machinery/autolathe/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/autolathe/proc/adjust_hacked(hack)
	hacked = hack

	if(hack)
		for(var/datum/design/D in files.possible_designs)
			if((D.build_type & AUTOLATHE) && ("hacked" in D.category))
				files.known_designs += D
	else
		for(var/datum/design/D in files.known_designs)
			if("hacked" in D.category)
				files.known_designs -= D

/obj/machinery/autolathe/proc/output_available_resources()
	var/output
	for(var/resource in materials.materials)
		var/amount = materials.amount(resource)
		output += "<span class=\"res_name\">[capitalize(materials.material2name(resource))]: </span>[amount] cm&sup3;"
		if(amount>0)
			output += "<span style='font-size:80%;'>- Remove \[<a href='?src=\ref[src];remove_mat=1;material=[resource]'>1</a>\] | \[<a href='?src=\ref[src];remove_mat=10;material=[resource]'>10</a>\] | \[<a href='?src=\ref[src];remove_mat=50;material=[resource]'>All</a>\]</span>"
		output += "<br/>"
	return output

/obj/machinery/autolathe/atmos
	name = "atmospheric fabricator"
	desc = "It produces atmospheric related items using metal and glass."
	icon_state = "mechfab1"
	default_icon = "mechfab1"
	metalanim = "mechfabo"
	glassanim = "mechfabr"
	making = "mechfab3"
	maintpanel = "mechfabt"
	categories = list("Atmos")
	board = /obj/item/weapon/circuitboard/atmoslathe
	files = /datum/research/autolathe/atmoslathe
