//this category is very little but I think that it has great potential to grow
////////////////////////////////////////////SALAD////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/snacks/salad
	icon = 'icons/obj/food/soupsalad.dmi'
	trash = /obj/item/trash/snack_bowl
	bitesize = 3
	w_class = 3
	list_reagents = list("nutriment" = 7, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/salad/New()
	..()
	eatverb = pick("crunch","devour","nibble","gnaw","gobble","chomp")

/obj/item/weapon/reagent_containers/food/snacks/salad/aesirsalad
	name = "\improper Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	bonus_reagents = list("omnizine" = 2, "vitamin" = 6)
	list_reagents = list("nutriment" = 8, "omnizine" = 8, "vitamin" = 6)

/obj/item/weapon/reagent_containers/food/snacks/salad/herbsalad
	name = "herb salad"
	desc = "A tasty salad with apples on top."
	icon_state = "herbsalad"
	bonus_reagents = list("vitamin" = 4)
	list_reagents = list("nutriment" = 8, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/salad/validsalad
	name = "valid salad"
	desc = "It's just an herb salad with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	bonus_reagents = list("doctorsdelight" = 5, "vitamin" = 4)
	list_reagents = list("nutriment" = 8, "doctorsdelight" = 5, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/salad/oatmeal
	name = "oatmeal"
	desc = "A nice bowl of oatmeal."
	icon_state = "oatmeal"
	bonus_reagents = list("nutriment" = 4, "vitamin" = 4)
	list_reagents = list("nutriment" = 7, "milk" = 10, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/salad/fruit
	name = "fruit salad"
	desc = "Your standard fruit salad."
	icon_state = "fruitsalad"
	bonus_reagents = list("nutriment" = 2, "vitamin" = 4)

/obj/item/weapon/reagent_containers/food/snacks/salad/jungle
	name = "jungle salad"
	desc = "Exotic fruits in a bowl."
	icon_state = "junglesalad"
	bonus_reagents = list("nutriment" = 4, "vitamin" = 4)
	list_reagents = list("nutriment" = 7, "banana" = 5, "vitamin" = 4)

/obj/item/weapon/reagent_containers/food/snacks/salad/citrusdelight
	name = "citrus delight"
	desc = "Citrus overload!"
	icon_state = "citrusdelight"
	bonus_reagents = list("nutriment" = 4, "vitamin" = 4)
	list_reagents = list("nutriment" = 7, "vitamin" = 5)