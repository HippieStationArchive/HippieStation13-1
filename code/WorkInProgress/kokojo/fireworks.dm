//Ce-le-bra-tion! By Lcass and Koko

/obj/effect/sparkle
	name = "Sparkle"
	desc = "Ooh shiny!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = ""
	mouse_opacity = 0
	luminosity = 4
	layer = 10//just for safety measures hehe no pun intended
	pixel_x = -32
	pixel_y = 21

/obj/effect/sparkle/New()
	..()
	color = pick("#FF0000","#0000FF","#00FF00")
	icon_state = pick("fireworks1","fireworks2","fireworks3")
	playsound(src, pick('sound/effects/fireworks1.ogg', 'sound/effects/fireworks2.ogg' ), 100, 1)
	spawn(8)
		qdel(src)

/obj/item/toy/firework
	name = "Firework"
	desc = "What do you call a duck who likes watching fireworks? A firequacker."
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	force = 0
	icon = 'icons/obj/toy.dmi'
	icon_state = "firework_prepared"
	item_state = "firework"
	w_class = 2.0
	var/littime = 4
	var/userdanger = 0
	var/lit = 0

/obj/item/toy/firework/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] puts the [src.name] in \his mouth and lights it! It looks like \he's trying to commit suicide.</span>")
	src.lit = 1
	src.littime = 0
	return (FIRELOSS)


//stolen from cigarettes, of course
/obj/item/toy/firework/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	..()
	var/lighting_text = "<span class='notice'>[user] lights the [name] with [W].</span>"
	if(istype(W, /obj/item/weapon/weldingtool))
		lighting_text = "<span class='notice'>[user] casually lights the [name] with [W], what a fool!.</span>"
		userdanger = 4
	else if(istype(W, /obj/item/weapon/lighter/zippo))
		lighting_text = "<span class='rose'>With a really cool motion, [user] lights the [name] with [W].</span>"
		userdanger = 1
	else if(istype(W, /obj/item/weapon/lighter))
		lighting_text = "<span class='notice'>[user] lights the [name] with [W].</span>"
		userdanger = 1
	else if(istype(W, /obj/item/weapon/melee/energy))
		userdanger = 4
		lighting_text = "<span class='warning'>[user] swings their [W] at the [name] and lights it!</span>"
	else if(istype(W, /obj/item/device/assembly/igniter))
		lighting_text = "<span class='notice'>[user] fiddles with [W], and manages to light the [name].</span>"

	else if(istype(W, /obj/item/device/flashlight/flare))
		lighting_text = "<span class='notice'>[user] lights the [name] with [W]. Isin't that dangerous?</span>"
		userdanger = 4
	if(is_hot(W))
		light(lighting_text)
	return

/obj/item/toy/firework/proc/light(var/flavor_text = null)
	if(!src.lit)
		src.lit = 1
		icon_state = "firework_fire"
		processing_objects.Add(src)
		if(flavor_text)
			var/turf/T = get_turf(src)
			T.visible_message(flavor_text)


/obj/item/toy/firework/process()
	var/turf/location = get_turf(src)
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	littime--
	userdanger--

	if(prob(15) && userdanger && littime < 1)
		icon_state = "firework_flight"
		visible_message("<span class='userdanger'>[src] was damaged and spins off!</span>")
		if(isliving(loc))
			M.fire_stacks = min(5,M.fire_stacks + 5)
			M.IgniteMob()
		littime = 100 //don't want double explosion do we?
		throwforce = 15
		var/atom/throw_target = get_edge_target_turf(src, pick(cardinal))
		src.throw_at(throw_target, 7, 1)
		spawn(rand(2, 4))
			processing_objects.Remove(src)
			explode()
	if(littime < 1)
		processing_objects.Remove(src)
		explode()
		return
	if(location)
		location.hotspot_expose(700, 5)


/obj/item/toy/firework/proc/explode()
	icon_state = "firework_flight"
	playsound(src, 'sound/effects/fireworkstart.ogg', 40, 1, 1)
	var/mob/living/M = loc
	if(isliving(loc))
		playsound(src, pick('sound/effects/fireworks1.ogg', 'sound/effects/fireworks2.ogg' ), 100, 1)
		explosion(get_turf(loc), 0, 0, 1, 1)
		M.fire_stacks = min(5,M.fire_stacks + 5)
		M.IgniteMob()
		qdel(src)
	else
		src.dir = 1
		animate(src, pixel_y = 4, time = 2)
		spawn(2)
			animate(src, pixel_y = 13, time = 2)
			spawn(2)
				animate(src, pixel_y = 21, time = 2)
				spawn(2)
					for(var/mob/living/carbon/human/L in range(1, src))
						L.eye_blurry += 2
					visible_message("<span class='userdanger'>[src] explodes!</span>")
					var/obj/effect/sparkle/S = new /obj/effect/sparkle(src.loc)
					animate(S, alpha = 100, time = 10)//add something to the pixel_y bit to make it curve.
					qdel(src)