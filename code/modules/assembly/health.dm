/obj/item/device/assembly/health
	name = "health sensor"
	desc = "Used for scanning and monitoring health."
	icon_state = "health"
	materials = list(MAT_METAL=800, MAT_GLASS=200)
	origin_tech = "magnets=1;biotech=1"
	attachable = 1
	secured = 0

	var/scanning = 0
	var/health_scan
	var/alarm_health = 0



/obj/item/device/assembly/health/activate()
	if(!..())	return 0//Cooldown check
	toggle_scan()
	return 0

/obj/item/device/assembly/health/toggle_secure()
	secured = !secured
	if(secured && scanning)
		SSobj.processing |= src
	else
		scanning = 0
		SSobj.processing.Remove(src)
	update_icon()
	return secured

/obj/item/device/assembly/health/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/multitool))
		alarm_health = Clamp(input(user,"Input health variable to detect from -90 to 80 (0 is crit state, 80 is hurt, -90 is death)",src,0) as num, -90, 80)
		return
	..()

/obj/item/device/assembly/health/HasProximity(mob/living/M)
	if(!secured || !scanning || cooldown > 0)
		return
	if(!istype(M))
		return
	health_scan = M.health
	if(health_scan <= alarm_health)
		pulse()
		audible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
		cooldown = 2
		spawn(10)
			process_cooldown()

/obj/item/device/assembly/health/proc/toggle_scan()
	if(!secured)	return 0
	scanning = !scanning
	if(scanning)
		SSobj.processing |= src
	else
		SSobj.processing.Remove(src)
		health_scan = null

/obj/item/device/assembly/health/interact(mob/user as mob)//TODO: Change this to the wires thingy
	if(!secured)
		user.show_message("<span class='warning'>The [name] is unsecured!</span>")
		return 0
	var/dat = text("<TT><B>Health Sensor</B> <A href='?src=\ref[src];scanning=1'>[scanning?"On":"Off"]</A>")
	dat += "<BR><i>Detecting health <= [alarm_health]</i>"
	if(scanning && health_scan)
		dat += "<BR>Health: [health_scan]"
	user << browse(dat, "window=hscan")
	onclose(user, "hscan")


/obj/item/device/assembly/health/Topic(href, href_list)
	..()
	if(!ismob(usr))
		return

	var/mob/user = usr

	if(!user.canUseTopic(user))
		usr << browse(null, "window=hscan")
		onclose(usr, "hscan")
		return

	if(href_list["scanning"])
		toggle_scan()

	if(href_list["close"])
		usr << browse(null, "window=hscan")
		return

	attack_self(user)