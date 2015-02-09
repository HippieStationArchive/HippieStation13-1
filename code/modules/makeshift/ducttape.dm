/* Misc. Stuff!!
 * Contains:
 *		Duct Tape
 */

/obj/item/clothing/mask/muzzle/tape
	name = "tape"
	desc = "Taking that off is going to hurt."
	icon_state = "tape"
	item_state = "tape"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	put_on_delay = 20
	strip_delay = 10
	var/used = 0

/obj/item/clothing/mask/muzzle/tape/attack_hand(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		return ..()
	var/mob/living/carbon/human/H = user
	if(loc == user && H.wear_mask == src)
		qdel(src)
		user << "<span class='danger'>You take off the duct tape. It's not pleasant.</span>"
		playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
		H.apply_damage(2, BRUTE, "head")
	else
		..()

/obj/item/clothing/mask/muzzle/tape/dropped(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		return ..()
	var/mob/living/carbon/human/H = user
	..()
	if(H.wear_mask == src && !src.used)
		user << "<span class='danger'>Your tape was forcefully removed from your mouth. It's not pleasant.</span>"
		playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
		H.apply_damage(2, BRUTE, "head")
		src.used = 1
		src.desc = "This one appears to be used."
		user.drop_item()
		qdel(src)
		// H.wear_mask = null
		// H.unEquip(src, 1)
		// user.update_inv_wear_mask(0)

/obj/item/stack/ducttape
	desc = "It's duct tape. You can use it to tape something... or someone."
	name = "duct tape"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	item_state = "tape"
	amount = 15
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 7
	m_amt = 10
	noAction = 1

/obj/item/stack/ducttape/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is taping \his entire face with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/*
 * Crafting recipes below
 */

/obj/item/stack/ducttape/afterattack(W, mob/user as mob)
	if(istype(W, /obj/item/weapon/shard))
		var/obj/item/weapon/shank/new_item = new(user.loc)
		user << "<span class='notice'>You use [src] to turn [W] into [new_item].</span>"
		var/replace = (user.get_inactive_hand()==W)
		qdel(W)
		src.use(1)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/items/ducttape1.ogg', 50, 1)

	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/weapon/tapedmetal/new_item = new(user.loc)
		user << "<span class='notice'>You strap [src] to the [W].</span>"
		var/obj/item/stack/sheet/metal/R = W
		W = null
		R.use(1)
		if(src.use(6) == 0)
			user.drop_item()
			qdel(src)
		var/replace = (user.get_inactive_hand()==R)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/items/ducttape1.ogg', 50, 1)

	if(istype(W, /obj/item/weapon/storage/bag/tray))
		var/obj/item/weapon/shield/riot/trayshield/new_item = new(user.loc)
		user << "<span class='notice'>You strap [src] to the [W].</span>"
		var/replace = (user.get_inactive_hand()==W)
		qdel(W)
		if(src.use(3) == 0)
			user.drop_item()
			qdel(src)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/items/ducttape1.ogg', 50, 1)

	if(ishuman(W) && (user.zone_sel.selecting == "mouth" || user.zone_sel.selecting == "head"))
		var/mob/living/carbon/human/H = W
		if( \
				(H.head && H.head.flags & HEADCOVERSMOUTH) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH) \
			)
			user << "<span class='danger'>You're going to need to remove that mask/helmet first.</span>"
			return
		playsound(loc, 'sound/items/ducttape1.ogg', 30, 1)
		if(do_mob(user, H, 20))
			// H.wear_mask = new/obj/item/clothing/mask/muzzle/tape(H)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)
			user << "<span class='notice'>You tape [H]'s mouth.</span>"
			playsound(loc, 'sound/items/ducttape1.ogg', 50, 1)
			if(src.use(2) == 0)
				user.drop_item()
				qdel(src)
			add_logs(user, H, "mouth-taped")
		else
			user << "<span class='warning'>You fail to tape [H]'s mouth.</span>"



/*/obj/item/weapon/shard/attackby(obj/item/stack/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/stack/ducttape))
		var/obj/item/weapon/shank/new_item = new(user.loc)
		user << "<span class='notice'>You use [W] to turn [src] into [new_item].</span>"
		var/replace = (user.get_inactive_hand()==src)
		qdel(src)
		W.use(1)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/items/ducttape1.ogg', 50, 1)*/

// /obj/item/stack/sheet/metal/attackby(obj/item/stack/W, mob/user as mob)
// 	..()
// 	if(istype(W, /obj/item/stack/ducttape))
// 		var/obj/item/weapon/tapedmetal/new_item = new(user.loc)
// 		user << "<span class='notice'>You strap [W] to the [src].</span>"
// 		var/obj/item/stack/sheet/metal/R = src
// 		src = null
// 		R.use(1)
// 		if(W.use(4) == 0)
// 			qdel(W)
// 		var/replace = (user.get_inactive_hand()==R)
// 		if(replace)
// 			user.put_in_hands(new_item)
// 		playsound(user, 'sound/items/ducttape1.ogg', 50, 1)

/obj/item/weapon/tapedmetal
	name = "taped metal sheet"
	desc = "A metal sheet with tape over it. Can be used for something."
	w_class = 3.0
	force = 5
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	icon = 'icons/new/makeshift.dmi'
	icon_state = "tapedmetal"

/obj/item/weapon/tapedmetal/attack_self(mob/user)
	playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
	var/obj/item/stack/sheet/metal/new_item = new(user.loc)
	user << "<span class='notice'>You take the duct tape off the [src].</span>"
	qdel(src)
	user.put_in_hands(new_item)