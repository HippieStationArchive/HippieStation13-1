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
//roman candle
/obj/effect/centre_explosion
	name = "Firework"
	desc = "Ooh shiny!"
	icon = 'icons/wip/firework.dmi'
	icon_state = "centre"

	New(var/list/source = list(0,0),var/loc = null)
		if(loc)
			src.loc = loc
		color = rgb(rand(125,255),rand(125,255),rand(125,255),150)
		pixel_x = source[1]
		pixel_y = source[2]
		spawn(5)
			qdel(src)
/obj/effect/romansparkle
	name = "Firework"
	desc = "Ooh shiny!"
	icon = 'icons/wip/firework.dmi'
	icon_state = "particle1"
	var/list/vector_dir
	var/fall = 0.05
	var/life_span//how long the particle will live for before destroying itself
	var/list/start
	var/velocity = 3
	layer = 10//just for safety measures hehe no pun intended

	New(var/list/source = list(16,16),var/col = null)//start at the centre of the tile and work outwards
		//iconpicking madness
		if(col)
			color = col
		//init vars
		life_span = rand(8,15)
		//setup pixels
		pixel_x = rand(source[1] - 16,source[1] + 16)
		pixel_y = rand(source[2] - 16,source[2] + 16)//move it around a bit , allows it to have off centre fireworks
		vector_dir = list(pixel_x - source[1],pixel_y - source[2])
		start = source
	proc/move()
		animate(src, pixel_x = (pixel_x + vector_dir[1]) * velocity, pixel_y = ((pixel_y + vector_dir[2]) - (vector_dir[2] * fall * vector_dir[2])) * velocity , alpha = 15, time = life_span, loop = 1)//add something to the pixel_y bit to make it curve.
		spawn(life_span)
			qdel(src)

/obj/item/projectile/energy/candle
	name = "Roman Candle Firework"
	icon = 'icons/obj/toy.dmi'
	icon_state = "firework_flight"
	damage = 10
	range = 4

/obj/item/projectile/energy/candle/New()
	range = rand(range , range + 3)
	pixel_x = rand(-16,32) // from ranges + 16 to - 16 , give it some variation I could calculate angles and rotate but that would just be horrific :/
	pixel_y = rand(-16,32)
	hitsound = pick('sound/effects/fireworks1.ogg', 'sound/effects/fireworks2.ogg' )

/obj/item/projectile/energy/candle/on_hit(var/atom/target, var/blocked = 0)
	var/particles = rand(45,70)
	//moar sounds
	part_explode(amount = particles)


/obj/item/projectile/energy/candle/on_range() //to ensure the bolt sparks when it reaches the end of its range if it didn't hit a target yet
	var/particles = rand(45,70)
	//and another sound
	playsound(src, hitsound, 40, 1, 1)
	part_explode(amount = particles)

/obj/item/projectile/energy/candle/proc/part_explode(var/amount = 50)
	var/setup = rgb(rand(125,255),rand(125,255),rand(125,255),230)
	new /obj/effect/centre_explosion(source = list(src.pixel_x,src.pixel_y),loc = src.loc)
	for(var/i = 0 , i < amount , i++)
		var/obj/effect/romansparkle/proj = new /obj/effect/romansparkle(source = list(src.pixel_x,src.pixel_y),col = setup)
		setup = rgb(rand(125,255),rand(125,255),rand(125,255),230)
		proj.loc = src.loc
		proj.move()
	qdel(src)

/obj/structure/firework/roman
	name = "Roman Candle"
	desc = "Because explosives are just that much more fun on a space station!"
	icon = 'icons/wip/firework.dmi'
	icon_state = "Roman"
	density = 1
	layer = 3.5
	var/triggered = 0
	pixel_y = -16

/obj/structure/firework/roman/trigger(var/mob/living/user)
	//play sound of a fuse or something
	if(triggered)
		return
	triggered = 1
	//fuse
	icon_state = "Roman_lit"
	sleep(25)
	var/shots = 10
	for(var/i = 0, i < shots , i++)
		//sound goes here init
		playsound(src, 'sound/effects/fireworkstart.ogg', 40, 1, 1)
		var/obj/item/projectile/energy/candle/A = new /obj/item/projectile/energy/candle(src.loc)
		A.yo = 5
		A.xo = 0
		A.fire()
		sleep(15)
	//set sprite
	icon_state = "Roman"

//stolen from kokojo of course
/obj/structure/firework/roman/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(triggered)
		user<<"This [src.name] looks used up , probably won't light."
		return
	..()
	var/lighting_text = "<span class='notice'>[user] lights the [name] with [W].</span>"
	if(istype(W, /obj/item/weapon/weldingtool))
		lighting_text = "<span class='notice'>[user] casually lights the [name] with [W], what a fool!.</span>"
	else if(istype(W, /obj/item/weapon/lighter/zippo))
		lighting_text = "<span class='rose'>With a really cool motion, [user] lights the [name] with [W].</span>"
	else if(istype(W, /obj/item/weapon/lighter))
		lighting_text = "<span class='notice'>[user] lights the [name] with [W].</span>"
	else if(istype(W, /obj/item/weapon/melee/energy))
		lighting_text = "<span class='warning'>[user] swings their [W] at the [name] and lights it!</span>"
	else if(istype(W, /obj/item/device/assembly/igniter))
		lighting_text = "<span class='notice'>[user] fiddles with [W], and manages to light the [name].</span>"
	else if(istype(W, /obj/item/device/flashlight/flare))
		lighting_text = "<span class='notice'>[user] lights the [name] with [W]. Isin't that dangerous?</span>"
	if(is_hot(W))
		user<<lighting_text
		trigger(user)
/obj/structure/firework/proc/trigger()
/