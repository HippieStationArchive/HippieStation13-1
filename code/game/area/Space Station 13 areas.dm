/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/area
	var/fire = null
	var/radstorm = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Space"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1
	var/valid_territory = 1 //If it's a valid territory for gangs to claim

	var/eject = null

	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0
	var/static_equip
	var/static_light = 0
	var/static_environ

	var/has_gravity = 0
	var/safe = 0 				//Is the area teleport-safe: no space / radiation / aggresive mobs / other dangers

	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/proc/process_teleport_locs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == ZLEVEL_STATION)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	sortTim(teleportlocs, /proc/cmp_text_dsc)

/*-----------------------------------------------------------------------------*/

/area/engine/

/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"

/area/space
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_DISABLED
	power_light = 0
	power_equip = 0
	power_environ = 0
	valid_territory = 0
	ambientsounds = list('sound/ambience/ambispace.ogg','sound/ambience/space_stutter.ogg','sound/ambience/space_ambience.ogg',\
				'sound/ambience/title1.ogg','sound/ambience/title2.ogg','sound/ambience/title3.ogg',)
	ambloop = 'sound/ambience/loop/space.ogg'

/area/space/nearstation
	icon_state = "space_near"
	lighting_use_dynamic = DYNAMIC_LIGHTING_IFSTARLIGHT

//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.

/area/shuttle
	name = "Shuttle"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_ENABLED
	has_gravity = 1
	valid_territory = 0
	icon_state = "shuttle"

/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/pod_1
	name = "Escape Pod One"

/area/shuttle/pod_2
	name = "Escape Pod Two"

/area/shuttle/pod_3
	name = "Escape Pod Three"

/area/shuttle/pod_4
	name = "Escape Pod Four"

/area/shuttle/mining
	name = "Mining Shuttle"

/area/shuttle/labor
	name = "Labor Camp Shuttle"

/area/shuttle/supply
	name = "Supply Shuttle"

/area/shuttle/escape
	name = "Emergency Shuttle"

/area/shuttle/transport
	name = "Transport Shuttle"

/area/shuttle/syndicate
	name = "Syndicate Infiltrator"

/area/shuttle/assault_pod
	name = "Steel Rain"

/area/shuttle/abandoned
	name = "Abandoned Ship"
	ambientsounds = list('sound/ambience/ambiatm1.ogg', 'sound/ambience/ambmaint.ogg',\
						'sound/ambience/ambicreek1.ogg', 'sound/ambience/ambicreek2.ogg',\
						'sound/ambience/ambicha2.ogg', 'sound/ambience/ambicha3.ogg')
	ambloop = 'sound/ambience/loop/softhum.ogg'

/area/shuttle/outpost
	name = "Outpost Shuttle"

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_DISABLED
	has_gravity = 1

// CENTCOM

/area/centcom
	name = "Centcom"
	icon_state = "centcom"
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/cargohum.ogg'

/area/centcom/control
	name = "Centcom Docks"

/area/centcom/evac
	name = "Centcom Recovery Ship"
	ambloop = 'sound/ambience/loop/cargohum.ogg'

/area/centcom/supply
	name = "Centcom Supply Shuttle Dock"

/area/centcom/ferry
	name = "Centcom Transport Shuttle Dock"

/area/centcom/prison
	name = "Admin Prison"

/area/centcom/holding
	name = "Holding Facility"

//SYNDICATES

/area/syndicate_mothership
	name = "Syndicate Mothership"
	icon_state = "syndie-ship"
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/windwinterinside.ogg'
	ambientsounds = list('sound/ambience/ambicreek1.ogg', 'sound/ambience/ambicreek2.ogg', 'sound/ambience/johncena.ogg')

/area/syndicate_mothership/control
	name = "Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "Syndicate Elite Squad"
	icon_state = "syndie-elite"

//EXTRA

/area/asteroid
	name = "Asteroid"
	icon_state = "green"
	requires_power = 0
	has_gravity = 1

/area/asteroid/cave
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/asteroid/artifactroom
	name = "Asteroid - Artifact"
	icon_state = "cave"

/area/asteroid/crash
	name = "Asteroid Crash Site"
	icon_state = "cave"
	has_gravity = 1

/area/asteroid/crash/New()
	..()
	SetDynamicLighting()

/area/asteroid/artifactroom/New()
	..()
	SetDynamicLighting()

/area/planet/clown
	name = "Clown Planet"
	icon_state = "honk"
	requires_power = 0
	ambloop = 'sound/ambience/loop/space.ogg'
	ambientsounds = list('sound/ambience/clown.ogg','sound/misc/slip.ogg','sound/items/bikehorn.ogg')

/area/telesciareas
	name = "Cosmic Anomaly"
	icon_state = "telesci"
	requires_power = 0

/area/tdome
	name = "Thunderdome"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1

/area/tdome/arena
	name = "Thunderdome Arena"
	icon_state = "thunder"

/area/tdome/arena_source
	name = "Thunderdome Arena Template"
	icon_state = "thunder"

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "green"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"

//ENEMY


/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/terriblehum.ogg'

//Abductors
/area/abductor_ship
	name = "Abductor Ship"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/opressivehum.ogg'

//PRISON
/area/prison
	name = "Prison Station"
	icon_state = "brig"

/area/prison/arrival_airlock
	name = "Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Quarters"
	icon_state = "security"

/area/prison/rec_room
	name = "Prison Rec Room"
	icon_state = "green"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Prison Morgue"
	icon_state = "morgue"
	ambientsounds = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//STATION13

/area/atmos
	name = "Atmospherics"
	icon_state = "atmos"

//Maintenance
/area/maintenance
	ambientsounds = list('sound/ambience/ambimaint1.ogg', 'sound/ambience/ambimaint2.ogg', 'sound/ambience/ambimaint3.ogg', 'sound/ambience/ambimaint4.ogg', 'sound/ambience/ambimaint5.ogg')
	valid_territory = 0

/area/maintenance/atmos_control
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint
	name = "EVA Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Arrivals North Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Dormitory Maintenance"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Bar Maintenance"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Medbay Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Locker Room Maintenance"
	icon_state = "pmaint"

/area/maintenance/aft
	name = "Engineering Maintenance"
	icon_state = "amaint"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/incinerator
	name = "Incinerator"
	icon_state = "disposal"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/electrical
	name = "Electrical Maintenance"
	icon_state = "yellow"

/area/maintenance/secelectrical
	name = "Security Electrical Maintenance"
	icon_state = "yellow"

/area/maintenance/brigwest
	name = "Brig West Wing Maintenance"
	icon_state = "yellow"

/area/maintenance/strangeroom
	name = "Strange Room"
	icon_state = "yellow"

/area/maintenance/commiespy
	name = "Russian Room"
	icon_state = "yellow"


//Hallway

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"

/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"

/area/bridge/meeting_room
	name = "Heads of Staff Meeting Room"
	icon_state = "meeting"
	music = null

/area/crew_quarters/captain
	name = "Captain's Office"
	icon_state = "captain"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/crew_quarters/heads
	name = "Head of Personnel's Office"
	icon_state = "head_quarters"

/area/crew_quarters/hor
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/crew_quarters/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"

/area/mint
	name = "Mint"
	icon_state = "green"

/area/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"

/area/server
	name = "Messaging Server Room"
	icon_state = "server"

//Crew

/area/crew_quarters
	name = "Dormitories"
	icon_state = "Sleep"
	safe = 1

/area/crew_quarters/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep
	name = "Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male
	name = "Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male/toilet_male
	name = "Male Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_female
	name = "Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "Female Toilets"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/locker/locker_toilet
	name = "Locker Toilets"
	icon_state = "toilet"

/area/crew_quarters/pool
	name = "Pool"
	icon_state = "pool"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"

/area/crew_quarters/theatre
	name = "Theatre"
	icon_state = "Theatre"

/area/library
	name = "Library"
	icon_state = "library"

/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"
	ambientsounds = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "Law Office"
	icon_state = "law"

/area/clown
	name = "Clown Office"
	icon_state = "clown"

/area/mime
	name = "Mime Office"
	icon_state = "mime"

/area/rec_room
	name = "Recreation Room"
	icon_state = "yellow"






/area/holodeck
	name = "Holodeck"
	icon_state = "Holodeck"
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_DISABLED

/area/holodeck/alphadeck
	name = "Holodeck Alpha"


/area/holodeck/source_plating
	name = "Holodeck - Off"
	icon_state = "Holodeck"

/area/holodeck/source_emptycourt
	name = "Holodeck - Empty Court"

/area/holodeck/source_boxingcourt
	name = "Holodeck - Boxing Court"

/area/holodeck/source_basketball
	name = "Holodeck - Basketball Court"

/area/holodeck/source_thunderdomecourt
	name = "Holodeck - Thunderdome Court"

/area/holodeck/source_beach
	name = "Holodeck - Beach"
	icon_state = "Holodeck" // Lazy.

/area/holodeck/source_burntest
	name = "Holodeck - Atmospheric Burn Test"

/area/holodeck/source_wildlife
	name = "Holodeck - Wildlife Simulation"

/area/holodeck/source_wrestling
	name = "Holodeck - Wrestling Arena"

/area/holodeck/source_cqc
	name = "Holodeck - CQC VR Training"

/area/holodeck/source_krav_maga
	name = "Holodeck - Krav Maga Training"



//Engineering

/area/engine
	ambientsounds = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')

/area/engine/engine_smes
	name = "Engineering SMES"
	icon_state = "engine_smes"

/area/engine/engineering
	name = "Engineering"
	icon_state = "engine"

/area/engine/break_room
	name = "Engineering Foyer"
	icon_state = "engine"

/area/engine/chiefs_office
	name = "Chief Engineer's office"
	icon_state = "engine_control"

/area/engine/secure_construction
	name = "Secure Construction Area"
	icon_state = "engine"

/area/engine/gravity_generator
	name = "Gravity Generator Room"
	icon_state = "blue"

/area/engine/supermatter
	name = "Supermatter"
	icon_state = "red"

/area/engine/heat_exchange
	name = "Filtering Room"
	icon_state = "yellow"

/area/engine/port_engineering
	name = "Port Engineering"
	icon_state = "green"

//Solars

/area/solar
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_IFSTARLIGHT
	valid_territory = 0

/area/solar/auxport
		name = "Fore Port Solar Array"
		icon_state = "panelsA"

/area/solar/auxstarboard
		name = "Fore Starboard Solar Array"
		icon_state = "panelsA"

/area/solar/fore
		name = "Fore Solar Array"
		icon_state = "yellow"

/area/solar/aft
		name = "Aft Solar Array"
		icon_state = "aft"

/area/solar/starboard
		name = "Aft Starboard Solar Array"
		icon_state = "panelsS"

/area/solar/port
		name = "Aft Port Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Fore Port Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/starboardsolar
	name = "Aft Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Aft Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/auxsolarstarboard
	name = "Fore Starboard Solar Maintenance"
	icon_state = "SolarcontrolA"


/area/assembly/chargebay
	name = "Mech Bay"
	icon_state = "mechbay"

/area/assembly/showroom
	name = "Robotics Showroom"
	icon_state = "showroom"

/area/assembly/robotics
	name = "Robotics Lab"
	icon_state = "ass_line"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "Assembly Line"
	icon_state = "ass_line"
	power_equip = 0
	power_light = 0
	power_environ = 0

//Teleporter

/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/gateway
	name = "Gateway"
	icon_state = "teleporter"
	music = "signal"

/area/AIsattele
	name = "Abandoned Teleporter"
	icon_state = "teleporter"
	music = "signal"
	ambientsounds = list('sound/ambience/ambimalf.ogg')
	ambloop = 'sound/ambience/loop/quiethum.ogg'

//MedBay

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

//Medbay is a large area, these additional areas help level out APC load.
/area/medical/medbay2
	name = "Medbay"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay3
	name = "Medbay"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/patients_rooms
	name = "Patient's Rooms"
	icon_state = "patients"

/area/medical/cmo
	name = "Chief Medical Officer's office"
	icon_state = "CMO"

/area/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"

/area/medical/virology
	name = "Virology"
	icon_state = "virology"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	ambientsounds = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Genetics Lab"
	icon_state = "genetics"

/area/medical/genetics_cloning
	name = "Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "Medbay Treatment Center"
	icon_state = "exam_room"

//Security

/area/security/main
	name = "Security Office"
	icon_state = "security"

/area/security/lockers
	name = "Security Locker Room"
	icon_state = "firingrange"

/area/security/sec_lobby
	name = "Security Lobby"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/prison
	name = "Brig West Wing"
	icon_state = "sec_prison"

/area/security/trainingroom
	name = "Training Room"
	icon_state = "sec_prison"
	color = "yellow"

/area/security/isolation
	name = "Brig Medbay"
	icon_state = "sec_prison"
	color = "blue"

/area/security/processing
	name = "Prison Shuttle Dock"
	icon_state = "sec_prison"

/area/security/warden
	name = "Brig Control"
	icon_state = "Warden"

/area/security/armory
	name = "Armory"
	icon_state = "armory"

/area/security/hos
	name = "Head of Security's Office"
	icon_state = "sec_hos"

/area/security/detectives_office
	name = "Detective's Office"
	icon_state = "detective"

/area/security/range
	name = "Firing Range"
	icon_state = "firingrange"

/area/security/transfer
	name = "Transfer Centre"
	icon_state = "armory"

/area/security/arrivalscheckpoint
	name = "Arrivals Security Checkpoint"
	icon_state = "security"

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"

/area/ai_monitored/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "Vacant Office"
	icon_state = "security"

/area/quartermaster
	name = "Quartermasters"
	icon_state = "quart"

///////////WORK IN PROGRESS//////////

/area/quartermaster/sorting
	name = "Delivery Office"
	icon_state = "quartstorage"

////////////WORK IN PROGRESS//////////

/area/quartermaster/office
	name = "Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "Cargo Bay"
	icon_state = "quartstorage"

/area/quartermaster/qm
	name = "Quartermaster's Office"
	icon_state = "quart"

//Outpost

/area/quartermaster/miningdock
	name = "Mining Dock"
	icon_state = "mining"

/area/quartermaster/miningstorage
	name = "Mining Storage"
	icon_state = "green"

/area/quartermaster/mechbay
	name = "Mech Bay"
	icon_state = "yellow"

/area/janitor/
	name = "Custodial Closet"
	icon_state = "janitor"

/area/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

//Toxins

/area/toxins/lab
	name = "Research and Development"
	icon_state = "toxlab"

/area/toxins/shuttledock
	name = "Research Shuttle Dock"
	icon_state = "toxmisc"

/area/toxins/shuttle
	name = "Research Shuttle"
	icon_state = "shuttle"

/area/toxins/xenobiology
	name = "Xenobiology Lab"
	icon_state = "toxlab"

/area/toxins/storage
	name = "Toxins Storage"
	icon_state = "toxstorage"

/area/toxins/mineral_storeroom
	name = "Mineral Storeroom"
	icon_state = "toxmisc"

/area/toxins/test_area
	valid_territory = 0
	name = "Toxins Test Area"
	icon_state = "toxtest"
	ambloop = 'sound/ambience/loop/space.ogg'

/area/toxins/mixing
	name = "Toxins Mixing Room"
	icon_state = "toxmix"

/area/toxins/misc_lab
	name = "Testing Lab"
	icon_state = "toxmisc"

/area/toxins/server
	name = "Server Room"
	icon_state = "server"

/area/toxins/explab
	name = "Experimentation Lab"
	icon_state = "toxmisc"

//Storage

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"

//DJSTATION

/area/djstation
	name = "Ruskie DJ Station"
	icon_state = "DJ"
	has_gravity = 1

/area/djstation/solars
	name = "DJ Station Solars"
	icon_state = "DJ"
	has_gravity = 1
	ambloop = 'sound/ambience/loop/space.ogg'

//DERELICT

/area/derelict
	name = "Derelict Station"
	icon_state = "hallC"
	ambloop = 'sound/ambience/loop/drone01.ogg'
	ambientsounds = list('sound/ambience/ambmaint.ogg','sound/ambience/ambicreek1.ogg',\
							'sound/ambience/ambicreek2.ogg','sound/ambience/ambigen5.ogg',\
							'sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg',\
							'sound/ambience/ambieng1.ogg')

/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/janitor
	name = "Derelict Custodial Closet"
	icon_state = "janitor"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Derelict Command"
	icon_state = "bridge"

/area/derelict/brig
	name = "Derelict Security"
	icon_state = "security"

/area/derelict/cargo
	name = "Derelict Supply"
	icon_state = "quartstorage"

/area/derelict/research
	name = "Derelict Research"
	icon_state = "medresearch"

/area/derelict/secret
	name = "Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Derelict Computer Core"
	icon_state = "ai"

/area/derelict/bridge/hop
	name = "Derelict Job Assignment"
	icon_state = "head_quarters"

/area/derelict/solar_control
	name = "Derelict Solar Control"
	icon_state = "engine"

/area/derelict/se_solar
	name = "South East Solars"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/crew_quarters/bar
	name = "Derelict Diner"
	icon_state = "bar"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "Abandoned Ship"
	icon_state = "yellow"
	ambientsounds = list('sound/ambience/ambiatm1.ogg', 'sound/ambience/ambmaint.ogg',\
						'sound/ambience/ambicreek1.ogg', 'sound/ambience/ambicreek2.ogg',\
						'sound/ambience/ambicha2.ogg', 'sound/ambience/ambicha3.ogg')
	ambloop = 'sound/ambience/loop/softhum.ogg'

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "yellow"

/area/derelict/singularity_engine
	name = "Derelict Engine"
	icon_state = "engine"

/area/derelict/gravity_generator
	name = "Derelict Gravity Generator Room"
	icon_state = "red"

/area/derelict/atmospherics
	name = "Derelict Atmospherics"
	icon_state = "red"

/area/derelict/russian
	name = "Russian Hideaway"
	icon_state = "red"

//Construction

/area/construction
	name = "Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "Solar Panels"
	icon_state = "yellow"
	ambloop = 'sound/ambience/loop/space.ogg'

/area/construction/solarscontrol
	name = "Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

//AI
/area/ai_monitored/security/armory
	name = "Armory"
	icon_state = "armory"

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/ai_monitored/storage/satellite
	name = "AI Satellite Maint"
	icon_state = "storage"


/area/turret_protected/
	ambientsounds = list('sound/ambience/ambimalf.ogg')
	ambloop = 'sound/ambience/loop/softhum.ogg'

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/aisat
	name = "AI Satellite Exterior"
	icon_state = "yellow"

/area/turret_protected/aisat_interior
	name = "AI Satellite Antechamber"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_IFSTARLIGHT
	ambloop = 'sound/ambience/loop/space.ogg'

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_IFSTARLIGHT
	ambloop = 'sound/ambience/loop/space.ogg'

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_IFSTARLIGHT
	ambloop = 'sound/ambience/loop/space.ogg'

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_IFSTARLIGHT
	ambloop = 'sound/ambience/loop/space.ogg'

/area/turret_protected/NewAIMain
	name = "AI Main New"
	icon_state = "storage"



//Misc



/area/wreck
	name = "\improper Spacewreck"
	icon_state = "centcom"
	has_gravity = 1
	ambientsounds = list('sound/ambience/ambieng1.ogg', 'sound/ambience/ambimine.ogg')
	// ambloop = 'sound/ambience/loop/softhum.ogg'

/area/wreck/living
	name = "\improper Prototype living area"
	icon_state = "ai"

/area/wreck/main
	name = "\improper Prototype Main Hall"
	icon_state = "storage"

/area/wreck/engineering
	name = "\improper Prototype Power Room"
	icon_state = "engine"

/area/wreck/bridge
	name = "\improper Prototype Bridge"
	icon_state = "bridge"

/area/wreck/botany
	name = "\improper Prototype Botany"
	icon_state = "hydro"

/area/wreck/solars
	name = "\improper Prototype Solars"
	icon_state = "engine"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	ambloop = 'sound/ambience/loop/hallow.ogg'

/area/generic
	name = "Unknown"
	icon_state = "storage"



// Telecommunications Satellite

/area/tcommsat
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')
	ambloop = 'sound/ambience/loop/drone02.ogg'

/area/tcommsat/entrance
	name = "Telecoms Teleporter"
	icon_state = "tcomsatentrance"

/area/tcommsat/chamber
	name = "Abandoned Satellite"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "Telecoms Satellite"
	icon_state = "tcomsatlob"
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomfoyer
	name = "Telecoms Foyer"
	icon_state = "tcomsatentrance"
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomwest
	name = "Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomeast
	name = "Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tcommsat/computer
	name = "Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/server
	name = "Telecoms Server Room"
	icon_state = "tcomsatcham"

/area/tcommsat/lounge
	name = "Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"



// Away Missions
/area/awaymission
	name = "Strange Location"
	icon_state = "away"
	has_gravity = 1

/area/awaymission/example
	name = "Strange Station"
	icon_state = "away"

/area/awaymission/desert
	name = "Mars"
	icon_state = "away"

/area/awaymission/listeningpost
	name = "Listening Post"
	icon_state = "away"
	requires_power = 0

/area/awaymission/beach
	name = "Beach"
	icon_state = "away"
	luminosity = 1
	lighting_use_dynamic = DYNAMIC_LIGHTING_DISABLED
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/shore.ogg'
	ambientsounds = list('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag2.ogg')

/area/spacecontent
	name = "space"

/area/spacecontent/a1
	icon_state = "spacecontent1"

/area/spacecontent/a2
	icon_state = "spacecontent2"

/area/spacecontent/a3
	icon_state = "spacecontent3"

/area/spacecontent/a4
	icon_state = "spacecontent4"

/area/spacecontent/a5
	icon_state = "spacecontent5"

/area/spacecontent/a6
	icon_state = "spacecontent6"

/area/spacecontent/a7
	icon_state = "spacecontent7"

/area/spacecontent/a8
	icon_state = "spacecontent8"

/area/spacecontent/a9
	icon_state = "spacecontent9"

/area/spacecontent/a10
	icon_state = "spacecontent10"

/area/spacecontent/a11
	icon_state = "spacecontent11"

/area/spacecontent/a11
	icon_state = "spacecontent12"

/area/spacecontent/a12
	icon_state = "spacecontent13"

/area/spacecontent/a13
	icon_state = "spacecontent14"

/area/spacecontent/a14
	icon_state = "spacecontent14"

/area/spacecontent/a15
	icon_state = "spacecontent15"

/area/spacecontent/a16
	icon_state = "spacecontent16"

/area/spacecontent/a17
	icon_state = "spacecontent17"

/area/spacecontent/a18
	icon_state = "spacecontent18"

/area/spacecontent/a19
	icon_state = "spacecontent19"

/area/spacecontent/a20
	icon_state = "spacecontent20"

/area/spacecontent/a21
	icon_state = "spacecontent21"

/area/spacecontent/a22
	icon_state = "spacecontent22"

/area/spacecontent/a23
	icon_state = "spacecontent23"

/area/spacecontent/a24
	icon_state = "spacecontent24"

/area/spacecontent/a25
	icon_state = "spacecontent25"

/area/spacecontent/a26
	icon_state = "spacecontent26"

/area/spacecontent/a27
	icon_state = "spacecontent27"

/area/spacecontent/a28
	icon_state = "spacecontent28"

/area/spacecontent/a29
	icon_state = "spacecontent29"

/area/spacecontent/a30
	icon_state = "spacecontent30"

/area/awaycontent
	name = "space"

/area/awaycontent/a1
	icon_state = "awaycontent1"

/area/awaycontent/a2
	icon_state = "awaycontent2"

/area/awaycontent/a3
	icon_state = "awaycontent3"

/area/awaycontent/a4
	icon_state = "awaycontent4"

/area/awaycontent/a5
	icon_state = "awaycontent5"

/area/awaycontent/a6
	icon_state = "awaycontent6"

/area/awaycontent/a7
	icon_state = "awaycontent7"

/area/awaycontent/a8
	icon_state = "awaycontent8"

/area/awaycontent/a9
	icon_state = "awaycontent9"

/area/awaycontent/a10
	icon_state = "awaycontent10"

/area/awaycontent/a11
	icon_state = "awaycontent11"

/area/awaycontent/a11
	icon_state = "awaycontent12"

/area/awaycontent/a12
	icon_state = "awaycontent13"

/area/awaycontent/a13
	icon_state = "awaycontent14"

/area/awaycontent/a14
	icon_state = "awaycontent14"

/area/awaycontent/a15
	icon_state = "awaycontent15"

/area/awaycontent/a16
	icon_state = "awaycontent16"

/area/awaycontent/a17
	icon_state = "awaycontent17"

/area/awaycontent/a18
	icon_state = "awaycontent18"

/area/awaycontent/a19
	icon_state = "awaycontent19"

/area/awaycontent/a20
	icon_state = "awaycontent20"

/area/awaycontent/a21
	icon_state = "awaycontent21"

/area/awaycontent/a22
	icon_state = "awaycontent22"

/area/awaycontent/a23
	icon_state = "awaycontent23"

/area/awaycontent/a24
	icon_state = "awaycontent24"

/area/awaycontent/a25
	icon_state = "awaycontent25"

/area/awaycontent/a26
	icon_state = "awaycontent26"

/area/awaycontent/a27
	icon_state = "awaycontent27"

/area/awaycontent/a28
	icon_state = "awaycontent28"

/area/awaycontent/a29
	icon_state = "awaycontent29"

/area/awaycontent/a30
	icon_state = "awaycontent30"

// Template Code
/area/template/Labshuttle
 	name = "LabShuttle"
 	icon_state = "hydro"

/area/template/Clown
	name = "Clownship"
	icon_state = "clown"
	has_gravity = 1
	ambloop = 'sound/ambience/loop/space.ogg'
	ambientsounds = list('sound/ambience/clown.ogg','sound/misc/slip.ogg','sound/items/bikehorn.ogg')

/area/template/OriginalClown
	name = "Clownship"
	icon_state = "clown"
	has_gravity = 1
	ambloop = 'sound/ambience/loop/space.ogg'
	ambientsounds = list('sound/ambience/clown.ogg','sound/misc/slip.ogg','sound/items/bikehorn.ogg')

/area/template/Mimeship
	name = "Broken Mimeship"
	icon_state = "mime"
	has_gravity = 1

/area/template/TempleGeometer
	name = "Temple of Unholy Geometer"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/terriblehum.ogg'
	ambientsounds = list('sound/spookoween/ghost_whisper.ogg','sound/spookoween/girlscream.ogg','sound/hallucinations/behind_you1.ogg','sound/hallucinations/behind_you2.ogg','sound/hallucinations/i_see_you1.ogg','sound/hallucinations/i_see_you2.ogg','sound/hallucinations/wail.ogg','sound/misc/scream_m1.ogg','sound/misc/scream_m2.ogg','sound/misc/scream_f1.ogg')

/area/template/syndicate_scout_ship
	name = "Syndicate scout ship"
	icon_state = "syndie-ship"
	requires_power = 0
	has_gravity = 1

/area/template/abandoned_abductor_ship
	name = "Abandoned Abductor Ship"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1
	ambloop = 'sound/ambience/loop/opressivehum.ogg'

//Gamma Vessel

/area/gammaderelict/bridge
	name = "Gamma Derelict Bridge"
	icon_state = "bridge"

/area/gammaderelict/captains
	name = "Gamma Derelict Captains Office"
	icon_state = "captain"

/area/gammaderelict/comms
	name = "Gamma Derelict Comms Relay"
	icon_state = "tcomsatcham"

/area/gammaderelict/command
	name = "Gamma Derelict Command Deck"
	icon_state = "meeting"

/area/gammaderelict/central
	name = "Gamma Derelict Central Hallway"
	icon_state = "hallC"

/area/gammaderelict/medical
	name = "Gamma Derelict Medbay"
	icon_state = "medresearch"

/area/gammaderelict/research
	name = "Gamma Derelict Research Center"
	icon_state = "medresearch"

/area/gammaderelict/aft
	name = "Gamma Derelict Aft Hallway"
	icon_state = "hallA"

/area/gammaderelict/engine
	name = "Gamma Derelict Engine Room"
	icon_state = "engine_smes"

/area/gammaderelict/engistorage
	name = "Gamma Derelict Engineering Storage"
	icon_state = "engine"

/area/gammaderelict/miscsci
	name = "Gamma Derelict Misc Science"
	icon_state = "medresearch"

/area/gammaderelict/grav
	name = "Gamma Derelict Gravity Generator"
	icon_state = "red"

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/atmos,
	/area/maintenance,
	/area/hallway,
	/area/bridge,
	/area/crew_quarters,
	/area/holodeck,
//	/area/mint,		//not present on map
	/area/library,
	/area/chapel,
	/area/lawoffice,
	/area/engine,
	/area/solar,
	/area/assembly,
	/area/teleporter,
	/area/medical,
	/area/security,
	/area/quartermaster,
	/area/janitor,
	/area/hydroponics,
	/area/toxins,
	/area/storage,
	/area/construction,
	/area/ai_monitored/storage/eva, //do not try to simplify to "/area/ai_monitored" --rastaf0
	/area/ai_monitored/security, // why wasn't armory in the list of ss13 areas
//	/area/ai_monitored/storage/secure,	//not present on map
//	/area/ai_monitored/storage/emergency,	//not present on map
	/area/turret_protected/ai_upload, //do not try to simplify to "/area/turret_protected" --rastaf0
	/area/turret_protected/ai_upload_foyer,
	/area/turret_protected/ai,
)