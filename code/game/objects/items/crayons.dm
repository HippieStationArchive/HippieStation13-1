/*
 * Crayons - Moved from toys.dm
 */

/obj/item/toy/crayon
	name = "crayon"
	desc = "A colourful crayon. Looks tasty. Mmmm..."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = 1.0
	attack_verb = list("attacked", "coloured")
	var/colour = "#FF0000" //RGB
	var/drawtype = "rune"
	var/can_scribble = 1
	var/list/graffiti = list("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa","saturn","ghost","mystery","cyka","antilizard","prolizard")
	var/list/letters = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/dat
	var/msg = "" //used for scribbles
	var/max_length = 0 //ditto
	var/list/validSurfaces = list(/turf/simulated/floor)
	var/start_drawing_sound = 'sound/items/chalk_start.ogg'
	var/stop_drawing_sound = 'sound/items/chalk.ogg'
	var/use_delay = 50 //how many deciseconds does it take to draw?

/obj/item/toy/crayon/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is jamming the [src.name] up \his nose and into \his brain. It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS|OXYLOSS)

/obj/item/toy/crayon/New()
	..()
	name = "[colourName] crayon" //Makes crayons identifiable in things like grinders
	drawtype = pick(pick(graffiti), pick(letters), "rune[rand(1,6)]")

/obj/item/toy/crayon/attack_self(mob/living/user as mob)
	update_window(user)

/obj/item/toy/crayon/proc/update_window(mob/living/user as mob)
	dat += "<center><h2>Currently selected: [drawtype]</h2><br>"
	dat += "<a href='?src=\ref[src];type=random_letter'>Random letter</a><a href='?src=\ref[src];type=letter'>Pick letter</a>[can_scribble ? "<a href='?src=\ref[src];type=scribble'>Draw a scribble</a>" : ""]"
	dat += "<hr>"
	dat += "<h3>Runes:</h3><br>"
	dat += "<a href='?src=\ref[src];type=random_rune'>Random rune</a>"
	for(var/i = 1; i <= 6; i++)
		dat += "<a href='?src=\ref[src];type=rune[i]'>Rune[i]</a>"
		if(!((i + 1) % 3)) //3 buttons in a row
			dat += "<br>"
	dat += "<hr>"
	graffiti.Find()
	dat += "<h3>Graffiti:</h3><br>"
	dat += "<a href='?src=\ref[src];type=random_graffiti'>Random graffiti</a>"
	var/c = 1
	for(var/T in graffiti)
		dat += "<a href='?src=\ref[src];type=[T]'>[T]</a>"
		if(!((c + 1) % 3)) //3 buttons in a row
			dat += "<br>"
		c++
	dat += "<hr>"
	var/datum/browser/popup = new(user, "crayon", name, 300, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	dat = ""

/obj/item/toy/crayon/Topic(href, href_list, hsrc)
	var/temp = "a"
	switch(href_list["type"])
		if("random_letter")
			temp = pick(letters)
		if("letter")
			temp = input("Choose the letter.", "Scribbles") in letters
		if("scribble")
			temp = "scribble" //Check in code for scribble var to handle custom operations.
			if(uses)
				max_length = uses * 2
			else
				max_length = 60 //Since we have unlimited uses, let's limit our characters to 60

			if(max_length > 0)
				msg = stripped_input("Write a message. It cannot be longer than [max_length] characters.", "Scribbles", "")
		if("random_rune")
			temp = "rune[rand(1,6)]"
		if("random_graffiti")
			temp = pick(graffiti)
		else
			temp = href_list["type"]
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	drawtype = temp
	update_window(usr)

/obj/item/toy/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(is_type_in_list(target,validSurfaces))
		var/temp = "rune"
		if(letters.Find(drawtype))
			temp = "letter"
		else if(graffiti.Find(drawtype))
			temp = "graffiti"
		else if(drawtype == "scribble")
			if(msg)
				temp = "scribble"
			else //No message input, just pick random graffiti
				drawtype = pick(graffiti)
				temp = "graffiti"
		user << "You start drawing a [temp] on the [target.name]."
		if(!instant) //So we don't get layered sfx
			playsound(src.loc, start_drawing_sound, 40, 1)
		if(instant || do_after(user, use_delay))
			var/obj/effect/decal/cleanable/W = null
			var/rand_offset = 0
			var/taken = 1
			user << "You finish drawing [temp]."
			playsound(src.loc, stop_drawing_sound, 40, 1)
			if(temp == "scribble")
				if(length(msg) > max_length)
					msg = copytext(msg,1,max_length)
					msg += "-"
					// src << "<span class='warning'>You ran out of [src] to write with!</span>" //We'll be informed in the "uses" check.
				var/obj/effect/decal/cleanable/scribble/S = new (target)
				S.basecolor = colour
				S.update_icon()
				S.info = msg
				S.add_fingerprint(user)
				W = S
				taken = max(1, round(length(msg) / 2))
				rand_offset = 1 //We're a scribble, so randomise offset
			else
				W = new /obj/effect/decal/cleanable/crayon(target,colour,drawtype,temp)

			if(istype(target, /turf/simulated/wall)) //If we draw things on the wall turfs they shouldn't be seen from all angles.
				W.loc = user.loc //change location of writings to user's so they can't be seen from all directions
				var/scribbledir = get_dir(user, target)
				//Adjust pixel offset to make writings appear on the wall
				W.pixel_x = scribbledir & EAST ? 32 : (scribbledir & WEST ? -32 : 0)
				W.pixel_y = scribbledir & NORTH ? 32 : (scribbledir & SOUTH ? -32 : 0)
				if(rand_offset)
					//Randomise pixel offset + adjust it accordingly from the center
					W.pixel_x += scribbledir & EAST ? -rand(6, 11) : (scribbledir & WEST ? rand(6, 11) : rand(-7, 7))
					W.pixel_y += scribbledir & NORTH ? -rand(6, 11) : (scribbledir & SOUTH ? rand(6, 11) : rand(-7, 7))
			else
				if(rand_offset)
					W.pixel_x = rand(-8, 8)
					W.pixel_y = rand(-8, 8)

			if(uses)
				uses-= taken
				if(!uses)
					user << "<span class='danger'>You used up your [src.name]!</span>"
					qdel(src)
	return

/obj/item/toy/crayon/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		user << "You take a bite of the [src.name]. Delicious!"  //Huffing them didn't work so LOGIC OUT THE WINDOW!  ~Nexendia
		user.nutrition += 5
		if(uses)
			uses -= 5
			if(uses <= 0)
				user << "<span class='danger'>There is no more of the [src.name] left!</span>"
				qdel(src)
	else
		if(istype(M, /mob/living/carbon/human) && M.lying && isturf(M.loc))
			user << "You start drawing an outline of the [M]."
			playsound(src.loc, 'sound/items/chalk_start.ogg', 40, 1)
			if(instant || do_after(user, 50))
				new /obj/effect/decal/cleanable/crayon(M.loc,colour,"body","body")
				user << "You finish drawing an outline."
				playsound(src.loc, 'sound/items/chalk.ogg', 40, 1)
				if(uses)
					uses--
					if(!uses)
						user << "<span class='danger'>You used up your [src.name]!</span>"
						qdel(src)

/obj/item/toy/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	colourName = "red"

/obj/item/toy/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	colourName = "orange"

/obj/item/toy/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	colourName = "yellow"

/obj/item/toy/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	colourName = "green"

/obj/item/toy/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	colourName = "blue"

/obj/item/toy/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	colourName = "purple"

/obj/item/toy/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	colourName = "mime"
	uses = 0

/obj/item/toy/crayon/white
	icon_state = "crayonwhite"
	desc = "Usually used by forensics experts to draw outlines of bodies and little mr. saturns next to them."
	colour = "#FFFFFF"
	colourName = "white"
	uses = 0

/obj/item/toy/crayon/mime/attack_self(mob/living/user as mob)
	update_window(user)

/obj/item/toy/crayon/mime/update_window(mob/living/user as mob)
	dat += "<center><span style='border:1px solid #161616; background-color: [colour];'>&nbsp;&nbsp;&nbsp;</span><a href='?src=\ref[src];color=1'>Change color</a></center>"
	..()

/obj/item/toy/crayon/mime/Topic(href,href_list)
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	if(href_list["color"])
		if(colour != "#FFFFFF")
			colour = "#FFFFFF"
		else
			colour = "#000000"
		update_window(usr)
	else
		..()

/obj/item/toy/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	colourName = "rainbow"
	desc = "Eat this and you will puke rainbows!" //TODO: Actually implement rainbow-puking chance when eaten
	uses = 0

/obj/item/toy/crayon/rainbow/attack_self(mob/living/user as mob)
	update_window(user)

/obj/item/toy/crayon/rainbow/update_window(mob/living/user as mob)
	dat += "<center><span style='border:1px solid #161616; background-color: [colour];'>&nbsp;&nbsp;&nbsp;</span><a href='?src=\ref[src];color=1'>Change color</a></center>"
	..()

/obj/item/toy/crayon/rainbow/Topic(href,href_list[])

	if(href_list["color"])
		var/temp = input(usr, "Please select colour.", "Crayon colour") as color
		if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
			return
		colour = temp
		update_window(usr)
	else
		..()



//Spraycan stuff

/obj/item/toy/crayon/spraycan
	name = "spraycan"
	icon_state = "spraycanwhite"
	desc = "A metallic container containing 'tasty' paint."
	var/capped = 1
	uses = 0 //Infinite use
	use_delay = 20 //more than half of crayon use delay
	can_scribble = 0
	start_drawing_sound = 'sound/effects/zzzt.ogg'
	stop_drawing_sound = 'sound/effects/spray.ogg'
	validSurfaces = list(/turf/simulated/floor,/turf/simulated/wall)

/obj/item/toy/crayon/spraycan/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is spraying \the contents of \the [src.name] into \his mouth! It looks like \he's trying to commit suicide.</span>") //TOXIC CHEMICALS O NO
	return (BRUTELOSS|OXYLOSS)

/obj/item/toy/crayon/spraycan/New()
	..()
	name = initial(name) //Reset the crayon's code for renaming
	update_icon()

/obj/item/toy/crayon/spraycan/update_icon()
	overlays.Cut()
	var/image/I = image('icons/obj/crayons.dmi', icon_state = "spraycancolor")
	I.color = colour
	overlays += I
	if(capped)
		I = image('icons/obj/crayons.dmi', icon_state = "cap")
		I.color = colour
		overlays += I

/obj/item/toy/crayon/spraycan/verb/toggleCap()
	set name = "Toggle Cap"
	set category = "Object" //Since we set the category, this makes the proc a verb as well.

	usr << "<span class='notice'>You [capped ? "Remove" : "Replace"] the cap of the [src]</span>"
	capped = !capped
	playsound(usr.loc, 'sound/effects/pop.ogg', 25, 1, -2)
	update_icon()
	..()

/obj/item/toy/crayon/spraycan/AltClick() //Toggles cap
	..()
	toggleCap()

/obj/item/toy/crayon/spraycan/attack_self(mob/living/user as mob)
	if(capped)
		toggleCap()
	else
		..()

/obj/item/toy/crayon/spraycan/attack(mob/M as mob, mob/user as mob)
	return //No crayon biting, and no body outlining.

/obj/item/toy/crayon/spraycan/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(capped) return

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		user.visible_message("<span class='danger'>[user] sprays [target] in the face with [src]!</span>",\
							"<span class='userdanger'>[user] sprays [target] in the face with [src]!</span>")
		if(H.client)
			H.eye_blurry = max(H.eye_blurry, 3)
			H.eye_blind = max(H.eye_blind, 1)
			H.confused = max(H.confused, 2) //Confusion is pretty powerful
			// H.Weaken(3) //That is too much.
		H.spraypaint = "face"
		H.spraypaint_color = colour
		H.update_body()
		playsound(user.loc, stop_drawing_sound, 50, 1, -1)
		return
	..()

/obj/item/toy/crayon/spraycan/CtrlClick() //Change color
	..()
	colour = input(usr,"Choose Color") as color
	update_icon()

/obj/item/toy/crayon/spraycan/attack_self(mob/living/user as mob)
	var/choice = input(user,"Spraycan options") in list("Toggle Cap","Change Drawing","Change Color")
	switch(choice)
		if("Toggle Cap")
			toggleCap()
		if("Change Drawing")
			..()
		if("Change Color")
			colour = input(user,"Choose Color") as color
			update_icon()