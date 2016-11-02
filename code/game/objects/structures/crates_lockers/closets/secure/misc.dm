/obj/structure/closet/secure_closet/ertCom
	name = "commander's closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(access_cent_captain)
	icon_state = "cap"

/obj/structure/closet/secure_closet/ertCom/New()
	..()
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/device/aicard(src)
	new /obj/item/device/assembly/flash(src)
	if(prob(50))
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/weapon/gun/projectile/automatic/pistol/deagle(src)
	else
		new /obj/item/ammo_box/a357(src)
		new /obj/item/ammo_box/a357(src)
		new /obj/item/weapon/gun/projectile/revolver/mateba(src)

/obj/structure/closet/secure_closet/ertSec
	name = "security closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(access_cent_specops)
	icon_state = "hos"

/obj/structure/closet/secure_closet/ertSec/New()
	..()
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/teargas(src)
	new /obj/item/weapon/storage/box/flashes(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/weapon/shield/deployable/tele(src)

/obj/structure/closet/secure_closet/ertMed
	name = "medical closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(access_cent_medical)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/ertMed/New()
	..()
	new /obj/item/weapon/storage/firstaid/o2(src)
	new /obj/item/weapon/storage/firstaid/toxin(src)
	new /obj/item/weapon/storage/firstaid/fire(src)
	new /obj/item/weapon/storage/firstaid/brute(src)
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/defibrillator/compact/combat/loaded(src)
	new /obj/machinery/bot/medbot(src)

/obj/structure/closet/secure_closet/ertEngi
	name = "engineer closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(access_cent_storage)
	icon_state = "ce"

/obj/structure/closet/secure_closet/ertEngi/New()
	..()
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/sheet/glass(src, 50)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/weapon/storage/box/metalfoam(src)
	new /obj/item/weapon/rcd_ammo/large(src)
	new /obj/item/weapon/rcd_ammo/large(src)
	new /obj/item/weapon/rcd_ammo/large(src)

/obj/structure/closet/secure_closet/mime
	name = "Mime closet"
	desc = "Filled with mime stuff"
	req_access = list(access_theatre)
	icon_state = "mime"

/obj/structure/closet/secure_closet/mime/New()
	..()
	new /obj/item/toy/crayon/mime(src)
	new /obj/item/clothing/head/beret(src)
	new /obj/item/clothing/mask/gas/mime(src)
	new /obj/item/clothing/shoes/sneakers/mime(src)
	new /obj/item/clothing/under/rank/mime(src)
	new /obj/item/weapon/storage/backpack/mime(src)
	new /obj/item/weapon/reagent_containers/food/snacks/baguette(src)
	new /obj/item/clothing/gloves/color/white(src)
	new /obj/item/clothing/suit/suspenders(src)

/obj/structure/closet/secure_closet/clown
	name = "Clown closet"
	desc = "Filled with clown stuff"
	req_access = list(access_theatre)
	icon_state = "clown"

/obj/structure/closet/secure_closet/clown/New()
	..()
	new /obj/item/toy/crayon/rainbow(src)
	new /obj/item/weapon/stamp/clown(src)
	new /obj/item/clothing/under/rank/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/weapon/storage/backpack/clown(src)
	new /obj/item/weapon/bikehorn(src)
