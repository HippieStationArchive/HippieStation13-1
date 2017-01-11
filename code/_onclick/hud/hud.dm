/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob

	var/hud_shown = 1			//Used for the HUD toggle (F12)
	var/hud_version = 1			//Current displayed version of the HUD
	var/inventory_shown = 1		//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/obj/screen/lingstingdisplay
	var/obj/screen/blobpwrdisplay
	var/obj/screen/blobhealthdisplay
	var/obj/screen/alien_plasma_display
	var/obj/screen/nightvisionicon
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/action_intent
	var/obj/screen/move_intent
	var/obj/screen/combo/combo_object

	var/obj/screen/deity_health_display
	var/obj/screen/deity_power_display
	var/obj/screen/deity_follower_display

	var/list/adding
	var/list/other
	var/list/obj/screen/hotkeybuttons

	var/obj/screen/movable/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = 0

/datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()


/datum/hud/proc/hidden_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(H.handcuffed)
			H.handcuffed.screen_loc = null	//no handcuffs in my UI!
		if(inventory_shown && hud_shown)
			if(H.shoes)		H.shoes.screen_loc = ui_shoes
			if(H.gloves)	H.gloves.screen_loc = ui_gloves
			if(H.ears)		H.ears.screen_loc = ui_ears
			if(H.glasses)	H.glasses.screen_loc = ui_glasses
			if(H.w_uniform)	H.w_uniform.screen_loc = ui_iclothing
			if(H.wear_suit)	H.wear_suit.screen_loc = ui_oclothing
			if(H.wear_mask)	H.wear_mask.screen_loc = ui_mask
			if(H.head)		H.head.screen_loc = ui_head
		else
			if(H.shoes)		H.shoes.screen_loc = null
			if(H.gloves)	H.gloves.screen_loc = null
			if(H.ears)		H.ears.screen_loc = null
			if(H.glasses)	H.glasses.screen_loc = null
			if(H.w_uniform)	H.w_uniform.screen_loc = null
			if(H.wear_suit)	H.wear_suit.screen_loc = null
			if(H.wear_mask)	H.wear_mask.screen_loc = null
			if(H.head)		H.head.screen_loc = null


/datum/hud/proc/persistant_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(hud_shown)
			if(H.s_store)	H.s_store.screen_loc = ui_sstore1
			if(H.wear_id)	H.wear_id.screen_loc = ui_id
			if(H.belt)		H.belt.screen_loc = ui_belt
			if(H.back)		H.back.screen_loc = ui_back
			if(H.l_store)	H.l_store.screen_loc = ui_storage1
			if(H.r_store)	H.r_store.screen_loc = ui_storage2
		else
			if(H.s_store)	H.s_store.screen_loc = null
			if(H.wear_id)	H.wear_id.screen_loc = null
			if(H.belt)		H.belt.screen_loc = null
			if(H.back)		H.back.screen_loc = null
			if(H.l_store)	H.l_store.screen_loc = null
			if(H.r_store)	H.r_store.screen_loc = null


/datum/hud/proc/instantiate()
	if(!ismob(mymob))
		return 0
	if(!mymob.client)
		return 0

	var/ui_style = ui_style2icon(mymob.client.prefs.UI_style)

	if(ishuman(mymob))
		human_hud(ui_style) // Pass the player the UI style chosen in preferences
	else if(ismonkey(mymob))
		monkey_hud(ui_style)
	else if(isbrain(mymob))
		brain_hud(ui_style)
	else if(islarva(mymob))
		larva_hud()
	else if(isalien(mymob))
		alien_hud()
	else if(isAI(mymob))
		ai_hud()
	else if(isrobot(mymob))
		robot_hud()
	else if(isobserver(mymob))
		ghost_hud()
	else if(isovermind(mymob))
		blob_hud()
	else if(isdrone(mymob))
		drone_hud(ui_style)
	else if(isswarmer(mymob))
		swarmer_hud()
	else if(isguardian(mymob))
		guardian_hud()
	else if(what_rank(mymob.mind) == "God")
		hoggod_hud()

	reload_fullscreen()
//Version denotes which style should be displayed. blank or 0 means "next version"
/datum/hud/proc/show_hud(version = 0)
	if(!ismob(mymob))
		return 0
	if(!mymob.client)
		return 0
	var/display_hud_version = version
	if(!display_hud_version)	//If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS)	//If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1

	switch(display_hud_version)
		if(HUD_STYLE_STANDARD)	//Default HUD
			hud_shown = 1	//Governs behavior of other procs
			if(adding)
				mymob.client.screen += adding
			if(other && inventory_shown)
				mymob.client.screen += other
			if(hotkeybuttons && !hotkey_ui_hidden)
				mymob.client.screen += hotkeybuttons

			action_intent.screen_loc = ui_acti //Restore intent selection to the original position
			mymob.client.screen += mymob.zone_sel				//This one is a special snowflake
			mymob.client.screen += mymob.healths				//As are the rest of these.
			mymob.client.screen += mymob.staminas
			mymob.client.screen += mymob.healthdoll
			mymob.client.screen += mymob.internals
			mymob.client.screen += lingstingdisplay
			mymob.client.screen += lingchemdisplay
		if(HUD_STYLE_REDUCED)	//Reduced HUD
			hud_shown = 0	//Governs behavior of other procs
			if(adding)
				mymob.client.screen -= adding
			if(other)
				mymob.client.screen -= other
			if(hotkeybuttons)
				mymob.client.screen -= hotkeybuttons

			//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
			mymob.client.screen -= mymob.zone_sel	//zone_sel is a mob variable for some reason.
			mymob.client.screen -= lingstingdisplay
			mymob.client.screen -= lingchemdisplay

			//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
			mymob.client.screen += l_hand_hud_object	//we want the hands to be visible
			mymob.client.screen += r_hand_hud_object	//we want the hands to be visible
			mymob.client.screen += action_intent		//we want the intent swticher visible
			action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.
		if(HUD_STYLE_NOHUD)	//No HUD
			hud_shown = 0	//Governs behavior of other procs
			if(adding)
				mymob.client.screen -= adding
			if(other)
				mymob.client.screen -= other
			if(hotkeybuttons)
				mymob.client.screen -= hotkeybuttons

			//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
			mymob.client.screen -= mymob.zone_sel	//zone_sel is a mob variable for some reason.
			mymob.client.screen -= mymob.healths
			mymob.client.screen -= mymob.staminas
			mymob.client.screen -= mymob.healthdoll
			mymob.client.screen -= mymob.internals
			mymob.client.screen -= lingstingdisplay
			mymob.client.screen -= lingchemdisplay
	hidden_inventory_update()
	persistant_inventory_update()
	mymob.update_action_buttons()
	reorganize_alerts()

	hud_version = display_hud_version

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = 1

	if(hud_used && client)
		if(ishuman(src))
			hud_used.show_hud() //Shows the next hud preset
			usr << "<span class ='info'>Switched HUD mode. Press F12 to toggle.</span>"
		else
			usr << "<span class ='warning'>Inventory hiding is currently only supported for human mobs, sorry.</span>"
	else
		usr << "<span class ='warning'>This mob type does not use a HUD.</span>"
