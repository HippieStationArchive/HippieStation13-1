/obj/item/clothing/suit/armor/makeshift
	name = "makeshift armor"
	desc = "A hazard vest with metal plate taped on it. It offers some protection, however it slows you down."
	icon_state = "metalarmor"
	item_state = "metalarmor"
	w_class = 3
	slowdown = 1
	blood_overlay_type = "armor"
	armor = list(melee = 30, bullet = 10, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/suit/hazardvest/attackby(obj/item/W as obj, mob/user as mob)
	..()