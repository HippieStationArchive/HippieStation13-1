/obj/structure/tablesaw
	name = "table saw"
	desc = "Used to model wood."
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "tablesaw"
	density = TRUE
	anchored = TRUE
	var/obj/item/weapon/woodenplate/plate 	//the wooden plate
	var/client/sawer	 	//the guy sawing the plate
	var/oldloc 								//the loc the sawer was on when he started sawing,to remove the image in case of movement
	var/cooldown //Used to prevent the MULTISAWING OF DEATH!

/obj/structure/tablesaw/New()
	..()
	SSobj.processing |= src

/obj/structure/tablesaw/Destroy()
	SSobj.processing.Remove(src)
	if(plate)
		plate.mode = FALSE
		plate.forceMove(get_turf(src))
	..()

/obj/structure/tablesaw/process()
	if(sawer && oldloc && plate)
		if(get_turf(sawer.mob) != oldloc)
			sawer.images -= plate.zoom

/obj/structure/tablesaw/attackby(obj/item/I, mob/user)
	if(default_unfasten_wrench(user, I))
		return
	if(istype(I, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/W = I
		W.use(1)
		new /obj/item/weapon/woodenplate(get_turf(src))
		user << "<span class='notice'>You saw the plank and make a plate out of it.</span>"
		return
	if(istype(I, /obj/item/weapon/woodenplate))
		if(plate)
			user << "<span class='danger'>\The [name] already has a plate on it!</span>"
			return
		else
			user << "<span class='notice'>You insert \the [I] in \the [name].</span>"
			plate = I
			plate.mode = TRUE
			user.drop_item()
			I.forceMove(src)
			sawer = user.client
			oldloc = get_turf(user)
			plate.zoom.loc = src
			sawer.images |= plate.zoom
			overlays += "ontable"
		return
	if(istype(I, /obj/item/weapon/grab))//shamelessly copied from meatspike
		var/obj/item/weapon/grab/G = I
		if(cooldown)
			user << "<span class='notice'>Someone is already being sawn!</span>"
			return
		if(isliving(G.affecting))
			user.visible_message("<span class='danger'>[user] starts slamming [G.affecting] onto \the [name]...</span>")
			cooldown = 1
			if(do_mob(user, src, 120))
				if(G.affecting.buckled)
					return
				var/mob/living/H = G.affecting
				H.visible_message("<span class='danger'>[user] slams [G.affecting] onto \the [name]!</span>", "<span class='userdanger'>[user] slams you onto \the [name]!</span>", "<span class='italics'>You hear a squishy wet noise.</span>")
				H.forceMove(get_turf(src))
				H.emote("scream")
				if(istype(H, /mob/living/carbon/human)) //So you don't get human blood when you spike a giant spider
					var/mob/living/carbon/human/HU = H
					var/turf/pos = get_turf(HU)
					pos.add_blood_floor(HU)
					var/target_zone = user.zone_sel.selecting
					var/obj/item/organ/limb/affecting = HU.get_organ(target_zone)
					if(affecting.dismember())
						I.add_blood(H)
						playsound(get_turf(H), pick('sound/misc/desceration-01.ogg', 'sound/misc/desceration-02.ogg', 'sound/misc/desceration-03.ogg', 'sound/misc/desceration-04.ogg'), 80, 1)
						affecting.add_blood(H)
						var/turf/location = H.loc
						if(istype(location, /turf/simulated))
							location.add_blood(H)
				H.adjustBruteLoss(50)
				qdel(G)
				cooldown = 0
			else
				cooldown = 0

/obj/structure/tablesaw/attack_hand(mob/user)
	if(plate)
		plate.forceMove(get_turf(src))
		plate.mode = FALSE
		user << "<span class='notice'>You remove \the [plate] from \the [src]."
		if(plate.zoom in user.client.images)
			sawer.images -= plate.zoom
		plate = null
		sawer = null
		overlays.Cut()
	else
		..()

/obj/structure/tablesaw/Click(location,control,params)
	if(plate && plate.mode)
		var/clickparams = params2list(params)
		if(clickparams["ctrl"])
			attack_hand(usr)
		else
			plate.Click(location,control,params)
	else
		..()

/obj/structure/tablesaw/MouseMove(location,control,params)
	if(plate && plate.mode)
		plate.MouseMove(location,control,params)
	else
		..()

/obj/item/weapon/woodenplate
	name = "wooden plate"
	desc = "Can be modelled by a table saw."
	icon = 'icons/obj/artstuff.dmi'
	icon_state = "woodenplate"
	var/mode = FALSE // gets set to TRUE when inside the tablesaw.
	var/pixels = 1024 // Number of pixels the icon starts with,needed to delete the object when it has no more pixels left
	var/image/zoom

/obj/item/weapon/woodenplate/New()
	..()
	zoom = image(icon, src, icon_state)
	zoom.transform *= 4
	zoom.pixel_y = 32*4 //one tile above

/obj/item/weapon/woodenplate/proc/saw(mob/user, params)
	var/list/clickparams = params2list(params)
	var/pixX = text2num(clickparams["icon-x"])
	var/pixY = text2num(clickparams["icon-y"])
	var/icon/I = icon(icon, icon_state)
	I = DrawPixel(I, null, pixX, pixY)
	icon = I
	zoom.icon = I
	pixels--
	if(!pixels)
		user.client.images -= zoom
		qdel(src)
		overlays.Cut()

/obj/item/weapon/woodenplate/Click(location,control,params)
	if(mode)
		saw(usr, params)
	else
		..()

/obj/item/weapon/woodenplate/MouseMove(location,control,params)
	if(mode)
		var/list/clickparams = params2list(params)
		if(clickparams["alt"])
			saw(usr, params)
	else
		..()

/obj/item/weapon/paper/tablesaw
	name = "paper - 'How to saw wood correctly'"
	info = "<h2>Steps to saw wood properly</h2><ol> <li>Step 1, get some wooden planks,one will be enough, and saw it on the table saw. It'll give you a wooden plate that can be worked with.</li> <li>Step 2, insert the wooden plate in the table saw, and it'll give you a zoomed in view. You can cut pixels by clicking them,or you can hold alt and move your mouse around to cut several pixels at once!Wow!Remember that you can remove the plate by ctrl clicking the tablesaw.</li> <li>Please be aware that trying to saw too rapidly may lock up the tablesaw and cause...visual glitches.Don't be too slow or too fast.</li>"
