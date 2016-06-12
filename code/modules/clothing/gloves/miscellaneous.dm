
/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	put_on_delay = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT

/obj/item/clothing/gloves/botanic_leather
	name = "botanist's leather gloves"
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin.  They're also quite warm."
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = -1 //Not Burnable

/obj/item/clothing/gloves/combat
	name = "combat gloves"
	desc = "These tactical gloves are fireproof and shock resistant."
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/gloves/pickpocket
	name = "black gloves"
	desc = "A pair of gloves, they make you feel sneaky for whatever reason."
	icon_state = "black"
	item_state = "bgloves"
	item_color = null

/obj/item/clothing/gloves/proc/chameleon(var/mob/user)
	var/input_gloves = input(user, "Choose a piece of gloves to disguise as.", "Choose gloves style.") as null|anything in list("Fingerless", "Botanist", "Combat", "Black", "Insulated", "Latex","Nitrile","White", "Boxing Red", "Boxing Green", "Boxing Blue", "Boxing Yellow")

	if(user && src in user.contents)
		switch(input_gloves)
			if("Fingerless")
				name = "fingerless gloves"
				icon_state = "fingerless"
				item_state = "fingerless"
			if("Botanist")
				name = "botanist's leather gloves"
				icon_state = "leather"
				item_state = "ggloves"
			if("Combat")
				name = "combat gloves"
				icon_state = "black"
				item_state = "bgloves"
			if("Black")
				name = "black gloves"
				icon_state = "black"
				item_state = "bgloves"
			if("Insulated")
				name = "insulated gloves"
				icon_state = "yellow"
				item_state = "ygloves"
			if("Latex")
				name = "latex gloves"
				icon_state = "latex"
				item_state = "lgloves"
			if("Nitrile")
				name = "nitrile gloves"
				icon_state = "nitrile"
				item_state = "nitrilegloves"
			if("White")
				name = "white gloves"
				icon_state = "white"
				item_state = "wgloves"
			if("Boxing Red")
				name = "boxing gloves"
				icon_state = "boxing"
				item_state = "boxing"
			if("Boxing Green")
				name = "boxing gloves"
				icon_state = "boxinggreen"
				item_state = "boxingreen"
			if("Boxing Blue")
				name = "boxing gloves"
				icon_state = "boxingblue"
				item_state = "boxingblue"
			if("Boxing Yellow")
				name = "boxing gloves"
				icon_state = "boxingyellow"
				item_state = "boxingyellow"
