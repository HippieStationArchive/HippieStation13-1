/obj/item/vehicle_parts/engine //Regent-based engines, other electric engines will need to overwrite engine_act()
	name = "engine"
	desc = "A generic, welding fuel powered engine"
	icon = 'icons/vehicles/items.dmi'
	icon_state = "blank"
	var/engine_power = 100 //Engine power, used to calculate the delay between movement AND how much power it gives to the cell
	var/fueluse = 1 //How many units it uses per move,
	var/fueltype = "welding_fuel" //This is the fueltype, use the IDs, not the paths
	part_type = "engine"

//The act proc for doing effects while the engine is running, such as leaving a fire trail, draining the tank or cell of fuel, modify it per engine, or dont
/obj/item/vehicle_parts/engine/proc/engine_act(obj/item/weapon/reagent_containers/fueltank/fueltank, obj/item/weapon/stock_parts/cell/cell, mob/user, returnmsg)
	if(!cell) //I would draw on the cell to start the engine, but i'll leave this out for now
		returnmsg = "nocell"
		return returnmsg
	else if(!fueltank.reagents.has_reagent(fueltype, fueluse))
		returnmsg = "nofuel"
		return returnmsg
	else
		fueltank.reagents.remove_reagent(fueltype, fueluse)
		if(!fueltank.reagents.has_reagent(fueltype, fueluse))
			user.visible_message("<span class='danger'>[src]'s engine stops abruptly.</span>",
			"<span class='danger'>[src]'s engine stops abruptly</span>",
			"<span class='italics'>You hear an engine die down</span>")

/obj/item/vehicle_parts/engine/electric
	name = "electric engine"
	desc = "A generic, cell-consuming electric engine"
	fueluse = 20 //Use charge for electric engines, reusing fueluse for this purpose
	engine_power = 20 //Weaker, but doesnt use fuel

/obj/item/vehicle_parts/engine/electric/engine_act(obj/item/weapon/reagent_containers/fueltank/fueltank, obj/item/weapon/stock_parts/cell/cell, mob/user, returnmsg)
	if(!cell)
		returnmsg = "nocell"
		return returnmsg
	else if(!fueluse >= cell.charge)
		returnmsg = "nofuel"
		return returnmsg
	else
		cell.use(fueluse)
		if(!fueluse >= cell.charge)
			user.visible_message("<span class='danger'>[src]'s engine stops abruptly.</span>",
			"<span class='danger'>[src]'s engine stops abruptly</span>",
			"<span class='italics'>You hear an engine die down</span>")




/obj/item/vehicle_parts/engine/fire
	name = "fire engine"
	desc = "Shoots fucking flames out the back when it moves"

/obj/item/vehicle_parts/engine/fire/engine_act(var/obj/item/weapon/reagent_containers/fueltank/fueltank, var/obj/item/weapon/stock_parts/cell/cell, var/mob/user, var/returnmsg)
	if(!cell) //I would draw on the cell to start the engine, but i'll leave this out for now
		returnmsg = "nocell"
		return returnmsg
	else if(!fueltank.reagents.has_reagent(fueltype, fueluse))
		returnmsg = "nofuel"
		return returnmsg
	else
		fueltank.reagents.remove_reagent(fueltype, fueluse)
		if(!fueltank.reagents.has_reagent(fueltype, fueluse))
			user.visible_message("<span class='danger'>[src]'s engine stops abruptly.</span>",
			"<span class='danger'>[src]'s engine stops abruptly</span>",
			"<span class='italics'>You hear an engine die down</span>")

		var/turf/location = get_turf(src)
		if(location)
			PoolOrNew(/obj/effect/hotspot, location)
			location.hotspot_expose(700, 50, 1)