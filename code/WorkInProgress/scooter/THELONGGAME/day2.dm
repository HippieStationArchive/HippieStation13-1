//goonmod

var/global/datum/goonmod/goonmod

/proc/goonmod()
	goonmod = new/datum/goonmod
	goonmod.begin()

/datum/goonmod
	var/list/playerlist1 = list()//griefbadminnery
	var/list/playerlist2 = list()//monkey
	var/list/playerlist3 = list()//bodily functions
	var/on = 0

/datum/goonmod/proc/begin()
	for(var/mob/living/C in world)
		if(!C.client)
			continue
		var/X = pick(1)
		switch(X)
			if(1)
				playerlist1.Add(C)
			if(2)
				playerlist2.Add(C)
			if(3)
				playerlist3.Add(C)
	sleep(100)
	on = 1
	processdatum()

/datum/goonmod/proc/processdatum()
	while(on)
		if(playerlist1)
			for(var/mob/living/carbon/C in playerlist1)
				var/X = pick(1,2,3,4,5,6,7,8,9,10)
				switch(X)
					if(1)
						var/list/obj/structure/closet/lockerlist = list()
						for(var/obj/structure/closet/V in world)
							if(V.z != 1)
								return
							lockerlist.Add(V)
						if(lockerlist)
							var/obj/structure/closet/A = pick(lockerlist)
							C.loc = A.contents
							A.welded = 1
							A.name = "gay baby jail"
							C << "\red WHAT THE DINK! You are locked in a locker!"
					if(2)
						C.handcuffed = new /obj/item/weapon/restraints/handcuffs/cable/zipties/used(C)
						C.update_inv_handcuffed(0)	//update the handcuffs overlay
						C << "\red You suddenly find your hands unable to move!"
					if(3)
						C.color = pick("red","blue", "purple", "green")
						C << "\red You feel colorful."
					if(4)
					//	C.say("*megascream")
					if(5)
						C.loc = pick(playerlist2)
						C << "\red You feel like you are inside someone"
					if(6)
						for(var/obj/item/W in C)
							C.unEquip(W)
						C << "\red You dropped everything you had! What a clutz!"
					if(7)
						var/text = "Just a heads up [C.name] is a giant cockmongling traitor."
						var/title = "[pick(playerlist3)] Announces"
						priority_announce(text, title)
					if(8)
						C.x = rand(1,255)
						C.y = rand(1,255)
						C << "\red You randomly warp!"
					if(9)
						var/mob/Q = pick(playerlist3)
						C.loc = Q.loc
						C.say("*superfart")
					if(10)
						C.gib()

		if(playerlist2)
			for(var/mob/living/C in playerlist2)
				var/X = pick(1,2,3,4,5,6,7,8,9,10)
				return

		if(playerlist3)
			for(var/mob/living/C in playerlist3)
				var/X = pick(1,2,3,4,5,6,7,8,9,10)
				return
		sleep(100)