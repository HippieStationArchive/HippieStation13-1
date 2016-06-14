
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("ethanol" = 1, "charcoal" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/spraytan
	name = "Spray Tan"
	id = "spraytan"
	result = "spraytan"
	required_reagents = list("orangejuice" = 1, "oil" = 1)
	result_amount = 2

/datum/chemical_reaction/spraytan2
	name = "Spray Tan"
	id = "spraytan"
	result = "spraytan"
	required_reagents = list("orangejuice" = 1, "cornoil" = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("water" = 1, "sodium" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/capsaicincondensation
	name = "Capsaicincondensation"
	id = "capsaicincondensation"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 1, "ethanol" = 5)
	result_amount = 5

/datum/chemical_reaction/soapification
	name = "Soapification"
	id = "soapification"
	result = null
	required_reagents = list("liquidgibs" = 15, "lye"  = 15) // requires three scooped gib tiles
	required_temp = 374
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/soapification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/weapon/soap/homemade(location)
	return

/datum/chemical_reaction/candlefication
	name = "candlefication"
	id = "candlefication"
	result = null
	required_reagents = list("liquidgibs" = 5, "oxygen"  = 5)
	required_temp = 374
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/candlefication/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/candle(location)
	return

/datum/chemical_reaction/meatification
	name = "meatification"
	id = "meatification"
	result = "null"
	required_reagents = list("liquidgibs" = 10, "nutriment" = 10, "carbon" = 10)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/meatification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/meatproduct(location)
	return


////////////////////////////////// VIROLOGY //////////////////////////////////////////

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	required_reagents = list("water" = 5, "milk" = 5)
	result_amount = 15

/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	result = "blood"
	required_reagents = list("virusfood" = 1)
	required_catalysts = list("blood" = 1)
	var/level_min = 0
	var/level_max = 2

/datum/chemical_reaction/mix_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level_min, level_max)


/datum/chemical_reaction/mix_virus/mix_virus_2

	name = "Mix Virus 2"
	id = "mixvirus2"
	required_reagents = list("mutagen" = 1)
	level_min = 2
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_3

	name = "Mix Virus 3"
	id = "mixvirus3"
	required_reagents = list("plasma" = 1)
	level_min = 4
	level_max = 6

/datum/chemical_reaction/mix_virus/rem_virus

	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list("synaptizine" = 1)
	required_catalysts = list("blood" = 1)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()



////////////////////////////////// foam and foam precursor ///////////////////////////////////////////////////


/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5


/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2
	mob_react = 1

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution spews out foam!</span>"
	var/datum/effect_system/foam_spread/s = new()
	s.set_up(created_volume, location, holder)
	s.start()
	holder.clear_reagents()
	return


/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminium" = 3, "foaming_agent" = 1, "facid" = 1)
	result_amount = 5
	mob_react = 1

/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution spews out a metallic foam!</span>"

	var/datum/effect_system/foam_spread/metal/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "facid" = 1)
	result_amount = 5
	mob_react = 1

/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution spews out a metallic foam!</span>"
	var/datum/effect_system/foam_spread/metal/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1


/////////////////////////////// Cleaning and hydroponics /////////////////////////////////////////////////

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	result = "weedkiller"
	required_reagents = list("toxin" = 1, "ammonia" = 4)
	result_amount = 5

/datum/chemical_reaction/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	result = "pestkiller"
	required_reagents = list("toxin" = 1, "ethanol" = 4)
	result_amount = 5

/datum/chemical_reaction/drying_agent
	name = "Drying agent"
	id = "drying_agent"
	result = "drying_agent"
	required_reagents = list("stable_plasma" = 2, "ethanol" = 1, "sodium" = 1)
	result_amount = 3

//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	name = "acetone"
	id = "acetone"
	result = "acetone"
	required_reagents = list("oil" = 1, "welding_fuel" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/carpet
	name = "carpet"
	id = "carpet"
	result = "carpet"
	required_reagents = list("space_drugs" = 1, "blood" = 1)
	result_amount = 2


/datum/chemical_reaction/oil
	name = "Oil"
	id = "oil"
	result = "oil"
	required_reagents = list("welding_fuel" = 1, "carbon" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/phenol
	name = "phenol"
	id = "phenol"
	result = "phenol"
	required_reagents = list("water" = 1, "chlorine" = 1, "oil" = 1)
	result_amount = 3

/datum/chemical_reaction/ash
	name = "Ash"
	id = "ash"
	result = "ash"
	required_reagents = list("oil" = 1)
	result_amount = 1
	required_temp = 480

//////////////////////////////////// Colorant ///////////////////////////////////////////

/datum/chemical_reaction/colorful_reagent
 	name = "colorful_reagent"
 	id = "colorful_reagent"
 	result = "colorful_reagent"
 	required_reagents = list("stable_plasma" = 1, "radium" = 1, "space_drugs" = 1, "cryoxadone" = 1, "triple_citrus" = 1)
 	result_amount = 5

/datum/chemical_reaction/red_reagent
	name = "red_reagent"
	id = "red_reagent"
	result = "red_reagent"
	required_reagents = list("colorful_reagent" = 1, "redcrayonpowder" = 1)
	result_amount = 2

/datum/chemical_reaction/orange_reagent
	name = "orange_reagent"
	id = "orange_reagent"
	result = "orange_reagent"
	required_reagents = list("colorful_reagent" = 1, "orangecrayonpowder" = 1)
	result_amount = 2

/datum/chemical_reaction/yellow_reagent
	name = "yellow_reagent"
	id = "yellow_reagent"
	result = "yellow_reagent"
	required_reagents = list("colorful_reagent" = 1, "yellowcrayonpowder" = 1)
	result_amount = 2

/datum/chemical_reaction/green_reagent
	name = "green_reagent"
	id = "green_reagent"
	result = "green_reagent"
	required_reagents = list("colorful_reagent" = 1, "greencrayonpowder" = 1)
	result_amount = 2

/datum/chemical_reaction/blue_reagent
	name = "blue_reagent"
	id = "blue_reagent"
	result = "blue_reagent"
	required_reagents = list("colorful_reagent" = 1, "bluecrayonpowder" = 1)
	result_amount = 2

/datum/chemical_reaction/purple_reagent
	name = "purple_reagent"
	id = "purple_reagent"
	result = "purple_reagent"
	required_reagents = list("colorful_reagent" = 1, "purplecrayonpowder" = 1)
	result_amount = 2

/datum/chemical_reaction/life
	name = "Life"
	id = "life"
	result = null
	required_reagents = list("strange_reagent" = 1, "synthflesh" = 1, "blood" = 1)
	result_amount = 1
	required_temp = 374

/datum/chemical_reaction/life/on_reaction(datum/reagents/holder, created_volume)
	chemical_mob_spawn(holder, 1, "Life")

/datum/chemical_reaction/corgium
	name = "corgium"
	id = "corgium"
	result = null
	required_reagents = list("nutriment" = 1, "colorful_reagent" = 1, "strange_reagent" = 1, "blood" = 1)
	result_amount = 1
	required_temp = 374

/datum/chemical_reaction/corgium/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /mob/living/simple_animal/pet/dog/corgi(location)
	..()

/datum/chemical_reaction/hair_dye
	name = "hair_dye"
	id = "hair_dye"
	result = "hair_dye"
	required_reagents = list("colorful_reagent" = 1, "radium" = 1, "space_drugs" = 1)
	result_amount = 5

/datum/chemical_reaction/barbers_aid
	name = "barbers_aid"
	id = "barbers_aid"
	result = "barbers_aid"
	required_reagents = list("carpet" = 1, "radium" = 1, "space_drugs" = 1)
	result_amount = 5

/datum/chemical_reaction/concentrated_barbers_aid
	name = "concentrated_barbers_aid"
	id = "concentrated_barbers_aid"
	result = "concentrated_barbers_aid"
	required_reagents = list("barbers_aid" = 1, "mutagen" = 1)
	result_amount = 2

/datum/chemical_reaction/saltpetre
	name = "saltpetre"
	id = "saltpetre"
	result = "saltpetre"
	required_reagents = list("potassium" = 1, "nitrogen" = 1, "oxygen" = 3)
	result_amount = 3

/datum/chemical_reaction/lye
	name = "lye"
	id = "lye"
	result = "lye"
	required_reagents = list("sodium" = 1, "hydrogen" = 1, "oxygen" = 3)
	result_amount = 3
	
//////////////////////////////////// Solidification ///////////////////////////////////////////

/datum/chemical_reaction/plasmasolidification
	name = "Solid Plasma"
	id = "solidplasma"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "plasma" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/plasmasolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/plasma(location)
	return

/datum/chemical_reaction/metalsolidification
	name = "Solid Metal"
	id = "solidmetal"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "iron" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/metalsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/metal(location)
	return

/datum/chemical_reaction/glasssolidification
	name = "Solid Glass"
	id = "solidglass"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "silicon" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/glasssolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/glass(location)
	return

/datum/chemical_reaction/uraniumsolidification
	name = "Solid Uranium"
	id = "soliduranium"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "uranium" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/uraniumsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/uranium(location)
	return

/datum/chemical_reaction/bananiumsolidification
	name = "Solid Bananium"
	id = "solidbananium"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "banana" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/bananiumsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/bananium(location)
	return

/datum/chemical_reaction/silversolidification
	name = "Solid Silver"
	id = "solidsilver"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "silver" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/silversolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/silver(location)
	return

/datum/chemical_reaction/goldsolidification
	name = "Solid Gold"
	id = "solidgold"
	result = null
	required_reagents = list("pyrosium" = 10, "cryostylane" = 10, "gold" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/goldsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/gold(location)
	return
	
