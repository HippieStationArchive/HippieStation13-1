/* Misc. Stuff!!
 * Contains:
 *		Duct Tape
 */

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

/obj/item/stack/ducttape/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is taping \his entire face with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/*
 * Crafting recipes below
 */

/obj/item/stack/ducttape/afterattack(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/shard))
		var/obj/item/weapon/shank/new_item = new(user.loc)
		user << "<span class='notice'>You use [src] to turn [W] into [new_item].</span>"
		var/replace = (user.get_inactive_hand()==W)
		qdel(W)
		src.use(1)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/New_Sound/items/ducttape1.ogg', 50, 1)
	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/weapon/tapedmetal/new_item = new(user.loc)
		user << "<span class='notice'>You strap [src] to the [W].</span>"
		var/obj/item/stack/sheet/metal/R = W
		W = null
		R.use(1)
		if(src.use(4) == 0)
			qdel(src)
		var/replace = (user.get_inactive_hand()==R)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/New_Sound/items/ducttape1.ogg', 50, 1)

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
		playsound(user, 'sound/New_Sound/items/ducttape1.ogg', 50, 1)*/

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
// 		playsound(user, 'sound/New_Sound/items/ducttape1.ogg', 50, 1)

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

/obj/item/clothing/suit/hazardvest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/tapedmetal))
		var/obj/item/clothing/suit/armor/makeshift/new_item = new(user.loc)
		user << "<span class='notice'>You use [W] to turn [src] into [new_item].</span>"
		var/replace = (user.get_inactive_hand()==src)
		qdel(W)
		qdel(src)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/New_Sound/items/ducttape1.ogg', 50, 1)
		return

/obj/item/weapon/tapedmetal/attack_self(mob/user)
	playsound(user, 'sound/New_Sound/items/ducttape2.ogg', 50, 1)
	var/obj/item/stack/sheet/metal/new_item = new(user.loc)
	user << "<span class='notice'>You take the duct tape off the [src].</span>"
	qdel(src)
	user.put_in_hands(new_item)