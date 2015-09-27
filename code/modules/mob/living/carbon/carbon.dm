/mob/living/carbon/prepare_huds()
	..()
	prepare_data_huds()

/mob/living/carbon/proc/prepare_data_huds()
	..()
	med_hud_set_health()
	med_hud_set_status()

/mob/living/carbon/updatehealth()
	..()
	med_hud_set_health()
	med_hud_set_status()

/mob/living/carbon/Destroy()
	for(var/atom/movable/guts in internal_organs)
		qdel(guts)
	for(var/atom/movable/food in stomach_contents)
		qdel(food)
	remove_from_all_data_huds()
	return ..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			src.nutrition -= HUNGER_FACTOR/10
			if(src.m_intent == "run")
				src.nutrition -= HUNGER_FACTOR/10
		if((FAT in src.mutations) && src.m_intent == "run" && src.bodytemperature <= 360)
			src.bodytemperature += 2

/mob/living/carbon/movement_delay()
	. = 0
	if(legcuffed)
		. += legcuffed.slowdown

/mob/living/carbon/relaymove(var/mob/user, direction)
	if(user in src.stomach_contents)
		if(prob(40))
			audible_message("<span class='danger'>You hear something rumbling inside [src]'s stomach...</span>", \
						 "<span class='danger'>You hear something rumbling.</span>", 4,\
						  "<span class='danger'>Something is rumbling inside your stomach!</span>")
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/organ = H.get_organ("chest")
					if (istype(organ, /obj/item/organ/limb))
						var/obj/item/organ/limb/temp = organ
						if(temp.take_damage(d, 0))
							H.update_damage_overlays(0)
					H.updatehealth()
				else
					src.take_organ_damage(d)
				visible_message("<span class='danger'>[user] attacks [src]'s stomach wall with the [I.name]!</span>", \
									"<span class='userdanger'>[user] attacks your stomach wall with the [I.name]!</span>")
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()

/mob/living/carbon/gib(var/animation = 1)
	for(var/mob/M in src)
		if(M in stomach_contents)
			stomach_contents.Remove(M)
		M.loc = loc
		visible_message("<span class='danger'>[M] bursts out of [src]!</span>")
	. = ..()


/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0
	src.take_overall_damage(0,shock_damage)
	//src.burn_skin(shock_damage)
	//src.adjustFireLoss(shock_damage) //burn_skin will do this for us
	//src.updatehealth()
	src.visible_message(
		"<span class='danger'>[src] was shocked by the [source]!</span>", \
		"<span class='userdanger'>You feel a powerful shock coursing through your body!</span>", \
		"<span class='danger'>You hear a heavy electrical crack.</span>" \
	)
	src.jitteriness += 1000 //High numbers for violent convulsions
	src.stuttering += 2
	Stun(2)
	spawn(20)
		src.jitteriness -= 990 //Still jittery, but vastly less
		Stun(3)
		Weaken(3)
	return shock_damage


/mob/living/carbon/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(istype(item_in_hand,/obj/item/weapon/twohanded))
			if(item_in_hand:wielded == 1)
				usr << "<span class='warning'>Your other hand is too busy holding the [item_in_hand.name]</span>"
				return
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_l_active"
			hud_used.r_hand_hud_object.icon_state = "hand_r_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_l_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_r_active"
	/*if (!( src.hand ))
		src.hands.dir = NORTH
	else
		src.hands.dir = SOUTH*/
	return

/mob/living/carbon/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()
	else
		mode() // Activate held item

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(health >= 0)

		if(lying)
			sleeping = max(0, sleeping - 5)
			if(sleeping == 0)
				resting = 0
			M.visible_message("<span class='notice'>[M] shakes [src] trying to get \him up!</span>", \
							"<span class='notice'>You shake [src] trying to get \him up!</span>")
		else
			M.visible_message("<span class='notice'>[M] hugs [src] to make \him feel better!</span>", \
						"<span class='notice'>You hug [src] to make \him feel better!</span>")

		AdjustParalysis(-3)
		AdjustStunned(-3)
		AdjustWeakened(-3)

		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/proc/eyecheck()
	return 0

/mob/living/carbon/proc/tintcheck()
	return 0

//Throwing stuff
/mob/living/carbon/proc/toggle_throw_mode()
	if(stat)
		return
	if(in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()


/mob/living/carbon/proc/throw_mode_off()
	in_throw_mode = 0
	throw_icon.icon_state = "act_throw_off"


/mob/living/carbon/proc/throw_mode_on()
	in_throw_mode = 1
	throw_icon.icon_state = "act_throw_on"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	throw_mode_off()
	if(!target || !isturf(loc))
		return
	if(istype(target, /obj/screen)) return

	var/atom/movable/item = src.get_active_hand()

	if(!item || (item.flags & NODROP)) return

	if(istype(item, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = item
		item = G.throwAffecting() //throw the person instead of the grab
		qdel(G)			//We delete the grab, as it needs to stay around until it's returned.
		if(ismob(item))
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				add_logs(src, M, "thrown", admin=0, addition="from [start_T_descriptor] with the target [end_T_descriptor]")

	if(!item) return //Grab processing has a chance of returning null

	if(!ismob(item)) //Honk mobs don't have a dropped() proc honk
		unEquip(item)
	if(src.client)
		src.client.screen -= item

	//actually throw it!
	if(item)
		var/range = item.throw_range
		var/throw_speed = item.throw_speed
		var/did = "thrown"
		var/obj/item/I = src.get_inactive_hand()
		var/obj/item/E = item
		if(istype(I) && I.special_throw && istype(E) && I.specthrow_maxwclass >= E.w_class) //For special items that multiply something's throw range when in inactive hand (example: baseball bat)
			range = round(range * I.throwrange_mult)
			if(I.specthrowmsg)
				did = I.specthrowmsg
			if(I.specthrowsound)
				playsound(loc, I.specthrowsound, 50, 1, -1)
			if(I.throwforce_mult)
				E.throwforce = round(E.throwforce * I.throwforce_mult)
				E.mult = 1 //Tell the code we have modified this item's throwforce and would like for it to be set back to normal after it hits something.
		item.throwzone = check_zone(src.zone_sel.selecting) //So targeting when throwing items isn't completely useless
		item.layer = initial(item.layer)
		src.visible_message("<span class='danger'>[src] has [did] [item].</span>")

		newtonian_move(get_dir(target, src))

		item.throw_at(target, range, throw_speed)

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/stool/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/proc/canBeHandcuffed()
	return 0



/mob/living/carbon/unEquip(obj/item/I) //THIS PROC DID NOT CALL ..() AND THAT COST ME AN ENTIRE DAY OF DEBUGGING.
	. = ..() //Sets the default return value to what the parent returns.
	if(!. || !I) //We don't want to set anything to null if the parent returned 0.
		return

	if(I == back)
		back = null
		update_inv_back(0)
	else if(I == wear_mask)
		if(istype(src, /mob/living/carbon/human)) //If we don't do this hair won't be properly rebuilt.
			return
		wear_mask = null
		update_inv_wear_mask(0)
	else if(I == handcuffed)
		handcuffed = null
		if(buckled && buckled.buckle_requires_restraints)
			buckled.unbuckle_mob()
		update_inv_handcuffed(0)
	else if(I == legcuffed)
		legcuffed = null
		update_inv_legcuffed(0)


/mob/living/carbon/proc/get_temperature(var/datum/gas_mixture/environment)
	var/loc_temp = T0C
	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		loc_temp =  M.return_temperature()

	else if(istype(loc, /obj/structure/transit_tube_pod))
		loc_temp = environment.temperature

	else if(istype(get_turf(src), /turf/space))
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.temperature

	else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		var/obj/machinery/atmospherics/unary/cryo_cell/C = loc

		if(C.air_contents.total_moles() < 10)
			loc_temp = environment.temperature
		else
			loc_temp = C.air_contents.temperature

	else
		loc_temp = environment.temperature

	return loc_temp


/mob/living/carbon/show_inv(mob/user)
	user.set_machine(src)
	var/dat = {"
	<HR>
	<B><FONT size=3>[name]</FONT></B>
	<HR>
	<BR><B>Mask:</B> <A href='?src=\ref[src];item=[slot_wear_mask]'>		[(wear_mask && !(wear_mask.flags&ABSTRACT))	? wear_mask	: "Nothing"]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=[slot_l_hand]'>		[(l_hand && !(l_hand.flags&ABSTRACT))		? l_hand	: "Nothing"]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=[slot_r_hand]'>		[(r_hand && !(r_hand.flags&ABSTRACT))		? r_hand	: "Nothing"]</A>"}

	dat += "<BR><B>Back:</B> <A href='?src=\ref[src];item=[slot_back]'> [back ? back : "Nothing"]</A>"

	if(istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank))
		dat += "<BR><A href='?src=\ref[src];internal=1'>[internal ? "Disable Internals" : "Set Internals"]</A>"

	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_legcuffed]'>Legcuffed</A>"

	dat += {"
	<BR>
	<BR><A href='?src=\ref[user];mach_close=mob\ref[src]'>Close</A>
	"}
	user << browse(dat, "window=mob\ref[src];size=325x500")
	onclose(user, "mob\ref[src]")

/mob/living/carbon/Topic(href, href_list)
	..()
	//strip panel
	if(usr.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		if(href_list["internal"])
			var/slot = text2num(href_list["internal"])
			var/obj/item/ITEM = get_item_by_slot(slot)
			if(ITEM && istype(ITEM, /obj/item/weapon/tank) && wear_mask && (wear_mask.flags & MASKINTERNALS))
				visible_message("<span class='danger'>[usr] tries to [internal ? "close" : "open"] the valve on [src]'s [ITEM].</span>", \
								"<span class='userdanger'>[usr] tries to [internal ? "close" : "open"] the valve on [src]'s [ITEM].</span>")
				if(do_mob(usr, src, POCKET_STRIP_DELAY))
					if(internal)
						internal = null
						if(internals)
							internals.icon_state = "internal0"
					else if(ITEM && istype(ITEM, /obj/item/weapon/tank) && wear_mask && (wear_mask.flags & MASKINTERNALS))
						internal = ITEM
						if(internals)
							internals.icon_state = "internal1"

					visible_message("<span class='danger'>[usr] [internal ? "opens" : "closes"] the valve on [src]'s [ITEM].</span>", \
									"<span class='userdanger'>[usr] [internal ? "opens" : "closes"] the valve on [src]'s [ITEM].</span>")



/mob/living/carbon/getTrail()
	if(getBruteLoss() < 300)
		if(prob(50))
			return "ltrails_1"
		return "ltrails_2"
	else if(prob(50))
		return "trails_1"
	return "trails_2"

var/const/NO_SLIP_WHEN_WALKING = 1
var/const/STEP = 2
var/const/SLIDE = 4
var/const/GALOSHES_DONT_HELP = 8
/mob/living/carbon/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	if(isturf(loc))
		loc.handle_slip(src, s_amount, w_amount, O, lube)

/mob/living/carbon/fall(var/forced)
	if(isturf(loc))
		loc.handle_fall(src, forced)//it's loc so it doesn't call the mob's handle_fall which does nothing

/mob/living/carbon/is_muzzled()
	return(istype(src.wear_mask, /obj/item/clothing/mask/muzzle) || src.silent > 0)

/mob/living/carbon/get_standard_pixel_y_offset(lying = 0)
	if(lying)
		return -6
	else
		return initial(pixel_y)