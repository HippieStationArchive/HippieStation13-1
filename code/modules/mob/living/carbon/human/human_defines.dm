/mob/living/carbon/human
	languages = HUMAN
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD,ANTAG_HUD,ANTAG_HUD_ADMIN)

	crit_can_crawl = 1
	crit_crawl_damage = 1 //Crawling in crit should apply 1 oxyloss
	crit_crawl_damage_type = OXY //Just in case
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
	var/lip_color = "white"

	var/age = 30		//Player's age (pure fluff)

	var/underwear = "Nude"	//Which underwear the player wants
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backbag = 1		//Which backpack type the player has chosen. Backpack.or Satchel

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/ears = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/gender_ambiguous = 0 //if something goes wrong during gender reassignment this generates a line in examine

	var/blood_max = 0 //how much are we bleeding
	var/bleedsuppress = 0 //for stopping bloodloss, eventually this will be limb-based like bleeding

	var/list/organs = list() //Gets filled up in the constructor (human.dm, New() proc.

	var/datum/martial_art/martial_art = null
	var/datum/martial_art/martial_art_base = null //Permament martial art

	var/name_override //For temporary visible name changes

	var/heart_attack = 0
	var/deepfried = 0