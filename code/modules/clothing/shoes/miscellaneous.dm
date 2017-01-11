

/obj/item/clothing/shoes/baneboots
    name = "baneboots"
    desc = "Speak of the devil and he shall appear."
    icon_state = "baneboots"
    item_state = "baneboots"
    armor = list(melee = 10, bullet = 25, laser = 10)
    strip_delay = 70
    burn_state = -1


/obj/item/clothing/shoes/proc/step_action() //this was made to rewrite clown shoes squeaking

/obj/item/clothing/shoes/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is bashing their own head in with [src]! Ain't that a kick in the head?</span>")
	for(var/i = 0, i < 3, i++)
		sleep(3)
		playsound(user, 'sound/weapons/genhit2.ogg', 50, 1)
	return(BRUTELOSS)

/obj/item/clothing/shoes/sneakers/syndigaloshes
	desc = "A pair of brown shoes."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	flags = NOSLIP
	origin_tech = "syndicate=3"
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/sneakers/mime
	name = "mime shoes"
	icon_state = "mime"
	item_color = "mime"

/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "combat boots"
	desc = "High speed, low drag combat boots."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor = list(melee = 25, bullet = 25, laser = 25, energy = 25, bomb = 50, bio = 10, rad = 0)
	strip_delay = 70
	burn_state = -1 //Won't burn in fires
	stomp = 1

/obj/item/clothing/shoes/combat/swat //overpowered boots for death squads
	name = "\improper SWAT boots"
	desc = "High speed, no drag combat boots."
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 40, bullet = 30, laser = 25, energy = 25, bomb = 50, bio = 30, rad = 30)

/obj/item/clothing/shoes/combat/camo //camo boots for ruskies
	name = "camoflage combat boots"
	desc = "High speed, camoflaged, no drag combat boots."
	icon_state = "camoboots"
	item_state = "camoboots"
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 50, bullet = 60, laser = 50, energy = 30, bomb = 20, bio = 10, rad = 15)

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
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/galoshes/dry
	name = "absorbent galoshes"
	desc = "A pair of orange rubber boots, designed to prevent slipping on wet surfaces while also drying them."
	icon_state = "galoshes_dry"

/obj/item/clothing/shoes/galoshes/dry/step_action()
	var/turf/simulated/t_loc = get_turf(src)
	if(istype(t_loc) && t_loc.wet)
		t_loc.MakeDry(TURF_WET_WATER)

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	item_color = "clown"
	var/footstep = 1	//used for squeeks whilst walking
	burn_state = -1

/obj/item/clothing/shoes/clown_shoes/step_action()
	if(footstep > 1)
		playsound(src, "clownstep", 50, 1)
		footstep = 0
	else
		footstep++

/obj/item/clothing/shoes/clown_shoes/cluwne
	icon_state = "cluwne"
	item_state = "cluwne"
	unacidable = 1
	burn_state = -1
	flags = NODROP

/obj/item/clothing/shoes/clown_shoes/cluwne/dropped(mob/user)
	qdel(src)

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Nanotrasen-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	item_state = "jackboots"
	item_color = "hosred"
	strip_delay = 50
	put_on_delay = 50
	cold_protection = FEET //Regular black shoes have this, workboots should too.
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	burn_state = -1 //Won't burn in fires
	stomp = 1

/obj/item/clothing/shoes/winterboots
	name = "winter boots"
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
	cold_protection = FEET //Regular black shoes have this, workboots should too.
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	burn_state = -1

/obj/item/clothing/shoes/cult
	name = "nar-sian invoker boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	item_state = "cult"
	item_color = "cult"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	burn_state = -1

/obj/item/clothing/shoes/cult/alt
	name = "cultist boots"
	icon_state = "cultalt"

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
	burn_state = -1

/obj/item/clothing/shoes/griffin
	name = "griffon boots"
	desc = "A pair of costume boots fashioned after bird talons."
	icon_state = "griffinboots"
	item_state = "griffinboots"

/obj/item/clothing/shoes/rollerskates
	name = "blastco rollerskates"
	desc = "A pair of roller skates, syndicate style. Will make you go faster."
	icon_state = "magboots-old1"
	item_state = "magboots-old1"
	slowdown = -1

/obj/item/clothing/shoes/rollerskates/hockey
	name = "Ka-Nada Hyperblades"
	desc = "A pair of all terrain techno-skates, enabling a skilled skater to move freely and quickly."
	icon_state = "hockey_shoes"
	item_state = "hockey_shoes"
	flags = NODROP

/obj/item/clothing/shoes/dio
	name = "DIO's ring shoes"
	desc = "These help you stand."
	icon_state = "DIO"
	item_color = "DIO"
	item_state = "DIO"

/obj/item/clothing/shoes/jotaro
	name = "Delinquent's shoes"
	desc = "Stand above the rest."
	icon_state = "jotaro"
	item_state = "jotaro"
