
//Originally stolen from paradise. Credits to tigercat2000.
//Modified a lot by Kokojo.
/obj/machinery/poolcontroller
	name = "Pool Controller"
	desc = "A controller for the nearby pool."
	icon = 'icons/turf/pool.dmi'
	icon_state = "poolcnorm"
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 75
	var/list/linkedturfs = list() //List contains all of the linked pool turfs to this controller, assignment happens on New()
	var/temperature = "normal" //The temperature of the pool, starts off on normal, which has no effects.
	var/srange = 6 //The range of the search for pool turfs, change this for bigger or smaller pools.
	var/linkedmist = list() //Used to keep track of created mist
	var/misted = 0 //Used to check for mist.
//herpderp	var/beaker = null
//herpderp	var/cur_reagent = "pooladone" //Yes, it does exist now.
	var/datum/wires/poolcontroller/wires = null
	var/drainable = 0
	var/drained = 0
	var/bloody = 0
	var/lastbloody = 99
	var/obj/machinery/drain/linkeddrain = null
	var/timer = 0 //we need a cooldown on that shit.
	var/reagenttimer = 0 //We need 2.
	var/seconds_electrified = 0//Shocks morons, like an airlock.

/obj/machinery/poolcontroller/New() //This proc automatically happens on world start
	wires = new(src)
//	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large/pooladone(src)
	for(var/turf/simulated/pool/water/W in range(srange,src)) //Search for /turf/simulated/beach/water in the range of var/srange
		src.linkedturfs += W
	for(var/obj/machinery/drain/pooldrain in range(srange,src))
		src.linkeddrain += pooldrain
	..() //Always call your parents when you're a new thing.

/obj/machinery/poolcontroller/emag_act(user as mob) //Emag_act, this is called when it is hit with a cryptographic sequencer.
	if(!emagged) //If it is not already emagged, emag it.
		user << "\red You disable \the [src]'s temperature safeguards." //Inform the mob of what emagging does.
		emagged = 1 //Set the emag var to true.

/obj/machinery/poolcontroller/attackby(obj/item/weapon/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/screwdriver) && anchored)
		panel_open = !panel_open
		user << "You [panel_open ? "open" : "close"] the maintenance panel."
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, "wires")
		updateUsrDialog()
		return
	else if(istype(W, /obj/item/device/multitool)||istype(W, /obj/item/weapon/wirecutters))
		if(panel_open)
			attack_hand(user)
		updateUsrDialog()
		return

//herpderp	else
//herpderp		if(stat & (NOPOWER|BROKEN))
//herpderp			return
//herpderp		if (istype(W,/obj/item/weapon/reagent_containers/glass/beaker/large))
//herpderp			if(src.beaker)
//herpderp				user << "A beaker is already loaded into the machine."
//herpderp				return

//herpderp			if(isrobot(user))
//herpderp				return

//herpderp			if(W.reagents.total_volume >= 100 && W.reagents.reagent_list.len == 1) //check if full and allow one reageant only.
//herpderp				src.beaker =  W
//herpderp				user.drop_item()
//herpderp				W.loc = src
//herpderp				user << "You add the beaker to the machine!"
//herpderp				updateUsrDialog()
//herpderp				for(var/datum/reagent/R in W.reagents.reagent_list)
//herpderp					src.cur_reagent = R.id
//herpderp					if(adminlog)
//herpderp						log_say("[key_name(user)] has changed the pool's chems to [R.name]")
//herpderp						message_admins("[key_name_admin(user)] has changed the pool's chems to [R.name].")


//herpderp			else
//herpderp				user << "<span class='notice'>This machine only accepts full beakers of one reagent.</span>"
//herpderp		else



/obj/machinery/vending/attack_paw(mob/user)
	return attack_hand(user)

//procs
/obj/machinery/poolcontroller/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/poolcontroller/proc/wires()
	return wires.GetInteractWindow()

//herpderp	/obj/machinery/poolcontroller/proc/poolreagent()
//herpderp		for(var/turf/simulated/pool/water/W in linkedturfs)
//herpderp			for(var/mob/living/carbon/human/swimee in W)
//herpderp				if(beaker && cur_reagent)
//herpderp					swimee.reagents.add_reagent(cur_reagent, 1)
//herpderp					reagenttimer = 5
//				world << "got [cur_reagent]"

/obj/machinery/poolcontroller/process()
	updatePool() //Call the mob affecting proc)
	if(timer > 0)
		timer--
		updateUsrDialog()
//herpderp	if(reagenttimer > 0)
//herpderp		reagenttimer--
	if(stat & (NOPOWER|BROKEN))
		return
//herpderp	else if(reagenttimer == 0)
//herpderp		poolreagent()

/obj/machinery/poolcontroller/proc/updatePool()
	if(!drained)
		for(var/turf/simulated/pool/water/W in linkedturfs) //Check for pool-turfs linked to the controller.
			for(var/mob/M in W) //Check for mobs in the linked pool-turfs.
				if(isobserver(M))
					continue

				//End sanity checks, go on
				switch(temperature) //Apply different effects based on what the temperature is set to.
					if("Scalding") //Burn the mob.
						M.bodytemperature = min(500, M.bodytemperature + 35) //heat mob at 35k(elvin) per cycle
						// if(M.bodytemperature >= 400 && !M.stat)
							// M << "<span class='danger'>You're boiling alive!</span>"

					if("Frigid") //Freeze the mob.
						M.bodytemperature = max(80, M.bodytemperature - 35) //cool mob at -35k per cycle, less would not affect the mob enough.
						// if(M.bodytemperature <= 215 && !M.stat)
							// M << "<span class='danger'>You're being frozen solid!</span>"

					if("Normal") //Normal temp does nothing, because it's just room temperature water.

					if("Warm") //Gently warm the mob.
						M.bodytemperature = min(360, M.bodytemperature + 20) //Heats up mobs till the termometer shows up

					if("Cool") //Gently cool the mob.
						M.bodytemperature = max(250, M.bodytemperature - 20) //Cools mobs till the termometer shows up
				var/mob/living/carbon/human/drownee = M
				if(drownee.stat == DEAD)
					continue
				if(drownee && drownee.lying && !drownee.internal)
					if(drownee.stat != CONSCIOUS)
						drownee.adjustOxyLoss(9)
						drownee << "<span class='danger'>You're quickly drowning!</span>"
					else
						if(!drownee.internal)
							drownee.adjustOxyLoss(4)
							if(prob(35))
								drownee << "<span class='danger'>You're lacking air!</span>"

			for(var/obj/effect/decal/cleanable/decal in W)
				if(bloody < 800)
					animate(decal, alpha = 10, time = 20)
					spawn(25)
						qdel(decal)
				if(istype(decal,/obj/effect/decal/cleanable/blood) || istype(decal, /obj/effect/decal/cleanable/trail_holder))
					bloody++
					if(bloody > lastbloody)
						changecolor()

/obj/machinery/poolcontroller/proc/changecolor()
	lastbloody = bloody+99
	switch(bloody)
		if(0 to 99)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FFFFFF"
				color1.watereffect.color = "#FFFFFF"
		if(100 to 199)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FFDDDD"
				color1.watereffect.color = "#FFDDDD"
		if(100 to 199)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FFCCCC"
				color1.watereffect.color = "#FFCCCC"
		if(200 to 299)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FFBBBB"
				color1.watereffect.color = "#FFBBBB"
		if(300 to 399)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FFAAAA"
				color1.watereffect.color = "#FFAAAA"
		if(400 to 499)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FF9999"
				color1.watereffect.color = "#FF9999"
		if(500 to 599)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FF8888"
				color1.watereffect.color = "#FF8888"
		if(600 to 699)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FF7777"
				color1.watereffect.color = "#FF7777"
		if(700 to 799)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FF7777"
				color1.watereffect.color = "#FF7777"
		if(800 to 899)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FF6666"
				color1.watereffect.color = "#FF6666"
		if(900 to INFINITY)
			for(var/turf/simulated/pool/water/color1 in linkedturfs)
				color1.color = "#FF5555"
				color1.watereffect.color = "#FF5555"
				src.bloody = 1000

/obj/machinery/poolcontroller/proc/miston() //Spawn /obj/effect/mist (from the shower) on all linked pool tiles
	for(var/turf/simulated/pool/water/W in linkedturfs)
		var/M = new /obj/effect/mist(W)
		if(misted)
			return
		linkedmist += M

	misted = 1 //var just to keep track of when the mist on proc has been called.

/obj/machinery/poolcontroller/proc/mistoff() //Delete all /obj/effect/mist from all linked pool tiles.
	for(var/obj/effect/mist/M in linkedmist)
		qdel(M)
	misted = 0 //no mist left, turn off the tracking var

/obj/machinery/poolcontroller/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	else
		user.set_machine(src)
		var/dat = ""
		if(panel_open)
			dat += wires()


		dat += text({"
					<BR><TT><B>Pool Controller Panel</B></TT><BR><BR>
					<B>Current temperature :</B> [temperature]<BR>
					</B>Drain is [drainable ? "active" : "unactive"]</B> <BR>"})

//herpderp			if(beaker)
//herpderp				dat += "<a href='?src=\ref[src];beaker=1'>Remove Beaker</a><br>"
//herpderp				dat += "<B><span class='good'>Duplicator filled with [cur_reagent].</span></B><BR><BR><BR>"
//herpderp			if(!beaker)
//herpderp				dat += "<B><span class='bad'>No beaker loaded</span></B><BR><BR><BR>"

		dat += text({"<B>Pool status :</B>      "})
		if(timer < 45)
			switch(drained)
				if(0)
					dat += "<span class='good'>Full</span><BR>"
				if(1)
					dat += "<span class='bad'>Drained</span><BR>"
		if(timer >= 45)
			dat += "<span class='bad'>Warning. Do not approach drain!<BR></span>"

		dat += "<span class='notice'>[timer] seconds left until pool can operate again.<BR></span>"

		if(timer == 0 && drained == 0)
			if(emagged)
				dat += "<a href='?src=\ref[src];Scalding=1'>Scalding</a><br>"
			dat += "<a href='?src=\ref[src];Warm=1'>Warm</a><br>"
			dat += "<a href='?src=\ref[src];Normal=1'>Normal</a><br>"
			dat += "<a href='?src=\ref[src];Cool=1'>Cool</a><br>"
			if(emagged)
				dat += "<a href='?src=\ref[src];Frigid=1'>Frigid</a><br>"
		if(drainable && !drained && !timer)
			dat += "<a href='?src=\ref[src];Activate Drain=1'>Drain Pool</a><br>"
		if(drainable && drained && !timer)
			dat += "<a href='?src=\ref[src];Activate Drain=1'>Fill Pool</a><br>"




		var/datum/browser/popup = new(user, "Pool Controller", name, 350, 550)
		popup.set_content(dat)
		popup.open()

/obj/machinery/poolcontroller/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
//herpderp		if(href_list["beaker"])
//herpderp			if(beaker)
//herpderp				var/obj/item/weapon/reagent_containers/glass/B = beaker
//herpderp				B.loc = loc
//herpderp				beaker = null
	if(href_list["Scalding"])
		if(emagged)
			timer = 10
			src.temperature = "Scalding"
			src.icon_state = "poolcscald"
			if(!misted)
				miston()
		if(!emagged)
			message_admins("[key_name_admin(usr)] is trying to use href exploits with the poolcontroller")
	if(href_list["Warm"])
		timer = 10
		src.temperature = "Warm"
		src.icon_state = "poolcwarm"
		mistoff()
	if(href_list["Normal"])
		timer = 10
		src.temperature = "Normal"
		src.icon_state = "poolcnorm"
		mistoff()
	if(href_list["Cool"])
		timer = 10
		src.temperature = "Cool"
		src.icon_state = "poolccool"
		mistoff()
	if(href_list["Frigid"])
		if(emagged)
			timer = 10
			src.temperature = "Frigid"
			src.icon_state = "poolcfrig"
			mistoff()
		if(!emagged)
			message_admins("[key_name_admin(usr)] is trying to use href exploits with the poolcontroller")
	if(href_list["Activate Drain"])
		if(drainable) //Drain is activated
			if(linkeddrain.active == 1)
				return
			if(timer > 0)
				return
			else
				mistoff()
				linkeddrain.active = 1
				linkeddrain.timer = 15
				timer = 60
				if(linkeddrain.status == 0)
					new /obj/effect/whirlpool(linkeddrain.loc)
					temperature = "None"
					icon_state = "poolcnorm"
				if(linkeddrain.status == 1)
					new /obj/effect/effect/waterspout(linkeddrain.loc)
					temperature = "Normal"
		if(!drainable)
			message_admins("[key_name_admin(usr)] is trying to use href exploits with the poolcontroller")
	update_icon()
	updateUsrDialog()