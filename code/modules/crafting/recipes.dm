
/datum/table_recipe
	var/name = "" //in-game display name
	var/reqs[] = list() //type paths of items consumed associated with how many are needed
	var/result //type path of item resulting from this craft
	var/tools[] = list() //type paths of items needed but not consumed
	var/time = 30 //time in deciseconds
	var/parts[] = list() //type paths of items that will be placed in the result
	var/chem_catalysts[] = list() //like tools but for reagents
	var/category = CAT_NONE //where it shows up in the crafting UI


/datum/table_recipe/pin_removal
	name = "Pin Removal"
	result = /obj/item/weapon/gun
	reqs = list(/obj/item/weapon/gun = 1)
	parts = list(/obj/item/weapon/gun = 1)
	tools = list(/obj/item/weapon/gun/energy/plasmacutter, /obj/item/weapon/screwdriver, /obj/item/weapon/wirecutters)
	time = 100
	category = CAT_WEAPON
	
/datum/table_recipe/receiver
	name = "Modular Receiver"
	result = /obj/item/weaponcrafting/receiver
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/rods = 2)
	tools = list(/obj/item/weapon/screwdriver, /obj/item/weapon/wirecutters)
	time = 150
	category = CAT_WEAPON

/datum/table_recipe/IED
	name = "IED"
	result = /obj/item/weapon/grenade/iedcasing
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/device/assembly/igniter = 1,
				/obj/item/weapon/reagent_containers/food/drinks/soda_cans = 1)
	parts = list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans = 1)
	time = 80
	category = CAT_WEAPON

/datum/table_recipe/molotov
	name = "Molotov"
	result = /obj/item/weapon/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/weapon/reagent_containers/glass/rag = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/weapon/reagent_containers/food/drinks/bottle = 1)
	time = 80
	category = CAT_WEAPON

/datum/table_recipe/stunprod
	name = "Stunprod"
	result = /obj/item/weapon/melee/baton/cattleprod
	reqs = list(/obj/item/weapon/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/weapon/wirecutters = 1)
	time = 80
	category = CAT_WEAPON

/datum/table_recipe/ed209
	name = "ED209"
	result = /obj/machinery/bot/ed209
	reqs = list(/obj/item/robot_parts/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/robot_parts/l_leg = 1,
				/obj/item/robot_parts/r_leg = 1,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weapon/gun/energy/gun/advtaser = 1,
				/obj/item/weapon/stock_parts/cell = 1,
				/obj/item/device/assembly/prox_sensor = 1)
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 120
	category = CAT_ROBOT

/datum/table_recipe/secbot
	name = "Secbot"
	result = /obj/machinery/bot/secbot
	reqs = list(/obj/item/device/assembly/signaler = 1,
				/obj/item/clothing/head/helmet/sec = 1,
				/obj/item/weapon/melee/baton = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	tools = list(/obj/item/weapon/weldingtool)
	time = 120
	category = CAT_ROBOT

/datum/table_recipe/cleanbot
	name = "Cleanbot"
	result = /obj/machinery/bot/cleanbot
	reqs = list(/obj/item/weapon/reagent_containers/glass/bucket = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 80
	category = CAT_ROBOT

/datum/table_recipe/floorbot
	name = "Floorbot"
	result = /obj/machinery/bot/floorbot
	reqs = list(/obj/item/weapon/storage/toolbox/mechanical = 1,
				/obj/item/stack/tile/plasteel = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 80
	category = CAT_ROBOT

/datum/table_recipe/medbot
	name = "Medbot"
	result = /obj/machinery/bot/medbot
	reqs = list(/obj/item/device/healthanalyzer = 1,
				/obj/item/weapon/storage/firstaid = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 80
	category = CAT_ROBOT

/datum/table_recipe/flamethrower
	name = "Flamethrower"
	result = /obj/item/weapon/flamethrower
	reqs = list(/obj/item/weapon/weldingtool = 1,
				/obj/item/device/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/device/assembly/igniter = 1,
				/obj/item/weapon/weldingtool = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 20
	category = CAT_WEAPON

/datum/table_recipe/meteorshot
	name = "Meteorshot Shell"
	result = /obj/item/ammo_casing/shotgun/meteorshot
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/rcd_ammo = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/stock_parts/capacitor/adv = 2,
				/obj/item/weapon/stock_parts/micro_laser/ultra = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/incendiary/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/phosphorus = 5,)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5,)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/stock_parts/micro_laser/ultra = 1,
				/obj/item/weapon/stock_parts/subspace/crystal = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/improvisedslugoverload
	name = "Overload Improvised Shell"
	result = /obj/item/ammo_casing/shotgun/improvised/overload
	reqs = list(/obj/item/ammo_casing/shotgun/improvised = 1,
				/datum/reagent/blackpowder = 5)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO
	
/datum/table_recipe/coinshot
	name = "Coinshot Shell"
	result = /obj/item/ammo_casing/shotgun/coinshot
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/datum/reagent/fuel = 10,
				/obj/item/weapon/coin = 5)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO
	
/datum/table_recipe/coinshot_overload
	name = "Overload Coinshot Shell"
	result = /obj/item/ammo_casing/shotgun/coinshot/overload
	reqs = list(/obj/item/ammo_casing/shotgun/coinshot = 1,
				/datum/reagent/blackpowder = 5)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/laserslug
	name = "Laser Slug Shell"
	result = /obj/item/ammo_casing/shotgun/laserslug
	reqs = list(/obj/item/ammo_casing/shotgun/improvised = 1,
				/obj/item/weapon/stock_parts/capacitor = 1,
				/obj/item/weapon/stock_parts/micro_laser = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
	category = CAT_AMMO

/datum/table_recipe/ishotgun
	name = "Improvised Shotgun"
	result = /obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/ducttape = 5,)
	tools = list(/obj/item/weapon/screwdriver)
	time = 200
	category = CAT_WEAPON

/datum/table_recipe/spikebat
	name = "Spiked Baseball Bat"
	result = /obj/item/weapon/baseballbat/spike
	reqs = list(/obj/item/weapon/baseballbat/wood = 1,
				/obj/item/stack/rods = 4,)
	time = 120
	category = CAT_WEAPON

/datum/table_recipe/garrote_handles //Still need to apply some wires to finish it
	name = "Garrote Handles"
	result = /obj/item/garrotehandles
	tools = list(/obj/item/weapon/weldingtool)
	reqs = list(/obj/item/stack/cable_coil = 15,
				/obj/item/stack/rods = 1,)
	time = 120
	category = CAT_WEAPON

/datum/table_recipe/paper_cartridge//for duh breechloadin ryefull
	name = "Black Powder Cartridge"
	result = /obj/item/ammo_casing/musket
	tools = list(/obj/item/weapon/screwdriver)
	reqs = list(/obj/item/ammo_casing/minieball = 1,
				/obj/item/stack/ducttape = 2,
				/obj/item/weapon/paper = 1,
				/datum/reagent/blackpowder = 5)
	time = 300
	category = CAT_AMMO


/datum/table_recipe/minieball //for paper cartridge craftin'
	name = "Minieball"
	result = /obj/item/ammo_casing/minieball
	tools = list(/obj/item/weapon/weldingtool)
	reqs = list(/obj/item/stack/sheet/metal = 1)
	time = 120
	category = CAT_WEAPON
