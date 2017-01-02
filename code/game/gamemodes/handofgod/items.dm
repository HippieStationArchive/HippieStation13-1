/obj/item/weapon/banner
	name = "banner"
	icon = 'icons/obj/items.dmi'
	icon_state = "banner"
	item_state = "banner"
	desc = "A banner with a weird logo on it."
	materials = list(MAT_METAL = 8000)
	var/side = ""
	var/moralecooldown = 0
	var/moralewait = 600

/obj/item/weapon/banner/New(location, team = "")
	..()
	color = team
	side = team

/obj/item/weapon/banner/attack_self(mob/living/carbon/human/user)
	if(moralecooldown + moralewait > world.time)
		return
	if(user.mind)
		side = is_in_any_team(user.mind)

	if(!side)
		return
	user << "<span class='notice'>You increase the morale of your fellows!</span>"
	moralecooldown = world.time

	for(var/mob/living/carbon/human/H in range(4,get_turf(src)))
		if(is_in_any_team(H.mind) == side)
			H << "<span class='notice'>Your morale is increased by [user]'s banner!</span>"
			H.adjustBruteLoss(-15)
			H.adjustFireLoss(-15)
			H.AdjustStunned(-2)
			H.AdjustWeakened(-2)
			H.AdjustParalysis(-2)

/obj/item/weapon/banner/examine(mob/user)
	..()
	if(!side)
		return // it's a normal banner in this case
	if(!is_in_any_team(user.mind))
		return // a non antag is examining this
	if(is_in_any_team(user.mind) == side)
		user << "A banner representing our might against the heretics. We may use it to increase the morale of our fellow members!"
	else
		user << "A heretical banner that should be destroyed posthaste."


/obj/item/weapon/storage/backpack/bannerpack
	name = "banner backpack"
	desc = "It's a backpack with lots of extra room.  A banner with a weird logo is attached, that can't be removed."
	max_combined_w_class = 27 //6 more then normal, for the tradeoff of declaring yourself an antag at all times.
	icon_state = "bannerpack"
	materials = list(MAT_METAL = 20000)

/obj/item/weapon/storage/backpack/bannerpack/New(location, team = "")
	..()
	color = team
//weapons

/obj/item/weapon/claymore/hog
	force = 17 //both nerfed because this gamemode isn't about fucking killing everything on sight jesus christ
	materials = list(MAT_METAL = 20000)

/obj/item/weapon/twohanded/scythe
	name = "forged scythe"
	desc = "An occult weapon used by those who claim to serve a deity."
	icon_state = "hogscythe0"
	force = 7
	throwforce = 15
	w_class = 4
	slot_flags = SLOT_BACK
	force_unwielded = 7
	force_wielded = 24
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	materials = list(MAT_METAL = 30000)

/obj/item/weapon/twohanded/scythe/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "hogscythe[wielded]"
	return

/obj/item/weapon/twohanded/scythe/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is beheading \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return (BRUTELOSS)

/obj/item/weapon/melee/combatknife/hog
	name = "forged knife"
	desc = "An occult weapon that can easily stick in the flesh of men."
	icon_state = "hogdagger"
	force = 10
	materials = list(MAT_METAL = 12000)

//this is all part of one item set
/obj/item/clothing/suit/armor/plate/advocate
	name = "Advocate's Armour"
	desc = "Armour that was used to protect from backstabs, gunshots, explosives, and lasers.  The original wearers of this type of armour were trying to avoid being murdered.  Since they're not around anymore, you're not sure if they were successful or not."
	icon_state = "hogrobe-frame"
	w_class = 4 //bulky
	slowdown = 2.0 //gotta pretend we're balanced.
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 40, bomb = 60, bio = 0, rad = 0)
	materials = list(MAT_METAL = 40000, MAT_GLASS = 20000) // expensive since it's fuckingly op

/obj/item/clothing/suit/armor/plate/advocate/New(location, side)
	..()
	var/image/overlay = image(icon, "hogrobe-overlay")
	overlay.color = side
	overlays += overlay

/obj/item/clothing/suit/armor/plate/advocate/examine(mob/user)
	..()
	if(!is_in_any_team(user.mind)) //normal guy examining
		user << "Armour that's comprised of metal and cloth."
	else //HoG player
		user << "Armour that was used to protect from backstabs, gunshots, explosives, and lasers.  The original wearers of this type of armour were trying to avoid being murdered.  Since they're not around anymore, you're not sure if they were successful or not."


/obj/item/clothing/head/helmet/plate/advocate
	name = "Advocate's Hood"
	icon_state = "hoghat"
	w_class = 3 //normal
	flags = BLOCKHAIR
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 40, bomb = 60, bio = 0, rad = 0)
	materials = list(MAT_METAL = 30000, MAT_GLASS = 8000)

/obj/item/clothing/head/helmet/plate/advocate/New(location, side)
	..()
	color = side //hat has no overlay,it's one piece,just needs a color

/obj/item/clothing/head/helmet/plate/advocate/examine(mob/user)
	..()
	if(!is_in_any_team(user.mind))
		user << "A brownish hood."
	else
		user << "A hood that's very protective, despite being made of cloth.  Due to the tendency of the wearer to be targeted for assassinations, being protected from being shot in the face was very important.."



//Prophet helmet
/obj/item/clothing/head/helmet/plate/advocate/prophet
	name = "Prophet's Hat"
	icon_state = "hogprophet-frame"
	flags = 0
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 50, bomb = 70, bio = 50, rad = 50) //religion protects you from disease and radiation, honk.

/obj/item/clothing/head/helmet/plate/advocate/prophet/New(location, side)
	..()
	var/image/overlay = image(icon, "hogprophet-overlay")
	overlay.color = side
	overlays += overlay

/obj/item/clothing/head/helmet/plate/advocate/prophet/examine(mob/user)
	..()
	if(!is_in_any_team(user.mind))
		user << "A brownish, religious-looking hat."
	else
		user << "A hat bestowed upon a prophet of gods and demigods."



//Structure conversion staff
/obj/item/weapon/godstaff
	name = "godstaff"
	icon_state = "godstaff"
	var/mob/camera/god/god = null

/obj/item/weapon/godstaff/New(location, side)
	..()
	color = side

/obj/item/weapon/godstaff/examine(mob/user)
	..()
	if(!is_in_any_team(user.mind))
		user << "It's a stick..?"
	else
		user << "A powerful staff capable of changing the allegiance of god/demigod structures."


/obj/item/clothing/gloves/plate
	name = "Plate Gauntlets"
	icon_state = "hogglove-frame"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	materials = list(MAT_METAL = 20000, MAT_GLASS = 10000)

/obj/item/clothing/gloves/plate/New(location, side)
	..()
	var/image/overlay = image(icon, "hogglove-overlay")
	overlay.color = side
	overlays += overlay

/obj/item/clothing/gloves/plate/examine(mob/user)
	..()
	if(!is_in_any_team(user.mind))
		user << "They're like gloves, but made of metal."
	else
		user << "Protective gloves that are also blessed to protect from heat and shock."


/obj/item/clothing/shoes/plate
	name = "Plate Boots"
	icon_state = "hogshoes-frame"
	w_class = 3 //normal
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 40, bomb = 60, bio = 0, rad = 0) //does this even do anything on boots?
	flags = NOSLIP
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	materials = list(MAT_METAL = 20000, MAT_GLASS = 10000)

/obj/item/clothing/shoes/plate/New(location, side)
	..()
	var/image/overlay = image(icon, "hogshoes-overlay")
	overlay.color = side
	overlays += overlay

/obj/item/clothing/shoes/plate/examine(mob/user)
	..()
	if(!is_in_any_team(user.mind))
		user << "Metal boots, they look heavy."
	else
		user << "Heavy boots that are blessed for sure footing.  You'll be safe from being taken down by the heresy that is the banana peel."

