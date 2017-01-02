/////////////////
// NEW DEFINES //
/////////////////

/client
	var/viewingCanvas = 0 //If this is 1, as soon as client /TRIES/ to move the view resets.

///////////
// EASEL //
///////////

/obj/structure/easel
	name = "easel"
	desc = "only for the finest of art!"
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "easel"
	density = 1
	burn_state = 0 //Burnable
	burntime = 15
	var/obj/item/weapon/canvas/painting = null


//Adding canvases
/obj/structure/easel/attackby(var/obj/item/I, var/mob/user, params)
	if(istype(I, /obj/item/weapon/canvas))
		var/obj/item/weapon/canvas/C = I
		user.unEquip(C)
		painting = C
		C.loc = get_turf(src)
		C.layer = layer+0.1
		user.visible_message("<span class='notice'>[user] puts \the [C] on \the [src].</span>","<span class='notice'>You place \the [C] on \the [src].</span>")
		return

	..()


//Stick to the easel like glue
/obj/structure/easel/Move()
	var/turf/T = get_turf(src)
	..()
	if(painting && painting.loc == T) //Only move if it's near us.
		painting.loc = get_turf(src)
	else
		painting = null


//////////////
// CANVASES //
//////////////

#define AMT_OF_CANVASES	4 //Keep this up to date or shit will break.

//To safe memory on making /icons we cache the blanks..
var/global/list/globalBlankCanvases[AMT_OF_CANVASES]

/obj/item/weapon/canvas
	name = "11px by 11px canvas"
	desc = "Draw out your soul on this canvas! Instructions: Only crayons can draw on it. Examine it to focus on the canvas. You can name, sign and write a description if you have a pen."
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "11x11"
	burn_state = 0 //Burnable
	var/whichGlobalBackup = 1 //List index
	var/offset_pixel_y = 3 //Used by frames/paintings. What pixel offset to apply to the photocopied painting?
	var/offset_pixel_x = 0 //Most of the paintings only have to change y offset.
	var/author = ""
	var/title = ""
	var/inscription = ""

/obj/item/weapon/canvas/nineteenXnineteen
	name = "19px by 19px canvas"
	icon_state = "19x19"
	whichGlobalBackup = 2
	offset_pixel_y = -1

/obj/item/weapon/canvas/twentythreeXnineteen
	name = "23px by 19px canvas"
	icon_state = "23x19"
	whichGlobalBackup = 3
	offset_pixel_y = -1

/obj/item/weapon/canvas/twentythreeXtwentythree
	name = "23px by 23px canvas"
	icon_state = "23x23"
	whichGlobalBackup = 4
	offset_pixel_y = -3

//Find the right size blank canvas
/obj/item/weapon/canvas/proc/getGlobalBackup()
	. = null
	if(globalBlankCanvases[whichGlobalBackup])
		. = globalBlankCanvases[whichGlobalBackup]
	else
		var/icon/I = icon(initial(icon),initial(icon_state))
		globalBlankCanvases[whichGlobalBackup] = I
		. = I

//One pixel increments
/obj/item/weapon/canvas/attackby(var/obj/item/I, var/mob/user, params)
	//Click info
	var/list/click_params = params2list(params)
	var/pixX = text2num(click_params["icon-x"])
	var/pixY = text2num(click_params["icon-y"])

	//Should always be true, otherwise you didn't click the object, but let's check because SS13~
	if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
		return

	var/icon/masterpiece = icon(icon,icon_state)
	//Cleaning one pixel with a soap or rag
	if(istype(I, /obj/item/weapon/soap) || istype(I, /obj/item/weapon/reagent_containers/glass/rag))
		//Pixel info created only when needed
		var/thePix = masterpiece.GetPixel(pixX,pixY)
		var/icon/Ico = getGlobalBackup()
		if(!Ico)
			qdel(masterpiece)
			return

		var/theOriginalPix = Ico.GetPixel(pixX,pixY)
		if(thePix != theOriginalPix) //colour changed
			var/icon/Draw = DrawPixel(masterpiece,theOriginalPix,pixX,pixY)
			if(Draw)
				icon = Draw
		qdel(masterpiece)
		return

	//Drawing one pixel with a crayon
	if(istype(I, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/C = I
		if(masterpiece.GetPixel(pixX, pixY)) // if the located pixel isn't blank (null))
			var/icon/Draw = DrawPixel(masterpiece,C.colour, pixX, pixY)
			if(Draw)
				icon = Draw
		qdel(masterpiece)
		return

	//Drawing one pixel with a paintbrush. TODO: Add paintbrush "fatness"
	if(istype(I, /obj/item/weapon/paintbrush))
		var/obj/item/weapon/paintbrush/P = I
		if(!P.colour) return //No color on paintbrush
		if(P.paintstyle == "pixel")
			if(masterpiece.GetPixel(pixX, pixY)) // if the located pixel isn't blank (null))
				var/icon/Draw = DrawPixel(masterpiece,P.colour, pixX, pixY)
				if(Draw)
					icon = Draw

		// else if(P.paintstyle == "line") //WIP CODE
		// 	if(P.line_ox != null && P.line_oy != null && P.linedraw_obj == src) //They were defined
		// 		//WOO COMPLEX ALGORITHMS.
		// 		var/pixel1x = 0
		// 		var/pixel1y = 0
		// 		var/pixel2y = 0
		// 		var/pixel2x = 0
		// 		if(P.line_ox < pixX)
		// 			pixel1x = P.line_ox
		// 			pixel2x = pixX
		// 		else
		// 			pixel1x = pixX
		// 			pixel2x = P.line_ox

		// 		if(P.line_oy < pixY)
		// 			pixel1y = P.line_oy
		// 			pixel2y = pixY
		// 		else
		// 			pixel1y = pixY
		// 			pixel2y = P.line_oy

		// 		var/dx = abs(pixel1x-pixel2x)
		// 		if(dx == 0) dx = 1
		// 		var/dy = abs(pixel1y-pixel2y)
		// 		if(dy == 0) dy = 1
		// 		world << "dx [dx] dy [dy] pixel1x [pixel1x] pixel1y [pixel1y] pixel2x [pixel2x] pixel2y [pixel2y]"
		// 		var/icon/Draw
		// 		for(var/newX = pixel1x to pixel2x)
		// 			var/newY = round(pixel1y+dy*(newX-pixel1x)/dx)
		// 			// for(var/newY = pixel1y to pixel2y) //This makes it draw squares. Very laggily.
		// 				world << "newX [newX] newY [newY]"
		// 				// if(masterpiece.GetPixel(newX, newY))
		// 				Draw = DrawPixel(masterpiece,P.colour,newX,newY)
		// 		if(Draw)
		// 			icon = Draw
		// 		P.line_ox = null
		// 		P.line_oy = null
			else //They were NOT defined, let's define them now
				user << "<span class='notice'>Click on another location to draw a line.</span>"
				P.linedraw_obj = src
				P.line_ox = pixX
				P.line_oy = pixY
				if(masterpiece.GetPixel(pixX, pixY)) // if the located pixel isn't blank (null))
					var/icon/Draw = DrawPixel(masterpiece,P.colour, pixX, pixY)
					if(Draw)
						icon = Draw

		else if(P.paintstyle == "fill")
			var/icon/C = new /icon('icons/effects/alphacolors.dmi', "white")
			masterpiece.Blend(C, ICON_ADD) //Fills the icon with the color
			masterpiece.Blend(P.colour, ICON_MULTIPLY) //Colorifies the sheet
			icon = masterpiece

		qdel(masterpiece)
		return

	//Naming, signing, etc. the canvas. Photocopying saves this info, and photocopies cannot be changed.
	if(istype(I, /obj/item/weapon/pen))
		var/choice = input("What would you like to change?") in list("Title", "Author", "Description", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(stripped_input(usr, "Write a new title:"))
				if(!newtitle)
					usr << "The title is invalid."
					return
				else
					name = "canvas - \"[newtitle]\""
					title = newtitle
			if("Author")
				var/newauthor = stripped_input(usr, "Write the author's name:")
				if(!newauthor)
					usr << "The name is invalid."
					return
				else
					author = newauthor
			if("Description")
				var/newdesc = stripped_input(usr, "Write the painting's description:", max_length=512)
				if(!newdesc)
					usr << "The description is invalid."
					return
				else
					desc = "The painting has a plaque on it: \"[newdesc]\""
					inscription = newdesc
			else
				return
	..()

/obj/item/weapon/canvas/clean_blood() //Cleaning blood also cleans the painting.
	..()
	Clean() //rip

/obj/item/weapon/canvas/proc/Clean()
	var/icon/blank = getGlobalBackup()
	if(blank)
		//it's basically a giant etch-a-sketch
		icon = blank

//Clean the whole canvas
/obj/item/weapon/canvas/attack_self(var/mob/user)
	if(!user)
		return
	//To clean it up you have to get some water now.

//Examine to enlarge
/obj/item/weapon/canvas/examine(mob/user)
	..()
	if(author)
		usr << "It was signed by [author]."
	if(in_range(user, src) && get_turf(src) && user.client && ishuman(user)) //Let only humans be the robust zoominators. I'm too spooked other mobs trying to use it may get broken huds.
		if(src.loc == user || get_turf(src) == get_turf(user))
			user << "<span class='notice'>[src] has to be on the ground to focus on it!</span>"
			return
		user << "<span class='notice'>You focus on \the [src].</span>"
		// user.client.prev_screen = user.client.screen //We cached the screen so we should be good... right?
		user.client.screen = list()
		user.client.reset_stretch = winget(user.client, "mapwindow.map", "icon-size") //Remember previous icon-size
		user.client.view = 3 //Decrease view
		winset(user.client, "mapwindow.map", "icon-size=0") //Enable stretch-to-fit
		user.client.viewingCanvas = 1 //Reset everything we just changed as soon as client tries to move
	else
		user << "<span class='notice'>It is too far away.</span>"

/obj/item/weapon/painting //You can create paintings using photocopier. Woo, creative outlet!
	name = "painting"
	desc = "This is a painting. It lacks description."
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "11x11"
	var/author = ""
	var/title = ""
	var/inscription = ""
	var/attached = 0

/obj/item/weapon/painting/examine(mob/user)
	..()
	if(author)
		usr << "It was signed by [author]."

/obj/item/weapon/painting/afterattack(atom/target, mob/living/user, proximity, params)
	if(!proximity) return
	if(istype(target, /turf/simulated/wall))
		user.drop_item()
		src.loc = target
		attached = 1
		anchored = 1
		flags |= NODROP

/obj/item/weapon/painting/attack_hand(mob/user as mob)
	if(attached)
		if(alert(usr, "Are you sure you want to take the painting off the wall?", "[name]", "Yes", "No") != "Yes") return
		flags = initial(flags)
		anchored = 0
		attached = 0
		user.put_in_active_hand(src)
		return
	..()

//BRUSHES/PALETTES

/obj/item/weapon/paintbrush
	name = "paintbrush"
	desc = "Screw crayons, this is how real artists paint!"
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "brush"
	burn_state = 0 //Burnable
	var/colour = "" //If this variable is not empty the brush will have a fancy overlay added to it!
	var/paintstyle = "pixel" //What kind of paint style does this brush have?
	var/line_ox //Selected pixel for linedraw
	var/line_oy
	var/atom/linedraw_obj
	w_class = 1

/obj/item/weapon/paintbrush/attack_self(var/mob/user)
	if(!user)
		return
	// line_ox = null
	// line_oy = null
	// linedraw_obj = null
	// paintstyle = (paintstyle == "pixel" ? "line" : "pixel")
	// user << "<span class='notice'>Switched to [paintstyle] drawing style."

/obj/item/weapon/paintbrush/update_icon()
	overlays.Cut()
	if(colour)
		var/image/I = new(icon,"[icon_state]_color")
		I.color = colour
		overlays += I

/obj/item/weapon/paintbrush/broadbrush
	name = "broad-brush"
	desc = "Paint the ENTIRE PAINTING with one swipe!"
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "broadbrush"
	paintstyle = "fill"

/obj/item/weapon/palette
	name = "palette"
	desc = "This color palette supports up to 8 colors!"
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "palette"
	burn_state = 0 //Burnable
	var/list/colorpalette[8] //Crayon colors
	var/dat

/obj/item/weapon/palette/New()
	..()
	for(var/i = 1, i <= 8, i++)
		colorpalette[i] = "#ffffff"
/obj/item/weapon/palette/attack_self(mob/living/user as mob)
	// for(var/i = 1, i <= colorpalette.len, i++)
	// 	usr << "[colorpalette[i]] // [i]"
	update_window(user)

/obj/item/weapon/palette/Topic(href, href_list, hsrc)
	if(href_list["colour"])
		var/clr = text2num(href_list["colour"])
		if(istype(usr.get_active_hand(), /obj/item/weapon/paintbrush))
			var/obj/item/weapon/paintbrush/P = usr.get_active_hand()
			P.colour = colorpalette[clr]
			P.update_icon()
			usr << "<span class='notice'>You dip [P] in \the [src]."
			update_window(usr)
		else
			var/temp = input(usr, "Please select colour.", "Palette colour slot [href_list["colour"]]") as color
			if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
				return
			colorpalette[clr] = temp
			update_window(usr)

/obj/item/weapon/palette/proc/update_window(mob/living/user as mob)
	dat = "<center>"
	for(var/i = 1, i <= colorpalette.len, i++)
		dat += "<a href='?src=\ref[src];colour=[i]'><span style='border:1px solid #161616; background-color: [colorpalette[i]];font=20px;'>&nbsp;&nbsp;&nbsp;</span></a>"
	dat += "</center>"
	var/datum/browser/popup = new(user, "palette", name, 524, 300)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	dat = ""
#undef AMT_OF_CANVASES