//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 * 		Wirecutters
 * 		Welding Tool
 * 		Crowbar
 */

/*
 * Wrench
 */
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 150
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwy with this."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	g_amt = 0
	m_amt = 75
	attack_verb = list("stabbed")
	hitsound = 'sound/weapons/bladeslice.ogg'
	embedchance = 20 //Low chance to embed itself in you

/obj/item/weapon/screwdriver/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is stabbing the [src.name] into \his temple! It looks like \he's trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is stabbing the [src.name] into \his heart! It looks like \he's trying to commit suicide.</span>"))
	return(BRUTELOSS)

/obj/item/weapon/screwdriver/New()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))	return ..()
	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6.0
	throw_speed = 3
	throw_range = 7
	w_class = 2.0
	m_amt = 80
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("pinched", "nipped")
	hitsound = 'sound/items/Wirecutter.ogg'

/obj/item/weapon/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C, mob/user)
	if(istype(C) && C.handcuffed && istype(C.handcuffed, /obj/item/weapon/handcuffs/cable))
		user.visible_message("<span class='notice'>[user] cuts [C]'s restraints with [src]!</span>")
		qdel(C.handcuffed)
		C.handcuffed = null
		C.update_inv_handcuffed(0)
		return
	else
		..()

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	item_state = "welder"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 3
	throwforce = 5
	hitsound = "swing_hit"
	throw_speed = 3
	throw_range = 5
	w_class = 2
	m_amt = 70
	g_amt = 30
	origin_tech = "engineering=1"
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

/obj/item/weapon/weldingtool/New()
	..()
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	update_icon()
	return

/obj/item/weapon/weldingtool/proc/update_torch()
	if(welding)
		src.overlays = 0
		overlays += "["-won"]"
		item_state = "welder1"
	else
		item_state = "welder"

/obj/item/weapon/weldingtool/update_icon()
	src.overlays = 0
	var/ratio = get_fuel() / max_fuel
	ratio = Ceiling(ratio*4) * 25
	icon_state = "[initial(icon_state)][ratio]"
	update_torch()
	return

/obj/item/weapon/weldingtool/examine(mob/user)
	..()
	user << "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."


/obj/item/weapon/weldingtool/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		flamethrower_screwdriver(I, user)
	if(istype(I, /obj/item/stack/rods))
		flamethrower_rods(I, user)
	..()


/obj/item/weapon/weldingtool/attack(mob/living/carbon/human/H, mob/user)
	if(!istype(H))
		return ..()

	var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))

	if(affecting.status == ORGAN_ROBOTIC && user.a_intent != "harm")
		if(src.remove_fuel(0))
			item_heal_robotic(H, user, 30, 0)
			return
		else
			return
	else
		return ..()

/obj/item/weapon/weldingtool/process()
	switch(welding)
		if(0)
			force = 3
			damtype = "brute"
			update_icon()
			processing_objects.Remove(src)
			return
	//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(1)
			force = 15
			damtype = "fire"
			if(prob(5))
				remove_fuel(1)
			update_icon()

	//This is to start fires. process() is only called if the welder is on.
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = get_turf(M)
	if(isturf(location))
		location.hotspot_expose(700, 5)


/obj/item/weapon/weldingtool/afterattack(atom/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && in_range(src, O))
		if(!welding)
			O.reagents.trans_to(src, max_fuel)
			user << "<span class='notice'>[src] refueled.</span>"
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			update_icon()
			return
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			user << "<span class='warning'>That was stupid of you.</span>"
			O.ex_act()
			return

	if(welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		location.hotspot_expose(700, 50, 1)

		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()

/obj/item/weapon/weldingtool/attack_self(mob/user)
	toggle(user)
	update_icon()

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(amount = 1, mob/M = null)
	if(!welding || !check_fuel())
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel()
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "<span class='notice'>You need more welding fuel to complete this task.</span>"
		return 0


//Returns whether or not the welding tool is currently on.
/obj/item/weapon/weldingtool/proc/isOn()
	return welding


//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weapon/weldingtool/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && welding)
		toggle(user, 1)
		update_icon()
		//mob icon update
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_r_hand(0)
			M.update_inv_l_hand(0)

		return 0
	return 1


//Toggles the welder off and on
/obj/item/weapon/weldingtool/proc/toggle(mob/user, message = 0)
	if(!status)
		return
	welding = !welding
	if(welding)
		if(remove_fuel(1))
			user << "<span class='notice'>You switch [src] on.</span>"
			force = 15
			damtype = "fire"
			hitsound = 'sound/items/welder.ogg'
			icon_state = "welder1"
			processing_objects.Add(src)
		else
			user << "<span class='notice'>You need more fuel.</span>"
			welding = 0
	else
		if(!message)
			user << "<span class='notice'>You switch [src] off.</span>"
		else
			user << "<span class='notice'>[src] shuts off!</span>"
		force = 3
		damtype = "brute"
		hitsound = "swing_hit"
		icon_state = "welder"



//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/weldingtool/proc/eyecheck(mob/user)
	if(!iscarbon(user))
		return 1
	var/mob/living/carbon/C = user
	var/safety = C.eyecheck()

	switch(safety)
		if(1)
			usr << "<span class='warning'>Your eyes sting a little.</span>"
			user.eye_stat += rand(1, 2)
			if(user.eye_stat > 12)
				user.eye_blurry += rand(3, 6)
		if(0)
			usr << "<span class='warning'>Your eyes burn.</span>"
			user.eye_stat += rand(2, 4)
			if(user.eye_stat > 10)
				user.eye_blurry += rand(4, 10)
		if(-1)
			usr << "<span class='warning'>Your thermals intensify the welder's glow. Your eyes itch and burn severely!</span>"
			user.eye_blurry += rand(12, 20)
			user.eye_stat += rand(12, 16)
	if(user.eye_stat > 10 && safety < 2)
		user << "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>"
	if (prob(user.eye_stat - 25 + 1))
		user << "<span class='warning'>You go blind!</span>"
		user.sdisabilities |= BLIND
	else if(prob(user.eye_stat - 15 + 1))
		user << "<span class='warning'>You go blind!</span>"
		user.eye_blind = 5
		user.eye_blurry = 5
		user.disabilities |= NEARSIGHTED
		spawn(100)
			user.disabilities &= ~NEARSIGHTED

/obj/item/weapon/weldingtool/proc/flamethrower_screwdriver(obj/item/I, mob/user)
	if(welding)
		user << "<span class='notice'>Turn it off first.</span>"
		return
	status = !status
	if(status)
		user << "<span class='notice'>You resecure [src].</span>"
	else
		user << "<span class='notice'>[src] can now be attached and modified.</span>"
	add_fingerprint(user)

/obj/item/weapon/weldingtool/proc/flamethrower_rods(obj/item/I, mob/user)
	if(!status)
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/weapon/flamethrower/F = new /obj/item/weapon/flamethrower(user.loc)
			user.unEquip(src)
			loc = F
			F.weldtool = src
			add_fingerprint(user)
			user << "<span class='notice'>You add a rod to a welder, starting to build a flamethrower.</span>"
			user.put_in_hands(F)
		else
			user << "<span class='warning'>You need one rod to start building a flamethrower.</span>"
			return

/obj/item/weapon/weldingtool/largetank
	name = "industrial welding tool"
	max_fuel = 40
	m_amt = 70
	g_amt = 60
	origin_tech = "engineering=2"

/obj/item/weapon/weldingtool/largetank/cyborg

/obj/item/weapon/weldingtool/largetank/cyborg/flamethrower_screwdriver()
	return

/obj/item/weapon/weldingtool/largetank/cyborg/flamethrower_rods()
	return

/obj/item/weapon/weldingtool/hugetank
	name = "upgraded welding tool"
	max_fuel = 80
	w_class = 3.0
	m_amt = 70
	g_amt = 120
	origin_tech = "engineering=3"

/obj/item/weapon/weldingtool/experimental
	name = "experimental welding tool"
	max_fuel = 40
	w_class = 3.0
	m_amt = 70
	g_amt = 120
	origin_tech = "engineering=4;plasmatech=3"
	var/last_gen = 0


//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
//i don't think this is actually used, yaaaaay -Pete
/obj/item/weapon/weldingtool/experimental/proc/fuel_gen()
	var/gen_amount = (world.time - last_gen) / 25
	reagents += gen_amount
	if(reagents > max_fuel)
		reagents = max_fuel


/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "A small crowbar. This handy tool is useful for lots of things, such as prying floor tiles or opening unpowered doors."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5
	throwforce = 7
	item_state = "crowbar"
	w_class = 2
	m_amt = 50
	origin_tech = "engineering=1"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/weapon/crowbar/large
	name = "crowbar"
	desc = "It's a big crowbar. It doesn't fit in your pockets, because it's big."
	force = 12
	w_class = 3
	throw_speed = 3
	throw_range = 3
	m_amt = 66
	icon_state = "crowbar_large"
