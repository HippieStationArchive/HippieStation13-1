///////////////////
// RESEARCH ITEM //
///////////////////

/datum/design/bot_upgrade
	build_type = MECHFAB
	materials = list(MAT_GLASS = 2000, MAT_METAL = 4000)
	category = list("Misc")
	construction_time = 100
	// Should not be acquirable

/datum/design/bot_upgrade/boost
	name = "Bot Upgrade: Boost"
	desc = "The circuit board for giving a speed boost to bots"
	id = "bot_upgrade_boost"
	req_tech = list("programming" = 2, "engineering" = 2)
	build_path = /obj/item/weapon/bot_upgrade/boost

////////////////////////
// CIRCUIT BOARD ITEM //
////////////////////////

/obj/item/weapon/bot_upgrade
	density = 0
	anchored = 0
	w_class = 2
	name = "bot upgrade"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	origin_tech = "programming=2"
	materials = list(MAT_GLASS = 2000, MAT_METAL = 4000)
	var/board_type = "computer"

/obj/item/weapon/bot_upgrade/boost
	name = "Bot Upgrade: Boost"
	desc = "An upgrade for bots which provide them with a speed boost."
	origin_tech = "programming=2;engineering=2"
	var/boost = FALSE
	var/boost_length = 50     // in deciseconds
	var/boost_cooldown = 300  // in deciseconds
	var/boost_multiplier = 2.5