var/list/uplink_items = list()

/proc/get_uplink_items(var/gamemode_override=null)
	// If not already initialized..
	if(!uplink_items.len)

		// Fill in the list	and order it like this:
		// A keyed list, acting as categories, which are lists to the datum.

		var/list/last = list()
		for(var/item in typesof(/datum/uplink_item))

			var/datum/uplink_item/I = new item()
			if(!I.item)
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

	//Filtered version
	var/list/filtered_uplink_items = list()

	for(var/category in uplink_items)
		for(var/datum/uplink_item/I in uplink_items[category])
			if(I.gamemodes.len)
				if(!gamemode_override && ticker && !(ticker.mode.type in I.gamemodes))
					continue
				if(gamemode_override && !(gamemode_override in I.gamemodes))
					continue
			if(I.excludefrom.len)
				if(!gamemode_override && ticker && (ticker.mode.type in I.excludefrom))
					continue
				if(gamemode_override && (gamemode_override in I.excludefrom))
					continue
			if(!filtered_uplink_items[I.category])
				filtered_uplink_items[I.category] = list()
			filtered_uplink_items[category] += I

	return filtered_uplink_items

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


/datum/uplink_item/proc/spawn_item(turf/loc, obj/item/device/uplink/U)
	if(item)
		U.uses -= max(cost, 0)
		U.used_TC += cost
		feedback_add_details("traitor_uplink_items_bought", "[item]")
		return new item(loc)

/datum/uplink_item/proc/buy(obj/item/device/uplink/U, mob/user)

	..()
	if(!istype(U))
		return 0

	if (!user || user.incapacitated())
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

/datum/uplink_item/job_specific
	category = "Job-specific Contraband"
	surplus = 1

//ATMOS + CLOWN

/datum/uplink_item/job_specific/farttank
	name = "Fart Tank"
	desc = "Suffocate someone with this pure nastiness in a tank."
	item = /obj/item/weapon/tank/internals/fart
	cost = 2
	jobs = list("Clown", "Atmospheric Technician")

//ENGINEER DIVISION

/datum/uplink_item/job_specific/rodgun
	name = "Rod Gun"
	desc = "Based on the staple gun design, this baby can be loaded with 3 rods that you can shoot for them to embed into people." //This thing may be super OP
	item = /obj/item/weapon/gun/rodgun
	cost = 10 //Costly, but for a good reason
	jobs = list("Station Engineer", "Chief Engineer", "Atmospheric Technician")

//SCIENCE + MEDICAL
/datum/uplink_item/job_specific/labcoat
	name = "Armored Labcoat"
	desc = "An armored labcoat with the ability to change how it looks into any standard Nanotrasen issue labcoat."
	item = /obj/item/clothing/suit/labcoat/chameleon
	cost = 2
	jobs = list("Chemist", "Medical Doctor", "Chief Medical Officer", "Geneticist", "Virologist", "Research Director", "Scientist", "Roboticist") //all the labcoat jobs

//MEDICAL
/datum/uplink_item/job_specific/voodoo
	name = "Voodoo Doll"
	desc = "An artifact provided by the Wizard Federation, it allows you to attach any item to it and manipulate anyone who has ever touched said item, be it from moving them around, making them say stuff and stabbing them with objects. The Wizard Federation has notified us that the victim will be made alert of the user's general location if used too aggresively."
	item = /obj/item/weapon/storage/box/syndie_kit/voodoo
	cost = 4
	jobs = list("Chemist", "Medical Doctor", "Chief Medical Officer", "Geneticist", "Virologist")

//SERVICE DIVISION

/datum/uplink_item/job_specific/chainsaw
	name = "Chainsaw"
	desc = "An extremely loud, dirty, noisy, bulky, powerful as hell chainsaw that will absolutely destroy anyone it comes in contact with. Obviously won't fit in your backpack."
	item = /obj/item/weapon/twohanded/chainsaw
	cost = 14
	jobs = list("Botanist", "Bartender", "Chef")

//CIVILIAN DIVISION
/datum/uplink_item/job_specific/spiritcam
	name = "Spirit Camera"
	desc = "This special camera allows you to take long-distance photographs of any living person provided you know their name."
	item = /obj/item/device/camera/spiritcam
	cost = 1
	jobs = list("Librarian", "Assistant", "Clown", "Mime", "Lawyer", "Chaplain")

//LIBRARIAN
/datum/uplink_item/job_specific/soulstone
	name = "Soulstone"
	desc = "This stone will be able to capture your victim's soul and bind them to your will."
	item = /obj/item/device/soulstone/anybody
	cost = 4 //nerfed the cost on Chronitonity's request
	jobs = list("Librarian")

//CHAPLAIN
/datum/uplink_item/job_specific/skelestone
	name = "Skelestone"
	desc = "Make a skeleton minion! Has one use."
	item = /obj/item/device/necromantic_stone/oneuse
	cost = 7
	jobs = list("Chaplain")

/datum/uplink_item/job_specific/holyarmor
	name = "Holy Armor"
	desc = "A set of blessed Holy Armor that shoots out lightning whenever you're attacked."
	item = /obj/item/clothing/suit/armor/riot/knight/templar/holy
	cost = 10
	jobs = list("Chaplain")

//BARTENDER
/datum/uplink_item/job_specific/shotgunammo
	name = "Shotgun ammo kit"
	desc = "An assortment of various syndicate approved shotgun shells."
	item = /obj/item/weapon/storage/box/syndie_kit/shotguntender
	cost = 2
	jobs = list("Bartender")

//ENTERTAINERS
/datum/uplink_item/job_specific/tricksyndicatecards
	name = "Trick Syndicate Playing Cards"
	desc = "A special deck of space-grade playing cards used by syndicate entertainers to awe the crowd. The cards have been altered in some way to produce random certain effects when thrown at someone."
	item = /obj/item/weapon/trickcards/trickdeck
	cost = 12
	jobs = list("Clown","Mime","Bartender","Librarian")

//CLOWN + MIME
/datum/uplink_item/job_specific/caneshotgun
	name = "Cane Shotgun + Assassination Darts"
	desc = "A specialized, one shell shotgun with a built-in cloaking device to mimic a cane. The shotgun is capable of hiding it's contents and the pin alongside being supressed. Comes with 6 special darts and a preloaded shrapnel round."
	item = /obj/item/weapon/storage/box/syndie_kit/caneshotgun
	cost = 10
	jobs = list("Clown","Mime")

//CLOWN
/datum/uplink_item/job_specific/honkrender
	name = "Honk Render"
	desc = "A blade capable of tearing apart the fabric of reality and summoning several clowns from the Clown Planet itself. They're mostly passive, until someone hits one of them, after which they enter a frenzy, attacking any and all in a collective group effort. The blade itself is also useful as a slashing weapon."
	item = /obj/item/weapon/veilrender/honkrender
	cost = 6
	jobs = list("Clown")

//King of the Disk items

/datum/uplink_item/king_disk
	category = "King of the Disk items"
	gamemodes = list(/datum/game_mode/traitor/king_disk)

/datum/uplink_item/king_disk/pinpointer
	name = "Spare Pinpointer"
	desc = "In case you lose your pinpointer, the Syndicate are willing to provide a spare...for a price."
	item = /obj/item/weapon/pinpointer
	cost = 2


//equipment room access

/datum/uplink_item/equipaccess
	category = "Equipment room access"
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/equipaccess/blastco
	name = "Blast Co access"
	desc = "This ID card will let you access the Blast Co equipment room. Inside is enough gear to fully equip a team with explosive based weaponry."
	item = /obj/item/weapon/card/id/syndicate_blastco
	cost = 200
	gamemodes = list(/datum/game_mode/nuclear)

//Operator special offers

/datum/uplink_item/specoffer
	category = "Special offer roles"
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/specoffer/c20r
	name = "C20r bundle"
	desc = "The classic C20r, with two magazines, at discount price. Contains free surplus suppressor."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/c20rbundle
	cost = 14//normal price 16
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/specoffer/c90gl
	name = "C90gl bundle"
	desc = "Premium offer. Pick up the C90gl with a magazine, some grenades, and a pack of cigarettes for a premium discount."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/c90glbundle
	cost = 15//normal price 18
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/specoffer/bulldog
	name = "Bulldog bundle"
	desc = "Optimised for people that want to get up close and personal. Contains the popular Bulldog shotgun, a two drums of ammunition, and an elite hardsuit."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/bulldogbundle
	cost = 16//normal price 20 THATS TWO FREE DRUMS
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/specoffer/medical
	name = "Medical bundle"
	desc = "Support your fellow operatives with this medical bundle. Contains a Donksoft machine gun, a box of ammo, a pair of magboots and a medical beam gun to rescue your friends in no-gravity environments."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/med/medicalbundle
	cost = 14
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/specoffer/sniper
	name = "Sniper bundle"
	desc = "Contains a collapsed sniper rifle in an expensive carrying case, a high explosive magazine, a soporific knockout magazine, a penetrator magazine, a free surplus supressor, and a worn out suit and tie."
	item = /obj/item/weapon/storage/briefcase/sniperbundle
	cost = 22 //29 normal cost. suppressor is excluded from price.
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/specoffer/chemical
	name = "Tiger Corperation Chemical Bioterror bundle"
	desc = "Contains Bioterror spray, Bioterror grenade, chemicals, syringe gun, box of syringes, Donksoft assault rifle, and some darts. Warning: Seal suit and equip internals before use."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/med/bioterrorbundle
	cost = 26 //normal price 42 biggest saving here
	gamemodes = list(/datum/game_mode/nuclear)

// DANGEROUS WEAPONS

/datum/uplink_item/dangerous
	category = "Conspicuous and Dangerous Weapons"

/datum/uplink_item/dangerous/pistol
	name = "Syndicate Pistol"
	desc = "A small, easily concealable handgun that uses 10mm auto rounds in 8-round magazines and is compatible with suppressors."
	item = /obj/item/weapon/gun/projectile/automatic/pistol
	cost = 8
	surplus = 15

/datum/uplink_item/dangerous/g17
	name = "Glock 17 Handgun"
	desc = "A simple yet popular handgun chambered in 9mm. Made out of strong but lightweight polymer. The standard magazine can hold up to 14 9mm cartridges. Compatible with a universal suppressor."
	item = /obj/item/weapon/gun/projectile/automatic/pistol/g17
	cost = 10
	surplus = 15

/datum/uplink_item/dangerous/revolver
	name = "Syndicate Revolver"
	desc = "A brutally simple syndicate revolver that fires .357 Magnum cartridges and has 7 chambers."
	item = /obj/item/weapon/gun/projectile/revolver
	cost = 13
	surplus = 50
	excludefrom = list(/datum/game_mode/traitor/king_disk)

/datum/uplink_item/dangerous/contender
	name = "Syndicate Contender"
	desc = "A syndicate version of the latest G13 Contender. The bluespace barrel means it can fire any ammo, but only 1 chamber"
	item = /obj/item/weapon/gun/projectile/revolver/doublebarrel/contender/syndie
	cost = 6
	surplus = 15

/datum/uplink_item/dangerous/smg
	name = "C-20r Submachine Gun"
	desc = "A fully-loaded Scarborough Arms bullpup submachine gun that fires .45 rounds with a 20-round magazine and is compatible with suppressors."
	item = /obj/item/weapon/gun/projectile/automatic/c20r
	cost = 10
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 40

/datum/uplink_item/dangerous/smg/unrestricted
	item = /obj/item/weapon/gun/projectile/automatic/c20r/unrestricted
	gamemodes = list(/datum/game_mode/gang)

/datum/uplink_item/dangerous/carbine
	name = "C-90GL Carbine"
	desc = "A fully-loaded three-round burst carbine that uses 30-round 5.56mm magazines with an underslung 40mm grenade launcher."
	item = /obj/item/weapon/gun/projectile/automatic/c90
	cost = 12
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 50

/*
/datum/uplink_item/dangerous/ak922
	name = "AK-922 Assault Rifle"
	desc = "A standard issue New Russia assault rifle praised for being able to survive common issues in the field, including but not limited to: explosions, laser beams, toolboxes, and clowns. Chambered in the 7.62x39mm cartridge."
	item = /obj/item/weapon/gun/projectile/automatic/ak922
	cost = 16		//Cheaper than the C-90 because it has no grenade launcher, but is otherwise identical, excluding icons and the like.
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 50
*/

/datum/uplink_item/dangerous/ak922gold
	name = "Gold-Plated AK-922 Assault Rifle"
	desc = "An AK-922 with gold-plating. Now you can kill innocent workers of a hated company with efficiency AND style!"
	item = /obj/item/weapon/gun/projectile/automatic/ak922/gold
	cost = 13
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 50

/datum/uplink_item/dangerous/carbine/unrestricted
	item = /obj/item/weapon/gun/projectile/automatic/c90/unrestricted
	gamemodes = list(/datum/game_mode/gang)

/datum/uplink_item/dangerous/machinegun
	name = "L6 Squad Automatic Weapon"
	desc = "A fully-loaded Aussec Armory belt-fed machine gun. This deadly weapon has a massive 50-round magazine of devastating 7.62x51mm ammunition."
	item = /obj/item/weapon/gun/projectile/automatic/l6_saw
	cost = 22 // no one buys this thing
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/bulldogshotgun
	name = "Bulldog Shotgun"
	desc = "A semi-auto shotgun that can hold 8 rounds in each magazine. Specialized for tight corriders."
	item = /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
	cost = 8
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/machineshotgun
	name = "Abzats Shotgun Machinegun"
	desc = "A fully-loaded Aussec Armoury belt-fed machine gun. This deadly weapon has a massive 40-round box magazine of 12 gauge buckshot cartridges."
	item = /obj/item/weapon/gun/projectile/automatic/shotgun/abzats
	cost = 27
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/mgl
	name = "Strider MGL"
	desc = "An Aussec Armory-produced Multi-Grenade-Launcher. Can hold six 40mm grenades for maximum firepower."
	item = /obj/item/weapon/gun/projectile/revolver/grenadelauncher/mgl
	cost = 25
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/crossbow
	name = "Miniature Energy Crossbow"
	desc = "A short bow mounted across a tiller in miniature. Small enough to fit into a pocket or slip into a bag unnoticed. It will synthesize and fire bolts tipped with a paralyzing toxin that will \
	briefly stun targets and cause them to slur as if inebriated. It can produce an infinite amount of bolts, but must be manually recharged with each shot."
	item = /obj/item/weapon/gun/energy/kinetic_accelerator/crossbow
	cost = 12
	excludefrom = list(/datum/game_mode/gang,/datum/game_mode/traitor/king_disk)
	surplus = 50

/datum/uplink_item/dangerous/flamethrower
	name = "Flamethrower"
	desc = "A flamethrower, fueled by a portion of highly flammable biotoxins stolen previously from Nanotrasen stations. Make a statement by roasting the filth in their own greed. Use with caution."
	item = /obj/item/weapon/flamethrower/full/tank
	cost = 2
	gamemodes = list(/datum/game_mode/nuclear,/datum/game_mode/gang)
	surplus = 40

/datum/uplink_item/dangerous/knife
	name = "Combat Knife"
	desc = "A military knife that has decent force and huge embedding chance when thrown. Can be considered stealthy."
	item = /obj/item/weapon/melee/combatknife
	cost = 2

/datum/uplink_item/dangerous/sword
	name = "Energy Sword"
	desc = "The energy sword is an edged weapon with a blade of pure energy. The sword is small enough to be pocketed when inactive. Activating it produces a loud, distinctive noise. One can combine two \
	energy swords to create a double energy sword, which must be wielded in two hands but is more robust and deflects all energy projectiles."
	item = /obj/item/weapon/melee/energy/sword/saber
	cost = 8

/datum/uplink_item/dangerous/powerfist
	name = "Power Fist"
	desc = "A large mechanically powered fist made out of plasteel which can deliver a massive blow to any target with the ability to throw them across a room. The power fist needs approximately a second in between each punch before it is powered again."
	item = /obj/item/weapon/melee/powerfist
	cost = 10

/datum/uplink_item/dangerous/emp
	name = "EMP Kit"
	desc = "A box that contains two EMP grenades, an EMP implant and a short ranged recharging device disguised as a flashlight. Useful to disrupt communication and silicon lifeforms."
	item = /obj/item/weapon/storage/box/syndie_kit/emp
	cost = 5

/datum/uplink_item/dangerous/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "The minibomb is a grenade with a five-second fuse. Upon detonation, it will create a small hull breach in addition to dealing high amounts of damage to nearby personnel."
	item = /obj/item/weapon/grenade/syndieminibomb
	cost = 4

/datum/uplink_item/dangerous/cat_grenade
	name = "Feral Cat Delivery Grenade"
	desc = "The feral cat delivery grenade contains 8 dehydrated feral cats in a similar manner to dehydrated monkeys, which, upon detonation, will be rehydrated by a small reservoir of water contained within the grenade. These cats will then attack anything in sight."
	item = /obj/item/weapon/grenade/spawnergrenade/feral_cats
	cost = 5

/datum/uplink_item/dangerous/foamsmg
	name = "Toy Submachine Gun"
	desc = "A fully-loaded Donksoft bullpup submachine gun that fires riot grade rounds with a 20-round magazine."
	item = /obj/item/weapon/gun/projectile/automatic/c20r/toy
	cost = 4

/datum/uplink_item/dangerous/foammachinegun
	name = "Toy Machine Gun"
	desc = "A fully-loaded Donksoft belt-fed machine gun. This weapon has a massive 50-round magazine of devastating riot grade darts, that can briefly incapacitate someone in just one volley."
	item = /obj/item/weapon/gun/projectile/automatic/l6_saw/toy
	cost = 7

/datum/uplink_item/dangerous/viscerators
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerators upon activation, which will chase down and shred any non-operatives in the area."
	item = /obj/item/weapon/grenade/spawnergrenade/manhacks
	cost = 6
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 35

/datum/uplink_item/dangerous/bioterrorfoam
	name = "Crowd control chemical foam grenade"
	desc = "A powerful chemical foam grenade which creates a deadly torrent of foam that will mute, blind, confuse, mutate, and irritate carbon lifeforms. Specially brewed by Tiger Cooperative chemical weapons specialists using additional spore toxin. Ensure suit is sealed before use."
	item = /obj/item/weapon/grenade/chem_grenade/bioterrorfoam
	cost = 3
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 35

/datum/uplink_item/dangerous/bioterror
	name = "Biohazardous Chemical Sprayer"
	desc = "A chemical sprayer that allows a wide dispersal of selected chemicals. Especially tailored by the Tiger Cooperative, the deadly blend it comes stocked with will disorient, damage, and disable your foes... \
	Use with extreme caution, to prevent exposure to yourself and your fellow operatives."
	item = /obj/item/weapon/reagent_containers/spray/chemsprayer/bioterror
	cost = 14
	gamemodes = list(/datum/game_mode/nuclear,/datum/game_mode/gang)
	surplus = 0

/datum/uplink_item/dangerous/gygax
	name = "Gygax Exosuit"
	desc = "A lightweight exosuit, painted in a dark scheme. Its speed and equipment selection make it excellent for hit-and-run style attacks. \
	This model lacks a method of space propulsion, and therefore it is advised to repair the mothership's teleporter if you wish to make use of it."
	item = /obj/mecha/combat/gygax/dark/loaded
	cost = 60
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/mauler
	name = "Mauler Exosuit"
	desc = "A massive and incredibly deadly Syndicate exosuit. Features long-range targetting, thrust vectoring, and deployable smoke."
	item = /obj/mecha/combat/marauder/mauler/loaded
	cost = 120
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/cqc_gloves
	name = "Tactical Gloves"
	desc = "Comfortable grey gloves with the CQC martial art inside."
	item = /obj/item/clothing/gloves/cqc
	cost = 4

/datum/uplink_item/dangerous/wrestling
	name = "Wrestling Belt"
	desc = "A powerful wrestling moveset given to you via championship belt."
	item = /obj/item/weapon/storage/belt/champion/wrestling
	cost = 4

/datum/uplink_item/dangerous/reinforcement
	name = "Reinforcements"
	desc = "Call in an additional team member. They come with predefined gear sets, but you might want to save some telecrystals to arm them better."
	item = /obj/item/weapon/antag_spawner/nuke_ops
	cost = 25
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/reinforcement/syndieborg
	name = "Syndicate Cyborg"
	desc = "A cyborg designed and programmed for systematic extermination of non-Syndicate personnel."
	item = /obj/item/weapon/antag_spawner/nuke_ops/borg_tele
	cost = 50
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an organic host as a home base and source of fuel."
	item = /obj/item/weapon/storage/box/syndie_kit/guardian
	excludefrom = list(/datum/game_mode/nuclear,/datum/game_mode/gang)
	cost = 20

/datum/uplink_item/dangerous/hockey
	name = "Ka-Nada Boxed S.S.F Hockey Set"
	desc = "The iconic extreme environment gear used by Ka-Nada special sport forces. Used to devastating effect during the great northern sports wars of the second great athletic republic. The unmistakable grey and red gear provides great protection from most if not all environmental hazards and combat threats in addition to coming with the signature weapon of the Ka-Nada SSF and all terrain Hyper-Blades for enhanced mobility and lethality in melee combat. This power comes at a cost as your Ka-Nada benefactors expect absolute devotion to the cause, once equipped you will be unable to remove the gear so be sure to make it count."
	item = /obj/item/weapon/storage/box/syndie_kit/hockeyset
	excludefrom = list(/datum/game_mode/nuclear,/datum/game_mode/gang)
	cost = 20

/datum/uplink_item/dangerous/sniper
	name = "Sniper Rifle"
	desc = "Ranged fury, syndicate style. Features a scope for precision fire."
	item = /obj/item/weapon/gun/projectile/sniper_rifle
	cost = 14
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 25

// AMMUNITION

/datum/uplink_item/ammo
	category = "Ammunition"
	surplus = 40

/datum/uplink_item/ammo/pistol
	name = "Handgun Magazine - 10mm"
	desc = "An additional 8-round 10mm magazine for use in the syndicate pistol. These subsonic rounds are dirt cheap but are half as effective as .357 rounds."
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 1

/datum/uplink_item/ammo/g17
	name = "Handgun Magazine - 9mm"
	desc = "A spare fully-loaded magazine for use in the Glock 17 handgun. Holds up to 14 9mm cartridges."
	item = /obj/item/ammo_box/magazine/g17
	cost = 1

/datum/uplink_item/ammo/revolver
	name = "Speed Loader - .357"
	desc = "A speed loader that contains seven additional .357 Magnum rounds for the syndicate revolver. For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	cost = 2
	excludefrom = list(/datum/game_mode/traitor/king_disk)

/datum/uplink_item/ammo/smg
	name = "SMG Magazine - .45 ACP"
	desc = "An additional 20-round .45 ACP magazine for use in the C-20r submachine gun. These bullets pack a lot of punch that can knock most targets down, but do limited overall damage."
	item = /obj/item/ammo_box/magazine/smgm45
	cost = 3

/datum/uplink_item/ammo/smgammo
	name = "Ammo Duffelbag - C20r Ammo Grab Bag"
	desc = "A duffelbag filled with C20r to kit out an entire team, at a discounted price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/smg
	cost = 20 //get about 2 mags for free this shit is imba as fuck Normal price 27
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/ammobag
	name = "Ammo Duffelbag - Shotgun Ammo Grab Bag"
	desc = "A duffelbag filled with Bulldog ammo to kit out an entire team, at a discounted price."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/loaded
	cost = 12 //bulk buyer's discount. Very useful if you're buying a mech and dont have TC left to buy people non-shotgun guns
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/bullslug
	name = "Drum Magazine - 12g Slugs"
	desc = "An additional 8-round slug magazine for use in the Bulldog shotgun. Now 8 times less likely to shoot your pals."
	item = /obj/item/ammo_box/magazine/m12g
	cost = 2

/datum/uplink_item/ammo/bullbuck
	name = "Drum Magazine - 12g Buckshot"
	desc = "An additional 8-round buckshot magazine for use in the Bulldog shotgun. Front towards enemy."
	item = /obj/item/ammo_box/magazine/m12g/buckshot
	cost = 2

/datum/uplink_item/ammo/bullstun
	name = "Drum Magazine - 12g Stun Slug"
	desc = "An alternative 8-round stun slug magazine for use in the Bulldog shotgun. Saying that they're completely non-lethal would be lying."
	item = /obj/item/ammo_box/magazine/m12g/stun
	cost = 2

/datum/uplink_item/ammo/bulldragon
	name = "Drum Magazine - 12g Dragon's Breath"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. I'm a fire starter, twisted fire starter!"
	item = /obj/item/ammo_box/magazine/m12g/dragon
	cost = 2

/datum/uplink_item/ammo/box12gbuckshot2 //you couldn't buy this because it had the same name as the box mag, good job whoever coded this
	name = "40rnd ammo box - 12g Buckshot"
	desc = "A box of 40 rounds of buckshot ammo, intended for reloading of the Abzats' box magazine."
	item = /obj/item/ammo_box/box12gbuckshot
	cost = 6

/datum/uplink_item/ammo/box12gbuckshot
	name = "Abzats Spare Ammo Box - Buckshot"
	desc = "An ammo box designed for use with the Abzats machine shotgun. Holds up to forty 12 gauge shotgun shells."
	item = /obj/item/ammo_box/magazine/mbox12g
	cost = 7

/datum/uplink_item/ammo/box12gdragon
	name = "40rnd ammo box - 12g Dragon's breath"
	desc = "A box of 40 rounds of dragon's breath ammo, intended for reloading of the Abzats' box magazine."
	item = /obj/item/ammo_box/box12gdragon
	cost = 8

/datum/uplink_item/ammo/bioterror
	name = "Box of Bioterror Syringes"
	desc = "A box full of preloaded syringes, containing various chemicals that seize up the victim's motor and broca systems, making it impossible for them to move or speak for some time."
	item = /obj/item/weapon/storage/box/syndie_kit/bioterror
	cost = 4

/datum/uplink_item/ammo/carbine
	name = "Toploader Magazine - 5.56"
	desc = "An additional 30-round 5.56 magazine for use in the C-90gl carbine. These bullets don't have the punch to knock most targets down, but dish out higher overall damage."
	item = /obj/item/ammo_box/magazine/m556
	cost = 4

/datum/uplink_item/ammo/ak922
	name = "Box Magazine - 7.62x39mm"
	desc = "An additional 30-round 7.62x39mm magazine for the AK-922 battle rifle. While they don't hit as hard as other projectiles, they have higher velocity and penetrating power."
	item = /obj/item/ammo_box/magazine/ak922
	cost = 3

/datum/uplink_item/ammo/a40mm
	name = "Ammo Box - 40mm HE grenades"
	desc = "A box of 6 additional 40mm HE grenades for use with the C90's grenade launcher or the Strider MGL. Your teammates will thank you to not shoot these down tight corridors."
	item = /obj/item/ammo_box/a40mm
	cost = 5

/datum/uplink_item/ammo/fireteam
	name = "Ammo Duffelbag - Fireteam Ammo Grab Bag"
	desc = "A duffelbag filled with ammo to kit out a fireteam, contains four C20r magazines, two c90gl magazines, a box of 40mm grenades, and sniper ammunition at a discounted price." //C90gl ammo bag is too imba. fuck that.
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/fireteam
	cost = 24 //you get 4 grenades for free. Normal price 29
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun
	name = "Box Magazine - 7.62x51mm"
	desc = "A 50-round magazine of 7.62x51mm ammunition for use in the L6 SAW machinegun. By the time you need to use this, you'll already be on a pile of corpses."
	item = /obj/item/ammo_box/magazine/m762
	cost = 5

/datum/uplink_item/ammo/toydarts //This used to only be for nuke ops, but had the cost lowered and made available to traitors because >a box of foam darts is more expensive than four carbine magazines
	name = "Box of Riot Darts"
	desc = "A box of 40 Donksoft foam riot darts, for reloading any compatible foam dart gun. Don't forget to share!"
	item = /obj/item/ammo_box/foambox/riot
	cost = 2

/datum/uplink_item/ammo/sniper
	name = "Sniper Magazine - .50"
	desc = "An additional 5-round .50 magazine for use in the syndicate sniper rifle."
	item = /obj/item/ammo_box/magazine/sniper_rounds
	cost = 5 //70dmg rounds are no joke

/datum/uplink_item/ammo/sniper/soporific
	name = "Sniper Magazine - Soporific Rounds"
	desc = "A 5-round magazine of soporific ammo designed for use in the syndicate sniper rifle, put your enemies to sleep today!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/soporific
	cost = 3 //Why are sleep rounds more expensive than standard rounds, especially if it only comes with half the ammo?

/datum/uplink_item/ammo/sniper/he
	name = "Sniper Magazine - Explosive Rounds"
	desc = "A 5-round magazine of high-explosive ammo designed for use in the syndicate sniper rifle, causes a small explosion on impact."
	item = /obj/item/ammo_box/magazine/sniper_rounds/he
	cost = 6

/datum/uplink_item/ammo/sniper/penetrator
	name = "Sniper Magazine - Penetrator Rounds"
	desc = "A 5-round magazine of penetrator ammo designed for use in the syndicate sniper rifle. Can pierce walls and multiple enemies."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator
	cost = 6

// STEALTHY WEAPONS

/datum/uplink_item/stealthy_weapons
	category = "Stealthy and Inconspicuous Weapons"


/datum/uplink_item/stealthy_weapons/throwingstars
	name = "Box of Throwing Stars"
	desc = "A box of shurikens from ancient Earth martial arts. They are highly effective throwing weapons, and will embed into limbs when possible."
	item = /obj/item/weapon/storage/box/throwing_stars
	cost = 4
	excludefrom = list(/datum/game_mode/nuclear)

/datum/uplink_item/stealthy_weapons/edagger
	name = "Energy Dagger"
	desc = "A dagger made of energy that looks and functions as a pen when off."
	item = /obj/item/weapon/pen/edagger
	cost = 2

/datum/uplink_item/stealthy_weapons/foampistol
	name = "Toy Gun with Riot Darts"
	desc = "An innocent-looking toy pistol designed to fire foam darts. Comes loaded with riot-grade darts effective at incapacitating a target."
	item = /obj/item/weapon/gun/projectile/automatic/toy/pistol/riot
	cost = 2
	surplus = 10
	excludefrom = list(/datum/game_mode/gang)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen, filled with a potent mix of drugs, including a strong anesthetic and a chemical that prevents the target from speaking. \
	The pen holds one dose of the mixture, and cannot be refilled. Note that before the target falls asleep, they will be able to move and act."
	item = /obj/item/weapon/pen/sleepy
	cost = 2
	excludefrom = list(/datum/game_mode/nuclear,/datum/game_mode/gang)

/datum/uplink_item/stealthy_weapons/soap
	name = "Syndicate Soap"
	desc = "A sinister-looking surfactant used to clean blood stains to hide murders and prevent DNA analysis. You can also drop it underfoot to slip people."
	item = /obj/item/weapon/soap/syndie
	cost = 1
	surplus = 50

/datum/uplink_item/stealthy_weapons/traitor_chem_bottle
	name = "Poison Kit"
	desc = "An assortment of deadly chemicals packed into a compact box. Comes with a syringe for more precise application."
	item = /obj/item/weapon/storage/box/syndie_kit/chemical
	cost = 4
	surplus = 50

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Dart Pistol"
	desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any space a small item can."
	item = /obj/item/weapon/gun/syringe/syndicate
	cost = 4
	surplus = 50 //High chance of surplus due to poison kit also having a high chance

/datum/uplink_item/stealthy_weapons/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you four opportunities to detonate PDAs of crewmembers who have their message feature enabled. \
	The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer. It has a chance to detonate your PDA."
	item = /obj/item/weapon/cartridge/syndicate
	cost = 2

/datum/uplink_item/stealthy_weapons/suppressor
	name = "Universal Suppressor"
	desc = "Fitted for use on any small caliber weapon with a threaded barrel, this suppressor will silence the shots of the weapon for increased stealth and superior ambushing capability."
	item = /obj/item/weapon/suppressor
	cost = 2
	surplus = 10

/datum/uplink_item/stealthy_weapons/pizza_bomb
	name = "Pizza Bomb"
	desc = "A pizza box with a bomb taped inside it. The timer needs to be set by opening the box; afterwards, opening the box again will trigger the detonation."
	item = /obj/item/device/pizza_bomb
	cost = 3
	surplus = 8

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "Dehydrated Space Carp"
	desc = "Looks like a plush toy carp, but just add water and it becomes a real-life space carp! Activate before use."
	item = /obj/item/toy/carpplushie/dehy_carp
	cost = 2

/datum/uplink_item/stealthy_weapons/trick_pin
	name = "Trick firing pin"
	desc = "A firing pin that will cause the gun it is put into to explode the next time it is used. Slot it into any firearm to set it up."
	item = /obj/item/device/firing_pin/trick
	cost = 2

/datum/uplink_item/stealthy_weapons/door_charge
	name = "Explosive Airlock Charge"
	desc = "A small, easily concealable device. It can be applied to an open airlock panel, and the next person to open that airlock will be knocked down in an explosion. The airlock's maintenance panel will also be destroyed by this."
	item = /obj/item/device/doorCharge
	cost = 1
	surplus = 10
	excludefrom = list(/datum/game_mode/nuclear)

// STEALTHY TOOLS

/datum/uplink_item/stealthy_tools
	category = "Stealth and Camouflage Items"

/datum/uplink_item/stealthy_tools/chameleon_jumpsuit
	name = "Chameleon Jumpsuit"
	desc = "A jumpsuit used to imitate the uniforms of Nanotrasen crewmembers. It can change form at any time to resemble another jumpsuit. May react unpredictably to electromagnetic disruptions."
	item = /obj/item/clothing/under/chameleon
	cost = 2

/datum/uplink_item/stealthy_tools/chameleon_stamp
	name = "Chameleon Stamp"
	desc = "A stamp that can be activated to imitate an official Nanotrasen Stamp. The disguised stamp will work exactly like the real stamp and will allow you to forge false documents to gain access or equipment; \
	it can also be used in a washing machine to forge clothing."
	item = /obj/item/weapon/stamp/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Brown Shoes"
	desc = "These shoes will allow the wearer to run on wet floors and slippery objects without falling down. They do not work on heavily lubricated surfaces."
	item = /obj/item/clothing/shoes/sneakers/syndigaloshes
	cost = 2

/datum/uplink_item/stealthy_tools/agent_card
	name = "Agent Identification Card"
	desc = "Agent cards prevent artificial intelligences from tracking the wearer, and can copy access from other identification cards. The access is cumulative, so scanning one card does not erase the access gained from another. \
	In addition, they can be forged to display a new assignment and name. This can be done an unlimited amount of times. Some Syndicate areas can only be accessed with these cards."
	item = /obj/item/weapon/card/id/syndicate
	cost = 2

/datum/uplink_item/stealthy_tools/pickpocket_gloves
	name = "Pickpocket Gloves"
	desc = "Gloves that allow you to quickly and stealthily remove items from people and puts them straight into your hands."
	item = /obj/item/clothing/gloves/pickpocket
	cost = 2

/datum/uplink_item/stealthy_tools/voice_changer
	name = "Voice Changer"
	item = /obj/item/clothing/mask/gas/voice
	desc = "A conspicuous gas mask that mimics the voice named on your identification card. It can be toggled on and off."
	cost = 2

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Chameleon Projector"
	desc = "Projects an image across a user, disguising them as an object scanned with it, as long as they don't move the projector from their hand. Disguised users move slowly, and projectiles pass over them."
	item = /obj/item/device/chameleon
	cost = 6
	excludefrom = list(/datum/game_mode/gang)

/datum/uplink_item/stealthy_tools/camera_bug
	name = "Camera Bug"
	desc = "Enables you to view all cameras on the network and track a target. Bugging cameras allows you to disable them remotely."
	item = /obj/item/device/camera_bug
	cost = 1
	surplus = 90

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Smuggler's Satchel"
	desc = "This satchel is thin enough to be hidden in the gap between plating and tiling; great for stashing your stolen goods. Comes with a crowbar and a floor tile inside."
	item = /obj/item/weapon/storage/backpack/satchel_flat
	cost = 1
	surplus = 30

/datum/uplink_item/stealthy_tools/stimpack
	name = "Stimpack"
	desc = "Stimpacks, the tool of many great heroes, make you faster and immune to slowdown for about 5 minutes after injection."
	item = /obj/item/weapon/reagent_containers/syringe/stimulants
	cost = 5
	surplus = 90

/datum/uplink_item/stealthy_tools/mulligan
	name = "Randomizer"
	desc = "Screwed up and have security on your tail? Looks got you feeling down? This handy syringe will give you a completely new identity and appearance."
	item = /obj/item/weapon/reagent_containers/syringe/mulligan
	cost = 1
	excludefrom = list(/datum/game_mode/nuclear,/datum/game_mode/gang)

// DEVICE AND TOOLS

/datum/uplink_item/device_tools
	category = "Devices and Tools"

/datum/uplink_item/device_tools/emag
	name = "Cryptographic Sequencer"
	desc = "The cryptographic sequencer, or emag, is a small card that unlocks hidden functions in electronic devices, subverts intended functions, and characteristically breaks security mechanisms."
	item = /obj/item/weapon/card/emag
	cost = 6
	excludefrom = list(/datum/game_mode/gang,/datum/game_mode/traitor/king_disk)

/datum/uplink_item/device_tools/emag/king_disk
	name = "Cryptographic Sequencer - KotD"
	excludefrom = list()
	gamemodes = list(/datum/game_mode/traitor/king_disk)
	cost = 8

/datum/uplink_item/device_tools/toolbox
	name = "Full Syndicate Toolbox"
	desc = "The syndicate toolbox is a suspicious black and red. It comes loaded with a full tool set including a multitool and combat gloves that are resistant to shocks and heat."
	item = /obj/item/weapon/storage/toolbox/syndicate
	cost = 1

/datum/uplink_item/device_tools/surgerybag
	name = "Syndicate Surgery Dufflebag"
	desc = "The Syndicate surgery dufflebag is a toolkit containing all surgery tools, surgical drapes, a Syndicate brand MMI, a straitjacket, and a muzzle."
	item = /obj/item/weapon/storage/backpack/dufflebag/syndie/surgery
	cost = 3

/datum/uplink_item/device_tools/military_belt
	name = "Military Belt"
	desc = "A robust seven-slot red belt that is capable of holding all items that can fit into it."
	item = /obj/item/weapon/storage/belt/military
	cost = 1
	excludefrom = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/medkit
	name = "Syndicate Combat Medic Kit"
	desc = "This first aid kit is a suspicious brown and red. Included is a combat stimulant injector for rapid healing, a medical HUD for quick identification of injured personnel, \
	and other supplies helpful for a field medic."
	item = /obj/item/weapon/storage/firstaid/tactical
	cost = 6

/datum/uplink_item/device_tools/space_suit
	name = "Syndicate Space Suit"
	desc = "The red and black syndicate space suit is less encumbering than Nanotrasen variants, fits inside bags, and has a weapon slot. Nanotrasen crewmembers are trained to report red space suit sightings."
	item = /obj/item/weapon/storage/box/syndie_kit/space
	cost = 2
	excludefrom = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/hardsuit
	name = "Blood-Red Hardsuit"
	desc = "The feared suit of a syndicate nuclear agent. Features slightly better armoring and a built in jetpack that runs off standard atmospheric tanks. \
	When the built in helmet is deployed your identity will be protected, even in death, as the suit cannot be removed by outside forces. Toggling the suit into combat mode \
	will allow you all the mobility of a loose fitting uniform without sacrificing armoring. Additionally the suit is collapsible, small enough to fit within a backpack. \
	Nanotrasen crewmembers are trained to report red space suit sightings; these suits in particular are known to drive employees into a panic."
	item = /obj/item/clothing/suit/space/hardsuit/syndi
	cost = 6
	excludefrom = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/elite_hardsuit
	name = "Elite Syndicate Hardsuit"
	desc = "The elite Syndicate hardsuit is worn by only the best nuclear agents. Features much better armoring and complete fireproofing, as well as a built in jetpack. \
	When the built in helmet is deployed your identity will be protected, even in death, as the suit cannot be removed by outside forces. Toggling the suit into combat mode \
	will allow you all the mobility of a loose fitting uniform without sacrificing armoring. Additionally the suit is collapsible, small enough to fit within a backpack. \
	Nanotrasen crewmembers are trained to report red space suit sightings; these suits in particular are known to drive employees into a panic."
	item = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	cost = 10
	gamemodes = list(/datum/game_mode/nuclear)
	excludefrom = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/thermal
	name = "Thermal Imaging Glasses"
	desc = "These goggles can be turned to resemble common eyewears throughout the station. \
	They allow you to see organisms through walls by capturing the upper portion of the infrared light spectrum, emitted as heat and light by objects. \
	Hotter objects, such as warm bodies, cybernetic organisms and artificial intelligence cores emit more of this light than cooler objects like walls and airlocks." //THEN WHY CANT THEY SEE PLASMA FIRES????
	item = /obj/item/clothing/glasses/thermal/syndi
	cost = 6

/datum/uplink_item/device_tools/binary
	name = "Binary Translator Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to and talk with silicon-based lifeforms, such as AI units and cyborgs, over their private binary channel. Caution should \
	be taken while doing this, as unless they are allied with you, they are programmed to report such intrusions."
	item = /obj/item/device/encryptionkey/binary
	cost = 2
	surplus = 75

/datum/uplink_item/device_tools/encryptionkey
	name = "Syndicate Encryption Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to all station department channels as well as talk on an encrypted Syndicate channel with other agents that have the same \
	key. Use :t to utilize syndicate chat."
	item = /obj/item/device/encryptionkey/syndicate
	cost = 1 //Nowhere near as useful as the Binary Key!
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
	cost = 10

/datum/uplink_item/device_tools/magboots
	name = "Blood-Red Magboots"
	desc = "A pair of magnetic boots with a Syndicate paintjob that assist with freer movement in space or on-station during gravitational generator failures. \
	These reverse-engineered knockoffs of Nanotrasen's 'Advanced Magboots' slow you down in simulated-gravity environments much like the standard issue variety."
	item = /obj/item/clothing/shoes/magboots/syndie
	cost = 2
	gamemodes = list(/datum/game_mode/nuclear)

/datum/uplink_item/device_tools/c4
	name = "Composition C-4"
	desc = "C-4 is plastic explosive of the common variety Composition C. You can use it to breach walls or connect a signaler to its wiring to make it remotely detonable. \
	It has a modifiable timer with a minimum setting of 10 seconds."
	item = /obj/item/weapon/c4
	cost = 1

/datum/uplink_item/device_tools/powersink
	name = "Power Sink"
	desc = "When screwed to wiring attached to a power grid and activated, this large device places excessive load on the grid, causing a stationwide blackout. The sink is large and cannot be stored in \
	most traditional bags and boxes."
	item = /obj/item/device/powersink
	cost = 8

/datum/uplink_item/device_tools/singularity_beacon
	name = "Singularity Beacon"
	desc = "When screwed to wiring attached to an electric grid and activated, this large device pulls any active gravitational singularities towards it. \
	This will not work when the singularity is still in containment. A singularity beacon can cause catastrophic damage to a space station, \
	leading to an emergency evacuation. Because of its size, it cannot be carried. Ordering this sends you a small beacon that will teleport the larger beacon to your location upon activation."
	item = /obj/item/device/sbeacondrop
	cost = 14
	excludefrom = list(/datum/game_mode/gang)

/datum/uplink_item/device_tools/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate bomb is a fearsome device capable of massive destruction. It has an adjustable timer, with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
	movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
	be defused, and some crew may attempt to do so."
	item = /obj/item/device/sbeacondrop/bomb
	cost = 8

/datum/uplink_item/device_tools/rad_laser
	name = "Radioactive Microlaser"
	desc = "A radioactive microlaser disguised as a standard Nanotrasen health analyzer. When used, it emits a powerful burst of radiation, which, after a short delay, can incapitate all but the most protected of humanoids. \
	It has two settings: intensity, which controls the power of the radiation, and wavelength, which controls how long the radiation delay is."
	item = /obj/item/device/rad_laser
	cost = 2

/datum/uplink_item/device_tools/syndicate_detonator
	name = "Syndicate Detonator"
	desc = "The Syndicate detonator is a companion device to the Syndicate bomb. Simply press the included button and an encrypted radio frequency will instruct all live Syndicate bombs to detonate. \
	Useful for when speed matters or you wish to synchronize multiple bomb blasts. Be sure to stand clear of the blast radius before using the detonator."
	item = /obj/item/device/syndicatedetonator
	cost = 2

/datum/uplink_item/device_tools/assault_pod
	name = "Assault Pod Targetting Device"
	desc = "Use to select the landing zone of your assault pod."
	item = /obj/item/device/assault_pod
	cost = 20
	gamemodes = list(/datum/game_mode/nuclear)
	surplus = 0

/datum/uplink_item/device_tools/shield
	name = "Energy Shield"
	desc = "An incredibly useful personal shield projector, capable of reflecting energy projectiles and defending against other attacks."
	item = /obj/item/weapon/shield/deployable/energy
	cost = 10
	gamemodes = list(/datum/game_mode/nuclear,/datum/game_mode/gang)
	surplus = 20

/datum/uplink_item/device_tools/medgun
	name = "Medbeam Gun"
	desc = "Medical Beam Gun, useful in prolonged firefights."
	item = /obj/item/weapon/gun/medbeam
	cost = 13
	gamemodes = list(/datum/game_mode/nuclear)

// IMPLANTS

/datum/uplink_item/implants
	category = "Implants"

/datum/uplink_item/implants/freedom
	name = "Freedom Implant"
	desc = "An implant injected into the body and later activated at the user's will. It will attempt to free the user from common restraints such as handcuffs."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_freedom
	cost = 4

/datum/uplink_item/implants/uplink
	name = "Uplink Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will open a separate uplink with 10 telecrystals. The ability to have these telecrystals, combined with no easy \
	way to detect the ipmlant, makes this excellent for escaping confinement."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_uplink
	cost = 11
	surplus = 0

/*
/datum/uplink_item/implants/adrenal
	name = "Adrenal Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will inject a chemical cocktail which has a mild healing effect along with removing all stuns and increasing movement speed."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_adrenal
	cost = 8
*/

/datum/uplink_item/implants/storage
	name = "Storage Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will open a small subspace pocket capable of storing two items."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_storage
	cost = 6

/datum/uplink_item/implants/microbomb
	name = "Microbomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. The more implants inside of you, the higher the explosive power. \
	This will permanently destroy your body, however."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_microbomb
	cost = 2
	surplus = 30

/datum/uplink_item/implants/mindslave
	name = "Mindslave Implant"
	desc = "An implant injected into another body, forcing the victim to obey any command by the user for around 15 to 20 mintues."
	excludefrom = list(/datum/game_mode/nuclear)
	item = /obj/item/weapon/storage/box/syndie_kit/imp_mindslave
	cost = 8
	surplus = 20

/datum/uplink_item/implants/greatermindslave
	name = "Greater Mindslave Implant"
	desc = "An implant injected into another body, forcing the victim to obey any command by the user, it does not expire like a regular mindslave implant."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_gmindslave
	cost = 16

//CYBERNETIC IMPLANTS

/datum/uplink_item/cyber_implants
	category = "Cybernetic Implants"

/datum/uplink_item/cyber_implants/thermals
	name = "Thermal Vision Implant"
	desc = "These cybernetic eyes will give you thermal vision. They must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/eyes/thermals
	cost = 7

/datum/uplink_item/cyber_implants/xray
	name = "X-Ray Vision Implant"
	desc = "These cybernetic eyes will give you X-ray vision. They must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/eyes/xray
	cost = 8

/datum/uplink_item/cyber_implants/antistun
	name = "CNS Rebooter Implant"
	desc = "This implant will help you get back up on your feet faster after being stunned. It must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/brain/anti_stun
	cost = 10

/datum/uplink_item/cyber_implants/reviver
	name = "Reviver Implant"
	desc = "This implant will attempt to revive you if you lose consciousness. It must be implanted via surgery."
	item = /obj/item/organ/internal/cyberimp/chest/reviver
	cost = 6

/datum/uplink_item/cyber_implants/autoimplanter
	name = "Autoimplanter"
	desc = "A device that automatically injects a cyber-implant into the user without the hassle of extensive surgery. It has a slot to insert implants and a screwdriver slot for removing accidentally added implants."
	item = /obj/item/device/autoimplanter
	cost = 4

/datum/uplink_item/cyber_implants/bundle
	name = "Cybernetic Implants Bundle"
	desc = "A random selection of cybernetic implants. Guaranteed 5 high quality implants. They come with an autoimplanter to implant them for you!"
	item = /obj/item/weapon/storage/box/cyber_implants
	cost = 25
	gamemodes = list(/datum/game_mode/nuclear)

// POINTLESS BADASSERY

/datum/uplink_item/badass
	category = "(Pointless) Badassery"
	surplus = 0
	last = 1

/datum/uplink_item/badass/syndiecigs
	name = "Syndicate Smokes"
	desc = "Strong flavor, dense smoke, infused with omnizine."
	item = /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	cost = 1
	surplus = 40

/datum/uplink_item/badass/bundle
	name = "Syndicate Bundle"
	desc = "Syndicate Bundles are specialised groups of items that arrive in a plain box. These items are collectively worth more than 20 telecrystals, but you do not know which specialisation you will receive."
	item = /obj/item/weapon/storage/box/syndicate
	cost = 20
	excludefrom = list(/datum/game_mode/nuclear,/datum/game_mode/gang,/datum/game_mode/traitor/king_disk)

/datum/uplink_item/badass/syndiecards
	name = "Syndicate Playing Cards"
	desc = "A special deck of space-grade playing cards with a mono-molecular edge and metal reinforcement, making them slightly more robust than a normal deck of cards. \
	You can also play card games with them or leave them on your victims."
	item = /obj/item/toy/cards/deck/syndicate
	cost = 1
	excludefrom = list(/datum/game_mode/nuclear)
	surplus = 40

/datum/uplink_item/badass/syndiecash
	name = "Syndicate Briefcase Full of Cash"
	desc = "A secure briefcase containing 5000 space credits. Useful for bribing personnel, or purchasing goods and services at lucrative prices. \
	The briefcase also feels a little heavier to hold; it has been manufactured to pack a little bit more of a punch if your client needs some convincing."
	item = /obj/item/weapon/storage/secure/briefcase/syndie
	cost = 1
	surplus = 40

/datum/uplink_item/badass/balloon
	name = "For showing that you are THE BOSS"
	desc = "A useless red balloon with the Syndicate logo on it. Can blow the deepest of covers."
	item = /obj/item/toy/syndicateballoon
	cost = 20

/datum/uplink_item/implants/macrobomb
	name = "Macrobomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. Upon death, releases a massive explosion that will wipe out everything nearby."
	item = /obj/item/weapon/storage/box/syndie_kit/imp_macrobomb
	cost = 16

/datum/uplink_item/badass/raincoat
    name = "Raincoat"
    desc = "It's hip to be square!"
    item = /obj/item/clothing/suit/raincoat
    cost = 1

/datum/uplink_item/badass/random
	name = "Random Item"
	desc = "Picking this choice will send you a random item from the list. Useful for when you cannot think of a strategy to finish your objectives with."
	item = /obj/item/weapon/storage/box/syndicate
	cost = 0

/datum/uplink_item/badass/random/spawn_item(turf/loc, obj/item/device/uplink/U)

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
	excludefrom = list(/datum/game_mode/nuclear,/datum/game_mode/traitor/king_disk)

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
