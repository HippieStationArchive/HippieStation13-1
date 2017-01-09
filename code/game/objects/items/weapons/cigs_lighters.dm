//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

///////////
//MATCHES//
///////////
/obj/item/weapon/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = 0
	var/smoketime = 5
	w_class = 1
	origin_tech = "materials=1"
	heat = 1000
	burn_state = 0 //If this is in a fire, a lot more than the top is gonna burn.

/obj/item/weapon/match/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		matchburnout()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/weapon/match/fire_act()
	matchignite()

/obj/item/weapon/match/proc/matchignite()
	if(lit == 0)
		lit = 1
		icon_state = "match_lit"
		damtype = BURN
		force = 3
		hitsound = 'sound/items/welder.ogg'
		item_state = "cigon"
		name = "lit match"
		desc = "A match. This one is lit."
		attack_verb = list("burnt","singed")
		SSobj.processing |= src
		update_icon()
	return

/obj/item/weapon/match/proc/matchburnout()
	if(lit == 1)
		lit = -1
		damtype = BRUTE
		force = initial(force)
		icon_state = "match_burnt"
		item_state = "cigoff"
		name = "burnt match"
		desc = "A match. This one has seen better days."
		attack_verb = null
		SSobj.processing.Remove(src)

/obj/item/weapon/match/dropped(mob/user)
	matchburnout()
	return ..()

/obj/item/weapon/match/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return
	M.IgniteMob()
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M,user)
	if(lit && cig && user.a_intent == "help")
		if(cig.lit)
			user << "<span class='notice'>The [cig.name] is already lit.</span>"
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/proc/help_light_cig(mob/living/carbon/M, mob/living/carbon/user)
	if(!iscarbon(M))
		return
	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		return cig

/obj/item/weapon/match/is_hot()
	return lit * heat

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	body_parts_covered = null
	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/weapon/cigbutt
	var/lastHolder = null
	var/smoketime = 300
	var/chem_volume = 30
	heat = 1000
	burn_state = 0
	can_be_washed = 0

/obj/item/clothing/mask/cigarette/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is huffing the [src.name] as quickly as they can! It looks like \he's trying to give \himself cancer.</span>")
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/cigarette/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarette a chemical holder with a maximum volume of 15
	reagents.add_reagent("nicotine", 15)

/obj/item/clothing/mask/cigarette/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(!lit && smoketime > 0 && W.is_hot())
		var/lighting_text = is_lighter(W,user)
		if(lighting_text)
			light(lighting_text)
			return
	return

/obj/item/clothing/mask/cigarette/afterattack(obj/item/weapon/reagent_containers/glass/glass, mob/user, proximity)
	if(!proximity || lit) //can't dip if cigarette is lit (it will heat the reagents in the glass instead)
		return
	if(istype(glass))	//you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			user << "<span class='notice'>You dip \the [src] into \the [glass].</span>"
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				user << "<span class='notice'>[glass] is empty.</span>"
			else
				user << "<span class='notice'>[src] is full.</span>"

/obj/item/clothing/mask/cigarette/proc/is_lighter(obj/item/O, mob/user)
	var/lighting_text = null
	if(istype(O, /obj/item/weapon/weldingtool))
		lighting_text = "<span class='notice'>[user] casually lights the [name] with [O], what a badass.</span>"
	else if(istype(O, /obj/item/weapon/lighter/greyscale)) // we have to check for this first -- zippo lighters are default
		lighting_text = "<span class='notice'>After some fiddling, [user] manages to light their [name] with [O].</span>"
	else if(istype(O, /obj/item/weapon/lighter))
		lighting_text = "<span class='rose'>With a single flick of their wrist, [user] smoothly lights their [name] with [O]. Damn they're cool.</span>"
	else if(istype(O, /obj/item/weapon/melee/energy))
		lighting_text = "<span class='warning'>[user] swings their [O], barely missing their nose. They light their [name] in the process.</span>"
	else if(istype(O, /obj/item/device/assembly/igniter))
		lighting_text = "<span class='notice'>[user] fiddles with [O], and manages to light their [name].</span>"
	else if(istype(O, /obj/item/device/flashlight/flare))
		lighting_text = "<span class='notice'>[user] lights their [name] with [O] like a real badass.</span>"
	else if(O.is_hot())
		lighting_text = "<span class='notice'>[user] lights their [name] with [O].</span>"
	return lighting_text

/obj/item/clothing/mask/cigarette/proc/light(flavor_text = null)
	if(!src.lit)
		src.lit = 1
		name = "lit [name]"
		attack_verb = list("burnt", "singed")
		hitsound = 'sound/items/welder.ogg'
		damtype = BURN
		force = 4
		if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			if(ismob(loc))
				var/mob/M = loc
				M.unEquip(src, 1)
			qdel(src)
			return
		if(reagents.get_reagent_amount("nitroglycerin")) // nitroglycerin is a ridiculously strong explosive that should explode like plasma when smoked
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("nitroglycerin") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			if(ismob(loc))
				var/mob/M = loc
				M.unEquip(src, 1)
			qdel(src)
			return 
		if(reagents.get_reagent_amount("blackpowder")) // blackpowder isn't as strong as nitroglycerin but it's stronger than welding fuel
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("blackpowder") / 3.75, 1), get_turf(src), 0, 0)
			e.start()
			if(ismob(loc))
				var/mob/M = loc
				M.unEquip(src, 1)
			qdel(src)
			return
		if(reagents.get_reagent_amount("welding_fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("welding_fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			if(ismob(loc))
				var/mob/M = loc
				M.unEquip(src, 1)
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		if(flavor_text)
			var/turf/T = get_turf(src)
			T.visible_message(flavor_text)
		SSobj.processing |= src

		//can't think of any other way to update the overlays :<
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_wear_mask()
			M.update_inv_l_hand()
			M.update_inv_r_hand()


/obj/item/clothing/mask/cigarette/proc/handle_reagents()
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				if(prob(15)) // so it's not an instarape in case of acid
					var/fraction = min(REAGENTS_METABOLISM/reagents.total_volume, 1)
					reagents.reaction(C, INGEST, fraction)
				reagents.trans_to(C, REAGENTS_METABOLISM)
				return
		reagents.remove_any(REAGENTS_METABOLISM)


/obj/item/clothing/mask/cigarette/process()
	var/turf/location = get_turf(src)
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	smoketime--
	if(smoketime < 1)
		new type_butt(location)
		SSobj.processing.Remove(src)
		if(ismob(loc))
			M << "<span class='notice'>Your [name] goes out.</span>"
			M.unEquip(src, 1)	//un-equip it so the overlays can update //Force the un-equip so the overlays update
		qdel(src)
		return
	if(location)
		location.hotspot_expose(700, 5)
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		handle_reagents()
	return


/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on \the [src], putting it out instantly.</span>")
		new type_butt(user.loc)
		new /obj/effect/decal/cleanable/ash(user.loc)
		SSobj.processing.Remove(src)
		qdel(src)
	return ..()

/obj/item/clothing/mask/cigarette/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M,user)
	if(lit && cig && user.a_intent == "help")
		if(cig.lit)
			user << "<span class='notice'>The [cig.name] is already lit.</span>"
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		return ..()

/obj/item/clothing/mask/cigarette/fire_act()
	light()

/obj/item/clothing/mask/cigarette/is_hot()
	return lit * heat

/obj/item/clothing/mask/cigarette/rollie
	name = "rollie"
	desc = "A roll of dried plant matter wrapped in thin paper."
	icon_state = "spliffoff"
	icon_on = "spliffon"
	icon_off = "spliffoff"
	type_butt = /obj/item/weapon/cigbutt/roach
	throw_speed = 0.5
	item_state = "spliffoff"
	smoketime = 180
	chem_volume = 50

/obj/item/clothing/mask/cigarette/rollie/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

/obj/item/clothing/mask/cigarette/rollie/trippy/New()
	..()
	reagents.add_reagent("mushroomhallucinogen", 50)
	light()
	//for(var/mob/M in player_list)	M << 'sound/misc/Smoke_Weed_Everyday.ogg'


/obj/item/weapon/cigbutt/roach
	name = "roach"
	desc = "A manky old roach, or for non-stoners, a used rollup."
	icon_state = "roach"

/obj/item/weapon/cigbutt/roach/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	type_butt = /obj/item/weapon/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 40

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 2000
	chem_volume = 80


/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 50

/obj/item/weapon/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 0
	burn_state = 0

/obj/item/weapon/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 0
	chem_volume = 100
	var/packeditem = 0

/obj/item/clothing/mask/cigarette/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/cigarette/pipe/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			M << "<span class='notice'>Your [name] goes out.</span>"
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask()
			packeditem = 0
			name = "empty [initial(name)]"
		SSobj.processing.Remove(src)
		return
	if(location)
		location.hotspot_expose(700, 5)
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		handle_reagents()
	return


/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = O
		if(!packeditem)
			if(G.dry == 1)
				user << "<span class='notice'>You stuff [O] into [src].</span>"
				smoketime = 400
				packeditem = 1
				name = "[O.name]-packed [initial(name)]"
				if(O.reagents)
					O.reagents.trans_to(src, O.reagents.total_volume)
				qdel(O)
			else
				user << "<span class='warning'>It has to be dried first!</span>"
		else
			user << "<span class='warning'>It is already packed!</span>"
	else
		var/lighting_text = is_lighter(O,user)
		if(lighting_text)
			if(smoketime > 0)
				light(lighting_text)
			else
				user << "<span class='warning'>There is nothing to smoke!</span>"
		else
			user << "<span class='warning'>You can't put that in the pipe!</span>"
	..()


/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user)
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>", "<span class='notice'>You put out [src].</span>")
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		SSobj.processing.Remove(src)
		return
	if(!lit && smoketime > 0)
		user << "<span class='notice'>You empty [src] onto [location].</span>"
		new /obj/effect/decal/cleanable/ash(location)
		packeditem = 0
		smoketime = 0
		reagents.clear_reagents()
		name = "empty [initial(name)]"
	return

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen and kept popular in the modern age and beyond by space hipsters. Can be loaded with objects."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	smoketime = 0
	burn_state = 0


/////////
//ZIPPO//
/////////
/obj/item/weapon/lighter
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "zippo"
	item_state = "zippo"
	w_class = 1
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/lit = 0
	heat = 1500
	var/sound_toggleON = 'sound/items/zippo_on.ogg'
	var/sound_toggleOFF = 'sound/items/zippo_off.ogg'

/obj/item/weapon/lighter/greyscale
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon_state = "lighter"
	sound_toggleON = 'sound/items/lighter_on.ogg'
	sound_toggleOFF = 'sound/items/lighter_off.ogg'

/obj/item/weapon/lighter/greyscale/New()
	var/image/I = image(icon,"lighter-overlay")
	I.color = color2hex(randomColor(1))
	overlays += I

/obj/item/weapon/lighter/update_icon()
	icon_state = lit ? "[icon_state]_on" : "[initial(icon_state)]"

/obj/item/weapon/lighter/attack_self(mob/living/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			playsound(src, sound_toggleON, 30, 1, -1)
			update_icon()
			force = 5
			damtype = BURN
			hitsound = 'sound/items/welder.ogg'
			attack_verb = list("burnt", "singed")
			if(!istype(src, /obj/item/weapon/lighter/greyscale))
				user.visible_message("Without even breaking stride, [user] flips open and lights [src] in one smooth movement.", "<span class='notice'>Without even breaking stride, you flip open and lights [src] in one smooth movement.</span>")
			else
				if(prob(75))
					user.visible_message("After a few attempts, [user] manages to light [src].", "<span class='notice'>After a few attempts, you manage to light [src].</span>")
				else
					var/hitzone = user.r_hand == src ? "r_hand" : "l_hand"
					user.apply_damage(5, BURN, hitzone)
					user.visible_message("<span class='warning'>After a few attempts, [user] manages to light [src] - they however burn their finger in the process.</span>", "<span class='warning'>You burn yourself while lighting the lighter!</span>")

			user.AddLuminosity(1)
			SSobj.processing |= src
		else
			lit = 0
			playsound(src, sound_toggleOFF, 30, 1, -1)
			update_icon()
			hitsound = "swing_hit"
			force = 0
			attack_verb = null //human_defense.dm takes care of it
			if(!istype(src, /obj/item/weapon/lighter/greyscale))
				user.visible_message("You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing. Wow.", "<span class='notice'>You quietly shut off [src] without even looking at what you're doing. Wow.</span>")
			else
				user.visible_message("[user] quietly shuts off [src].", "<span class='notice'>You quietly shut off [src].")
			user.AddLuminosity(-1)
			SSobj.processing.Remove(src)
	else
		return ..()
	return

/obj/item/weapon/lighter/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return
	if(lit)
		M.IgniteMob()
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M,user)
	if(lit && cig && user.a_intent == "help")
		if(cig.lit)
			user << "<span class='notice'>The [cig.name] is already lit.</span>"
		if(M == user)
			cig.attackby(src, user)
		else
			if(!istype(src, /obj/item/weapon/lighter/greyscale))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M]. Their arm is as steady as the unflickering flame they light \the [cig] with.</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/weapon/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

/obj/item/weapon/lighter/pickup(mob/user)
	if(lit)
		SetLuminosity(0)
		user.AddLuminosity(1)
	return


/obj/item/weapon/lighter/dropped(mob/user)
	if(lit)
		if(user)
			user.AddLuminosity(-1)
		SetLuminosity(1)
	return

/obj/item/weapon/lighter/is_hot()
	return lit * heat

///////////
//ROLLING//
///////////
/obj/item/weapon/rollingpaper
	name = "rolling paper"
	desc = "A thin piece of paper used to make fine smokeables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper"
	w_class = 1
	burn_state = 0

/obj/item/weapon/rollingpaper/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/O = target
		if(O.dry)
			user.unEquip(target, 1)
			user.unEquip(src, 1)
			var/obj/item/clothing/mask/cigarette/rollie/R = new /obj/item/clothing/mask/cigarette/rollie(user.loc)
			R.chem_volume = target.reagents.total_volume
			target.reagents.trans_to(R, R.chem_volume)
			user.put_in_active_hand(R)
			user << "<span class='notice'>You roll the [target.name] into a rolling paper.</span>"
			R.desc = "Dried [target.name] rolled up in a thin piece of paper."
			qdel(target)
			qdel(src)
		else
			user << "<span class='warning'>You need to dry this first!</span>"
	else
		..()


///////////////
//VAPE NATION//
///////////////
/obj/item/clothing/mask/vape
	name = "e-Cigarette"
	desc = "A classy and highly sophisticated electronic cigarette, for classy and dignified gentlemen. A warning label reads \"Warning: do not fill with flamable materials!\""//<<< i'd vape to that.
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = null
	item_state = null
	var/chem_volume = 100
	var/vapetime = 0 //this so it won't puff out clouds every tick
	var/screw = 0 // kinky
	var/super = 0 //for the fattest vapes dude.
	emagged = 0 //LET THE GRIEF BEGIN

/obj/item/clothing/mask/vape/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is puffin hard on dat vape, they trying to join the vape life on a whole notha' plane!")//it doesn't give you cancer, it is cancer
	return (TOXLOSS|OXYLOSS)


/obj/item/clothing/mask/vape/New(loc, var/param_color = null)
	..()
	create_reagents(chem_volume)
	flags |= NOREACT // so it doesn't react until you light it
	reagents.add_reagent("nicotine", 50)
	if(!icon_state)
		if(!param_color)
			param_color = pick("red","blue","black","white","green","purple","yellow","orange")
		icon_state = "[param_color]_vape"
		item_state = "[param_color]_vape"

//The reagent thing was here
/obj/item/clothing/mask/vape/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/screwdriver))
		if(!screw)
			screw = 1
			flags |= OPENCONTAINER
			user << "<span class='notice'>You open the cap on the [src].</span>"
			if(super & !emagged)
				var/image/I = (image(icon, "vapeopen_med"))
				overlays += I
			if(emagged)
				var/image/I = (image(icon, "vapeopen_high"))
				overlays += I
			if(!super & !emagged)
				var/image/I = (image(icon, "vapeopen_low"))
				overlays += I
		else
			screw = 0
			flags &= ~OPENCONTAINER
			user << "<span class='notice'>You close the cap on the [src].</span>"
			overlays.Cut()

	if(istype(O, /obj/item/device/multitool))
		if(screw && !emagged)//also kinky
			if(!super)
				overlays.Cut()
				super = 1
				user << "<span class='notice'>You increase the voltage in the [src].</span>"
				var/image/I = (image(icon, "vapeopen_med"))
				overlays += I
			else
				overlays.Cut()
				super = 0
				user << "<span class='notice'>You decrease the voltage in the [src].</span>"
				var/image/I = (image(icon, "vapeopen_low"))
				overlays += I
		
		if(screw && emagged)
			user << "<span class='notice'>The [name] can't be modified!</span>"


/obj/item/clothing/mask/vape/emag_act(mob/user)// I WON'T REGRET WRITTING THIS, SURLY.
	if(screw)
		if(!emagged)
			overlays.Cut()
			emagged = 1
			super = 0
			user << "<span class='warning'>You maximize the voltage in the [src]!</span>"
			var/image/I = (image(icon, "vapeopen_high"))
			overlays += I
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread //for effect
			sp.set_up(5, 1, src)
			sp.start()
		else
			user << "<span class='warning'>The [name] is already emagged!</span>"
	else
		user << "<span class='notice'>You need to open the cap to do that!</span>"

/obj/item/clothing/mask/vape/attack_self(mob/user)
	if(reagents.total_volume > 0)
		user << "<span class='notice'>You empty [src] of all reagents.</span>"
		reagents.clear_reagents()
	return

/obj/item/clothing/mask/vape/equipped(mob/user, slot)
	if(slot == slot_wear_mask)
		if(!screw)
			user << "<span class='notice'>You start puffing on that dank vape.</span>"
			flags &= ~NOREACT // allowing reagents to react after being lit
			SSobj.processing |= src
		else //it will not start if the vape is opened.
			user << "<span class='warning'>You need to close the cap first!</span>"

/obj/item/clothing/mask/vape/dropped(mob/user)
	var/mob/living/carbon/C = user
	if(C.get_item_by_slot(slot_wear_mask) == src)
		flags |= NOREACT
		SSobj.processing.Remove(src)

/obj/item/clothing/mask/vape/proc/hand_reagents()//had to rename to avoid duplicate error
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				if(prob(18)) //Slightly more reactive than cigarettes, but EVEN LESS than it was before
					var/fraction = min(REAGENTS_METABOLISM/reagents.total_volume, 1)
					reagents.reaction(C, INGEST, fraction)
				if(reagents.get_reagent_amount("welding_fuel"))
					//HOT STUFF
					C.fire_stacks = 2
					C.IgniteMob()
				if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
					var/datum/effect_system/reagents_explosion/e = new()
					e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
					e.start()
					if(ismob(loc))
						var/mob/M = loc
						M.unEquip(src, 1)
					qdel(src)
				reagents.trans_to(C, REAGENTS_METABOLISM)
				return
			reagents.remove_any(REAGENTS_METABOLISM)

/obj/item/clothing/mask/vape/process()
	var/mob/living/M = loc

	if(isliving(loc))
		M.IgniteMob()

	vapetime++

	if(!reagents.total_volume)
		if(ismob(loc))
			M << "<span class='notice'>The [name] is empty!</span>"
			SSobj.processing.Remove(src)
			//it's reusable so it won't unequip when empty
		return
	//open flame removed because vapes are a closed system, they wont light anything on fire

	if(super && vapetime > 3)//Time to start puffing those fat vapes, yo.
		var/datum/effect_system/smoke_spread/chem/s = new
		s.set_up(reagents, 0, loc, silent=TRUE)
		s.start()
		vapetime = 0
		if(prob(3))//Chance added to super vape pens too
			playsound(get_turf(src), 'sound/effects/pop_expl.ogg', 50, 0)
			M.apply_damage(15, BURN, "head") //Less damage
			M.unEquip(src, 1)
			M.Weaken(15, 1, 0)
			qdel(src)
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread
			sp.set_up(5, 1, src)
			sp.start()
			M << "<span class='userdanger'>The [name] suddenly explodes in your mouth!</span>"

	if(emagged && vapetime > 3)
		var/datum/effect_system/smoke_spread/chem/s = new
		s.set_up(reagents, 3, loc, silent=TRUE)
		s.start()
		vapetime = 0
		if(prob(8))//small chance for the vape to break and deal damage if it's emagged
			playsound(get_turf(src), 'sound/effects/pop_expl.ogg', 50, 0)
			M.apply_damage(20, BURN, "head")
			M.unEquip(src, 1)
			M.Weaken(15, 1, 0)
			qdel(src)
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread
			sp.set_up(5, 1, src)
			sp.start()
			M << "<span class='userdanger'>The [name] suddenly explodes in your mouth!</span>"

	if(reagents && reagents.total_volume)
		hand_reagents()