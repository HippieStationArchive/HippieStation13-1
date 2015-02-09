var/global/datum/fun/thunderstorm

/proc/callthunder()
	thunderstorm = new/datum/fun/thunderstorm

/proc/syndicateshell()
	thunderstorm = new/datum/fun/thunderstorm/shell


/datum/fun/thunderstorm
	var/list/turf/landlist = list()
	var/thunder = 0
	var/maxturns = 50
	var/turns = 0
	var/shell

/datum/fun/thunderstorm/New()
	maxturns = rand(4,12)
	for(var/turf/simulated/floor/C in world)
		if(C.z == 1)
			landlist.Add(C)
	sleep(20)
	begin()

/datum/fun/thunderstorm/shell/New()
	maxturns = rand(4,12)
	for(var/turf/simulated/floor/C in world)
		if(C.z == 1)
			landlist.Add(C)
	sleep(20)
	syndicate()

/datum/fun/thunderstorm/proc/begin()
	while(turns <= maxturns)
		var/turf/temploc = pick(landlist)
		var/obj/effect/lightning/L = new /obj/effect/lightning()
		L.loc = get_turf(temploc)
		L.layer = temploc.layer+1 //i want it to display over clothing
		L.start()
		playsound(temploc,'sound/effects/thunder.ogg',50,1)
		for(var/mob/living/C in temploc)
			C.adjustFireLoss(10)
	//	world << "[temploc.loc]"
		explosion(L.loc,-1,-1,rand(2,4),4)
		spawn(10)
			qdel(L)
		turns++
		sleep(10)


/obj/machinery/computer/syndicate/bomber
	name = "Short-Ranged Subspace Artillery"
	desc = "Buy a bombing device with telecrystals to activate"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndishuttle"

	attackby(var/obj/C as obj)
		if(z != 1)
			usr << "\red Your shuttle is too far away to fire!"
		else
			usr << "\red You insert the disk and the computer begins to fire the missles! Whatever they hit, who knows!"
			usr.drop_item(src)
			syndicateshell()
			del(src)

/obj/item/weapon/disk/bombing
	name = "S-RSA Activation Disk"
	desc = "Insert into a Short-Ranged Subspace Artillery computer to carpet bomb a target"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sec_lock"



/datum/fun/thunderstorm/proc/syndicate()
	maxturns = 10
	for(var/mob/C in world)
		playsound(C,'sound/effects/shelling.ogg',50,1)

	while(turns <= maxturns)
		var/turf/temploc = targetlogic()

		turns++
		for(var/mob/living/C in temploc)
			C.adjustFireLoss(10)
		explosion(temploc,rand(1,4),rand(2,4),rand(2,4),4)
		sleep(5)

/datum/fun/thunderstorm/proc/targetlogic()
	var/targetlogic = rand(1,75)
	var/list/turf/tempholder = list()
	switch(targetlogic)
		if(1 to 15)
			for(var/turf/space/C in landlist)
				tempholder.Add(C)
			if(tempholder)
				var/turf/V = pick(tempholder)
				return V
		if(16 to 50)
			for(var/turf/simulated/C in landlist)
				tempholder.Add(C)
			if(tempholder)
				var/turf/V = pick(tempholder)
				return V
		if(51 to 65)
			for(var/turf/simulated/C in landlist)
				if(/obj/machinery/power/smes in C.contents)
					tempholder.Add(C)
			if(tempholder)
				var/turf/V = pick(tempholder)
				return V
		if(66 to 75)
			for(var/turf/simulated/C in landlist)
				if(/obj/machinery/computer/communications in C.contents)
					tempholder.Add(C)
			if(tempholder)
				var/turf/V = pick(tempholder)
				return V