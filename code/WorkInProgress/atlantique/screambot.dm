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

	if(cooldown < world.time && prob(30)) //Probability so it's not TOO annoying
		cooldown = world.time + 100
		playsound(loc, pick('sound/voice/screamsilicon.ogg', 'sound/misc/cat.ogg', 'sound/misc/lizard.ogg', 'sound/misc/caw.ogg'), 50, 1, 7, 1.2)
		flick("screambot_scream", src)
		visible_message("<span class='danger'><b>[src]</b> screams!</span>")