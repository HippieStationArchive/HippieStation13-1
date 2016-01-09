//Bomb Vest		-	Commenting this whole thing out because I can't get it working but I'd rather not throw all the work away. If someone feels like looking at it and fixing it up, that'd be great.
/*

/obj/item/device/bombvest
	name = "bomb vest"
	desc = "If you're wearing this, you're either suicidal or in a really bad position. Seems to have an auto-locking mechanism which will prevent the wearer from removing it."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "bombvest"
	item_state = "bombvest"
	body_parts_covered = CHEST|GROIN
	flags_inv = null
	slot_flags = slot_wear_suit
	w_class = 3
	strip_delay = 120
	var/vest_id = 0

/obj/item/device/bombvest/proc/detonate_vest()
	playsound(src, 'sound/weapons/armbomb.ogg', 80)
	spawn(50)
		explosion(get_turf(src),3,6,14, flame_range = 15)

/obj/item/device/bombvest/attack_hand()
	var/mob/living/carbon/human/user = src.loc
	if(user && ishuman(user) && (user.wear_suit == src))
		user << "<span class='warning'>You need help taking this off!</span>"
		return
	..()

/obj/item/device/bombvest/proc/action_button_detonate(mob/user = null)
	action_button_name = "Detonate Bomb Vest"
	user.visible_message("<span class='italics'>[user] pushes a button on the [src]! Now seems to be a good time to run!</span>")
	user.emote("scream")
	spawn(10)
		user.visible_message("<span class='italics'>The [src] starts beeping!</span>")
		playsound(src, 'sound/weapons/armbomb.ogg', 80)
		spawn(50)
			explosion(get_turf(src),3,6,17, flame_range = 15)

/obj/item/device/bombvest/suicide_act(user)
	var/mob/living/carbon/human/H = user
	H.visible_message("<span class='italics'>[user] pushes a button on the [src]! Now seems to be a good time to run!</span>")
	H.emote("scream")
	spawn(10)
		H.visible_message("<span class='italics'>The [src] starts beeping!</span>")
		detonate_vest()

/obj/item/device/bombvest/attackby(obj/item/W, mob/user, params)
	var/obj/item/device/multitool/M = W, var/obj/item/device/bombvest/V
	if(M.buffer && istype(M.buffer, /obj/item/device/bombvest))
		V.vest_id = M.buffer
		M.buffer = null
		user << "<span class='caution'>You upload the data from the [W.name]'s buffer.</span>"
	else
		..()


//Bomb Vest Detonator

/obj/item/device/vestdetonator
	name = "barcode scanner"
	icon = 'icons/obj/library.dmi'
	icon_state ="scanner"
	throw_speed = 3
	throw_range = 5
	w_class = 1
	origin_tech = "syndicate=2"
	var/detonator_id = null

/obj/item/device/vestdetonator/New()
	detonator_id = rand(1,200)
	..()

/obj/item/device/vestdetonator/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = I
		M.buffer = src.detonator_id
		user << "<span class='caution'>You save the [src.name]'s ID in the [I.name]'s buffer.</span>"

/obj/item/device/vestdetonator/attack_self(user)
	for(var/obj/item/device/bombvest/B in items)
	add_fingerprint(user)
	playsound(loc, 'sound/weapons/empty.ogg', 50)
	if(B.vest_id == detonator_id)
		B.detonate_vest()
		user << "<span class='notice'>Bomb vest found and detonated.</span>"
		var/turf/T = get_turf(src)
		var/area/A = get_area(T)
		var/log_str = "[key_name_admin(user)]<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) has remotely detonated a [B.name] using a [name] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>[A.name] (JMP)</a>."
		bombers += log_str
		message_admins(log_str)
		log_game("[key_name(user)] has remotely detonated a [B.name] using a [name] at [A.name]([T.x],[T.y],[T.z])")

*/