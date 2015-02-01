/mob/living/carbon/human/say_quote(text)
	if(!text)
		return "says, \"...\"";	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
	var/ending = copytext(text, length(text))
	if (src.stuttering)
		return "stammers, \"[text]\"";
	if(isliving(src))
		var/mob/living/L = src
		if (L.getBrainLoss() >= 60)
			return "gibbers, \"[text]\"";
	if (ending == "?")
		return "asks, \"[text]\"";
	if (ending == "!")
		return "exclaims, \"[text]\"";

	if(dna)
		return "[dna.species.say_mod], \"[text]\"";

	return "says, \"[text]\"";

/mob/living/carbon/human/treat_message(message)
	if(dna)
		message = dna.species.handle_speech(message,src)

	if ((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(replacetext(message, ".", "!"))]!!" //because I don't know how to code properly in getting vars from other files -Bro

	if(viruses.len)
		for(var/datum/disease/pierrot_throat/D in viruses)
			var/list/temp_message = text2list(message, " ") //List each word in the message
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++) //Create a second list for excluding words down the line
				pick_list += i
			for(var/i=1, ((i <= D.stage) && (i <= temp_message.len)), i++) //Loop for each stage of the disease or until we run out of words
				if(prob(3 * D.stage)) //Stage 1: 3% Stage 2: 6% Stage 3: 9% Stage 4: 12%
					var/H = pick(pick_list)
					if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
					temp_message[H] = "HONK"
					pick_list -= H //Make sure that you dont HONK the same word twice
				message = list2text(temp_message, " ")

	message = ..(message)

	return message

/mob/living/carbon/human/GetVoice()
	if(istype(wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = wear_mask
		if(V.vchange && wear_id)
			var/obj/item/weapon/card/id/idcard = wear_id.GetID()
			if(istype(idcard))
				return idcard.registered_name
			else
				return real_name
		else
			return real_name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/IsVocal()
	if(mind)
		return !mind.miming
	return 1

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/binarycheck()
	if(ears)
		var/obj/item/device/radio/headset/dongle = ears
		if(!istype(dongle)) return 0
		if(dongle.translate_binary) return 1

/mob/living/carbon/human/radio(message, message_mode)
	. = ..()
	if(. != 0)
		return .

	switch(message_mode)
		if(MODE_HEADSET)
			if (ears)
				ears.talk_into(src, message)
			return ITALICS | REDUCE_RANGE

		if(MODE_SECURE_HEADSET)
			if (ears)
				ears.talk_into(src, message, 1)
			return ITALICS | REDUCE_RANGE

		if(MODE_DEPARTMENT)
			if (ears)
				ears.talk_into(src, message, message_mode)
			return ITALICS | REDUCE_RANGE

	if(message_mode in radiochannels)
		if(ears)
			ears.talk_into(src, message, message_mode)
			return ITALICS | REDUCE_RANGE

	return 0

/mob/living/carbon/human/get_alt_name()
	if(name != GetVoice())
		return " (as [get_id_name("Unknown")])"

/mob/living/carbon/human/proc/forcesay(list/append) //this proc is at the bottom of the file because quote fuckery makes notepad++ cri
	if(stat == CONSCIOUS)
		if(client)

			var/msg = null

			var/cmd_text = winget(client, "input", "text")

			if(lowertext(copytext(cmd_text, 1, 4)) == "say")
				msg = copytext(cmd_text, 5)
			else if(winget(client, "say_window", "is-visible"))
				msg = winget(client, "say_window.say_input", "text")

			if(!msg || length(msg) < 1)
				return

			while(1)
				var/first_char = copytext(msg, 1, 2)

				if(first_char == " " || first_char == "\"" || first_char == ";")
					msg = copytext(msg, 2)
				else if(first_char == ":")
					msg = copytext(msg, 3)
				else
					break

			if(length(msg) < 1)
				return

			msg = copytext(msg, 1, min(max(7, round(length(msg) * 0.4)), 20)) // Value of msg length * 0.4 restricted between 7 and 20

			if(append)
				msg += pick(append)

			say(msg)

			winset(client, "input", "text=[null]")
			winset(client, "say_window.say_input", "text=[null]")