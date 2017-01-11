	//Baseline hardsuits


/obj/item/clothing/head/helmet/space/hardsuit
	name = "hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)
	var/basestate = "hardsuit"
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	var/obj/item/clothing/suit/space/hardsuit/suit
	item_color = "engineering" //Determines used sprites: hardsuit[on]-[color] and hardsuit[on]-[color]2 (lying down sprite)
	action_button_name = "Toggle Helmet Light"
	flags = BLOCKHAIR | STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH


/obj/item/clothing/head/helmet/space/hardsuit/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot turn the light on while in this [user.loc]!</span>" //To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "[basestate][on]-[item_color]"
	user.update_inv_head()	//so our mob-overlays update

	if(on)	user.AddLuminosity(brightness_on)
	else	user.AddLuminosity(-brightness_on)


/obj/item/clothing/head/helmet/space/hardsuit/pickup(mob/user)
	if(on)
		user.AddLuminosity(brightness_on)
		SetLuminosity(0)

/obj/item/clothing/head/helmet/space/hardsuit/dropped(mob/user)
	if(on)
		user.AddLuminosity(-brightness_on)
		SetLuminosity(brightness_on)

/obj/item/clothing/head/helmet/space/hardsuit/proc/display_visor_message(var/msg)
	var/mob/wearer = loc
	if(msg && ishuman(wearer))
		wearer.show_message("\icon[src]<b><span class='robot'>[msg]</span></b>", 1)

/obj/item/clothing/head/helmet/space/hardsuit/rad_act(severity)
	..()
	display_visor_message("Radiation pulse detected! Magnitide: <span class='green'>[severity]</span> RADs.")

/obj/item/clothing/head/helmet/space/hardsuit/emp_act(severity)
	..()
	display_visor_message("[severity > 1 ? "Light" : "Strong"] electromagnetic pulse detected!")



/obj/item/clothing/suit/space/hardsuit
	name = "hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-engineering"
	item_state = "eng_hardsuit"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals,/obj/item/device/t_scanner, /obj/item/weapon/rcd)
	siemens_coefficient = 0
	var/obj/item/clothing/head/helmet/space/hardsuit/helmet
	action_button_name = "Toggle Helmet"
	var/helmettype = /obj/item/clothing/head/helmet/space/hardsuit
	var/obj/item/weapon/tank/jetpack/suit/jetpack = null

/obj/item/clothing/suit/space/hardsuit/verb/Jetpack()
	set name = "Toggle Inbuilt Jetpack"
	set category = "Object"
	jetpack.toggle()

/obj/item/clothing/suit/space/hardsuit/verb/Jetpack_Rockets()
	set name = "Toggle Inbuilt Jetpack Stabilization"
	set category = "Object"
	jetpack.toggle_rockets()

	//Engineering
/obj/item/clothing/head/helmet/space/hardsuit/engine
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)
	item_color = "engineering"

/obj/item/clothing/suit/space/hardsuit/engine
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-engineering"
	item_state = "eng_hardsuit"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine


/obj/item/clothing/suit/space/hardsuit/engine/New()
	jetpack = new /obj/item/weapon/tank/jetpack/suit(src)
	..()

	//Atmospherics
/obj/item/clothing/head/helmet/space/hardsuit/engine/atmos
	name = "atmospherics hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has thermal shielding."
	icon_state = "hardsuit0-atmospherics"
	item_state = "atmo_helm"
	item_color = "atmospherics"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 0)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/atmos
	name = "atmospherics hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has thermal shielding."
	icon_state = "hardsuit-atmospherics"
	item_state = "atmo_hardsuit"
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 0)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/atmos


	//Chief Engineer's hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/engine/elite
	name = "advanced hardsuit helmet"
	desc = "An advanced helmet designed for work in a hazardous, low pressure environment. Shines with a high polish."
	icon_state = "hardsuit0-white"
	item_state = "ce_helm"
	item_color = "white"
	armor = list(melee = 40, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 90)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT


/obj/item/clothing/suit/space/hardsuit/engine/elite
	icon_state = "hardsuit-white"
	name = "advanced hardsuit"
	desc = "An advanced suit that protects against hazardous, low pressure environments. Shines with a high polish."
	item_state = "ce_hardsuit"
	armor = list(melee = 40, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 90)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/elite


	//Mining hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/mining
	name = "mining hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating for wildlife encounters and dual floodlights."
	icon_state = "hardsuit0-mining"
	item_state = "mining_helm"
	item_color = "mining"
	armor = list(melee = 40, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 50)
	brightness_on = 7


/obj/item/clothing/suit/space/hardsuit/mining
	icon_state = "hardsuit-mining"
	name = "mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating for wildlife encounters."
	item_state = "mining_hardsuit"
	armor = list(melee = 40, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 50)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals,/obj/item/weapon/storage/bag/ore,/obj/item/weapon/pickaxe)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/mining



	//Syndicate hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi
	name = "blood-red hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for work in special operations. It is in travel mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced helmet designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	item_state = "syndie_helm"
	item_color = "syndi"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
	on = 0
	var/obj/item/clothing/suit/space/hardsuit/syndi/linkedsuit = null
	action_button_name = "Toggle Helmet Mode"
	flags = BLOCKHAIR | STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/helmet/space/hardsuit/syndi/update_icon()
	icon_state = "hardsuit[on]-[item_color]"

/obj/item/clothing/head/helmet/space/hardsuit/syndi/New()
	..()
	if(istype(loc, /obj/item/clothing/suit/space/hardsuit/syndi))
		linkedsuit = loc

/obj/item/clothing/head/helmet/space/hardsuit/syndi/attack_self(mob/user) //Toggle Helmet
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot toggle your helmet while in this [user.loc]!</span>" //To prevent some lighting anomalities.
		return
	on = !on
	if(on || force)
		user << "<span class='notice'>You switch your hardsuit to travel mode.</span>"
		name = initial(name)
		desc = initial(desc)
		user.AddLuminosity(brightness_on)
		flags |= STOPSPRESSUREDMAGE
		flags_cover |= HEADCOVERSEYES | HEADCOVERSMOUTH
		flags_inv |= HIDEMASK|HIDEEYES|HIDEFACE
		cold_protection |= HEAD
	else
		user << "<span class='notice'>You switch your hardsuit to combat mode.</span>"
		name += " (combat)"
		desc = alt_desc
		user.AddLuminosity(-brightness_on)
		flags &= ~(STOPSPRESSUREDMAGE)
		flags_cover &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
		flags_inv &= ~(HIDEMASK|HIDEEYES|HIDEFACE)
		cold_protection &= ~HEAD
	update_icon()
	playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	toggle_hardsuit_mode(user)
	user.update_inv_head()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/toggle_hardsuit_mode(mob/user) //Helmet Toggles Suit Mode
	if(linkedsuit)
		if(on)
			linkedsuit.name = initial(linkedsuit.name)
			linkedsuit.desc = initial(linkedsuit.desc)
			linkedsuit.slowdown = 1
			linkedsuit.flags |= STOPSPRESSUREDMAGE
			linkedsuit.cold_protection |= CHEST | GROIN | LEGS | FEET | ARMS | HANDS
		else
			linkedsuit.name += " (combat)"
			linkedsuit.desc = linkedsuit.alt_desc
			linkedsuit.slowdown = 0
			linkedsuit.flags &= ~(STOPSPRESSUREDMAGE)
			linkedsuit.cold_protection &= ~(CHEST | GROIN | LEGS | FEET | ARMS | HANDS)

		linkedsuit.icon_state = "hardsuit[on]-[item_color]"
		linkedsuit.update_icon()
		user.update_inv_wear_suit()
		user.update_inv_w_uniform()


/obj/item/clothing/suit/space/hardsuit/syndi
	name = "blood-red hardsuit"
	desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in travel mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	item_state = "syndie_hardsuit"
	item_color = "syndi"
	w_class = 3
	action_button_name = "Toggle Helmet"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword/saber,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi

/obj/item/clothing/suit/space/hardsuit/syndi/New()
	jetpack = new /obj/item/weapon/tank/jetpack/suit(src)
	..()

//Elite Syndie suit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	name = "elite syndicate hardsuit helmet"
	desc = "An elite version of the syndicate helmet, with improved armour and fire shielding. It is in travel mode. Property of Gorlex Marauders."
	alt_desc = "An elite version of the syndicate helmet, with improved armour and fire shielding. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-elite"
	item_state = "syndie_hardsuit"
	item_color = "elite"
	armor = list(melee = 75, bullet = 60, laser = 50, energy = 25, bomb = 55, bio = 100, rad = 70)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT


/obj/item/clothing/suit/space/hardsuit/syndi/elite
	name = "elite syndicate hardsuit"
	desc = "An elite version of the syndicate hardsuit, with improved armour and fire shielding. It is in travel mode."
	alt_desc = "An elite version of the syndicate hardsuit, with improved armour and fire shielding. It is in combat mode."
	icon_state = "hardsuit1-elite"
	item_state = "syndie_hardsuit"
	item_color = "elite"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	armor = list(melee = 75, bullet = 60, laser = 50, energy = 25, bomb = 55, bio = 100, rad = 70)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT

//Blast Co Syndie suit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/blastco
	name = "blastco syndicate hardsuit helmet"
	desc = "A specialized helmet built for sustaining concussive blasts and shrapnel. It is in travel mode. Property of Blast-Co."
	alt_desc = "A specialized helmet built for sustaining concussive blasts and shrapnel. It is in combat mode. Property of Blast-Co."
	icon_state = "hardsuit1-blastco"
	item_state = "syndie_hardsuit"
	item_color = "blastco"
	armor = list(melee = 70, bullet = 30, laser = 50, energy = 25, bomb = 100, bio = 100, rad = 70)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT


/obj/item/clothing/suit/space/hardsuit/syndi/blastco
	name = "blastco syndicate hardsuit"
	desc = "A specialized hardsuit built for sustaining concussive blasts and shrapnel. It is in travel mode."
	alt_desc = "A specialized hardsuit built for sustaining concussive blasts and shrapnel. It is in combat mode."
	icon_state = "hardsuit1-blastco"
	item_state = "blastco_hardsuit"
	item_color = "blastco"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/blastco
	armor = list(melee = 70, bullet = 30, laser = 50, energy = 25, bomb = 100, bio = 100, rad = 70)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT

//The Owl Hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/owl
	name = "owl hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for any crime-fighting situation. It is in travel mode."
	alt_desc = "A dual-mode advanced helmet designed for any crime-fighting situation. It is in combat mode."
	icon_state = "hardsuit1-owl"
	item_state = "s_helmet"
	item_color = "owl"
	armor = list(melee = 30, bullet = 15, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 50) //Why in gods name was a thing that non antags could get inside of 30 seconds of roundstart AS GOOD as something normal traitors had to spend TC on?


/obj/item/clothing/suit/space/hardsuit/syndi/owl
	name = "owl hardsuit"
	desc = "A dual-mode advanced hardsuit designed for any crime-fighting situation. It is in travel mode."
	alt_desc = "A dual-mode advanced hardsuit designed for any crime-fighting situation. It is in combat mode."
	icon_state = "hardsuit1-owl"
	item_state = "s_suit"
	item_color = "owl"
	flags_inv = HIDEGLOVES
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/owl
	armor = list(melee = 30, bullet = 15, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 50)

/obj/item/clothing/suit/space/hardsuit/syndi/owl/cursed
	flags = NODROP

/obj/item/clothing/head/helmet/space/hardsuit/syndi/owl/attack_self(mob/user) //Toggle Helmet
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot toggle your helmet while in this [user.loc]!</span>" //To prevent some lighting anomalities.
		return
	on = !on
	if(on || force)
		user << "<span class='notice'>You switch your hardsuit to travel mode.</span>"
		name = initial(name)
		desc = initial(desc)
		user.AddLuminosity(brightness_on)
		flags |= STOPSPRESSUREDMAGE | THICKMATERIAL
		flags_cover |= HEADCOVERSEYES | HEADCOVERSMOUTH
		flags_inv |= HIDEMASK|HIDEEYES|HIDEFACE
		cold_protection |= HEAD
	else
		user << "<span class='notice'>You switch your hardsuit to combat mode.</span>"
		name += " (combat)"
		desc = alt_desc
		user.AddLuminosity(-brightness_on)
		flags &= ~(STOPSPRESSUREDMAGE | THICKMATERIAL)
		flags_cover &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
		flags_inv &= ~(HIDEMASK|HIDEEYES|HIDEFACE)
		cold_protection &= ~HEAD
	update_icon()
	playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	toggle_owlhardsuit_mode(user)
	user.update_inv_head()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/toggle_owlhardsuit_mode(mob/user) //Helmet Toggles Suit Mode
	if(linkedsuit)
		if(on)
			linkedsuit.name = initial(linkedsuit.name)
			linkedsuit.desc = initial(linkedsuit.desc)
			linkedsuit.slowdown = 1
			linkedsuit.flags |= STOPSPRESSUREDMAGE | THICKMATERIAL
			linkedsuit.cold_protection |= CHEST | GROIN | LEGS | FEET | ARMS | HANDS
		else
			linkedsuit.name += " (combat)"
			linkedsuit.desc = linkedsuit.alt_desc
			linkedsuit.slowdown = 0
			linkedsuit.flags &= ~(STOPSPRESSUREDMAGE | THICKMATERIAL)
			linkedsuit.cold_protection &= ~(CHEST | GROIN | LEGS | FEET | ARMS | HANDS)

		linkedsuit.icon_state = "hardsuit[on]-[item_color]"
		linkedsuit.update_icon()
		user.update_inv_wear_suit()
		user.update_inv_w_uniform()

	//Wizard hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/wizard
	name = "gem-encrusted hardsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "hardsuit0-wiz"
	item_state = "wiz_helm"
	item_color = "wiz"
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 20, bomb = 35, bio = 100, rad = 50)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1


/obj/item/clothing/suit/space/hardsuit/wizard
	icon_state = "hardsuit-wiz"
	name = "gem-encrusted hardsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state = "wiz_hardsuit"
	w_class = 3
	unacidable = 1
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 20, bomb = 35, bio = 100, rad = 50)
	allowed = list(/obj/item/weapon/teleportation_scroll,/obj/item/weapon/tank/internals)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	unacidable = 1
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/wizard


	//Medical hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/medical
	name = "medical hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort, but does not protect the eyes from intense light."
	icon_state = "hardsuit0-medical"
	item_state = "medical_helm"
	item_color = "medical"
	flash_protect = 0
	var/onboard_hud_enabled = 0 //stops conflicts with another diag HUD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 50)
	scan_reagents = 1 //Generally worn by the CMO, so they'd get utility off of seeing reagents

/obj/item/clothing/head/helmet/space/hardsuit/medical/equipped(mob/living/carbon/human/user, slot)
	..(user, slot)
	if(user.glasses && istype(user.glasses, /obj/item/clothing/glasses/hud/health))
		user << ("<span class='warning'>Your [user.glasses] prevents you using [src]'s medical visor HUD.</span>")
	else
		onboard_hud_enabled = 1
		var/datum/atom_hud/DHUD = huds[DATA_HUD_MEDICAL_ADVANCED]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/medical/dropped(mob/living/carbon/human/user)
	..(user)
	if(onboard_hud_enabled && !(user.glasses && istype(user.glasses, /obj/item/clothing/glasses/hud/health)))
		var/datum/atom_hud/DHUD = huds[DATA_HUD_MEDICAL_ADVANCED]
		DHUD.remove_hud_from(user)

/obj/item/clothing/suit/space/hardsuit/medical
	icon_state = "hardsuit-medical"
	name = "medical hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Built with lightweight materials for easier movement."
	item_state = "medical_hardsuit"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical

	//Research Director hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/rd
	name = "prototype hardsuit helmet"
	desc = "A prototype helmet designed for research in a hazardous, low pressure environment. Scientific data flashes across the visor."
	icon_state = "hardsuit0-rd"
	item_color = "rd"
	unacidable = 1
	var/onboard_hud_enabled = 0 //stops conflicts with another diag HUD
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list(melee = 15, bullet = 5, laser = 10, energy = 5, bomb = 100, bio = 100, rad = 70)
	scan_reagents = 1
	var/obj/machinery/doppler_array/integrated/bomb_radar

/obj/item/clothing/head/helmet/space/hardsuit/rd/New()
	..()
	bomb_radar = new /obj/machinery/doppler_array/integrated(src)

/obj/item/clothing/head/helmet/space/hardsuit/rd/equipped(mob/living/carbon/human/user, slot)
	..(user, slot)
	user.scanner.Grant(user)
	user.scanner.devices += 1
	if(user.glasses && istype(user.glasses, /obj/item/clothing/glasses/hud/diagnostic))
		user << ("<span class='warning'>Your [user.glasses] prevents you using [src]'s diagnostic visor HUD.</span>")
	else
		onboard_hud_enabled = 1
		var/datum/atom_hud/DHUD = huds[DATA_HUD_DIAGNOSTIC]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/rd/dropped(mob/living/carbon/human/user)
	..(user)
	user.scanner.devices = max(0, user.scanner.devices - 1)
	if(onboard_hud_enabled && !(user.glasses && istype(user.glasses, /obj/item/clothing/glasses/hud/diagnostic)))
		var/datum/atom_hud/DHUD = huds[DATA_HUD_DIAGNOSTIC]
		DHUD.remove_hud_from(user)

/obj/item/clothing/suit/space/hardsuit/rd
	icon_state = "hardsuit-rd"
	name = "prototype hardsuit"
	desc = "A prototype suit that protects against hazardous, low pressure environments. Fitted with extensive plating for handling explosives and dangerous research materials."
	item_state = "hardsuit-rd"
	unacidable = 1
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT //Same as an emergency firesuit. Not ideal for extended exposure.
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/gun/energy/wormhole_projector,
	/obj/item/weapon/hand_tele, /obj/item/device/aicard)
	armor = list(melee = 20, bullet = 5, laser = 10, energy = 5, bomb = 100, bio = 100, rad = 70)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rd


	//Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security
	name = "security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-sec"
	item_state = "sec_helm"
	item_color = "sec"
	armor = list(melee = 30, bullet = 15, laser = 30,energy = 10, bomb = 10, bio = 100, rad = 50)


/obj/item/clothing/suit/space/hardsuit/security
	icon_state = "hardsuit-sec"
	name = "security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "sec_hardsuit"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs)
	armor = list(melee = 30, bullet = 15, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security

/obj/item/clothing/head/helmet/space/hardsuit/security/hos
	name = "head of security's hardsuit helmet"
	desc = "a special bulky helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-hos"
	item_color = "hos"
	armor = list(melee = 45, bullet = 25, laser = 30,energy = 10, bomb = 25, bio = 100, rad = 50)


/obj/item/clothing/suit/space/hardsuit/security/hos
	icon_state = "hardsuit-hos"
	name = "head of security's hardsuit"
	desc = "A special bulky suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	armor = list(melee = 45, bullet = 25, laser = 30, energy = 10, bomb = 25, bio = 100, rad = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security/hos

// powerarmour is for pussies

/obj/item/clothing/head/helmet/space/hardsuit/powerarmour
	name = "t-45d power armour helmet"
	desc = "A precursor powered helmet designed for combat. Has radiation shielding, Incredibly weak to electronic pulses."
	icon_state = "hardsuit0-powerarmour"
	item_state = "hardsuit0-powerarmour"
	item_color = "powerarmour"
	armor = list(melee = 65, bullet = 30, laser = 30, energy = 0, bomb = 50, bio = 100, rad = 90)


/obj/item/clothing/suit/space/hardsuit/powerarmour
	icon_state = "powerarmour"
	name = "t-45d power armour suit"
	desc = "A precursor powered suit designed for combat. Has radiation shielding, Incredibly weak to electronic pulses."
	item_state = "powerarmour"
	armor = list(melee = 65, bullet = 35, laser = 30, energy = 0, bomb = 50, bio = 100, rad = 90)
	origin_tech = "materials=5;engineering=5;combat=4"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/powerarmour
	slowdown = 1

/obj/item/clothing/suit/space/hardsuit/powerarmour/emp_act(severity, mob/living/user)
    user = src.loc
    if(istype(user,/mob/living/carbon/human))
        if(slowdown <= 3)
            slowdown += 1
        user.electrocute_act(10 * severity,src)
        user.visible_message("<span class='warning'>[user.name]'s suit shakes violently, sending out electrical sparks!</span>", \
                       "<span class='danger'>Electronic interference detected in [src], servo damage has occured!.</span>", \
                    "<span class='italics'>You hear loud electrical crackles.</span>")
    else
        return 0
