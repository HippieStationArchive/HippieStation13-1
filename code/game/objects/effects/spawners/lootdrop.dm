/obj/effect/spawner/lootdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = 1		//if the same item can be spawned twice
	var/list/loot			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)

/obj/effect/spawner/lootdrop/New()
	if(loot && loot.len)
		for(var/i = lootcount, i > 0, i--)
			if(!loot.len) break
			var/lootspawn = pickweight(loot)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				new lootspawn(get_turf(src))
	qdel(src)

/obj/effect/spawner/lootdrop/armory_contraband
	name = "armory contraband gun spawner"
	lootdoubles = 0

	loot = list(
				/obj/item/weapon/gun/projectile/automatic/pistol = 8,
				/obj/item/weapon/gun/projectile/shotgun/automatic/combat = 5,
				/obj/item/weapon/gun/projectile/revolver/mateba,
				/obj/item/weapon/gun/projectile/automatic/pistol/deagle
				)

/obj/effect/spawner/lootdrop/maintenance
	name = "maintenance loot spawner"

	//How to balance this table
	//-------------------------
	//The total added weight of all the entries should be (roughly) equal to the total number of lootdrops
	//(take in account those that spawn more than one object!)
	//
	//While this is random, probabilities tells us that item distribution will have a tendency to look like
	//the content of the weighted table that created them.
	//The less lootdrops, the less even the distribution.
	//
	//If you want to give items a weight <1 you can multiply all the weights by 10
	//
	//the "" entry will spawn nothing, if you increase this value,
	//ensure that you balance it with more spawn points

	//table data:
	//-----------
	//aft maintenance: 		24 items, 18 spots 2 extra (28/08/2014)
	//asmaint: 				16 items, 11 spots 0 extra (08/08/2014)
	//asmaint2:			 	36 items, 26 spots 2 extra (28/08/2014)
	//fpmaint:				5  items,  4 spots 0 extra (08/08/2014)
	//fpmaint2:				12 items, 11 spots 2 extra (28/08/2014)
	//fsmaint:				0  items,  0 spots 0 extra (08/08/2014)
	//fsmaint2:				40 items, 27 spots 5 extra (28/08/2014)
	//maintcentral:			2  items,  2 spots 0 extra (08/08/2014)
	//port:					5  items,  5 spots 0 extra (08/08/2014)
	loot = list(
				/obj/item/bodybag = 1,
				/obj/item/clothing/glasses/meson = 2,
				/obj/item/clothing/glasses/sunglasses = 1,
				/obj/item/clothing/gloves/color/yellow/fake = 1,
				/obj/item/clothing/head/hardhat = 1,
				/obj/item/clothing/head/hardhat/red = 1,
				/obj/item/clothing/head/that{throwforce = 1; throwing = 1} = 1,
				/obj/item/clothing/head/ushanka = 1,
				/obj/item/clothing/head/welding = 1,
				/obj/item/clothing/mask/gas = 15,
				/obj/item/clothing/suit/hazardvest = 1,
				/obj/item/clothing/under/rank/vice = 1,
				/obj/item/device/assembly/prox_sensor = 4,
				/obj/item/device/assembly/timer = 3,
				/obj/item/device/flashlight = 4,
				/obj/item/device/flashlight/pen = 1,
				/obj/item/weapon/storage/daki = 3,
				/obj/item/device/multitool = 2,
				/obj/item/device/radio/off = 2,
				/obj/item/device/t_scanner = 6,
				/obj/item/stack/cable_coil = 4,
				/obj/item/stack/cable_coil{amount = 5} = 6,
				/obj/item/stack/medical/bruise_pack = 1,
				/obj/item/stack/rods{amount = 10} = 9,
				/obj/item/stack/rods{amount = 23} = 1,
				/obj/item/stack/rods{amount = 50} = 1,
				/obj/item/stack/ducttape{amount = 5} = 6,
				/obj/item/stack/ducttape{amount = 10} = 2,
				/obj/item/stack/ducttape = 1,
				/obj/item/stack/sheet/cardboard = 2,
				/obj/item/stack/sheet/metal{amount = 20} = 1,
				/obj/item/stack/sheet/mineral/plasma{layer = 2.9} = 1,
				/obj/item/stack/sheet/rglass = 1,
				/obj/item/weapon/book/manual/wiki/engineering_construction = 1,
				/obj/item/weapon/book/manual/wiki/engineering_hacking = 1,
				/obj/item/clothing/head/cone = 1,
				/obj/item/weapon/coin/silver = 1,
				/obj/item/weapon/coin/twoheaded = 1,
				/obj/item/weapon/poster/contraband = 1,
				/obj/item/weapon/poster/legit = 1,
				/obj/item/weapon/crowbar = 1,
				/obj/item/weapon/crowbar/red = 1,
				/obj/item/weapon/extinguisher = 11,
				//obj/item/weapon/gun/projectile/revolver/russian = 1, //disabled until lootdrop is a proper world proc.
				/obj/item/weapon/hand_labeler = 1,
				/obj/item/weapon/paper/crumpled = 1,
				/obj/item/weapon/pen = 1,
				/obj/item/weapon/reagent_containers/spray/pestspray = 1,
				/obj/item/weapon/reagent_containers/glass/rag = 3,
				/obj/item/weapon/stock_parts/cell = 3,
				/obj/item/weapon/storage/belt/utility = 2,
				/obj/item/weapon/storage/box = 2,
				/obj/item/weapon/storage/box/cups = 1,
				/obj/item/weapon/storage/box/donkpockets = 1,
				/obj/item/weapon/storage/box/lights/mixed = 3,
				/obj/item/weapon/storage/box/hug/medical = 1,
				/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 1,
				/obj/item/weapon/storage/toolbox/mechanical = 1,
				/obj/item/weapon/screwdriver = 3,
				/obj/item/weapon/tank/internals/emergency_oxygen = 2,
				/obj/item/weapon/vending_refill/cola = 1,
				/obj/item/weapon/weldingtool = 3,
				/obj/item/weapon/wirecutters = 1,
				/obj/item/weapon/wrench = 4,
				/obj/item/weapon/relic = 3,
				/obj/item/clothing/under/cosby = 1,
				/obj/item/organ/internal/chemgland = 1,
				"" = 11
				)

/obj/effect/spawner/lootdrop/crate_spawner
	name = "lootcrate spawner"
	lootdoubles = 0

	loot = list(
				/obj/structure/closet/crate/secure/loot = 20,
				"" = 80
				)

/obj/effect/spawner/lootdrop/contraband
//Total of 1850 items. (26/10/2015)
	name = "contraband spawner"
	loot = list(
				/obj/item/weapon/relic = 80,
				/obj/item/weapon/book/manual/wiki/engineering_hacking = 50,
				/obj/item/weapon/poster/contraband = 80,
				/obj/item/weapon/bikehorn/airhorn = 20,
				/obj/item/weapon/gun/buttlauncher = 10,
				/obj/item/weapon/banhammer = 10,
				/obj/item/weapon/bikehorn = 50,
				/obj/item/weapon/storage/daki = 50,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita = 150,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap = 150,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/reishi = 150,
				/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/deus = 100,
				/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris = 300,
				/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 50,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita{potency = 100} = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap{potency = 100} = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/reishi{potency = 100} = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/deus{potency = 100} = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris{potency = 100} = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/banana{potency = 100} = 10,
				/obj/item/weapon/cartridge/clown = 30,
				/obj/item/weapon/lipstick/random = 30,
				/obj/item/weapon/picket_sign = 40,
				/obj/item/weapon/pneumatic_cannon/ghetto = 25,
				/obj/item/weapon/reagent_containers/food/drinks/soda_cans/thirteenloko = 15,
				/obj/item/weapon/reagent_containers/food/snacks/soylentgreen = 15,
				/obj/item/weapon/reagent_containers/spray/waterflower = 33,
				/obj/item/weapon/restraints/legcuffs/beartrap = 33,
				/obj/item/weapon/stamp/clown =20,
				/obj/item/weapon/storage/crayons = 20,
				/obj/item/weapon/storage/spooky = 5,
				/obj/item/weapon/storage/book/bible = 5,
				/obj/item/weapon/tome = 1,
				/obj/item/weapon/toy/xmas_cracker = 10,
				/obj/item/ammo_box/foambox = 10,
				/obj/item/areaeditor/permit = 5,
				/obj/item/clothing/gloves/boxing = 20,
				/obj/item/clothing/shoes/clown_shoes/banana_shoes = 5,
				/obj/item/documents/syndicate/blue = 1,
				/obj/item/documents/syndicate/red = 1,
				/obj/item/seeds/kudzuseed = 5,
				/obj/item/toy/syndicateballoon = 1,
				/obj/item/toy/crayon/rainbow = 40,
				/obj/item/toy/crayon/mime = 30,
				/obj/item/toy/foamblade = 10,
				/obj/item/weapon/grown/bananapeel = 40,
				/obj/item/weapon/grown/bananapeel/specialpeel = 5,
				/obj/item/stack/ducttape{amount = 5} = 40,
				/obj/item/stack/ducttape{amount = 10} = 20,
				/obj/item/stack/ducttape = 10,
				/obj/item/clothing/under/cosby = 1,
				"" = 100
				)

/obj/effect/spawner/lootdrop/food
//Total of 870 items. (26/10/2015)
	name = "food_spawner"
	loot = list(
				/obj/item/weapon/reagent_containers/food/snacks/baguette = 5,
				/obj/item/weapon/reagent_containers/food/snacks/store/bread/plain = 5,
				/obj/item/weapon/reagent_containers/food/snacks/breadslice/plain = 60,
				/obj/item/weapon/reagent_containers/food/snacks/store/bread/meat = 1,
				/obj/item/weapon/reagent_containers/food/snacks/breadslice/meat = 5,
				/obj/item/weapon/reagent_containers/food/snacks/store/bread/banana = 1,
				/obj/item/weapon/reagent_containers/food/snacks/breadslice/banana = 5,
				/obj/item/weapon/reagent_containers/food/snacks/store/bread/tofu = 1,
				/obj/item/weapon/reagent_containers/food/snacks/breadslice/tofu = 5,
				/obj/item/weapon/reagent_containers/food/snacks/store/bread/creamcheese = 1,
				/obj/item/weapon/reagent_containers/food/snacks/breadslice/creamcheese = 5,
				/obj/item/weapon/reagent_containers/food/snacks/store/bread/mimana = 1,
				/obj/item/weapon/reagent_containers/food/snacks/breadslice/mimana = 3,
				/obj/item/weapon/reagent_containers/food/snacks/candy_corn = 5,
				/obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice = 5,
				/obj/item/weapon/reagent_containers/food/snacks/popcorn = 5,
				/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 5,
				/obj/item/weapon/reagent_containers/food/snacks/fries = 10,
				/obj/item/weapon/reagent_containers/food/snacks/soydope = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cheesyfries = 5,
				/obj/item/weapon/reagent_containers/food/snacks/badrecipe = 100,
				/obj/item/weapon/reagent_containers/food/snacks/carrotfries = 5,
				/obj/item/weapon/reagent_containers/food/snacks/candiedapple = 5,
				/obj/item/weapon/reagent_containers/food/snacks/eggwrap = 5,
				/obj/item/weapon/reagent_containers/food/snacks/beans = 5,
				/obj/item/weapon/reagent_containers/food/snacks/chococoin = 5,
				/obj/item/weapon/reagent_containers/food/snacks/chocoorange = 5,
				/obj/item/weapon/reagent_containers/food/snacks/eggplantparm = 5,
				/obj/item/weapon/reagent_containers/food/snacks/tortilla = 10,
				/obj/item/weapon/reagent_containers/food/snacks/burrito = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cheesyburrito = 5,
				/obj/item/weapon/reagent_containers/food/snacks/carneburrito = 5,
				/obj/item/weapon/reagent_containers/food/snacks/fuegoburrito = 5,
				/obj/item/weapon/reagent_containers/food/snacks/yakiimo = 5,
				/obj/item/weapon/reagent_containers/food/snacks/roastparsnip = 5,
				/obj/item/weapon/reagent_containers/food/snacks/melonfruitbowl = 5,
				/obj/item/weapon/reagent_containers/food/snacks/spacefreezy = 5,
				/obj/item/weapon/reagent_containers/food/snacks/sundae = 5,
				/obj/item/weapon/reagent_containers/food/snacks/honkdae = 5,
				/obj/item/weapon/reagent_containers/food/snacks/nachos = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cheesynachos = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cubannachos = 5,
				/obj/item/weapon/reagent_containers/food/snacks/melonkeg = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cubancarp = 5,
				/obj/item/weapon/reagent_containers/food/snacks/carpmeat/imitation = 5,
				/obj/item/weapon/reagent_containers/food/snacks/fishfingers = 5,
				/obj/item/weapon/reagent_containers/food/snacks/fishandchips = 5,
				/obj/item/weapon/reagent_containers/food/snacks/tofu = 10,
				/obj/item/weapon/reagent_containers/food/snacks/cornedbeef = 5,
				/obj/item/weapon/reagent_containers/food/snacks/bearsteak = 5,
				/obj/item/weapon/reagent_containers/food/snacks/faggot = 5,
				/obj/item/weapon/reagent_containers/food/snacks/sausage = 5,
				/obj/item/weapon/reagent_containers/food/snacks/kebab = 15,
				/obj/item/weapon/reagent_containers/food/snacks/kebab/monkey = 5,
				/obj/item/weapon/reagent_containers/food/snacks/kebab/tofu = 5,
				/obj/item/weapon/reagent_containers/food/snacks/enchiladas = 5,
				/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat = 5,
				/obj/item/weapon/reagent_containers/food/snacks/boiledspiderleg = 5,
				/obj/item/weapon/reagent_containers/food/snacks/spidereggsham = 5,
				/obj/item/weapon/reagent_containers/food/snacks/sashimi = 5,
				/obj/item/weapon/reagent_containers/food/snacks/sandwich = 15,
				/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grilledcheese = 5,
				/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry = 5,
				/obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich = 5,
				/obj/item/weapon/reagent_containers/food/snacks/notasandwich = 5,
				/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/cherry = 5,
				/obj/item/weapon/reagent_containers/food/snacks/twobread = 5,
				/obj/item/weapon/reagent_containers/food/snacks/muffin = 5,
				/obj/item/weapon/reagent_containers/food/snacks/muffin/berry = 5,
				/obj/item/weapon/reagent_containers/food/snacks/muffin/booberry = 5,
				/obj/item/weapon/reagent_containers/food/snacks/chawanmushi = 5,
				/obj/item/weapon/reagent_containers/food/snacks/waffles = 5,
				/obj/item/weapon/reagent_containers/food/snacks/soylenviridians = 5,
				/obj/item/weapon/reagent_containers/food/snacks/rofflewaffles = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cookie = 5,
				/obj/item/weapon/reagent_containers/food/snacks/donkpocket/warm = 45,
				/obj/item/weapon/reagent_containers/food/snacks/fortunecookie = 5,
				/obj/item/weapon/reagent_containers/food/snacks/poppypretzel = 5,
				/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cracker = 5,
				/obj/item/weapon/reagent_containers/food/snacks/hotdog = 15,
				/obj/item/weapon/reagent_containers/food/snacks/meatbun = 5,
				/obj/item/weapon/reagent_containers/food/snacks/sugarcookie = 5,
				/obj/item/weapon/reagent_containers/food/snacks/chococornet = 5,
				/obj/item/weapon/reagent_containers/food/snacks/oatmealcookie = 5,
				/obj/item/weapon/reagent_containers/food/snacks/raisincookie = 5,
				/obj/item/weapon/reagent_containers/food/snacks/cherrycupcake = 5,
				/obj/item/weapon/reagent_containers/food/snacks/bluecherrycupcake = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/plain = 60,
				/obj/item/weapon/reagent_containers/food/snacks/burger/corgi = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/appendix = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/fish = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/tofu = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/xeno = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/bearger = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/clown = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/mime = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/brain = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/ghost = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/red = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/orange = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/yellow = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/green = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/blue = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/purple = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/bigbite = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/jelly/cherry = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/superbite = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/fivealarm = 5,
				/obj/item/weapon/reagent_containers/food/snacks/burger/rat = 20,
				"" = 100
				)

/obj/effect/spawner/lootdrop/plants
//Total of 279 items. (26/10/2015)
	name = "plant_spawner"
	loot = list(
				/obj/item/weapon/reagent_containers/food/snacks/grown/corn = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/cherries = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/potato = 20,
				/obj/item/weapon/reagent_containers/food/snacks/grown/grapes = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage = 15,
				/obj/item/weapon/reagent_containers/food/snacks/grown/berries = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/cocoapod = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane = 15,
				/obj/item/weapon/reagent_containers/food/snacks/grown/apple = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lemon = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lime = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 2,
				/obj/item/weapon/reagent_containers/food/snacks/grown/chili = 2,
				/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/tomato = 15,
				/obj/item/weapon/reagent_containers/food/snacks/grown/wheat = 30,
				/obj/item/weapon/reagent_containers/food/snacks/grown/rice = 10,
				/obj/item/weapon/reagent_containers/food/snacks/grown/carrot = 15,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet = 5,
				/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/chanterelle = 5,
				"" = 10
				)
