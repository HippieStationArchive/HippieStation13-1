var/global/datum/ep

/proc/how2()
	ep = new/datum/ep

/datum/ep
	var/on = 1
	New()
		begin()

/datum/ep/proc/begin()
	while(on)
		for(var/turf/C in world)
			C.color = pick("red","blue","purple","yellow","orange","green")
			sleep(rand(1,5))
		for(var/mob/C in world)
			C.color = pick("red","blue","purple","yellow","orange","green")
			sleep(rand(1,5))
		for(var/obj/C in world)
			C.color = pick("red","blue","purple","yellow","orange","green")
			sleep(rand(1,5))