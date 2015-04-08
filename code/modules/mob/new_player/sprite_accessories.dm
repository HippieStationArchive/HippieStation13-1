/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/
/proc/init_sprite_accessory_subtypes(prototype, list/L, list/male, list/female)
	if(!istype(L))		L = list()
	if(!istype(male))	male = list()
	if(!istype(female))	female = list()

	for(var/path in typesof(prototype))
		if(path == prototype)	continue
		var/datum/sprite_accessory/D = new path()

		if(D.icon_state)	L[D.name] = D
		else				L += D.name

		switch(D.gender)
			if(MALE)	male += D.name
			if(FEMALE)	female += D.name
			else
				male += D.name
				female += D.name
	return L

/datum/sprite_accessory
	var/icon			//the icon file the accessory is located in
	var/icon_state		//the icon_state of the accessory
	var/name			//the preview name of the accessory
	var/gender = NEUTER	//Determines if the accessory will be skipped or included in random hair generations
	var/list/species_allowed = list("Human") // For later use!
//////////////////////
// Hair Definitions //
//////////////////////
/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face.dmi'	  // default icon for all hairs

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = null
	species_allowed = list("Human","Avain")

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

/datum/sprite_accessory/hair/shorthair2
	name = "Short Hair 2"
	icon_state = "hair_shorthair2"
	species_allowed = list("Human")

/datum/sprite_accessory/hair/shorthair3
	name = "Short Hair 3"
	icon_state = "hair_shorthair3"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "hair_b"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/over_eye
	name = "Over Eye"
	icon_state = "hair_shortovereye"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/long_over_eye
	name = "Long Over Eye"
	icon_state = "hair_longovereye"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longest2
	name = "Very Long Over Eye"
	icon_state = "hair_longest2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "hair_vlongfringe"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/halfbang2
	name = "Half-banged Hair 2"
	icon_state = "hair_halfbang2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail"
	icon_state = "hair_ponytail"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_ponytail2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"
	species_allowed = list("Human")

/datum/sprite_accessory/hair/sidetail
	name = "Side Pony"
	icon_state = "hair_sidetail"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/sidetail2
	name = "Side Pony 2"
	icon_state = "hair_sidetail2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/sidetail3
	name = "Side Pony 3"
	icon_state = "hair_sidetail3"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/sidetail4
	name = "Side Pony 4"
	icon_state = "hair_sidetail4"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/oneshoulder
	name = "One Shoulder"
	icon_state = "hair_oneshoulder"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/tressshoulder
	name = "Tress Shoulder"
	icon_state = "hair_tressshoulder"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bigpompadour
	name = "Big Pompadour"
	icon_state = "hair_bigpompadour"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/messy
	name = "Messy"
	icon_state = "hair_messy"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehivev2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "hair_bigafro"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longemo
	name = "Long Emo"
	icon_state = "hair_longemo"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/fag
	name = "Flow Hair"
	icon_state = "hair_f"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/reversemohawk
	name = "Reverse Mohawk"
	icon_state = "hair_reversemohawk"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/jensen
	name = "Adam Jensen Hair"
	icon_state = "hair_jensen"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/spiky2
	name = "Spiky 2"
	icon_state = "hair_spiky"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/spiky3
	name = "Spiky 3"
	icon_state = "hair_spiky2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/protagonist
	name = "Slightly long"
	icon_state = "hair_protagonist"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/kagami
	name = "Pigtails"
	icon_state = "hair_kagami"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/pigtail
	name = "Pigtails 2"
	icon_state = "hair_pigtails"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/pigtail
	name = "Pigtails 3"
	icon_state = "hair_pigtails2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/himecut2
	name = "Hime Cut 2"
	icon_state = "hair_himecut2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/himeup
	name = "Hime Updo"
	icon_state = "hair_himeup"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/antenna
	name = "Ahoge"
	icon_state = "hair_antenna"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/front_braid
	name = "Braided front"
	icon_state = "hair_braidfront"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/lowbraid
	name = "Low Braid"
	icon_state = "hair_hbraid"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/not_floorlength_braid
	name = "High Braid"
	icon_state = "hair_braid2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/shortbraid
	name = "Short Braid"
	icon_state = "hair_shortbraid"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon_state = "hair_braid"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longbangs
	name = "Long Bangs"
	icon_state = "hair_lbangs"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/parted
	name = "Side Part"
	icon_state = "hair_part"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/braided
	name = "Braided"
	icon_state = "hair_braided"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bun
	name = "Bun Head"
	icon_state = "hair_bun"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bun2
	name = "Bun Head 2"
	icon_state = "hair_bunhead2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/braidtail
	name = "Braided Tail"
	icon_state = "hair_braidtail"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bigflattop
	name = "Big Flat Top"
	icon_state = "hair_bigflattop"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/drillhair
	name = "Drill Hair"
	icon_state = "hair_drillhair"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/keanu
	name = "Keanu Hair"
	icon_state = "hair_keanu"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/swept
	name = "Swept Back Hair"
	icon_state = "hair_swept"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/swept2
	name = "Swept Back Hair 2"
	icon_state = "hair_swept2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/business
	name = "Business Hair"
	icon_state = "hair_business"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/business2
	name = "Business Hair 2"
	icon_state = "hair_business2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/business3
	name = "Business Hair 3"
	icon_state = "hair_business3"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/business4
	name = "Business Hair 4"
	icon_state = "hair_business4"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/hedgehog
	name = "Hedgehog Hair"
	icon_state = "hair_hedgehog"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bob
	name = "Bob Hair"
	icon_state = "hair_bob"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/bob2
	name = "Bob Hair 2"
	icon_state = "hair_bob2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/long
	name = "Long Hair 1"
	icon_state = "hair_long"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/long2
	name = "Long Hair 2"
	icon_state = "hair_long2"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/pixie
	name = "Pixie Cut"
	icon_state = "hair_pixie"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/megaeyebrows
	name = "Mega Eyebrows"
	icon_state = "hair_megaeyebrows"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/highponytail
	name = "High Ponytail"
	icon_state = "hair_highponytail"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/longponytail
	name = "Long Ponytail"
	icon_state = "hair_longstraightponytail"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/sidepartlongalt
	name = "Long Side Part"
	icon_state = "hair_longsidepart"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/birdnest
	name = "Bird Nest"
	icon_state = "hair_birdnest"
	species_allowed = list("Human")
/datum/sprite_accessory/hair/unkept
	name = "Unkempt"
	icon_state = "hair_unkept"

/datum/sprite_accessory/hair/duelist
	name = "Duelist"
	icon_state = "hair_duelist"
	gender = MALE
	species_allowed = list("Human")
/datum/sprite_accessory/hair/fastline
	name = "Fastline"
	icon_state = "hair_fastline"
	species_allowed = list("Human","LizardPeople")
	gender = MALE
	species_allowed = list("Human","LizardPeople")
/datum/sprite_accessory/hair/modern
	name = "Modern"
	icon_state = "hair_modern"
	gender = FEMALE
	species_allowed = list("Human")
/datum/sprite_accessory/hair/unshavenmohawk
	name = "Unshaven Mohawk"
	icon_state = "hair_unshavenmohawk"
	gender = MALE
	species_allowed = list("Human")
/datum/sprite_accessory/hair/drills
	name = "Twincurls"
	icon_state = "hair_twincurl"
	gender = FEMALE
	species_allowed = list("Human")
/datum/sprite_accessory/hair/minidrills
	name = "Twincurls 2"
	icon_state = "hair_twincurl2"
	gender = FEMALE
	species_allowed = list("Human")
/*/ IPC SHIT PORTED FROM VG NOICE FIGURE IT OUT LATER

/datum/sprite_accessory/hair/icp_screen_pink
		name = "pink IPC screen"
		icon_state = "ipc_pink"
		species_allowed = list("")

/datum/sprite_accessory/hair/icp_screen_red
		name = "red IPC screen"
		icon_state = "ipc_red"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_green
		name = "green IPC screen"
		icon_state = "ipc_green"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_blue
		name = "blue IPC screen"
		icon_state = "ipc_blue"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_breakout
		name = "breakout IPC screen"
		icon_state = "ipc_breakout"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_eight
		name = "eight IPC screen"
		icon_state = "ipc_eight"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_goggles
		name = "goggles IPC screen"
		icon_state = "ipc_goggles"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_heart
		name = "heart IPC screen"
		icon_state = "ipc_heart"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_monoeye
		name = "monoeye IPC screen"
		icon_state = "ipc_monoeye"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_nature
		name = "nature IPC screen"
		icon_state = "ipc_nature"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_orange
		name = "orange IPC screen"
		icon_state = "ipc_orange"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_purple
		name = "purple IPC screen"
		icon_state = "ipc_purple"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_shower
		name = "shower IPC screen"
		icon_state = "ipc_shower"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_static
		name = "static IPC screen"
		icon_state = "ipc_static"
		species_allowed = list("IPC")

/datum/sprite_accessory/hair/icp_screen_yellow
		name = "yellow IPC screen"
		icon_state = "ipc_yellow"
		species_allowed = list("IPC")
*//

/////////////////////////////
// Facial Hair Definitions //
/////////////////////////////
/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix w/ beards :P)

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/vandyke
	name = "Van Dyke Mustache"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Very Long Beard"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"

/datum/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/jensen
	name = "Adam Jensen Beard"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/fiveoclock
	name = "Five o Clock Shadow"
	icon_state = "facial_fiveoclock"

/datum/sprite_accessory/facial_hair/fu
	name = "Fu Manchu"
	icon_state = "facial_fumanchu"

/datum/sprite_accessory/facial_hair/britstache
	name = "Brit Stache"
	icon_state = "facial_britstache"

/datum/sprite_accessory/facial_hair/martialartist
	name = "Martial Artist"
	icon_state = "facial_martialartist"

/datum/sprite_accessory/facial_hair/moonshiner
	name = "Moonshiner"
	icon_state = "facial_moonshiner"

/datum/sprite_accessory/facial_hair/tribeard
	name = "Tri-beard"
	icon_state = "facial_tribeard"

/datum/sprite_accessory/facial_hair/unshaven
	name = "Unshaven"
	icon_state = "facial_unshaven"

///////////////////////////
// Underwear Definitions //
///////////////////////////
/datum/sprite_accessory/underwear
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/underwear/nude
	name = "Nude"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/underwear/male_white
	name = "Mens White"
	icon_state = "male_white"
	gender = MALE

/datum/sprite_accessory/underwear/male_grey
	name = "Mens Grey"
	icon_state = "male_grey"
	gender = MALE

/datum/sprite_accessory/underwear/male_green
	name = "Mens Green"
	icon_state = "male_green"
	gender = MALE

/datum/sprite_accessory/underwear/male_blue
	name = "Mens Blue"
	icon_state = "male_blue"
	gender = MALE

/datum/sprite_accessory/underwear/male_black
	name = "Mens Black"
	icon_state = "male_black"
	gender = MALE

/datum/sprite_accessory/underwear/male_mankini
	name = "Mankini"
	icon_state = "male_mankini"
	gender = MALE

/datum/sprite_accessory/underwear/male_hearts
	name = "Mens Hearts Boxer"
	icon_state = "male_hearts"
	gender = MALE

/datum/sprite_accessory/underwear/male_blackalt
	name = "Mens Black Boxer"
	icon_state = "male_blackalt"
	gender = MALE

/datum/sprite_accessory/underwear/male_greyalt
	name = "Mens Grey Boxer"
	icon_state = "male_greyalt"
	gender = MALE

/datum/sprite_accessory/underwear/male_stripe
	name = "Mens Striped Boxer"
	icon_state = "male_stripe"
	gender = MALE

/datum/sprite_accessory/underwear/male_kinky
	name = "Mens Kinky"
	icon_state = "male_kinky"
	gender = MALE

/datum/sprite_accessory/underwear/male_red
	name = "Mens Red"
	icon_state = "male_red"
	gender = MALE

/datum/sprite_accessory/underwear/female_red
	name = "Ladies Red"
	icon_state = "female_red"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_white
	name = "Ladies White"
	icon_state = "female_white"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_yellow
	name = "Ladies Yellow"
	icon_state = "female_yellow"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_blue
	name = "Ladies Blue"
	icon_state = "female_blue"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_black
	name = "Ladies Black"
	icon_state = "female_black"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_thong
	name = "Ladies Thong"
	icon_state = "female_thong"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_babydoll
	name = "Babydoll"
	icon_state = "female_babydoll"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_babyblue
	name = "Ladies Baby-Blue"
	icon_state = "female_babyblue"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_green
	name = "Ladies Green"
	icon_state = "female_green"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_pink
	name = "Ladies Pink"
	icon_state = "female_pink"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_kinky
	name = "Ladies Kinky"
	icon_state = "female_kinky"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_whitealt
	name = "Ladies White Sport"
	icon_state = "female_whitealt"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_blackalt
	name = "Ladies Black Sport"
	icon_state = "female_blackalt"
	gender = FEMALE

////////////////////////////
// Undershirt Definitions //
////////////////////////////
/datum/sprite_accessory/undershirt
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/undershirt/nude
	name = "Nude"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/undershirt/shirt_white
	name = "White Shirt"
	icon_state = "shirt_white"
	gender = NEUTER

/datum/sprite_accessory/undershirt/shirt_black
	name = "Black Shirt"
	icon_state = "shirt_black"
	gender = NEUTER

/datum/sprite_accessory/undershirt/shirt_grey
	name = "Grey Shirt"
	icon_state = "shirt_grey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_white
	name = "White Tank Top"
	icon_state = "tank_white"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_black
	name = "Black Tank Top"
	icon_state = "tank_black"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_grey
	name = "Grey Tank Top"
	icon_state = "tank_grey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/female_midriff
	name = "Midriff Tank Top"
	icon_state = "tank_midriff"
	gender = FEMALE

/datum/sprite_accessory/undershirt/lover
	name = "Lover shirt"
	icon_state = "lover"
	gender = NEUTER

/datum/sprite_accessory/undershirt/ian
	name = "Blue Ian Shirt"
	icon_state = "ian"
	gender = NEUTER

/datum/sprite_accessory/undershirt/uk
	name = "UK Shirt"
	icon_state = "uk"
	gender = NEUTER

/datum/sprite_accessory/undershirt/ilovent
	name = "I Love NT Shirt"
	icon_state = "ilovent"
	gender = NEUTER

/datum/sprite_accessory/undershirt/peace
	name = "Peace Shirt"
	icon_state = "peace"
	gender = NEUTER

/datum/sprite_accessory/undershirt/mondmondjaja
	name = "Band Shirt"
	icon_state = "band"
	gender = NEUTER

/datum/sprite_accessory/undershirt/pacman
	name = "Pogoman Shirt"
	icon_state = "pogoman"
	gender = NEUTER

/datum/sprite_accessory/undershirt/matroska
	name = "Matroska Shirt"
	icon_state = "matroska"
	gender = NEUTER

/datum/sprite_accessory/undershirt/whiteshortsleeve
	name = "White Short-sleeved Shirt"
	icon_state = "whiteshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/purpleshortsleeve
	name = "Purple Short-sleeved Shirt"
	icon_state = "purpleshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshortsleeve
	name = "Blue Short-sleeved Shirt"
	icon_state = "blueshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/greenshortsleeve
	name = "Green Short-sleeved Shirt"
	icon_state = "greenshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blackshortsleeve
	name = "Black Short-sleeved Shirt"
	icon_state = "blackshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshirt
	name = "Blue T-Shirt"
	icon_state = "blueshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redshirt
	name = "Red T-Shirt"
	icon_state = "redshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/yellowshirt
	name = "Yellow T-Shirt"
	icon_state = "yellowshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/greenshirt
	name = "Green T-Shirt"
	icon_state = "greenshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/bluepolo
	name = "Blue Polo Shirt"
	icon_state = "bluepolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redpolo
	name = "Red Polo Shirt"
	icon_state = "redpolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/whitepolo
	name = "White Polo Shirt"
	icon_state = "whitepolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/grayyellowpolo
	name = "Gray-Yellow Polo Shirt"
	icon_state = "grayyellowpolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redtop
	name = "Red Top"
	icon_state = "redtop"
	gender = FEMALE

/datum/sprite_accessory/undershirt/whitetop
	name = "White Top"
	icon_state = "whitetop"
	gender = FEMALE

/datum/sprite_accessory/undershirt/greenshirtsport
	name = "Green Sports Shirt"
	icon_state = "greenshirtsport"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redshirtsport
	name = "Red Sports Shirt"
	icon_state = "redshirtsport"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshirtsport
	name = "Blue Sports Shirt"
	icon_state = "blueshirtsport"
	gender = NEUTER

/datum/sprite_accessory/undershirt/ss13
	name = "SS13 Shirt"
	icon_state = "shirt_ss13"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tankfire
	name = "Fire Tank Top"
	icon_state = "tank_fire"
	gender = NEUTER

/datum/sprite_accessory/undershirt/question
	name = "Question Shirt"
	icon_state = "shirt_question"
	gender = NEUTER

/datum/sprite_accessory/undershirt/skull
	name = "Skull Shirt"
	icon_state = "shirt_skull"
	gender = NEUTER

/datum/sprite_accessory/undershirt/commie
	name = "Commie Shirt"
	icon_state = "shirt_commie"
	gender = NEUTER

/datum/sprite_accessory/undershirt/nano
	name = "Nanotransen Shirt"
	icon_state = "shirt_nano"
	gender = NEUTER

/datum/sprite_accessory/undershirt/stripe
	name = "Striped Shirt"
	icon_state = "shirt_stripes"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshirt
	name = "Blue Shirt"
	icon_state = "shirt_blue"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redshirt
	name = "Red Shirt"
	icon_state = "shirt_red"
	gender = NEUTER

/datum/sprite_accessory/undershirt/greenshirt
	name = "Green Shirt"
	icon_state = "shirt_green"
	gender = NEUTER

/datum/sprite_accessory/undershirt/meat
	name = "Meat Shirt"
	icon_state = "shirt_meat"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tiedye
	name = "Tie-dye Shirt"
	icon_state = "shirt_tiedye"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redjersey
	name = "Red Jersey"
	icon_state = "shirt_redjersey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/bluejersey
	name = "Blue Jersey"
	icon_state = "shirt_bluejersey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tankstripe
	name = "Striped Tank Top"
	icon_state = "tank_stripes"
	gender = NEUTER

/datum/sprite_accessory/undershirt/whitepolostripe
	name = "White Striped Polo Shirt"
	icon_state = "whitepolostriped"
	gender = NEUTER

/datum/sprite_accessory/undershirt/batter
	name = "The Batter Shirt"
	icon_state = "batter"
	gender = NEUTER


