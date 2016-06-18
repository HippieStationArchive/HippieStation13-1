/**********************Light************************/

//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light-emtter"
	anchored = 1
	unacidable = 1
	luminosity = 8

/**********************Miner Lockers**************************/

/obj/structure/closet/wardrobe/miner
	name = "mining wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/miner/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/dufflebag/engineering(src)
	new /obj/item/weapon/storage/backpack/industrial(src)
	new /obj/item/weapon/storage/backpack/satchel_eng(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/suit/hooded/wintercoat/miner(src)
	new /obj/item/clothing/suit/hooded/wintercoat/miner(src)
	new /obj/item/clothing/suit/hooded/wintercoat/miner(src)

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "mining"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/device/t_scanner/adv_mining_scanner(src)
	new /obj/item/weapon/storage/bag/ore(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe(src)
	new /obj/item/clothing/glasses/meson(src)
	new	/obj/item/device/flashlight/lantern(src)

/**********************Shuttle Computer**************************/

/obj/machinery/computer/shuttle/mining
	name = "Mining Shuttle Console"
	desc = "Used to call and send the mining shuttle."
	circuit = /obj/item/weapon/circuitboard/mining_shuttle
	shuttleId = "mining"
	possible_destinations = "mining_home;mining_away"

/obj/machinery/computer/shuttle/outpost
	name = "Outpost Shuttle Console"
	desc = "Used to call and send the research outpost shuttle."
	circuit = /obj/item/weapon/circuitboard/outpost_shuttle
	shuttleId = "outpost"
	possible_destinations = "outpost_home;outpost_away"

/*********************Pickaxe & Drills**************************/

/obj/item/weapon/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 10
	item_state = "pickaxe"
	w_class = 4
	materials = list(MAT_METAL=2000) //one sheet, but where can you make them?
	var/digspeed = 40
	var/list/digsound = list('sound/effects/picaxe1.ogg','sound/effects/picaxe2.ogg','sound/effects/picaxe3.ogg')
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("hit", "pierced", "sliced", "attacked")

// /obj/item/weapon/pickaxe/suicide_act(mob/user)
	//Edgy flavortext to-do
	//"User slams down the head of the pickaxe into Victim's chest!" "You hear bones crunching!" "Victim screams!" "User pulls back the pickaxe, and Victim's heart is popped out, along with bits of bones and other viscera!"
	// return(BRUTELOSS)

/obj/item/weapon/pickaxe/proc/playDigSound()
	playsound(src, pick(digsound),50,1)

/obj/item/weapon/pickaxe/diamond
	name = "diamond-tipped pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 20 //mines twice as fast as a normal pickaxe, bought from mining vendor
	origin_tech = "materials=4;engineering=3"
	desc = "A pickaxe with a diamond pick head. Extremely robust at cracking rock walls and digging up dirt."

/obj/item/weapon/pickaxe/drill
	name = "mining drill"
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 25 //available from roundstart, faster than a pickaxe.
	digsound = list('sound/weapons/drill.ogg')
	hitsound = 'sound/weapons/drill.ogg'
	origin_tech = "materials=2;powerstorage=3;engineering=2"
	desc = "An electric mining drill for the especially scrawny."

/obj/item/weapon/pickaxe/drill/cyborg
	name = "cyborg mining drill"
	desc = "An integrated electric mining drill."
	flags = NODROP

/obj/item/weapon/pickaxe/drill/diamonddrill
	name = "diamond-tipped mining drill"
	icon_state = "diamonddrill"
	digspeed = 10
	origin_tech = "materials=6;powerstorage=4;engineering=5"
	desc = "Yours is the drill that will pierce the heavens!"

/obj/item/weapon/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "diamond-tipped cyborg mining drill" //To inherit the NODROP flag, and easier to change borg specific drill mechanics.
	icon_state = "diamonddrill"
	digspeed = 10

/obj/item/weapon/pickaxe/drill/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 5 //the epitome of powertools. extremely fast mining, laughs at puny walls
	origin_tech = "materials=3;powerstorage=2;engineering=2"
	digsound = list('sound/weapons/sonic_jackhammer.ogg')
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	desc = "Cracks rocks with sonic blasts, and doubles as a demolition power tool for smashing walls."

/*****************************Shovel********************************/

/obj/item/weapon/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	stamina_percentage = 0.3
	var/digspeed = 20
	throwforce = 5
	item_state = "shovel"
	w_class = 3
	materials = list(MAT_METAL=50)
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharpness = IS_SHARP

/obj/item/weapon/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5
	stamina_percentage = 0.3
	throwforce = 7
	w_class = 2


/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon_crate = "miningcar"
	icon_state = "miningcar"
/*****************************Survival Pod********************************/


/area/survivalpod
	name = "\improper Emergency Shelter"
	icon_state = "away"
	requires_power = 0
	has_gravity = 1

/obj/item/weapon/survivalcapsule
	name = "bluespace shelter capsule"
	desc = "An emergency shelter stored within a pocket of bluespace."
	icon_state = "capsule"
	icon = 'icons/obj/mining.dmi'
	w_class = 1
	var/used = FALSE

/obj/item/weapon/survivalcapsule/attack_self()
	if(used == FALSE)
		src.loc.visible_message("The [src] begins to shake. Stand back!")
		used = TRUE
		sleep(50)
		playsound(get_turf(src), 'sound/effects/phasein.ogg', 100, 1)
		PoolOrNew(/obj/effect/particle_effect/smoke, src.loc)
		load()
		qdel(src)

/obj/item/weapon/survivalcapsule/proc/load()
	var/turf/start_turf = get_turf(src.loc)
	var/turf/cur_turf
	var/x_size = 5
	var/y_size = 5
	var/list/walltypes = list(/turf/simulated/wall)
	var/floor_type = /turf/simulated/floor/wood
	var/room
	var/onshuttle = 0

	//Center the room/spawn it
	start_turf = locate(start_turf.x -2, start_turf.y - 2, start_turf.z)

	var/area/A = get_area(src)
	if(istype(A, /area/shuttle))
		onshuttle = 1
	room = spawn_room(start_turf, x_size, y_size, walltypes, floor_type, "Emergency Shelter", onshuttle)

	start_turf = get_turf(src.loc)

	//Fill it
	cur_turf = locate(start_turf.x, start_turf.y-2, start_turf.z)
	new /obj/machinery/door/airlock/glass(cur_turf)

	cur_turf = locate(start_turf.x+1, start_turf.y, start_turf.z)
	new /obj/structure/table/wood(cur_turf)
	new /obj/item/weapon/storage/pill_bottle/dice(cur_turf)

	cur_turf = locate(start_turf.x+1, start_turf.y-1, start_turf.z)
	var/obj/structure/bed/chair/comfy/C = new /obj/structure/bed/chair/comfy(cur_turf)
	C.dir = 1

	cur_turf = locate(start_turf.x+1, start_turf.y+1, start_turf.z)
	new /obj/structure/bed/chair/comfy(cur_turf)

	cur_turf = locate(start_turf.x-1, start_turf.y-1, start_turf.z)
	var/obj/machinery/sleeper/S = new /obj/machinery/sleeper(cur_turf)
	S.dir = 4

	cur_turf = locate(start_turf.x-1, start_turf.y, start_turf.z)
	new /obj/structure/table/wood(cur_turf)
	new /obj/item/weapon/storage/box/donkpockets(cur_turf)

	cur_turf = locate(start_turf.x-1, start_turf.y+1, start_turf.z)
	new /obj/structure/table/wood(cur_turf)
	new /obj/machinery/microwave(cur_turf)

	var/area/survivalpod/L = new /area/survivalpod

	var/turf/threshhold = locate(start_turf.x, start_turf.y-2, start_turf.z)
	threshhold.ChangeTurf(/turf/simulated/floor/wood)
	threshhold.blocks_air = 1 //So the air doesn't leak out
	threshhold.oxygen = 21
	threshhold.temperature = 293.15
	threshhold.nitrogen = 82
	threshhold.carbon_dioxide = 0
	threshhold.toxins = 0
	if(!onshuttle)
		L.contents += threshhold
	threshhold.overlays.Cut()

	var/list/turfs = room["floors"]
	for(var/turf/simulated/floor/F in turfs)
		SSair.remove_from_active(F)
		F.oxygen = 21
		F.temperature = 293.15
		F.nitrogen = 82
		F.carbon_dioxide = 0
		F.toxins = 0
		F.air.oxygen = 21
		F.air.carbon_dioxide = 0
		F.air.nitrogen = 82
		F.air.toxins = 0
		F.air.temperature = 293.15
		SSair.add_to_active(F)
		F.overlays.Cut()
		if(!onshuttle)
			L.contents += F
