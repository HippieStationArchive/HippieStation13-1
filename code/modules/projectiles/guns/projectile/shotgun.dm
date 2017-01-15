/obj/item/weapon/gun/projectile/shotgun
	name = "shotgun"
	desc = "A traditional shotgun with wood furniture and a four-shell capacity underneath."
	icon_state = "shotgun"
	item_state = "shotgun"
	w_class = 4
	force = 10
	stamina_percentage = 0.5
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	fire_sound = 'sound/weapons/shotgun.ogg'
	var/recentpump = 0 // to prevent spammage
	mag_load_sound = null
	mag_unload_sound = null		//Shotguns have their own procs related to loading, unloading, etc.
	chamber_sound = null

/obj/item/weapon/gun/projectile/shotgun/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		user << "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>"
		playsound(loc, 'sound/effects/wep_magazines/insertShotgun.ogg', 80)
		A.update_icon()
		update_icon()
		return
	..()
/obj/item/weapon/gun/projectile/shotgun/process_chamber()
	return ..(0, 0)

/obj/item/weapon/gun/projectile/shotgun/chamber_round()
	return

/obj/item/weapon/gun/projectile/shotgun/can_shoot()
	if(!chambered)
		return 0
	return (chambered.BB ? 1 : 0)

/obj/item/weapon/gun/projectile/shotgun/attack_self(mob/living/user)
	if(recentpump)	return
	pump(user)
	recentpump = 1
	spawn(10)
		recentpump = 0
	return

/obj/item/weapon/gun/projectile/shotgun/proc/pump(mob/M)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	pump_unload(M)
	pump_reload(M)
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/weapon/gun/projectile/shotgun/proc/pump_unload(mob/M)
	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered.SpinAnimation(5, 1)
		chambered = null

/obj/item/weapon/gun/projectile/shotgun/proc/pump_reload(mob/M)
	if(!magazine.ammo_count())	return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC


/obj/item/weapon/gun/projectile/shotgun/examine(mob/user)
	..()
	if (chambered)
		user << "A [chambered.BB ? "live" : "spent"] one is in the chamber."

// RIOT SHOTGUN //

/obj/item/weapon/gun/projectile/shotgun/riot //for spawn in the armory
	name = "riot shotgun"
	desc = "A sturdy shotgun with a longer magazine and a fixed tactical stock designed for non-lethal riot control."
	icon_state = "riotshotgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/riot
	fire_sound = 'sound/weapons/shotgun.ogg'
	sawn_desc = "Come with me if you want to live."

/obj/item/weapon/gun/projectile/shotgun/riot/attackby(obj/item/A, mob/user, params)
	..()

	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/gun/energy/plasmacutter))
		sawoff(user)
	if(istype(A, /obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/W = A
		if(W.active)
			sawoff(user)

///////////////////////
// BOLT ACTION RIFLE //
///////////////////////

/obj/item/weapon/gun/projectile/shotgun/boltaction
	name = "Mosin M91/30"
	desc = "This piece of junk looks like something that could have been used 700 years ago... Where's the bayonet?"	//mm.. gagsa
	icon_state = "mosin"
	item_state = "mosin"
	slot_flags = SLOT_BACK //we got slot back sprites comrade
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction
	sawn_desc = "A NUU CHEEKI BREEKI I V DAMKE."
	fire_sound = 'sound/weapons/handcannon.ogg'
	var/bolt_open = 0
	can_knife = 1
	knife_x_offset = 17
	knife_y_offset = 13
	can_sawn = TRUE

/obj/item/weapon/gun/projectile/shotgun/boltaction/pump(mob/M)
	if(bolt_open)
		pump_reload(M)
		playsound(loc, 'sound/effects/wep_magazines/rifle_bolt_back.ogg', 80)
	else
		pump_unload(M)
		playsound(loc, 'sound/effects/wep_magazines/rifle_bolt_forward.ogg', 80)
	bolt_open = !bolt_open
	update_icon()	//I.E. fix the desc
	return 1


/obj/item/weapon/gun/projectile/shotgun/boltaction/examine(mob/user)
	..()
	user << "The bolt is [bolt_open ? "open" : "closed"]."

/obj/item/weapon/gun/projectile/shotgun/boltaction/attackby(obj/item/A, mob/user, params)
	..()
	if(!bolt_open)
		user << "<span class='notice'>The bolt is closed!</span>"
		return
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()
		playsound(loc, 'sound/effects/wep_magazines/rifle_load.ogg', 80)
	if(istype(A, /obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/W = A
		if(W.active)
			sawoff(user)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/gun/energy/plasmacutter))
		sawoff(user)

/////////////////////////////
// DOUBLE BARRELED SHOTGUN //
/////////////////////////////

/obj/item/weapon/gun/projectile/revolver/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "shotgun"
	pin = /obj/item/device/firing_pin/generic
	w_class = 4
	force = 10
	stamina_percentage = 0.5
	flags = CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = "combat=3;materials=1"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual
	fire_sound = 'sound/weapons/shotgun.ogg'
	sawn_desc = "Omar's coming!"
	unique_rename = 1
	unique_reskin = 1
	can_sawn = TRUE

/obj/item/weapon/gun/projectile/revolver/doublebarrel/New()
	..()
	options["Default"] = "dshotgun"
	options["Dark Red Finish"] = "dshotgun-d"
	options["Ash"] = "dshotgun-f"
	options["Faded Grey"] = "dshotgun-g"
	options["Maple"] = "dshotgun-l"
	options["Rosewood"] = "dshotgun-p"
	options["Cancel"] = null

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()
	if(istype(A, /obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/W = A
		if(W.active)
			sawoff(user)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/gun/energy/plasmacutter))
		sawoff(user)

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attack_self(mob/living/user)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.loc = get_turf(src.loc)
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		user << "<span class='notice'>You break open \the [src] and unload [num_unloaded] shell\s.</span>"
	else
		user << "<span class='warning'>[src] is empty!</span>"


// IMPROVISED SHOTGUN //

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised
	name = "improvised shotgun"
	desc = "Essentially a tube that aims shotgun shells."
	icon_state = "ishotgun"
	item_state = "shotgun"
	w_class = 4
	force = 10
	stamina_percentage = 0.5
	slot_flags = null
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/improvised
	fire_sound = 'sound/weapons/shotgun.ogg'
	sawn_desc = "I'm just here for the gasoline."
	unique_rename = 0
	unique_reskin = 0
	mag_load_sound = 'sound/effects/wep_magazines/rifle_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/rifle_bolt_back.ogg'
	chamber_sound = null
	can_sawn = TRUE

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/stack/cable_coil) && !sawn_state)
		var/obj/item/stack/cable_coil/C = A
		if(C.use(10))
			slot_flags = SLOT_BACK
			icon_state = "ishotgunsling"
			user << "<span class='notice'>You tie the lengths of cable to the shotgun, making a sling.</span>"
			update_icon()
		else
			user << "<span class='warning'>You need at least ten lengths of cable if you want to make a sling!</span>"
			return

// CANE SHOTGUN //


/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown. Can be used as a crutch."
	icon_state = "cane"
	item_state = "stick"
	icon = 'icons/obj/weapons.dmi'
	w_class = 2
	force = 10
	stamina_percentage = 0.75
	can_unsuppress = 0
	slot_flags = null
	origin_tech = "" // NO GIVAWAYS
	mag_type = /obj/item/ammo_box/magazine/internal/shot/improvised
	fire_sound = 'sound/weapons/shotgun.ogg'
	sawn_desc = "I'm sorry, but why did you saw your cane in the first place?"
	unique_reskin = 1
	reskinned = 0
	mag_load_sound = null
	mag_unload_sound = null
	chamber_sound = null
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")
	fire_sound = 'sound/weapons/Gunshot_silenced.ogg'
	suppressed = 1
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	can_sawn = FALSE

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/cane/update_slowdown(mob/user)
	var/mob/living/carbon/human/H = user
	var/slow = 0
	if(istype(H))
		slow = (H.get_num_legs(1) < 2) ? -2 : 0 //Negates slowdown caused by lack of a leg
	return slow

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/cane/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/stack/cable_coil))
		return
/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/cane/examine(mob/user) // HAD TO REPEAT EXAMINE CODE BECAUSE GUN CODE DOESNT STEALTH
	var/f_name = "\a [src]."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "<span class='danger'>blood-stained</span> [name]!"

	user << "\icon[src] That's [f_name]"

	if(desc)
		user << desc

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/cane/New()
	..()

	options = list()
	options["Pimp Stick"] = "pimpstick"
	options["Cane"] = "cane"
	options["Cancel"] = null

	return

// Sawing guns related procs //

/obj/item/weapon/gun/projectile/proc/blow_up(mob/user)
	. = 0
	for(var/obj/item/ammo_casing/AC in magazine.stored_ammo)
		if(AC.BB)
			process_fire(user, user,0)
			. = 1

/obj/item/weapon/gun/projectile/shotgun/blow_up(mob/user)
	. = 0
	if(chambered && chambered.BB)
		process_fire(user, user,0)
		. = 1

/obj/item/weapon/gun/projectile/proc/sawoff(mob/user)
	if(sawn_state == SAWN_OFF)
		user << "<span class='warning'>\The [src] is already shortened!</span>"
		return

	if(!can_sawn)
		user << "<span class='warning'>You're unable to shorten this weapon!</span>"
		return

	if(sawn_state == SAWN_SAWING)
		return

	user.visible_message("[user] begins to shorten \the [src].", "<span class='notice'>You begin to shorten \the [src]...</span>")

	//if there's any live ammo inside the gun, makes it go off
	if(blow_up(user))
		user.visible_message("<span class='danger'>\The [src] goes off!</span>", "<span class='danger'>\The [src] goes off in your face!</span>")
		return

	sawn_state = SAWN_SAWING

	if(do_after(user, 30, target = src))
		user.visible_message("[user] shortens \the [src]!", "<span class='notice'>You shorten \the [src].</span>")
		name = "sawn-off [src.name]"
		desc = sawn_desc
		icon_state = "[icon_state]-sawn"
		w_class = 3
		item_state = "gun"
		slot_flags &= ~SLOT_BACK	//you can't sling it on your back
		slot_flags |= SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
		sawn_state = SAWN_OFF
		update_icon()
		return
	else
		sawn_state = SAWN_INTACT


// Bulldog shotgun //

/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
	name = "Bulldog Shotgun"
	desc = "A semi-auto, mag-fed shotgun for combat in narrow corridors, nicknamed 'Bulldog' by boarding parties. Compatible only with specialized 8-round drum magazines."
	icon_state = "bulldog"
	item_state = "bulldog"
	w_class = 3
	origin_tech = "combat=5;materials=4;syndicate=6"
	mag_type = /obj/item/ammo_box/magazine/m12g
	fire_sound = 'sound/weapons/shotgun_shoot.ogg'
	can_suppress = 0
	burst_size = 1
	fire_delay = 0
	mag_load_sound = 'sound/effects/wep_magazines/bulldog_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/bulldog_unload.ogg'
	chamber_sound = 'sound/effects/wep_magazines/bulldog_chamber.ogg'
	action_button_name = null
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12
	can_knife = 1
	knife_x_offset = 18
	knife_y_offset = 12
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog/New()
	..()
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog/update_icon()
	..()
	if(magazine)
		overlays.Cut()
		overlays += "[magazine.icon_state]"
	icon_state = "bulldog[chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog/afterattack()
	..()
	empty_alarm()
	return

/obj/item/weapon/gun/projectile/shotgun/automatic/shoot_live_shot(mob/living/user as mob|obj)
	..()
	src.pump(user)

/obj/item/weapon/gun/projectile/automatic/shotgun/abzats
	name = "Abzats"
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
	spread = 15
	mag_load_sound = 'sound/effects/wep_magazines/lmg_load.ogg'
	mag_unload_sound = null
	chamber_sound = null
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/automatic/shotgun/abzats/burst_select()
	return


/obj/item/weapon/gun/projectile/automatic/shotgun/abzats/attack_self(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()


/obj/item/weapon/gun/projectile/automatic/shotgun/abzats/update_icon()
	..()
	icon_state = "abzats[cover_open ? "open" : "closed"][magazine ? Ceiling(get_ammo(0)/12.5)*25 : "-empty"]"


/obj/item/weapon/gun/projectile/automatic/shotgun/abzats/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	if(cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
	else
		..()
		update_icon()


/obj/item/weapon/gun/projectile/automatic/shotgun/abzats/attack_hand(mob/user)
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
		playsound(loc, 'sound/effects/wep_magazines/lmg_unload.ogg', 80)
		user << "<span class='notice'>You remove the magazine from [src].</span>"


/obj/item/weapon/gun/projectile/automatic/shotgun/abzats/attackby(obj/item/A, mob/user, params)
	if(!cover_open)
		user << "<span class='warning'>[src]'s cover is closed! You can't insert a new mag.</span>"
		return
	..()

// COMBAT SHOTGUN //

/obj/item/weapon/gun/projectile/shotgun/automatic/combat
	name = "Combat Shotgun"
	desc = "A semi automatic shotgun with tactical furniture and a six-shell capacity underneath."
	icon_state = "cshotgun"
	origin_tech = "combat=5;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com
	fire_sound = 'sound/weapons/shotgun.ogg'
	w_class = 5

// Triple Threat //

/obj/item/weapon/gun/projectile/revolver/triplebarrel
	name = "triple-barreled shotgun"
	desc = "A modded version of a true classic."
	icon_state = "triplethreat"
	item_state = "triplethreat"
	w_class = 4
	force = 10
	stamina_percentage = 0.5
	flags = CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/triple
	fire_sound = 'sound/weapons/shotgun.ogg'
	can_sawn = FALSE

// Lever Action //

/obj/item/weapon/gun/projectile/shotgun/leveraction //for biker bar
	name = "lever-action shotgun"
	desc = "A short shotgun with a small magazine and a carved grip."
	icon_state = "leveraction"
	item_state = "gun"
	slot_flags = SLOT_BELT
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lever
	fire_sound = 'sound/weapons/shotgun.ogg'
	w_class = 3
	can_sawn = FALSE

// breechloader

/obj/item/weapon/gun/projectile/revolver/doublebarrel/musket
	name = "breech-loading musket"
	desc = "This thing looks old!"
	icon_state = "musket"
	item_state = "musket"
	w_class = 4
	force = 10
	stamina_percentage = 0.5
	slot_flags = SLOT_BACK
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/musket
	fire_sound = 'sound/weapons/handcannon.ogg'
	mag_load_sound = 'sound/effects/wep_magazines/rifle_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/rifle_bolt_back.ogg'
	chamber_sound = null
	spread = 7
	unique_rename = 0
	unique_reskin = 0
	can_sawn = FALSE

/obj/item/weapon/gun/projectile/revolver/doublebarrel/contender
	desc = "The Contender G13, a favorite amongst space hunters. An easily modified bluespace barrel and break action loading means it can use any ammo available. It can only hold one round at a time, however."
	name = "Contender G13"
	icon_state = "contender"
	origin_tech = "combat=6;materials=4;bluespace=5"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/contender
	mag_load_sound = 'sound/effects/wep_magazines/rifle_load.ogg'
	mag_unload_sound = 'sound/effects/wep_magazines/rifle_bolt_back.ogg'
	can_sawn = FALSE
	unique_rename = 0
	unique_reskin = 0
	can_suppress = 1
	w_class = 2
	materials = list(MAT_METAL=1000)

/obj/item/weapon/gun/projectile/revolver/doublebarrel/contender/syndie
	desc = "A modified Contender G13, custom ordered for the Syndicate. An easily modified bluespace barrel and break action loading means it can use any ammo available. It can only hold one round at a time, however."
	icon_state = "contender-s"
	pin = /obj/item/device/firing_pin/area/syndicate
