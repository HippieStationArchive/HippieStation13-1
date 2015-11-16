
// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

// No comment
/atom/proc/attackby(obj/item/W, mob/user, params)
	return

/atom/movable/attackby(obj/item/W, mob/living/user, params)
	user.do_attack_animation(src)
	if(W && !(W.flags&NOBLUDGEON))
		visible_message("<span class='danger'>[user] has hit [src] with [W]!</span>")

/mob/living/attackby(obj/item/I, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(butcher_results && stat == DEAD) //can we butcher it?
		var/sharpness = I.is_sharp()
		if(sharpness)
			user << "<span class='notice'>You begin to butcher [src]...</span>"
			playsound(loc, 'sound/weapons/slice.ogg', 50, 1, -1)
			if(do_mob(user, src, 80/sharpness))
				harvest(user)
			return
	I.attack(src, user)

/mob/living/proc/attacked_by(obj/item/I, mob/living/user, def_zone)
	apply_damage(I.force, I.damtype, def_zone)
	if(I.damtype == "brute")
		if(prob(33) && I.force)
			var/turf/location = src.loc
			if(istype(location, /turf/simulated))
				location.add_blood_floor(src)

	var/message_verb = ""
	if(I.attack_verb && I.attack_verb.len)
		message_verb = "[pick(I.attack_verb)]"
	else if(I.force)
		message_verb = "attacked"

	var/attack_message = "[src] has been [message_verb] with [I]."
	if(user)
		user.do_attack_animation(src)
		if(user in viewers(src, null))
			attack_message = "[user] has [message_verb] [src] with [I]!"
	if(message_verb)
		visible_message("<span class='danger'>[attack_message]</span>",
		"<span class='userdanger'>[attack_message]</span>")

/mob/living/simple_animal/attacked_by(var/obj/item/I, var/mob/living/user)
	if(!I.force)
		user.visible_message("<span class='warning'>[user] gently taps [src] with [I].</span>",\
						"<span class='warning'>This weapon is ineffective, it does no damage!</span>")
	else if(I.force >= force_threshold && I.damtype != STAMINA)
		..()
	else
		visible_message("<span class='warning'>[I] bounces harmlessly off of [src].</span>",\
					"<span class='warning'>[I] bounces harmlessly off of [src]!</span>")



// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return


/obj/item/proc/get_clamped_volume()
	if(src.force && src.w_class)
		return Clamp((src.force + src.w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
	else if(!src.force && src.w_class)
		return Clamp(src.w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/obj/item/proc/attack(mob/living/M, mob/living/user, def_zone)

	if (!istype(M)) // not sure if this is the right thing...
		return

	//Throat slitting -- Will be added later.
	// if(user.zone_sel.selecting == "head" && ishuman(M))
	// 	var/mob/living/carbon/human/H = M
	// 	var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))
	// 	var/armor = H.run_armor_check(affecting, "melee")
	// 	if(armor < 100 && affecting)
	// 		for(var/obj/item/weapon/grab/G in user)
	// 			if(G.assailant == user && G.state >= GRAB_NECK && G.affecting == H)
	// 				if(src.can_slit_throat && H.last_throat_slit < world.time)
	// 					if(affecting.status == ORGAN_ORGANIC)
	// 						src.add_blood(H) //Bloodify our knife
	// 						H.apply_damage(Clamp(src.force * 2, 0, 50), src.damtype, affecting, armor, H) //Not that much damage because the aftereffects are pretty damn devastating.
	// 						H.adjustBloodLoss(Clamp(src.bleedchance / 100, 0, 1), affecting)
	// 						H.apply_effect(20, PARALYZE, armor)
	// 						H.silent = 20 //Your throat was slit. You wouldn't be able to talk, really.
	// 						H.losebreath = 30 //You lose breath 30 ticks, aka 60 seconds. Someone will have to give you a dexalin pill to swallow if you make it out alive.
	// 						H.visible_message("<span class='suicide'>[user] has slit [H]'s throat open with [src]!</span>", \
	// 										"<span class='suicide'>Your throat has been slit open by [user] with [src]!</span>")
	// 						H.emote("gasp")
	// 						playsound(H.loc, 'sound/misc/slit.ogg', 100, 1, -2)
	// 						user.changeNext_move(50) //5 seconds till you can act again.
	// 						var/obj/effect/effect/splatter/B = new(H)
	// 						B.basecolor = H.dna.species.blood_color
	// 						B.blood_source = H
	// 						B.update_icon()
	// 						var/n = rand(1,3)
	// 						var/turf/targ = get_ranged_target_turf(H, user.dir, n)
	// 						B.GoTo(targ, n)

	// 						H.last_throat_slit = world.time + 3000//You can only slit a particular person's throat every 5 minutes. It's a devastating move.
	// 						add_logs(user, H, "throat-slit", src)
	// 						return 0

	if (hitsound && force > 0) //If an item's hitsound is defined and the item's force is greater than zero...
		playsound(loc, hitsound, get_clamped_volume(), 1, -1) //...play the item's hitsound at get_clamped_volume() with varying frequency and -1 extra range.
	else if (force == 0)//Otherwise, if the item's force is zero...
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), 1, -1)//...play tap.ogg at get_clamped_volume()
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////
	M.attacked_by(src, user, def_zone)

	add_logs(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)

	return 1
