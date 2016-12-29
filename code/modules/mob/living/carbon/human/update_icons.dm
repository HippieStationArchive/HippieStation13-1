	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/* Keep these comments up-to-date if you -insist- on hurting my code-baby ;_;
This system allows you to update individual mob-overlays, without regenerating them all each time.
When we generate overlays we generate the standing version and then rotate the mob as necessary..

As of the time of writing there are 20 layers within this list. Please try to keep this from increasing. //22 and counting, good job guys
	var/overlays_standing[20]		//For the standing stance

Most of the time we only wish to update one overlay:
	e.g. - we dropped the fireaxe out of our left hand and need to remove its icon from our mob
	e.g.2 - our hair colour has changed, so we need to update our hair icons on our mob
In these cases, instead of updating every overlay using the old behaviour (regenerate_icons), we instead call
the appropriate update_X proc.
	e.g. - update_l_hand()
	e.g.2 - update_hair()

Note: Recent changes by aranclanos+carn:
	update_icons() no longer needs to be called.
	the system is easier to use. update_icons() should not be called unless you absolutely -know- you need it.
	IN ALL OTHER CASES it's better to just call the specific update_X procs.

Note: The defines for layer numbers is now kept exclusvely in __DEFINES/misc.dm instead of being defined there,
	then redefined and undefiend everywhere else. If you need to change the layering of sprites (or add a new layer)
	that's where you should start.

All of this means that this code is more maintainable, faster and still fairly easy to use.

There are several things that need to be remembered:
>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src), rather than using the helper procs)
	You will need to call the relevant update_inv_* proc

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_damage_overlays()	//handles damage overlays for brute/burn damage
		update_base_icon_state()	//Handles updating var/base_icon_state (WIP) This is used to update the
									mob's icon_state easily e.g. "[base_icon_state]_s" is the standing icon_state
		update_body()				//Handles updating your mob's icon_state (using update_base_icon_state())
									as well as sprite-accessories that didn't really fit elsewhere (underwear, undershirts, socks, lips, eyes)
									//NOTE: update_mutantrace() is now merged into this!
		update_hair()				//Handles updating your hair overlay (used to be update_face, but mouth and
									eyes were merged into update_body())

If you have any questions/constructive-comments/bugs-to-report
Please contact me on #coderbus IRC. ~Carnie x
//Carn can sometimes be hard to reach now. However IRC is still your best bet for getting help.
*/

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/image/standing	= image("icon"='icons/mob/dam_human.dmi', "icon_state"="blank", "layer"=-DAMAGE_LAYER)
	overlays_standing[DAMAGE_LAYER]	= standing

	for(var/obj/item/organ/limb/O in organs)
		if(O.brutestate)
			standing.overlays	+= "[O.icon_state]_[O.brutestate]0"	//we're adding icon_states of the base image as overlays
		if(O.burnstate)
			standing.overlays	+= "[O.icon_state]_0[O.burnstate]"

	apply_overlay(DAMAGE_LAYER)


//HAIR OVERLAY
/mob/living/carbon/human/update_hair()
	//Reset our hair
	remove_overlay(HAIR_LAYER)

	if( (disabilities & HUSK) || (head && (head.flags & BLOCKHAIR)) || (wear_mask && (wear_mask.flags & BLOCKHAIR)) )
		return

	if((wear_suit) && (wear_suit.hooded) && (wear_suit.suittoggled == 1))
		return

	if(!get_organ("head")) //Decapitated
		return

	return dna.species.handle_hair(src)

//used when putting/removing clothes that hide certain mutant body parts to just update those and not update the whole body.
/mob/living/carbon/human/proc/update_mutant_bodyparts()
	dna.species.handle_mutant_bodyparts(src)


/mob/living/carbon/human/proc/update_body()
	remove_overlay(BODY_LAYER)
	dna.species.handle_body(src)
	update_body_parts()

/mob/living/carbon/human/update_fire()
	..("Standing")

/mob/living/carbon/human/proc/update_body_parts()
	if(!dna.species:has_dismemberment) //Species don't have no dismemberment going for 'em!
		remove_overlay(BODYPARTS_LAYER)
		return

	icon_state = ""//Reset here as apposed to having a null one due to some getFlatIcon calls at roundstart.

	//CHECK FOR UPDATE
	var/oldkey = icon_render_key
	icon_render_key = generate_icon_render_key()
	if(oldkey == icon_render_key)
		return

	remove_overlay(BODYPARTS_LAYER)

	//LOAD ICONS
	if(limb_icon_cache[icon_render_key])
		load_limb_from_cache()
		update_damage_overlays()
		update_hair()
		return

	//GENERATE NEW LIMBS
	var/list/new_limbs = list()
	for(var/obj/item/organ/limb/L in organs)
		var/image/temp = generate_limb_icon(L)
		if(temp)
			new_limbs += temp
	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs
		limb_icon_cache[icon_render_key] = new_limbs

	apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()

/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()

	if(!..())
		update_body()
		update_body_parts()
		update_hair()
		update_inv_w_uniform()
		update_inv_wear_id()
		update_inv_gloves()
		update_inv_glasses()
		update_inv_ears()
		update_inv_shoes()
		update_inv_s_store()
		update_inv_wear_mask()
		update_inv_head()
		update_inv_belt()
		update_inv_back()
		update_inv_wear_suit()
		update_inv_pockets()
		update_transform()
		//Hud Stuff
		update_hud()
		//mutations
		update_mutations_overlay()
		//damage overlays
		update_damage_overlays()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform()
	remove_overlay(UNIFORM_LAYER)

	if(istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				w_uniform.screen_loc = ui_iclothing //...draw the item in the inventory screen
			client.screen += w_uniform				//Either way, add the item to the HUD

		if(wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT))
			return

		var/t_color = w_uniform.item_color
		if(!t_color)		t_color = w_uniform.icon_state

		var/image/standing

		if(dna && dna.species.sexes)
			var/G = (gender == FEMALE) ? "f" : "m"
			if(G == "f" && U.fitted != NO_FEMALE_UNIFORM)
				standing = U.build_worn_icon(state = "[t_color]_s", default_layer = UNIFORM_LAYER, default_icon_file = 'icons/mob/uniform.dmi', isinhands = FALSE, femaleuniform = U.fitted)

		if(!standing)
			standing = U.build_worn_icon(state = "[t_color]_s", default_layer = UNIFORM_LAYER, default_icon_file = 'icons/mob/uniform.dmi', isinhands = FALSE)

		standing.color = w_uniform.color
		standing.alpha = w_uniform.alpha
		overlays_standing[UNIFORM_LAYER]	= standing

	else
		// Automatically drop anything in store / id / belt if you're not wearing a uniform.	//CHECK IF NECESARRY
		for(var/obj/item/thing in list(r_store, l_store, wear_id, belt))						//
			unEquip(thing)

	apply_overlay(UNIFORM_LAYER)


/mob/living/carbon/human/update_inv_wear_id()
	remove_overlay(ID_LAYER)
	if(wear_id)
		wear_id.screen_loc = ui_id	//TODO
		if(client && hud_used)
			client.screen += wear_id

		//TODO: add an icon file for ID slot stuff, so it's less snowflakey
		var/image/standing = wear_id.build_worn_icon(state = wear_id.item_state, default_layer = ID_LAYER, default_icon_file = 'icons/mob/mob.dmi')
		standing.color = wear_id.color
		standing.alpha = wear_id.alpha
		overlays_standing[ID_LAYER]	= standing
	sec_hud_set_ID()
	apply_overlay(ID_LAYER)


/mob/living/carbon/human/update_inv_gloves()
	remove_overlay(GLOVES_LAYER)

	if(get_num_arms() <2)
		return

	if(gloves)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				gloves.screen_loc = ui_gloves		//...draw the item in the inventory screen
			client.screen += gloves					//Either way, add the item to the HUD

		var/t_state = gloves.item_state
		if(!t_state)	t_state = gloves.icon_state

		var/image/standing = gloves.build_worn_icon(state = t_state, default_layer = GLOVES_LAYER, default_icon_file = 'icons/mob/hands.dmi')

		standing.color = gloves.color
		standing.alpha = gloves.alpha
		overlays_standing[GLOVES_LAYER]	= standing

	else
		if(blood_DNA)
			overlays_standing[GLOVES_LAYER]	= image("icon"='icons/effects/blood.dmi', "icon_state"="bloodyhands", "layer"=-GLOVES_LAYER)

	apply_overlay(GLOVES_LAYER)



/mob/living/carbon/human/update_inv_glasses()
	remove_overlay(GLASSES_LAYER)

	if(!get_organ("head")) //Decpaitated
		return

	if(glasses)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				glasses.screen_loc = ui_glasses		//...draw the item in the inventory screen
			client.screen += glasses				//Either way, add the item to the HUD

		if(!(head && (head.flags_inv & HIDEEYES)))
			var/image/standing = glasses.build_worn_icon(state = glasses.icon_state, default_layer = GLASSES_LAYER, default_icon_file = 'icons/mob/eyes.dmi')
			standing.color = glasses.color
			standing.alpha = glasses.alpha
			overlays_standing[GLASSES_LAYER] = standing

	apply_overlay(GLASSES_LAYER)


/mob/living/carbon/human/update_inv_ears()
	remove_overlay(EARS_LAYER)

	if(!get_organ("head")) //Decpaitated
		return

	if(ears)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				ears.screen_loc = ui_ears			//...draw the item in the inventory screen
			client.screen += ears					//Either way, add the item to the HUD

		var/image/standing = ears.build_worn_icon(state = ears.icon_state, default_layer = EARS_LAYER, default_icon_file = 'icons/mob/ears.dmi')

		standing.color = ears.color
		standing.alpha = ears.alpha
		overlays_standing[EARS_LAYER] = standing

	apply_overlay(EARS_LAYER)


/mob/living/carbon/human/update_inv_shoes()
	remove_overlay(SHOES_LAYER)

	if(get_num_legs() < 2)
		return

	if(shoes)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open ...
				shoes.screen_loc = ui_shoes			//...draw the item in the inventory screen
			client.screen += shoes					//Either way, add the item to the HUD

		var/image/standing = shoes.build_worn_icon(state = shoes.icon_state, default_layer = SHOES_LAYER, default_icon_file = 'icons/mob/feet.dmi')
		standing.color = shoes.color
		standing.alpha = shoes.alpha
		overlays_standing[SHOES_LAYER]	= standing

	apply_overlay(SHOES_LAYER)


/mob/living/carbon/human/update_inv_s_store()
	remove_overlay(SUIT_STORE_LAYER)

	if(s_store)
		s_store.screen_loc = ui_sstore1		//TODO
		if(client && hud_used)
			client.screen += s_store

		var/t_state = s_store.item_state
		if(!t_state)	t_state = s_store.icon_state
		var/image/standing = image("icon"='icons/mob/belt_mirror.dmi', "icon_state"="[t_state]", "layer"=-SUIT_STORE_LAYER)
		standing.color = s_store.color
		standing.alpha = s_store.alpha
		overlays_standing[SUIT_STORE_LAYER]	= standing

	apply_overlay(SUIT_STORE_LAYER)



/mob/living/carbon/human/update_inv_head()
	remove_overlay(HEAD_LAYER)
	if(!get_organ("head")) //Decpaitated
		return

	var/obj/item/H = ..()
	if(H)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)				//if the inventory is open ...
				H.screen_loc = ui_head		//TODO	//...draw the item in the inventory screen
			client.screen += H						//Either way, add the item to the HUD

	update_mutant_bodyparts()
	sec_hud_set_ID()
	apply_overlay(HEAD_LAYER)


/mob/living/carbon/human/update_inv_belt()
	remove_overlay(BELT_LAYER)

	if(belt)
		belt.screen_loc = ui_belt
		if(client && hud_used)
			client.screen += belt

		var/t_state = belt.item_state
		if(!t_state)	t_state = belt.icon_state

		var/image/standing = belt.build_worn_icon(state = t_state, default_layer = BELT_LAYER, default_icon_file = 'icons/mob/belt.dmi')
		standing.color = belt.color
		standing.alpha = belt.alpha
		overlays_standing[BELT_LAYER] = standing

	apply_overlay(BELT_LAYER)



/mob/living/carbon/human/update_inv_wear_suit()
	remove_overlay(SUIT_LAYER)

	if(istype(wear_suit, /obj/item/clothing/suit) || istype(wear_suit, /obj/item/weapon/storage/backpack/cloak) )
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)					//if the inventory is open ...
				wear_suit.screen_loc = ui_oclothing	//TODO	//...draw the item in the inventory screen
			client.screen += wear_suit						//Either way, add the item to the HUD


		var/image/standing = wear_suit.build_worn_icon(state = wear_suit.icon_state, default_layer = SUIT_LAYER, default_icon_file = 'icons/mob/suit.dmi')
		standing.color = wear_suit.color
		standing.alpha = wear_suit.alpha
		overlays_standing[SUIT_LAYER]	= standing

		if(istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
			unEquip(handcuffed)
			drop_l_hand()
			drop_r_hand()

	src.update_hair()
	src.update_mutant_bodyparts()

	apply_overlay(SUIT_LAYER)


/mob/living/carbon/human/update_inv_pockets()
	if(l_store)
		l_store.screen_loc = ui_storage1	//TODO
		if(client && hud_used)
			client.screen += l_store
	if(r_store)
		r_store.screen_loc = ui_storage2	//TODO
		if(client && hud_used)
			client.screen += r_store


/mob/living/carbon/human/update_inv_wear_mask()
	var/obj/item/clothing/mask/M = ..()
	if(M)
		if(client && hud_used && hud_used.hud_shown)
			if(hud_used.inventory_shown)				//if the inventory is open ...
				M.screen_loc = ui_mask	//TODO	//...draw the item in the inventory screen
			client.screen += M					//Either way, add the item to the HUD
	update_mutant_bodyparts()
	sec_hud_set_ID()
	apply_overlay(FACEMASK_LAYER)


/mob/living/carbon/human/update_inv_back()
	var/obj/item/B = ..()
	if(B)
		B.screen_loc = ui_back
		if(client && hud_used && hud_used.hud_shown)
			client.screen += B
	apply_overlay(BACK_LAYER)

/mob/living/carbon/human/update_inv_handcuffed()
	if(..())
		overlays_standing[HANDCUFF_LAYER] = image("icon"='icons/mob/mob.dmi', "icon_state"="handcuff1", "layer"=-HANDCUFF_LAYER)
		apply_overlay(HANDCUFF_LAYER)

/mob/living/carbon/human/update_inv_legcuffed()
	remove_overlay(LEGCUFF_LAYER)
	if(legcuffed)
		overlays_standing[LEGCUFF_LAYER] = image("icon"='icons/mob/mob.dmi', "icon_state"="legcuff1", "layer"=-LEGCUFF_LAYER)
	apply_overlay(LEGCUFF_LAYER)


/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(..())
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar


/proc/wear_female_version(t_color, icon, layer, type)
	var/index = t_color
	var/icon/female_clothing_icon = female_clothing_icons[index]
	if(!female_clothing_icon) 	//Create standing/laying icons if they don't exist
		generate_female_clothing(index,t_color,icon,type)
	var/standing	= image("icon"=female_clothing_icons["[t_color]"], "layer"=-layer)
	return(standing)

/mob/living/carbon/human/proc/get_overlays_copy(list/unwantedLayers)
	var/list/out = new
	for(var/i=1;i<=TOTAL_LAYERS;i++)
		if(overlays_standing[i])
			if(i in unwantedLayers)
				continue
			out += overlays_standing[i]
	return out

/*
Does everything in relation to building the /image used in the mob's overlays list
covers:
 inhands and any other form of worn item
 centering large images
 layering images on custom layers
 building images from custom icon files

By Remie Richards (yes I'm taking credit because this just removed 90% of the copypaste in update_icons())

state: A string to use as the state, this is FAR too complex to solve in this proc thanks to shitty old code
so it's specified as an argument instead.

default_layer: The layer to draw this on if no other layer is specified

default_icon_file: The icon file to draw states from if no other icon file is specified

isinhands: If true then alternate_worn_icon is skipped so that default_icon_file is used,
in this situation default_icon_file is expected to match either the lefthand_ or righthand_ file var

femalueuniform: A value matching a uniform item's fitted var, if this is anything but NO_FEMALE_UNIFORM, we
generate/load female uniform sprites matching all previously decided variables


*/
/obj/item/proc/build_worn_icon(var/state = "", var/default_layer = 0, var/default_icon_file = null, var/isinhands = FALSE, var/femaleuniform = NO_FEMALE_UNIFORM)

	//Find a valid icon file from variables+arguments
	var/file2use
	if(!isinhands && alternate_worn_icon)
		file2use = alternate_worn_icon
	if(!file2use)
		file2use = default_icon_file

	//Find a valid layer from variables+arguments
	var/layer2use
	if(alternate_worn_layer)
		layer2use = alternate_worn_layer
	if(!layer2use)
		layer2use = default_layer

	var/image/standing
	if(femaleuniform)
		standing = wear_female_version(state,file2use,layer2use,femaleuniform)
	if(!standing)
		standing = image("icon"=file2use, "icon_state"=state,"layer"=-layer2use)

	//Get the overlay images for this item when it's being worn
	//eg: ammo counters, primed grenade flashes, etc.
	var/list/worn_overlays = worn_overlays(isinhands)
	if(worn_overlays && worn_overlays.len)
		standing.overlays.Add(worn_overlays)

	standing = center_image(standing, isinhands ? inhand_x_dimension : worn_x_dimension, isinhands ? inhand_y_dimension : worn_y_dimension)

	standing.alpha = alpha
	standing.color = color

	return standing


/////////////////////
// Limb Icon Cache //
/////////////////////
/*
	Called from update_body_parts() these procs handle the limb icon cache.
	the limb icon cache adds an icon_render_key to a human mob, it represents:
	- skin_tone (if applicable)
	- gender
	- limbs (stores as the limb name and whether it is removed/fine, organic/robotic)
	These procs only store limbs as to increase the number of matching icon_render_keys
	This cache exists because drawing 6/7 icons for humans constantly is quite a waste

	See RemieRichards on irc.rizon.net #coderbus
*/

var/global/list/limb_icon_cache = list()

/mob/living/carbon/human
	var/icon_render_key = ""


//produces a key based on the human's limbs
/mob/living/carbon/human/proc/generate_icon_render_key()
	. = "[dna.species.id]"

	if(dna.species.use_skintones || dna.features["mcolor"])
		. += "-coloured-[skin_tone]-[dna.features["mcolor"]]"
	else
		. += "-not_coloured"

	. += "-[gender]"
	if(disabilities & HUSK)
		. += "-husk"
	for(var/obj/item/organ/limb/L in organs)
		var/limbname = Bodypart2name(L)
		. += "-[limbname]"
		if(L.status == ORGAN_ORGANIC)
			. += "-organic"
		else
			. += "-robotic"


//change the human's icon to the one matching it's key
/mob/living/carbon/human/proc/load_limb_from_cache()
	if(limb_icon_cache[icon_render_key])
		remove_overlay(BODYPARTS_LAYER)
		overlays_standing[BODYPARTS_LAYER] = limb_icon_cache[icon_render_key]
		apply_overlay(BODYPARTS_LAYER)


//draws an icon from a limb
/mob/living/carbon/human/proc/generate_limb_icon(var/obj/item/organ/limb/affecting)
	if(!affecting)
		return 0
	var/image/I
	var/should_draw_gender = FALSE
	var/icon_gender = (gender == FEMALE) ? "f" : "m" //gender of the icon, if applicable
	var/datum/species/species = dna.species
	var/species_id = species.id
	var/should_draw_greyscale = FALSE

	if((affecting.body_part == HEAD || affecting.body_part == CHEST) && species.sexes)
		should_draw_gender = TRUE

	if((MUTCOLORS in species.specflags) || species.use_skintones || affecting.skin_tone)
		should_draw_greyscale = TRUE

	//Some overrides present on limb (This is great for frankenstein monsters :D)
	if(affecting.human_gender)
		icon_gender = (affecting.human_gender == FEMALE) ? "f" : "m"
	if(affecting.species_id)
		species_id = affecting.species_id
	if(affecting.should_draw_gender)
		should_draw_gender = affecting.should_draw_gender
	if(affecting.should_draw_greyscale)
		should_draw_greyscale = affecting.should_draw_greyscale

	if(disabilities & HUSK)
		species_id = "husk"
		should_draw_gender = FALSE
		should_draw_greyscale = FALSE

	if(affecting.status == ORGAN_ORGANIC)
		if(should_draw_greyscale)
			if(should_draw_gender)
				I = image("icon"='icons/mob/human_parts_greyscale.dmi', "icon_state"="[species_id]_[Bodypart2name(affecting)]_[icon_gender]_s", "layer"=-BODYPARTS_LAYER)
			else
				I = image("icon"='icons/mob/human_parts_greyscale.dmi', "icon_state"="[species_id]_[Bodypart2name(affecting)]_s", "layer"=-BODYPARTS_LAYER)
		else
			if(should_draw_gender)
				I = image("icon"='icons/mob/human_parts.dmi', "icon_state"="[species_id]_[Bodypart2name(affecting)]_[icon_gender]_s", "layer"=-BODYPARTS_LAYER)
			else
				I = image("icon"='icons/mob/human_parts.dmi', "icon_state"="[species_id]_[Bodypart2name(affecting)]_s", "layer"=-BODYPARTS_LAYER)
	else
		if(should_draw_gender)
			I = image("icon"='icons/mob/augments.dmi', "icon_state"="[Bodypart2name(affecting)]_[icon_gender]_s", "layer"=-BODYPARTS_LAYER)
		else
			I = image("icon"='icons/mob/augments.dmi', "icon_state"="[Bodypart2name(affecting)]_s", "layer"=-BODYPARTS_LAYER)
		if(I)
			return I
		return 0

	if(!should_draw_greyscale)
		if(I)
			return I //We're done here
		return 0


	//Greyscale Colouring
	var/draw_color

	if(species)
		if(MUTCOLORS in species.specflags)
			draw_color = dna.features["mcolor"]
		else if(species.use_skintones)
			draw_color = skintone2hex(skin_tone)
	if(affecting.skin_tone) //Limb has skin color variable defined, use it
		draw_color = skintone2hex(affecting.skin_tone)
	if(affecting.species_color)
		draw_color = affecting.species_color

	if(draw_color)
		I.color = "#[draw_color]"
	//End Greyscale Colouring

	if(I)
		return I
	return 0


/proc/skintone2hex(var/skin_tone)
	. = 0
	switch(skin_tone)
		if("caucasian1")
			. = "ffe0d1"
		if("caucasian2")
			. = "fcccb3"
		if("caucasian3")
			. = "e8b59b"
		if("latino")
			. = "d9ae96"
		if("mediterranean")
			. = "c79b8b"
		if("asian1")
			. = "ffdeb3"
		if("asian2")
			. = "e3ba84"
		if("arab")
			. = "c4915e"
		if("indian")
			. = "b87840"
		if("african1")
			. = "754523"
		if("african2")
			. = "471c18"
		if("albino")
			. = "fff4e6"
