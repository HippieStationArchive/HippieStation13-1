var/list/uplink_items = list()

/proc/get_uplink_items()
	// If not already initialized..
	if(!uplink_items.len)
		// Fill in the list	and order it like this:
		// A keyed list, acting as categories, which are lists to the datum.
		var/list/last = list()
		for(var/item in typesof(/datum/uplink_item))

			var/datum/uplink_item/I = new item()
			if(!I.item)
				continue
			if(I.gamemodes.len && ticker && !(ticker.mode.type in I.gamemodes))
				continue
			if(I.excludefrom.len && ticker && (ticker.mode.type in I.excludefrom))
				continue
			if(I.last)
				last += I
				continue

			if(!uplink_items[I.category])
				uplink_items[I.category] = list()

			uplink_items[I.category] += I

		for(var/datum/uplink_item/I in last)

			if(!uplink_items[I.category])
				uplink_items[I.category] = list()

			uplink_items[I.category] += I

	return uplink_items

// You can change the order of the list by putting datums before/after one another OR
// you can use the last variable to make sure it appears last, well have the category appear last.

/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null
	var/cost = 0
	var/last = 0 // Appear last
	var/list/gamemodes = list() // Empty list means it is in all the gamemodes. Otherwise place the gamemode name here.
	var/list/excludefrom = list() //Empty list does nothing. Place the name of gamemode you don't want this item to be available in here. This is so you dont have to list EVERY mode to exclude something.
	var/surplus = 100 //Chance of being included in the surplus crate (when pick() selects it)
	var/list/jobs = list() // For job-specific traitor items. Leave empty for all jobs to be allowed to buy it.
	var/list/jobs_exclude = list() //Not sure why would you want to exclude uplink items from some jobs, but okay.

/datum/uplink_item/proc/spawn_item(var/turf/loc, var/obj/item/device/uplink/U)
	if(item)
		U.uses -= max(cost, 0)
		U.used_TC += cost
		feedback_add_details("traitor_uplink_items_bought", "[item]")
		return new item(loc)

/datum/uplink_item/proc/buy(var/obj/item/device/uplink/U, var/mob/user)

	..()
	if(!istype(U))
		return 0

	if (!user || user.stat || user.restrained())
		return 0

	// If the uplink's holder is in the user's contents
	if ((U.loc in user.contents || (in_range(U.loc, user) && istype(U.loc.loc, /turf))))
		user.set_machine(U)
		if(cost > U.uses)
			return 0

		var/obj/I = spawn_item(get_turf(user), U)

		if(istype(I, /obj/item))
			if(ishuman(user))
				var/mob/living/carbon/human/A = user
				A.put_in_any_hand_if_possible(I)

			if(istype(I,/obj/item/weapon/storage/box/) && I.contents.len>0)
				for(var/atom/o in I)
					U.purchase_log += "<BIG>\icon[o]</BIG>"
			else
				U.purchase_log += "<BIG>\icon[I]</BIG>"

		U.interact(user)
		return 1
	return 0

/*
//
//	UPLINK ITEMS
//
*/

// JOB-SPECIFIC ITEMS

/datum/uplink_item/job_specific //No job-specific support for surplus yet.
	category = "Job-specific Contraband"
	surplus = 0

//ENGINEER DIVISION

/datum/uplink_item/job_specific/rodgun
	name = "Rod Gun"
	desc = "Based on the staple gun design, this baby can be loaded with 3 rods that you can shoot for them to embed into people." //This thing may be super OP
	item = /obj/item/weapon/gun/rodgun
	cost = 10 //Costly, but for a good reason
	jobs = list("Station Engineer", "Chief Engineer", "Atmospheric Technician")

//CHEMIST
/datum/uplink_item/job_specific/assX
	name = "Ass-X pill"
	desc = "A hilarious pill that will force your target to superfart while dealing lots of damage to their stomach. It can be surprisingly effective."
	item = /obj/item/weapon/reagent_containers/pill/assX
	cost = 4
	jobs = list("Chemist")

//LIBRARIAN
/datum/uplink_item/job_specific/soulstone
	name = "Soulstone"
	desc = "This stone will be able to capture your victim's soul and bind them to your will."
	item = /obj/item/device/soulstone
	cost = 5 //nerfed the cost on Chronitonity's request
	jobs = list("Librarian") //Switched soulstones to librarian, gave chaplain skelestones
//TODO: Add flash disguised as camera

//CHAPLAIN
/datum/uplink_item/job_specific/skelestone
	name = "Skelestone"
	desc = "Make a skeleton minion! Has one use."
	item = /obj/item/device/necromantic_stone/oneuse
	cost = 7
	jobs = list("Chaplain")

//BARTENDER
/datum/uplink_item/job_specific/buckshot
	name = "12g Buckshot Shell"
	desc = "Buckshot shells fire 5 pellets that will spread in the direction you are shooting. They can be loaded into your double-barreled shotgun. Absolutely devastating point-blank."
	item = /obj/item/ammo_casing/shotgun/buckshot
	cost = 5
	jobs = list("Bartender")

//JANITOR

//TODO: Meatcubing trashcart goon-style

//BOTANIST
/datum/uplink_item/job_specific/chainsaw
	name = "Chainsaw"
	desc = "An extremely loud, dirty, noisy, bulky, powerful as hell chainsaw that will absolutely destroy anyone it comes in contact with. Obviously won't fit in your backpack."
	item = /obj/item/weapon/twohanded/chainsaw
	cost = 14
	jobs = list("Botanist", "Bartender", "Chef")

//ASSISTANT
/datum/uplink_item/job_specific/stungloves
	name = "Stun Gloves"
	desc = "Classic among cunning assistant assasins, these gloves stun your target on touch. Be careful when you wear them, though."
	item = /obj/item/clothing/gloves/stungloves
	cost = 4
	jobs = list("Assistant")

// DANGEROUS WEAPONS

/datum/uplink_item/dangerous
	category = "Conspicuous and Dangerous Weapons"

/datum/uplink_item/dangerous/pistol
	name = "Syndicate Pistol"
	desc = "A small, easily concealable handgun that uses 10mm auto rounds in 8-round magazines and is compatible with suppressors."
	item = /obj/item/weapon/gun/projectile/automatic/pistol
	cost = 9

/datum/uplink_item/dangerous/revolver
	name = "Syndicate Revolver"
	desc = "A brutally simple syndicate revolver that fires .357 Magnum cartridges and has 7 chambers."
	item = /obj/item/weapon/gun/projectile/revolver
	cost = 13
	surplus = 50

/datum/uplink_item/dangerous/smg
	name = "C-20r Submachine Gun"
	desc = "A fully-loaded Scarborough Arms bullpup submachine gun that fires .45 rounds with a 20-round magazine and is compatible with suppressors."
	item = /obj/item/weapon/gun/projectile/automatic/c20r
	cost = 14
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 40

/datum/uplink_item/dangerous/car
	name = "C-90gl Compact Assault Rifle"
	desc = "A fully-loaded Zashchita Industriya toploading bullpup assault rifle that uses 30-round 5.45x39mm magazines with a togglable underslung 40mm grenade launcher."
	item = /obj/item/weapon/gun/projectile/automatic/c90gl
	cost = 18
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 50

/datum/uplink_item/dangerous/machinegun
	name = "L6 Squad Automatic Weapon"
	desc = "A fully-loaded Aussec Armoury belt-fed machine gun. This deadly weapon has a massive 50-round magazine of devastating 7.62x51mm ammunition."
	item = /obj/item/weapon/gun/projectile/automatic/l6_saw
	cost = 40
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/crossbow
	name = "Miniature Energy Crossbow"
	desc = "A short bow mounted across a tiller in miniature. Small enough to fit into a pocket or slip into a bag unnoticed. It fires bolts tipped with a paralyzing toxin collected from a rare organism. \
	Its bolts stun enemies for short periods, and replenish automatically."
	item = /obj/item/weapon/gun/energy/crossbow
	cost = 12
	excludefrom = list(/datum/game_mode/nuclear)
	surplus = 50

/datum/uplink_item/dangerous/flamethrower
	name = "Flamethrower"
	desc = "A flamethrower, fueled by a portion of highly flammable biotoxins stolen previously from Nanotrasen stations. Make a statement by roasting the filth in their own greed. Use with caution."
	item = /obj/item/weapon/flamethrower/full/tank
	cost = 11
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 40

/datum/uplink_item/dangerous/sword
	name = "Energy Sword"
	desc = "The energy sword is an edged weapon with a blade of pure energy. The sword is small enough to be pocketed when inactive. Activating it produces a loud, distinctive noise."
	item = /obj/item/weapon/melee/energy/sword/saber
	cost = 8

/datum/uplink_item/dangerous/combatknife
	name = "Combat Knife"
	desc = "The combat knife is a military blade created for those situations when you need to finish someone off. Favored by nuclear operatives, this knife is also effective in throwing. \
	It's not as powerful as an energy sword but it can be stuffed in your pocket. Please note that if you're caught with this knife you'll definitely be found out."
	item = /obj/item/weapon/melee/combatknife
	cost = 6

/datum/uplink_item/dangerous/emp
	name = "EMP Kit"
	desc = "A box that contains two EMP grenades, an EMP implant and a short ranged recharging device disguised as a flashlight. Useful to disrupt communication and silicon lifeforms."
	item = /obj/item/weapon/storage/box/syndie_kit/emp
	cost = 5

/datum/uplink_item/dangerous/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "The Minibomb is a grenade with a five-second fuse."
	item = /obj/item/weapon/grenade/syndieminibomb
	cost = 6

/datum/uplink_item/dangerous/viscerators
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerators upon activation, which will chase down and shred any non-operatives in the area."
	item = /obj/item/weapon/grenade/spawnergrenade/manhacks
	cost = 8
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 35

/datum/uplink_item/dangerous/bioterror
	name = "Biohazardous Chemical Sprayer"
	desc = "A chemical sprayer that allows a wide dispersal of selected chemicals. Especially tailored by the Tiger Cooperative, the deadly blend it comes stocked with will disorient, damage, and disable your foes... \
	Use with extreme caution, to prevent exposure to yourself and your fellow operatives."
	item = /obj/item/weapon/reagent_containers/spray/chemsprayer/bioterror
	cost = 20
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/gygax
	name = "Gygax Exosuit"
	desc = "A lightweight exosuit, painted in a dark scheme. Its speed and equipment selection make it excellent for hit-and-run style attacks. \
	This model lacks a method of space propulsion, and therefore it is advised to repair the mothership's teleporter if you wish to make use of it."
	item = /obj/mecha/combat/gygax/dark/loaded
	cost = 90
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/mauler
	name = "Mauler Exosuit"
	desc = "A massive and incredibly deadly Syndicate exosuit. Features long-range targetting, thrust vectoring, and deployable smoke."
	item = /obj/mecha/combat/marauder/mauler/loaded
	cost = 140
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/syndieborg
	name = "Syndicate Cyborg"
	desc = "A cyborg designed and programmed for systematic extermination of non-Syndicate personnel."
	item = /obj/item/weapon/antag_spawner/borg_tele
	cost = 50
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

//for refunding the syndieborg teleporter
/datum/uplink_item/dangerous/syndieborg/spawn_item()
	var/obj/item/weapon/antag_spawner/borg_tele/T = ..()
	if(istype(T))
		T.TC_cost = cost

// AMMUNITION

/datum/uplink_item/ammo
	category = "Ammunition"
	surplus = 40

/datum/uplink_item/ammo/pistol
	name = "Magazine - 10mm"
	desc = "An additional 8-round 10mm magazine for use in the syndicate pistol. These subsonic rounds are dirt cheap but are half as effective as .357 rounds."
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 1

/datum/uplink_item/ammo/revolver
	name = "Speed Loader - .357"
	desc = "A speed loader that contains seven additional .357 Magnum rounds for the syndicate revolver. For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	cost = 4

/datum/uplink_item/ammo/smg
	name = "Magazine - .45"
	desc = "An additional 20-round .45 magazine for use in the C-20r submachine gun. These bullets pack a lot of punch that can knock most targets down, but do limited overall damage."
	item = /obj/item/ammo_box/magazine/smgm45
	cost = 2
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/bullstun
	name = "Drum Magazine - 12g Stun Slug"
	desc = "An alternate 8-round stun slug magazine for use in the Bulldog shotgun. Saying that they're completely non-lethal would be lying."
	item = /obj/item/ammo_box/magazine/m12g/stun
	cost = 2
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/bullbuck
	name = "Drum Magazine - 12g Buckshot"
	desc = "An additional 8-round buckshot magazine for use in the Bulldog shotgun. Front towards enemy."
	item = /obj/item/ammo_box/magazine/m12g
	cost = 2
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/bulldragon
	name = "Drum Magazine - 12g Dragon's Breath"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. I'm a fire starter, twisted fire starter!"
	item = /obj/item/ammo_box/magazine/m12g/dragon
	cost = 3
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/car
	name = "Box Magazine - 5.45x39mm"
	desc = "An additional 30-round 5.45x39mm magazine for use in the C-90gl assault rifle. These bullets don't have the punch to knock most targets down, but dish out higher overall damage."
	item = /obj/item/ammo_box/magazine/m545
	cost = 2
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/a40mm
	name = "Ammo Box - 40mm grenades"
	desc = "A box of 4 additional 40mm HE grenades for use the C-90gl's underbarrel grenade launcher. Your teammates will thank you to not shoot these down small hallways."
	item = /obj/item/ammo_box/a40mm
	cost = 4
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun
	name = "Box Magazine - 7.62×51mm"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use in the L6 SAW machinegun. By the time you need to use this, you'll already be on a pile of corpses."
	item = /obj/item/ammo_box/magazine/m762
	cost = 12
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

// STEALTHY WEAPONS

/datum/uplink_item/stealthy_weapons
	category = "Stealthy and Inconspicuous Weapons"

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen, filled with a potent mix of drugs, including a strong anaesthetic and a chemical that is capable of blocking the movement of the vocal chords. \
	The pen holds one dose of the mixture, and cannot be refilled."
	item = /obj/item/weapon/pen/sleepy
	cost = 4
	excludefrom = list(/datum/game_mode/nuclear)

/datum/uplink_item/stealthy_weapons/soap
	name = "Syndicate Soap"
	desc = "A sinister-looking surfactant used to clean blood stains to hide murders and prevent DNA analysis. You can also drop it underfoot to slip people."
	item = /obj/item/weapon/soap/syndie
	cost = 1
	surplus = 50

/datum/uplink_item/stealthy_weapons/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five opportunities to detonate PDAs of crewmembers who have their message feature enabled. \
	The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer. It has a chance to detonate your PDA."
	item = /obj/item/weapon/cartridge/syndicate
	cost = 6

/datum/uplink_item/stealthy_weapons/suppressor
	name = "Universal Suppressor"
	desc = "Fitted for use on any small caliber weapon with a threaded barrel, this suppressor will silence the shots of the weapon for increased stealth and superior ambushing capability."
	item = /obj/item/weapon/suppressor
	cost = 3
	surplus = 10

// STEALTHY TOOLS

/datum/uplink_item/stealthy_tools
	category = "Stealth and Camouflage Items"

/datum/uplink_item/stealthy_tools/chameleon_jumpsuit
	name = "Chameleon Jumpsuit"
	desc = "A jumpsuit used to imitate the uniforms of Nanotrasen crewmembers."
	item = /obj/item/clothing/under/chameleon
	cost = 4

/datum/uplink_item/stealthy_tools/chameleon_stamp
	name = "Chameleon Stamp"
	desc = "A stamp that can be activated to imitate an official Nanotrasen Stamp. The disguised stamp will work exactly like the real stamp and will allow you to forge false documents to gain access or equipment; \
	it can also be used in a washing machine to forge clothing."
	item = /obj/item/weapon/stamp/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/syndigolashes
	name = "No-Slip Brown Shoes"
	desc = "These allow you to run on wet floors. They do not work on lubricated surfaces."
	item = /obj/item/clothing/shoes/syndigaloshes
	cost = 4

/datum/uplink_item/stealthy_tools/agent_card
	name = "Agent Identification card"
	desc = "Agent cards prevent artificial intelligences from tracking the wearer, and can copy access from other identification cards. The access is cumulative, so scanning one card does not erase the access gained from another."
	item = /obj/item/weapon/card/id/syndicate
	cost = 3

/datum/uplink_item/stealthy_tools/voice_changer
	name = "Voice Changer"
	item = /obj/item/clothing/mask/gas/voice
	desc = "A conspicuous gas mask that mimics the voice named on your identification card. When no identification is worn, the mask will render your voice unrecognizable."
	cost = 5

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Chameleon-Projector"
	desc = "Projects an image across a user, disguising them as an object scanned with it, as long as they don't move the projector from their hand. The disguised user cannot run and rojectiles pass over them."
	item = /obj/item/device/chameleon
	cost = 7

/datum/uplink_item/stealthy_tools/camera_bug
	name = "Camera Bug"
	desc = "Enables you to bug cameras to view them remotely. Adding particular items to it alters its functions."
	item = /obj/item/device/camera_bug
	cost = 2
	surplus = 90

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Smuggler's Satchel"
	desc = "This satchel is thin enough to be hidden in the gap between plating and tiling, great for stashing your stolen goods. Comes with a crowbar and a floor tile inside."
	item = /obj/item/weapon/storage/backpack/satchel_flat
	cost = 2
	surplus = 30

// DEVICE AND TOOLS

/datum/uplink_item/device_tools
	category = "Devices and Tools"

/datum/uplink_item/device_tools/emag
	name = "Cryptographic Sequencer"
	desc = "The emag is a small card that unlocks hidden functions in electronic devices, subverts intended functions and characteristically breaks security mechanisms."
	item = /obj/item/weapon/card/emag
	cost = 6

/datum/uplink_item/device_tools/toolbox
	name = "Full Syndicate Toolbox"
	desc = "The syndicate toolbox is a suspicious black and red. Aside from tools, it comes with cable and a multitool. Insulated gloves are not included."
	item = /obj/item/weapon/storage/toolbox/syndicate
	cost = 1

/datum/uplink_item/device_tools/medkitnorm
	name = "Syndicate Medical Supply Kit" //Unlike tacticool medkit it's not gamemode-restricted.
	desc = "The syndicate medkit is a suspicious black and red. Included is 6 syndicate chempatches (brutanol and ointment), 3 gauzes, a health anaylzer and a medipen with inaprovaline."
	item = /obj/item/weapon/storage/firstaid/syndicate
	cost = 4 //Hefty price for robust meds

/datum/uplink_item/device_tools/medkit
	name = "Syndicate Tacticool Medkit"
	desc = "The syndicate medkit is a suspicious black and red. Included is a combat stimulant injector for rapid healing, a medical hud for quick identification of injured comrades, \
	and other medical supplies helpful for a medical field operative."
	item = /obj/item/weapon/storage/firstaid/tactical
	cost = 6 //Nerfed from 9 so there's a reason to actually use it. It's pretty shit overall anyway.
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/badass/syndiecigs
	name = "Syndicate Smokes"
	desc = "Strong flavor, dense smoke, infused with Doctor's Delight."
	item = /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	cost = 4

/datum/uplink_item/device_tools/space_suit
	name = "Syndicate Space Suit"
	desc = "The red and black syndicate space suit is less encumbering than Nanotrasen variants, fits inside bags, and has a weapon slot. Nanotrasen crewmembers are trained to report red space suit sightings."
	item = /obj/item/weapon/storage/box/syndie_kit/space
	cost = 5

/datum/uplink_item/device_tools/thermal
	name = "Thermal Imaging Glasses"
	desc = "These glasses are thermals disguised as engineers' optical meson scanners. \
	They allow you to see organisms through walls by capturing the upper portion of the infrared light spectrum, emitted as heat and light by objects. \
	Hotter objects, such as warm bodies, cybernetic organisms and artificial intelligence cores emit more of this light than cooler objects like walls and airlocks." //THEN WHY CANT THEY SEE PLASMA FIRES????
	item = /obj/item/clothing/glasses/thermal/syndi
	cost = 6

/datum/uplink_item/device_tools/binary
	name = "Binary Translator Key"
	desc = "A key, that when inserted into a radio headset, allows you to listen to and talk with artificial intelligences and cybernetic organisms in binary. "
	item = /obj/item/device/encryptionkey/binary
	cost = 5
	surplus = 75

/datum/uplink_item/device_tools/encryptionkey
	name = "Syndicate Encryption Key"
	desc = "A key, that when inserted into a radio headset, allows you to listen to all station department channels as well as talk on an encrypted Syndicate channel."
	item = /obj/item/device/encryptionkey/syndicate
	cost = 5
	surplus = 75

/datum/uplink_item/device_tools/ai_detector
	name = "Artificial Intelligence Detector" // changed name in case newfriends thought it detected disguised ai's
	desc = "A functional multitool that turns red when it detects an artificial intelligence watching it or its holder. Knowing when an artificial intelligence is watching you is useful for knowing when to maintain cover."
	item = /obj/item/device/multitool/ai_detect
	cost = 1

/datum/uplink_item/device_tools/hacked_module
	name = "Hacked AI Law Upload Module"
	desc = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. Be careful with their wording, as artificial intelligences may look for loopholes to exploit."
	item = /obj/item/weapon/aiModule/syndicate
	cost = 14

/datum/uplink_item/device_tools/advpinpointer
	name = "Advanced Pinpointer"
	desc = "This pinpointer lets you track objectives, people by DNA and the disk. It's very powerful yo!"
	item = /obj/item/weapon/pinpointer/advpinpointer
	cost = 4

/datum/uplink_item/device_tools/magboots
	name = "Blood-Red Magboots"
	desc = "A pair of magnetic boots with a Syndicate paintjob that assist with freer movement in space or on-station during gravitational generator failures. \
	These reverse-engineered knockoffs of Nanotrasen's 'Advanced Magboots' slow you down in simulated-gravity environments much like the standard issue variety."
	item = /obj/item/clothing/shoes/magboots/syndie
	cost = 5
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/bombingdisk
	name = "S-RSA Activation Disk"
	desc = "Insert into a Short-Ranged Subspace Artillery computer to carpet bomb a target. Who knows what it will hit!"
	item = /obj/item/weapon/disk/bombing
	cost = 10
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/c4
	name = "Composition C-4"
	desc = "C-4 is plastic explosive of the common variety Composition C. You can use it to breach walls or connect a signaler to its wiring to make it remotely detonable. \
	It has a modifiable timer with a minimum setting of 10 seconds."
	item = /obj/item/weapon/c4
	cost = 1

/datum/uplink_item/device_tools/powersink
	name = "Power sink"
	desc = "When screwed to wiring attached to an electric grid, then activated, this large device places excessive load on the grid, causing a stationwide blackout. The sink cannot be carried because of its excessive size. \
	Ordering this sends you a small beacon that will teleport the power sink to your location on activation."
	item = /obj/item/device/powersink
	cost = 10

/datum/uplink_item/device_tools/singularity_beacon
	name = "Singularity Beacon"
	desc = "When screwed to wiring attached to an electric grid, then activated, this large device pulls the singularity towards it. \
	Does not work when the singularity is still in containment. A singularity beacon can cause catastrophic damage to a space station, \
	leading to an emergency evacuation. Because of its size, it cannot be carried. Ordering this sends you a small beacon that will teleport the larger beacon to your location on activation."
	item = /obj/item/device/sbeacondrop
	cost = 14

/datum/uplink_item/device_tools/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate Bomb has an adjustable timer with a minimum setting of 60 seconds. Ordering the bomb sends you a small beacon, which will teleport the explosive to your location when you activate it. \
	You can wrench the bomb down to prevent removal. The crew may attempt to defuse the bomb."
	item = /obj/item/device/sbeacondrop/bomb
	cost = 11
	excludefrom = list(/datum/game_mode/traitor/double_agents)

/datum/uplink_item/device_tools/rad_laser
	name = "Radioactive Microlaser"
	desc = "A radioactive microlaser disguised as a standard Nanotrasen health analyzer. When used, it emits a powerful burst of radiation, which, after a short delay, can incapitate all but the most protected of humanoids. \
	It has two settings: intensity, which controls the power of the radiation, and wavelength, which controls how long the radiation delay is."
	item = /obj/item/device/rad_laser
	cost = 6

/datum/uplink_item/device_tools/syndicate_detonator
	name = "Syndicate Detonator"
	desc = "The Syndicate Detonator is a companion device to the Syndicate Bomb. Simply press the included button and an encrypted radio frequency will instruct all live syndicate bombs to detonate. \
	Useful for when speed matters or you wish to synchronize multiple bomb blasts. Be sure to stand clear of the blast radius before using the detonator."
	item = /obj/item/device/syndicatedetonator
	cost = 3
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/teleporter
	name = "Teleporter Circuit Board"
	desc = "A printed circuit board that completes the teleporter onboard the mothership. Advise you test fire the teleporter before entering it, as malfunctions can occur."
	item = /obj/item/weapon/circuitboard/teleporter
	cost = 40
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/device_tools/shield
	name = "Energy Shield"
	desc = "An incredibly useful personal shield projector, capable of reflecting energy projectiles and defending against other attacks."
	item = /obj/item/weapon/shield/energy
	cost = 16
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 20


// IMPLANTS

/datum/uplink_item/implants
	category = "Implants"

/datum/uplink_item/implants/freedom
	name = "Freedom Implant"
	desc = "An implant injected into the body and later activated using a bodily gesture to attempt to slip restraints."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_freedom
	cost = 5

/datum/uplink_item/implants/uplink
	name = "Uplink Implant"
	desc = "An implant injected into the body, and later activated using a bodily gesture to open an uplink with 10 telecrystals. \
	The ability for an agent to open an uplink after their posessions have been stripped from them makes this implant excellent for escaping confinement."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_uplink
	cost = 20
	surplus = 0

/datum/uplink_item/implants/adrenal
	name = "Adrenal Implant"
	desc = "An implant injected into the body, and later activated using a bodily gesture to inject a chemical cocktail, which has a mild healing effect along with removing all stuns and increasing his speed."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_adrenal
	cost = 8

/datum/uplink_item/implants/explosive
	name = "Explosive Implant"
	desc = "An implant injected into the body, and later activated using a bodily gesture to activate a bomb inside your cavity. \
	It's only effective if you want to go out with a boom. The explosion may or may not knock down the targets right next to you."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_explosive
	cost = 8

// POINTLESS BADASSERY

/datum/uplink_item/badass
	category = "(Pointless) Badassery"
	surplus = 0

/datum/uplink_item/badass/bundle
	name = "Syndicate Bundle"
	desc = "Syndicate Bundles are specialised groups of items that arrive in a plain box. These items are collectively worth more than 10 telecrystals, but you do not know which specialisation you will receive."
	item = /obj/item/weapon/storage/box/syndicate
	cost = 20
	excludefrom = list(/datum/game_mode/nuclear)

/datum/uplink_item/badass/syndiecards
	name = "Syndicate Playing Cards"
	desc = "A special deck of space-grade playing cards with a mono-molecular edge and metal reinforcement, making them more robust than a normal deck of cards. \
	You can also play card games with them or leave them in your victims."
	item = /obj/item/toy/cards/deck/syndicate
	cost = 1
	excludefrom = list(/datum/game_mode/nuclear)
	surplus = 40

/datum/uplink_item/badass/balloon
	name = "For showing that you are The Boss"
	desc = "A useless red balloon with the syndicate logo on it, which can blow the deepest of covers."
	item = /obj/item/toy/syndicateballoon
	cost = 20

/datum/uplink_item/badass/random
	name = "Random Item"
	desc = "Picking this choice will send you a random item from the list. Useful for when you cannot think of a strategy to finish your objectives with."
	item = /obj/item/weapon/storage/box/syndicate
	cost = 0

/datum/uplink_item/badass/random/spawn_item(var/turf/loc, var/obj/item/device/uplink/U)

	var/list/buyable_items = get_uplink_items()
	var/list/possible_items = list()

	for(var/category in buyable_items)
		for(var/datum/uplink_item/I in buyable_items[category])
			if(I == src)
				continue
			if(I.cost > U.uses)
				continue
			possible_items += I

	if(possible_items.len)
		var/datum/uplink_item/I = pick(possible_items)
		U.uses -= max(0, I.cost)
		feedback_add_details("traitor_uplink_items_bought","RN")
		return new I.item(loc)

/datum/uplink_item/badass/surplus_crate
	name = "Syndicate Surplus Crate"
	desc = "A crate containing 50 telecrystals worth of random syndicate leftovers."
	cost = 20
	item = /obj/item/weapon/storage/box/syndicate
	excludefrom = list(/datum/game_mode/nuclear)

/datum/uplink_item/badass/surplus_crate/spawn_item(turf/loc, obj/item/device/uplink/U)
	var/obj/structure/closet/crate/C = new(loc)
	var/list/temp_uplink_list = get_uplink_items()
	var/list/buyable_items = list()
	for(var/category in temp_uplink_list)
		buyable_items += temp_uplink_list[category]
	var/list/bought_items = list()
	U.uses -= cost
	U.used_TC = 20
	var/remaining_TC = 50

	var/datum/uplink_item/I
	while(remaining_TC)
		I = pick(buyable_items)
		if(!I.surplus)
			continue
		if(I.cost > remaining_TC)
			continue
		if((I.item in bought_items) && prob(33)) //To prevent people from being flooded with the same thing over and over again.
			continue
		bought_items += I.item
		remaining_TC -= I.cost

	U.purchase_log += "<BIG>\icon[C]</BIG>"
	for(var/item in bought_items)
		new item(C)
		U.purchase_log += "<BIG>\icon[item]</BIG>"
