/mob/living/carbon/human/
	var/stage = 0 //What stage in the tutorial the mob is in

/obj/screen/tutorialbasics
	icon ='icons/vehicles/starship.dmi'
	icon_state="body"
	screen_loc = "8,5"
	var/arrow
	var/mob/living/carbon/human/body
	var/obj/screen/tempscreen = null
		//		S1.client.screen += new /obj/screen/exit//
					//			usr.client.screen -= locate(/obj/screen/exit)in usr.client.screen


	Click()
		if (ticker.current_state == 3)
			if(!body)
				body = usr.client.mob
		else
			usr.client.mob << "\red The game has not started yet!"
		switch(body.stage)
			if(0)
				body << "Tutorial loaded. Please click again."
				body.stage = 2
			if(2)
				body << "Welcome to <b>Hippie Station 13</b>. Click this button to continue through the tutorial. Arrows will appearing indicating specific things."
				body.stage = 3
			if(3)
				body << "<br><b>Movement</b>: You can do basic movements via the arrow keys. You can walk through doors you have access to just by walking into them. Why not try it out?"
				body.stage = 4
			if(4)
				body << "<br><b>HUD</b>: Over here is your hud; you can find your current oxygen, pressure, temperatures and health over here."
				tempscreen = new/obj/screen/arrow
				body.client.screen += tempscreen
				tempscreen.screen_loc = "14,8"
				body.stage = 5
			if(5)
				body << "<b>Internals</b>: This button over here controls your air tanks internals. Click it to cycle between on and off."
				tempscreen.screen_loc = "14,8"
				body.stage = 6
			if(6)
				body << "<b>Health</b>: This figure represents your health. As you take damage it will change color based on how much health you have left. \green Green is the best, \red Red is the worst."
				tempscreen.screen_loc = "14,7"
				body.stage = 7
			if(7)
				body << "<b>Hands</b>: These things here are your hands. You have two. Everyone has two. You can only carry one thing at a time in each hand. If you were to fall over by any means, you will drop the items in your hands. Press the <b>Swap</b> button or <b>Middle-Mouse Click</b> to switch hands."
				tempscreen.screen_loc = "8,2"
				tempscreen.icon_state = "arrowdown"
				body.stage = 8
			if(8)
				body << "<b>Intent</b>: Whenever you click someone; your intent decides what you do to them. <b>Help Intent</b> will allow you to get people off the floor as well as not cause you to hurt them when clicked. <b>Disarm Intent</b> will give you a chance to knock whatever the person you clicked is holding out of their hand and sometimes push them to the floor. <b>Grab Intent</b> will grab onto the person allowing you to pull them as well as allows you to suffocate them. <b>Harm Intent</b> allows you to punch the person."
				tempscreen.screen_loc = "14,2"
				body.stage = 9
			if(9)
				body << "<b>Equipment</b>: Over here is the button that shows all of your equipped equipment and articles of clothing. Close it by clicking it again. All of the other buttons included and around that menu are your equipment and clothing that are equipped."
				tempscreen.screen_loc = "1,2"
				body.stage = 10
			if(10)
				body << "Why don't you get more used to the controls? Walking around is a good start! If you have any questions; hit your F1 key!"
				del(tempscreen)
				tempscreen = null
				body.stage = 11
				body.client.screen -= locate(/obj/screen/tutorialbasics)in usr.client.screen
				body.unlock_achievement("All There in the Manual")

/obj/screen/arrow/
	name = "arrow"
	desc = "Get the point?"
	icon = 'icons/scooterstuff.dmi'
	icon_state = "arrowright"