
////////////////////////////////////////////////KEBABS NO REMOVE////////////////////////////////////////////////


/datum/recipe/kebab/monkey
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/monkey

/datum/recipe/kebab/lizard
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human/lizard

/datum/recipe/kebab/bird
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/bird,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/bird
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human/lizard

/datum/recipe/kebab/robo
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/robo,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/robo
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human/robo

/datum/recipe/kebab/cat
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/cat,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/cat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human/cat

/datum/recipe/kebab/moth
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/moth,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/moth
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human/moth

//Put this AFTER snowflake races or else all species make the same kebab.
/datum/recipe/kebab/human
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human

/datum/recipe/kebab/tofu
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/tofu

/datum/recipe/kebab/rat
	items = list(
		/obj/item/stack/rods = 1,
		/obj/item/trash/deadmouse = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/rat

/datum/recipe/kebab/doublerat
	items = list(
		/obj/item/stack/rods = 1,
		/obj/item/trash/deadmouse = 1,
		/obj/item/trash/deadmouse = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/doublerat


////////////////////////////////////////////////FISH////////////////////////////////////////////////

/datum/recipe/carpmeat
	reagents = list("carpotoxin" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/carpmeat/imitation

/datum/recipe/cubancarp
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cubancarp

/datum/recipe/fishandchips
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishandchips

/datum/recipe/fishfingers
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishfingers

/datum/recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spidereggs,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sashimi

////////////////////////////////////////////////MR SPIDER////////////////////////////////////////////////

/datum/recipe/boiledspiderleg
	reagents = list("water" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spiderleg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledspiderleg

/datum/recipe/spidereggsham
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spidereggs,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/spider,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/spidereggsham

////////////////////////////////////////////////MISC RECIPE's////////////////////////////////////////////////

/datum/recipe/cornedbeef
	reagents = list("sodiumchloride" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cornedbeef

/datum/recipe/meatsteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human

/datum/recipe/enchiladas
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili,
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili,
		/obj/item/weapon/reagent_containers/food/snacks/grown/corn,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/enchiladas

/datum/recipe/stewedsoymeat
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/grown/carrot,
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat

/datum/recipe/sausage
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/faggot,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sausage
