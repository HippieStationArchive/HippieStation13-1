/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "blue laser tag armor"
	desc = "A piece of plastic armor. It has sensors that react to red light." //Lasers are concentrated light
	icon_state = "bluetag"
	item_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/weapon/gun/energy/laser/bluetag)

/obj/item/clothing/suit/redtag
	name = "red laser tag armor"
	desc = "A piece of plastic armor. It has sensors that react to blue light."
	icon_state = "redtag"
	item_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/weapon/gun/energy/laser/redtag)

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"


/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	item_state = "hgpirate"
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	item_state = "death"
	flags = CONDUCT
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/greatcoat
	name = "greatcoat"
	desc = "A Nazi greatcoat."
	icon_state = "nazi"
	item_state = "nazi"


/obj/item/clothing/suit/johnny_coat
	name = "johnny~~ coat"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"


/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "this pretty much looks ridiculous" //Needs no fixing
	icon_state = "justice"
	item_state = "justice"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/spacecash)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	item_state = "overalls"
	body_parts_covered = CHEST|GROIN|LEGS


/obj/item/clothing/suit/syndicatefake
	name = "black and red space suit replica"
	icon_state = "syndicate-black-red"
	item_state = "syndicate-black-red"
	desc = "A plastic replica of the Syndicate space suit. You'll look just like a real murderous Syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = 3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/hastur
	name = "\improper Hastur's robe"
	desc = "Robes not meant to be worn by man."
	icon_state = "hastur"
	item_state = "hastur"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "\improper Imperium monk suit"
	desc = "Have YOU killed a xeno today?"
	icon_state = "imperium_monk"
	item_state = "imperium_monk"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/emergency_oxygen)


/obj/item/clothing/suit/chickensuit
	name = "chicken suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	item_state = "chickensuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/monkeysuit
	name = "monkey suit"
	desc = "A suit that looks like a primate."
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/holidaypriest
	name = "holiday priest"
	desc = "This is a nice holiday, my son."
	icon_state = "holidaypriest"
	item_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/emergency_oxygen)



/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/poncho
	name = "poncho"
	desc = "Your classic, non-racist poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"

/obj/item/clothing/suit/poncho/green
	name = "green poncho"
	desc = "Your classic, non-racist poncho. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/suit/poncho/red
	name = "red poncho"
	desc = "Your classic, non-racist poncho. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/suit/poncho/ponchoshame
	name = "poncho of shame"
	desc = "Forced to live on your shameful acting as a fake Mexican, you and your poncho have grown inseperable. Literally."
	icon_state = "ponchoshame"
	item_state = "ponchoshame"
	flags = NODROP

/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
	desc = "A suit that completely restrains the wearer. Manufactured by Antyphun Corp." //Straight jacket is antifun
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	strip_delay = 60

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	item_state = "ianshirt"

/obj/item/clothing/suit/nerdshirt
	name = "gamer shirt"
	desc = "A baggy shirt with vintage game character Phanic the Weasel. Why would anyone wear this?"
	icon_state = "nerdshirt"
	item_state = "nerdshirt"

/obj/item/clothing/suit/jacket
	name = "bomber jacket"
	desc = "Aviators not included."
	icon_state = "bomberjacket"
	item_state = "johnny"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/jacket/leather
	name = "leather jacket"
	desc = "Pompadour not included."
	icon_state = "leatherjacket"

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state = "xenos_helm"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/toggle/owlwings
	name = "owl cloak"
	desc = "A soft brown cloak made of synthetic feathers. Soft to the touch, stylish, and a 2 meter wing span that will drive the ladies mad."
	icon_state = "owl_wings"
	item_state = "owl_wings"
	togglename = "wings"
	body_parts_covered = ARMS|CHEST
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite)
	action_button_name = "Toggle Owl Wings"

/obj/item/clothing/suit/toggle/owlwings/griffinwings
	name = "griffon cloak"
	desc = "A plush white cloak made of synthetic feathers. Soft to the touch, stylish, and a 2 meter wing span that will drive your captives mad."
	icon_state = "griffin_wings"
	item_state = "griffin_wings"

// Payday Tux #wow
//Toggle sprite not in yet deal with it

/obj/item/clothing/suit/toggle/tux
	name = "Tuxedo"
	desc = "Wow does that look fancy!"
	icon_state = "tux"
	item_state = "tux"
	togglename = "buttons"
	action_button_name = "Toggle Suit Buttons"
	body_parts_covered = ARMS|CHEST
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite)


// non-WINTER COATS

/obj/item/clothing/suit/hooded/wintercoat
	name = "coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	item_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter)
	hooded = 1
	action_button_name = "Toggle Winter Hood"
	togglename = "hood"

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags = NODROP

/obj/item/clothing/suit/hooded/wintercoat/captain
	name = "captain's coat"
	icon_state = "coatcaptain"
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/truncheon/telebaton)

/obj/item/clothing/suit/hooded/wintercoat/security
	name = "security coat"
	icon_state = "coatsecurity"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/truncheon/telebaton)

/obj/item/clothing/suit/hooded/wintercoat/medical
	name = "medical coat"
	icon_state = "coatmedical"
	allowed = list(/obj/item/device/analyzer,/obj/item/weapon/reagent_containers/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/melee/truncheon/telebaton)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/hooded/wintercoat/science
	name = "science coat"
	icon_state = "coatscience"
	allowed = list(/obj/item/device/analyzer,/obj/item/weapon/reagent_containers/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/melee/truncheon/telebaton)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/hooded/wintercoat/engineering
	name = "engineering coat"
	icon_state = "coatengineer"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/t_scanner, /obj/item/weapon/rcd)

/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos
	name = "atmospherics coat"
	icon_state = "coatatmos"

/obj/item/clothing/suit/hooded/wintercoat/hydro
	name = "hydroponics coat"
	icon_state = "coathydro"
	allowed = list(/obj/item/weapon/reagent_containers/spray/plantbgone,/obj/item/device/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/minihoe,/obj/item/weapon/reagent_containers/spray/pestspray,/obj/item/weapon/hatchet,/obj/item/weapon/storage/bag/plants)

/obj/item/clothing/suit/hooded/wintercoat/cargo
	name = "cargo coat"
	icon_state = "coatcargo"

/obj/item/clothing/suit/hooded/wintercoat/miner
	name = "mining coat"
	icon_state = "coatminer"
	allowed = list(/obj/item/weapon/pickaxe,/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter)
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/raincoat
	name = "Raincoat"
	desc = "Do you like Huey Lewis and the News?"
	icon_state = "raincoat"
	item_state = "raincoat"
	allowed = list (/obj/item/weapon/twohanded/fireaxe)
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

//FPSS13 PORTS!

/obj/item/clothing/suit/reporterjacket
	name = "Reporter Jacket"
	desc = "With my handy dandy notebook!"
	icon_state = "reporterjacket"
	item_state = "reporterjacket"

/obj/item/clothing/suit/welder
	name = "Welder's Apron"
	desc = "It's got a disgusting brown color. Kinda reminds you of dried blood..."
	icon_state = "apronwelder2"
	item_state = "apronwelder2"

/obj/item/clothing/suit/armor/beebox
	name = "Bee Box"
	desc = "A largish beebox that goes over the entire waist, and is supported by straps"
	icon_state = "beebox"
	item_state = "beebox"
	armor = list(melee = 10, bullet = 1, laser = 1, energy = 1, bomb = 0, bio = 0, rad = 0)

