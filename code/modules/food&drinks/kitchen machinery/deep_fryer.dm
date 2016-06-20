/obj/item
	var/fry_amt = 0 //Amount of times this object was fried
/mob/living/carbon/human
	var/fry_amt = 0

/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it deep frying already?

/obj/machinery/deepfryer/examine(mob/user)
	..()
	if(contents.len)
		var/list/frying = jointext(contents, ", ")
		user << "You can make out [frying] in the oil."

/obj/machinery/deepfryer/proc/mob_fry(mob/living/F, mob/user)
	if(!istype(F)) return //implicit typechecking for /mob/living
	if(buckled_mob) return
	if(F == user) F.visible_message("<span class='warning'>[user] starts squeezing into [src]!</span>", "<span class='userdanger'>You start squeezing into [src]!</span>")
	else F.visible_message("<span class='warning'>[user] starts putting [F] into [src]!</span>", "<span class='userdanger'>[user] starts shoving you into [src]!</span>")
	if(!do_mob(user, F, 120)) return
	if(buckled_mob) return //to prevent spam/queing up attacks
	if(F.buckled) return
	on = TRUE
	F.loc = src
	user.stop_pulling()
	user.drop_item()
	icon_state = "fryer_on"
	spawn(0)
		for(var/i in 1 to 4)
			if(!F) //if mob got deleted for some reasons
				if(!contents.len) return // nothing
				else
					var/C = contents[1]
					src.visible_message("<span class='warning'>[C] dissolves in the oil!Fuck!</span>")
					icon_state = "fryer_off"
					on = FALSE
					playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -7)
					qdel(C)
					return
			if(F.loc != src) return // if we ejected the mob, can't process anything
			F.emote("scream")
			F.adjustFireLoss(12.5)
			sleep(50)
		F.loc = src.loc
		for(var/obj/item/O in F.contents)
			switch(O.fry_amt)
				if(0)
					O.color = "#7A5230"
				if(1)
					O.color = "#553921"
				if(2)
					O.color = "#302013"
				if(3)
					O.color = "#181009"
				if(4)
					O.color = "#0c0804"
				else
					O.color = "#000000"
			O.fry_amt = O.fry_amt + 1
			if(!(findtext(O.name, "deep fried"))) O.name = "deep fried [O.name]"
		if(ishuman(F))
			var/mob/living/carbon/human/ligger = F // fucking liggers and birds causing me issues like always
			if(MUTCOLORS in ligger.dna.species.specflags)
				ligger.dna.species.specflags -= MUTCOLORS
			ligger.deepfried = 1 // to avoid the deepfry overlay to reset when icons get regenerated
			ligger.fry_amt++
			ligger.regenerate_icons() //Updates the deepfried items overlays
		else // blending works for simple mobs which don't use a complicated update proc like simple animals so, but if you revive them..their icon won't change. idk
			var/icon/HI = icon(F.icon, F.icon_state)
			HI.Blend('icons/effects/overlays.dmi', ICON_MULTIPLY)
			F.icon = HI
		add_logs(user, F, "deepfried")
		icon_state = "fryer_off"
		on = FALSE
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -7)
		return

/obj/machinery/deepfryer/proc/item_fry(obj/item/I, mob/user)
	user.drop_item()
	I.loc = src
	user << "<span class='notice'>You put [I] into [src].</span>"
	on = TRUE
	icon_state = "fryer_on"
	spawn(200)

		if(I && I.loc == src)
			icon_state = "fryer_off"
			on = FALSE
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -7)
			if(I.fry_amt > 5 && prob(I.fry_amt * 3)) //Don't overfry shit!
				visible_message("<span class='danger'>[I] [pick("breaks", "crumbles", "burns")] in [src]!</span>")
				new /obj/effect/decal/cleanable/ash(loc)
				qdel(I)
				return

			var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
			if(I.reagents)
				if(I.reagents.total_volume)
					var/amount = I.reagents.get_reagent_amount("nutriment")
					if(I.reagents.has_reagent("nutriment") && amount > 1)  // special check to only transfer half of the nutriment the fried object had, if it has 2 nutriments or more
						I.reagents.trans_id_to(S, "nutriment", amount/2)
						I.reagents.del_reagent("nutriment") // so the rest won't be added with I.reagents.trans_to(S, I.reagents.total_volume)
					else
						S.reagents.add_reagent("nutriment", 1) // otherwise just give 1 nutriment
					I.reagents.trans_to(S, I.reagents.total_volume)
			else S.reagents.add_reagent("nutriment", 1) // if old item had no chems,just give 1 nutriment

			var/icon/IC = icon(I.icon, I.icon_state)
			IC.Blend('icons/effects/overlays.dmi', ICON_MULTIPLY)
			S.icon = IC
			S.name = I.name //In case the if check for length fails so we don't name it "Deep Fried Food Holder Obj"
			if(!(findtext(I.name, "deep fried"))) S.name = "deep fried [I.name]"
			S.fry_amt = I.fry_amt + 1
			S.desc = I.desc
			if(istype(I, /obj/item/weapon/disk/nuclear))
				S.desc = "Welp. I guess Centcomm will have to bluespace ANOTHER nuke disk now."
			qdel(I)

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(on)
		user << "<span class='notice'>[src] is still active!</span>"
		return
	if(istype(I,/obj/item/weapon/wrench))
		if(!anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			anchored = 1
			user << "You wrench [src] in place."
			return
		else if(anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			anchored = 0
			user << "You unwrench [src]."
			return
	if(!anchored)
		user << "The machine must be anchored to be usable!"
		return
	if(istype(I, /obj/item/tk_grab))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		user << "<span class='warning'>That would probably break [I].</span>"
		return
	if(istype(I, /obj/item/weapon/grab)) // what happens if we try to put an human in the frier?
		var/obj/item/weapon/grab/G = I
		var/mob/living/grabbed_thing = G.affecting
		if(!istype(grabbed_thing)) return//check type
		if(G.state < GRAB_AGGRESSIVE)
			user << "<span class='warning'>You need a better grip to do that!</span>"
			return
		mob_fry(grabbed_thing, user)
	else item_fry(I, user)

/obj/machinery/deepfryer/MouseDrop_T(mob/living/M, mob/user)
	if(!istype(M)) return
	if (user.stat != 0) return
	if(on)
		user << "<span class='notice'>[src] is still active!</span>"
		return
	if(!anchored)
		user << "The machine must be anchored to be usable!"
		return
	mob_fry(M, user)

/obj/machinery/deepfryer/attack_hand(mob/user)
	if(on && contents.len)
		var/O = pop(contents)
		if(ismob(O))
			var/mob/M = O
			user << "<span class='warning'>You pull [M] out!</span>"
			M.loc = get_turf(src)
			icon_state = "fryer_off"
			on = FALSE
			return
		else
			var/obj/item/item = O
			user << "<span class='notice'>You pull [item] from [src]! It looks like you were just in time!</span>"
			item.loc = get_turf(src)
			icon_state = "fryer_off"
			on = FALSE
		return
	..()