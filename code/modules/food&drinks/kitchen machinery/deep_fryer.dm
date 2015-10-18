/obj/item
	var/fry_amt = 0 //Amount of times this object was fried

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
	var/obj/item/frying = null	//What's being fried RIGHT NOW?

/obj/machinery/deepfryer/examine()
	..()
	if(frying)
		usr << "You can make out [frying] in the oil."

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
	// if(istype(I, /obj/item/weapon/disk/nuclear)) //Don't give chef the nuke disk. Seriously.
	// 	user << "Central Command would kill you if you deep fried that."
	// 	return
	if(istype(I, /obj/item/weapon/grab)) // what happens if we try to put an human in the frier?
		var/obj/item/weapon/grab/G = I
		I = G.affecting
		if(G.state < GRAB_AGGRESSIVE)
			user << "<span class='warning'>You need a better grip to do that!</span>"
			return
		if(istype(I, /mob/living/))
			if(!buckled_mob)
				I.visible_message("<span class='warning'>[user] starts putting [I] into [src]!</span>", "<span class='userdanger'>[user] starts shoving you into [src]!</span>")
				if(do_mob(user, src, 120))
					var/mob/living/H = I
					if(buckled_mob) return //to prevent spam/queing up attacks
					if(H.buckled) return
					on = TRUE
					H.loc = src
					user.stop_pulling()
					user.drop_item()
					frying = H
				else return
	else
		user.drop_item()
		frying = I
		frying.loc = src
		user << "<span class='notice'>You put [I] into [src].</span>"
		on = TRUE
	icon_state = "fryer_on"

	if(istype(frying, /mob/living)) // if there's an hooman inside
		var/mob/living/L = frying
		spawn(0)
			for(var/i in 1 to 4)
				L.adjustFireLoss(12.5)
				L.emote("scream")
				sleep(50)
			L.loc = src.loc
			for(var/obj/item/O in L.contents)
				var/icon/OI = icon(O.icon, O.icon_state)
				OI.Blend('icons/effects/overlays.dmi', ICON_MULTIPLY)
				O.icon = OI
				O.name = "deep fried [O.name]"
			if(ishuman(frying))
				var/mob/living/carbon/human/ligger = frying // fucking liggers and birds causing me issues like always
				if(MUTCOLORS in ligger.dna.species.specflags)
					ligger.dna.species.specflags -= MUTCOLORS
					ligger.regenerate_icons()
				ligger.deepfried = 1 // to avoid the deepfry overlay to reset when icons get regenerated
				ligger.update_body()
			if(!(findtext(L.name, "deep fried"))) // deep fried deep fried deep fried deep fried deep fired John Snow says, "hi", no
				L.name = "deep fried [L.name]"
				L.real_name = L.name
			icon_state = "fryer_off"
			on = FALSE
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -7)
			return
	sleep(200)

	if(frying && frying.loc == src)
		icon_state = "fryer_off"
		on = FALSE
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1, -7)
		if(frying.fry_amt > 5 && prob(frying.fry_amt * 3)) //Don't overfry shit!
			visible_message("<span class='danger'>[I] [pick("breaks", "crumbles", "burns")] in [src]!</span>")
			new /obj/effect/decal/cleanable/ash(loc)
			qdel(frying)
			return

		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		if(frying.reagents)
			if(frying.reagents.total_volume)
				var/amount = frying.reagents.get_reagent_amount("nutriment")
				if(frying.reagents.has_reagent("nutriment") && amount > 1)  // special check to only transfer half of the nutriment the fried object had, if it has 2 nutriments or more
					frying.reagents.trans_id_to(S, "nutriment", amount/2)
					frying.reagents.del_reagent("nutriment") // so the rest won't be added with frying.reagents.trans_to(S, frying.reagents.total_volume)
				else
					S.reagents.add_reagent("nutriment", 1) // otherwise just give 1 nutriment
				frying.reagents.trans_to(S, frying.reagents.total_volume)
		else S.reagents.add_reagent("nutriment", 1) // if old item had no chems,just give 1 nutriment

		var/icon/IC = icon(frying.icon, frying.icon_state)
		IC.Blend('icons/effects/overlays.dmi', ICON_MULTIPLY)
		S.icon = IC
		S.name = frying.name //In case the if check for length fails so we don't name it "Deep Fried Food Holder Obj"
		if(length(S.name) < 500) //S.name = "[pick("extra", "super", "hyper", "mega", "ultra")] deep fried [initial(frying.name)]"
			S.name = "deep fried [frying.name]"
		S.fry_amt = frying.fry_amt + 1
		S.desc = I.desc
		if(istype(I, /obj/item/weapon/disk/nuclear))
			S.desc = "Welp. I guess Centcomm will have to bluespace ANOTHER nuke disk now."
		qdel(frying)
/obj/machinery/deepfryer/attack_hand(mob/user)
	if(on && frying)
		if(ismob(frying))
			user << "<span class='warning'>You cannot pull him out!</span>"
			return
		user << "<span class='notice'>You pull [frying] from [src]! It looks like you were just in time!</span>"
		user.put_in_hands(frying)
		frying = null
		icon_state = "fryer_off"
		on = FALSE
		return
	..()
