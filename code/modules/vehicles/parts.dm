/obj/item/vehicle_parts
	name = "vehicle part"
	icon = 'icons/vehicles/Bike.dmi'
	icon_state = "blank"
	w_class = 5  //Will vary between parts
	flags = CONDUCT
	origin_tech = "programming=2;materials=2"
	var/durability = 100 //Durability of the part
	var/weight = 10 //Mass of part
	slowdown = 2
	var/part_type = null


/obj/item/vehicle_parts/engine //Regent-based engines, other electric engines will need to overwrite engine_act()
	name = "engine"
	desc = "A generic, welding fuel powered engine"
	var/engine_power = 100 //Engine power, used to calculate the delay between movement AND how much power it gives to the cell
	var/fueluse = 1 //How many units it uses per move,
	var/fueltype = "welding_fuel" //This is the fueltype, use the IDs, not the paths
	part_type = "engine"

//The act proc for doing effects while the engine is running, such as leaving a fire trail, draining the tank or cell of fuel, modify it per engine
/obj/item/vehicle_parts/engine/proc/engine_act(var/obj/item/weapon/reagent_containers/fueltank/fueltank, var/obj/item/weapon/stock_parts/cell/cell, var/mob/user)
	var/returnmsg
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


/obj/item/vehicle_parts/propulsion
	name = "propulsion"
	var/thrust_type = "rolling" //Will look into this later
	var/nograv = 0 //Can it function with no gravity?
	weight = 0 //Typically has no weight as it's SUPPORTING the chassis
	icon_state = "wheels"
	part_type = "propulsion"

/obj/item/weapon/reagent_containers/fueltank //YES IT IS A REAGENT CONTAINER, SHUT UP
	name = "fuel tank"
	desc = "A large, heavy fuel tank, pretty much impossible to put into your backpack"
	w_class = 5
	slowdown = 2
	volume = 100//How much fuel the tank can hold
	var/part_type = "fueltank"
	var/weight = 10
	var/durability = 200


/obj/item/vehicle_parts/chassis
	name = "chassis"
	var/max_mass = 300
	var/occupants_max = 2
	icon_state = "chassis"
	part_type = "chassis"

/obj/item/vehicle_parts/armor
	name = "armor"
	weight = 100
	//(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0) Armor value positions
	var/vehicle_armor = list("melee"=0,"bullet"=0,"laser"=0,"energy"=0,"bomb"=0)//Damage reduction based on armor
	part_type = "armor"

/obj/item/vehicle_parts/seat
	name = "seat"
	weight = 0
	var/safety = 100 //Safety, between 0 and 100 for right now
	part_type = "seat"

