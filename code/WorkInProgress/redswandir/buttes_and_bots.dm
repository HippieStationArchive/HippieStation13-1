/obj/machinery/bot/buttbot
	name = "buttbot"
	desc = "It's a robotic butt. Are you dense or something??"
	icon_state = "buttbot"
	layer = 5.0
	density = 0
	anchored = 0
	flags = HEAR
	health = 25
	maxhealth = 25
	// bubble_type = "h"
	var/xeno = 0 //Do we hiss when buttspeech?
	var/cooldown = 0
	var/list/speech_buffer = list()
	var/list/speech_list = list("butt.", "butts.", "ass.", "fart.", "assblast usa", "woop get an ass inspection", "woop") //Hilarious.

/obj/machinery/bot/buttbot/New()
	..()
	if(xeno)
		icon_state = "buttbot_xeno"
		bubble_type = "A" //make alien speech bubbles
		speech_list = list("hissing butts", "hiss hiss motherfucker", "nice trophy nerd", "butt", "woop get an alien inspection")

/obj/machinery/bot/buttbot/explode()
	visible_message("<span class='userdanger'>[src] blows apart!</span>")
	var/turf/T = get_turf(src)

	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)
	if(xeno)
		new /obj/item/organ/butt/xeno(T)
	else
		new /obj/item/organ/butt(T)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	// new /obj/effect/decal/cleanable/oil(loc)
	qdel(src)

/obj/machinery/bot/buttbot/bot_process()
	if (!..())
		return

	if(isturf(src.loc))
		var/anydir = pick(cardinal)
		if(Process_Spacemove(anydir))
			Move(get_step(src, anydir), anydir)

	if(prob(5) && cooldown < world.time)
		cooldown = world.time + 200 //20 seconds
		if(xeno) //Hiss like a motherfucker
			playsound(loc, "hiss", 15, 1, 1)
		if(prob(70) && speech_buffer.len)
			speak(buttificate(pick(speech_buffer)))
			if(prob(5))
				speech_buffer.Remove(pick(speech_buffer)) //so they're not magic wizard guru buttbots that hold arcane information collected during an entire round.
		else
			speak(pick(speech_list))

/obj/machinery/bot/buttbot/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq)
	//Also dont imitate ourselves. Imitate other buttbots though heheh
	if(speaker != src && prob(40))
		if(speech_buffer.len >= 20)
			speech_buffer -= pick(speech_buffer)
		speech_buffer |= html_decode(raw_message)
	..()

/obj/item/organ/butt //Made it an organ so it doesn't count as a cavity implant anymore
	name = "butt"
	desc = "extremely treasured body part"
	icon = 'icons/misc/newbutt.dmi'
	icon_state = "butt"
	item_state = "butt"
	throwforce = 5
	force = 5
	hitsound = 'sound/misc/fart.ogg'
	throwhitsound = 'sound/misc/fart.ogg' //woo
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	embedchance = 5 //This is a joke
	//These are not used
	// var/subjectname = ""
	// var/subjectjob = null
	// var/hname = ""
	// var/job = null

/obj/item/organ/butt/xeno //XENOMORPH BUTTS ARE BEST BUTTS
	name = "alien butt"
	desc = "best trophy ever"
	icon_state = "xenobutt"
	item_state = "xenobutt"

/obj/item/organ/butt/attackby(var/obj/item/W, mob/user as mob) // copypasting bot manufucturing process, im a lazy fuck

	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		user.drop_item()
		del(W)
		var/turf/T = get_turf(src.loc)
		var/obj/machinery/bot/buttbot/B = new(T)
		if(istype(src, /obj/item/organ/butt/xeno))
			B.xeno = 1
			B.icon_state = "buttbot_xeno"
			B.bubble_type = "A" //make alien speech bubbles
			B.speech_list = list("hissing butts", "hiss hiss motherfucker", "nice trophy nerd", "butt", "woop get an alien inspection")
		user << "<span class='notice'>You add the robot arm to the butt and... What?</span>"
		user.drop_item(src)
		qdel(src)


//What the hell is this?
// /datum/recipe/butt
// 	make(var/obj/container as obj)
// 		var/human_name //these should work for ANYTHING
// 		var/human_job
// 		for (var/obj/item/organ/butt/B in container)
// 			if (!B.subjectname)
// 				continue
// 			human_name = B.subjectname
// 			human_job = B.subjectjob
// 			break
// 		var/lastname_index = findtext(human_name, " ")
// 		if (lastname_index)
// 			human_name = copytext(human_name,lastname_index+1)

// 		var/obj/item/organ/butt/BB = ..(container)
// 		BB.name = human_name+BB.name
// 		BB.job = human_job
// 		return BB

// 	items = list(
// 		/obj/item/organ/butt
// 	)
// 	result = /obj/item/organ/butt //does this matter in some way ? ? ?