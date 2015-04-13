//THIS IS SUPER WIP
/*
Boxer
*/
/datum/job/gimmick/boxer
	title = "Boxer"
	//flag = BOXER //No defined flag
	// department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "absolutely NOBODY"
	selection_color = "#dddddd"
	access = list()
	minimal_access = list()

/datum/job/gimmick/boxer/equip_items(var/mob/living/carbon/human/H)
	// H.fully_replace_character_name(H.real_name, pick(clown_names))

	H.equip_to_slot_or_del(new /obj/item/clothing/under/shorts(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/red(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/medical/bruise_pack(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/boxing(H), slot_gloves)

	H.rename_self("boxer")

/*
Wrassler - Similar to boxer, although he gets wrassling by default
*/
/datum/job/gimmick/wrestler
	title = "Wrestler"
	//flag = BOXER //No defined flag
	// department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "absolutely NOBODY"
	selection_color = "#dddddd"
	access = list()
	minimal_access = list()

/datum/job/gimmick/wrestler/equip_items(var/mob/living/carbon/human/H)
	// H.fully_replace_character_name(H.real_name, pick(clown_names))

	H.equip_to_slot_or_del(new /obj/item/clothing/under/shorts(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/red(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/medical/bruise_pack(H), slot_l_store)
	var/mask = pick(new /obj/item/clothing/mask/luchador/tecnicos(H), new /obj/item/clothing/mask/luchador/rudos(H))
	H.equip_to_slot_or_del(mask, slot_wear_mask)

	H.rename_self("wrestler")

/*
Test jobs
*/
/datum/job/gimmick/test1
	title = "TEST 1 GIMMICK JOB"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

/datum/job/gimmick/test1/equip_items(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(H), slot_w_uniform)

/datum/job/gimmick/test2
	title = "TEST 2 GIMMICK JOB"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

/datum/job/gimmick/test2/equip_items(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/blue(H), slot_w_uniform)

/datum/job/gimmick/test3
	title = "TEST 3 GIMMICK JOB"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

/datum/job/gimmick/test3/equip_items(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/red(H), slot_w_uniform)