//REAGENTS\\

datum/reagent/inspectionitis
	name = "Ass-X"
	id = "inspectionitis"
	description = "You'll have one hell of a pain in the ass with this."
	color = "#556B2F" // rgb: 85, 107, 47

datum/reagent/inspectionitis/reaction_mob(var/mob/living/carbon/M, var/method=TOUCH, var/volume)
	src = null
	if((prob(10) && method==TOUCH) || method==INGEST)
		var/datum/disease/D = new /datum/disease/assinspection(0)
		M.ContractDisease(D) //ASS BLAST USA. WOOP WOOP
	return

datum/reagent/inspectionitisplacebo
	name = "Ass-X"
	id = "inspectionitisplacebo"
	description = "You'll have one hell of a pain in the ass with this."
	color = "#808000" // rgb: 128, 128, 0

datum/reagent/inspectionitisplacebo/reaction_mob(var/mob/living/carbon/M, var/method=TOUCH, var/volume)
	src = null
	if((prob(10) && method==TOUCH) || method==INGEST)
		var/datum/disease/D = new /datum/disease/assinspectionplacebo(0)
		M.ContractDisease(D) //ASS BLAST USA. WOOP WOOP
	return

//PILLS\\

/obj/item/weapon/reagent_containers/pill/assX
	name = "Ass-X pill"
	desc = "The ultimate assblast pill."
	icon_state = "pill15"

/obj/item/weapon/reagent_containers/pill/assX/New()
	..()
	reagents.add_reagent("inspectionitis", 10)

/obj/item/weapon/reagent_containers/pill/assXplacebo
	name = "Ass-X pill"
	desc = "The ultimate assblast pill."
	icon_state = "pill15"

/obj/item/weapon/reagent_containers/pill/assXplacebo/New()
	..()
	reagents.add_reagent("inspectionitisplacebo", 10)