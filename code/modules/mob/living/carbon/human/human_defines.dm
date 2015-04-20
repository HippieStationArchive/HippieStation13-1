/mob/living/carbon/human
	languages = HUMAN
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD,ANTAG_HUD)
	//Hair colour and style
	var/hair_color = "000"
	var/hair_style = "Bald"

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hair_style = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/spraypaint = null	//No spraypaint on face by default - obvious reasons. Only used by paint cans currently.
	var/spraypaint_color = "#FFFFFF" //White spraypaint by default

	var/age = 30		//Player's age (pure fluff)
	var/blood_type = "A+"	//Player's bloodtype (Not currently used, just character fluff)

	var/underwear = "Nude"	//Which underwear the player wants
	var/undershirt = "Nude" //Which undershirt the player wants
	var/backbag = 2		//Which backpack type the player has chosen. Nothing, Satchel or Backpack.

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/ears = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/icon/base_icon_state = "caucasian1_m"

	var/list/organs = list() //Gets filled up in the constructor (human.dm, New() proc, line 24. I'm sick and tired of missing comments. -Agouri

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/gender_ambiguous = 0 //if something goes wrong during gender reassignment this generates a line in examine

	var/list/martial_arts = list() // Contains each of a human's current martial arts
	var/datum/martial_art/martial_art = null // The currently in-use martial art

	var/adjusted_darkness_sight = 0
	var/get_adjust_message = 0 //whether or not we'll be spammed by the adjustment messages
	var/lastDarknessAdjust = 0