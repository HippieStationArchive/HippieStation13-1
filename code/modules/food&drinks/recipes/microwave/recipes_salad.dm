////////////////////////////////////////////////SALADS////////////////////////////////////////////////

/datum/recipe/salad/herb
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/herbsalad

/datum/recipe/salad/aesir
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/deus,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/deus,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/deus,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple/gold,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/aesirsalad

/datum/recipe/salad/valid
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris,
		/obj/item/weapon/reagent_containers/food/snacks/grown/potato,
		/obj/item/weapon/reagent_containers/food/snacks/faggot,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/validsalad

/datum/recipe/salad/oatmeal
	reagents = list("milk" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/glass/bowl = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/oat = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/oatmeal

/datum/recipe/salad/fruitsalad
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/grapes = 1,
		/obj/item/weapon/reagent_containers/food/snacks/watermelonslice = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/fruit

/datum/recipe/salad/junglesalad
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/grapes = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 2,
		/obj/item/weapon/reagent_containers/food/snacks/watermelonslice = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/jungle

/datum/recipe/salad/citrusdelight
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lime = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lemon = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/salad/citrusdelight

