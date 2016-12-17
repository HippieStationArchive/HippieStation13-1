
////////////////////////////////////////////////DONUTS////////////////////////////////////////////////

/datum/recipe/donut
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut

/datum/recipe/donut/jelly
	reagents = list("berryjuice" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/jelly

/datum/recipe/donut/jelly/slime
	reagents = list("slimejelly" = 5, "flour" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/jelly/slimejelly

/datum/recipe/donut/jelly/cherry
	reagents = list("cherryjelly" = 5, "flour" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/jelly/cherryjelly

/datum/recipe/chaosdonut
	reagents = list("frostoil" = 5, "capsaicin" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/chaos


////////////////////////////////////////////////WAFFLES////////////////////////////////////////////////

/datum/recipe/waffles
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/waffles


/datum/recipe/waffles/soylenviridians
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/soylenviridians

/datum/recipe/waffles/soylentgreen
	reagents = list("flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/soylentgreen


/datum/recipe/waffles/roffle
	reagents = list("mushroomhallucinogen" = 5, "flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rofflewaffles

////////////////////////////////////////////////DONKPOCCKETS////////////////////////////////////////////////

/datum/recipe/donkpocket
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/faggot,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donkpocket

/datum/recipe/donkpocketwarm
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donkpocket/warm

////////////////////////////////////////////////MUFFINS////////////////////////////////////////////////

/datum/recipe/muffin
	reagents = list("milk" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/muffin

/datum/recipe/muffin/berry
	reagents = list("milk" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/grown/berries
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/muffin/berry

/datum/recipe/muffin/booberry
	reagents = list("milk" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/grown/berries,
		/obj/item/weapon/ectoplasm
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/muffin/booberry

/datum/recipe/muffin/chawanmushi
	reagents = list("water" = 5, "soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/chanterelle,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chawanmushi

////////////////////////////////////////////OTHER////////////////////////////////////////////

/datum/recipe/hotdog
	reagents = list("ketchup" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/sausage,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/hotdog

/datum/recipe/meatbun
	reagents = list("soysauce" = 5, "flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/faggot,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatbun

/datum/recipe/sugarcookie
	reagents = list("flour" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sugarcookie

/datum/recipe/fortunecookie
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/paper,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fortunecookie
/datum/recipe/fortunecookie/make_food(var/obj/container as obj)
	var/obj/item/weapon/paper/paper = locate() in container
	paper.loc = null //prevent deletion
	var/obj/item/weapon/reagent_containers/food/snacks/fortunecookie/being_cooked = ..(container)
	paper.loc = being_cooked
	being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
	return being_cooked

/datum/recipe/poppypretzel
	reagents = list("flour" = 5)
	items = list(
		/obj/item/seeds/poppyseed,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/poppypretzel

/datum/recipe/plumphelmetbiscuit
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit

/datum/recipe/appletart
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple/gold,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie/appletart

//TODO: Add the other tarts

/datum/recipe/cracker
	reagents = list("flour" = 5, "sodiumchloride" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/cracker