/obj/item/weapon/frightbot_chasis
	desc = "A chasis for a new frightbot."
	name = "frightbot chasis"
	icon = 'icons/obj/aibots_new.dmi'
	icon_state = "frightbot_chasis"
	force = 3.0
	throwforce = 5.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0

/obj/item/weapon/frightbot_chasis/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/radio))
		user << "<span class='notice'>You complete the Frightbot! KEEEEEEEEEEE!!!</span>"
		user.drop_item()
		qdel(W)
		var/turf/T = get_turf(src)
		new/obj/machinery/bot/frightbot(T)
		user.unEquip(src, 1)
		qdel(src)

/obj/machinery/bot/frightbot
	name = "frightbot"
	desc = "You'll poop your pants from his scary stories!"
	icon = 'icons/obj/aibots_new.dmi'
	icon_state = "frightbot"
	// layer = 5.0
	density = 0
	anchored = 0
	health = 25
	maxhealth = 25
	var/cooldown = 0
	var/list/frights = list("told a pants-wettingly scary story", "told a story so scary you want to cover your ears",\
							"told a story so incredibly scary that your teeth won't stop chattering", "told a bloodcurdling story",\
							"told a scary story with some deeply touching moments mixed in", "started telling a spine-chilling story",\
							"is making horrible chalkboard-scratching sounds while trying to tell scary stories",\
							"told a story so scary you couldn't help but laugh", "accidentaly told a cute, funny story",\
							"told a story so scary you'll never go to bathroom at night again", "told a story so scary it made your eyes start to tear up")

/obj/machinery/bot/frightbot/explode()
	visible_message("<span class='userdanger'>[src] blows apart!</span>")
	var/turf/T = get_turf(src)
	if(prob(50))
		new /obj/item/device/radio(T)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	qdel(src)

/obj/machinery/bot/frightbot/New()
	..()
	icon_state = "frightbot[on]"

/obj/machinery/bot/frightbot/turn_on()
	..()
	icon_state = "frightbot[on]"

/obj/machinery/bot/frightbot/turn_off()
	..()
	icon_state = "frightbot[on]"

/obj/machinery/bot/frightbot/bot_process()
	if (!..())
		return

	// if(isturf(src.loc))
	// 	var/anydir = pick(cardinal)
	// 	if(Process_Spacemove(anydir))
	// 		Move(get_step(src, anydir), anydir)

	if(cooldown < world.time && prob(20))
		cooldown = world.time + 200
		playsound(loc, 'sound/machines/fright.ogg', 50, 1)
		flick("frightbot_speak", src)
		visible_message("<span class='danger'><b>[src]</b> [pick(frights)]!</span>")