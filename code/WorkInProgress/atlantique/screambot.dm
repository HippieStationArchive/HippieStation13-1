/obj/machinery/bot/screambot
	name = "screambot"
	desc = "SCREAMING INTENSIFIES."
	icon = 'icons/misc/screambot.dmi'
	icon_state = "screambot_on"
	layer = 5.0
	density = 0
	anchored = 0
	var/cooldown = 0

/obj/machinery/bot/screambot/New()
	..()


/obj/machinery/bot/screambot/bot_process()
	if (!..())
		return

	if(isturf(src.loc))
		var/anydir = pick(cardinal)
		if(Process_Spacemove(anydir))
			Move(get_step(src, anydir), anydir)

	if(cooldown < world.time)
		cooldown = world.time + 100
		playsound(loc, pick('sound/voice/screamsilicon.ogg', 'sound/misc/cat.ogg', 'sound/misc/lizard.ogg', 'sound/misc/caw.ogg'), 50, 1, 10, 1.2)
		visible_message("\red <b>[src]</b> screams!")