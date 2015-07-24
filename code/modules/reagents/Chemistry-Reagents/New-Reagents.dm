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

datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "The reason why you can't get enough of these cigs."
	color = "#CD853F" // rgb: 205,133,63
	addiction_rate = 0.05 //5 units of nicotine go away in 100 ticks, which is 200 seconds.

datum/reagent/nicotine/on_mob_life(var/mob/living/M as mob)
	var/mob/living/carbon/human/H = M
	var/obj/item/clothing/mask/cigarette/cig = H.wear_mask
	H.addicted_to.add_reagent("nicotine", 0.2) //Slowly add addiction
	var/datum/reagent/R = H.addicted_to.has_reagent("nicotine")
	if(R)
		R.data = R.data-- //Slowly reduce addiction stage to prevent toxins as soon as you stop smoking when addicted.
		if(R.data < 0)
			R.data = 0
	if(prob(5))
		var/msg = ""
		if(cig)
			msg = pick("You feel relaxed.", "You feel a warm smoke in your lungs.")
		else
			msg = pick("You feel relaxed.", "It feels as if you smoked recently.")
		M << "<span class='notice'>[msg]</span>"
	..()
	return

datum/reagent/nicotine/on_mob_addicted(var/mob/living/M as mob)
	var/mob/living/carbon/human/H = M
	//Restructured the IF check - possibly fixed the runtime error.
	if(istype(H)) //Addiction slowly builds up. We don't call ..() because we don't want to remove it yet.
		var/obj/item/clothing/mask/cigarette/cig = H.wear_mask
		if(H.reagents.has_reagent("nicotine") || (istype(cig) && cig && cig.lit))
			..() //We call parent to remove reagents from bloodstream so medical use cigs are possible.
			return //Notice how we don't decrease data in here - that's because seasoned smokers have worse side effects. Stop smoking before it's required to live, dog.

	//No nicotine in blood stream? Good. Continue with the data.
	if(!data) data = 1
	switch(data)
		if(1 to 15)
			if(prob(2))
				M.emote("cough")
		if(15 to 30)
			if(prob(4))
				M.emote("cough")
			if(prob(7))
				var/msg = pick("You feel pretty bad.", "You have an urge to smoke.", "You have a headache.")
				M << "<span class='notice'>[msg]</span>"
		if(30 to 60)
			if(prob(8))
				M.emote("cough")
				M.adjustToxLoss(1) //Not feeling so well now are you?
			if(prob(7))
				var/msg = pick("You feel pretty bad.", "You REALLY need a smoke right now.", "You're dying for a smoke.", "You have a headache.", "You feel nauseous.")
				M << "<span class='notice'>[msg]</span>"
		if(60 to INFINITY)
			if(prob(10))
				M.emote("cough") //massive coughing feats
				M.adjustToxLoss(2) //Toxins intensify
			if(prob(7))
				var/msg = pick("You feel nauseous.", "You feel intoxicated.", "Goddamn, you feel terrible!", "You feel like you smoked too much to give up now.")
				M << "<span class='warning'>[msg]</span>"
			if(prob(2))
				M.visible_message("<span class='danger'>[src] clutches his chest!</span>")
				M.Stun(rand(2,5))
				M.apply_damage(rand(2,4), BRUTE, "chest")
				if(prob(5))
					M.emote("scream")

	data++
	..()
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