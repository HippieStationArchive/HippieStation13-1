/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/mob/living/carbon/owner = null
	var/status = ORGAN_ORGANIC
	var/state_flags = ORGAN_FINE

//Old Datum Limbs:
// code/modules/unused/limbs.dm


/obj/item/organ/limb
	name = "limb"
	desc = ""

	force = 5 //Now you can bash someone to death with an arm, you silly bastard.
	stamina_percentage = 0.6
	throwforce = 5

	hitsound = "swing_hit"
	throwhitsound = "swing_hit"

	var/body_part = null
	var/brutestate = 0
	var/burnstate = 0
	var/brute_dam = 0
	var/bloodloss = 0
	var/max_bloodloss = 2
	var/burn_dam = 0
	var/max_damage = 0
	var/list/embedded_objects = list()

	//Coloring and proper item icon update
	var/skin_tone = ""
	var/human_gender = ""
	var/species_id = ""
	var/should_draw_gender = FALSE
	var/should_draw_greyscale = FALSE
	var/species_color = ""
	var/updated = 0

	var/px_x = 0
	var/px_y = 0

/obj/item/organ/limb/throw_impact(atom/hit_atom)
	..()
	playsound(get_turf(src), pick('sound/misc/splat.ogg', 'sound/misc/splort.ogg'), 50, 1, -1)

/obj/item/organ/limb/examine(mob/user)
	..()
	if(brute_dam > 0)
		user << "<span class='warning'>This limb has [brute_dam > 30 ? "severe" : "minor"] bruising.</span>"
	if(burn_dam > 0)
		user << "<span class='warning'>This limb has [burn_dam > 30 ? "severe" : "minor"] bruising.</span>"

/obj/item/organ/limb/proc/update_limb(mob/living/carbon/human/H)
	if(!istype(H))
		var/mob/living/carbon/human/L = loc
		if(istype(L) && locate(src) in L.organs)
			H = L
	if(skin_tone == "")
		if(istype(H))
			skin_tone = H.skin_tone
		else
			skin_tone = "caucasian1"
	if(skin_tone)
		should_draw_greyscale = TRUE
	if(human_gender == "")
		if(istype(H))
			human_gender = H.gender
		else
			human_gender = MALE
	if(human_gender)
		should_draw_gender = TRUE
	if(istype(H) && H.dna && H.dna.species)
		var/datum/species/S = H.dna.species
		species_id = S.id
		if(MUTCOLORS in S.specflags)
			species_color = H.dna.features["mcolor"]
			should_draw_greyscale = TRUE
		should_draw_gender = S.sexes
	if(species_id == "")
		species_id = "human"
	updated = 1
	update_icon()

//Similar to human's update_icon proc
/obj/item/organ/limb/update_icon()
	overlays.Cut()
	var/image/I = get_limb_item_icon()
	if(I)
		I.pixel_x = px_x
		I.pixel_y = px_y
		overlays += I

//Gives you a proper icon appearance for the dismembered limb
/obj/item/organ/limb/proc/get_limb_item_icon()
	var/image/I

	var/icon_gender = (gender == FEMALE) ? "f" : "m" //gender of the icon, if applicable

	if((body_part == HEAD || body_part == CHEST))
		should_draw_gender = TRUE
	else
		should_draw_gender = FALSE

	if(status == ORGAN_ORGANIC)
		if(should_draw_greyscale)
			if(should_draw_gender)
				I = image("icon"='icons/mob/human_parts_greyscale.dmi', "icon_state"="[species_id]_[Bodypart2name(body_part)]_[icon_gender]_s", "layer"=-BODYPARTS_LAYER, "dir"=SOUTH)
			else
				I = image("icon"='icons/mob/human_parts_greyscale.dmi', "icon_state"="[species_id]_[Bodypart2name(body_part)]_s", "layer"=-BODYPARTS_LAYER, "dir"=SOUTH)
		else
			if(should_draw_gender)
				I = image("icon"='icons/mob/human_parts.dmi', "icon_state"="[species_id]_[Bodypart2name(body_part)]_[icon_gender]_s", "layer"=-BODYPARTS_LAYER, "dir"=SOUTH)
			else
				I = image("icon"='icons/mob/human_parts.dmi', "icon_state"="[species_id]_[Bodypart2name(body_part)]_s", "layer"=-BODYPARTS_LAYER, "dir"=SOUTH)
	else
		if(should_draw_gender)
			I = image("icon"='icons/mob/augments.dmi', "icon_state"="[Bodypart2name(body_part)]_[icon_gender]_s", "layer"=-BODYPARTS_LAYER, "dir"=SOUTH)
		else
			I = image("icon"='icons/mob/augments.dmi', "icon_state"="[Bodypart2name(body_part)]_s", "layer"=-BODYPARTS_LAYER, "dir"=SOUTH)
		if(I)
			return I
		return 0

	if(!should_draw_greyscale)
		if(I)
			return I //We're done here
		return 0

	//Greyscale Colouring
	var/draw_color
	if(skin_tone) //Limb has skin color variable defined, use it
		draw_color = skintone2hex(skin_tone)
	if(species_color)
		draw_color = species_color

	if(draw_color)
		I.color = "#[draw_color]"
	//End Greyscale Colouring

	if(I)
		return I
	return 0

//Checked in UnarmedAttack(). Return 1 to prevent normal click action (useful for SAW ARMS, etc.)
//Remember to check for proximity unless you're doing ranged actions for this!
/obj/item/organ/limb/proc/Touch(atom/A,proximity,params)
	return 0

/obj/item/organ/limb/chest
	name = "chest"
	icon_state = "chest"
	max_damage = 200
	body_part = CHEST
	px_x = 0
	px_y = 0

/obj/item/organ/limb/l_arm
	name = "left arm"
	icon_state = "l_arm"
	max_damage = 75
	body_part = ARM_LEFT
	px_x = -6
	px_y = 0

/obj/item/organ/limb/r_arm
	name = "right arm"
	icon_state = "r_arm"
	max_damage = 75
	body_part = ARM_RIGHT
	px_x = 6
	px_y = 0

/obj/item/organ/limb/l_leg
	name = "left leg"
	icon_state = "l_leg"
	max_damage = 75
	body_part = LEG_LEFT
	px_x = -2
	px_y = 12

/obj/item/organ/limb/r_leg
	name = "right leg"
	icon_state = "r_leg"
	max_damage = 75
	body_part = LEG_RIGHT
	px_x = 2
	px_y = 12

/*
	HEAD
	Plenty of additional icon appearance bullshit in here, watch out.
*/

/obj/item/organ/limb/head
	name = "head"
	icon_state = "head"
	max_damage = 200
	body_part = HEAD
	w_class = 4 //Quite a hefty load
	anchored = 1 //Forces people to carry it by hand, no pulling!
	slowdown = 1 //Balancing measure
	throw_range = 2 //No head bowling :(

	px_x = 0
	px_y = -8

	var/list/teeth_list = list() //Teeth are added in carbon/human/New()
	var/max_teeth = 32 //Changed based on teeth type the species spawns with
	var/max_dentals = 1
	var/list/dentals = list() //Dentals - pills inserted into teeth. I'd die trying to keep track of these for every single tooth.

	//Brain info
	var/mob/living/carbon/brain/brainmob = null //The current occupant.
	var/obj/item/organ/internal/brain/brain = null //The actual brain

	//Limb appearance info:
	var/real_name = "" //Replacement name
	//Hair colour and style
	var/hair_color = "000"
	var/hair_style = "Bald"
	var/hair_alpha = 255
	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hair_style = "Shaved"
	//Eye Colouring
	var/eyes = "eyes"
	var/eye_color = "000"
	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"
	//Old body
	var/body


/obj/item/organ/limb/head/attackby(obj/item/W, mob/user, params)
	if(!user || !W)
		return ..()

	add_fingerprint(user)

	var/list/implements = list(/obj/item/weapon/circular_saw, /obj/item/weapon/circular_saw/bonesaw, /obj/item/weapon/melee/energy/sword/cyborg/saw, /obj/item/weapon/melee/arm_blade,\
		/obj/item/weapon/twohanded/fireaxe, /obj/item/weapon/hatchet, /obj/item/weapon/kitchen/knife/butcher)
	if(W.type in implements)
		if(!istype(brain))
			user << "<span class='warning'>There is no brain in this head!</span>"
			return
		user.visible_message("<span class='warning'>[user] begins to saw through the bone in [src].</span>",\
			"<span class='notice'>You begin to saw through the bone in [src]...</span>")
		if(do_after(user, 54, target = user))
			user.visible_message("<span class='warning'>[user] saws [src] open and pulls out a brain!</span>", "<span class='notice'>You saw [src] open and pull out a brain.</span>")
			brainmob.container = null //Reset brainmob var.
			brainmob.loc = brain //Throw mob into brain.
			brain.brainmob = brainmob //Set the brain to use the brainmob
			brainmob = null //Set brainmob var to null

			brain.loc = get_turf(user)
			brain = null //No more brain in here

			update_icon()
		return
	..()

/obj/item/organ/limb/head/update_limb(mob/living/carbon/human/H)
	if(istype(H) && H.dna && H.dna.species)
		var/datum/species/S = H.dna.species
		//First of all, name.
		real_name = H.real_name

		//Facial hair
		if(H.facial_hair_style && (FACEHAIR in S.specflags))
			facial_hair_style = H.facial_hair_style
			if(S.hair_color)
				if(S.hair_color == "mutcolor")
					facial_hair_color = H.dna.features["mcolor"]
				else
					facial_hair_color = S.hair_color
			else
				facial_hair_color = H.facial_hair_color
			hair_alpha = S.hair_alpha
		//Hair
		if(H.hair_style && (HAIR in S.specflags))
			hair_style = H.hair_style
			if(S.hair_color)
				if(S.hair_color == "mutcolor")
					hair_color = H.dna.features["mcolor"]
				else
					hair_color = S.hair_color
			else
				hair_color = H.hair_color
			hair_alpha = S.hair_alpha
		// lipstick
		if(H.lip_style && (LIPS in S.specflags))
			lip_style = H.lip_style
			lip_color = H.lip_color
		// eyes
		if(EYECOLOR in S.specflags)
			eyes = S.eyes
			eye_color = H.eye_color
	..()

/obj/item/organ/limb/head/update_icon()
	overlays.Cut()
	var/list/standing = get_limb_item_icon()
	if(!standing)
		return
	for(var/image/I in standing)
		I.pixel_x = px_x
		I.pixel_y = px_y
	overlays = standing

/obj/item/organ/limb/head/get_limb_item_icon()
	var/image/I = ..()
	var/list/standing = list()
	standing += I

	var/datum/sprite_accessory/S

	//facial hair
	if(facial_hair_style)
		S = facial_hair_styles_list[facial_hair_style]
		if(S)
			var/image/img_facial_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
			img_facial_s.color = "#" + facial_hair_color
			img_facial_s.alpha = hair_alpha
			standing += img_facial_s

	//Applies the debrained overlay if there is no brain
	if(!brain)
		standing	+= image("icon"='icons/mob/human_face.dmi', "icon_state" = "debrained_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
	else
		if(hair_style)
			S = hair_styles_list[hair_style]
			if(S)
				var/image/img_hair_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
				img_hair_s.color = "#" + hair_color
				img_hair_s.alpha = hair_alpha
				standing += img_hair_s

	// lipstick
	if(lip_style)
		var/image/lips = image("icon"='icons/mob/human_face.dmi', "icon_state"="lips_[lip_style]_s", "layer" = -BODY_LAYER, "dir"=SOUTH)
		lips.color = lip_color
		standing += lips

	// eyes
	if(eye_color)
		var/image/img_eyes_s = image("icon" = 'icons/mob/human_face.dmi', "icon_state" = "[eyes]_s", "layer" = -BODY_LAYER, "dir"=SOUTH)
		img_eyes_s.color = "#" + eye_color
		standing += img_eyes_s

	if(standing.len)
		return standing
	return

/obj/item/organ/limb/head/proc/get_teeth() //returns collective amount of teeth
	var/amt = 0
	if(!teeth_list) teeth_list = list()
	for(var/obj/item/stack/teeth in teeth_list)
		amt += teeth.amount
	return amt

/obj/item/organ/limb/head/proc/knock_out_teeth(throw_dir, num=32) //Won't support knocking teeth out of a dismembered head or anything like that yet.
	num = Clamp(num, 1, 32)
	var/done = 0
	if(teeth_list && teeth_list.len) //We still have teeth
		var/stacks = rand(1,3)
		for(var/curr = 1 to stacks) //Random amount of teeth stacks
			var/obj/item/stack/teeth/teeth = pick(teeth_list)
			if(!teeth || teeth.zero_amount()) return //No teeth left, abort!
			var/drop = round(min(teeth.amount, num)/stacks) //Calculate the amount of teeth in the stack
			var/obj/item/stack/teeth/T = new teeth.type(owner.loc, drop)
			T.copy_evidences(teeth)
			teeth.use(drop)
			T.add_blood(owner)
			var/turf/target = get_turf(owner.loc)
			var/range = rand(2,T.throw_range)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf.density)
					break
			T.throw_at(target,T.throw_range,T.throw_speed)
			teeth.zero_amount() //Try to delete the teeth
			done = 1
	return done

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/organ/limb/proc/take_damage(brute, burn, bleed)
	if(owner && (owner.status_flags & GODMODE))	return 0
	brute	= max(brute,0)
	burn	= max(burn,0)
	bleed = max(bleed,0)
	if(status == ORGAN_ROBOTIC) //This makes robolimbs not damageable by chems and makes it stronger
		brute = max(0, brute - 5)
		burn = max(0, burn - 4)
		bleed = 0 //Robotic limbs don't bleed, stupid!

	bloodloss = min(bloodloss + bleed, max_bloodloss)
	var/can_inflict = max_damage - (brute_dam + burn_dam)
	if(!can_inflict)	return 0

	if((brute + burn) < can_inflict)
		brute_dam	+= brute
		burn_dam	+= burn
	else
		if(brute > 0)
			if(burn > 0)
				brute	= round( (brute/(brute+burn)) * can_inflict, 1 )
				burn	= can_inflict - brute	//gets whatever damage is left over
				brute_dam	+= brute
				burn_dam	+= burn
			else
				brute_dam	+= can_inflict
		else
			if(burn > 0)
				burn_dam	+= can_inflict
			else
				return 0
	return update_organ_icon()


//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/organ/limb/proc/heal_damage(brute, burn, bleed, robotic)

	if(robotic && status != ORGAN_ROBOTIC) // This makes organic limbs not heal when the proc is in Robotic mode.
		brute = max(0, brute - 3)
		burn = max(0, burn - 3)

	if(!robotic && status == ORGAN_ROBOTIC) // This makes robolimbs not healable by chems.
		brute = max(0, brute - 3)
		burn = max(0, burn - 3)

	brute_dam	= max(brute_dam - brute, 0)
	burn_dam	= max(burn_dam - burn, 0)
	bloodloss	= max(bloodloss - bleed, 0)
	return update_organ_icon()


//Returns total damage
/obj/item/organ/limb/proc/get_damage()
	return brute_dam + burn_dam


//Updates an organ's brute/burn states for use by update_damage_overlays()
//Returns 1 if we need to update overlays. 0 otherwise.
/obj/item/organ/limb/proc/update_organ_icon()
	if(status == ORGAN_ORGANIC) //Robotic limbs show no damage - RR
		var/update = 0
		if(state_flags & ORGAN_AUGMENTABLE) //Severed muscles make the limb look fucked up
			brutestate = 3
			update = 1
		var/tbrute	= round( (brute_dam/max_damage)*3, 1 )
		var/tburn	= round( (burn_dam/max_damage)*3, 1 )
		if((tbrute != brutestate) || (tburn != burnstate))
			brutestate = tbrute
			burnstate = tburn
			update = 1
		return update
	return 0

//Remove all embedded objects from all limbs on the human mob
/mob/living/carbon/human/proc/remove_all_embedded_objects()
	var/turf/T = get_turf(src)

	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			L.embedded_objects -= I
			I.loc = T

	clear_alert("embeddedobject")

/mob/living/carbon/human/proc/has_embedded_objects()
	. = 0
	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			return 1
