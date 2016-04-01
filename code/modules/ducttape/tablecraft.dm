/datum/table_recipe/makeshift_armor
	name = "Makeshift Armor"
	result = /obj/item/clothing/suit/armor/makeshift
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/clothing/suit/hazardvest = 1,
				/obj/item/stack/ducttape = 5)
	time = 80
	category = CAT_ARMOR

/datum/table_recipe/knifegloves
	name = "Knife Box Gloves"
	result = /obj/item/clothing/gloves/knife
	reqs = list(/obj/item/clothing/gloves/boxing = 1,
				/obj/item/weapon/kitchen/knife = 2,
				/obj/item/stack/ducttape = 5)
	parts = list(/obj/item/clothing/gloves/boxing = 1)
	time = 80
	category = CAT_WEAPON

/datum/table_recipe/retspear
	name = "Retractable Spear"
	result = /obj/item/weapon/melee/retractable_spear
	reqs = list(/obj/item/weapon/melee/classic_baton/telescopic = 1,
				/obj/item/weapon/shank = 1,
				/obj/item/stack/cable_coil = 5)
	time = 80
	category = CAT_WEAPON
