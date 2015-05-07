/obj/item/clothing/shoes/proc/step_action(mob/user as mob) //this was made to rewrite clown shoes squeaking
	var/turf/T = get_turf(user)
	if(istype(T, /turf/space)) //Space should never have step sounds
		return
	// if(user.m_intent == "run") //&& prob(50) //to add to stealth
	// 	if (user.footstep < world.time)
	// 		user.footstep = world.time + 5 //Half a second
	// 		playsound(src, "step", 15, 1)
			//playsound(src, pick(T.stepsound), 15, 1)

/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	flags = NOSLIP
	origin_tech = "syndicate=3"

/obj/item/clothing/shoes/sneakers/mime
	name = "mime shoes"
	icon_state = "mime"
	item_color = "mime"

/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "combat boots"
	desc = "High speed, low drag combat boots."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 10, rad = 0)
	strip_delay = 70

/obj/item/clothing/shoes/combat/swat //overpowered boots for death squads
	name = "\improper SWAT boots"
	desc = "High speed, no drag combat boots."
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 80, bullet = 60, laser = 50, energy = 50, bomb = 50, bio = 30, rad = 30)

/obj/item/clothing/shoes/combat/camo //camo boots for ruskies
	name = "camoflage combat boots"
	desc = "High speed, camoflaged, no drag combat boots."
	icon_state = "camoboots"
	item_state = "camoboots"
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 50, bullet = 60, laser = 50, energy = 30, bomb = 20, bio = 10, rad = 15)

/obj/item/clothing/shoes/space_ninja
	name = "ninja shoes"
	desc = "A pair of running shoes. Excellent for running and even better for smashing skulls."
	icon_state = "s-ninja"
	item_state = "secshoes"
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	strip_delay = 120
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	strip_delay = 50
	put_on_delay = 50
	unacidable = 1

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic black shoes."
	name = "magic shoes"
	icon_state = "black"

/obj/item/clothing/shoes/galoshes
	desc = "A pair of yellow rubber boots, designed to prevent slipping on wet surfaces."
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	strip_delay = 50
	put_on_delay = 50

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	item_color = "clown"
	var/footstep = 1	//used for squeeks whilst walking
	var/hacked = 0

/obj/item/clothing/shoes/clown_shoes/emag_act(user as mob)
	if(!hacked)
		user << "<span class='notice'>You hear a strange HONK.</span>"
		hacked = 1
		if(prob(50))
			slowdown=-4
		else
			flags = NOSLIP

/obj/item/clothing/shoes/clown_shoes/step_action(mob/user as mob)
	var/turf/T = get_turf(user)
	if(istype(T, /turf/space)) //Space should never have step sounds
		return
	playsound(src, "clownstep", 30, 1)

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Nanotrasen-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	item_state = "jackboots"
	item_color = "hosred"
	strip_delay = 50
	put_on_delay = 50

/obj/item/clothing/shoes/winterboots
	name = "fur boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	item_state = "winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/workboots
	name = "work boots"
	desc = "Nanotrasen-issue Engineering lace-up work boots for the especially blue-collar."
	icon_state = "workboots"
	item_state = "jackboots"
	strip_delay = 40
	put_on_delay = 40


/obj/item/clothing/shoes/cult
	name = "cultist boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	item_state = "cult"
	item_color = "cult"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume."
	icon_state = "boots"

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"
	put_on_delay = 50

/obj/item/clothing/shoes/roman
	name = "roman sandals"
	desc = "Sandals with buckled leather straps on it."
	icon_state = "roman"
	item_state = "roman"
	strip_delay = 100
	put_on_delay = 100

/obj/item/clothing/shoes/griffin
	name = "griffon boots"
	desc = "A pair of costume boots fashioned after bird talons."
	icon_state = "griffinboots"
	item_state = "griffinboots"

/obj/item/clothing/shoes/discoputin
	name = "disco shoes"
	desc = "Using the most advanced in bluespace disco technology, you too can dance the night away!"
	icon_state = "discoputin"
	item_state = "discoputin"
