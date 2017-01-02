/obj/item/weapon/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	flags = CONDUCT
	force = 8
	stamina_percentage = 0.5
	hitsound = "swing_hit"
	throw_speed = 2
	throw_range = 4
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 21
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	burn_state = 0 //Burnable
	burntime = 20

/obj/item/weapon/storage/briefcase/New()
	..()
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/pen(src)

/obj/item/weapon/storage/briefcase/sniperbundle
	name = "briefcase"
	desc = "It's label reads genuine hardened Captain leather, but suspiciously has no other tags or branding. Smells like L'Air du Temps."
	icon_state = "briefcase"
	flags = CONDUCT
	force = 10
	hitsound = "swing_hit"
	throw_speed = 2
	throw_range = 4
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 21
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	burn_state = 0
	burntime = 20

/obj/item/weapon/storage/briefcase/sniperbundle/New()
	..()
	new /obj/item/weapon/gun/projectile/sniper_rifle(src)
	new /obj/item/clothing/tie/red(src)
	new /obj/item/clothing/under/syndicate/sniper(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/soporific(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/he(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)
	new /obj/item/weapon/suppressor(src)
