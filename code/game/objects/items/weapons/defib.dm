//backpack item

/obj/item/weapon/defibrillator
	name = "defibrillator"
	desc = "A device that delivers powerful shocks to detachable paddles that resuscitate incapacitated patients."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	w_class = 4
	origin_tech = "biotech=4"
	action_button_name = "Toggle Paddles"

	var/on = 0 //if the paddles are equipped (1) or on the defib (0)
	var/safety = 1 //if you can zap people with the defibs on harm mode
	var/powered = 0 //if there's a cell in the defib with enough power for a revive, blocks paddles from reviving otherwise
	var/obj/item/weapon/twohanded/shockpaddles/paddles
	var/obj/item/weapon/stock_parts/cell/high/bcell = null

/obj/item/weapon/defibrillator/New() //starts without a cell for rnd
	..()
	paddles = make_paddles()
	update_icon()
	return

/obj/item/weapon/defibrillator/loaded/New() //starts with hicap
	..()
	paddles = make_paddles()
	bcell = new(src)
	update_icon()
	return

/obj/item/weapon/defibrillator/update_icon()
	update_power()
	update_overlays()
	update_charge()

/obj/item/weapon/defibrillator/proc/update_power()
	if(bcell)
		if(bcell.charge < paddles.revivecost)
			powered = 0
		else
			powered = 1
	else
		powered = 0

/obj/item/weapon/defibrillator/proc/update_overlays()
	overlays.Cut()
	if(!on)
		overlays += "defibunit-paddles"
	if(powered)
		overlays += "defibunit-powered"
	if(!bcell)
		overlays += "defibunit-nocell"
	if(!safety)
		overlays += "defibunit-emagged"

/obj/item/weapon/defibrillator/proc/update_charge()
	if(powered) //so it doesn't show charge if it's unpowered
		if(bcell)
			var/ratio = bcell.charge / bcell.maxcharge
			ratio = Ceiling(ratio*4) * 25
			overlays += "defibunit-charge[ratio]"

/obj/item/weapon/defibrillator/CheckParts()
	bcell = locate(/obj/item/weapon/stock_parts/cell) in contents
	update_icon()

/obj/item/weapon/defibrillator/ui_action_click()
	if(usr.get_item_by_slot(slot_back) == src)
		toggle_paddles()
	else
		usr << "<span class='warning'>Put the defibrillator on your back first!</span>"
	return

/obj/item/weapon/defibrillator/attack_hand(mob/user as mob)
	if(src.loc == user)
		ui_action_click()
		return
	..()

/obj/item/weapon/defibrillator/MouseDrop(obj/over_object)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		switch(over_object.name)
			if("r_hand")
				if(H.r_hand)
					return
				if(!H.unEquip(src))
					return
				H.put_in_r_hand(src)
			if("l_hand")
				if(H.l_hand)
					return
				if(!H.unEquip(src))
					return
				H.put_in_l_hand(src)
	return

/obj/item/weapon/defibrillator/attackby(obj/item/weapon/W, mob/user, params)
	if(W == paddles)
		paddles.unwield()
		toggle_paddles()
		return
	if(istype(W, /obj/item/weapon/stock_parts/cell))
		var/obj/item/weapon/stock_parts/cell/C = W
		if(bcell)
			user << "<span class='notice'>[src] already has a cell.</span>"
		else
			if(C.maxcharge < paddles.revivecost)
				user << "<span class='notice'>[src] requires a higher capacity cell.</span>"
				return
			user.drop_item()
			W.loc = src
			bcell = W
			user << "<span class='notice'>You install a cell in [src].</span>"

	if(istype(W, /obj/item/weapon/screwdriver))
		if(bcell)
			bcell.updateicon()
			bcell.loc = get_turf(src.loc)
			bcell = null
			user << "<span class='notice'>You remove the cell from [src].</span>"

	update_icon()
	return

/obj/item/weapon/defibrillator/emag_act(mob/user as mob)
	if(safety)
		safety = 0
		user << "<span class='warning'>You silently disable [src]'s safety protocols with the cryptographic sequencer."
	else
		safety = 1
		user << "<span class='notice'>You silently enable [src]'s safety protocols with the cryptographic sequencer."
	update_icon()

/obj/item/weapon/defibrillator/emp_act(severity)
	if(bcell)
		deductcharge(1000 / severity)
		if(bcell.reliability != 100 && prob(50/severity))
			bcell.reliability -= 10 / severity
	if(safety)
		safety = 0
		src.visible_message("<span class='notice'>[src] beeps: Safety protocols disabled!</span>")
		playsound(get_turf(src), 'sound/machines/defib_saftyOff.ogg', 50, 0)
	else
		safety = 1
		src.visible_message("<span class='notice'>[src] beeps: Safety protocols enabled!</span>")
		playsound(get_turf(src), 'sound/machines/defib_saftyOn.ogg', 50, 0)
	update_icon()
	..()

/obj/item/weapon/defibrillator/proc/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"
	on = !on

	var/mob/living/carbon/human/user = usr
	if(on)
		//Detach the paddles into the user's hands
		if(!usr.put_in_hands(paddles))
			on = 0
			user << "<span class='warning'>You need a free hand to hold the paddles!</span>"
			update_icon()
			return
		paddles.loc = user
	else
		//Remove from their hands and back onto the defib unit
		paddles.unwield()
		remove_paddles(user)

	update_icon()
	return

/obj/item/weapon/defibrillator/proc/make_paddles()
	return new /obj/item/weapon/twohanded/shockpaddles(src)

/obj/item/weapon/defibrillator/equipped(mob/user, slot)
	if(slot != slot_back)
		remove_paddles(user)
		update_icon()

/obj/item/weapon/defibrillator/proc/remove_paddles(mob/user)
	var/mob/living/carbon/human/M = user
	if(paddles in get_both_hands(M))
		M.unEquip(paddles,1)
	update_icon()
	return

/obj/item/weapon/defibrillator/Destroy()
	if(on)
		var/M = get(paddles, /mob)
		remove_paddles(M)
	..()
	update_icon()
	return

/obj/item/weapon/defibrillator/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.charge < (paddles.revivecost+chrgdeductamt))
			powered = 0
			update_icon()
		if(bcell.use(chrgdeductamt))
			update_icon()
			return 1
		else
			update_icon()
			return 0

/obj/item/weapon/defibrillator/proc/cooldowncheck(var/mob/user)
	spawn(50)
		if(bcell)
			if(bcell.charge >= paddles.revivecost)
				user.visible_message("<span class='notice'>[src] beeps: Unit ready.</span>")
				playsound(get_turf(src), 'sound/machines/defib_ready.ogg', 50, 0)
			else
				user.visible_message("<span class='notice'>[src] beeps: Charge depleted.</span>")
				playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		paddles.cooldown = 0
		paddles.update_icon()
		update_icon()

//paddles

/obj/item/weapon/twohanded/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	force = 0
	throwforce = 6
	w_class = 4
	flags = NODROP

	var/revivecost = 1000
	var/cooldown = 0
	var/busy = 0
	var/obj/item/weapon/defibrillator/defib

/obj/item/weapon/twohanded/shockpaddles/New(mainunit)
	..()
	if(check_defib_exists(mainunit, src))
		defib = mainunit
		loc = defib
		busy = 0
		update_icon()
	return

/obj/item/weapon/twohanded/shockpaddles/update_icon()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles[wielded]"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/weapon/twohanded/shockpaddles/suicide_act(mob/user)
	user.visible_message("<span class='danger'>[user] is putting the live paddles on \his chest! It looks like \he's trying to commit suicide.</span>")
	defib.deductcharge(revivecost)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	return (OXYLOSS)

/obj/item/weapon/twohanded/shockpaddles/dropped(mob/user as mob)
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
		user << "<span class='notice'>The paddles snap back into the main unit.</span>"
		defib.on = 0
		loc = defib
		defib.update_icon()
	return	unwield()

/obj/item/weapon/twohanded/shockpaddles/proc/check_defib_exists(mainunit, var/mob/living/carbon/human/M, var/obj/O)
	if (!mainunit || !istype(mainunit, /obj/item/weapon/defibrillator))	//To avoid weird issues from admin spawns
		M.unEquip(O)
		qdel(O)
		return 0
	else
		return 1

/obj/item/weapon/twohanded/shockpaddles/attack(mob/M as mob, mob/user as mob)
	var/tobehealed
	var/threshold = -config.health_threshold_dead
	// var/mob/living/L = M
	var/mob/living/carbon/human/H = M

	if(busy)
		return
	if(istype(M, /obj) || istype(M, /turf))
		return
	if(!defib.powered)
		user.visible_message("<span class='notice'>[defib] beeps: Unit is unpowered.</span>")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return
	if(!wielded)
		user << "<span class='notice'>You need to wield the paddles in both hands before you can use them on someone!</span>"
		return
	if(cooldown)
		user << "<span class='notice'>[defib] is recharging.</span>"
		return
	if(!ishuman(M))
		user << "<span class='notice'>The instructions on [defib] don't mention how to revive that...</span>"
		return
	else
		if(user.a_intent == "harm" && !defib.safety)
			busy = 1
			H.visible_message("<span class='danger'>[user] has touched [H.name] with [src]!</span>", \
					"<span class='userdanger'>[user] has touched [H.name] with [src]!</span>")
			H.adjustFireLoss(30)
			H.Stun(5)
			H.Weaken(5)
			H.Paralyse(3)
			H.apply_effect(STUTTER, 5)
			// H.Weaken(5)
			H.updatehealth() //forces health update before next life tick
			playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
			H.emote("gasp")
			add_logs(user, M, "shocked", object="defibrillator")
			defib.deductcharge(revivecost)
			cooldown = 1
			busy = 0
			update_icon()
			defib.cooldowncheck(user)
			return
		if(user.zone_sel && user.zone_sel.selecting == "chest")
			user.visible_message("<span class='warning'>[user] begins to place [src] on [M.name]'s chest.</span>", "<span class='warning'>You begin to place [src] on [M.name]'s chest.</span>")
			busy = 1
			update_icon()
			if(do_after(user, 30, target = src)) //beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
				user.visible_message("<span class='notice'>[user] places [src] on [M.name]'s chest.</span>", "<span class='warning'>You place [src] on [M.name]'s chest.</span>")
				playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
				var/mob/dead/observer/ghost = H.get_ghost()
				var/tplus = world.time - H.timeofdeath
				var/tlimit = 3600 //past this much time the patient is unrecoverable (in deciseconds)
				var/tloss = 900 //brain damage starts setting in on the patient after some time left rotting
				var/total_burn	= 0
				var/total_brute	= 0
				if(do_after(user, 20, target = src)) //placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
					for(var/obj/item/carried_item in H.contents)
						if((istype(carried_item, /obj/item/clothing/suit/armor)) || (istype(carried_item, /obj/item/clothing/suit/space)))
							user.visible_message("<span class='notice'>[defib] buzzes: Patient's chest is obscured. Operation aborted.</span>")
							playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
							busy = 0
							update_icon()
							return
					if(H.stat == 2)
						var/health = H.health + H.getOxyLoss() //Gotta use L because this proc is mob/living.
						// var/random = prob(80) //Chance of success. Stored in a variable to display failure message. Currently removed from the if check.
						// user.visible_message("<span class='warning'>[health] HP ([H.getOxyLoss()] oxyloss notwithstanding). [threshold] threshold.") //Debug text
						M.visible_message("<span class='warning'>[M]'s body convulses a bit.")
						playsound(get_turf(src), "bodyfall", 50, 1)
						playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
						for(var/obj/item/organ/limb/O in H.organs)
							total_brute	+= O.brute_dam
							total_burn	+= O.burn_dam
						if(health > (config.health_threshold_dead - 50) && total_burn <= 180 && total_brute <= 180 && !H.suiciding && !ghost && tplus < tlimit && !(NOCLONE in H.mutations))
							tobehealed = (health + threshold) + 65 //Threshold is positive, health is negative.
							//Current problem: defib can pull you out of crit completely, AND there are sometimes cases where you'll die instantly after getting defibbed.

							// user.visible_message("<span class='warning'>+[tobehealed] HP heals for toxloss, fireloss, bruteloss.") //Debug text
							H.adjustOxyLoss(-H.getOxyLoss() + 60) //Basically sets person's oxyloss to 60.
							H.adjustToxLoss(-tobehealed)
							H.adjustFireLoss(-tobehealed)
							H.adjustBruteLoss(-tobehealed)
							user.visible_message("<span class='notice'>[defib] pings: Resuscitation successful.</span>")
							playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
							H.stat = 1
							dead_mob_list -= H
							living_mob_list |= list(H)
							H.emote("gasp")
							if(tplus > tloss)
								H.setBrainLoss( max(0, min(99, ((tlimit - tplus) / tlimit * 100))))
							defib.deductcharge(revivecost)
							add_logs(user, M, "revived", object="defibrillator")
						else
							if(tplus > tlimit)
								user.visible_message("<span class='warning'>[defib] buzzes: Resuscitation failed - Heart tissue damage beyond point of no return for defibrillation.</span>")
							else if(total_burn > 180 || total_brute > 180)
								user.visible_message("<span class='warning'>[defib] buzzes: Resuscitation failed - Severe tissue damage detected.</span>")
							else if(health <= (config.health_threshold_dead - 50))
								user.visible_message("<span class='warning'>[defib] buzzes: Resuscitation failed - Critical organical damage detected.</span>")
							// else if(!random)
							// 	user.visible_message("<span class='warning'>[defib] buzzes: Resuscitation failed - Please try again.</span>")
							else
								if(ghost)
									ghost << "<span class='ghostalert'>Your heart is being defibrillated. Return to your body if you want to be revived!</span> (Verbs -> Ghost -> Re-enter corpse)"
									ghost << sound('sound/effects/genetics.ogg')
									user.visible_message("<span class='warning'>[defib] buzzes: Resuscitation failed - Mental interface failure.</span>")
								else
									user.visible_message("<span class='warning'>[defib] buzzes: Resuscitation failed.</span>")
							playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
							defib.deductcharge(revivecost)
						update_icon()
						cooldown = 1
						defib.cooldowncheck(user)
					else
						user.visible_message("<span class='notice'>[defib] buzzes: Patient is not in a valid state. Operation aborted.</span>")
						playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
			busy = 0
			update_icon()
		else
			user << "<span class='notice'>You need to target your patient's chest with [src].</span>"
			return
