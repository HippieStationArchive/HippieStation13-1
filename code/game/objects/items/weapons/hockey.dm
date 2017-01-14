/obj/item/weapon/hockeypack
	name = "Ka-Nada Special Sport Forces Hockey Pack"
	desc = "Holds and powers a Ka-Nada SSF Hockey Stick, A devastating weapon capable of knocking men around like toys and batting objects at deadly velocities."
	icon = 'icons/obj/items.dmi'
	icon_state = "hockey_bag"
	item_state = "hockey_bag"
	w_class = 4
	slot_flags = SLOT_BACK
	flags = NODROP
	action_button_name = "Get stick"

	var/obj/item/weapon/twohanded/hockeystick/packstick
	var/on = 0
	var/volume = 500


/obj/item/weapon/hockeypack/New() //A lot of this is copied from how backpack watertanks work, ain't broke, don't fix.
	packstick = make_stick()

/obj/item/weapon/hockeypack/ui_action_click()
	toggle_stick()

/obj/item/weapon/hockeypack/verb/toggle_stick()
	set name = "Get stick"
	set category = "Object"
	if (usr.get_item_by_slot(usr.getHockeypackSlot()) != src)
		usr << "<span class='warning'>The pack must be worn properly to use!</span>"
		return
	if(usr.incapacitated())
		return
	on = !on

	var/mob/living/carbon/human/user = usr
	if(on)
		if(packstick == null)
			packstick = make_stick()

		if(!user.put_in_hands(packstick))
			on = 0
			user << "<span class='warning'>You need a free hand to hold the stick!</span>"
			return
		packstick.loc = user
	else
		remove_stick()
	return

/obj/item/weapon/hockeypack/proc/make_stick()
	return new /obj/item/weapon/twohanded/hockeystick(src)

/obj/item/weapon/hockeypack/equipped(mob/user, slot) //The Pack is cursed so this should not happen, but i'm going to play it safe.
	if (slot != slot_back)
		remove_stick()

/obj/item/weapon/hockeypack/proc/remove_stick()
	if(ismob(packstick.loc))
		var/mob/M = packstick.loc
		M.unEquip(packstick, 1)
	return

/obj/item/weapon/hockeypack/Destroy()
	if (on)
		packstick.unwield()
		remove_stick()
		qdel(packstick)
		packstick = null
	return ..()

/obj/item/weapon/hockeypack/attack_hand(mob/user)
	if(src.loc == user)
		ui_action_click()
		return
	..()

/obj/item/weapon/hockeypack/MouseDrop(obj/over_object)
	var/mob/M = src.loc
	if(istype(M))
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

/obj/item/weapon/hockeypack/attackby(obj/item/W, mob/user, params)
	if(W == packstick)
		remove_stick()
		return
	..()


/mob/proc/getHockeypackSlot()
	return slot_back



/obj/item/weapon/twohanded/hockeystick
	icon_state = "hockeystick0"
	name = "Ka-Nada SSF Hockey Stick"
	desc = "A Ka-Nada specification Power Stick designed after the implement of a violent sport, it is locked to and powered by the back mounted pack."
	force = 5
	w_class = 4
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 25 //Four hits to crit normally, three if they hit a wall each time.
	special_throw = 1
	specthrowsound = 'sound/weapons/resonator_blast.ogg'
	throwforce = 3
	throw_speed = 4
	flags = NOSHIELD | NODROP
	attack_verb = list("smacked", "thwacked", "bashed", "struck", "battered")
	throwforce_mult = 1.4 //More powerful than a baseball bat because it costs 20 fucking tc and more or less denies you any ranged option.
	specthrow_maxwclass = 4 //If you have the time to build a spear on the fly with no backpack to keep the bits in you deserve to be able to chuck it around freely.
	specthrowmsg = "chipped"
	sharpness = IS_SHARP_ACCURATE //Very sharp to make up for the comparativly low damage.
	var/click_delay = 1.3
	var/hit_reflect_chance = 50

	var/obj/item/weapon/hockeypack/pack

/obj/item/weapon/twohanded/hockeystick/update_icon()
	icon_state = "hockeystick[wielded]"
	return

/obj/item/weapon/twohanded/hockeystick/New(parent_pack)
	..()
	if(check_pack_exists(parent_pack, src))
		pack = parent_pack
		loc = pack

	return


/obj/item/weapon/twohanded/hockeystick/attack(mob/living/target, mob/living/user) //Sure it's the powerfist code, right down to the sound effect. Gonna be fun though.

	if(!wielded)
		return ..()

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/limb/affecting = H.get_organ(ran_zone(user.zone_sel.selecting))
		var/armor_block = H.run_armor_check(affecting, "melee")
		target.apply_damage(force, BRUTE, affecting, armor_block)
	else
		target.apply_damage(force, BRUTE)	//If it's a mob but not a humanoid, just give it plain brute damage.

	target.visible_message("<span class='danger'>[target.name] was [pick(attack_verb)] by [user] 'eh!</span>", \
		"<span class='userdanger'>You hear a loud crack 'eh!</span>", \
		"<span class='italics'>You hear the sound of bones crunching 'eh!</span>")

	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	spawn(1)
		target.throw_at(throw_target, 10, 0.2)	//Throws the target 10 tiles

	playsound(loc, specthrowsound, 50, 1)

	add_logs(user, target, "used a hockey stick on", src) //Very unlikeley non-antags are going to get their hands on this but just in case...

	user.changeNext_move(CLICK_CD_MELEE * click_delay)


	return

/obj/item/weapon/twohanded/hockeystick/dropped(mob/user) //The Stick is undroppable but just in case they lose an arm better put this here.
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
		user << "<span class='notice'>The stick is drawn back to the backpack 'eh!</span>"
		loc = pack
	return unwield(user)

/proc/check_pack_exists(parent_pack, mob/living/carbon/human/M, obj/O)
	if(!parent_pack || !istype(parent_pack, /obj/item/weapon/hockeypack))
		M.unEquip(O)
		qdel(0)
		return 0
	else
		return 1

/obj/item/weapon/twohanded/hockeystick/Move()
	..()
	if(loc != pack.loc)
		loc = pack.loc

/obj/item/weapon/twohanded/hockeystick/IsReflect()
	if(wielded && prob(hit_reflect_chance))
		return 1


/obj/item/weapon/storage/belt/hockey
	name = "Holopuck Generator"
	desc = "A Belt mounted device that quickly fabricates hard-light holopucks that when thrown will stall and slow down foes dealing minor damage. Has a pouch to store a pair of spare pucks"
	icon_state = "hockey_belt"
	item_state = "hockey_belt"
	action_button_name = "Produce Puck"
	storage_slots = 2
	flags = NODROP
	can_hold = list(/obj/item/holopuck)
	var/recharge_time = 100
	var/charged = 1
	var/timerid
	var/obj/item/holopuck/newpuck

/obj/item/weapon/storage/belt/hockey/ui_action_click()
	make_puck()

/obj/item/weapon/storage/belt/hockey/verb/make_puck()
	set name = "Produce Puck"
	set category = "Object"
	if (usr.get_item_by_slot(usr.getHockeybeltSlot()) != src)
		usr << "<span class='warning'>The belt must be worn properly to use!</span>"
		return
	if(usr.incapacitated())
		return

	var/mob/living/carbon/human/user = usr

	if(charged != 1)
		user << "<span class='warning'>The generator is still charging!</span>"
		return

	newpuck = build_puck()
	timerid = addtimer(src,"reset_puck",recharge_time)
	if(!user.put_in_hands(newpuck))
		user << "<span class='warning'>You need a free hand to hold the stick!</span>"
		return

	charged = 0

/obj/item/weapon/storage/belt/hockey/proc/build_puck()
	return new /obj/item/holopuck(src)

/mob/proc/getHockeybeltSlot()
	return slot_belt

/obj/item/weapon/storage/belt/hockey/proc/reset_puck()
	charged = 1
	var/mob/M = get(src, /mob)
	M << "<span class='notice'>The belt is now ready to fabricate another holopuck!</span>"


/obj/item/holopuck
	name = "HoloPuck"
	desc = "A small disk of hard light energy that's been electrically charged, will daze and damage a foe on impact."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0"
	item_state = "eshield0"
	w_class = 1
	stamina_percentage = 0.75
	force = 3
	throwforce = 30


/mob/living/carbon/human/hitby(atom/movable/PP, blocked = 0)
	..()
	if(blocked <= 0)
		if(istype(PP, /obj/item/holopuck))
			apply_effect(2, STUN)
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			visible_message("<span class='danger'>[name] has been dazed by a holopuck!</span>", \
											"<span class='userdanger'>[name] has been dazed by a holopuck!</span>")
			qdel(PP)
