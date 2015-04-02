
// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return
/atom/movable/attackby(obj/item/W, mob/living/user)
	user.do_attack_animation(src)
	if(W && !(W.flags&NOBLUDGEON))
		visible_message("<span class='danger'>[user] has hit [src] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	I.attack(src, user)

/mob/living/proc/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone) //this is actually unused thanks to species.dm
	apply_damage(I.force, I.damtype)
	if(I.damtype == "brute")
		if(I.force)
			if(prob(33))
				var/turf/location = src.loc
				if(istype(location, /turf/simulated))
					location.add_blood_floor(src)
			else if(prob(66))
				var/turf/location = get_step_away(src,user)
				if(istype(location, /turf/simulated))
					location.add_blood_floor(src, 1) //1 for splatter

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


// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return


obj/item/proc/get_clamped_volume()
	if(src.force && src.w_class)
		return Clamp((src.force + src.w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
	else if(!src.force && src.w_class)
		return Clamp(src.w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)

	if (!istype(M)) // not sure if this is the right thing...
		return

	if (hitsound && (force > 0 || forcehitsound)) //If an item's hitsound is defined and the item's force is greater than zero...
		playsound(loc, pick(hitsound), get_clamped_volume(), 1, -1) //...play the item's hitsound at get_clamped_volume() with varying frequency and -1 extra range.
	else if (force == 0)//Otherwise, if the item's force is zero...
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), 1, -1)//...play tap.ogg at get_clamped_volume()
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	add_logs(user, M, "attacked", object=src.name, addition="(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////
	M.attacked_by(src, user, def_zone)
	add_fingerprint(user)
	return 1
