/datum/supply_pack
	var/name = "Crate"
	var/group = ""
	var/hidden = FALSE
	var/contraband = FALSE
	var/cost = 7 // Minimum cost, or infinite points are possible.
	var/access = FALSE
	var/list/contains = null
	var/crate_name = "crate"
	var/crate_type = /obj/structure/closet/crate
	var/dangerous = FALSE // Should we message admins?

/datum/supply_pack/proc/generate(turf/T)
	var/obj/structure/closet/crate/C = new crate_type(T)
	C.name = crate_name
	if(access)
		C.req_access = list(access)

	for(var/item in contains)
		new item(C)
	return C

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/emergency
	group = "Emergency"

/datum/supply_pack/emergency/equipment
	name = "Emergency Equipment"
	cost = 3500
	contains = list(/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/medbot,
					/mob/living/simple_animal/bot/medbot,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas)
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/internals
	name = "Internals Crate"
	cost = 1000
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air)
	crate_name = "internals crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/firefighting
	name = "Firefighting Crate"
	cost = 1000
	contains = list(/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/device/flashlight,
					/obj/item/device/flashlight,
					/obj/item/weapon/tank/internals/oxygen/red,
					/obj/item/weapon/tank/internals/oxygen/red,
					/obj/item/weapon/extinguisher,
					/obj/item/weapon/extinguisher,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red)
	crate_name = "firefighting crate"

/datum/supply_pack/emergency/atmostank
	name = "Firefighting Watertank"
	cost = 1000
	access = access_atmospherics
	contains = list(/obj/item/weapon/watertank/atmos)
	crate_name = "firefighting watertank crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/radiation
	name = "Radiation Protection Crate"
	cost = 1000
	contains = list(/obj/item/clothing/head/radiation,
					/obj/item/clothing/head/radiation,
					/obj/item/clothing/suit/radiation,
					/obj/item/clothing/suit/radiation)
	crate_name = "radiation protection crate"
	crate_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/weedcontrol
	name = "Weed Control Crate"
	cost = 1500
	access = access_hydroponics
	contains = list(/obj/item/weapon/scythe,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/grenade/chem_grenade/antiweed,
					/obj/item/weapon/grenade/chem_grenade/antiweed)
	crate_name = "weed control crate"
	crate_type = /obj/structure/closet/crate/secure/hydroponics

/datum/supply_pack/emergency/specialops
	name = "Special Ops Supplies"
	hidden = TRUE
	cost = 2000
	contains = list(/obj/item/weapon/storage/box/emps,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/pen/sleepy,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	crate_name = "special ops crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/emergency/syndicate
	name = "NULL_ENTRY"
	hidden = TRUE
	cost = 14000
	contains = list(/obj/item/weapon/storage/box/syndicate)
	crate_name = "crate"
	crate_type = /obj/structure/closet/crate
	dangerous = TRUE

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security
	group = "Security"
	access = access_security
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/supplies
	name = "Security Supplies Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas,
					/obj/item/weapon/storage/box/flashes,
					/obj/item/weapon/storage/box/handcuffs)
	crate_name = "security supply crate"

/datum/supply_pack/security/helmets
	name = "Helmets Crate"
	cost = 1000
	contains = list(/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec)
	crate_name = "helmet crate"

/datum/supply_pack/security/armor
	name = "Armor Crate"
	cost = 1000
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest)
	crate_name = "armor crate"

/datum/supply_pack/security/baton
	name = "Stun Batons Crate"
	cost = 1000
	contains = list(/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/melee/baton/loaded)
	crate_name = "stun baton crate"

/datum/supply_pack/security/wall_flash
	name = "Wall-Mounted Flash Crate"
	cost = 10
	contains = list(/obj/item/weapon/storage/box/wall_flash,
					/obj/item/weapon/storage/box/wall_flash,
					/obj/item/weapon/storage/box/wall_flash,
					/obj/item/weapon/storage/box/wall_flash)
	crate_name = "wall-mounted flash crate"

/datum/supply_pack/security/laser
	name = "Lasers Crate"
	cost = 1500
	contains = list(/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser)
	crate_name = "laser crate"

/datum/supply_pack/security/taser
	name = "Taser Crate"
	cost = 1500
	contains = list(/obj/item/weapon/gun/energy/gun/advtaser,
					/obj/item/weapon/gun/energy/gun/advtaser,
					/obj/item/weapon/gun/energy/gun/advtaser)
	crate_name = "taser crate"

/datum/supply_pack/security/disabler
	name = "Disabler Crate"
	cost = 1000
	contains = list(/obj/item/weapon/gun/energy/disabler,
					/obj/item/weapon/gun/energy/disabler,
					/obj/item/weapon/gun/energy/disabler)
	crate_name = "disabler crate"

/datum/supply_pack/security/forensics
	name = "Forensics Crate"
	cost = 2000
	contains = list(/obj/item/device/detective_scanner,
	                /obj/item/weapon/storage/box/evidence,
	                /obj/item/device/camera,
	                /obj/item/device/taperecorder,
	                /obj/item/toy/crayon/white,
	                /obj/item/clothing/head/det_hat)
	crate_name = "forensics crate"

/datum/supply_pack/security/armory
	access = access_armory
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/riot
	name = "Riot Armor Crate"
	cost = 3000
	contains = list(/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot)
	crate_name = "riot armor crate"

/datum/supply_pack/security/armory/riotshields
	name = "Riot Shields Crate"
	cost = 2000
	contains = list(/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot)
	crate_name = "riot shields crate"

/datum/supply_pack/security/armory/bulletarmor
	name = "Bulletproof Armor Crate"
	cost = 1500
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof)
	crate_name = "bulletproof armor crate"

/datum/supply_pack/security/armory/swat
	name = "SWAT Crate"
	cost = 6000
	contains = list(/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/suit/space/swat,
					/obj/item/clothing/suit/space/swat,
					/obj/item/weapon/kitchen/knife/combat,
					/obj/item/weapon/kitchen/knife/combat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/weapon/storage/belt/military/assault,
					/obj/item/weapon/storage/belt/military/assault)
	crate_name = "swat crate"

/datum/supply_pack/security/armory/laserarmor
	name = "Reflector Vest Crate"
	cost = 2000
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)
	crate_name = "reflector vest crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/knight
	name = "Knight Armor Crate"
	cost = 3500
	contains = list(/obj/item/clothing/suit/armor/riot/knight,
					/obj/item/clothing/suit/armor/riot/knight/red,
					/obj/item/clothing/suit/armor/riot/knight/yellow,
					/obj/item/clothing/suit/armor/riot/knight/blue,
					/obj/item/clothing/head/helmet/knight,
					/obj/item/clothing/head/helmet/knight/red,
					/obj/item/clothing/head/helmet/knight/yellow,
					/obj/item/clothing/head/helmet/knight/blue)
	crate_name = "knight armor crate"

/datum/supply_pack/security/armory/ballistic
	name = "Combat Shotguns Crate"
	cost = 2000
	contains = list(/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
					/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
					/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
					/obj/item/weapon/storage/belt/bandolier,
					/obj/item/weapon/storage/belt/bandolier,
					/obj/item/weapon/storage/belt/bandolier)
	crate_name = "combat shotguns crate"

/datum/supply_pack/security/armory/energy
	name = "Energy Guns Crate"
	cost = 2500
	contains = list(/obj/item/weapon/gun/energy/gun,
					/obj/item/weapon/gun/energy/gun)
	crate_name = "energy gun crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/fire
	name = "Incendiary Weapons Crate"
	cost = 1500
	access = access_heads
	contains = list(/obj/item/weapon/flamethrower/full,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/grenade/chem_grenade/incendiary,
					/obj/item/weapon/grenade/chem_grenade/incendiary,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	crate_name = "incendiary weapons crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/security/armory/loyalty
	name = "Loyalty Implants Crate"
	cost = 4000
	contains = list(/obj/item/weapon/storage/lockbox/loyalty)
	crate_name = "loyalty implant crate"

/datum/supply_pack/security/armory/trackingimp
	name = "Tracking Implants Crate"
	cost = 2000
	contains = list(/obj/item/weapon/storage/box/trackimp)
	crate_name = "tracking implant crate"

/datum/supply_pack/security/armory/chemimp
	name = "Chemical Implants Crate"
	cost = 2000
	contains = list(/obj/item/weapon/storage/box/chemimp)
	crate_name = "chemical implant crate"

/datum/supply_pack/security/armory/exileimp
	name = "Exile Implants Crate"
	cost = 3000
	contains = list(/obj/item/weapon/storage/box/exileimp)
	crate_name = "exile implant crate"

/datum/supply_pack/security/securitybarriers
	name = "Security Barriers Crate"
	contains = list(/obj/item/weapon/grenade/barrier,
					/obj/item/weapon/grenade/barrier,
					/obj/item/weapon/grenade/barrier,
					/obj/item/weapon/grenade/barrier)
	cost = 2000
	crate_name = "security barriers crate"

/datum/supply_pack/security/firingpins
	name = "Standard Firing Pins Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/box/firingpins,
					/obj/item/weapon/storage/box/firingpins)
	crate_name = "firing pins crate"

/datum/supply_pack/security/securityclothes
	name = "Security Clothing Crate"
	cost = 3000
	contains = list(/obj/item/clothing/under/rank/security/navyblue,
					/obj/item/clothing/under/rank/security/navyblue,
					/obj/item/clothing/suit/security/officer,
					/obj/item/clothing/suit/security/officer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/under/rank/warden/navyblue,
					/obj/item/clothing/suit/security/warden,
					/obj/item/clothing/head/beret/sec/navywarden,
					/obj/item/clothing/under/rank/head_of_security/navyblue,
					/obj/item/clothing/suit/security/hos,
					/obj/item/clothing/head/beret/sec/navyhos)
	crate_name = "security clothing crate"

/datum/supply_pack/security/justiceinbound
	name = "Standard Justice Enforcer Crate"
	cost = 6000 //justice comes at a price. An expensive, noisy price.
	contraband = TRUE
	contains = list(/obj/item/clothing/head/helmet/justice,
					/obj/item/clothing/mask/gas/sechailer)
	crate_name = "justice enforcer crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Engineering /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engineering
	group = "Engineering"

/datum/supply_pack/engineering/fueltank
	name = "Fuel Tank Crate"
	cost = 800
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/tools
	name = "Toolbox Crate"
	contains = list(/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/mechanical,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/mechanical,
					/obj/item/weapon/storage/toolbox/mechanical)
	cost = 1000
	crate_name = "toolbox crate"

/datum/supply_pack/engineering/powergamermitts
	name = "Insulated Gloves Crate"
	cost = 2000	//Made of pure-grade bullshittinium
	contains = list(/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow)
	crate_name = "insulated gloves crate"

/datum/supply_pack/engineering/power
	name = "Powercell Crate"
	cost = 1000
	contains = list(/obj/item/weapon/stock_parts/cell/high,
					/obj/item/weapon/stock_parts/cell/high,
					/obj/item/weapon/stock_parts/cell/high)
	crate_name = "electrical maintenance crate"

/datum/supply_pack/engineering/engiequipment
	name = "Engineering Gear Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/belt/utility,
					/obj/item/weapon/storage/belt/utility,
					/obj/item/weapon/storage/belt/utility,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat)
	crate_name = "engineering gear crate"

/datum/supply_pack/engineering/engine/spacesuit
	name = "Space Suit Crate"
	cost = 3000
	access = access_eva
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,)
	crate_name = "space suit crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/engineering/solar
	name = "Solar Panel Crate"
	cost = 2000
	contains  = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/weapon/circuitboard/solar_control,
					/obj/item/weapon/electronics/tracker,
					/obj/item/weapon/paper/solar)
	crate_name = "solar panel crate"

/datum/supply_pack/engineering/engine
	name = "Emitter Crate"
	cost = 1000
	access = access_ce
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	crate_name = "emitter crate"
	crate_type = /obj/structure/closet/crate/secure
	dangerous = TRUE

/datum/supply_pack/engineering/engine/field_gen
	name = "Field Generator Crate"
	cost = 1000
	contains = list(/obj/machinery/field/generator,
					/obj/machinery/field/generator)
	crate_name = "field generator crate"

/datum/supply_pack/engineering/engine/sing_gen
	name = "Singularity Generator Crate"
	cost = 1000
	contains = list(/obj/machinery/the_singularitygen)
	crate_name = "singularity generator crate"

/datum/supply_pack/engineering/engine/collector
	name = "Collector Crate"
	cost = 1000
	contains = list(/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector)
	crate_name = "collector crate"

/datum/supply_pack/engineering/engine/PA
	name = "Particle Accelerator Crate"
	cost = 2500
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	crate_name = "particle accelerator crate"

/datum/supply_pack/engineering/engine/supermatter_shard
	name = "Supermatter Shard Crate"
	cost = 10000
	contains = list(/obj/machinery/power/supermatter_shard)
	crate_name = "supermatter shard crate"
	crate_type = /obj/structure/closet/crate/secure
	dangerous = TRUE

/datum/supply_packs/engineering/engine/tesla_gen
	name = "Tesla Generator Crate"
	cost = 1000
	contains = list(/obj/machinery/the_singularitygen/tesla)
	crate_name = "tesla generator crate"

/datum/supply_packs/engineering/engine/tesla_coil
	name = "Tesla Coil Crate"
	contains = list(/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil)
	cost = 1500
	crate_name = "tesla coil crate"

/datum/supply_packs/engineering/engine/grnd_rod
	name = "Grounding Rod Crate"
	contains = list(/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod)
	cost = 2000
	crate_name = "grounding rod crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical
	group = "Medical"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/supplies
	name = "Medical Supplies Crate"
	cost = 2000
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/charcoal,
					/obj/item/weapon/reagent_containers/glass/bottle/charcoal,
					/obj/item/weapon/reagent_containers/glass/bottle/epinephrine,
					/obj/item/weapon/reagent_containers/glass/bottle/epinephrine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/toxin,
					/obj/item/weapon/reagent_containers/glass/bottle/toxin,
					/obj/item/weapon/reagent_containers/glass/beaker/large,
					/obj/item/weapon/reagent_containers/glass/beaker/large,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/stack/medical/gauze,
					/obj/item/weapon/storage/box/beakers,
					/obj/item/weapon/storage/box/syringes,
				    /obj/item/weapon/storage/box/bodybags)
	crate_name = "medical supplies crate"

/datum/supply_pack/medical/firstaid
	name = "First Aid Kit Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/regular)
	crate_name = "first aid kit crate"

/datum/supply_pack/medical/firstaidbruises
	name = "Bruise Treatment Kit Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/firstaid/brute,
					/obj/item/weapon/storage/firstaid/brute,
					/obj/item/weapon/storage/firstaid/brute)
	crate_name = "brute treatment kit crate"

/datum/supply_pack/medical/firstaidburns
	name = "Burn Treatment Kit Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/fire)
	crate_name = "burn treatment kit crate"

/datum/supply_pack/medical/firstaidtoxins
	name = "Toxin Treatment Kit Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/toxin)
	crate_name = "toxin treatment kit crate"

/datum/supply_pack/medical/firstaidoxygen
	name = "Oxygen Deprivation Kit Crate"
	cost = 1000
	contains = list(/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/o2)
	crate_name = "oxygen deprivation kit crate"

/datum/supply_pack/medical/virus
	name = "Virus Crate"
	cost = 2500
	access = access_cmo
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/flu_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/cold,
					/obj/item/weapon/reagent_containers/glass/bottle/epiglottis_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/liver_enhance_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/weapon/reagent_containers/glass/bottle/magnitis,
					/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/weapon/reagent_containers/glass/bottle/brainrot,
					/obj/item/weapon/reagent_containers/glass/bottle/hullucigen_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/anxiety,
					/obj/item/weapon/reagent_containers/glass/bottle/beesease,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/beakers,
					/obj/item/weapon/reagent_containers/glass/bottle/mutagen)
	crate_name = "virus crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	cost = 3500
	contains = list(/obj/item/weapon/reagent_containers/blood/empty,
					/obj/item/weapon/reagent_containers/blood/empty,
					/obj/item/weapon/reagent_containers/blood/APlus,
					/obj/item/weapon/reagent_containers/blood/AMinus,
					/obj/item/weapon/reagent_containers/blood/BPlus,
					/obj/item/weapon/reagent_containers/blood/BMinus,
					/obj/item/weapon/reagent_containers/blood/OPlus,
					/obj/item/weapon/reagent_containers/blood/OMinus)
	crate_name = "blood pack crate"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/iv_drip
	name = "IV Drip Crate"
	cost = 3000
	access = access_cmo
	contains = list(/obj/machinery/iv_drip)
	crate_name = "iv drip crate"
	crate_type = /obj/structure/closet/crate/secure

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/science
	group = "Science"

/datum/supply_pack/science/robotics
	name = "Robotics Assembly Crate"
	cost = 1000
	access = access_robotics
	contains = list(/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/box/flashes,
					/obj/item/weapon/stock_parts/cell/high,
					/obj/item/weapon/stock_parts/cell/high)
	crate_name = "robotics assembly crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/science/robotics/mecha_ripley
	name = "Circuit Crate (Ripley APLU)"
	cost = 3000
	access = access_robotics
	contains = list(/obj/item/weapon/book/manual/ripley_build_and_repair,
					/obj/item/weapon/circuitboard/mecha/ripley/main,
					/obj/item/weapon/circuitboard/mecha/ripley/peripherals)
	crate_name = "\improper APLU Ripley circuit crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/science/robotics/mecha_odysseus
	name = "Circuit Crate (Odysseus)"
	cost = 2500
	access = access_robotics
	contains = list(/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,
					/obj/item/weapon/circuitboard/mecha/odysseus/main)
	crate_name = "\improper Odysseus circuit crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/science/plasma
	name = "Plasma Assembly Crate"
	cost = 1000
	access = access_tox_storage
	contains = list(/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer)
	crate_name = "plasma assembly crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/science/shieldwalls
	name = "Shield Generators"
	cost = 2000
	access = access_teleporter
	contains = list(/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen)
	crate_name = "shield generators crate"
	crate_type = /obj/structure/closet/crate/secure


/datum/supply_pack/science/transfer_valves
	name = "Tank Transfer Valves Crate"
	cost = 6000
	access = access_rd
	contains = list(/obj/item/device/transfer_valve,
					/obj/item/device/transfer_valve)
	crate_name = "tank transfer valves crate crate"
	crate_type = /obj/structure/closet/crate/secure
	dangerous = TRUE

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic
	group = "Food & Livestock"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/food
	name = "Food Crate"
	cost = 1000
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour,
					/obj/item/weapon/reagent_containers/food/condiment/rice,
					/obj/item/weapon/reagent_containers/food/condiment/milk,
					/obj/item/weapon/reagent_containers/food/condiment/soymilk,
					/obj/item/weapon/reagent_containers/food/condiment/saltshaker,
					/obj/item/weapon/reagent_containers/food/condiment/peppermill,
					/obj/item/weapon/storage/fancy/egg_box,
					/obj/item/weapon/reagent_containers/food/condiment/enzyme,
					/obj/item/weapon/reagent_containers/food/condiment/sugar,
					/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey,
					/obj/item/weapon/reagent_containers/food/snacks/grown/banana,
					/obj/item/weapon/reagent_containers/food/snacks/grown/banana,
					/obj/item/weapon/reagent_containers/food/snacks/grown/banana)
	crate_name = "food crate"

/datum/supply_pack/organic/pizza
	name = "Pizza Crate"
	cost = 6000 // Best prices this side of the galaxy.
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	crate_name = "pizza crate"

/datum/supply_pack/organic/monkey
	name = "Monkey Crate"
	cost = 2000
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	crate_name = "monkey crate"

/datum/supply_pack/organic/party
	name = "Party Equipment"
	cost = 2000
	contains = list(/obj/item/weapon/storage/box/drinkingglasses,
					/obj/item/weapon/reagent_containers/food/drinks/shaker,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
					/obj/item/weapon/reagent_containers/food/drinks/ale,
					/obj/item/weapon/reagent_containers/food/drinks/ale,
					/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/beer)
	crate_name = "party equipment"

/datum/supply_pack/organic/critter
	crate_type = /obj/structure/closet/crate/critter

/datum/supply_pack/organic/critter/cow
	name = "Cow Crate"
	cost = 3000
	contains = list(/mob/living/simple_animal/cow)
	crate_name = "cow crate"

/datum/supply_pack/organic/critter/goat
	name = "Goat Crate"
	cost = 2500
	contains = list(/mob/living/simple_animal/hostile/retaliate/goat)
	crate_name = "goat crate"

/datum/supply_pack/organic/critter/chick
	name = "Chicken Crate"
	cost = 2000
	contains = list( /mob/living/simple_animal/chick)
	crate_name = "chicken crate"

/datum/supply_pack/organic/critter/corgi
	name = "Corgi Crate"
	cost = 5000
	contains = list(/mob/living/simple_animal/pet/dog/corgi,
					/obj/item/clothing/tie/petcollar)
	crate_name = "corgi crate"

/datum/supply_pack/organic/critter/corgi/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/dog/corgi/D = locate() in .
		qdel(D)
		new /mob/living/simple_animal/pet/dog/corgi/Lisa(.)

/datum/supply_packs/organic/memedog
	name = "Strange Dog Crate"
	cost = 2000
	contains = list(/mob/living/simple_animal/pet/dog/corgi/puppy/annoying_dog)
	crate_name = "Strange Dog Crate"

/datum/supply_pack/organic/critter/cat
	name = "Cat Crate"
	cost = 5000 //Cats are worth as much as corgis.
	contains = list(/mob/living/simple_animal/pet/cat,
					/obj/item/clothing/tie/petcollar,
                    /obj/item/toy/cattoy)
	crate_name = "cat crate"

/datum/supply_pack/organic/critter/cat/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/cat/C = locate() in .
		qdel(C)
		new /mob/living/simple_animal/pet/cat/Proc(.)

/datum/supply_pack/organic/critter/pug
	name = "Pug Crate"
	cost = 5000
	contains = list(/mob/living/simple_animal/pet/dog/pug,
					/obj/item/clothing/tie/petcollar)
	crate_name = "pug crate"

/datum/supply_pack/organic/critter/fox
	name = "Fox Crate"
	cost = 5000
	contains = list(/mob/living/simple_animal/pet/fox,
					/obj/item/clothing/tie/petcollar)
	crate_name = "fox crate"

/datum/supply_pack/organic/critter/butterfly
	name = "Butterflies Crate"
	contraband = TRUE
	cost = 5000
	contains = list(/mob/living/simple_animal/butterfly)
	crate_name = "butterflies crate"

/datum/supply_pack/organic/critter/butterfly/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/simple_animal/butterfly(.)

/datum/supply_pack/organic/hydroponics
	name = "Hydroponics Crate"
	cost = 1500
	contains = list(/obj/item/weapon/reagent_containers/spray/plantbgone,
					/obj/item/weapon/reagent_containers/spray/plantbgone,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia,
					/obj/item/weapon/hatchet,
					/obj/item/weapon/cultivator,
					/obj/item/device/analyzer/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron)
	crate_name = "hydroponics crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/misc/hydroponics/hydrotank
	name = "Hydroponics Backpack Crate"
	cost = 1000
	access = access_hydroponics
	contains = list(/obj/item/weapon/watertank)
	crate_name = "hydroponics backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/hydroponics/seeds
	name = "Seeds Crate"
	cost = 1000
	contains = list(/obj/item/seeds/chili,
					/obj/item/seeds/berry,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/tomato,
					/obj/item/seeds/soya,
					/obj/item/seeds/wheat,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/carrot,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/chanter,
					/obj/item/seeds/potato,
					/obj/item/seeds/sugarcane)
	crate_name = "seeds crate"

/datum/supply_pack/organic/hydroponics/exoticseeds
	name = "Exotic Seeds Crate"
	cost = 1500
	contains = list(/obj/item/seeds/nettle,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/plump,
					/obj/item/seeds/liberty,
					/obj/item/seeds/amanita,
					/obj/item/seeds/reishi,
					/obj/item/seeds/banana,
					/obj/item/seeds/eggplant/eggy)
	crate_name = "exotic seeds crate"

/datum/supply_pack/organic/vending
	name = "Bartending Supply Crate"
	cost = 2000
	contains = list(/obj/item/weapon/vending_refill/boozeomat,
					/obj/item/weapon/vending_refill/boozeomat,
					/obj/item/weapon/vending_refill/boozeomat,
					/obj/item/weapon/vending_refill/coffee,
					/obj/item/weapon/vending_refill/coffee,
					/obj/item/weapon/vending_refill/coffee)
	crate_name = "bartending supply crate"

/datum/supply_pack/organic/vending/snack
	name = "Snack Supply Crate"
	cost = 1500
	contains = list(/obj/item/weapon/vending_refill/snack,
					/obj/item/weapon/vending_refill/snack,
					/obj/item/weapon/vending_refill/snack)
	crate_name = "snacks supply crate"

/datum/supply_pack/organic/vending/cola
	name = "Softdrinks Supply Crate"
	cost = 1500
	contains = list(/obj/item/weapon/vending_refill/cola,
					/obj/item/weapon/vending_refill/cola,
					/obj/item/weapon/vending_refill/cola)
	crate_name = "softdrinks supply crate"

/datum/supply_pack/organic/vending/cigarette
	name = "Cigarette Supply Crate"
	cost = 1500
	contains = list(/obj/item/weapon/vending_refill/cigarette,
					/obj/item/weapon/vending_refill/cigarette,
					/obj/item/weapon/vending_refill/cigarette)
	crate_name = "cigarette supply crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Materials ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials
	group = "Raw Materials"

/datum/supply_pack/materials/metal50
	name = "50 Metal Sheets"
	cost = 1000
	contains = list(/obj/item/stack/sheet/metal/fifty)
	crate_name = "metal sheets crate"

/datum/supply_pack/materials/plasteel20
	name = "20 Plasteel Sheets"
	cost = 3000
	contains = list(/obj/item/stack/sheet/plasteel/twenty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/plasteel50
	name = "50 Plasteel Sheets"
	cost = 5000
	contains = list(/obj/item/stack/sheet/plasteel/fifty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/glass50
	name = "50 Glass Sheets"
	cost = 1000
	contains = list(/obj/item/stack/sheet/glass/fifty)
	crate_name = "glass sheets crate"

/datum/supply_pack/materials/wood50
	name = "50 Wood Planks"
	cost = 1000
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "wood planks crate"

/datum/supply_pack/materials/cardboard50
	name = "50 Cardboard Sheets"
	cost = 1000
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "cardboard sheets crate"

/datum/supply_pack/materials/sandstone30
	name = "30 Sandstone Blocks"
	cost = 2000
	contains = list(/obj/item/stack/sheet/mineral/sandstone/thirty)
	crate_name = "sandstone blocks crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/misc
	group = "Miscellaneous Supplies"

/datum/supply_pack/misc/mule
	name = "MULEbot Crate"
	cost = 2000
	contains = list(/mob/living/simple_animal/bot/mulebot)
	crate_name = "\improper MULEbot Crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/misc/conveyor
	name = "Conveyor Assembly Crate"
	cost = 1500
	contains = list(/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_switch_construct,
					/obj/item/weapon/paper/conveyor)
	crate_name = "conveyor assembly crate"

/datum/supply_pack/misc/watertank
	name = "Water Tank Crate"
	cost = 800
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/misc/lasertag
	name = "Laser Tag Crate"
	cost = 1500
	contains = list(/obj/item/weapon/gun/energy/laser/redtag,
					/obj/item/weapon/gun/energy/laser/redtag,
					/obj/item/weapon/gun/energy/laser/redtag,
					/obj/item/weapon/gun/energy/laser/bluetag,
					/obj/item/weapon/gun/energy/laser/bluetag,
					/obj/item/weapon/gun/energy/laser/bluetag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/head/helmet/redtaghelm,
					/obj/item/clothing/head/helmet/bluetaghelm)
	crate_name = "laser tag crate"

/datum/supply_pack/misc/religious_supplies
	name = "Religious Supplies Crate"
	cost = 4000	// it costs so much because the Space Church is ran by Space Jews
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater,
					/obj/item/weapon/storage/book/bible/booze,
					/obj/item/weapon/storage/book/bible/booze,
					/obj/item/clothing/suit/hooded/chaplain_hoodie,
					/obj/item/clothing/suit/hooded/chaplain_hoodie)
	crate_name = "religious supplies crate"

/datum/supply_pack/misc/posters
	name = "Corporate Posters Crate"
	cost = 800
	contains = list(/obj/item/weapon/poster/legit,
					/obj/item/weapon/poster/legit,
					/obj/item/weapon/poster/legit,
					/obj/item/weapon/poster/legit,
					/obj/item/weapon/poster/legit)
	crate_name = "Corporate Posters Crate"

/datum/supply_pack/misc/paper
	name = "Bureaucracy Crate"
	cost = 1500
	contains = list(/obj/structure/filingcabinet/chestdrawer/wheeled,
					/obj/item/device/camera_film,
					/obj/item/weapon/hand_labeler,
					/obj/item/hand_labeler_refill,
					/obj/item/hand_labeler_refill,
					/obj/item/weapon/paper_bin,
					/obj/item/weapon/pen/fourcolor,
					/obj/item/weapon/pen/fourcolor,
					/obj/item/weapon/pen,
					/obj/item/weapon/pen/blue,
					/obj/item/weapon/pen/red,
					/obj/item/weapon/folder/blue,
					/obj/item/weapon/folder/red,
					/obj/item/weapon/folder/yellow,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/clipboard)
	crate_name = "bureaucracy crate"

/datum/supply_pack/misc/toner
	name = "Toner Crate"
	cost = 1000
	contains = list(/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner)
	crate_name = "toner crate"

/datum/supply_pack/misc/janitor
	name = "Janitorial Supplies Crate"
	cost = 1000
	contains = list(/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/item/weapon/grenade/chem_grenade/cleaner)
	crate_name = "janitorial supplies crate"

/datum/supply_pack/misc/janitor/janicart
	name = "Janitorial Cart and Galoshes Crate"
	cost = 2000
	contains = list(/obj/structure/janitorialcart,
					/obj/item/clothing/shoes/galoshes)
	crate_name = "janitorial cart crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/misc/janitor/janitank
	name = "Janitor Backpack Crate"
	cost = 1000
	access = access_janitor
	contains = list(/obj/item/weapon/watertank/janitor)
	crate_name = "janitor backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/misc/janitor/lightbulbs
	name = "Replacement Lights"
	cost = 1000
	contains = list(/obj/item/weapon/storage/box/lights/mixed,
					/obj/item/weapon/storage/box/lights/mixed,
					/obj/item/weapon/storage/box/lights/mixed)
	crate_name = "replacement lights"

/datum/supply_pack/misc/noslipfloor
	name = "High-traction Floor Tiles"
	cost = 2000
	contains = list(/obj/item/stack/tile/noslip/thirty)
	crate_name = "high-traction floor tiles"

/datum/supply_pack/misc/plasmaman
	name = "Plasmaman Supply Kit"
	cost = 2000
	contains = list(/obj/item/clothing/under/plasmaman,
					/obj/item/clothing/under/plasmaman,
					/obj/item/weapon/tank/internals/plasmaman/belt/full,
					/obj/item/weapon/tank/internals/plasmaman/belt/full,
					/obj/item/clothing/head/helmet/space/plasmaman,
					/obj/item/clothing/head/helmet/space/plasmaman)
	crate_name = "plasmaman supply kit"

/datum/supply_pack/misc/costume
	name = "Standard Costume Crate"
	cost = 1000
	access = access_theatre
	contains = list(/obj/item/weapon/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/clown,
					/obj/item/weapon/bikehorn,
					/obj/item/clothing/under/rank/mime,
					/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/suit/suspenders,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,
					/obj/item/weapon/storage/backpack/mime)
	crate_name = "standard costume crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/misc/wizard
	name = "Wizard Costume Crate"
	cost = 2000
	contains = list(/obj/item/weapon/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	crate_name = "wizard costume crate"

/datum/supply_pack/misc/randomised
	name = "Collectable Hats Crate!"
	cost = 20000
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	crate_name = "collectable hats crate"

/datum/supply_pack/misc/randomised/contraband
	name = "Contraband Crate"
	contraband = TRUE
	cost = 3000
	num_contained = 6
	contains = list(/obj/item/weapon/poster/contraband,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori,
					/obj/item/seeds/ambrosia/deus,
					/obj/item/clothing/tie/dope_necklace)
	crate_name = "crate"

/datum/supply_pack/misc/randomised/toys
	name = "Toy Crate"
	cost = 5000 // or play the arcade machines ya lazy bum
	num_contained = 5
	contains = list(/obj/item/toy/spinningtoy,
	                /obj/item/toy/sword,
	                /obj/item/toy/foamblade,
	                /obj/item/toy/AI,
	                /obj/item/toy/owl,
	                /obj/item/toy/griffin,
	                /obj/item/toy/nuke,
	                /obj/item/toy/minimeteor,
	                /obj/item/toy/carpplushie,
	                /obj/item/weapon/coin/antagtoken,
	                /obj/item/stack/tile/fakespace,
	                /obj/item/weapon/gun/projectile/shotgun/toy/crossbow,
	                /obj/item/toy/redbutton)
	crate_name = "toy crate"

/datum/supply_pack/misc/autodrobe
	name = "Autodrobe Supply Crate"
	cost = 1500
	contains = list(/obj/item/weapon/vending_refill/autodrobe,
					/obj/item/weapon/vending_refill/autodrobe)
	crate_name = "autodrobe supply crate"

/datum/supply_pack/misc/formalwear
	name = "Formalwear Crate"
	cost = 3000 //Lots of very expensive items. You gotta pay up to look good!
	contains = list(/obj/item/clothing/under/blacktango,
					/obj/item/clothing/under/assistantformal,
					/obj/item/clothing/under/assistantformal,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/suit/toggle/lawyer,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/suit/toggle/lawyer/purple,
					/obj/item/clothing/under/lawyer/blacksuit,
					/obj/item/clothing/suit/toggle/lawyer/black,
					/obj/item/clothing/tie/waistcoat,
					/obj/item/clothing/tie/blue,
					/obj/item/clothing/tie/red,
					/obj/item/clothing/tie/black,
					/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/head/flatcap,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/that,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/under/suit_jacket/charcoal,
					/obj/item/clothing/under/suit_jacket/navy,
					/obj/item/clothing/under/suit_jacket/burgundy,
					/obj/item/clothing/under/suit_jacket/checkered,
					/obj/item/clothing/under/suit_jacket/tan,
					/obj/item/weapon/lipstick/random)
	crate_name = "formalwear crate"

/datum/supply_pack/misc/foamforce
	name = "Foam Force Crate"
	cost = 1000
	contains = list(/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy)
	crate_name = "foam force crate"

/datum/supply_pack/misc/foamforce/bonus
	name = "Foam Force Pistols Crate"
	contraband = TRUE
	cost = 4000
	contains = list(/obj/item/weapon/gun/projectile/automatic/toy/pistol,
					/obj/item/weapon/gun/projectile/automatic/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol)
	crate_name = "foam force pistols crate"
