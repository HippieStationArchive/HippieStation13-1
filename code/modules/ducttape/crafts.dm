/*
		ARMOR
*/

/obj/item/clothing/suit/armor/makeshift
	name = "makeshift armor"
	desc = "A hazard vest with metal plate taped on it. It offers minor protection."
	icon_state = "makeshiftarmor"
	item_state = "makeshiftarmor"
	w_class = 3
	blood_overlay_type = "armor"
	armor = list(melee = 30, bullet = 10, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/*
		WEAPONS/ITEMS
*/

/obj/item/weapon/shield/trayshield
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
	block_chance = list(melee = 60, bullet = 50, laser = 40, energy = 30) //Great at blocking incoming melee, but then again, it can break...
	blocksound = list('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg')
	var/damage_received = 0 //Amount of damage the shield has received
	var/max_damage = 60 //Amount of max damage the trayshield can withstand

/obj/item/weapon/shield/trayshield/examine(mob/user)
	..()
	var/a = max(0, max_damage - damage_received)
	if(a <= max_damage/4) //20
		user << "It's falling apart."
	else if(a <= max_damage/2) //40
		user << "It's badly damaged."
	else if(a < max_damage)
		user << "It's slightly damaged."

/obj/item/weapon/shield/trayshield/hit_reaction(mob/living/carbon/human/owner, attack_text = "the attack", final_block_chance = 0, damage = 0, type = "melee")
	if(..())
		damage_received += damage * (100-block_chance[type])/100
		if(damage_received >= max_damage)
			if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				H.visible_message("<span class='danger'>[H]'s shield breaks!</span>", "<span class='userdanger'>Your shield breaks!</span>")
				playsound(H, 'sound/effects/bang.ogg', 30, 1)
				H.unEquip(src, 1)
			spawn(1) //Delay the deletion so the code has time to work with the shield
				qdel(src)
		return 1
	return 0

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

/obj/item/weapon/melee/retractable_spear
	name = "retractable spear"
	desc = "A compact spear that can be extended. Doesn't hurt as much while retracted."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "retspear0"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwhitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	w_class = 2
	force = 7
	var/on = 0
	embed_chance = 8
	sharpness = IS_SHARP

/obj/item/weapon/melee/retractable_spear/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/internal/brain/B = H.getorgan(/obj/item/organ/internal/brain)

	user.visible_message("<span class='suicide'>[user] stuffs the [src] up their nose and presses the 'extend' button! It looks like they're trying to clear their mind.</span>")
	if(!on)
		src.attack_self(user)
	else
		playsound(loc, 'sound/weapons/batonextend.ogg', 50, 1)
		add_fingerprint(user)
	sleep(3)
	if (H && !qdeleted(H))
		if (B && !qdeleted(B))
			H.internal_organs -= B
			qdel(B)
		gibs(H.loc, H.viruses, H.dna)
		return (BRUTELOSS)
	return

/obj/item/weapon/melee/retractable_spear/attack_self(mob/user)
	on = !on
	if(on)
		user << "<span class ='warning'>You extend the baton.</span>"
		icon_state = "retspear1"
		w_class = 4 //doesnt fit in backpack when its on for balance
		force = 15 //Decent enough force
		embed_chance = 25 //Slightly increased embedchance - not as good as spears
		attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	else
		user << "<span class ='notice'>You collapse the baton.</span>"
		icon_state = "retspear0"
		slot_flags = SLOT_BELT
		w_class = 2
		force = 7
		embed_chance = 8
		attack_verb = list("stabbed", "shanked", "sliced", "cut")

	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)
