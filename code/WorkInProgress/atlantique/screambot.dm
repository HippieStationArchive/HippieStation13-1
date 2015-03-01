/obj/item/weapon/screambot_chasis
	desc = "A chasis for a new screambot."
	name = "screambot chasis"
	icon = 'icons/obj/aibots_new.dmi'
	icon_state = "screambot_chasis"
	force = 3.0
	throwforce = 5.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/build_step = 0

/obj/item/weapon/screambot_chasis/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool) && build_step <= 0)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			user << "<span class='notice'>You weld some holes in [src].</span>"
			build_step = 1
			desc += " It has weird holes in it that resemble a face."
			icon_state = "screambot_chasis1"
	else if((istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm)) && build_step == 1)
		user << "<span class='notice'>You complete the screambot!</span>"
		user.drop_item()
		qdel(W)
		var/turf/T = get_turf(src)
		new/obj/machinery/bot/screambot(T)
		user.unEquip(src, 1)
		qdel(src)

/obj/machinery/bot/screambot
	name = "screambot"
	desc = "SCREAMING INTENSIFIES."
	icon = 'icons/obj/aibots_new.dmi'
	icon_state = "screambot"
	layer = 5.0
	density = 0
	anchored = 0
	health = 25
	maxhealth = 25
	var/cooldown = 0
	var/speedup = 1
	var/probability = 30
	var/list/sounds = list('sound/misc/scream_f1.ogg', 'sound/misc/scream_f2.ogg', 'sound/misc/scream_m1.ogg', 'sound/misc/scream_m2.ogg', 'sound/voice/screamsilicon.ogg', 'sound/misc/cat.ogg', 'sound/misc/caw.ogg', 'sound/misc/lizard.ogg')

/obj/machinery/bot/screambot/explode()
	visible_message("<span class='userdanger'>[src] blows apart!</span>")
	var/turf/T = get_turf(src)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	qdel(src)

/obj/machinery/bot/screambot/New()
	..()
	icon_state = "screambot[on]"

/obj/machinery/bot/screambot/turn_on()
	..()
	icon_state = "screambot[on]"

/obj/machinery/bot/screambot/turn_off()
	..()
	icon_state = "screambot[on]"

/obj/machinery/bot/screambot/bot_process()
	if (!..())
		return

	if(isturf(src.loc))
		var/anydir = pick(cardinal)
		if(Process_Spacemove(anydir))
			Move(get_step(src, anydir), anydir)

	if(cooldown < world.time && prob(probability)) //Probability so it's not TOO annoying (-atlantique except when its emagged lmao)
		cooldown = world.time + 100 / speedup
		if(sounds.len)
			playsound(loc, pick(sounds), 50, 1, 7, 1.2)
		flick("screambot_scream", src)
		visible_message("<span class='danger'><b>[src]</b> screams!</span>")

/obj/machinery/bot/screambot/emag_act(mob/user as mob)
	if(!emagged)
		emagged = 1
		speedup = 10
		probability = 100
		user << "<span class='warning'>Nice. The screambot is going to be really, REALLY annoying now.</span>"

//MENU

/obj/machinery/bot/screambot/attack_hand(mob/user as mob)
	var/dat = "<div class='statusDisplay'>"
	dat += "Human scream: <A href='?src=\ref[src];action=toggle;scream=human'>[('sound/misc/scream_f1.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Synthesized scream: <A href='?src=\ref[src];action=toggle;scream=silicon'>[('sound/voice/screamsilicon.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Cat scream: <A href='?src=\ref[src];action=toggle;scream=cat'>[('sound/misc/cat.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Lizard scream: <A href='?src=\ref[src];action=toggle;scream=lizard'>[('sound/misc/lizard.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Bird scream: <A href='?src=\ref[src];action=toggle;scream=caw'>[('sound/misc/caw.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	var/datum/browser/popup = new(user, "screambot", name, 300, 300)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/bot/screambot/Topic(href, href_list)
	if(..() || panel_open)
		return

	if(href_list["action"] == "toggle")
		switch(href_list["scream"])
			if("human")
				if('sound/misc/scream_f1.ogg' in sounds)
					sounds -= 'sound/misc/scream_f1.ogg'
					sounds -= 'sound/misc/scream_f2.ogg'
					sounds -= 'sound/misc/scream_m1.ogg'
					sounds -= 'sound/misc/scream_m2.ogg'
				else
					sounds += 'sound/misc/scream_f1.ogg'
					sounds += 'sound/misc/scream_f2.ogg'
					sounds += 'sound/misc/scream_m1.ogg'
					sounds += 'sound/misc/scream_m2.ogg'
			if("silicon")
				if('sound/voice/screamsilicon.ogg' in sounds)
					sounds -= 'sound/voice/screamsilicon.ogg'
				else
					sounds += 'sound/voice/screamsilicon.ogg'
			if("cat")
				if('sound/misc/cat.ogg' in sounds)
					sounds -= 'sound/misc/cat.ogg'
				else
					sounds += 'sound/misc/cat.ogg'
			if("lizard")
				if('sound/misc/lizard.ogg' in sounds)
					sounds -= 'sound/misc/lizard.ogg'
				else
					sounds += 'sound/misc/lizard.ogg'
			if("caw")
				if('sound/misc/caw.ogg' in sounds)
					sounds -= 'sound/misc/caw.ogg'
				else
					sounds += 'sound/misc/caw.ogg'

	updateUsrDialog()
	return