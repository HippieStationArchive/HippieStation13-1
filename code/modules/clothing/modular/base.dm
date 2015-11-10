/*
This is the base file for Modular Armour, the reason for this being here is so it can be easily disabled and shit like that without filling the other files with my shit. Will eventually seperate into DMs for code cleanup purposes
*/
//Procs
/obj/item/clothing/suit/armor/modular/New()
	MakeParts()
	..()
/obj/item/clothing/suit/armor/modular/Destroy()
	if(helmet)
		helmet.suit = null
		shoes.suit = null
		gloves.suit = null
		qdel(helmet)
		qdel(shoes)
		qdel(gloves)
	return ..()

/obj/item/clothing/head/helmet/modular/Destroy()
	if(suit)
		suit.helmet = null
		qdel(suit)
	return ..()

/obj/item/clothing/shoes/modular/Destroy()
	if(suit)
		suit.shoes = null
		qdel(suit)
	return ..()

/obj/item/clothing/gloves/modular/Destroy()
	if(suit)
		suit.shoes = null
		qdel(suit)
	return ..()

/obj/item/clothing/suit/armor/modular/proc/MakeParts()
	if(!helmettype)
		return
	if(!helmet)
		var/obj/item/clothing/head/helmet/modular/W = new helmettype(src)
		W.suit = src
		helmet = W
	if(!shoes)
		var/obj/item/clothing/shoes/modular/X = new shoetype(src)
		X.suit = src
		shoes = X
	if(!gloves)
		var/obj/item/clothing/gloves/modular/Z = new glovetype(src)
		Z.suit = src
		gloves = Z

/obj/item/clothing/suit/armor/modular/ui_action_click()
	..()
	ToggleSystem()

/obj/item/clothing/suit/armor/modular/equipped(mob/user, slot)
	if(!helmettype || !glovetype || !shoetype)
		return
	if(slot != slot_wear_suit)
		RemoveParts()
	..()

/obj/item/clothing/suit/armor/modular/proc/RemoveParts()
	if(!helmet)
		return
	suittoggled = 0
	if(ishuman(helmet.loc))
		var/mob/living/carbon/H = helmet.loc
		if(helmet.on || shoes.on || gloves.on)
			helmet.attack_self(H)
			shoes.attack_self(H)
			gloves.attack_self(H)
		H.unEquip(helmet, 1)
		H.unEquip(gloves, 1)
		H.unEquip(shoes, 1)
		H.update_inv_wear_suit()
	helmet.loc = src
	shoes.loc = src
	gloves.loc = src

/obj/item/clothing/suit/armor/modular/dropped()
	RemoveParts()

/obj/item/clothing/suit/armor/modular/proc/ToggleSystem()
	var/mob/living/carbon/human/H = src.loc
	if(!helmettype || !shoetype || !glovetype)
		return
	if(!suittoggled)
		if(ishuman(src.loc))
			if(H.wear_suit != src)
				H << "<span class='warning'>You must be wearing [src] to engage the suit!</span>"
				return
			if(H.head || H.shoes || H.gloves)
				H << "<span class='warning'>You're already wearing something on your head, feet, and/or hands!</span>"
				return
			else
				H << "<span class='notice'>You engage the suit's systems!.</span>"
				H.equip_to_slot_if_possible(helmet,slot_head,0,0,1)
				H.equip_to_slot_if_possible(gloves,slot_gloves,0,0,1)
				H.equip_to_slot_if_possible(shoes,slot_shoes,0,0,1)
				suittoggled = 1
				H.update_inv_wear_suit()
				playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	else
		H << "<span class='notice'>You disengage [src]</span>"
		playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
		RemoveParts()

//Armor shit
/obj/item/clothing/gloves/modular
	name = "Modular Gloves"
	desc = "A pair of modular gloves, can't be detached from the modular suit."
	icon_state = "leather"
	item_state = "ggloves"
	burn_state = -1 //Not Burnable
	var/on = 0
	flags = NODROP
	var/obj/item/clothing/suit/armor/modular/suit

/obj/item/clothing/shoes/modular
	desc = "A pair of modular shoes, can't be detached from the modular suit."
	name = "Modular Shoes"
	icon_state = "brown"
	item_state = "brown"
	burn_state = -1 //Won't burn in fires
	var/on = 0
	var/obj/item/clothing/suit/armor/modular/suit
	flags = NODROP

/obj/item/clothing/head/helmet/modular
	name = "Modular Helmet"
	desc = "A modular helmet, can't be detached from the modular suit."
	icon_state = "hardsuit0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 4, bullet = 5, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	item_color = "engineering"
	burn_state = -1
	var/on = 0
	var/obj/item/clothing/suit/armor/modular/suit
	flags = BLOCKHAIR | THICKMATERIAL | NODROP

/obj/item/clothing/suit/armor/modular
	name = "armor"
	desc = "An empty modular vest."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	origin_tech = "combat=3"
	armor = list(melee = 5, bullet = 5, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	var/maxplates = 2//Plate max
	var/obj/item/clothing/shoes/modular/shoes
	var/obj/item/clothing/head/helmet/modular/helmet
	var/obj/item/clothing/gloves/modular/gloves
	var/helmettype = /obj/item/clothing/head/helmet/modular
	var/shoetype = /obj/item/clothing/shoes/modular
	var/glovetype = /obj/item/clothing/gloves/modular
	action_button_name = "Toggle Suit"
	var/internalcell =

/obj/item/clothing/suit/armor/modular/heavy
	name = "armor"
	desc = "A heavy, empty modular vest."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	origin_tech = "combat=5"
	armor = list(melee = 10, bullet = 10, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	maxplates = 3