/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null, var/special = 0)
	var/param = null
	var/delay = 5
	var/exception = null
	if(src.spam_flag == 1)
		return
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/silent = is_muzzled()
	var/muzzled = is_muzzled()
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	var/miming=0
	if(mind)
		miming=mind.miming

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	switch(act) //Please keep this alphabetically ordered when adding or changing emotes.
		if ("aflap") //Any emote on human that uses miming must be left in, oh well.
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings ANGRILY!"
				m_type = 2

		if ("choke")
			if (miming)
				message = "<B>[src]</B> clutches \his throat desperately!"
			else
				..(act)

		if ("chuckle")
			if(miming)
				message = "<B>[src]</B> appears to chuckle."
			else
				..(act)

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> collapses!"
			m_type = 2

		if ("cough")
			if (miming)
				message = "<B>[src]</B> appears to cough!"
			else
				if (!muzzled)
					var/sound = pick('sound/misc/cough1.ogg', 'sound/misc/cough2.ogg', 'sound/misc/cough3.ogg', 'sound/misc/cough4.ogg')
					if(gender == FEMALE)
						sound = pick('sound/misc/cough_f1.ogg', 'sound/misc/cough_f2.ogg', 'sound/misc/cough_f3.ogg')
					playsound(src.loc, sound, 50, 1, 5)
					if(nearcrit)
						message = "<B>[src]</B> coughs painfuly!"
					else
						message = "<B>[src]</B> coughs!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("cry")
			if (miming)
				message = "<B>[src]</B> cries."
			else
				if (!muzzled)
					message = "<B>[src]</B> cries."
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise. \He frowns."
					m_type = 2

		if ("custom")
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			if(copytext(input,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if(miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

		if ("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings."
				m_type = 2

		if ("gasp")
			if (miming)
				message = "<B>[src]</B> appears to be gasping!"
			else
				..(act)

		if ("giggle")
			if (miming)
				message = "<B>[src]</B> giggles silently!"
			else
				..(act)

		if ("groan")
			if (miming)
				message = "<B>[src]</B> appears to groan!"
			else
				if (!muzzled)
					if(nearcrit)
						message = "<B>[src]</B> groans in pain!"
					else
						message = "<B>[src]</B> groans!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a loud noise."
					m_type = 2

		if ("grumble")
			if (!muzzled)
				message = "<B>[src]</B> grumbles!"
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if ("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					message = "<B>[src]</B> hugs \himself."

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if(miming)
					message = "<B>[src]</B> takes a drag from a cigarette and blows \"[M]\" out in smoke."
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows \his name out in smoke."
					m_type = 2

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<span class='danger'>You cannot send IC messages (muted).</span>"
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			if(copytext(message,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				message = "<B>[src]</B> [message]"

		if ("moan")
			if(miming)
				message = "<B>[src]</B> appears to moan!"
			else
				message = "<B>[src]</B> moans!"
				m_type = 2
		if ("fart")
			exception = 1
			message = fart()
		if("superfart") //how to remove ass
			exception = 1
			message = fart(1)
		if ("mumble")
			message = "<B>[src]</B> mumbles!"
			m_type = 2

		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> raises a hand."
			m_type = 1

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1

		if ("scream")
			if(silent) // Fixes the screaming while muffled issue. Thanks to Crystal for the fix.
				message = "<B>[src]</B> makes a loud, muffled noise."
				m_type = 2
			else
				if (miming)
					message = "<B>[src]</B> acts out a scream!"
				else
					var/DNA = src.dna.species.id
					var/sound = pick('sound/misc/scream_m1.ogg', 'sound/misc/scream_m2.ogg')
					switch(DNA)
						if("IPC")
							sound = "sound/voice/screamsilicon.ogg"
						if("tarajan")
							sound = "sound/misc/cat.ogg"
						if("lizard")
							sound = "sound/misc/lizard.ogg"
						if("avian")
							sound = "sound/misc/caw.ogg"
						else
							if(gender == FEMALE)
								sound = pick('sound/misc/scream_f1.ogg', 'sound/misc/scream_f2.ogg')
							if(isalien(src))
								sound = pick('sound/voice/hiss6.ogg')

					playsound(src.loc, sound, 50, 1, 4, 1.2)
					message = "<B>[src]</B> screams!"
					src.adjustOxyLoss(5)
					m_type = 2
					delay = 15


	////////////////
	// IPC EMOTES //
	////////////////

		if ("ping")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
					message = "<B>[src]</B> pings!"
		if ("buzz")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
					message = "<B>[src]</B> buzzes."
		if ("buzz2")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
					message = "<B>[src]</B> buzzes twice."
		if ("chime")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/machines/chime.ogg', 50, 0)
					message = "<B>[src]></B> chimes."
		if ("honk")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 0)
					message = "<B>[src]</B> honks!"
		if ("sad")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/misc/sadtrombone.ogg', 50, 0)
					message = "<B>[src]</B> plays a sad trombone."
		if ("warn")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 50, 0)
					message = "<B>[src]</B> blares an alarm!"
		if ("help")
			var/DNA = src.dna.species.id
			switch(DNA)
				if("IPC")
					src << "Help for IPC emotes. You can use all Human emotes along with these emotes with say \"*emote\":\n\naflap, beep-(none)/mob, bow-(none)/mob, buzz-(none)/mob,buzz2,chime, clap, custom, deathgasp, flap, glare-(none)/mob, honk, look-(none)/mob, me, nod, ping-(none)/mob, sad, \nsalute-(none)/mob, twitch, twitch_s, warn,"

	////////////////////
	// END IPC EMOTES //
	////////////////////

		if ("shiver")
			message = "<B>[src]</B> shivers."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("sigh")
			if(miming)
				message = "<B>[src]</B> sighs."
			else
				..(act)

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<B>[src]</B> sneezes."
			else
				if (muzzled)
					message = "<B>[src]</B> makes a strange noise."
				else
					var/sound = pick('sound/misc/malesneeze01.ogg', 'sound/misc/malesneeze02.ogg', 'sound/misc/malesneeze03.ogg')
					if(gender == FEMALE)
						sound = pick('sound/misc/femsneeze01.ogg', 'sound/misc/femsneeze02.ogg')
					playsound(src.loc, sound, 50, 1, 5)
					message = "<B>[src]</B> sneezes."
				m_type = 2

		if ("sniff")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore")
			if (miming)
				message = "<B>[src]</B> sleeps soundly."
			else
				..(act)

		if ("whimper")
			if (miming)
				message = "<B>[src]</B> appears hurt."
			else
				..(act)

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> yawns."
				m_type = 2

		if ("help") //This can stay at the bottom.
			src << "Help for emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, dance, deathgasp, drool, fart, flap, frown, gasp, giggle, glare-(none)/mob, grin, jump, laugh, look, me, nod, point-atom, scream, shake, sigh, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tremble, twitch, twitch_s, wave, whimper, wink, yawn"


		else
			..(act)

	if(miming)
		m_type = 1



	if (message)
		log_emote("[name]/[key] : [message]")
		if(!exception)
			src.spam_flag = 1
			spawn(delay)
				src.spam_flag = 0
 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			visible_message(message)
		else if (m_type & 2)
			src.loc.audible_message(message)

#define FART_GENERIC	1
#define FART_ASSBLAST	2
#define FART_SUPERNOVA	3
#define FART_FLY		4



/mob/living/carbon/proc/fart(var/super = 0)
	if(ticker.current_state < GAME_STATE_PLAYING || world.time < fartholdin)
		src << "Your ass is not ready to blast."
		return

	var/obj/item/organ/butt/B = locate() in src.internal_organs
	if(!B)
		src << "\red You don't have a butt!"
		return

	if(HasDisease(/datum/disease/assinspection))
		src << "<span class='danger'>Your ass hurts too much.</span>"
		return

	var/count = 1 //rand(1, 2) //Double farts sounded weird
	var/lose_butt = prob(6)
	var/fart_type = FART_GENERIC
	var/message = null

	if(super)
		count = 10
		fart_type = FART_ASSBLAST //Put this outside probability check just in case. There were cases where superfart did a normal fart.
		if(prob(76)) // 76%
			fart_type = FART_ASSBLAST
		else if(prob(12)) // 3%
			fart_type = FART_SUPERNOVA
		else if(prob(12)) // 0.4%
			fart_type = FART_FLY

	if(fart_type != FART_GENERIC)
		lose_butt = 1
	else
		message = "<B>[src]</B> [pick(
				  "rears up and lets loose a fart of tremendous magnitude!",
				  "farts!",
				  "toots.",
				  "harvests methane from uranus at mach 3!",
				  "assists global warming!",
				  "farts and waves their hand dismissively.",
				  "farts and pretends nothing happened.",
				  "is a <b>farting</b> motherfucker!",
				  "<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>")]"

	spawn(0)
		spawn(count)
			for(var/obj/item/weapon/storage/book/bible/CUL8 in range(0))
				var/obj/effect/lightning/L = new /obj/effect/lightning(get_turf(src.loc))
				L.layer = src.layer + 1
				L.start()
				playsound(CUL8,'sound/effects/thunder.ogg', 90, 1)

				spawn(10)
					src.gib()
				break //This is to prevent multi-gibbening

		for(var/i = 1, i <= count, i++)
			B = locate() in src.internal_organs
			if(!B) break
			playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
			sleep(1)
		B = locate() in src.internal_organs
		if(!B) //Neccesary checks to prevent hyper duplicating buttblasts
			src << "\red You don't have a butt!"
			return
		if(super)
			sleep(4)
			playsound(src, 'sound/misc/fartmassive.ogg', 75, 1, 5)
		B = locate() in src.internal_organs
		if(!B) //Same here, sorry for the copypasta but it's neccesary with "sleep"
			src << "\red You don't have a butt!"
			return
		if(lose_butt)
			src.internal_organs -= B
			new /obj/item/organ/butt(src.loc)
			new /obj/effect/decal/cleanable/blood(src.loc)

			if(super)
				if(HasDisease(/datum/disease/assinspection))
					src << "<span class='danger'>It hurts so much!</span>"
					apply_damage(50, BRUTE, "chest")
				src.nutrition -= 500
			else
				src.nutrition -= rand(15, 30)
		else
			src.nutrition -= rand(5, 25)

		switch(fart_type)
			if(FART_GENERIC)
				for(var/mob/living/M in range(0))
					if(M != src)
						if(lose_butt)
							visible_message("\red <b>[src]</b>'s ass hits <b>[M]</b> in the face!", "\red Your ass smacks <b>[M]</b> in the face!")
							M.apply_damage(15,"brute","head")
						else
							visible_message("\red <b>[src]</b> farts in <b>[M]</b>'s face!")

				if(lose_butt)
					visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")

			if(FART_ASSBLAST)
				for(var/mob/living/M in range(0))
					if(M != src)
						visible_message("\red <b>[src]</b>'s ass blasts <b>[M]</b> in the face!", "\red You ass blast <b>[M]</b>!")
						M.apply_damage(75,"brute","head")

				visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")

			if(FART_SUPERNOVA)
				visible_message("\red <b>[src]</b> rips their ass apart in a massive explosion!", "\red Holy shit, your butt goes supernova!")
				explosion(src.loc, 0, 1, 3, adminlog = 0, flame_range = 3)
				src.gib()

			if(FART_FLY)
				var/startx = 0
				var/starty = 0
				var/endy = 0
				var/endx = 0
				var/startside = pick(cardinal)

				switch(startside)
					if(NORTH)
						starty = src.loc
						startx = src.loc
						endy = 38
						endx = rand(41, 199)
					if(EAST)
						starty = src.loc
						startx = src.loc
						endy = rand(38, 187)
						endx = 41
					if(SOUTH)
						starty = src.loc
						startx = src.loc
						endy = 187
						endx = rand(41, 199)
					else
						starty = src.loc
						startx = src.loc
						endy = rand(38, 187)
						endx = 199

				//ASS BLAST USA
				visible_message("\red <b>[src]</b> blows their ass off with such force, they explode!", "\red Holy shit, your butt flies off into the galaxy!")
				src.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
				new /obj/effect/immovablerod/butt(locate(startx, starty, 1), locate(endx, endy, 1))
				priority_announce("What the fuck was that?!", "General Alert")

	return message

#undef FART_GENERIC
#undef FART_ASSBLAST
#undef FART_SUPERNOVA
#undef FART_FLY
