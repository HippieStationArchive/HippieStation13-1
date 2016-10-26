
// see code/datums/recipe.dm

////////////////////////////////////////////////BREAD////////////////////////////////////////////////

/datum/recipe/bread
	reagents = list("flour" = 15)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/plain

/datum/recipe/bread/xenomeat
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/xenomeat

/datum/recipe/bread/spidermeat
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/spider,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/spider,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/spider,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/spidermeat

//Generic meat bread, keep this at the end.
/datum/recipe/bread/meat
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/meat

/datum/recipe/bread/banana
	reagents = list("milk" = 5, "flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/banana

/datum/recipe/bread/tofu
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/tofu

/datum/recipe/bread/creamcheese
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/store/bread/creamcheese

/datum/recipe/bread/baguette
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/baguette
