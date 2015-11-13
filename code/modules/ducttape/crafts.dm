/*
		ARMOR
*/

/obj/item/clothing/suit/armor/makeshift
	name = "makeshift armor"
	desc = "A hazard vest with metal plate taped on it. It offers some protection, however it slows you down."
	icon_state = "metalarmor"
	item_state = "metalarmor"
	w_class = 3
	slowdown = 1
	blood_overlay_type = "armor"
	armor = list(melee = 30, bullet = 10, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/*
		WEAPONS/ITEMS
*/

/obj/item/weapon/shield/riot/trayshield
	name = "tray shield"
	desc = "A makeshift shield that won't last for long."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "trayshield"
	slot_flags = null //SLOT_BACK
	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = 4
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")

/obj/item/weapon/shield/riot/trayshield/IsShield()
	if(prob(30))
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			visible_message("<span class='warning'>[H]'s shield breaks!</span>", "<span class='warning'>Your shield breaks!</span>")
			H.unEquip(src, 1)
		spawn(1) //Delay the deletion so the code has time to work with the shield
			qdel(src)
	return 1

/obj/item/weapon/storage/bag/tray/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/ducttape))
		return
	..()

/obj/item/weapon/shank
	name = "shank"
	desc = "A nasty looking shard of glass. There's duct tape over one of the ends."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "shank"
	w_class = 2.0
	force = 10.0 //Average force
	throwforce = 10.0
	item_state = "shard-glass"
	g_amt = MINERAL_MATERIAL_AMOUNT
	attack_verb = list("stabbed", "shanked", "sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	siemens_coefficient = 0 //Means it's insulated
	embed_chance = 10
	sharpness = IS_SHARP

/obj/item/weapon/shank/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is slitting \his wrists with the shank! It looks like \he's trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is slitting \his throat with the shank! It looks like \he's trying to commit suicide.</span>"))
	return (BRUTELOSS)

/obj/item/weapon/shank/attack_self(mob/user)
	playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
	var/obj/item/weapon/shard/new_item = new(user.loc)
	user << "<span class='notice'>You take the duct tape off the [src].</span>"
	qdel(src)
	user.put_in_hands(new_item)