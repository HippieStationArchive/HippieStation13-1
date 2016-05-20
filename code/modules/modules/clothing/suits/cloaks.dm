//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/suit/cloak
	name = "brown cloak"
	desc = "Worn by The Owl, an outdated hero who once robusted griffons who threatened the station. Will you take up the mantle?"
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "qmcloak"
	w_class = 2
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/cloak/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling themself with [src]! It looks like they're trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/clothing/suit/cloak/hos
	name = "head of security's cloak"
	desc = "Worn by Securistan, ruling the station with an iron fist. Smells robust."
	icon_state = "hoscloak"
	armor = list(melee = 30, bullet = 30, laser = 10, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/cloak/qm
	name = "quartermaster's cloak"
	desc = "Worn by Cargonia, supplying the station with the necessary tools for survival. Smells like failed revolutions."

/obj/item/clothing/suit/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "Worn by Meditopia, the valiant men and women keeping pestilence at bay. Smells sterile."
	icon_state = "cmocloak"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 10)

/obj/item/clothing/suit/cloak/ce
	name = "chief engineer's cloak"
	desc = "Worn by Engitopia, wielders of an unlimited power. Smells like asbestos and lead."
	icon_state = "cecloak"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 10)
	burn_state = -1

/obj/item/clothing/suit/cloak/rd
	name = "research director's cloak."
	desc = "Worn by Sciencia, thaumaturges and researchers of the universe. Smells like plasma, napalm, and victory."
	icon_state = "rdcloak"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 0, rad = 10)
	burn_state = -1

/obj/item/clothing/suit/cloak/cap
	name = "captain's cloak"
	desc = "Worn by the commander of Space Station 13. Smells like failure."
	icon_state = "capcloak"
	armor = list(melee = 30, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 10, rad = 10)

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
