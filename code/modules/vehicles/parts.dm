/obj/item/vehicle_parts
	name = "vehicle part"
	icon = 'icons/vehicles/Bike.dmi'
	icon_state = "blank"
	w_class = 4  //Will vary between parts
	flags = CONDUCT
	origin_tech = "programming=2;materials=2"
	var/durability = 100 //Durability of the part
	var/weight = 10 //Mass of part
	slowdown = 2


/obj/item/vehicle_parts/engine
	name = "engine"
	var/engine_power = 100 //Engine power, used to calculate the delay between movement
	var/fueluse = 1
	var/fueltype = "welding_fuel" //This is the fueltype, use the IDs, not the paths




/obj/item/vehicle_parts/propulsion
	name = "propulsion"
	var/thrust_type = "rolling" //Will look into this later
	var/nograv = 0 //Can it function with no gravity?
	weight = 0 //Typically has no weight as it's SUPPORTING the chassis
	icon_state = "wheels"

/obj/item/weapon/reagent_containers/fueltank //YES IT IS A REAGENT CONTAINER, SHUT UP
	name = "fuel tank"
	desc = "A large fuel tank, pretty much impossible to put into your backpack"
	w_class = 5
	slowdown = 2
	volume = 100//How much fuel the tank can hold


/obj/item/vehicle_parts/chassis
	name = "chassis"
	var/max_mass = 200
	var/occupants_max = 2
	icon_state = "chassis"

/obj/item/vehicle_parts/armor
	name = "armor"
	weight = 100
	//(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) Armor value positions
	armor = list(0,0,0,0,0,0,0)//Damage reduction based on armor

/obj/item/vehicle_parts/seat
	name = "seat"
	weight = 0

