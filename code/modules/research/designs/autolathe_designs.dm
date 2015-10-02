///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////
//TODO: SPLIT THIS FILE INTO GODDAMN CATEGORIES JESUS FUCK

/datum/design/bucket
	name = "Bucket"
	id = "bucket"
	build_type = AUTOLATHE
	materials = list("$metal" = 200)
	build_path = /obj/item/weapon/reagent_containers/glass/bucket
	category = list("initial","Tools")

/datum/design/crowbar
	name = "Pocket crowbar"
	id = "crowbar"
	build_type = AUTOLATHE
	materials = list("$metal" = 50)
	build_path = /obj/item/weapon/crowbar
	category = list("initial","Tools")

/datum/design/flashlight
	name = "Flashlight"
	id = "flashlight"
	build_type = AUTOLATHE
	materials = list("$metal" = 50, "$glass" = 20)
	build_path = /obj/item/device/flashlight
	category = list("initial","Tools")

/datum/design/extinguisher
	name = "Fire extinguisher"
	id = "extinguisher"
	build_type = AUTOLATHE
	materials = list("$metal" = 90)
	build_path = /obj/item/weapon/extinguisher
	category = list("initial","Tools")

/datum/design/multitool
	name = "Multitool"
	id = "multitool"
	build_type = AUTOLATHE
	materials = list("$metal" = 50, "$glass" = 20)
	build_path = /obj/item/device/multitool
	category = list("initial","Tools")

/datum/design/analyzer
	name = "Analyzer"
	id = "analyzer"
	build_type = AUTOLATHE
	materials = list("$metal" = 30, "$glass" = 20)
	build_path = /obj/item/device/analyzer
	category = list("initial","Tools")

/datum/design/tscanner
	name = "T-ray scanner"
	id = "tscanner"
	build_type = AUTOLATHE
	materials = list("$metal" = 150)
	build_path = /obj/item/device/t_scanner
	category = list("initial","Tools")

/datum/design/weldingtool
	name = "Welding tool"
	id = "welding_tool"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 20)
	build_path = /obj/item/weapon/weldingtool
	category = list("initial","Tools")

/datum/design/screwdriver
	name = "Screwdriver"
	id = "screwdriver"
	build_type = AUTOLATHE
	materials = list("$metal" = 75)
	build_path = /obj/item/weapon/screwdriver
	category = list("initial","Tools")

/datum/design/wirecutters
	name = "Wirecutters"
	id = "wirecutters"
	build_type = AUTOLATHE
	materials = list("$metal" = 80)
	build_path = /obj/item/weapon/wirecutters
	category = list("initial","Tools")

/datum/design/wrench
	name = "Wrench"
	id = "wrench"
	build_type = AUTOLATHE
	materials = list("$metal" = 150)
	build_path = /obj/item/weapon/wrench
	category = list("initial","Tools")

/datum/design/welding_helmet
	name = "Welding helmet"
	id = "welding_helmet"
	build_type = AUTOLATHE
	materials = list("$metal" = 1750, "$glass" = 400)
	build_path = /obj/item/clothing/head/welding
	category = list("initial","Tools")

/datum/design/console_screen
	name = "Console screen"
	id = "console_screen"
	build_type = AUTOLATHE
	materials = list("$glass" = 200)
	build_path = /obj/item/weapon/stock_parts/console_screen
	category = list("initial", "Electronics")

/datum/design/airlock_board
	name = "Airlock electronics"
	id = "airlock_board"
	build_type = AUTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/airlock_electronics
	category = list("initial", "Electronics")

/datum/design/airalarm_electronics
	name = "Air alarm electronics"
	id = "airalarm_electronics"
	build_type = AUTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/airalarm_electronics
	category = list("initial", "Electronics")

/datum/design/firealarm_electronics
	name = "Fire alarm electronics"
	id = "firealarm_electronics"
	build_type = AUTOLATHE
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/firealarm_electronics
	category = list("initial", "Electronics")

/datum/design/pipe_painter
	name = "Pipe painter"
	id = "pipe_painter"
	build_type = AUTOLATHE
	materials = list("$metal" = 5000, "$glass" = 2000)
	build_path = /obj/item/device/pipe_painter
	category = list("initial", "Misc")

/datum/design/metal
	name = "Metal"
	id = "metal"
	build_type = AUTOLATHE
	materials = list("$metal" = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/metal
	category = list("initial","Construction")

/datum/design/glass
	name = "Glass"
	id = "glass"
	build_type = AUTOLATHE
	materials = list("$glass" = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/glass
	category = list("initial","Construction")

/datum/design/rglass
	name = "Reinforced glass"
	id = "rglass"
	build_type = AUTOLATHE
	materials = list("$metal" = 1000, "$glass" = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/rglass
	category = list("initial","Construction")

/datum/design/rods
	name = "Metal rod"
	id = "rods"
	build_type = AUTOLATHE
	materials = list("$metal" = 1000)
	build_path = /obj/item/stack/rods
	category = list("initial","Construction")

/datum/design/rcd_ammo
	name = "Compressed matter cardridge"
	id = "rcd_ammo"
	build_type = AUTOLATHE
	materials = list("$metal" = 16000, "$glass"=8000)
	build_path = /obj/item/weapon/rcd_ammo
	category = list("initial","Construction")

/datum/design/kitchen_knife
	name = "Kitchen knife"
	id = "kitchen_knife"
	build_type = AUTOLATHE
	materials = list("$metal" = 12000)
	build_path = /obj/item/weapon/kitchenknife
	category = list("initial","Misc")

/datum/design/scalpel
	name = "Scalpel"
	id = "scalpel"
	build_type = AUTOLATHE
	materials = list("$metal" = 4000, "$glass" = 1000)
	build_path = /obj/item/weapon/scalpel
	category = list("initial", "Medical")

/datum/design/circular_saw
	name = "Circular saw"
	id = "circular_saw"
	build_type = AUTOLATHE
	materials = list("$metal" = 10000, "$glass" = 6000)
	build_path = /obj/item/weapon/circular_saw
	category = list("initial", "Medical")

/datum/design/surgicaldrill
	name = "Surgical drill"
	id = "surgicaldrill"
	build_type = AUTOLATHE
	materials = list("$metal" = 10000, "$glass" = 6000)
	build_path = /obj/item/weapon/surgicaldrill
	category = list("initial", "Medical")

/datum/design/retractor
	name = "Retractor"
	id = "retractor"
	build_type = AUTOLATHE
	materials = list("$metal" = 6000, "$glass" = 3000)
	build_path = /obj/item/weapon/retractor
	category = list("initial", "Medical")

/datum/design/cautery
	name = "Cautery"
	id = "cautery"
	build_type = AUTOLATHE
	materials = list("$metal" = 2500, "$glass" = 750)
	build_path = /obj/item/weapon/cautery
	category = list("initial", "Medical")

/datum/design/hemostat
	name = "Hemostat"
	id = "hemostat"
	build_type = AUTOLATHE
	materials = list("$metal" = 5000, "$glass" = 2500)
	build_path = /obj/item/weapon/hemostat
	category = list("initial", "Medical")

/datum/design/beaker
	name = "Beaker"
	id = "beaker"
	build_type = AUTOLATHE
	materials = list("$glass" = 500)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker
	category = list("initial", "Medical")

/datum/design/large_beaker
	name = "Large beaker"
	id = "large_beaker"
	build_type = AUTOLATHE
	materials = list("$glass" = 2500)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/large
	category = list("initial", "Medical")

/datum/design/beanbag_slug
	name = "Beanbag slug"
	id = "beanbag_slug"
	build_type = AUTOLATHE
	materials = list("$metal" = 250)
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	category = list("initial", "Security")

/datum/design/c38
	name = "Speed loader (.38)"
	id = "c38"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000)
	build_path = /obj/item/ammo_box/c38
	category = list("initial", "Security")

/datum/design/recorder
	name = "Universal recorder"
	id = "recorder"
	build_type = AUTOLATHE
	materials = list("$metal" = 60, "$glass" = 30)
	build_path = /obj/item/device/taperecorder/empty
	category = list("initial", "Misc")

/datum/design/tape
	name = "Tape"
	id = "tape"
	build_type = AUTOLATHE
	materials = list("$metal" = 20, "$glass" = 5)
	build_path = /obj/item/device/tape
	category = list("initial", "Misc")

/datum/design/igniter
	name = "Igniter"
	id = "igniter"
	build_type = AUTOLATHE
	materials = list("$metal" = 500, "$glass" = 50)
	build_path = /obj/item/device/assembly/igniter
	category = list("initial", "Misc")

/datum/design/signaler
	name = "Remote signaling device"
	id = "signaler"
	build_type = AUTOLATHE
	materials = list("$metal" = 400, "$glass" = 120)
	build_path = /obj/item/device/assembly/signaler
	category = list("initial", "T-Comm")

/datum/design/radio_headset
	name = "Radio headset"
	id = "radio_headset"
	build_type = AUTOLATHE
	materials = list("$metal" = 75)
	build_path = /obj/item/device/radio/headset
	category = list("initial", "T-Comm")

/datum/design/bounced_radio
	name = "Station bounced radio"
	id = "bounced_radio"
	build_type = AUTOLATHE
	materials = list("$metal" = 75, "$glass" = 25)
	build_path = /obj/item/device/radio/off
	category = list("initial", "T-Comm")

/datum/design/infrared_emitter
	name = "Infrared emitter"
	id = "infrared_emitter"
	build_type = AUTOLATHE
	materials = list("$metal" = 1000, "$glass" = 500)
	build_path = /obj/item/device/assembly/infra
	category = list("initial", "Misc")

/datum/design/timer
	name = "Timer"
	id = "timer"
	build_type = AUTOLATHE
	materials = list("$metal" = 500, "$glass" = 50)
	build_path = /obj/item/device/assembly/timer
	category = list("initial", "Misc")

/datum/design/voice_analyser
	name = "Voice analyser"
	id = "voice_analyser"
	build_type = AUTOLATHE
	materials = list("$metal" = 500, "$glass" = 50)
	build_path = /obj/item/device/assembly/voice
	category = list("initial", "Misc")

/datum/design/light_tube
	name = "Light tube"
	id = "light_tube"
	build_type = AUTOLATHE
	materials = list("$metal" = 60, "$glass" = 100)
	build_path = /obj/item/weapon/light/tube
	category = list("initial", "Construction")

/datum/design/light_bulb
	name = "Light bulb"
	id = "light_bulb"
	build_type = AUTOLATHE
	materials = list("$metal" = 60, "$glass" = 100)
	build_path = /obj/item/weapon/light/bulb
	category = list("initial", "Construction")

/datum/design/camera_assembly
	name = "Camera assembly"
	id = "camera_assembly"
	build_type = AUTOLATHE
	materials = list("$metal" = 400, "$glass" = 250)
	build_path = /obj/item/weapon/camera_assembly
	category = list("initial", "Construction")

/datum/design/newscaster_frame
	name = "Newscaster frame"
	id = "newscaster_frame"
	build_type = AUTOLATHE
	materials = list("$metal" = 14000, "$glass" = 8000)
	build_path = /obj/item/newscaster_frame
	category = list("initial", "Construction")

/datum/design/syringe
	name = "Syringe"
	id = "syringe"
	build_type = AUTOLATHE
	materials = list("$metal" = 10, "$glass" = 20)
	build_path = /obj/item/weapon/reagent_containers/syringe
	category = list("initial", "Medical")

/datum/design/prox_sensor
	name = "Proximity sensor"
	id = "prox_sensor"
	build_type = AUTOLATHE
	materials = list("$metal" = 800, "$glass" = 200)
	build_path = /obj/item/device/assembly/prox_sensor
	category = list("initial", "Misc")

//hacked autolathe recipes
/datum/design/flamethrower
	name = "Flamethrower"
	id = "flamethrower"
	build_type = AUTOLATHE
	materials = list("$metal" = 500)
	build_path = /obj/item/weapon/flamethrower/full
	category = list("hacked", "Weapons and ammo")

/datum/design/rcd
	name = "Rapid construction device (RCD)"
	id = "rcd"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000)
	build_path = /obj/item/weapon/rcd
	category = list("hacked", "Construction")

/datum/design/rpd
	name = "Rapid pipe dispenser (RPD)"
	id = "rpd"
	build_type = AUTOLATHE
	materials = list("$metal" = 75000, "$glass" = 37500)
	build_path = /obj/item/weapon/pipe_dispenser
	category = list("hacked", "Construction")

/datum/design/electropack
	name = "Electropack"
	id = "electropack"
	build_type = AUTOLATHE
	materials = list("$metal" = 10000, "$glass" = 2500)
	build_path = /obj/item/device/electropack
	category = list("hacked", "Tools")

/datum/design/large_welding_tool
	name = "Industrial welding tool"
	id = "large_welding_tool"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/weapon/weldingtool/largetank
	category = list("hacked", "Tools")

/datum/design/handcuffs
	name = "Handcuffs"
	id = "handcuffs"
	build_type = AUTOLATHE
	materials = list("$metal" = 500)
	build_path = /obj/item/weapon/handcuffs
	category = list("hacked", "Security")

/datum/design/shotgun_slug
	name = "Shotgun slug"
	id = "shotgun_slug"
	build_type = AUTOLATHE
	materials = list("$metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun
	category = list("hacked", "Security")

/datum/design/l85
	name = "L85A2 Frame"
	id = "l85"
	build_type = AUTOLATHE
	materials = list("$metal" = 25000)
	build_path = /obj/item/weapon/l85frame
	category = list("hacked", "Weapons and ammo")

/datum/design/buttlaunch
	name = "Butt Launcher frame"
	id = "l85"
	build_type = AUTOLATHE
	materials = list("$metal" = 5000)
	build_path = /obj/item/weapon/buttlaunch1
	category = list("hacked", "Weapons and ammo")

/datum/design/l85s
	name = "L85A2 Stamina ammunition"
	id = "l85sa"
	build_type = AUTOLATHE
	materials = list("$metal" = 700)
	build_path = /obj/item/ammo_box/magazine/l85/s
	category = list("hacked", "Weapons and ammo")

/datum/design/buckshot_shell
	name = "Buckshot shell"
	id = "buckshot_shell"
	build_type = AUTOLATHE
	materials = list("$metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun/buckshot
	category = list("hacked", "Security")

/datum/design/shotgun_dart
	name = "Shotgun dart"
	id = "shotgun_dart"
	build_type = AUTOLATHE
	materials = list("$metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun/dart
	category = list("hacked", "Security")

/datum/design/incendiary_slug
	name = "Incendiary slug"
	id = "incendiary_slug"
	build_type = AUTOLATHE
	materials = list("$metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun/incendiary
	category = list("hacked", "Security")

/datum/design/a357
	name = "Ammo box (.357)"
	id = "a357"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000)
	build_path = /obj/item/ammo_box/a357
	category = list("hacked", "Security")

/datum/design/c10mm
	name = "Ammo box (10mm)"
	id = "c10mm"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000)
	build_path = /obj/item/ammo_box/c10mm
	category = list("hacked", "Security")

/datum/design/c45
	name = "Ammo box (.45)"
	id = "c45"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000)
	build_path = /obj/item/ammo_box/c45
	category = list("hacked", "Security")

/datum/design/c9mm
	name = "Ammo box (9mm)"
	id = "c9mm"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000)
	build_path = /obj/item/ammo_box/c9mm
	category = list("hacked", "Security")

//NEW DESIGNS
/datum/design/baseballbat
	name = "Metal Baseball Bat"
	id = "baseballbat"
	build_type = AUTOLATHE
	materials = list("$metal" = 30000) //Rather costly, since it's a pretty great weapon.
	build_path = /obj/item/weapon/baseballbat/metal
	category = list("hacked", "Misc")

/datum/design/ducttape
	name = "Duct tape"
	id = "ducttape"
	build_type = AUTOLATHE
	materials = list("$metal" = 100)
	build_path = /obj/item/stack/ducttape
	category = list("initial","Tools")

//Let botany produce baseballs, makes more sense
// /datum/design/baseball
// 	name = "Baseball Ball"
// 	id = "baseball"
// 	build_type = AUTOLATHE
// 	materials = list("$metal" = 100) //Relatively cheap
// 	build_path = /obj/item/baseball
// 	category = list("initial", "Misc")

//SPRAYCANS!!!  //They are back baby!  ~Nexendia

/datum/design/spraycan
	name = "Spray Can"
	id = "spraycan"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan
	category = list("initial", "Tools")

/*
/datum/design/spraycanred
	name = "Red Spraycan"
	id = "spraycanred"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/red
	category = list("initial", "Tools")

/datum/design/spraycanorange
	name = "Orange Spraycan"
	id = "spraycanorange"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/orange
	category = list("initial", "Tools")

/datum/design/spraycanyellow
	name = "Yellow Spraycan"
	id = "spraycanyellow"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/yellow
	category = list("initial", "Tools")

/datum/design/spraycangreen
	name = "Green Spraycan"
	id = "spraycangreen"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/green
	category = list("initial", "Tools")

/datum/design/spraycanblue
	name = "Blue Spraycan"
	id = "spraycanblue"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/blue
	category = list("initial", "Tools")

/datum/design/spraycanblue
	name = "Purple Spraycan"
	id = "spraycanpurple"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/purple
	category = list("initial", "Tools")

/datum/design/spraycanwhite
	name = "White Spraycan"
	id = "spraycanwhite"
	build_type = AUTOLATHE
	materials = list("$metal" = 70, "$glass" = 60)
	build_path = /obj/item/toy/crayon/spraycan/white
	category = list("initial", "Tools")

*/
