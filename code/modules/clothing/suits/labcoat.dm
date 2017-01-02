/obj/item/clothing/suit/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/melee/classic_baton/telescopic)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	permeability_coefficient = 0.40
	togglename = "buttons"

/obj/item/clothing/suit/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/toggle/labcoat/emt
	name = "EMT's jacket"
	desc = "A dark blue jacket with reflective strips for emergency medical technicians."
	icon_state = "labcoat_emt"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/toggle/labcoat/mad
	name = "\improper The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen"
	item_state = "labgreen"

/obj/item/clothing/suit/toggle/labcoat/genetics
	name = "geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen"

/obj/item/clothing/suit/toggle/labcoat/chemist
	name = "chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem"

/obj/item/clothing/suit/toggle/labcoat/virologist
	name = "virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir"

/obj/item/clothing/suit/toggle/labcoat/science
	name = "scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox"

/obj/item/clothing/suit/labcoat/chameleon //For some reason the button up button was appearing where the action button should be for this, so until someone works that out this thing cant be buttoned up I guess
	name = "labcoat"
	icon_state = "labcoat"
	item_state = "labcoat"
	desc = "A reinforced labcoat that protects against much more than a minor chemical spill. Has a small dial inside it."
	action_button_name = "Change"
	origin_tech = "syndicate=2"
	armor = list(melee = 35, bullet = 15, laser = 15, energy = 0, bomb = 0, bio = 50, rad = 0) //real armor is still better
	var/list/clothing_choices = list()
	permeability_coefficient = 0.01 //Defends against viruses perfectly, when combined with white shoes, latex gloves, and a medical mask.
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/suit/labcoat/chameleon/New()
	..()
	for(var/U in typesof(/obj/item/clothing/suit/toggle/labcoat)-(/obj/item/clothing/suit/toggle/labcoat))
		var/obj/item/clothing/suit/toggle/V = new U
		src.clothing_choices += V
	return

/obj/item/clothing/suit/labcoat/chameleon/attack_self()
	set src in usr

	var/obj/item/clothing/suit/toggle/labcoat/A
	A = input("Select Design to change it to", "BOOYEA", A) in clothing_choices
	if(!A)
		return

	if(usr.stat != CONSCIOUS)
		return

	desc = null

	desc = A.desc
	name = A.name
	icon_state = A.icon_state
	item_state = A.item_state
	usr.update_inv_wear_suit()	//so our overlays update.
