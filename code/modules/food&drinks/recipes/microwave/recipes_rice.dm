//Rice
/datum/recipe/rice/boiled
	reagents = list(
		"rice" = 10,
		"water" = 10
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rice/boiledrice

/datum/recipe/rice/ricepudding
	reagents = list(
		"milk" = 5,
		"sugar" = 5
	)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rice/boiledrice
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rice/ricepudding

/datum/recipe/rice/ricepork
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rice/boiledrice,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rice/ricepork

/datum/recipe/rice/eggbowl
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rice/boiledrice,
		/obj/item/weapon/reagent_containers/food/snacks/egg
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/rice/eggbowl