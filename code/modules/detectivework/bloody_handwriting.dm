/obj/effect/decal/cleanable/scribble
	name = "scribble"
	desc = "Something is written here..."
	icon = 'icons/effects/writing.dmi'
	icon_state = "writing1"
	random_icon_states = list("writing1", "writing2", "writing3", "writing4", "writing5")
	gender = NEUTER
	layer = 2.1 //Slightly higher layer than blood so you can see it
	blood_DNA = list()
	var/info //What's actually written on the scribble.
	var/basecolor = "#FFFFFF" //Pure white. #A10808 is blood.

/obj/effect/decal/cleanable/scribble/New()
	..()
	update_icon()

/obj/effect/decal/cleanable/scribble/update_icon()
	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

/obj/effect/decal/cleanable/scribble/examine(mob/user)
	..()
	if(in_range(user, src))
		user << "It reads: <span class='notice'>\"[info]\"</span>"
	else
		user << "<span class='notice'>It is too far away.</span>"

/obj/effect/decal/cleanable/scribble/attack_ai(mob/living/silicon/ai/user)
	var/dist
	if(istype(user) && user.current) //is AI
		dist = get_dist(src, user.current)
	else //cyborg or AI not seeing through a camera
		dist = get_dist(src, user)
	if(dist < 2)
		user << "It reads: <span class='notice'>\"[info]\"</span>"
	else
		user << "It reads: <span class='notice'>\"[stars(info)]\"</span>"

/mob/living/carbon/human/proc/bloody_doodle(var/turf/simulated/T as turf in view(1)) //Has rightclick functionality thanks to the args
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	// if (src.stat) //We need this commented out for death messages.
	// 	return

	if (usr != src)
		return 0 //something is terribly wrong

	var/blood_amt = bloody_hands
	var/bloodmob = bloody_hands_mob
	var/bloodcolor = hand_blood_color
	var/list/transferDNA = hand_blood_DNA
	var/obj/item/clothing/gloves/G
	if (src.gloves)
		G = src.gloves
		blood_amt = G.transfer_blood
		bloodmob = G.bloody_hands_mob
		bloodcolor = G.blood_color
		transferDNA = G.blood_DNA

	if (bloody_hands <= 0)
		if(G) //Gloves exist
			if(G.transfer_blood <= 0) //No blood on gloves? No blood on hands? Remove verb.
				verbs -= /mob/living/carbon/human/proc/bloody_doodle
		else //Welp, gloves don't exist, fuck bloody doodles.
			verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if(blood_amt <= 0)
		return
		// if(src.client)
		// 	src.client.verbs -= client/proc/bloody_doodle

	var/turf/simulated/S = src.loc
	if (!istype(S)) //to prevent doodling out of mechs and lockers
		src << "<span class='warning'>You cannot reach the floor.</span>"
		return

	// if (!istype(T)) //No argument - we're probably calling this from the verbs list. REDUNDANT. Already lets you pick a tile.
	// 	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	// 	if(direction != "Here")
	// 		T = get_step(T,text2dir(direction))

	if (!istype(T))
		src << "<span class='warning'>You cannot doodle there.</span>"
		return

	//Let's have INFINITE DOODLES for now
	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/scribble/W in T)
		num_doodles++
	if (num_doodles > 8) //doodles max, that's quite a lot.
		src << "<span class='warning'>There is no space to write on!</span>"
		return

	var/message = ""
	var/max_length = blood_amt * 30 //tweeter style
	var/msg = "Write a message. It cannot be longer than [max_length] characters."
	if(max_length > 0) //Check if we actually WROTE a message.
		if(InCritical()) //We're critical!
			if(stat == UNCONSCIOUS) //We're unconscious... Attempting to write blood like this will kill you off, similar to deathwhisper.
				msg += "\n<span class='userdanger'>WARNING!</span> You will use up the last of your strength to leave a death message!\nLeave the message blank if you want to cancel."

	message = stripped_input(src,"[msg]","Blood writing", "")

	if (message && src.loc == S) //Check if message exists and user's location didn't change.
		var/used_blood_amount = max(1, round(length(message) / 30)) //To make sure we use up 1 blood even for the smallest messages
		blood_amt = max(0, blood_amt - used_blood_amount) //use up some blood
		if(G)
			G.transfer_blood = blood_amt
		else
			bloody_hands = blood_amt
		src << "<span class='warning'>You used [used_blood_amount] blood. [blood_amt]</span>" //DEBUG
		if (length(message) > max_length)
			message = copytext(message,1,max_length) //Why wasn't this here before
			message += "-"
			src << "<span class='warning'>You ran out of blood to write with!</span>"

		var/obj/effect/decal/cleanable/scribble/W = new(T)
		if(istype(T, /turf/simulated/wall)) //Handle writings similar to palmprints
			W.loc = src.loc //change location of writings to user's so they can't be seen from all directions
			var/blooddir = get_dir(src, T)
			//Adjust pixel offset to make writings appear on the wall
			W.pixel_x = blooddir & EAST ? 32 : (blooddir & WEST ? -32 : 0)
			W.pixel_y = blooddir & NORTH ? 32 : (blooddir & SOUTH ? -32 : 0)
			//Randomise pixel offset + adjust it accordingly from the center
			W.pixel_x += blooddir & EAST ? -rand(6, 11) : (blooddir & WEST ? rand(6, 11) : rand(-7, 7))
			W.pixel_y += blooddir & NORTH ? -rand(6, 11) : (blooddir & SOUTH ? rand(6, 11) : rand(-7, 7))
		else
			W.pixel_x = rand(-8, 8)
			W.pixel_y = rand(-8, 8)

		W.basecolor = (bloodcolor) ? bloodcolor : "#CC0303"
		W.update_icon()
		W.info = message
		W.desc = "It's written in blood..."
		W.add_fingerprint(src)
		if(bloodmob)
			W.add_blood_list(bloodmob)
		else
			W.blood_DNA |= transferDNA.Copy()

		if(InCritical())
			if(stat == UNCONSCIOUS)
				succumb(1) //rip in peace
				src << "<span class='warning'>You use up the last of your strength to write this death message: </span><span class='notice'><i>\"[message]\"</i></span>"
			else
				adjustOxyLoss(9 + used_blood_amount) //Oxygen counts as "strength" for critical, so we'll decrease that. Writing a lengthy message is also going to kill you off faster.
				src << "<span class='warning'>You feel weaker after writing the message...</span>"