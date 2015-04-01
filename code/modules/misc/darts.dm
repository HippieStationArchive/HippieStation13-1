/obj/structure/darts
	name = "Dart Board"
	desc = "Get drunk, get krunked."
	icon = 'icons/scooterstuff.dmi'
	icon_state = "board"
	var/dart1 = 0
	var/dart2 = 0
	var/dart3 = 0
	var/done = 0
	var/darts = 0

	density = 1
	anchored = 1
	/proc/darts()
		var/D = pick("1","18","4","13","6","10","15","2","17","3","19","7","16","8","11","14","9","12","5","20","50","0","0")
		var/S = text2num(D)
		if(prob(15))
			var/C = S*2
			return C
		return S
/obj/structure/darts/attackby(obj/item/weapon/G, mob/user)
	if(istype(G, /obj/item/weapon/wrench))
		anchored = !anchored
		user << "<span class='notice'>You [anchored ? "attached" : "detached"] [src].</span>"
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)

/obj/structure/darts/Bumped(AM as mob|obj)
	..()
	if(istype(AM,/obj/item/darts))
		if(!done)
			var/obj/item/darts/H = AM
			for(var/mob/M in range(src,5))
				M.playsound_local(src, 'sound/effects/dartboard.ogg', 5, 1, 1, falloff = 5)
			if(!dart1 && darts <= 0)
				dart1 = darts()
				if(dart1 == 50)
					src.visible_message("The dart has hit the bullseye! The total is [total()]")
					desc = "There is one dart on the board, and it is on the bullseye."
				else if(dart1 == 0)
					src.visible_message("The dart has a dead space!")
					desc = "There is one dart on the board, and it is in the dead zone."
				else
					src.visible_message("The dart has hit [dart1]. The total is [total()]")
					desc = "There is one dart on the board, and it is on the [dart1] space."
				darts++

				del(H)
				return
			if(!dart2 && darts <= 1)
				dart2 = darts()
				if(dart2 == 50 && dart1 == 50)
					src.visible_message("The dart has hit the bullseye! The total is [total()]")
					desc = "There are two darts on the board, and both are bullseyes."
				else if(dart2 == 0)
					src.visible_message("The dart has a dead space! The total is [total()]")
					desc = "There are two darts on the board, one is worth [dart1] points, the other hit a dead zone."
				else
					src.visible_message("The dart has hit [dart2]! The total is [total()]")
					desc = "There are two darts on the board, one is worth [dart1] points, the other is worth [dart2] points."
				darts++
				del(H)
				return
			if(!dart3 && darts >= 2)
				dart3 = darts()
				if(dart3 == 50 && dart2 == 50 && dart1 == 50)
					src.visible_message("The dart has hit the bullseye! The total is [total()]")
					desc = "There are three darts on the board, some lucky bastard got all three as bullseyes.."
				else if(dart3 == 0)
					src.visible_message("The dart has a dead space! The total is [total()]")
					desc = "There are three darts on the board, one worth [dart1] points, another worth [dart2] points and the third hit a dead zone."
				else
					src.visible_message("The dart has hit [dart3]! The total is [total()]")
					desc = "There are three darts on the board, one is worth [dart1] points, the second is worth [dart2] points, and the third is worth [dart3] points."
				darts++
				del(H)
				return
/obj/structure/darts/proc/resetdarts()
	dart1 = 0
	dart2 = 0
	dart3 = 0
	done = 0

/obj/structure/darts/proc/total()
	var/C = dart1+dart2+dart3
	return C
/obj/structure/darts/attack_hand(var/mob/user as mob)
	switch(darts)
		if(1)
			new/obj/item/darts(user.loc)
			darts = 0
			resetdarts()
		if(2)
			new/obj/item/darts(user.loc)
			new/obj/item/darts(user.loc)
			resetdarts()
			darts = 0
		if(3)
			new/obj/item/darts(user.loc)
			new/obj/item/darts(user.loc)
			new/obj/item/darts(user.loc)
			darts = 0
			resetdarts()

/obj/item/darts
	name = "Dart"
	desc = "Get the point?"
	icon = 'icons/scooterstuff.dmi'
	icon_state = "dart"
	force = 4
	throwforce = 10
	embedchance = 30
	w_class = 2

