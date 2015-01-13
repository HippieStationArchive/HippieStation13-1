/obj/structure/closet/secure_closet/mime
	name = "Mime closet"
	desc = "Filled with mime stuff"
	icon_state = "mimesecure1"
	icon_closed = "mimesecure"
	icon_locked = "mimesecure1"
	icon_opened = "mimesecureopen"
	icon_broken = "mimesecureoff"
	icon_off = "mimesecureoff"
	req_access = list(access_theatre)


/obj/structure/closet/secure_closet/mime/New()
	..()
	new /obj/item/toy/crayon/mime
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/clothing/mask/gas/mime(src)
	new /obj/item/clothing/shoes/sneakers/mime(src)
	new /obj/item/clothing/under/rank/mime(src)
	new /obj/item/weapon/storage/backpack/mime(src)
	return

/obj/structure/closet/secure_closet/clown
	name = "Clown closet"
	desc = "Filled with clown stuff"
	icon_state = "clownsecure1"
	icon_closed = "clownsecure"
	icon_locked = "clownsecure1"
	icon_opened = "clownsecureopen"
	icon_broken = "clownsecureoff"
	icon_off = "clownsecureoff"
	req_access = list(access_theatre)


/obj/structure/closet/secure_closet/clown/New()
	..()
	new /obj/item/weapon/stamp/clown(src)
	new /obj/item/clothing/under/rank/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/weapon/storage/backpack/clown(src)
	return






