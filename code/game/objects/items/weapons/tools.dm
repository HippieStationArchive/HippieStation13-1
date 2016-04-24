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
	force = 7
	throwforce = 10
	w_class = 2
	materials = list(MAT_METAL=150)
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	hitsound = 'sound/weapons/wrench.ogg'
	toolspeed = 1

/obj/item/weapon/wrench/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is beating \himself to death with the [name]! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, hitsound, 50, 1, -1)
	return (BRUTELOSS)

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
	force = 5
	w_class = 1
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	materials = list(MAT_METAL=75)
	attack_verb = list("stabbed")
	hitsound = 'sound/weapons/bladeslice.ogg'
	toolspeed = 1

/obj/item/weapon/screwdriver/suicide_act(mob/user) //TODO: Make this suicide less lame
	user.visible_message(pick("<span class='suicide'>[user] is stabbing the [name] into \his temple! It looks like \he's trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is stabbing the [name] into \his heart! It looks like \he's trying to commit suicide.</span>"))
	playsound(loc, hitsound, 50, 1, -1)
	return(BRUTELOSS)

/obj/item/weapon/screwdriver/New(loc, var/param_color = null)
	if(!param_color)
		param_color = pick("red","blue","purple","brown","green","cyan","yellow")

	switch(param_color)
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
		pixel_y = rand(0, 16)
	return

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M, mob/living/carbon/user, def_zone)
	if(!istype(M))	return ..()
	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()
	if(user.disabilities & CLUMSY && prob(50))
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
	force = 6
	throw_speed = 3
	throw_range = 7
	w_class = 2
	materials = list(MAT_METAL=80)
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("pinched", "nipped")
	hitsound = 'sound/items/Wirecutter.ogg'
	toolspeed = 1

/obj/item/weapon/wirecutters/New(loc, var/param_color = null)
	..()
	if((!param_color && prob(50)) || param_color == "yellow")
		icon_state = "cutters-y"
		item_state = "cutters_yellow"

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C, mob/living/user, def_zone)
	if(ishuman(C) && user.zone_sel.selecting == "mouth")
		var/mob/living/carbon/human/H = C
		var/obj/item/organ/limb/head/O = locate() in H.organs
		if(!O || !O.get_teeth())
			user << "<span class='notice'>[H] doesn't have any teeth left!</span>"
			return
		if(!user.doing_something)
			user.doing_something = 1
			H.visible_message("<span class='danger'>[user] tries to tear off [H]'s tooth with [src]!</span>",
								"<span class='userdanger'>[user] tries to tear off your tooth with [src]!</span>")
			if(do_after(user, 50, target = H))
				if(!O || !O.get_teeth()) return
				var/obj/item/stack/teeth/E = pick(O.teeth_list)
				if(!E || E.zero_amount()) return
				var/obj/item/stack/teeth/T = new E.type(H.loc, 1)
				T.copy_evidences(E)
				E.use(1)
				T.add_blood(H)
				E.zero_amount() //Try to delete the teeth
				add_logs(user, H, "torn out the tooth from", src)
				H.visible_message("<span class='danger'>[user] tears off [H]'s tooth with [src]!</span>",
								"<span class='userdanger'>[user] tears off your tooth with [src]!</span>")
				var/armor = H.run_armor_check(O, "melee")
				H.apply_damage(rand(1,5), BRUTE, O, armor)
				playsound(H, 'sound/misc/tear.ogg', 40, 1, -1) //RIP AND TEAR. RIP AND TEAR.
				H.emote("scream")
				user.doing_something = 0
			else
				user << "<span class='notice'>Your attempt to pull out a teeth fails...</span>"
				user.doing_something = 0
			return
		else
			user << "<span class='notice'>You are already trying to pull out a teeth!</span>"
		return
	if(istype(C) && C.handcuffed && istype(C.handcuffed, /obj/item/weapon/restraints/handcuffs/cable))
		user.visible_message("<span class='notice'>[user] cuts [C]'s restraints with [src]!</span>")
		qdel(C.handcuffed)
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_requires_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed(0)
		return
	else
		..()

/obj/item/weapon/wirecutters/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is cutting at \his arteries with the [name]! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, hitsound, 50, 1, -1)
	return (BRUTELOSS)

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	desc = "A standard edition welder provided by NanoTrasen."
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
	toolspeed = 1

	materials = list(MAT_METAL=70, MAT_GLASS=30)
	origin_tech = "engineering=1"
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold
	var/change_icons = 1
	var/can_off_process = 0
	var/light_intensity = 2 //how powerful the emitted light is when used.
	var/spam_check = 0
	var/spam_level = 0
	heat = 3800

/obj/item/weapon/weldingtool/New()
	..()
	create_reagents(max_fuel)
	reagents.add_reagent("welding_fuel", max_fuel)
	update_icon()
	return

/obj/item/weapon/weldingtool/proc/update_torch()
	overlays.Cut()
	if(welding)
		overlays += "[initial(icon_state)]-on"
		item_state = "[initial(item_state)]1"
	else
		item_state = "[initial(item_state)]"

/obj/item/weapon/weldingtool/update_icon()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = Ceiling(ratio*4) * 25
		if(ratio == 100)
			icon_state = initial(icon_state)
		else
			icon_state = "[initial(icon_state)][ratio]"
	update_torch()
	return

/obj/item/weapon/weldingtool/examine(mob/user)
	..()
	user << "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

/obj/item/weapon/weldingtool/suicide_act(mob/user) //TODO: Make this suicide less lame
	user.visible_message("<span class='suicide'>[user] welds \his every orifice closed! It looks like \he's trying to commit suicide..</span>")
	return (FIRELOSS)


/obj/item/weapon/weldingtool/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		flamethrower_screwdriver(I, user)
	if(istype(I, /obj/item/stack/rods))
		flamethrower_rods(I, user)
	..()


/obj/item/weapon/weldingtool/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(!istype(H))
		return ..()

	var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))

	if(user.a_intent != "harm")
		if(affecting.status == ORGAN_ORGANIC && affecting.bloodloss > 0)
			if(remove_fuel(1))
				playsound(loc, 'sound/items/Welder.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] starts to close up wounds on [H]'s [affecting].</span>", "<span class='notice'>You start closing up wounds on [H]'s [affecting].</span>")
				if(!do_mob(user, H, 50))	return
				user.visible_message("<span class='notice'>[user] has closed up wounds [H]'s [affecting].</span>", "<span class='notice'>You closed up wounds on [H]'s [affecting].</span>")
				affecting.heal_damage(bleed=affecting.bloodloss)
				affecting.take_damage(burn=10) //Quite harsh tradeoff
			return
		else if(affecting.status == ORGAN_ROBOTIC && affecting.get_damage() > 0)
			if(remove_fuel(1))
				playsound(loc, 'sound/items/Welder.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] starts to fix some of the dents on [H]'s [affecting].</span>", "<span class='notice'>You start fixing some of the dents on [H]'s [affecting].</span>")
				if(!do_mob(user, H, 50))	return
				item_heal_robotic(H, user, 5, 0)
			return //It's neither organic or robotic... ...then what the hell is it!?
	return ..()

/obj/item/weapon/weldingtool/process()
	switch(welding)
		if(0)
			force = 3
			damtype = BRUTE
			update_icon()
			if(!can_off_process)
				SSobj.processing.Remove(src)
			return
	//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(1)
			force = 15
			damtype = BURN
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
		var/datum/gas_mixture/air_contents = location.return_air()
		var/mob/last = get_mob_by_ckey(fingerprintslast)
		if((air_contents.toxins > 1) && !(spam_check))
		//if((air_contents.toxins > 0) && !(location.contents.Find(/obj/effect/hotspot))) This would be better combined with spam_check.
			spam_check = 1 //There is no reason to message is a multitude of times in such a short period
			spawn(600)
				spam_check = 0 //Greater delay, this is so one welding tool isn't later totally masked from detection of fire sparking.
			message_admins("Plasma at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>(JMP)</a>. triggered by welder, last touched by [key_name_admin(last)]<A HREF='?_src_=holder;adminmoreinfo=\ref[last]'>(?)</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[last]'>FLW</A>).")
			investigate_log("Plasma at: X=[location.x];Y=[location.y];Z=[location.z];, trigger by welder last touched by [key_name_admin(last)]", "atmos")
		location.hotspot_expose(700, 5)


/obj/item/weapon/weldingtool/afterattack(atom/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O, /obj/structure/reagent_dispensers) && in_range(src, O))
		var/obj/structure/reagent_dispensers/D = O
		if(!welding)
			if(D.reagents.has_reagent("welding_fuel"))
				D.reagents.trans_id_to(src, "welding_fuel", max_fuel)
				user << "<span class='notice'>[src] refueled.</span>"
				playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
				update_icon()
				return
			else
				user << "<span class='notice'>[D] has not enough welding fuel to refill!</span>"
				return
		else
			user << "<span class='warning'>That was stupid of you.</span>"
			D.boom(user)
			return

	if(welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		var/datum/gas_mixture/air_contents = location.return_air()
		var/mob/last = get_mob_by_ckey(fingerprintslast)
		if((air_contents.toxins > 1) && !(spam_check))
		//if((air_contents.toxins > 0) && !(location.contents.Find(/obj/effect/hotspot))) This would be better combined with spam_check.
			if (spam_level > 3)
				spam_check = 1
				spawn(50)
					spam_level++
					spam_check = 0
			if (spam_level == 3)
				spam_check = 1
				spawn(600)
					spam_level = 0
					spam_check = 0
			message_admins("Plasma at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>(JMP)</a>. triggered by welder, last touched by [key_name_admin(last)]<A HREF='?_src_=holder;adminmoreinfo=\ref[last]'>(?)</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[last]'>FLW</A>).")
			investigate_log("Plasma at: X=[location.x];Y=[location.y];Z=[location.z];, trigger by welder last touched by [key_name_admin(last)]", "atmos")
		location.hotspot_expose(700, 50, 1)

		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()

/obj/item/weapon/weldingtool/attack_self(mob/user)
	toggle(user)
	update_icon()

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("welding_fuel")


//Removes fuel from the welding tool. If a mob is passed, it will try to flash the mob's eyes. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(amount = 1, mob/living/M = null)
	if(!welding || !check_fuel())
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("welding_fuel", amount)
		check_fuel()
		if(M)
			M.flash_eyes(light_intensity, noflash = 1)
		return 1
	else
		if(M)
			M << "<span class='warning'>You need more welding fuel to complete this task!</span>"
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
		user << "<span class='warning'>[src] can't be turned on while unsecured!</span>"
		return
	welding = !welding
	if(welding)
		if(get_fuel() >= 1)
			user << "<span class='notice'>You switch [src] on.</span>"
			force = 15
			damtype = BURN
			hitsound = 'sound/items/welder.ogg'
			update_icon()
			SSobj.processing |= src
		else
			user << "<span class='warning'>You need more fuel!</span>"
			welding = 0
	else
		if(!message)
			user << "<span class='notice'>You switch [src] off.</span>"
		else
			user << "<span class='warning'>[src] shuts off!</span>"
		force = 3
		damtype = BRUTE
		hitsound = "swing_hit"
		update_icon()

/obj/item/weapon/weldingtool/is_hot()
	return welding * heat

/obj/item/weapon/weldingtool/proc/flamethrower_screwdriver(obj/item/I, mob/user)
	if(welding)
		user << "<span class='warning'>Turn it off first!</span>"
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
			if(!remove_item_from_storage(F))
				user.unEquip(src)
				loc = F
			F.weldtool = src
			add_fingerprint(user)
			user << "<span class='notice'>You add a rod to a welder, starting to build a flamethrower.</span>"
			user.put_in_hands(F)
		else
			user << "<span class='warning'>You need one rod to start building a flamethrower!</span>"
			return

/obj/item/weapon/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A slightly larger welder with a larger tank."
	icon_state = "indwelder"
	max_fuel = 40
	materials = list(MAT_GLASS=60)
	origin_tech = "engineering=2"

/obj/item/weapon/weldingtool/largetank/cyborg

/obj/item/weapon/weldingtool/largetank/flamethrower_screwdriver()
	return


/obj/item/weapon/weldingtool/mini
	name = "emergency welding tool"
	desc = "A miniature welder used during emergencies."
	icon_state = "miniwelder"
	max_fuel = 10
	w_class = 1
	materials = list(MAT_METAL=30, MAT_GLASS=10)
	change_icons = 0

/obj/item/weapon/weldingtool/mini/flamethrower_screwdriver()
	return


/obj/item/weapon/weldingtool/hugetank
	name = "upgraded industrial welding tool"
	desc = "An upgraded welder based of the industrial welder."
	icon_state = "upindwelder"
	item_state = "upindwelder"
	max_fuel = 80
	materials = list(MAT_METAL=70, MAT_GLASS=120)
	origin_tech = "engineering=3"

/obj/item/weapon/weldingtool/experimental
	name = "experimental welding tool"
	desc = "An experimental welder capable of self-fuel generation and less harmful to the eyes."
	icon_state = "exwelder"
	item_state = "exwelder"
	max_fuel = 40
	materials = list(MAT_METAL=70, MAT_GLASS=120)
	origin_tech = "materials=4;engineering=4;bluespace=3;plasmatech=3"
	var/last_gen = 0
	change_icons = 0
	can_off_process = 1
	light_intensity = 1
	toolspeed = 2


//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
//i don't think this is actually used, yaaaaay -Pete
/obj/item/weapon/weldingtool/experimental/proc/fuel_gen()
	if(!welding && !last_gen)
		last_gen = 1
		reagents.add_reagent("welding_fuel",1)
		spawn(10)
			last_gen = 0

/obj/item/weapon/weldingtool/experimental/process()
	..()
	if(reagents.total_volume < max_fuel)
		fuel_gen()



/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "pocket crowbar"
	desc = "A small crowbar. This handy tool is useful for lots of things, such as prying floor tiles or opening unpowered doors."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 7
	throwforce = 10
	item_state = "crowbar"
	w_class = 2
	materials = list(MAT_METAL=50)
	origin_tech = "engineering=1"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	hitsound = list('sound/weapons/crowbar1.ogg','sound/weapons/crowbar2.ogg')
	toolspeed = 1

/obj/item/weapon/crowbar/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the [name] into \his mouth and proceeds to weigh down! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, 'sound/weapons/grapple.ogg', 50, 1, -1)
	sleep(3)
	var/turf/simulated/location = get_turf(user)
	if(istype(location))
		location.add_blood_floor(user)
	playsound(loc, 'sound/misc/tear.ogg', 50, 1, -1) //RIP AND TEAR. RIP AND TEAR.
	return (BRUTELOSS)

/obj/item/weapon/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"
	force = 8

/obj/item/weapon/crowbar/large
	name = "crowbar"
	desc = "It's a big crowbar. It doesn't fit in your pockets, because it's big."
	force = 12
	w_class = 3
	throw_speed = 3
	throw_range = 3
	materials = list(MAT_METAL=70)
	icon_state = "crowbar_large"
	toolspeed = 2
