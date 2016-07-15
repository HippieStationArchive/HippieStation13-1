////////////////////////////////////////
//////////////////Pod///////////////////
////////////////////////////////////////

/datum/design/pod_fore_port
	name = "Pod Frame Fore Port"
	desc = "The fore port of a pod, used for assembling a pod"
	id = "pod_fore_port"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/pod_frame/fore_port
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_fore_starboard
	name = "Pod Frame Fore Starboard"
	desc = "The fore-starboard port of a pod, used for assembling a pod"
	id = "pod_fore_starboard"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/pod_frame/fore_starboard
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_aft_port
	name = "Pod Aft Port"
	desc = "The aft port of a pod, used for assembling a pod"
	id = "pod_aft_port"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/pod_frame/fore_port
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_aft_starboard
	name = "Pod Frame Aft Starboard"
	desc = "The aft-starboard port of a pod, used for assembling a pod"
	id = "pod_aft_starboard"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/pod_frame/fore_starboard
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_aft_starboard
	name = "Pod Frame Aft Starboard"
	desc = "The aft-starboard port of a pod, used for assembling a pod"
	id = "pod_aft_starboard"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/pod_frame/fore_starboard
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_civ_armor
	name = "Civilian Pod Armor"
	desc = "Standard NT Civilian pod armor, commonly joked as being made of plastic."
	id = "pod_civ_armor"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 1200, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/armor/civilian
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_core
	name = "Pod Core"
	desc = "The core of a pod, used in the assembly of a pod"
	id = "pod_core"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 3000, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/core
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_main_board
	name = "Pod Main Board"
	desc = "The main board of a pod, due to it's design the traces are printed on rather than etched"
	id = "pod_main_board"
	req_tech = list("materials" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_METAL = 100, MAT_GLASS = 200)
	construction_time=100
	build_path = /obj/item/weapon/circuitboard/mecha/pod
	category = list("Pod Equipment","Machinery","initial")

/datum/design/pod_tasers
	name = "Pod-Mounted Tasers"
	desc = "Pod-mounted tasers, shoots two projectiles."
	id = "pod_aft_starboard"
	req_tech = list("materials" = 2, "combat" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 300)
	construction_time=100
	build_path = /obj/item/pod_parts/pod_frame/fore_starboard
	category = list("Pod Equipment","Weapons")