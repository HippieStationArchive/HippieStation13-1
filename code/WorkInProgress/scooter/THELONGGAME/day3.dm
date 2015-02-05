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
	maxturns = rand(15,30)
	for(var/turf/simulated/floor/C in world)
		landlist.Add(C)
	sleep(20)
	begin()

/datum/fun/thunderstorm/shell/New()
	maxturns = rand(4,12)
	for(var/turf/simulated/floor/C in world)
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
		turns--
		sleep(10)



/datum/fun/thunderstorm/proc/syndicate()
	maxturns = 10
	for(var/mob/C in world)
		playsound(C,'sound/effects/shelling.ogg',50,1)
	while(turns <= maxturns)
		var/turf/temploc = pick(landlist)
		turns++
		for(var/mob/living/C in temploc)
			C.adjustFireLoss(10)
		explosion(temploc,-1,-1,rand(2,4),4)
		sleep(5)

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