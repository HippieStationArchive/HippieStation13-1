/obj/machinery/bot/buttbot
	name = "buttbot"
	desc = "It's a robotic butt. Are you dense or something??"
	icon_state = "buttbot"
	layer = 5.0
	density = 0
	anchored = 0
	flags = HEAR
	var/cooldown = 0
	var/list/speech_buffer = list()
	var/list/speech_list = list("butt.", "butts.", "ass.", "fart.", "assblast usa", "woop get an ass inspection", "woop") //Hilarious.

/obj/machinery/bot/buttbot/New()
	..()
	// src.update_icon() //Is this neccesary?

/obj/machinery/bot/buttbot/bot_process()
	if (!..())
		return

	if(isturf(src.loc))
		var/anydir = pick(cardinal)
		if(Process_Spacemove(anydir))
			Move(get_step(src, anydir), anydir)

	if(prob(5) && cooldown < world.time)
		cooldown = world.time + 100 //10 seconds
		if(prob(70) && speech_buffer.len)
			speak(buttificate(pick(speech_buffer)))
			if(prob(5))
				speech_buffer.Remove(pick(speech_buffer)) //so they're not magic wizard guru buttbots that hold arcane information collected during an entire round.
		else
			speak(pick(speech_list))

/obj/machinery/bot/buttbot/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq)
	if(speaker != src && prob(40)) //Dont imitate ourselves
		if(speech_buffer.len >= 20)
			speech_buffer -= pick(speech_buffer)
		speech_buffer |= html_decode(raw_message)
	..()

/obj/item/clothing/head/butt
	name = "butt"
	desc = "extremely treasured body part"
	icon = 'icons/misc/newbutt.dmi'
	icon_state = "butt"
	item_state = "butt"
	throwforce = 5
	force = 5
	hitsound = 'sound/misc/fart.ogg'
	var/subjectname = ""
	var/subjectjob = null
	var/hname = ""
	var/job = null

/obj/item/clothing/head/butt/attackby(var/obj/item/W, mob/user as mob) // copypasting bot manufucturing process, im a lazy fuck

	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		user.drop_item()
		del(W)
		var/turf/T = get_turf(src.loc)
		new /obj/machinery/bot/buttbot(T)
		user << "<span class='notice'>You add the robot arm to the butt and... What?</span>"
		user.drop_item(src)
		qdel(src)


//What the hell is this?
/datum/recipe/butt
	make(var/obj/container as obj)
		var/human_name //these should work for ANYTHING
		var/human_job
		for (var/obj/item/clothing/head/butt/B in container)
			if (!B.subjectname)
				continue
			human_name = B.subjectname
			human_job = B.subjectjob
			break
		var/lastname_index = findtext(human_name, " ")
		if (lastname_index)
			human_name = copytext(human_name,lastname_index+1)

		var/obj/item/clothing/head/butt/BB = ..(container)
		BB.name = human_name+BB.name
		BB.job = human_job
		return BB

	items = list(
		/obj/item/clothing/head/butt
	)
	result = /obj/item/clothing/head/butt //does this matter in some way ? ? ?