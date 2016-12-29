//Cloaks. No, not THAT kind of cloak.

/obj/item/weapon/storage/backpack/cloak
	name = "brown cloak"
	desc = "Worn by The Owl, an outdated hero who once robusted griffons who threatened the station. Will you take up the mantle?"
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "qmcloak"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	w_class = 4
	slot_flags = SLOT_BACK
	armor =              list(melee = 15, bullet = 15, laser = 15, energy = 10, bomb = 30, bio = 20, rad = 20)
	var/armor_backslot = list(melee = 15, bullet = 15, laser = 15, energy = 10, bomb = 30, bio = 20, rad = 20)//To minimise stacking the damn thing with the hardsuit to be pretty resistant to stuns.
	var/armor_exoslot =  list(melee = 30, bullet = 30, laser = 30, energy = 10, bomb = 60, bio = 40, rad = 30)//This was debatably better armour than the hardsuit alone, it's just stacking it with the armour made it "worse".
	var/adjusted = 0
	max_w_class = 3
	max_combined_w_class = 15
	storage_slots = 15

/obj/item/weapon/storage/backpack/cloak/proc/adjust(mob/user)
	if(src.adjusted == 1)
		user << "<span class='notice'>You loosen \the [src], allowing you to wear it as a cape.</span>"
		adjusted = 0
		slot_flags = SLOT_BACK
		armor = armor_backslot
		max_w_class = 3
		max_combined_w_class = 15
		storage_slots = 15

	else // Exosuit form
		if(contents.len > 0)
			user << "<span class='notice'>You can't adjust \the [src] while it has items inside.</span>"
		else
			user << "<span class='notice'>You tighten \the [src], increasing it's defensive capabilities.</span>"
			adjusted = 1
			slot_flags = SLOT_OCLOTHING
			armor = armor_exoslot
			max_w_class = 2
			max_combined_w_class = 4
			storage_slots = 4



/obj/item/weapon/storage/backpack/cloak/attack_self(mob/user)
	adjust(user)

/obj/item/weapon/storage/backpack/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling themself with [src]! It looks like they're trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/weapon/storage/backpack/cloak/qm
	name = "quartermaster's cloak"
	desc = "Worn by Cargonia, supplying the station with the necessary tools for survival. Smells like failed revolutions."

/obj/item/weapon/storage/backpack/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "Worn by Meditopia, the valiant men and women keeping pestilence at bay. Smells sterile."
	icon_state = "cmocloak"
	permeability_coefficient = 0.05
	armor =          list(melee = 20, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 40, rad = 15)
	armor_backslot = list(melee = 20, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 40, rad = 15)
	armor_exoslot =  list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 80, rad = 30)
	flags = THICKMATERIAL

/obj/item/weapon/storage/backpack/cloak/ce
	name = "chief engineer's cloak"
	desc = "Worn by Engitopia, wielders of an unlimited power. Smells like asbestos and lead."
	icon_state = "cecloak"
	armor =          list(melee = 20, bullet = 0, laser = 10, energy = 10, bomb = 15, bio = 0, rad = 40)
	armor_backslot = list(melee = 20, bullet = 0, laser = 10, energy = 10, bomb = 15, bio = 0, rad = 40)
	armor_exoslot =  list(melee = 40, bullet = 0, laser = 20, energy = 20, bomb = 30, bio = 0, rad = 80)
	burn_state = -1
	gas_transfer_coefficient = 0.1
	heat_protection = CHEST|ARMS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/weapon/storage/backpack/cloak/rd
	name = "research director's cloak."
	desc = "Worn by Sciencia, thaumaturges and researchers of the universe. Smells like plasma, napalm, and victory."
	icon_state = "rdcloak"
	armor =          list(melee = 0, bullet = 0, laser = 0, energy = 25, bomb = 30, bio = 30, rad = 0)
	armor_backslot = list(melee = 0, bullet = 0, laser = 0, energy = 25, bomb = 30, bio = 30, rad = 0)
	armor_exoslot =  list(melee = 0, bullet = 0, laser = 0, energy = 50, bomb = 60, bio = 60, rad = 0)
	burn_state = -1
	permeability_coefficient = 0.5
	gas_transfer_coefficient = 0.2
	heat_protection = CHEST|ARMS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/weapon/storage/backpack/cloak/hos
	name = "head of security's cloak"
	desc = "Worn by Securistan, ruling the station with an iron fist. Smells robust."
	icon_state = "hoscloak"
	armor =          list(melee = 30, bullet = 13, laser = 25, energy = 8, bomb = 20, bio = 0, rad = 0)
	armor_backslot = list(melee = 30, bullet = 13, laser = 25, energy = 8, bomb = 20, bio = 0, rad = 0)
	armor_exoslot =  list(melee = 50, bullet = 20, laser = 40, energy = 12, bomb = 30, bio = 0, rad = 0) //greatcoat is 50, 30, 50, 10, 25, 0, 0

/obj/item/weapon/storage/backpack/cloak/cap
	name = "captain's cloak"
	desc = "Worn by the commander of Space Station 13. Smells like failure."
	icon_state = "capcloak"
	armor =          list(melee = 25, bullet = 20, laser = 25, energy = 13, bomb = 20, bio = 20, rad = 20)
	armor_backslot = list(melee = 25, bullet = 20, laser = 25, energy = 13, bomb = 20, bio = 20, rad = 20)
	armor_exoslot =  list(melee = 40, bullet = 30, laser = 40, energy = 20, bomb = 30, bio = 30, rad = 30) //carapace is 50, 40, 50, 10, 25, 0, 0
	cold_protection = CHEST|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	permeability_coefficient = 0.4

/* //wip
/obj/item/clothing/cloak/wizard //Not actually obtainable until proper balancing can be done
	name = "cloak of invisibility"
	desc = "A tattered old thing that apparently gifts the wearer with near-invisibility."
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 10, rad = 10)
	action_button_name = "Flaunt Cloak"
	var/invisible = 0

/obj/item/clothing/cloak/wizard/ui_action_click()
	toggleInvisibility(usr)
	return

/obj/item/clothing/cloak/wizard/proc/toggleInvisibility(mob/user)
	if(user.slot_back != src)
		user << "<span class='warning'>You need to be wearing the cloak first!</span>"
		return
	user.visible_message("<span class='notice'>[user] flaunts [src]!</span>")
	if(!invisible)
		makeInvisible(user)
		return
	if(invisible)
		breakInvisible(user)
		return

/obj/item/clothing/cloak/wizard/proc/makeInvisible(mob/user)
	if(!invisible)
		user.visible_message("<span class='warning'>[user] suddenly fades away!</span>", \
							 "<span class='notice'>You have become nearly invisible. This will require slow movement and will break upon taking damage.</span>")
		flags |= NODROP //Cannot unequip while invisible
		user.alpha = 10
		slowdown = 2
		invisible = 1

/obj/item/clothing/cloak/wizard/proc/breakInvisible(mob/user)
	if(invisible)
		user.visible_message("<span class='warning'>[user] suddenly appears from thin air!</span>", \
							 "<span class='warning'>The enchantment has broken! You are visible again.</span>")
		flags -= NODROP
		user.alpha = 255
		slowdown = 0
		invisible = 0

/obj/item/clothing/cloak/wizard/IsShield()
	breakInvisible(src.loc)
	return 0

/obj/item/clothing/cloak/wizard/IsReflect()
	breakInvisible(src.loc)
	return 0
*/