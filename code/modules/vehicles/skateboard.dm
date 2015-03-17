/obj/structure/stool/bed/chair/janicart/skateboard
	name = "skateboard"
	desc = "Do you guys want to go skateboards?"
	icon_state = "skate"
	var/emagged = 1
	var/canmove = 0
	var/ultimate = 0
	var/points = 0
	Bump(atom/A as mob|obj|turf|area)
		if(buckled_mob)
			if(ultimate)
				ultimate = 0
				unbuckle()
				explosion(src.loc, 0, 0, 0, adminlog = 1, flame_range = 1)
			buckled_mob.Stun(2)
			buckled_mob.Weaken(1)
			buckled_mob.stop_pulling()
			buckled_mob.adjustBruteLoss(2)

			buckled_mob.visible_message(\
				"<span class='notice'>[buckled_mob] steps falls of his skateboard. What a tool!</span>",\
				"<span class='notice'>You collide with the [A.name] and fall off your skateboard. Idiot.</span>")
			unbuckle()
			playsound(src.loc, 'sound/misc/collide.ogg', 75, 1)
	Move()
		if(canmove)
			return
		else
			for(var/mob/living/carbon/human/X in src.loc)
				if(buckled_mob == X)
					continue
				var/V = rand(1,4)
				if(ultimate)
					trick4(X)
				else
					switch(V)
						if(1)
							trick1()
						if(2)
							trick2()
						if(3)
							trick3()
						if(4)
							trick()
		playsound(src.loc, 'sound/misc/cruise.ogg', 75, 1)
		..()


/obj/structure/stool/bed/chair/janicart/skateboard/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle()
	else
		step(src, direction)
		update_mob()
		handle_rotation()

/obj/structure/stool/bed/chair/janicart/skateboard/examine()
	return

/obj/structure/stool/bed/chair/janicart/skateboard/proc/trick()//The Greytide
	SpinAnimation(7, 1)
	buckled_mob.SpinAnimation(7, 1)
	buckled_mob.visible_message(\
		"<span class='notice'>Wow! [buckled_mob] performed <b>The Greytide</b> and earned [pick("100","200","300")] points!.</span>",\
		"<span class='notice'>Nice! You performed <b>The Greytide</b></span>")
/obj/structure/stool/bed/chair/janicart/skateboard/update_mob()
	if(buckled_mob)
		buckled_mob.dir = dir
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(WEST)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4

/obj/structure/stool/bed/chair/janicart/skateboard/unbuckle()
	if(ultimate)
		usr << "You try to get off the skateboard but a super natural force compels you to stay on!"
	else
		..()

/obj/structure/stool/bed/chair/janicart/skateboard/proc/trick1()//The Yakkity Sax
	animate(buckled_mob,pixel_y=30,time=10)
	buckled_mob.SpinAnimation(7, 1)
	buckled_mob.visible_message(\
		"<span class='notice'>Totally tubular! [buckled_mob] performed <b>The Assistant Shuffle</b> and earned [pick("100","200","300")] points!.</span>",\
		"<span class='notice'>Nice! You performed <b>The Assistant Shuffle</b></span>")
/obj/structure/stool/bed/chair/janicart/skateboard/proc/trick2()//Thespanner
	buckled_mob.visible_message(\
		"<span class='notice'>Cool! [buckled_mob] performed <b>The Spanner</b> and earned [pick("100","200","300")] points!.</span>",\
		"<span class='notice'>Nice! You performed <b>The Spanner</b></span>")
	buckled_mob.dir = SOUTH
	spawn(1)
		buckled_mob.dir = WEST
		spawn(1)
			buckled_mob.dir = EAST
			spawn(1)
				buckled_mob.dir = NORTH


/obj/structure/stool/bed/chair/janicart/skateboard/proc/trick3()//The griefy assistant
	animate(buckled_mob,pixel_y=20,time=10)
	SpinAnimation(7, 1)
	buckled_mob.visible_message(\
		"<span class='notice'>Far out! [buckled_mob] performed <b>The Griefing Assistant</b> and earned [pick("100","200","300")] points!.</span>",\
		"<span class='notice'>Nice! You performed <b>The Griefing Assistant</b></span>")
/obj/structure/stool/bed/chair/janicart/skateboard/proc/trick4(var/mob/living/C)
	SpinAnimation(7, 1)
	animate(buckled_mob,pixel_y=20,time=10)
	var/obj/effect/lightning/L = new /obj/effect/lightning()
	L.loc = get_turf(loc)
	L.layer = layer+1 //i want it to display over clothing
	L.start()
	spawn(20)
		del(L)