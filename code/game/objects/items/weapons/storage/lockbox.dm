//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 4
	req_access = list(access_armory)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


/obj/item/weapon/storage/lockbox/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if (W.GetID())
		if(src.broken)
			user << "<span class='danger'>It appears to be broken.</span>"
			return
		if(src.allowed(user))
			src.locked = !( src.locked )
			if(src.locked)
				src.icon_state = src.icon_locked
				user << "<span class='danger'>You lock the [src.name]!</span>"
				return
			else
				src.icon_state = src.icon_closed
				user << "<span class='danger'>You unlock the [src.name]!</span>"
				return
		else
			user << "<span class='danger'>Access Denied.</span>"
			return
	else if(istype(W, /obj/item/weapon/melee/energy/blade) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		visible_message("<span class='notice'>[user] has sliced open \the [src] with an energy blade!</span>", "<span class='danger'>You hear metal being sliced and sparks flying.</span>")
		return
	if(!locked)
		..()
	else
		user << "<span class='danger'>It's locked!</span>"
	return

/obj/item/weapon/storage/lockbox/emag_act(mob/user as mob)
	if(!broken)
		broken = 1
		locked = 0
		desc += "It appears to be broken."
		icon_state = src.icon_broken
		for(var/mob/O in viewers(user, 3))
			O.show_message(text("<span class='notice'>\The [src] has been broken by [] with an electromagnetic card!</span>", user), 1, text("You hear a faint electrical spark."), 2)
			return
/obj/item/weapon/storage/lockbox/show_to(mob/user as mob)
	if(locked)
		user << "<span class='danger'>It's locked!</span>"
	else
		..()
	return

/obj/item/weapon/storage/lockbox/can_be_inserted(obj/item/W, stop_messages = 0)
	if(locked)
		return 0
	return ..()

/obj/item/weapon/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)

/obj/item/weapon/storage/lockbox/loyalty/New()
	..()
	new /obj/item/weapon/implantcase/loyalty(src)
	new /obj/item/weapon/implantcase/loyalty(src)
	new /obj/item/weapon/implantcase/loyalty(src)
	new /obj/item/weapon/implanter/loyalty(src)


/obj/item/weapon/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)

/obj/item/weapon/storage/lockbox/clusterbang/New()
	..()
	new /obj/item/weapon/grenade/flashbang/clusterbang(src)

/obj/item/weapon/storage/lockbox/medal
	name = "medal box"
	desc = "A locked box used to store medals of honor."
	icon_state = "medalbox+l"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 2
	storage_slots = 6
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"

/obj/item/weapon/storage/lockbox/medal/New()
	..()
	new /obj/item/clothing/tie/medal/silver/valor(src)
	new /obj/item/clothing/tie/medal/bronze_heart(src)
	new /obj/item/clothing/tie/medal/conduct(src)
	new /obj/item/clothing/tie/medal/conduct(src)
	new /obj/item/clothing/tie/medal/conduct(src)
	new /obj/item/clothing/tie/medal/gold/captain(src)