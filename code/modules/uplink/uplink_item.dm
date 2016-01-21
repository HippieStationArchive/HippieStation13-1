var/list/uplink_items = list() // Global list so we only initialize this once.

/proc/get_uplink_items(var/datum/game_mode/gamemode = null)
	if(!uplink_items.len)
		for(var/item in subtypesof(/datum/uplink_item))
			var/datum/uplink_item/I = new item()
			if(!I.item)
				continue
			if(!uplink_items[I.category])
				uplink_items[I.category] = list()
			uplink_items[I.category][I.name] = I

	var/list/filtered_uplink_items = list()
	for(var/category in uplink_items)
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(I.include_modes.len)
				if(!gamemode && ticker && !(ticker.mode.type in I.include_modes))
					continue
				if(gamemode && !(gamemode in I.include_modes))
					continue
			if(I.exclude_modes.len)
				if(!gamemode && ticker && (ticker.mode.type in I.exclude_modes))
					continue
				if(gamemode && (gamemode in I.exclude_modes))
					continue
			if(!filtered_uplink_items[category])
				filtered_uplink_items[category] = list()
			filtered_uplink_items[category][item] = I

	return filtered_uplink_items


/**
 * Uplink Items
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/
/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null // Path to the item to spawn.
	var/cost = 0
	var/refundable = FALSE
	var/surplus = 100 // Chance of being included in the surplus crate.
	var/list/include_jobs = list()
	var/list/include_modes = list() // Game modes to allow this item in.
	var/list/exclude_modes = list() // Game modes to disallow this item from.

/datum/uplink_item/proc/spawn_item(turf/loc, obj/item/device/uplink/U)
	if(item)
		feedback_add_details("traitor_uplink_items_bought", "[item]")
		return new item(loc)

/datum/uplink_item/proc/buy(mob/user, obj/item/device/uplink/U)
	if(!istype(U))
		return
	if (!user || user.incapacitated())
		return

	if(U.telecrystals < cost)
		return
	else
		U.telecrystals -= cost
		U.spent_telecrystals += cost

	var/atom/A = spawn_item(get_turf(user), U)
	var/obj/item/weapon/storage/box/B = A
	if(istype(B) && B.contents.len > 0)
		for(var/obj/item/I in B)
			U.purchase_log += "<big>\icon[I]</big>"
	else
		U.purchase_log += "<big>\icon[A]</big>"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.put_in_any_hand_if_possible(A)

	return 1

// Nuclear Operative (Special Offers)
/datum/uplink_item/nukeoffer
	category = "Special Offers"
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/nukeoffer/c20r
	name = "C-20r bundle"
	desc = "Old faithful: The classic C-20r, bundled with two magazines, and a (surplus) suppressor at discount price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/c20rbundle
	cost = 14 // normally 16

/datum/uplink_item/nukeoffer/c90gl
	name = "C-90gl bundle"
	desc = "A premium offer: Pick up the C-90gl, along with a magazine, some grenades, and a pack of cigarettes \
			for a 'killer' price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/c90glbundle
	cost = 15 // normally 18

/datum/uplink_item/nukeoffer/bulldog
	name = "Bulldog bundle"
	desc = "Lean and mean: Optimised for people that want to get up close and personal. Contains the popular \
			Bulldog shotgun, two 12g drums, and an elite hardsuit."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/bulldogbundle
	cost = 16 // normally 20

/datum/uplink_item/nukeoffer/medical
	name = "Medical bundle"
	desc = "The support specialist: Aid your fellow operatives with this medical bundle. Contains a Donksoft machine gun, \
			a box of ammo, and a pair of magboots to rescue your friends in no-gravity environments."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/med/medicalbundle
	cost = 15 // normally 20

/datum/uplink_item/nukeoffer/sniper
	name = "Sniper bundle"
	desc = "Elegant and refined: Contains a collapsed sniper rifle in an expensive carrying case, a hollowpoint \
			haemorrhage magazine, a soporific knockout magazine, a free surplus supressor, and a worn out suit and tie."
	item = /obj/item/weapon/storage/briefcase/sniperbundle
	cost = 20 // normally 26

/datum/uplink_item/nukeoffer/chemical
	name = "Bioterror bundle"
	desc = "For the madman: Contains Bioterror spray, Bioterror grenade, chemicals, syringe gun, box of syringes,\
			Donksoft assault rifle, and some darts. Remember: Seal suit and equip internals before use."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/med/bioterrorbundle
	cost = 30 // normally 42

/datum/uplink_item/nukeoffer/ammo
	name = "Fireteam bundle"
	desc = "For the team player: A duffelbag filled with enough ammo to kit out a fireteam; four .45 magazines, \
			three 5.56 magazines, a box of 40mm grenades, and a magazine of sniper ammunition; all at a discounted price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/fireteam
	cost = 24 // normally ??

// JOB-SPECIFIC ITEMS

/datum/uplink_item/job_specific //No job-specific support for surplus yet.
	category = "Job-specific Contraband"
	surplus = 0

//ENGINEER DIVISION

/datum/uplink_item/job_specific/rodgun
	name = "Rod Gun"
	desc = "Based on the staple gun design, this baby can be loaded with 3 rods that you can shoot for them to embed \
			into people."
	item = /obj/item/weapon/gun/rodgun
	cost = 10 //Costly, but for a good reason
	include_jobs = list("Station Engineer", "Chief Engineer", "Atmospheric Technician")

//SCIENCE + MEDICAL
/datum/uplink_item/job_specific/labcoat
	name = "Armored Labcoat"
	desc = "An armored labcoat with the ability to change how it looks into any standard Nanotrasen issue labcoat."
	item = /obj/item/clothing/suit/labcoat/chameleon
	cost = 4
	include_jobs = list("Chemist", "Medical Doctor", "Chief Medical Officer", "Geneticist", "Virologist", "Research Director", "Scientist", "Roboticist") //all the labcoat jobs

//SERVICE DIVISION

/datum/uplink_item/job_specific/chainsaw
	name = "Chainsaw"
	desc = "An extremely loud, dirty, noisy, bulky, powerful as hell chainsaw that will absolutely destroy anyone it \
			comes in contact with. Obviously won't fit in your backpack."
	item = /obj/item/weapon/twohanded/chainsaw
	cost = 14
	include_jobs = list("Botanist", "Bartender", "Chef")

//LIBRARIAN
/datum/uplink_item/job_specific/soulstone
	name = "Soulstone"
	desc = "This stone will be able to capture your victim's soul and bind them to your will."
	item = /obj/item/device/soulstone/anybody
	cost = 5 //nerfed the cost on Chronitonity's request
	include_jobs = list("Librarian")

//CHAPLAIN
/datum/uplink_item/job_specific/skelestone
	name = "Skelestone"
	desc = "Make a skeleton minion! Has one use."
	item = /obj/item/device/necromantic_stone/oneuse
	cost = 7
	include_jobs = list("Chaplain")

/datum/uplink_item/job_specific/holyarmor
	name = "Holy Armor"
	desc = "A set of blessed Holy Armor that shoots out lightning whenever you're attacked."
	item = /obj/item/clothing/suit/armor/riot/knight/templar/holy
	cost = 15
	include_jobs = list("Chaplain")

//BARTENDER
/datum/uplink_item/job_specific/buckshot
	name = "12g Buckshot Shell"
	desc = "Buckshot shells fire 5 pellets that will spread in the direction you are shooting. They can be loaded \
			into your double-barreled shotgun. Absolutely devastating point-blank."
	item = /obj/item/ammo_casing/shotgun/buckshot
	cost = 5
	include_jobs = list("Bartender")

//CLOWN + MIME
/datum/uplink_item/job_specific/caneshotgun
	name = "Cane Shotgun + Assassination Darts"
	desc = "A specialized, one shell shotgun with a built-in cloaking device to mimic a cane. The shotgun is capable \
			of hiding it's contents and the pin alongside being supressed. Comes with 6 special darts and a preloaded shrapnel round."
	item = /obj/item/weapon/storage/box/syndie_kit/caneshotgun
	cost = 15
	include_jobs = list("Clown","Mime")

// Dangerous Items
/datum/uplink_item/dangerous
	category = "Conspicuous and Dangerous Weapons"

/datum/uplink_item/dangerous/pistol
	name = "Stechkin Pistol"
	desc = "A small, easily concealable handgun that uses 10mm auto rounds in 8-round magazines and is compatible \
			with suppressors."
	item = /obj/item/weapon/gun/projectile/automatic/pistol
	cost = 9

/datum/uplink_item/dangerous/g17
	name = "Glock 17 Handgun"
	desc = "A simple yet popular handgun chambered in 9mm. Made out of strong but lightweight polymer. The standard \
			magazine can hold up to 14 9mm cartridges. Compatible with a universal suppressor."
	item = /obj/item/weapon/gun/projectile/automatic/pistol/g17
	cost = 10
	surplus = 15

/datum/uplink_item/dangerous/revolver
	name = "Syndicate Revolver"
	desc = "A brutally simple syndicate revolver that fires .357 Magnum rounds and has 7 chambers."
	item = /obj/item/weapon/gun/projectile/revolver
	cost = 13
	surplus = 50

/datum/uplink_item/dangerous/shotgun
	name = "Bulldog Shotgun"
	desc = "A fully-loaded semi-automatic drum-fed shotgun. Compatiable with all 12g rounds. Designed for close \
			quarter anti-personel engagements."
	item = /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
	cost = 8
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/machineshotgun
	name = "Abzats Shotgun Machinegun"
	desc = "A fully-loaded Aussec Armoury belt-fed machine gun. This deadly weapon has a massive 40-round box magazine of \
			12 gauge buckshot cartridges."
	item = /obj/item/weapon/gun/projectile/automatic/shotgun/abzats
	cost = 30
	include_modes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/smg
	name = "C-20r Submachine Gun"
	desc = "A fully-loaded Scarborough Arms bullpup submachine gun. The C-20r fires .45 rounds with a \
			20-round magazine and is compatible with suppressors."
	item = /obj/item/weapon/gun/projectile/automatic/c20r
	cost = 10
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/smg/unrestricted
	item = /obj/item/weapon/gun/projectile/automatic/c20r/unrestricted
	include_modes = list(/datum/game_mode/gang)

/datum/uplink_item/dangerous/ak922gold
	name = "Gold-Plated AK-922 Assault Rifle"
	desc = "An AK-922 with gold-plating. Now you can kill innocent workers of a hated company with efficiency AND style!"
	item = /obj/item/weapon/gun/projectile/automatic/ak922/gold
	cost = 13
	surplus = 50
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/carbine
	name = "C-90gl Carbine"
	desc = "A fully-loaded, specialized three-round burst carbine that fires 30-round 5.56mm magazines with a togglable \
			underslung 40mm grenade launcher."
	item = /obj/item/weapon/gun/projectile/automatic/c90
	cost = 12
	surplus = 50
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/carbine/unrestricted
	item = /obj/item/weapon/gun/projectile/automatic/c90/unrestricted
	include_modes = list(/datum/game_mode/gang)

/datum/uplink_item/dangerous/machinegun
	name = "L6 Squad Automatic Weapon"
	desc = "A fully-loaded Aussec Armoury belt-fed machine gun. \
			This deadly weapon has a massive 50-round magazine of devastating 7.62x51mm ammunition."
	item = /obj/item/weapon/gun/projectile/automatic/l6_saw
	cost = 23
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/sniper
	name = "Sniper Rifle"
	desc = "Ranged fury, Syndicate style. guaranteed to cause shock and awe or your TC back!"
	item = /obj/item/weapon/gun/projectile/sniper_rifle
	cost = 16
	surplus = 25
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/crossbow
	name = "Miniature Energy Crossbow"
	desc = "A short bow mounted across a tiller in miniature. Small enough to fit into a pocket or slip into a bag \
			unnoticed. It will synthesize and fire bolts tipped with a paralyzing toxin that will \
			briefly stun targets and cause them to slur as if inebriated. It can produce an infinite amount \
			of bolts, but must be manually recharged with each shot."
	item = /obj/item/weapon/gun/energy/kinetic_accelerator/crossbow
	cost = 12
	surplus = 50
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/dangerous/flamethrower
	name = "Flamethrower"
	desc = "A flamethrower, fueled by a portion of highly flammable biotoxins stolen previously from Nanotrasen \
			stations. Make a statement by roasting the filth in their own greed. Use with caution."
	item = /obj/item/weapon/flamethrower/full/tank
	cost = 4
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/dangerous/sword
	name = "Energy Sword"
	desc = "The energy sword is an edged weapon with a blade of pure energy. The sword is small enough to be \
			pocketed when inactive. Activating it produces a loud, distinctive noise. One can combine two \
			energy swords to create a double energy sword, which must be wielded in two hands but is more robust \
			and deflects all energy projectiles."
	item = /obj/item/weapon/melee/energy/sword/saber
	cost = 8

/datum/uplink_item/dangerous/powerfist
	name = "Power Fist"
	desc = "A large mechanically powered fist made out of plasteel which can deliver a massive blow to any target \
	 		with the ability to throw them across a room. The power fist needs approximately a second in between each \
	  		punch before it is powered again."
	item = /obj/item/weapon/melee/powerfist
	cost = 10

/datum/uplink_item/dangerous/cqc_gloves
	name = "Tactical Gloves"
	desc = "Comfortable grey gloves with the CQC martial art inside."
	item = /obj/item/clothing/gloves/cqc
	cost = 12

/datum/uplink_item/dangerous/emp
	name = "EMP Kit"
	desc = "A box that contains two EMP grenades, an EMP implant and a short ranged recharging device disguised \
			as a flashlight. Useful to disrupt communication and silicon lifeforms."
	item = /obj/item/weapon/storage/box/syndie_kit/emp
	cost = 5

/datum/uplink_item/dangerous/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "The minibomb is a grenade with a five-second fuse. Upon detonation, it will create a small hull breach \
			in addition to dealing high amounts of damage to nearby personnel."
	item = /obj/item/weapon/grenade/syndieminibomb
	cost = 6

/datum/uplink_item/dangerous/cat_grenade
	name = "Feral Cat Delivery Grenade"
	desc = "The feral cat delivery grenade contains 8 dehydrated feral cats in a similar manner to dehydrated monkeys, which, upon detonation, will be rehydrated by a small reservoir of water contained within the grenade. These cats will then attack anything in sight."
	item = /obj/item/weapon/grenade/spawnergrenade/feral_cats
	cost = 5

/datum/uplink_item/dangerous/foamsmg
	name = "Toy Submachine Gun"
	desc = "A fully-loaded Donksoft bullpup submachine gun that fires riot grade rounds with a 20-round magazine."
	item = /obj/item/weapon/gun/projectile/automatic/c20r/toy
	cost = 5
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/foammachinegun
	name = "Toy Machine Gun"
	desc = "A fully-loaded Donksoft belt-fed machine gun. This weapon has a massive 50-round magazine of devastating \
			riot grade darts, that can briefly incapacitate someone in just one volley."
	item = /obj/item/weapon/gun/projectile/automatic/l6_saw/toy
	cost = 10
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/viscerators
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerators upon activation, which will chase down and shred \
			any non-operatives in the area."
	item = /obj/item/weapon/grenade/spawnergrenade/manhacks
	cost = 5
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/bioterrorfoam
	name = "Chemical Foam Grenade"
	desc = "A powerful chemical foam grenade which creates a deadly torrent of foam that will mute, blind, confuse, \
			mutate, and irritate carbon lifeforms. Specially brewed by Tiger Cooperative chemical weapons specialists \
			using additional spore toxin. Ensure suit is sealed before use."
	item = /obj/item/weapon/grenade/chem_grenade/bioterrorfoam
	cost = 5
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/bioterror
	name = "Biohazardous Chemical Sprayer"
	desc = "A chemical sprayer that allows a wide dispersal of selected chemicals. Especially tailored by the Tiger \
			Cooperative, the deadly blend it comes stocked with will disorient, damage, and disable your foes... \
			Use with extreme caution, to prevent exposure to yourself and your fellow operatives."
	item = /obj/item/weapon/reagent_containers/spray/chemsprayer/bioterror
	cost = 20
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/dangerous/gygax
	name = "Gygax Exosuit"
	desc = "A lightweight exosuit, painted in a dark scheme. Its speed and equipment selection make it excellent \
			for hit-and-run style attacks. This model lacks a method of space propulsion, and therefore it is \
			advised to utilize the drop pod if you wish to make use of it."
	item = /obj/mecha/combat/gygax/dark/loaded
	cost = 80
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/mauler
	name = "Mauler Exosuit"
	desc = "A massive and incredibly deadly military-grade exosuit. Features long-range targetting, thrust vectoring, \
			and deployable smoke."
	item = /obj/mecha/combat/marauder/mauler/loaded
	cost = 140
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/reinforcement/syndieborg
	name = "Syndicate Cyborg"
	desc = "A cyborg designed and programmed for systematic extermination of non-Syndicate personnel."
	item = /obj/item/weapon/antag_spawner/nuke_ops/borg_tele
	cost = 80
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/reinforcement
	name = "Reinforcements"
	desc = "Call in an additional team member. They won't come with any gear, so you'll have to save some telecrystals \
			to arm them as well."
	item = /obj/item/weapon/antag_spawner/nuke_ops
	cost = 25
	refundable = TRUE
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an \
			organic host as a home base and source of fuel."
	item = /obj/item/weapon/storage/box/syndie_kit/guardian
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

// Ammunition
/datum/uplink_item/ammo
	category = "Ammunition"
	surplus = 40

/datum/uplink_item/ammo/pistol
	name = "10mm Handgun Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. These subsonic rounds \
			are dirt cheap but are half as effective as .357 rounds."
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 1

/datum/uplink_item/ammo/g17
	name = "Handgun Magazine - 9mm"
	desc = "A spare fully-loaded magazine for use in the Glock 17 handgun. Holds up to 14 9mm cartridges."
	item = /obj/item/ammo_box/magazine/g17
	cost = 1

/datum/uplink_item/ammo/revolver
	name = ".357 Speed Loader"
	desc = "A speed loader that contains seven additional .357 Magnum rounds; usable with the Syndicate revolver. \
			For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	cost = 4

/datum/uplink_item/ammo/shotgun
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/shotgun/buck
	name = "12g Buckshot Drum"
	desc = "An additional 8-round buckshot magazine for use with the Bulldog shotgun. Front towards enemy."
	item = /obj/item/ammo_box/magazine/m12g/buckshot

/datum/uplink_item/ammo/shotgun/slug
	name = "12g Slug Drum"
	desc = "An additional 8-round slug magazine for use with the Bulldog shotgun. \
			Now 8 times less likely to shoot your pals."
	item = /obj/item/ammo_box/magazine/m12g

/datum/uplink_item/ammo/shotgun/slug
	name = "12 Stun Slug Drum"
	desc = "An alternative 8-round stun slug magazine for use with the Bulldog shotgun. \
			Saying that they're completely non-lethal would be lying."
	item = /obj/item/ammo_box/magazine/m12g/stun
	cost = 3
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/shotgun/dragon
	name = "12g Dragon's Breath Drum"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. \
			'I'm a fire starter, twisted fire starter!'"
	item = /obj/item/ammo_box/magazine/m12g/dragon
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/shotgun/bag
	name = "12g Ammo Duffelbag"
	desc = "A duffelbag filled with enough 12g ammo to supply an entire team, at a discounted price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/shotgun
	cost = 12

/datum/uplink_item/ammo/box12gbuckshot
	name = "40rnd ammo box - 12g Buckshot"
	desc = "A box of 40 rounds of buckshot ammo, intended for reloading of the Abzats' box magazine."
	item = /obj/item/ammo_box/box12gbuckshot
	cost = 8
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/box12gbuckshot
	name = "Abzats Spare Ammo Box - Buckshot"
	desc = "An ammo box designed for use with the Abzats machine shotgun. Holds up to forty 12 gauge shotgun shells."
	item = /obj/item/ammo_box/magazine/mbox12g
	cost = 10
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/box12gdragon
	name = "40rnd ammo box - 12g Dragon's breath"
	desc = "A box of 40 rounds of dragon's breath ammo, intended for reloading of the Abzats' box magazine."
	item = /obj/item/ammo_box/box12gdragon
	cost = 12
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/smg
	name = ".45 SMG Magazine"
	desc = "An additional 20-round .45 magazine sutable for use with the C-20r submachine gun. \
			These bullets pack a lot of punch that can knock most targets down, but do limited overall damage."
	item = /obj/item/ammo_box/magazine/smgm45
	cost = 3
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/ammo/smg/bag
	name = ".45 Ammo Duffelbag"
	desc = "A duffelbag filled with enough .45 ammo to supply an entire team, at a discounted price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/smg
	cost = 20
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/carbine
	name = "5.56 Toploader Magazine"
	desc = "An additional 30-round 5.56 magazine; sutable for use with the M-90gl carbine. \
			These bullets don't have the punch to knock most targets down, but dish out higher overall damage."
	item = /obj/item/ammo_box/magazine/m556
	cost = 4
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/ammo/ak922
	name = "Box Magazine - 7.62x39mm"
	desc = "An additional 30-round 7.62x39mm magazine for the AK-922 battle rifle. While they don't hit as hard as other projectiles, they have higher velocity and penetrating power."
	item = /obj/item/ammo_box/magazine/ak922
	cost = 3
	include_modes = list(/datum/game_mode/nuclear,/datum/game_mode/gang)

/datum/uplink_item/ammo/a40mm
	name = "40mm Grenade Box"
	desc = "A box of 4 additional 40mm HE grenades for use with the M-90gl's underbarrel grenade launcher. \
			Your teammates will ask you to not shoot these down small hallways."
	item = /obj/item/ammo_box/a40mm
	cost = 5
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun/basic
	name = "7.62x51mm Box Magazine"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use with the L6 SAW. \
			By the time you need to use this, you'll already be on a pile of corpses."
	item = /obj/item/ammo_box/magazine/m762
	cost = 6
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun/bleeding
	name = "7.62x51mm (Bleeding) Box Magazine"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use in the L6 SAW; equipped with special properties \
			to induce internal bleeding on targets."
	item = /obj/item/ammo_box/magazine/m762/bleeding
	cost = 10
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun/hollow
	name = "7.62x51mm (Hollow-Point) Box Magazine"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use in the L6 SAW; equipped with hollow-point tips to help \
			with the unarmored masses of crew."
	item = /obj/item/ammo_box/magazine/m762/hollow
	cost = 10
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun/ap
	name = "7.62x51mm (Armor Penetrating) Box Magazine"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use in the L6 SAW; equipped with special properties \
			to puncture even the most durable armor."
	item = /obj/item/ammo_box/magazine/m762/ap
	cost = 10
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun/incen
	name = "7.62x51mm (Incendiary) Box Magazine"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use in the L6 SAW; tipped with a special flammable \
			mixture that'll ignite anyone struck by the bullet. Some men just want to watch the world burn."
	item = /obj/item/ammo_box/magazine/m762/incen
	cost = 8
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper
	name = ".50 Magazine"
	desc = "An additional standard 6-round magazine for use with .50 sniper rifles."
	item = /obj/item/ammo_box/magazine/sniper_rounds
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper/soporific
	name = ".50 Soporific Magazine"
	desc = "A 3-round magazine of soporific ammo designed for use with .50 sniper rifles. Put your enemies to sleep today!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/soporific
	cost = 6
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper/haemorrhage
	name = ".50 Haemorrhage Magazine"
	desc = "A 5-round magazine of haemorrhage ammo designed for use with .50 sniper rifles; causes heavy bleeding \
			in the target."
	item = /obj/item/ammo_box/magazine/sniper_rounds/haemorrhage
	cost = 6
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper/penetrator
	name = ".50 Penetrator Magazine"
	desc = "A 5-round magazine of penetrator ammo designed for use with .50 sniper rifles. \
			Can pierce walls and multiple enemies."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator
	cost = 5
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/toydarts
	name = "Box of Riot Darts"
	desc = "A box of 40 Donksoft foam riot darts, for reloading any compatible foam dart gun. Don't forget to share!"
	item = /obj/item/ammo_box/foambox/riot
	cost = 2
	surplus = 0

/datum/uplink_item/ammo/bioterror
	name = "Box of Bioterror Syringes"
	desc = "A box full of preloaded syringes, containing various chemicals that seize up the victim's motor \
			and broca systems, making it impossible for them to move or speak for some time."
	item = /obj/item/weapon/storage/box/syndie_kit/bioterror
	cost = 6
	include_modes = list(/datum/game_mode/nuclear)

// Stealthy Weapons
/datum/uplink_item/stealthy_weapons
	category = "Stealthy and Inconspicuous Weapons"

/datum/uplink_item/stealthy_weapons/throwingstars
	name = "Box of Throwing Stars"
	desc = "A box of shurikens from ancient Earth martial arts. They are highly effective throwing weapons, \
			and will embed into limbs when possible."
	item = /obj/item/weapon/storage/box/throwing_stars
	cost = 6

/datum/uplink_item/stealthy_weapons/edagger
	name = "Energy Dagger"
	desc = "A dagger made of energy that looks and functions as a pen when off."
	item = /obj/item/weapon/pen/edagger
	cost = 2

/datum/uplink_item/dangerous/knife
	name = "Combat Knife"
	desc = "A military knife that has decent force and huge embedding chance when thrown. Can be considered stealthy."
	item = /obj/item/weapon/melee/combatknife
	cost = 3
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/stealthy_weapons/foampistol
	name = "Toy Gun with Riot Darts"
	desc = "An innocent-looking toy pistol designed to fire foam darts. Comes loaded with riot-grade \
			darts effective at incapacitating a target."
	item = /obj/item/weapon/gun/projectile/automatic/toy/pistol/riot
	cost = 3
	surplus = 10
	exclude_modes = list(/datum/game_mode/gang)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen, filled with a potent mix of drugs, including a \
			strong anesthetic and a chemical that prevents the target from speaking. \
			The pen holds one dose of the mixture, and cannot be refilled. Note that before the target \
			falls asleep, they will be able to move and act."
	item = /obj/item/weapon/pen/sleepy
	cost = 4
	exclude_modes = list(/datum/game_mode/nuclear,/datum/game_mode/gang)

/datum/uplink_item/stealthy_weapons/soap
	name = "Syndicate Soap"
	desc = "A sinister-looking surfactant used to clean blood stains to hide murders and prevent DNA analysis. \
			You can also drop it underfoot to slip people."
	item = /obj/item/weapon/soap/syndie
	cost = 1
	surplus = 50

/datum/uplink_item/stealthy_weapons/traitor_chem_bottle
	name = "Poison Kit"
	desc = "An assortment of deadly chemicals packed into a compact box. Comes with a syringe for more precise application."
	item = /obj/item/weapon/storage/box/syndie_kit/chemical
	cost = 6
	surplus = 50

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Dart Pistol"
	desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any \
			space a small item can."
	item = /obj/item/weapon/gun/syringe/syndicate
	cost = 4
	surplus = 50

/datum/uplink_item/stealthy_weapons/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you four opportunities to \
			detonate PDAs of crewmembers who have their message feature enabled. \
			The concussive effect from the explosion will knock the recipient out for a short period, and deafen \
			them for longer. Beware, it has a chance to detonate your PDA."
	item = /obj/item/weapon/cartridge/syndicate
	cost = 6

/datum/uplink_item/stealthy_weapons/suppressor
	name = "Universal Suppressor"
	desc = "Fitted for use on any small caliber weapon with a threaded barrel, this suppressor will silence the \
			shots of the weapon for increased stealth and superior ambushing capability."
	item = /obj/item/weapon/suppressor
	cost = 3
	surplus = 10

/datum/uplink_item/stealthy_weapons/pizza_bomb
	name = "Pizza Bomb"
	desc = "A pizza box with a bomb taped inside it. The timer needs to be set by opening the box; afterwards, \
			opening the box again will trigger the detonation."
	item = /obj/item/device/pizza_bomb
	cost = 6
	surplus = 8

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "Dehydrated Space Carp"
	desc = "Looks like a plush toy carp, but just add water and it becomes a real-life space carp! Activate in \
			your hand before use so it knows not to kill you."
	item = /obj/item/toy/carpplushie/dehy_carp
	cost = 1

/datum/uplink_item/stealthy_weapons/door_charge
	name = "Explosive Airlock Charge"
	desc = "A small, easily concealable device. It can be applied to an open airlock panel, booby-trapping it. \
			The next person to use that airlock will trigger an explosion, knocking them down and destroying \
			the airlock maintenance panel."
	item = /obj/item/device/doorCharge
	cost = 2
	surplus = 10
	exclude_modes = list(/datum/game_mode/nuclear)

// Stealth Items
/datum/uplink_item/stealthy_tools
	category = "Stealth and Camouflage Items"

/datum/uplink_item/stealthy_tools/chameleon_jumpsuit
	name = "Chameleon Jumpsuit"
	desc = "A jumpsuit used to imitate the uniforms of Nanotrasen crewmembers. It can change form at any time \
			to resemble another jumpsuit. May react unpredictably to electromagnetic disruptions."
	item = /obj/item/clothing/under/chameleon
	cost = 2

/datum/uplink_item/stealthy_tools/chameleon_stamp
	name = "Chameleon Stamp"
	desc = "A stamp that can be activated to imitate an official Nanotrasen Stamp. The disguised stamp will \
			work exactly like the real stamp and will allow you to forge false documents to gain access or equipment; \
			it can also be used in a washing machine to forge clothing."
	item = /obj/item/weapon/stamp/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Brown Shoes"
	desc = "These shoes will allow the wearer to run on wet floors and slippery objects without falling down. \
			They do not work on heavily lubricated surfaces."
	item = /obj/item/clothing/shoes/sneakers/syndigaloshes
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/stealthy_tools/agent_card
	name = "Agent Identification Card"
	desc = "Agent cards prevent artificial intelligences from tracking the wearer, and can copy access \
			from other identification cards. The access is cumulative, so scanning one card does not erase the \
			access gained from another. In addition, they can be forged to display a new assignment and name. \
			This can be done an unlimited amount of times. Some Syndicate areas and devices can only be accessed \
			with these cards."
	item = /obj/item/weapon/card/id/syndicate
	cost = 2

/datum/uplink_item/stealthy_tools/voice_changer
	name = "Voice Changer"
	desc = "A conspicuous gas mask that mimics the voice named on your identification card. It can be toggled on and off."
	item = /obj/item/clothing/mask/gas/voice
	cost = 3

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Chameleon Projector"
	desc = "Projects an image across a user, disguising them as an object scanned with it, as long as they don't \
			move the projector from their hand. Disguised users move slowly, and projectiles pass over them."
	item = /obj/item/device/chameleon
	cost = 7
	exclude_modes = list(/datum/game_mode/gang)

/datum/uplink_item/stealthy_tools/camera_bug
	name = "Camera Bug"
	desc = "Enables you to view all cameras on the network and track a target. Bugging cameras allows you \
			to disable them remotely."
	item = /obj/item/device/camera_bug
	cost = 1
	surplus = 90

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Smuggler's Satchel"
	desc = "This satchel is thin enough to be hidden in the gap between plating and tiling; great for stashing \
			your stolen goods. Comes with a crowbar and a floor tile inside."
	item = /obj/item/weapon/storage/backpack/satchel_flat
	cost = 2
	surplus = 30

/datum/uplink_item/stealthy_tools/stimpack
	name = "Stimpack"
	desc = "Stimpacks, the tool of many great heroes, make you nearly immune to stuns and knockdowns for about \
			5 minutes after injection."
	item = /obj/item/weapon/reagent_containers/syringe/stimulants
	cost = 5
	surplus = 90

/datum/uplink_item/stealthy_tools/mulligan
	name = "Mulligan"
	desc = "Screwed up and have security on your tail? This handy syringe will give you a completely new identity \
			and appearance."
	item = /obj/item/weapon/reagent_containers/syringe/mulligan
	cost = 4
	surplus = 30
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

// Devices and Tools
/datum/uplink_item/device_tools
	category = "Devices and Tools"

/datum/uplink_item/device_tools/emag
	name = "Cryptographic Sequencer"
	desc = "The cryptographic sequencer, electromagnetic card, or emag, is a small card that unlocks hidden functions \
			in electronic devices, subverts intended functions, and easily breaks security mechanisms."
	item = /obj/item/weapon/card/emag
	cost = 6
	exclude_modes = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/toolbox
	name = "Full Syndicate Toolbox"
	desc = "The syndicate toolbox is a suspicious black and red. It comes loaded with a full tool set including a \
			multitool and combat gloves that are resistant to shocks and heat."
	item = /obj/item/weapon/storage/toolbox/syndicate
	cost = 1

/datum/uplink_item/device_tools/surgerybag
	name = "Syndicate Surgery Dufflebag"
	desc = "The Syndicate surgery dufflebag is a toolkit containing all surgery tools, surgical drapes, \
			a Syndicate brand MMI, a straitjacket, and a muzzle."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/med/surgery
	cost = 4

/datum/uplink_item/device_tools/military_belt
	name = "Military Belt"
	desc = "A robust seven-slot red belt that is capable of holding all manner of tatical equipment."
	item = /obj/item/weapon/storage/belt/military
	cost = 3
	exclude_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/medkit
	name = "Syndicate Combat Medic Kit"
	desc = "This first aid kit is a suspicious brown and red. Included is a combat stimulant injector \
			for rapid healing, a medical HUD for quick identification of injured personnel, \
			and other supplies helpful for a field medic."
	item = /obj/item/weapon/storage/firstaid/tactical
	cost = 9
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)


/datum/uplink_item/device_tools/space_suit
	name = "Syndicate Space Suit"
	desc = "This red and black syndicate space suit is less encumbering than Nanotrasen variants, \
			fits inside bags, and has a weapon slot. Nanotrasen crewmembers are trained to report red space suit \
			sightings, however."
	item = /obj/item/weapon/storage/box/syndie_kit/space
	cost = 4
	exclude_modes = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/hardsuit
	name = "Syndicate Hardsuit"
	desc = "The feared suit of a syndicate nuclear agent. Features slightly better armoring and a built in jetpack \
			that runs off standard atmospheric tanks. When the built in helmet is deployed your identity will be \
			protected, even in death, as the suit cannot be removed by outside forces. Toggling the suit in and out of \
			combat mode will allow you all the mobility of a loose fitting uniform without sacrificing armoring. \
			Additionally the suit is collapsible, making it small enough to fit within a backpack. \
			Nanotrasen crew who spot these suits are known to panic."
	item = /obj/item/clothing/suit/space/hardsuit/syndi
	cost = 8
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/hardsuit/elite
	name = "Elite Syndicate Hardsuit"
	desc = "An advanced hardsuit with superior armor and mobility to the standard Syndicate Hardsuit."
	item = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	cost = 8

/datum/uplink_item/device_tools/thermal
	name = "Thermal Imaging Glasses"
	desc = "These goggles can be turned to resemble common eyewears throughout the station. \
			They allow you to see organisms through walls by capturing the upper portion of the infrared light spectrum, \
			emitted as heat and light by objects. Hotter objects, such as warm bodies, cybernetic organisms \
			and artificial intelligence cores emit more of this light than cooler objects like walls and airlocks."
	item = /obj/item/clothing/glasses/thermal/syndi
	cost = 4

/datum/uplink_item/device_tools/binary
	name = "Binary Translator Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to and talk with silicon-based lifeforms, \
			such as AI units and cyborgs, over their private binary channel. Caution should \
			be taken while doing this, as unless they are allied with you, they are programmed to report such intrusions."
	item = /obj/item/device/encryptionkey/binary
	cost = 5
	surplus = 75

/datum/uplink_item/device_tools/encryptionkey
	name = "Syndicate Encryption Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to all station department channels \
			as well as talk on an encrypted Syndicate channel with other agents that have the same key."
	item = /obj/item/device/encryptionkey/syndicate
	cost = 2
	surplus = 75

/datum/uplink_item/device_tools/ai_detector
	name = "Artificial Intelligence Detector"
	desc = "A functional multitool that turns red when it detects an artificial intelligence watching it or its \
			holder. Knowing when an artificial intelligence is watching you is useful for knowing when to maintain cover."
	item = /obj/item/device/multitool/ai_detect
	cost = 1

/datum/uplink_item/device_tools/hacked_module
	name = "Hacked AI Law Upload Module"
	desc = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. \
			Be careful with wording, as artificial intelligences may look for loopholes to exploit."
	item = /obj/item/weapon/aiModule/syndicate
	cost = 14

/datum/uplink_item/device_tools/magboots
	name = "Blood-Red Magboots"
	desc = "A pair of magnetic boots with a Syndicate paintjob that assist with freer movement in space or on-station \
			during gravitational generator failures. These reverse-engineered knockoffs of Nanotrasen's \
			'Advanced Magboots' slow you down in simulated-gravity environments much like the standard issue variety."
	item = /obj/item/clothing/shoes/magboots/syndie
	cost = 3
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/c4
	name = "Composition C-4"
	desc = "C-4 is plastic explosive of the common variety Composition C. You can use it to breach walls or connect \
			a signaler to its wiring to make it remotely detonable. It has a modifiable timer with a \
			minimum setting of 10 seconds."
	item = /obj/item/weapon/c4
	cost = 1

/datum/uplink_item/device_tools/powersink
	name = "Power Sink"
	desc = "When screwed to wiring attached to a power grid and activated, this large device places excessive \
			load on the grid, causing a stationwide blackout. The sink is large and cannot be stored in most \
			traditional bags and boxes."
	item = /obj/item/device/powersink
	cost = 10

/datum/uplink_item/device_tools/singularity_beacon
	name = "Singularity Beacon"
	desc = "When screwed to wiring attached to an electric grid and activated, this large device pulls any \
			active gravitational singularities towards it. This will not work when the singularity is still \
			in containment. A singularity beacon can cause catastrophic damage to a space station, \
			leading to an emergency evacuation. Because of its size, it cannot be carried. Ordering this \
			sends you a small beacon that will teleport the larger beacon to your location upon activation."
	item = /obj/item/device/sbeacondrop
	cost = 14
	exclude_modes = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate bomb is a fearsome device capable of massive destruction. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so."
	item = /obj/item/device/sbeacondrop/bomb
	cost = 11

/datum/uplink_item/device_tools/syndicate_detonator
	name = "Syndicate Detonator"
	desc = "The Syndicate detonator is a companion device to the Syndicate bomb. Simply press the included button \
			and an encrypted radio frequency will instruct all live Syndicate bombs to detonate. \
			Useful for when speed matters or you wish to synchronize multiple bomb blasts. Be sure to stand clear of \
			the blast radius before using the detonator."
	item = /obj/item/device/syndicatedetonator
	cost = 3
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/rad_laser
	name = "Radioactive Microlaser"
	desc = "A radioactive microlaser disguised as a standard Nanotrasen health analyzer. When used, it emits a \
			powerful burst of radiation, which, after a short delay, can incapitate all but the most protected \
			of humanoids. It has two settings: intensity, which controls the power of the radiation, \
			and wavelength, which controls how long the radiation delay is."
	item = /obj/item/device/rad_laser
	cost = 5

/datum/uplink_item/device_tools/assault_pod
	name = "Assault Pod Targetting Device"
	desc = "Use to select the landing zone of your assault pod."
	item = /obj/item/device/assault_pod
	cost = 30
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/shield
	name = "Energy Shield"
	desc = "An incredibly useful personal shield projector, capable of reflecting energy projectiles and defending \
			against other attacks. Pair with an Energy Sword for a killer combination."
	item = /obj/item/weapon/shield/energy
	cost = 16
	surplus = 20
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/device_tools/medgun
	name = "Medbeam Gun"
	desc = "A wonder of Syndicate engineering, the Medbeam gun, or Medi-Gun enables a medic to keep his fellow \
			operatives in the fight, even while under fire."
	item = /obj/item/weapon/gun/medbeam
	cost = 15
	include_modes = list(/datum/game_mode/nuclear)


// Implants
/datum/uplink_item/implants
	category = "Implants"

/datum/uplink_item/implants/freedom
	name = "Freedom Implant"
	desc = "An implant injected into the body and later activated at the user's will. It will attempt to free the \
			user from common restraints such as handcuffs."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_freedom
	cost = 5

/datum/uplink_item/implants/uplink
	name = "Uplink Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will open a separate uplink \
			with 10 telecrystals. Undetectable, and excellent for escaping confinement."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_uplink
	cost = 14
	surplus = 0

/datum/uplink_item/implants/adrenal
	name = "Adrenal Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will inject a chemical \
			cocktail which has a mild healing effect along with removing all stuns and increasing movement speed."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_adrenal
	cost = 8

/datum/uplink_item/implants/storage
	name = "Storage Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will open a small subspace \
			pocket capable of storing two items."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_storage
	cost = 8

/datum/uplink_item/implants/microbomb
	name = "Microbomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. \
			The more implants inside of you, the higher the explosive power. \
			This will permanently destroy your body, however."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_microbomb
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/implants/macrobomb
	name = "Macrobomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. \
			Upon death, releases a massive explosion that will wipe out everything nearby."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_macrobomb
	cost = 20
	include_modes = list(/datum/game_mode/nuclear)


// Cybernetics
/datum/uplink_item/cyber_implants
	category = "Cybernetic Implants"
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/cyber_implants/thermals
	name = "Thermal Vision Implant"
	desc = "These cybernetic eyes will give you thermal vision. They must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/eyes/thermals
	cost = 8

/datum/uplink_item/cyber_implants/xray
	name = "X-Ray Vision Implant"
	desc = "These cybernetic eyes will give you X-ray vision. They must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/eyes/xray
	cost = 10

/datum/uplink_item/cyber_implants/antistun
	name = "CNS Rebooter Implant"
	desc = "This implant will help you get back up on your feet faster after being stunned. \
			It must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/brain/anti_stun
	cost = 12

/datum/uplink_item/cyber_implants/reviver
	name = "Reviver Implant"
	desc = "This implant will attempt to revive you if you lose consciousness. It must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/chest/reviver
	cost = 8

/datum/uplink_item/cyber_implants/bundle
	name = "Cybernetic Implants Bundle"
	desc = "A random selection of cybernetic implants. Guaranteed 5 high quality implants. \
			They must be implanted via surgery."
	item = /obj/item/weapon/storage/box/cyber_implants
	cost = 40

// Pointless
/datum/uplink_item/badass
	category = "(Pointless) Badassery"
	surplus = 0

/datum/uplink_item/badass/syndiecigs
	name = "Syndicate Smokes"
	desc = "Strong flavor, dense smoke, infused with omnizine."
	item = /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	cost = 2

/datum/uplink_item/badass/bundle
	name = "Syndicate Bundle"
	desc = "Syndicate Bundles are specialised groups of items that arrive in a plain box. \
			These items are collectively worth more than 20 telecrystals, but you do not know which specialisation \
			you will receive."
	item = /obj/item/weapon/storage/box/syndicate
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/badass/syndiecards
	name = "Syndicate Playing Cards"
	desc = "A special deck of space-grade playing cards with a mono-molecular edge and metal reinforcement, \
			making them slightly more robust than a normal deck of cards. \
			You can also play card games with them or leave them on your victims."
	item = /obj/item/toy/cards/deck/syndicate
	cost = 1
	surplus = 40

/datum/uplink_item/badass/syndiecash
	name = "Syndicate Briefcase Full of Cash"
	desc = "A secure briefcase containing 5000 space credits. Useful for bribing personnel, or purchasing goods \
			and services at lucrative prices. The briefcase also feels a little heavier to hold; it has been \
			manufactured to pack a little bit more of a punch if your client needs some convincing."
	item = /obj/item/weapon/storage/secure/briefcase/syndie
	cost = 1

/datum/uplink_item/badass/balloon
	name = "Syndicate Balloon"
	desc = "For showing that you are THE BOSS: A useless red balloon with the Syndicate logo on it. \
			Can blow the deepest of covers."
	item = /obj/item/toy/syndicateballoon
	cost = 20

/datum/uplink_item/badass/raincoat
    name = "Raincoat"
    desc = "It's hip to be square!"
    item = /obj/item/clothing/suit/raincoat
    cost = 1

/datum/uplink_item/badass/surplus
	name = "Syndicate Surplus Crate"
	desc = "A dusty crate from the back of the Syndicate warehouse. Rumored to contain a valuable assortion of items, \
			but you never know. Contents are sorted to always be worth 50 TC."
	cost = 20
	item = /obj/item/weapon/storage/box/syndicate
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/gang)

/datum/uplink_item/badass/surplus_crate/spawn_item(turf/loc, obj/item/device/uplink/U)
	var/list/uplink_items = get_uplink_items()

	var/crate_value = 50
	var/obj/structure/closet/crate/C = new(loc)
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]

		if(!prob(I.surplus))
			continue
		if(crate_value < I.cost)
			continue
		crate_value -= I.cost
		new I.item(C)
		U.purchase_log += "<big>\icon[I.item]</big>"

	return C

/datum/uplink_item/badass/random
	name = "Random Item"
	desc = "Picking this will purchase a random item. Useful if you have some TC to spare or if you haven't \
			decided on a strategy yet."
	item = /obj/item/weapon/storage/box/syndicate
	cost = 0

/datum/uplink_item/badass/random/spawn_item(turf/loc, obj/item/device/uplink/U)
	var/list/uplink_items = get_uplink_items()
	var/list/possible_items = list()
	for(var/category in uplink_items)
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(src == I || !I.item)
				continue
			if(U.telecrystals < I.cost)
				continue
			possible_items += I

	if(possible_items.len)
		var/datum/uplink_item/I = pick(possible_items)
		U.telecrystals -= I.cost
		feedback_add_details("traitor_uplink_items_bought","RN")
		return new I.item(loc)