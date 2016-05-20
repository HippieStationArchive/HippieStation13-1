/*
Tooltips v1.0 - 19/10/15
Developed by Wire (#goonstation on irc.synirc.net)
- Initial release
Configuration:
- Set control to the correct skin element (remember to actually place the skin element)
- Set file to the correct path for the .html file (remember to actually place the html file)
- Attach the datum to the user client on login, e.g.
	/client/New()
		src.tooltips = new /datum/tooltip(src)
Usage:
- Define mouse event procs on your (probably HUD) object and simply call the show and hide procs respectively:
	/obj/screen/hud
		MouseEntered(location, control, params)
			usr.client.tooltip.show(params, title = src.name, content = src.desc)
		MouseExited()
			usr.client.tooltip.hide()
Customization:
- Theming can be done by passing the theme var to show() and using css in the html file to change the look
- For your convenience some pre-made themes are included
Notes:
- You may have noticed 90% of the work is done via javascript on the client. Gotta save those cycles man.
- This is entirely untested in any other codebase besides goonstation so I have no idea if it will port nicely. Good luck!
	- After testing and discussion (Wire, Remie, MrPerson, AnturK) ToolTips are ok and work for /tg/station13
*/


/datum/tooltip
	var
		client/owner
		control = "mainwindow.tooltip"
		file = 'code/modules/tooltip/tooltip.html'
		showing = 0
		queueHide = 0


	New(client/C)
		if (C)
			src.owner = C
			src.owner << browse(src.file, "window=[src.control]")

		..()


	proc/show(params = null, title = null, content = null, theme = "default")
		if (!params || (!title && !content) || !src.owner) return 0
		src.showing = 1

		//Format contents
		if (title && content)
			title = "<h1>[title]</h1>"
			content = "<p>[content]</p>"
		else if (title && !content)
			title = "<p>[title]</p>"
		else if (!title && content)
			content = "<p>[content]</p>"

		//Send stuff to the tooltip
		src.owner << output(list2params(list(src.control, params, src.owner.view, "[title][content]", theme)), "[src.control]:tooltip.update")

		//If a hide() was hit while we were showing, run hide() again to avoid stuck tooltips
		src.showing = 0
		if (src.queueHide)
			src.hide()

		return 1


	proc/hide()
		if (src.queueHide)
			spawn(1)
				winshow(src.owner, src.control, 0)
		else
			winshow(src.owner, src.control, 0)

		src.queueHide = src.showing ? 1 : 0

		return 1



/* TG SPECIFIC CODE */


//Open a tooltip for user, at a location based on params
//Theme is a CSS class in tooltip.html, by default this wrapper chooses a CSS class based on the user's UI_style (Midnight, Plasmafire, Retro)
//Includes sanity.checks
/proc/openToolTip(mob/user = null,params = null,title = "",content = "",theme = "")
	if(istype(user))
		if(user.client && user.client.tooltips)
			if(!theme && user.client.prefs && user.client.prefs.UI_style)
				theme = lowertext(user.client.prefs.UI_style)
			if(!theme)
				theme = "default"
			user.client.tooltips.show(params,title,content,theme)


//Arbitrarily close a user's tooltip
//Includes sanity checks.
/proc/closeToolTip(mob/user)
	if(istype(user))
		if(user.client && user.client.tooltips)
			user.client.tooltips.hide()


