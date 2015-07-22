/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "blindfold"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	put_on_delay = 20

/obj/item/clothing/mask/muzzle/attack_paw(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.wear_mask)
			user << "<span class='notice'>You need help taking this off!</span>"
			return
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 1
	flags = MASKCOVERSMOUTH
	flags_inv = HIDEFACE
	visor_flags = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 25, rad = 0)
	action_button_name = "Adjust Sterile Mask"
	ignore_maskadjust = 0

/obj/item/clothing/mask/surgical/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	var/voicechange = 0

/obj/item/clothing/mask/horsehead/speechModification(message)
	if(voicechange)
		message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	return message

/obj/item/clothing/mask/beecowl
	name = "Bee Cowl"
	desc = "JUST YOUR AVERAGE WASP-THEMED SUPER HERO BY DAY!"
	icon_state = "beecowl"
	item_state = "beecowl"
	flags = BLOCKHAIR | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	w_class = 2

/obj/item/clothing/mask/beecowl/beehailer
	name = "Dr. Bee's Cowl"
	desc = "A cowl with a built in cassette deck! It appears to be preloaded with a unremovable cassette however."
	action_button_name = "BEES"
	icon_state = "beecowl"
	var/cooldown = 0
	var/aggressiveness = 2
	ignore_maskadjust = 0
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | BLOCKHAIR
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS

/obj/item/clothing/mask/beecowl/beehailer/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(aggressiveness)
			if(1)
				user << "<span class='notice'>You set the restrictor to the middle position, but all the settings are marked BEES.</span>"
				aggressiveness = 2
			if(2)
				user << "<span class='notice'>You set the restrictor to the last position, but all the settings are marked BEES.</span>"
				aggressiveness = 3
			if(3)
				user << "<span class='notice'>You set the restrictor to the first position, but all the settings are marked BEES.</span>"
				aggressiveness = 1
			if(4)
				user << "<span class='danger'>You adjust the restrictor but nothing happens, probably because its broken.</span>"
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(aggressiveness != 4)
			user << "<span class='danger'>You broke it!</span>"
			aggressiveness = 4
	else
		..()

/obj/item/clothing/mask/beecowl/beehailer/attack_self()
	bees()

/obj/item/clothing/mask/beecowl/beehailer/verb/bees()
	set category = "Object"
	set name = "BEES"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(!can_use(usr))
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null
	var/phrase_sound = null


	if(cooldown < world.time - 50) // Modified Sechailer code, doesn't need the aggressiveness, but will leave it for compatability reasons
		switch(aggressiveness)
			if(1)
				phrase = rand(1,7)
			if(2)
				phrase = rand(1,7)
			if(3)
				phrase = rand(1,7)
			if(4)
				phrase = rand(8,8)

		switch(phrase)	//sets the properties of the chosen phrase
			if(1)
				phrase_text = "Dr. BEEEES"
				phrase_sound = "drbees"
			if(2)
				phrase_text = "A large influx of bees ought to put a stop to that!"
				phrase_sound = "alargeinflux"
			if(3)
				phrase_text = "My briefcase full of bees ought to put a stop to that!"
				phrase_sound = "briefcasefullofbees"
			if(4)
				phrase_text = "On International bring a shit ton of bees to work day!"
				phrase_sound = "shittonofbees"
			if(5)
				phrase_text = "LATER THAT VERY SAME BEE"
				phrase_sound = "laterthatverysamebee"
			if(6)
				phrase_text = "BEES ARE MY ART"
				phrase_sound = "Beearemyart"
			if(7)
				phrase_text = "IF PEOPLE DONT LIKE MY BEES, THEY CAN VOICE THEIR OPINION OR VOTE WITH THEIR WALLETS"
				phrase_sound = "votewithwallet"
			if(8)
				phrase_text = "AGH NO, NOT THE BEES, NOT THE BEES, AHHHHHHGAHAGHAGH"
				phrase_sound = "notthebees"

		usr.visible_message("[usr]'s Cowl: <font color='black' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/complionator/bees/[phrase_sound].ogg", 100, 0, 4)
		cooldown = world.time