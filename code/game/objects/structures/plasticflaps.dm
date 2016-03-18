/obj/structure/plasticflaps	//HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "plastic flaps"
	desc = "Definitely can't get past those. No way."
	icon = 'icons/obj/stationobjs.dmi'	//Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	layer = 4

/obj/structure/plasticflaps/CanPass(atom/movable/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	if (!istype(A, /obj/machinery/bot/mulebot) && A.can_buckle && (A.buckled_mob || A.density))//if someone is buckled, it will not pass
		return 0

	else if(istype(A, /mob/living)) // You Shall Not Pass!
		var/mob/living/M = A
		if(M.buckled && istype(M.buckled, /obj/machinery/bot/mulebot)) // mulebot passenger gets a free pass.
			return 1
		if(!M.lying && !M.ventcrawler && M.mob_size != MOB_SIZE_TINY)	//If your not laying down, or a ventcrawler or a small creature, no pass.
			return 0
	return ..()

/obj/structure/plasticflaps/attackby(obj/item/weapon/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/structure/plasticflaps/ex_act(severity)
	..()
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

/obj/structure/plasticflaps/mining/New() //set the turf below the flaps to block air
	var/turf/T = get_turf(loc)
	if(T)
		T.blocks_air = 1
	..()

/obj/structure/plasticflaps/mining/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor //wow this is terrible
	var/turf/T = get_turf(loc)
	if(T)
		if(istype(T, /turf/simulated/floor))
			T.blocks_air = 0
	return ..()
