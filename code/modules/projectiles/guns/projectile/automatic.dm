/obj/item/weapon/gun/projectile/automatic
	name = "prototype SMG"
	desc = "A prototype three-round burst 9mm submachine gun, designated 'SABR'. Has a threaded barrel for suppressors."
	icon_state = "saber"
	w_class = 3
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/smgm9mm
	var/alarmed = 0
	can_suppress = 1
	burst_size = 3
	fire_delay = 1
	var/select = 0
	action_button_name = "Toggle Fire Mode"

/obj/item/weapon/gun/projectile/automatic/update_icon()
	..()
	overlays.Cut()
	if(!select)
		overlays += "[initial(icon_state)]semi"
	if(select == 1)
		overlays += "[initial(icon_state)]burst"
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/attackby(var/obj/item/A as obj, mob/user as mob)
	if(..() && chambered)
		alarmed = 0

/obj/item/weapon/gun/projectile/automatic/ui_action_click()
	burst_select()

/obj/item/weapon/gun/projectile/automatic/verb/burst_select()
	set name = "Toggle Fire Mode"
	set category = "Object"
	set desc = "Click to switch fire modes."
	var/mob/living/carbon/human/user = usr
	if(select)
		select = 0
		burst_size = 1
		fire_delay = 0
		user << "<span class='notice'>You switch to semi-automatic.</span>"
	else
		select = 1
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		user << "<span class='notice'>You switch to [burst_size]-rnd burst.</span>"

	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/can_shoot()
	return get_ammo()

/obj/item/weapon/gun/projectile/automatic/proc/empty_alarm()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(src.loc, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/c20r
	name = "syndicate SMG"
	desc = "A bullpup two-round burst .45 SMG, designated 'C-20r'. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/smgm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	fire_delay = 2
	burst_size = 2

/obj/item/weapon/gun/projectile/automatic/c20r/New()
	..()
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/c20r/afterattack()
	..()
	empty_alarm()
	return

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	icon_state = "c20r[magazine ? "-[Ceiling(get_ammo(0)/4)*4]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/ak922
	name = "AK-922"
	desc = "A New-Russia standard-issue battle rifle chambered in 7.62x39mm. Packs a punch and is built out of strong materials with an old yet reliable build."
	icon_state = "ak922"
	item_state = "c20r"
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_box/magazine/ak922
	can_suppress = 0
	fire_sound = 'sound/weapons/handcannon.ogg'
	fire_delay = 1
	burst_size = 3

/obj/item/weapon/gun/projectile/automatic/ak922/afterattack()
	..()
	empty_alarm()
	return

/obj/item/weapon/gun/projectile/automatic/ak922/update_icon()
	..()
	icon_state = "ak922[magazine ? "-[Ceiling(get_ammo(0)/5)*5]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/l6_saw
	name = "syndicate LMG"
	desc = "A heavily modified 7.62 light machine gun, designated 'L6 SAW'. Has 'Aussec Armoury - 2531' engraved on the reciever below the designation."
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 5
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m762
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	var/cover_open = 0
	can_suppress = 0
	burst_size = 1
	fire_delay = 0

/obj/item/weapon/gun/projectile/automatic/l6_saw/burst_select()
	return


/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_self(mob/user as mob)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()


/obj/item/weapon/gun/projectile/automatic/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][magazine ? Ceiling(get_ammo(0)/12.5)*25 : "-empty"]"


/obj/item/weapon/gun/projectile/automatic/l6_saw/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	if(cover_open)
		user << "<span class='notice'>[src]'s cover is open! Close it before firing!</span>"
	else
		..()
		update_icon()


/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_hand(mob/user as mob)
	if(loc != user)
		..()
		return	//let them pick it up
	if(!cover_open || (cover_open && !magazine))
		..()
	else if(cover_open && magazine)
		//drop the mag
		magazine.update_icon()
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine = null
		update_icon()
		user << "<span class='notice'>You remove the magazine from [src].</span>"


/obj/item/weapon/gun/projectile/automatic/l6_saw/attackby(var/obj/item/A as obj, mob/user as mob)
	if(!cover_open)
		user << "<span class='notice'>[src]'s cover is closed! You can't insert a new mag!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/abzats
	name = "Abzats shotgun machinegun"
	desc = "A heavily modified L6 SAW, the parts have been swapped out and others reinforced to be able to fire 12 gauge shotgun shells."
	icon_state = "abzatsclosed100"
	item_state = "l6closedmag"
	w_class = 5
	slot_flags = 0
	origin_tech = "combat=5;materials=3;syndicate=4"
	mag_type = /obj/item/ammo_box/magazine/mbox12g
	fire_sound = 'sound/weapons/shotgun_shoot.ogg'
	var/cover_open = 0
	can_suppress = 0
	burst_size = 2
	fire_delay = 1

/obj/item/weapon/gun/projectile/automatic/abzats/burst_select()
	return


/obj/item/weapon/gun/projectile/automatic/abzats/attack_self(mob/user as mob)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()


/obj/item/weapon/gun/projectile/automatic/abzats/update_icon()
	icon_state = "abzats[cover_open ? "open" : "closed"][magazine ? Ceiling(get_ammo(0)/12.5)*25 : "-empty"]"


/obj/item/weapon/gun/projectile/automatic/abzats/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	if(cover_open)
		user << "<span class='notice'>[src]'s cover is open! Close it before firing!</span>"
	else
		..()
		update_icon()


/obj/item/weapon/gun/projectile/automatic/abzats/attack_hand(mob/user as mob)
	if(loc != user)
		..()
		return	//let them pick it up
	if(!cover_open || (cover_open && !magazine))
		..()
	else if(cover_open && magazine)
		//drop the mag
		magazine.update_icon()
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine = null
		update_icon()
		user << "<span class='notice'>You remove the magazine from [src].</span>"


/obj/item/weapon/gun/projectile/automatic/abzats/attackby(var/obj/item/A as obj, mob/user as mob)
	if(!cover_open)
		user << "<span class='notice'>[src]'s cover is closed! You can't insert a new mag!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/c90gl
	name = "syndicate assault rifle"
	desc = "A bullpup three-round burst 5.45x39 assault rifle with a unique toploading design, designated 'C-90gl'. Has an attached underbarrel grenade launcher which can be toggled on and off."
	icon_state = "c90gl"
	item_state = "c90gl"
	origin_tech = "combat=5;materials=2;syndicate=8"
	mag_type = /obj/item/ammo_box/magazine/m545
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	action_button_name = "Toggle Grenade Launcher"
	can_suppress = 0
	var/obj/item/weapon/gun/projectile/revolver/grenadelauncher/underbarrel
	burst_size = 3
	fire_delay = 2

/obj/item/weapon/gun/projectile/automatic/c90gl/New()
	..()
	underbarrel = new /obj/item/weapon/gun/projectile/revolver/grenadelauncher(src)
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/c90gl/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack(target, user, flag, params)
	else
		..()
		empty_alarm()
		return
/obj/item/weapon/gun/projectile/automatic/c90gl/attackby(var/obj/item/A, mob/user)
	if(select == 2)
		underbarrel.attackby(A, user)
	else
		..()
/obj/item/weapon/gun/projectile/automatic/c90gl/attack_self(var/mob/living/user)
	if(select == 2)
		underbarrel.attack_self(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/c90gl/update_icon()
	..()
	overlays.Cut()
	if(!select)
		overlays += "[initial(icon_state)]semi"
	if(select == 1)
		overlays += "[initial(icon_state)]burst"
	if(select == 2)
		overlays += "[initial(icon_state)]gren"
	icon_state = "c90gl[magazine ? "-[Ceiling(get_ammo(0)/6)*6]" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/c90gl/burst_select()
	var/mob/living/carbon/human/user = usr
	if(!select)
		select = 1
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		user << "<span class='notice'>You switch to [burst_size]-rnd burst.</span>"
		update_icon()
		return
	if(select == 1)
		select = 2
		user << "<span class='notice'>You switch to grenades.</span>"
		update_icon()
		return
	if(select == 2)
		select = 0
		burst_size = 1
		fire_delay = 0
		user << "<span class='notice'>You switch to semi-auto.</span>"
		update_icon()
		return
	// update_icon()
	// return

/obj/item/weapon/gun/projectile/automatic/tommygun
	name = "tommy gun"
	desc = "A genuine 'Chicago Typewriter'."
	icon_state = "tommygun"
	item_state = "tommygun"
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	can_suppress = 0
	burst_size = 4

/obj/item/weapon/gun/projectile/automatic/l85a2
	name = "L85A2"
	desc = "An old classic brought back to life , fires lethal and stamina damaging rounds."
	icon_state = "ak922"
	item_state = "c20r"
	origin_tech = "combat=5;materials=3"
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "l85a2loaded"
	mag_type = /obj/item/ammo_box/magazine/l85
	can_suppress = 1
	fire_sound = 'sound/weapons/handcannon.ogg'
	fire_delay = 2
	burst_size = 2
	recoil = 1
/obj/item/weapon/gun/projectile/automatic/l85a2/update_icon()
	if(magazine)
		icon_state = "l85a2loaded"
		return
	else
		icon_state = "l85a2"
//stamina rifle
/obj/item/weapon/gun/projectile/automatic/l85a2/s/New()
	..()
	magazine = new /obj/item/ammo_box/magazine/l85/s
	chambered = null
	chamber_round()
//l85 construction
/obj/item/weapon/l85frame
	name = "L85A2 frame"
	desc = "The frame for an automatic weapon"
	item_state = "c20r"
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "cons1"
	var/stage = 0
	attackby(var/obj/item/A as obj, mob/user as mob)
		if(stage == 0)
			if(istype(A,/obj/item/stack/sheet/plasteel))
				var/obj/item/stack/sheet/plasteel/stack = A
				if(stack.amount >=5)
					user<<"<span class='notice'>You attach a cover around the frame of the [src.name].</span>"
					stack.use(5)
					stage = 1
					icon_state = "cons2"
		else if(stage == 1)
			if(istype(A,/obj/item/weaponcrafting/reciever))
				stage = 2
				user<<"<span class='notice'>You attach the Modular Reciever to the [src.name].</span>"
				user.drop_item()
				qdel(A)
				icon_state = "cons3"

		else if(stage == 2)
			if(istype(A,/obj/item/stack/rods))
				var/obj/item/stack/rods/stack = A
				if(stack.amount >= 2)
					stack.use(2)
					user<<"<span class='notice'>You insert two rods into the [src.name] forming the barrel and gas piston.</span>"
					stage = 3
					icon_state = "l85a2"
		else if(stage == 3)
			if(istype(A,/obj/item/weapon/screwdriver))
				user<<"<span class='notice'>You tighten the screws surrounding the [src.name].</span>"
				stage = 4
		else if(stage == 4)
			if(istype(A,/obj/item/weapon/weldingtool))
				user<<"<span class='notice'>You begin to weld the remaining chasis together.</span>"
				playsound(loc, 'sound/items/Welder2.ogg', 100, 1)
				spawn(5)
					user<<"<span class='notice'>You weld the remaining chasis together finishing the L85A2.</span>"
					var/obj/item/weapon/gun/projectile/automatic/l85a2/weapon = new /obj/item/weapon/gun/projectile/automatic/l85a2()
					weapon.loc = get_turf(user.loc)
					weapon.magazine = null
					weapon.chambered = null
					user.drop_item()
					qdel(src)

