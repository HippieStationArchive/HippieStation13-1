/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. While good for concealing your identity, it isn't good for blocking gas flow. These particular models have a cosmetic-changing feature." //More accurate
	icon_state = "gas_alt"
	flags = MASKCOVERSMOUTH | MASKCOVERSEYES | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	w_class = 3.0
	item_state = "gas_altold"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01

/obj/item/clothing/mask/gas/attack_self(mob/user)

	var/mob/M = usr
	var/list/options = list()
	options["New-Russian Gas Mask"] = "gas_altold"		//Old gas mask.
	options["NT RV2 Gas Mask"] = "gas_mask"		//Ye Olde Goon gas mask(?).
	options["NT Standard Gas Mask"] = "gas_alt"		//Current gas mask.

	var/choice = input(M,"To what form do you wish to morph this gas mask??","Morph Mask") in options

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		M << "Your gas mask has now morphed into the [choice]!"
		return 1

// **** Welding gas mask ****

/obj/item/clothing/mask/gas/welding
	name = "welding mask"
	desc = "A gas mask with built-in welding goggles and a face shield. Looks like a skull - clearly designed by a nerd."
	icon_state = "weldingmask"
	m_amt = 4000
	g_amt = 2000
	flash_protect = 2
	tint = 2
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	origin_tech = "materials=2;engineering=2"
	action_button_name = "Toggle Welding Mask"
	visor_flags = MASKCOVERSEYES
	visor_flags_inv = HIDEEYES

/obj/item/clothing/mask/gas/welding/attack_self()
	toggle()

/obj/item/clothing/mask/gas/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding mask"
	set src in usr

	weldingvisortoggle()


// ********************************************************************

// **** Security gas mask ****

/obj/item/clothing/mask/gas/sechailer
	name = "security gas mask"
	desc = "A standard issue Security gas mask with integrated 'Compli-o-nator 3000' device. Plays over a dozen pre-recorded compliance phrases designed to get scumbags to stand still whilst you taze them. Do not tamper with the device."
	action_button_name = "HALT!"
	icon_state = "sechailer"
	var/cooldown = 0
	var/aggressiveness = 2
	ignore_maskadjust = 0
	flags = MASKCOVERSMOUTH | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACE
	visor_flags = MASKCOVERSMOUTH | BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACE

/obj/item/clothing/mask/gas/sechailer/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask with an especially aggressive Compli-o-nator 3000."
	action_button_name = "HALT!"
	icon_state = "swat"
	aggressiveness = 3
	ignore_maskadjust = 1

/obj/item/clothing/mask/gas/sechailer/cyborg
	name = "security hailer"
	desc = "A set of recognizable pre-recorded messages for cyborgs to use when apprehending criminals."
	icon = 'icons/obj/device.dmi'
	icon_state = "taperecorder_idle"
	aggressiveness = 1 //Borgs are nicecurity!

/obj/item/clothing/mask/gas/sechailer/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(aggressiveness)
			if(1)
				user << "<span class='notice'>You set the restrictor to the middle position.</span>"
				aggressiveness = 2
			if(2)
				user << "<span class='notice'>You set the restrictor to the last position.</span>"
				aggressiveness = 3
			if(3)
				user << "<span class='notice'>You set the restrictor to the first position.</span>"
				aggressiveness = 1
			if(4)
				user << "<span class='danger'>You adjust the restrictor but nothing happens, probably because its broken.</span>"
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(aggressiveness != 4)
			user << "<span class='danger'>You broke it!</span>"
			aggressiveness = 4
	else
		..()

/obj/item/clothing/mask/gas/sechailer/verb/adjust()
	set category = "Object"
	set name = "Adjust Mask"
	adjustmask(usr)

/obj/item/clothing/mask/gas/sechailer/attack_self()
	halt()

/obj/item/clothing/mask/gas/sechailer/verb/halt()
	set category = "Object"
	set name = "HALT"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(!can_use(usr))
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null
	var/phrase_sound = null


	if(cooldown < world.time - 35) // A cooldown, to stop people being jerks
		switch(aggressiveness)		// checks if the user has unlocked the restricted phrases
			if(1)
				phrase = rand(1,5)	// set the upper limit as the phrase above the first 'bad cop' phrase, the mask will only play 'nice' phrases
			if(2)
				phrase = rand(1,11)	// default setting, set upper limit to last 'bad cop' phrase. Mask will play good cop and bad cop phrases
			if(3)
				phrase = rand(1,18)	// user has unlocked all phrases, set upper limit to last phrase. The mask will play all phrases
			if(4)
				phrase = rand(12,18)	// user has broke the restrictor, it will now only play shitcurity phrases

		switch(phrase)	//sets the properties of the chosen phrase
			if(1)				// good cop
				phrase_text = "HALT! HALT! HALT!"
				phrase_sound = "halt"
			if(2)
				phrase_text = "Stop in the name of the Law."
				phrase_sound = "bobby"
			if(3)
				phrase_text = "Compliance is in your best interest."
				phrase_sound = "compliance"
			if(4)
				phrase_text = "Prepare for justice!"
				phrase_sound = "justice"
			if(5)
				phrase_text = "Running will only increase your sentence."
				phrase_sound = "running"
			if(6)				// bad cop
				phrase_text = "Don't move, Creep!"
				phrase_sound = "dontmove"
			if(7)
				phrase_text = "Down on the floor, Creep!"
				phrase_sound = "floor"
			if(8)
				phrase_text = "Dead or alive you're coming with me."
				phrase_sound = "robocop"
			if(9)
				phrase_text = "God made today for the crooks we could not catch yesterday."
				phrase_sound = "god"
			if(10)
				phrase_text = "Freeze, Scum Bag!"
				phrase_sound = "freeze"
			if(11)
				phrase_text = "Stop right there, criminal scum!"
				phrase_sound = "imperial"
			if(12)				// LA-PD
				phrase_text = "Stop or I'll bash you."
				phrase_sound = "bash"
			if(13)
				phrase_text = "Go ahead, make my day."
				phrase_sound = "harry"
			if(14)
				phrase_text = "Stop breaking the law, ass hole."
				phrase_sound = "asshole"
			if(15)
				phrase_text = "You have the right to shut the fuck up."
				phrase_sound = "stfu"
			if(16)
				phrase_text = "Shut up crime!"
				phrase_sound = "shutup"
			if(17)
				phrase_text = "Face the wrath of the golden bolt."
				phrase_sound = "super"
			if(18)
				phrase_text = "I am, the LAW!"
				phrase_sound = "dredd"

		usr.visible_message("[usr]'s Compli-o-Nator: <font color='red' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/complionator/[phrase_sound].ogg", 100, 0, 4)
		cooldown = world.time



// ********************************************************************


//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out toxins but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 75, rad = 0)

/obj/item/clothing/mask/gas/plaguedoctor/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/syndicate
	name = "syndicate mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "syndicate"
	strip_delay = 60

/obj/item/clothing/mask/gas/syndicate/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/voice
	name = "gas mask"
	//desc = "A face-covering mask that can be connected to an air supply. It seems to house some odd electronics."
	var/mode = 0// 0==Scouter | 1==Night Vision | 2==Thermal | 3==Meson
	var/voice = "Unknown"
	var/vchange = 0//This didn't do anything before. It now checks if the mask has special functions/N
	origin_tech = "syndicate=4"
	action_button_name = "Toggle mask"

/obj/item/clothing/mask/gas/voice/attack_self(mob/user)
	vchange = !vchange
	user << "<span class='notice'>The voice changer is now [vchange ? "on" : "off"]!</span>"

/obj/item/clothing/mask/gas/voice/space_ninja
	name = "ninja mask"
	desc = "A close-fitting mask that acts both as an air filter and a post-modern fashion statement."
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	vchange = 1
	strip_delay = 120

/obj/item/clothing/mask/gas/voice/space_ninja/speechModification(message)
	if(voice == "Unknown")
		if(copytext(message, 1, 2) != "*")
			var/list/temp_message = text2list(message, " ")
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++)
				pick_list += i
			for(var/i=1, i <= abs(temp_message.len/3), i++)
				var/H = pick(pick_list)
				if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
				temp_message[H] = ninjaspeak(temp_message[H])
				pick_list -= H
			message = list2text(temp_message, " ")
			message = replacetext(message, "o", "?")
			message = replacetext(message, "p", "?")
			message = replacetext(message, "l", "?")
			message = replacetext(message, "s", "?")
			message = replacetext(message, "u", "?")
			message = replacetext(message, "b", "?")
	return message


/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	alloweat = 1
	icon_state = "clown"
	item_state = "clown_hat"

obj/item/clothing/mask/gas/clown_hat/attack_self(mob/user)

	var/mob/M = usr
	var/list/options = list()
	options["True Form"] = "clown"
	options["The Feminist"] = "sexyclown"
	options["The Madman"] = "joker"
	options["The Rainbow Color"] ="rainbow"

	var/choice = input(M,"To what form do you wish to Morph this mask?","Morph Mask") in options

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		M << "Your Clown Mask has now morphed into [choice], all praise the Honk Mother!"
		return 1

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	alloweat = 1
	icon_state = "sexyclown"
	item_state = "sexyclown"

/obj/item/clothing/mask/gas/sexyclown/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	alloweat = 1
	icon_state = "mime"
	item_state = "mime"

/obj/item/clothing/mask/gas/mime/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	alloweat = 1
	icon_state = "monkeymask"
	item_state = "monkeymask"

/obj/item/clothing/mask/gas/monkeymask/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	alloweat = 1
	icon_state = "sexymime"
	item_state = "sexymime"

/obj/item/clothing/mask/gas/sexymime/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/death_commando
	name = "Death Commando Mask"
	icon_state = "death_commando_mask"
	item_state = "death_commando_mask"

/obj/item/clothing/mask/gas/death_commando/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop."
	icon_state = "death"

/obj/item/clothing/mask/gas/cyborg/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	alloweat = 1
	icon_state = "owl"

/obj/item/clothing/mask/gas/owl_mask/attack_self(mob/user)
	return

/obj/item/clothing/mask/gas/tiki_mask
	name = "tiki mask"
	desc = "A tiki mask. Only a real Jerk would wear this."
	alloweat = 1
	icon_state = "tiki_eyebrow"
	item_state = "tiki_eyebrow"

obj/item/clothing/mask/gas/tiki_mask/attack_self(mob/user)

	var/mob/M = usr
	var/list/options = list()
	options["Original Tiki"] = "tiki_eyebrow"
	options["Happy Tiki"] = "tiki_happy"
	options["Confused Tiki"] = "tiki_confused"
	options["Angry Tiki"] ="tiki_angry"

	var/choice = input(M,"To what form do you wish to change this mask?","Morph Mask") in options

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		M << "The Tiki Mask has now changed into the [choice] Mask!"
	return 1