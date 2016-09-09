
// **** Security gas mask ****

/obj/item/clothing/mask/gas/sechailer
	name = "security gas mask"
	desc = "A standard issue Security gas mask with integrated 'Compli-o-nator 3000' device. Plays over a dozen pre-recorded compliance phrases designed to get scumbags to stand still whilst you taze them. Do not tamper with the device."
	action_button_name = "HALT!"
	icon_state = "sechailer"
	ignore_maskadjust = 0
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACE
	w_class = 2
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	var/aggressiveness = 2
	var/cooldown_special
	var/recent_uses = 0
	var/broken_hailer = 0
	burn_state = -1
	/obj/item/clothing/mask/gas/sechailer/emag_act(mob/user)
		if(!emagged)
			emagged=1
			flags+= NODROP | BLOCKHAIR | HEADBANGPROTECT | EARBANGPROTECT
			user << "<span class='warning'>You overload \the [src]'s Big Guy synthesizer.</span>"
			aggressiveness = 5

/obj/item/clothing/mask/gas/sechailer/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask with an especially aggressive Compli-o-nator 3000."
	action_button_name = "HALT!"
	icon_state = "swat"
	aggressiveness = 3
	ignore_maskadjust = 1

/obj/item/clothing/mask/gas/sechailer/cyborg
	name = "security hailer"
	desc = "A set of recognizable pre-recorded messages for cyborgs to use when apprehending criminals."
	icon = 'icons/obj/device.dmi'
	icon_state = "taperecorder_idle"
	aggressiveness = 1 //Borgs are nicecurity!
	ignore_maskadjust = 1

/obj/item/clothing/mask/gas/sechailer/cyborg/New()
	..()
	verbs -= /obj/item/clothing/mask/gas/sechailer/verb/adjust

/obj/item/clothing/mask/gas/sechailer/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/screwdriver))
		switch(aggressiveness)
			if(1)
				user << "<span class='notice'>You set the restrictor to the middle position.</span>"
				aggressiveness = 2
			if(2)
				user << "<span class='notice'>You set the restrictor to the last position.</span>"
				aggressiveness = 3
			if(3)
				user << "<span class='notice'>You set the restrictor to the first position.</span>"
				aggressiveness = 1
			if(4)
				user << "<span class='danger'>You adjust the restrictor but nothing happens, probably because its broken.</span>"
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(aggressiveness != 4 || 5)
			user << "<span class='danger'>You broke the restrictor!</span>"
			aggressiveness = 4
	else
		..()

/obj/item/clothing/mask/gas/sechailer/verb/adjust()
	set category = "Object"
	set name = "Adjust Mask"
	adjustmask(usr)

/obj/item/clothing/mask/gas/sechailer/attack_self()
	halt()

/obj/item/clothing/mask/gas/sechailer/verb/halt()
	set category = "Object"
	set name = "HALT"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(!can_use(usr))
		return
	if(broken_hailer && !emagged)
		usr << "<span class='warning'>\The [src]'s hailing system is broken.</span>"
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null
	var/phrase_sound = null


	if(cooldown < world.time - 30) // A cooldown, to stop people being jerks
		recent_uses++
		if(cooldown_special < world.time - 180) //A better cooldown that burns jerks
			recent_uses = initial(recent_uses)

		switch(recent_uses)
			if(3)
				usr << "<span class='warning'>\The [src] is starting to heat up.</span>"
			if(4)
				usr << "<span class='userdanger'>\The [src] is heating up dangerously from overuse!</span>"
			if(5) //overload
				if(!emagged)
					broken_hailer = 1
					usr << "<span class='userdanger'>\The [src]'s power modulator overloads and breaks.</span>"
					return

		switch(aggressiveness)		// checks if the user has unlocked the restricted phrases
			if(1)
				phrase = rand(1,5)	// set the upper limit as the phrase above the first 'bad cop' phrase, the mask will only play 'nice' phrases
			if(2)
				phrase = rand(1,11)	// default setting, set upper limit to last 'bad cop' phrase. Mask will play good cop and bad cop phrases
			if(3)
				phrase = rand(1,18)	// user has unlocked all phrases, set upper limit to last phrase. The mask will play all phrases
			if(4)
				phrase = rand(12,26)	// user has broke the restrictor, it will now only play shitcurity phrases
			if(5)
				phrase = rand(19,26)	// user has emagged the mask, it will now only banepost

		switch(phrase)	//sets the properties of the chosen phrase
			if(1)				// good cop
				phrase_text = "HALT! HALT! HALT!"
				phrase_sound = "halt"
			if(2)
				phrase_text = "Stop in the name of the Law."
				phrase_sound = "bobby"
			if(3)
				phrase_text = "Compliance is in your best interest."
				phrase_sound = "compliance"
			if(4)
				phrase_text = "Prepare for justice!"
				phrase_sound = "justice"
			if(5)
				phrase_text = "Running will only increase your sentence."
				phrase_sound = "running"
			if(6)				// bad cop
				phrase_text = "Don't move, Creep!"
				phrase_sound = "dontmove"
			if(7)
				phrase_text = "Down on the floor, Creep!"
				phrase_sound = "floor"
			if(8)
				phrase_text = "Dead or alive you're coming with me."
				phrase_sound = "robocop"
			if(9)
				phrase_text = "God made today for the crooks we could not catch yesterday."
				phrase_sound = "god"
			if(10)
				phrase_text = "Freeze, Scum Bag!"
				phrase_sound = "freeze"
			if(11)
				phrase_text = "Stop right there, criminal scum!"
				phrase_sound = "imperial"
			if(12)				// LA-PD
				phrase_text = "Stop or I'll bash you."
				phrase_sound = "bash"
			if(13)
				phrase_text = "Go ahead, make my day."
				phrase_sound = "harry"
			if(14)
				phrase_text = "Stop breaking the law, ass hole."
				phrase_sound = "asshole"
			if(15)
				phrase_text = "You have the right to shut the fuck up."
				phrase_sound = "stfu"
			if(16)
				phrase_text = "Shut up crime!"
				phrase_sound = "shutup"
			if(17)
				phrase_text = "Face the wrath of the golden bolt."
				phrase_sound = "super"
			if(18)
				phrase_text = "I am, the LAW!"
				phrase_sound = "dredd"
			if(19)
				phrase_text = "Well congratulations, you got yourself caught!"
				phrase_sound = "bane1"
			if(20)
				phrase_text = "Now, what's the next step of your master plan?"
				phrase_sound = "bane2"
			if(21)
				phrase_text = "No, this can't be happening! I'm in charge here!"
				phrase_sound = "bane3"
			if(22)
				phrase_text = "They work for the mercenary... the masked man."
				phrase_sound = "bane4"
			if(23)
				phrase_text = "He didn't fly so good! Who wants to try next?"
				phrase_sound = "bane5"
			if(24)
				phrase_text = "First one to talk gets to stay on my station!"
				phrase_sound = "bane6"
			if(25)
				phrase_text = "Dr. Pavel, I'm security."
				phrase_sound = "bane7"
			if(26)
				phrase_text = "You're a big guy!"
				phrase_sound = "bane8"

		usr.visible_message("[usr]'s Compli-o-Nator: <font color='red' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/complionator/[phrase_sound].ogg", 100, 0, 4)
		cooldown = world.time
		cooldown_special = world.time




