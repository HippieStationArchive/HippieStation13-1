/* Backpacks
 * Contains:
 *		Backpack
 *		Backpack Types
 *		Satchel Types
 *		Dufflebag Types
 *		Mountain Backpack Types
 */

/*
 * Backpack
 */

/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/bags.dmi'
	icon_state = "backpack"
	item_state = "backpack"
	w_class = 4
	slot_flags = SLOT_BACK	//ERROOOOO
	max_w_class = 3
	max_combined_w_class = 21

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()

/*
 * Backpack Types
 */

/obj/item/weapon/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "bluespace=4"
	icon_state = "holdingpack"
	max_w_class = 5
	max_combined_w_class = 35

/obj/item/weapon/storage/backpack/holding/can_be_inserted(obj/item/W, stop_messages = 0, mob/user)
	if(crit_fail)
		user << "<span class='danger'>The Bluespace generator isn't working.</span>"
		return
	return ..()

/obj/item/weapon/storage/backpack/holding/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	if(istype(W, /obj/item/weapon/storage/backpack/holding) && !W.crit_fail)
		investigate_log("has become a singularity. Caused by [user.key]","singulo")
		user << "<span class='danger'>The Bluespace interfaces of the two devices catastrophically malfunction!</span>"
		qdel(W)
		var/obj/singularity/singulo = new /obj/singularity (get_turf(src))
		singulo.energy = 300 //should make it a bit bigger~
		message_admins("[key_name_admin(user)] detonated a bag of holding")
		log_game("[key_name(user)] detonated a bag of holding")
		qdel(src)
		singulo.process()
		return
	..()

/obj/item/weapon/storage/backpack/holding/proc/failcheck(mob/user as mob)
	if (prob(src.reliability)) return 1 //No failure
	if (prob(src.reliability))
		user << "<span class='danger'>The Bluespace portal resists your attempt to add another item.</span>" //light failure
	else
		user << "<span class='danger'>The Bluespace generator malfunctions!</span>"
		for (var/obj/O in src.contents) //it broke, delete what was in it
			qdel(O)
		crit_fail = 1
		icon_state = "brokenpack"

/obj/item/weapon/storage/backpack/holding/singularity_act(current_size)
	var/dist = max((current_size - 2),1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return


/obj/item/weapon/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4.0
	storage_slots = 20 //Can store a lot.
	max_w_class = 3
	max_combined_w_class = 60

/obj/item/weapon/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"
	item_state = "backpack"

/obj/item/weapon/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/weapon/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "A silent backpack made for those silent workers. Silence Co."
	icon_state = "mimepack"
	item_state = "mimepack"

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for Nanotrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"

/obj/item/weapon/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"

/*
 * Satchel Types
 */

/obj/item/weapon/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"

/obj/item/weapon/storage/backpack/satchel/withwallet/New()
	..()
	new /obj/item/weapon/storage/wallet/random( src )

/obj/item/weapon/storage/backpack/satchel_norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/weapon/storage/backpack/satchel_eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state = "engiepack"

/obj/item/weapon/storage/backpack/satchel_med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/satchel_vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"

/obj/item/weapon/storage/backpack/satchel_chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"

/obj/item/weapon/storage/backpack/satchel_gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"

/obj/item/weapon/storage/backpack/satchel_tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/weapon/storage/backpack/satchel_sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/satchel_hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

/obj/item/weapon/storage/backpack/satchel_cap
	name = "captain's satchel"
	desc = "An exclusive satchel for Nanotrasen officers."
	icon_state = "satchel-cap"
	item_state = "captainpack"

/obj/item/weapon/storage/backpack/satchel_flat
	name = "smuggler's satchel"
	desc = "A very slim satchel that can easily fit into tight spaces."
	icon_state = "satchel-flat"
	w_class = 3 //Can fit in backpacks itself.
	storage_slots = 5
	max_combined_w_class = 15
	level = 1
	cant_hold = list(/obj/item/weapon/storage/backpack/satchel_flat) //muh recursive backpacks

/obj/item/weapon/storage/backpack/satchel_flat/hide(var/intact)
	if(intact)
		invisibility = 101
		anchored = 1 //otherwise you can start pulling, cover it, and drag around an invisible backpack.
		icon_state = "[initial(icon_state)]2"
	else
		invisibility = initial(invisibility)
		anchored = 0
		icon_state = initial(icon_state)

/obj/item/weapon/storage/backpack/satchel_flat/New()
	..()
	new /obj/item/stack/tile/plasteel(src)
	new /obj/item/weapon/crowbar(src)

/*
 * Dufflebag Types
 */

/obj/item/weapon/storage/backpack/dufflebag
	name = "duffle bag"
	desc = "It is often used to carry luggage or sports equipment by people who travel in the outdoors. I guess space counts as outdoors."
	icon_state = "dufflebag"
	item_state = "dufflebag"

/obj/item/weapon/storage/backpack/dufflebag/syndie_med
	name = "field medic bag"
	desc = "It's a syndicate medic duffle bag."
	icon_state = "dufflebag-syndiemed"
	item_state = "dufflebag-syndiemed"

/obj/item/weapon/storage/backpack/dufflebag/syndie_med/New()
	..()
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/storage/firstaid/fire(src)
	new /obj/item/weapon/storage/firstaid/fire(src)
	new /obj/item/weapon/storage/firstaid/toxin(src)
	new /obj/item/weapon/storage/pill_bottle/stimulant(src)

/obj/item/weapon/storage/backpack/dufflebag/syndie_ammo
	name = "ammo bag"
	desc = "It's a syndicate ammo duffle bag."
	icon_state = "dufflebag-syndieammo"
	item_state = "dufflebag-syndieammo"

/obj/item/weapon/storage/backpack/dufflebag/syndie_ammo/New()
	..()
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/c10mm(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)

/obj/item/weapon/storage/backpack/dufflebag_captain
	name = "captain's duffle bag"
	desc = "Captain's very own duffle bag."
	icon_state = "dufflebag-captain"
	item_state = "dufflebag-captain"

/obj/item/weapon/storage/backpack/dufflebag_security
	name = "security duffle bag"
	desc = "Ultra robust duffle bag for hipster security officers."
	icon_state = "dufflebag-security"
	item_state = "dufflebag-security"

/obj/item/weapon/storage/backpack/dufflebag_virology
	name = "virologist duffle bag"
	desc = "A sterile duffle bag with convenient bottle pockets."
	icon_state = "dufflebag-virology"
	item_state = "dufflebag-virology"

/obj/item/weapon/storage/backpack/dufflebag_toxins
	name = "scientist duffle bag"
	desc = "Neat duffle bag that is designed to hold research materials."
	icon_state = "dufflebag-toxins"
	item_state = "dufflebag-toxins"

/obj/item/weapon/storage/backpack/dufflebag_genetics
	name = "geneticist duffle bag"
	desc = "Geneticist's duffle bag with convenient disk pockets."
	icon_state = "dufflebag-genetics"
	item_state = "dufflebag-genetics"

/obj/item/weapon/storage/backpack/dufflebag_chemistry
	name = "chemist duffle bag"
	desc = "It's a duffle bag designed to hold various reagents."
	icon_state = "dufflebag-chemistry"
	item_state = "dufflebag-chemistry"

/obj/item/weapon/storage/backpack/dufflebag_medical
	name = "medical duffle bag"
	desc = "An extremely convenient sterile duffle bag."
	icon_state = "dufflebag-medical"
	item_state = "dufflebag-medical"

/obj/item/weapon/storage/backpack/dufflebag_engineer
	name = "engineering duffle bag"
	desc = "Designed to fit various construction materials."
	icon_state = "dufflebag-engineering"
	item_state = "dufflebag-engineering"

/obj/item/weapon/storage/backpack/dufflebag_hydroponics
	name = "hydroponics duffle bag"
	desc = "Convenient duffle bag for plant-related work."
	icon_state = "dufflebag-hydroponics"
	item_state = "dufflebag-hydroponics"

/obj/item/weapon/storage/backpack/dufflebag_clown
	name = "fanny bag"
	desc = "It's a funny-looking duffle bag."
	icon_state = "dufflebag-clown"
	item_state = "dufflebag-clown"

/*
 * Mountain Backpack Types
 */

/obj/item/weapon/storage/backpack/mountainbag
	name = "mountain backpack"
	desc = "Usually used by mountaineers, it's quite bulky."
	icon_state = "mountainbag"
	item_state = "mountainbag"

/obj/item/weapon/storage/backpack/mountainbag_chem
	name = "chemistry backpack"
	desc = "Usually used by explorer chemists. Has a nice orange color to it."
	icon_state = "mountainbag-chem"
	item_state = "mountainbag-chem"

/obj/item/weapon/storage/backpack/mountainbag_gen
	name = "geneticist backpack"
	desc = "Usually used by explorer geneticists. Has a nice blue color to it."
	icon_state = "mountainbag-gen"
	item_state = "mountainbag-gen"

/obj/item/weapon/storage/backpack/mountainbag_tox
	name = "scientist backpack"
	desc = "Usually used by explorer scientists. Has a nice purple color to it."
	icon_state = "mountainbag-tox"
	item_state = "mountainbag-tox"

/obj/item/weapon/storage/backpack/mountainbag_vir
	name = "virologist backpack"
	desc = "Usually used by explorer virologists. Has a nice dark green color to it."
	icon_state = "mountainbag-vir"
	item_state = "mountainbag-vir"

/obj/item/weapon/storage/backpack/mountainbag_hyd
	name = "botanist backpack"
	desc = "Usually used by explorer botanists. Has a nice purple color to it."
	icon_state = "mountainbag-hyd"
	item_state = "mountainbag-hyd"

/obj/item/weapon/storage/backpack/mountainbag_med
	name = "medical backpack"
	desc = "Usually used by explorer medics. Has a nice white color to it."
	icon_state = "mountainbag-med"
	item_state = "mountainbag-med"
