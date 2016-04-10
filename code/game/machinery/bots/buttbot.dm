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
	var/xeno = 0 //Do we hiss when buttspeech?
	var/cooldown = 0
	var/list/speech_buffer = list()
	var/list/speech_list = list("butt.", "butts.", "ass.", "fart.", "assblast usa", "woop get an ass inspection", "woop") //Hilarious.

/obj/machinery/bot/buttbot/New()
	..()
	if(xeno)
		icon_state = "buttbot_xeno"
		speech_list = list("hissing butts", "hiss hiss motherfucker", "nice trophy nerd", "butt", "woop get an alien inspection")

/obj/machinery/bot/buttbot/explode()
	visible_message("<span class='userdanger'>[src] blows apart!</span>")
	var/turf/T = get_turf(src)

	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)
	if(xeno)
		new /obj/item/organ/internal/butt/xeno(T)
	else
		new /obj/item/organ/internal/butt(T)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	// new /obj/effect/decal/cleanable/blood/oil(loc)
	..() //qdels us and removes us from processing objects

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
