 //Suits for the pink and grey skeletons!

/obj/item/clothing/suit/space/eva/plasmaman
	name = "plasmaman suit"
	desc = "A special containment suit designed to protect a plasmaman's volatile body from outside exposures."
	allowed = list(/obj/item/weapon/tank)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 0)
	icon_state = "plasmaman_suit"
	item_state = "plasmaman_suit"

//I just want the light feature of the hardsuit helmet
/obj/item/clothing/head/helmet/space/hardsuit/plasmaman
	name = "plasmaman helmet"
	desc = "A special containment helmet designed to protect a plasmaman's volatile body from outside exposure."
	icon_state = "plasmaman_helmet0-plasma"
	item_color = "plasma" //needed for the helmet lighting
	item_state = "plasmaman_helmet0"
	flags = BLOCKHAIR | STOPSPRESSUREDMAGE
	flags_inv = null
	// Overrides the hide item flags from /helmet/space/hardsuit
	basestate = "plasmaman_helmet"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

