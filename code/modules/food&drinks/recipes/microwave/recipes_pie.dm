
// see code/datums/recipe.dm

////////////////////////////////////////////////PIES////////////////////////////////////////////////

/datum/recipe/pie
	reagents = list("flour" = 10)
	items = list(
		 /obj/item/weapon/reagent_containers/food/snacks/grown/banana,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/cream

/datum/recipe/pie/meat
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/meat

/datum/recipe/pie/tofu
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result =/obj/item/weapon/reagent_containers/food/snacks/pie/tofupie

/datum/recipe/pie/xemeat
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/xemeatpie

/datum/recipe/pie/cherry
	reagents = list("flour" = 10)
	items = list(
		 /obj/item/weapon/reagent_containers/food/snacks/grown/cherries,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/cherrypie

/datum/recipe/pie/berryclafoutis
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/berries,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/bearypie

/datum/recipe/pie/amanita
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/amanita_pie

/datum/recipe/pie/plump
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/plump_pie


/datum/recipe/pie/apple
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/applepie

/datum/recipe/pie/pumpkin
	reagents = list("milk" = 5, "sugar" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/pumpkinpie
