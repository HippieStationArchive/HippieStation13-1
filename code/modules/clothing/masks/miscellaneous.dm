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
