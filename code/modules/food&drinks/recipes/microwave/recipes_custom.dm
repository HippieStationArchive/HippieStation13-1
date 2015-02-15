////////////////////////////////////////////////CUSTOM FOOD////////////////////////////////////////////////

// /datum/recipe/bread/custom //Custom bread is normal bread + egg
// 	reagents = list("flour" = 15)
// 	items = list(
// 		/obj/item/weapon/reagent_containers/food/snacks/egg
// 	)
// 	result = /obj/item/weapon/reagent_containers/food/snacks/customizable/cook/bread

/datum/recipe/bread/bun
	// reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough //Cook up dat dough good.
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bun

/datum/recipe/bread/flatbread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/flatbread