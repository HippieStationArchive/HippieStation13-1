/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	icon_state = "hydro"

/obj/structure/closet/secure_closet/hydroponics/New()
	..()
	new /obj/item/weapon/storage/bag/plants/portaseeder(src)
	new /obj/item/device/analyzer/plant_analyzer(src)
	new /obj/item/device/radio/headset/headset_srv(src)
	new /obj/item/weapon/cultivator(src)
	new /obj/item/weapon/hatchet(src)