/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

/datum/design/pin_testing
	name = "test-range firing pin"
	desc = "This safety firing pin allows firearms to be operated within proximity to a firing range."
	id = "pin_testing"
	req_tech = list("combat" = 1, "materials" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 500, MAT_GLASS = 300)
	build_path = /obj/item/device/firing_pin/test_range
	category = list("Firing Pins")

/datum/design/pin_loyalty
	name = "loyalty firing pin"
	desc = "This is a security firing pin which only authorizes users who are loyalty-implanted."
	id = "pin_loyalty"
	req_tech = list("combat" = 6, "materials" = 6, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_SILVER = 600, MAT_DIAMOND = 600, MAT_URANIUM = 200)
	build_path = /obj/item/device/firing_pin/implant/loyalty
	category = list("Firing Pins")

/datum/design/stunrevolver
	name = "Stun Revolver"
	desc = "A high-tech revolver that fires internal, reusable taser cartridges in a revolving cylinder. The cartridges can be recharged using conventional rechargers."
	id = "stunrevolver"
	req_tech = list("combat" = 3, "materials" = 3, "powerstorage" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_GLASS = 1000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	locked = 1
	category = list("Weapons")

/datum/design/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	id = "nuclear_gun"
	req_tech = list("combat" = 4, "materials" = 5, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 2000)
	reliability = 76
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	locked = 1
	category = list("Weapons")

/datum/design/tele_shield
	name = "Telescopic Riot Shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	id = "tele_shield"
	req_tech = list("combat" = 4, "materials" = 3, "engineering" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_GLASS = 5000, MAT_SILVER = 300)
	build_path = /obj/item/weapon/shield/deployable/tele
	locked = 1
	category = list("Weapons")

/datum/design/lasercannon
	name = "Laser Cannon"
	desc = "A heavy duty laser cannon."
	id = "lasercannon"
	req_tech = list("combat" = 4, "materials" = 3, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	locked = 1
	category = list("Weapons")

/datum/design/laserhypercannon
	name = "Laser Hypercannon"
	desc = "A heavy duty laser cannon that increases in damage the further the target."
	id = "laserhypercannon"
	req_tech = list("combat" = 5, "materials" = 4, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 20000, MAT_GLASS = 2000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000, MAT_PLASMA = 3000, MAT_GOLD = 3000)
	build_path = /obj/item/weapon/gun/energy/laser/hypercannon
	locked = 1
	category = list("Weapons")

/datum/design/gaussrifle
	name = "Gauss Rifle"
	desc = "A seriously powerful rifle with an electromagnetic acceleration core, capable of blowing limbs off."
	id = "gaussrifle"
	req_tech = list("combat" = 6, "materials" = 6, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 20000, MAT_URANIUM = 4000, MAT_DIAMOND = 8000, MAT_PLASMA = 4000, MAT_GOLD = 5000)
	build_path = /obj/item/weapon/gun/energy/gauss
	locked = 1
	category = list("Weapons")

/datum/design/laserpistol
	name = "Laser Pistol"
	desc = "A fairly basic weapon that fires low focus laser beams."
	id = "laserpistol"
	req_tech = list("combat" = 5, "materials" = 3, "powerstorage" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_DIAMOND = 700)
	build_path = /obj/item/weapon/gun/energy/laser/pistol
	locked = 1
	category = list("Weapons")

/datum/design/laserrifle
	name = "Laser Rifle"
	desc = "An advanced laser weapon capable of shooting higly focused beams of light."
	id = "laserrifle"
	req_tech = list("combat" = 6, "materials" = 5, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 5000, MAT_DIAMOND = 2000, MAT_GOLD = 3000, MAT_SILVER = 4000)
	build_path = /obj/item/weapon/gun/energy/laser/rifle
	locked = 1
	category = list("Weapons")

/datum/design/hybridlaser
	name = "Hybrid Laser Gun"
	desc = "An advanced laser weapon capable of shooting low focus and high focus beams. Great for non-lethal combat."
	id = "laserpistol"
	req_tech = list("combat" = 4, "materials" = 4, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 2000, MAT_GOLD = 1000, MAT_SILVER = 1000)
	build_path = /obj/item/weapon/gun/energy/laser/hybrid
	locked = 1
	category = list("Weapons")

/datum/design/hybridpistol
	name = "Hybrid Laser Pistol"
	desc = "A compact laser weapon capable of shooting low focus and high focus beams. Great for non-lethal combat."
	id = "hybridpistol"
	req_tech = list("combat" = 5, "materials" = 4, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 1000, MAT_DIAMOND = 700, MAT_GOLD = 500, MAT_SILVER = 500)
	build_path = /obj/item/weapon/gun/energy/laser/hybrid/pistol
	locked = 1
	category = list("Weapons")

/datum/design/autolaser
	name = "Automatic Laser Carbine"
	desc = "An advanced laser carbine which utilizes magazines and advanced cooling techniques to allow for burst-firing. The magazines use specialized plasma cartridges."
	id = "autolaser"
	req_tech = list("combat" = 6, "materials" = 5, "powerstorage" = 4, "plasmatech" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 2000, MAT_DIAMOND = 2000, MAT_PLASMA = 3000)
	build_path = /obj/item/weapon/gun/projectile/automatic/alc
	locked = 1
	category = list("Weapons")

/datum/design/decloner
	name = "Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	id = "decloner"
	req_tech = list("combat" = 8, "materials" = 7, "biotech" = 5, "powerstorage" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 5000,MAT_URANIUM = 10000)
	reagents = list("mutagen" = 40)
	build_path = /obj/item/weapon/gun/energy/decloner
	locked = 1
	category = list("Weapons")

/datum/design/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	id = "rapidsyringe"
	req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3, "biotech" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/weapon/gun/syringe/rapidsyringe
	category = list("Weapons")

/datum/design/largecrossbow
	name = "Energy Crossbow"
	desc = "A reverse-engineered energy crossbow favored by syndicate infiltration teams and carp hunters."
	id = "largecrossbow"
	req_tech = list("combat" = 5, "materials" = 5, "engineering" = 3, "biotech" = 4, "syndicate" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 1500, MAT_URANIUM = 1500, MAT_SILVER = 1500)
	build_path = /obj/item/weapon/gun/energy/kinetic_accelerator/crossbow/large
	locked = 1
	category = list("Weapons")
	reliability = 76

/datum/design/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	id = "temp_gun"
	req_tech = list("combat" = 3, "materials" = 4, "powerstorage" = 3, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_GLASS = 500, MAT_SILVER = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	locked = 1
	category = list("Weapons")

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	id = "flora_gun"
	req_tech = list("materials" = 2, "biotech" = 3, "powerstorage" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2000, MAT_GLASS = 500)
	reagents = list("radium" = 20)
	build_path = /obj/item/weapon/gun/energy/floragun
	category = list("Weapons")

/datum/design/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and uses larger containers."
	id = "large_Grenade"
	req_tech = list("combat" = 3, "materials" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 3000)
	reliability = 79
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	category = list("Weapons")

/datum/design/smg
	name = "NanoTrasen Saber SMG"
	desc = "A prototype advancment over the WT-550 auto rifle made using lightweight materials on a traditional frame, designed to fire standard 9mm rounds."
	id = "smg"
	req_tech = list("combat" = 4, "materials" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_SILVER = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic/proto
	locked = 1
	category = list("Weapons")

/datum/design/xray
	name = "Xray Laser Gun"
	desc = "Not quite as menacing as it sounds"		//Because laser beams that go through walls aren't menacing at all apparently? What.
	id = "xray"
	req_tech = list("combat" = 6, "materials" = 5, "biotech" = 5, "powerstorage" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 5000,MAT_URANIUM = 10000, MAT_METAL = 4000)
	build_path = /obj/item/weapon/gun/energy/xray
	locked = 1
	category = list("Weapons")

/datum/design/ioncarbine
	name = "Ion Carbine"
	desc = "How to dismantle a cyborg : The gun."
	id = "ioncarbine"
	req_tech = list("combat" = 5, "materials" = 4, "magnets" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_SILVER = 4000, MAT_METAL = 6000, MAT_URANIUM = 1000)
	build_path = /obj/item/weapon/gun/energy/ionrifle/carbine
	locked = 1
	category = list("Weapons")

/datum/design/wormhole_projector
	name = "Bluespace Wormhole Projector"
	desc = "A projector that emits high density quantum-coupled bluespace beams."
	id = "wormholeprojector"
	req_tech = list("combat" = 6, "materials" = 6, "bluespace" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_SILVER = 1000, MAT_METAL = 5000, MAT_DIAMOND = 3000)
	build_path = /obj/item/weapon/gun/energy/wormhole_projector
	locked = 1
	category = list("Weapons")

//SABR Mags

/datum/design/mag_smg
	name = "SABR SMG Magazine (9mm)"
	desc = "A 30-round magazine for the prototype submachine gun."
	id = "mag_smg"
	req_tech = list("combat" = 4, "materials" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2000)
	build_path = /obj/item/ammo_box/magazine/smgm9mm
	category = list("Ammo")

/datum/design/mag_smg/ap_mag
	name = "SABR SMG Armour Piercing Magazine (9mmAP)"
	desc = "A 30-round armour piercing magazine for the prototype submachine gun. The bullet itself utilizes stronger materials allowing it to punch through armor more easily, at the cost of less or no fragmentation of the bullet, resulting in less trauma."
	id = "mag_smg_ap"
	materials = list(MAT_METAL = 3000, MAT_SILVER = 100)
	build_path = /obj/item/ammo_box/magazine/smgm9mm/ap
	locked = 1

/datum/design/mag_smg/incin_mag
	name = "SABR SMG Incendiary Magazine (9mmIC)"
	desc = "A 30-round incendiary round magazine for the prototype submachine gun. Deals significantly less damage but sets the target on fire."
	id = "mag_smg_ic"
	materials = list(MAT_METAL = 3000, MAT_SILVER = 100)
	build_path = /obj/item/ammo_box/magazine/smgm9mm/fire
	locked = 1

/datum/design/mag_smg/incin_tox
	name = "SABR SMG Uranium Magazine (9mmTX)"
	desc = "A 30-round uranium tipped round magazine for the prototype submachine gun. The bullet injects toxin into the victim, but with less overall physical damage."
	id = "mag_smg_tx"
	materials = list(MAT_METAL = 3000, MAT_URANIUM = 1000)
	build_path = /obj/item/ammo_box/magazine/smgm9mm/toxin
	locked = 1

/datum/design/magazine_autolaser
	name = "Automatic Laser Carbine magazine (plasma)"
	desc = "A 24-round magazine which utilizes unique, specialized caseless plasma ammunition. For use with the Automatic Laser Carbine."
	id = "magazineautolaser"
	req_tech = list("combat" = 4, "materials" = 3, "plasmatech" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2500, MAT_PLASMA = 400)
	build_path = /obj/item/ammo_box/magazine/alc
	category = list("Ammo")

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list("combat" = 3, "materials" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 200)
	build_path = /obj/item/ammo_casing/shotgun/stunslug
	category = list("Ammo")

/datum/design/techshell
	name = "Unloaded Technological Shotshell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	id = "techshotshell"
	req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 200)
	build_path = /obj/item/ammo_casing/shotgun/techshell
	category = list("Ammo")

/datum/design/suppressor
	name = "Universal Suppressor"
	desc = "A reverse-engineered universal suppressor that fits on most small arms with threaded barrels."
	id = "suppressor"
	req_tech = list("combat" = 6, "engineering" = 5, "syndicate" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2000, MAT_SILVER = 500)
	build_path = /obj/item/weapon/suppressor
	category = list("Weapons")

/datum/design/armor/reactive
	name = "Reactive Teleport Armor"
	desc= "Someone seperated our Research Director from his own head!"
	id = "reactive"
	req_tech = list("materials" = 7, "combat" = 6, "powerstorage" = 6, "magnets" = 6, "programming" = 6, "bluespace" = 7)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 25000, MAT_GLASS = 10000, MAT_SILVER = 20000, MAT_GOLD = 20000, MAT_PLASMA = 6000, MAT_DIAMOND = 2000)
	build_path = /obj/item/clothing/suit/armor/reactive
	category = list("Weapons")
