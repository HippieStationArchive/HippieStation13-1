//Due to how large this one is it gets its own file
/*
Chaplain
*/
/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/chaplain

	access = list(access_morgue, access_chapel_office, access_crematorium)
	minimal_access = list(access_morgue, access_chapel_office, access_crematorium)

/datum/outfit/job/chaplain
	name = "Chaplain"

	belt = /obj/item/device/pda/chaplain
	uniform = /obj/item/clothing/under/rank/chaplain

/datum/outfit/job/chaplain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/weapon/storage/book/bible/B = new /obj/item/weapon/storage/book/bible/booze(H)
	var/new_religion = "Christianity"
	if(H.client && H.client.prefs.custom_names["religion"])
		new_religion = H.client.prefs.custom_names["religion"]

	switch(lowertext(new_religion))
		if("christianity")
			B.name = pick("Holy Bible","Dead Sea Scrolls")
		if("satanism")
			B.name = "Unholy Bible"
		if("cthulu")
			B.name = "Necronomicon"
		if("islam")
			B.name = "Quran"
		if("scientology")
			B.name = pick("Biography of L. Ron Hubbard","Dianetics")
		if("chaos")
			B.name = "Book of Lorgar"
		if("imperium")
			B.name = "Uplifting Primer"
		if("toolboxia")
			B.name = "Toolbox Manifesto"
		if("homosexuality")
			B.name = "Guys Gone Wild"
		if("lol", "wtf", "gay", "penis", "ass", "poo", "badmin", "shitmin", "deadmin", "cock", "cocks")
			B.name = pick("Woodys Got Wood: The Aftermath", "War of the Cocks", "Sweet Bro and Hella Jef: Expanded Edition")
			H.setBrainLoss(100) // starts off retarded as fuck
		if("science")
			B.name = pick("Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", "Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", "How To: Build Your Own Warp Drive", "Mysteries of Bluespace", "Playing God: Collector's Edition")
		else
			B.name = "Holy Book of [new_religion]"
	feedback_set_details("religion_name","[new_religion]")

	var/new_deity = "Space Jesus"
	if(H.client && H.client.prefs.custom_names["deity"])
		new_deity = H.client.prefs.custom_names["deity"]
	deity_name = new_deity
	biblename = B.name
	H.equip_to_slot_or_del(B, slot_in_backpack)