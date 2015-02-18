//SUPERPOWERS


/mob/living/carbon/human/proc/superscream()
	set name = "MEGA SCREAM"
	set desc = "AAAAAAGHHHH"
	set category = "Super"

	usr.say("AAAAAAGGGGHHHHHHHHHHH!")
//	usr.say("*megascream")
	usr << "You scream like a badass!"
	for(var/obj/structure/window/C in view(src, 5))
		spawn(rand(1,3))
			C.Destroy()
	for(var/mob/living/D in view(src,5))
		if(src == D)
			continue
		shake_camera(D, 3, 1)
		D.paralysis += 1
		if(prob(50))
			D.sdisabilities |= DEAF
			D << "\red You go deaf from [usr]'s scream!"
		if(prob(25))
			D.Dizzy(5)
			D << "\red You feel dizzy!"
		if(prob(1))
			D << "\red Your body can't take anymore!"
			D.gib()


/proc/dolphin()
	ticker.cinematic = new(src)
	ticker.cinematic.icon = 'icons/effects/station_explosion.dmi'
	ticker.cinematic.icon_state = "dolphin"
	ticker.cinematic.layer = 20
	ticker.cinematic.mouse_opacity = 0
	ticker.cinematic.screen_loc = "1,0"
	for(var/mob/living/M in world)
		M.client.screen += 	ticker.cinematic

	sleep(100)
	qdel(ticker.cinematic)