var/global/deity_name = "Christ"
var/global/chosenicon
var/global/biblename

/obj/item/weapon/storage/book
	name = "hollowed book"
	desc = "I guess someone didn't like it."
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 2
	throw_range = 5
	w_class = 3
	burn_state = 0 //Burnable
	var/title = "book"

/obj/item/weapon/storage/book/attack_self(mob/user)
		user << "<span class='notice'>The pages of [title] have been cut out!</span>"

/obj/item/weapon/storage/book/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon = 'icons/obj/storage.dmi'
	icon_state ="bible"
	var/heal_amt = 10
	var/static/obj/item/relic/relic
	var/relicmode = FALSE // will be turned to TRUE when chaplain wants to choose a relic.
	var/list/bibletypes = list("bible", "koran", "scrapbook",\
								"burning bible", "clown bible",\
								"creeper bible",\
								"white bible", "holy light",\
								"god delusion", "tome", "king in yellow",\
								"ithaqua", "scientology", "melted bible",\
								"necronomicon")//List with name(which is the same of the icon state), associated to the item state(some are just the same,that is why)

/obj/item/weapon/storage/book/bible/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is offering \himself to [deity_name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/weapon/storage/book/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

/obj/item/weapon/storage/book/bible/booze/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/beer(src)
	new /obj/item/weapon/reagent_containers/food/drinks/beer(src)
	new /obj/item/stack/spacecash(src)
	new /obj/item/stack/spacecash(src)
	new /obj/item/stack/spacecash(src)

/obj/item/weapon/storage/book/bible/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.job == "Chaplain")
		if(!chosenicon)
		//Open bible selection
			var/dat = "<html><head><title>Pick Bible Style</title></head><body><center><h2>Pick a bible style</h2></center><table>"
			for(var/i in 1 to bibletypes.len)
				var/icon/bibleicon = icon('icons/obj/storage.dmi', bibletypes[i])

				var/nicename = capitalize(bibletypes[i])
				H << browse_rsc(bibleicon, bibletypes[i])
				dat += {"<tr><td><img src="[bibletypes[i]]"></td><td><a href="?src=\ref[src];seticon=[i]">[nicename]</a></td></tr>"}

			dat += "</table></body></html>"

			H << browse(dat, "window=editicon;can_close=0;can_minimize=0;size=250x650")
		else
			ui_interact(H)

/obj/item/weapon/storage/book/bible/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	ui = SSnano.push_open_or_new_ui(user, src, ui_key, ui, "bible.tmpl", name, 600, 270, 1)

/obj/item/weapon/storage/book/bible/get_ui_data(mob/user)
	var/list/data = list()
	data["biblename"] = name
	data["god"] = deity_name
	data["relic"] = relic
	if(relic)
		var/area/A = get_area(relic)
		var/aname = A.name
		data["x"] = relic.x
		data["y"] = relic.y
		data["z"] = relic.z
		data["area"] = aname
	return data

/obj/item/weapon/storage/book/bible/proc/setupbiblespecifics(obj/item/weapon/storage/book/bible/B, mob/living/carbon/human/H)
	if(!istype(H))
		return
	switch(B.icon_state)
		if("clown bible")
			new /obj/item/weapon/bikehorn(B)
			new /obj/item/weapon/grown/bananapeel(B, 70)
			new /obj/item/weapon/grown/bananapeel(B, 70)
			H.equip_or_drop(new /obj/item/clothing/mask/gas/clown_hat(H))

/obj/item/weapon/storage/book/bible/Topic(href, href_list)
	if(href_list["seticon"])
		if(chosenicon)
			return //possibly a href exploit
		var/iconi = round(text2num(href_list["seticon"]))
		if(iconi > bibletypes.len || iconi <= 0)
			return
		var/mob/living/carbon/human/H = usr // safe to assume since attack_self calls this and has an human as arg

		icon_state = bibletypes[iconi]

		//Set biblespecific chapels
		setupbiblespecifics(src, H)
		H.update_inv_l_hand()
		H.update_inv_r_hand()//so the item_state gets updated too

		chosenicon = bibletypes[iconi]

		usr << browse(null, "window=editicon") // Close window
	if(href_list["effect"])
		if(!relic)//can have only one relic at time
			if(!relicmode)
				visible_message("<span class='notice'>\The [src] glows with a fiery light!</span>")
				usr << "<span class='notice'>\The [src] glows with a fiery light!</span>"
				relicmode = TRUE
			else
				visible_message("<span class='notice'>\The [src] glows dull...</span>")
				usr << "<span class='notice'>\The [src] glows dull...</span>"
				relicmode = FALSE
		else
			visible_message("<span class='notice'>\The [src] emits some smoke and glows dull...</span>")
			usr << "<span class='notice'>\The [src] emits some smoke and glows dull...</span>"
		return
	if(href_list["addprayer"])//this is what activates the relic effect. Just say the phrase near its hear range to activate it.
		if(!relic)
			visible_message("<span class='notice'>\The [src] emits some smoke and glows dull...</span>")
			usr << "<span class='notice'>\The [src] emits some smoke and glows dull...</span>"
		else
			var/prayer = stripped_input(usr, "What would you like your prayer to be?", "Add Prayer", max_length=100)
			if(!prayer)
				return
			relic.prayer = prayer

/obj/item/weapon/storage/book/bible/proc/bless(mob/living/carbon/M)
	. = FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/limb/affecting in H.organs)
			if(affecting.heal_damage(heal_amt, heal_amt, heal_amt/10))
				H.update_damage_overlays(0)
				. = TRUE

/obj/item/weapon/storage/book/bible/attack(mob/living/M, mob/living/carbon/human/user)
	if (!user.IsAdvancedToolUser())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return
	if(user.mind && (user.mind.assigned_role != "Chaplain"))
		user << "<span class='danger'>The book sizzles in your hands.</span>"
		user.take_organ_damage(0,10)
		return

	if (user.disabilities & CLUMSY && prob(50))
		user << "<span class='danger'>The [src] slips out of your hand and hits your head.</span>"//how the fuck can that happen?iunno
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(M.stat != DEAD)
		if(M.mind && (M.mind.assigned_role == "Chaplain"))
			user << "<span class='warning'>You can't heal yourself!</span>"
			return
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(prob(60))
				if(bless(M))
					M.visible_message("<span class='notice'>[user] heals [M] with the power of [deity_name]!</span>")
					M << "<span class='boldnotice'>May the power of [deity_name] compel you to be healed!</span>"
					playsound(src.loc, "punch", 25, 1, -1)

			else
				if(!istype(H.head, /obj/item/clothing/head/helmet))
					M.adjustBrainLoss(10)
					M << "<span class='danger'>You feel dumber.</span>"
				M.visible_message("<span class='danger'>[user] beats [M] over the head with [src]!</span>", \
						"<span class='userdanger'>[user] beats [M] over the head with [src]!</span>")
				playsound(loc, "punch", 25, 1, -1)
				add_logs(user, M, "bibled", src)

	else
		M.visible_message("<span class='danger'>[user] smacks [M]'s lifeless corpse with [src].</span>")
		playsound(loc, "punch", 25, 1, -1)

/obj/item/weapon/storage/book/bible/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(!relicmode)
			if (istype(A, /turf/simulated/floor))
				user << "<span class='notice'>You hit the floor with the bible.</span>"
				for(var/obj/effect/rune/R in orange(2,user))
					R.invisibility = 0
					R.alpha = initial(R.alpha)
			if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
				user << "<span class='notice'>You bless [A].</span>"
				var/water2holy = A.reagents.get_reagent_amount("water")
				A.reagents.del_reagent("water")
				A.reagents.add_reagent("holywater",water2holy)
			if(A.reagents && A.reagents.has_reagent("unholywater")) //yeah yeah, copy pasted code - sue me
				user << "<span class='notice'>You purify [A].</span>"
				var/unholy2clean = A.reagents.get_reagent_amount("unholywater")
				A.reagents.del_reagent("unholywater")
				A.reagents.add_reagent("holywater",unholy2clean)
		else // choose your relic
			if(istype(A, /obj/item))
				new /obj/item/relic(get_turf(src), A, src)
				PoolOrNew(/obj/effect/particle_effect/sparks, get_turf(src))
				playsound(get_turf(src), "sparks", 50, 1)
				user << "<span class='notice'>You pray towards \the [A] and, after a moment, a relic appears under you!</span>"
				relicmode = FALSE
			else
				user << "<span class='danger'>Your holy relic must be an item!</span>"

/obj/item/weapon/storage/book/bible/attackby(obj/item/weapon/W, mob/user, params)
	playsound(loc, "rustle", 50, 1, -5)
	..()

//Relic code. Chaplains can choose a relic(Only one can exist per time,but all bibles share it),
//by clicking "Assign Holy Relic" and then hitting something with their bible. A new item will
//spawn on the bible turf, which will share the item's name and icon, and only this, but it'll earn relic effects.

//This is the basic relic item. This will spawn first, then on its new proc an effect will be picked at random, and this will be changed with the relic type.
/obj/item/relic
	name = "You shouldn't see this!"
	icon_state = "gooncode" // you shouldn't see this either!
	desc = "It glows in a faint light. Seems a religious relic."
	w_class = 2 // you can put it in butts!Woo
	flags = HEAR
	languages = HUMAN
	var/obj/item/weapon/storage/book/bible/linkedbible
	var/obj/item/relic/chosenrelic // will be set to the relic chosen in New()
	var/prayer = "" //this is the prayer that activates the relic effect,you can set it from the bible
	var/range = 7 // normal view range,I don't know if a define for this number exists already,if it does change it and sorry.
	var/times_used = 0 // the more it gets used, the higher the change to break, the lower the effect will be for certain relics.
	var/list/affectedmobs = list()

/obj/item/relic/New(location, obj/item/I, obj/item/weapon/storage/book/bible/B) // I will be the object chaplain hit with the bible.
	..()
	if(type == /obj/item/relic)//we avoid using istype because we want a strict check of the type,we don't want childs to be included
		if(!I)
			qdel(src)//should never happen under normal conditions
			return
		var/effectpath = pick(typesof(/obj/item/relic) - /obj/item/relic - /obj/item/relic/healing - /obj/item/relic/itemspawner)
		chosenrelic = new effectpath(get_turf(src), B = B)
		var/list/nameprefixes = list(
			"ancient", "holy", "revered", "exalted", "divine",
			"blessed", "heretical", "godly", "beautiful", "altruistic",
			"illogical", "very vary", "dan-approved"
		)
		chosenrelic.name = pick(nameprefixes) + " " + I.name
		chosenrelic.icon = getFlatIcon(I)
		qdel(src)
	else
		linkedbible = B
		linkedbible.relic = src

/obj/item/relic/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	if(!prayer)
		return
	if(findtext(raw_message, prayer))
		if(playeffect())
			times_used++
			update()

/obj/item/relic/Destroy()
	if(linkedbible)
		linkedbible.relic = null
	..()

/obj/item/relic/proc/playeffect()
	affectedmobs.Cut()
	for(var/mob/living/carbon/human/H in range(range, src))
		if(conditions(H))
			affectedmobs |= H
			affectedmobs[H] = conditions(H)
	if(affectedmobs.len)
		feedback_inc("relic",1)
		return 1

/obj/item/relic/proc/conditions(mob/living/carbon/human/H)
	return 1

/obj/item/relic/proc/update()
	if(prob(times_used*10) && range > 1)//will the range lower?
		visible_message("<span class='danger'>\The [name] becomes slightly darker.</span>")
		range--
	else if(prob(times_used*5))//will it get destroyed?
		visible_message("<span class='danger'>\The [name] grows dull and powerless, slowly becoming ash...</span>")
		new /obj/effect/decal/cleanable/ash(loc)
		qdel(src)

//IMMUNITY: cures diseases

/obj/item/relic/immunity
	range = 3 // 3x3 area

/obj/item/relic/immunity/playeffect()
	if(..())
		visible_message("<span class='notice'>\The [name] emits an eerie glow!</span>")
		for(var/mob/living/carbon/human/M in affectedmobs)
			M << "<span class='notice'>You feel cleaned of your diseases!</span>"
			for(var/datum/disease/D in M.viruses)
				D.cure()
		return 1

/obj/item/relic/immunity/conditions(mob/living/carbon/human/H)
	return H.viruses.len

//HEALING RELICS

/obj/item/relic/healing // healing relics, they have healamt var which has a chance to be lowered
	var/healamt = 5

/obj/item/relic/healing/update()
	if(prob(times_used*20) && healamt > 1)//will the effect lower?
		visible_message("<span class='danger'>\The [name] becomes slightly darker.</span>")
		healamt--
	else
		..()

//PURGE: heals toxin damage

/obj/item/relic/healing/purge

/obj/item/relic/healing/purge/playeffect()
	if(..())
		visible_message("<span class='notice'>\The [name] emits an eerie glow!</span>")
		for(var/mob/living/carbon/human/M in affectedmobs)
			M.adjustToxLoss(-healamt)
		return 1

/obj/item/relic/healing/purge/conditions(mob/living/carbon/human/H)
	return H.getToxLoss()

//DIVINESIGHT: injects oculine

/obj/item/relic/healing/divinesight

/obj/item/relic/healing/divinesight/playeffect()
	if(..())
		visible_message("<span class='notice'>\The [name] emits an eerie glow!</span>")
		for(var/mob/living/carbon/human/M in affectedmobs)
			M.reagents.add_reagent("oculine", healamt)
			M << "<span class='notice'>You feel cleaned of your diseases!</span>"
		return 1

/obj/item/relic/healing/divinesight/conditions(mob/living/carbon/human/H)
	if((H.disabilities & BLIND) || (H.disabilities & NEARSIGHT) || H.eye_blind || H.eye_blurry || H.eye_stat)
		return 1

//CLEAR HEADED: cleans mindbreaker toxin and space drugs out of your bloodstream
/obj/item/relic/healing/clearheaded

/obj/item/relic/healing/clearheaded/playeffect()
	var/drug = ..()
	if(drug)
		visible_message("<span class='notice'>\The [name] emits an holy light!</span>")
		for(var/mob/living/carbon/human/M in affectedmobs)
			switch(affectedmobs[M])
				if(1)
					M.reagents.remove_reagent("mindbreaker", M.reagents.get_reagent_amount("mindbreaker"))
					M.hallucination = 0
				if(2)
					M.reagents.remove_reagent("space_drugs", M.reagents.get_reagent_amount("space_drugs"))
					M.druggy = 0
			M << "<span class='notice'>You mind feels cleared!</span>"
		return 1

/obj/item/relic/healing/clearheaded/conditions(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("mindbreaker"))
		return 1
	if(H.reagents.has_reagent("space_drugs"))
		return 2

//REVERB: heals deafness

/obj/item/relic/healing/reverb

/obj/item/relic/healing/reverb/playeffect()
	var/deaf = ..()
	if(deaf)
		visible_message("<span class='notice'>\The [name] emits a divine melody!</span>")
		playsound(src,'sound/effects/pray_chaplain.ogg',25,1)
		for(var/mob/living/carbon/human/M in affectedmobs)
			switch(affectedmobs[M])
				if(1)
					if(prob(healamt))//hey you're a chaplain not a combat medic
						M.disabilities &= ~DEAF
						M.setEarDamage(0,0)
						M << "<span class='notice'>You can hear the melody again!</span>"
				if(2)
					M.adjustEarDamage(-healamt,-healamt)
					M << "<span class='notice'>You feel like the melody's fixing your ears!</span>"
		return 1

/obj/item/relic/healing/reverb/conditions(mob/living/carbon/human/H)
	if(H.disabilities & DEAF)
		return 1
	if(H.ear_damage || H.ear_deaf)
		return 2

//MENDING: heals brute damage
/obj/item/relic/healing/mending

/obj/item/relic/healing/mending/playeffect()
	if(..())
		visible_message("<span class='notice'>\The [name] emits an holy light!</span>")
		for(var/mob/living/carbon/human/M in affectedmobs)
			M.adjustBruteLoss(-healamt)
			M.adjustBloodLoss(-healamt/10)
			M << "<span class='notice'>You feel your wounds knitting together!</span>"
		return 1

/obj/item/relic/healing/mending/conditions(mob/living/carbon/human/H)
	return H.getBruteLoss()

//ITEM SPAWNING RELICS

/obj/item/relic/itemspawner
	var/list/possiblespawns = list() //possible items that the relic can spawn
	var/list/peoplepraying = list() //list of people praying
	var/prayersneeded = 2 // number of people praying needed
	var/spawnsnumber = 2 //numbers of items that can spawn

/obj/item/relic/itemspawner/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	if(!prayer)
		return
	if(findtext(raw_message, prayer))
		if(!(speaker in peoplepraying))
			peoplepraying |= speaker
			if(peoplepraying.len == prayersneeded)
				if(playeffect())
					times_used++
					update()
					visible_message("<span class='danger'>\The [src] emits a bright light!</span>")
					return
			if(peoplepraying.len == 1)
				visible_message("<span class='danger'>\The [src] begins to glow...</span>")
				spawn(100)
					peoplepraying.Cut()
				return
			visible_message("<span class='danger'>\The [src]'s glow becomes brighter...</span>")

/obj/item/relic/itemspawner/playeffect()
	if(..())//by default it'll return 1, it's here in case you want to add conditions,such as an item-converter relic,iunno.
		for(var/i in 1 to spawnsnumber)
			var/path = pick(possiblespawns)
			new path(get_turf(src))
		return 1

//GREED: spawns coins/spacecash
/obj/item/relic/itemspawner/greed

/obj/item/relic/itemspawner/greed/New(location, obj/item/I, obj/item/weapon/storage/book/bible/B)
	..()
	possiblespawns += typesof(/obj/item/stack/spacecash) + typesof(/obj/item/weapon/coin)

//GLUTTONY: spawns food,woo
/obj/item/relic/itemspawner/gluttony // possiblespawns list defined in New(), to use typesof

/obj/item/relic/itemspawner/gluttony/New(location, obj/item/I, obj/item/weapon/storage/book/bible/B)
	..()
	var/list/blocked = list(/obj/item/weapon/reagent_containers/food/snacks,//taken from silver extracts
		/obj/item/weapon/reagent_containers/food/snacks/store/bread,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/store/cake,
		/obj/item/weapon/reagent_containers/food/snacks/cakeslice,
		/obj/item/weapon/reagent_containers/food/snacks/store,
		/obj/item/weapon/reagent_containers/food/snacks/pie,
		/obj/item/weapon/reagent_containers/food/snacks/kebab,
		/obj/item/weapon/reagent_containers/food/snacks/pizza,
		/obj/item/weapon/reagent_containers/food/snacks/pizzaslice,
		/obj/item/weapon/reagent_containers/food/snacks/salad,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/soup,
		/obj/item/weapon/reagent_containers/food/snacks/grown,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom,
		)
	possiblespawns += typesof(/obj/item/weapon/reagent_containers/food/snacks) - blocked