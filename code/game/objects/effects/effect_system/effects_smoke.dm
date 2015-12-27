/////////////////////////////////////////////
//// SMOKE SYSTEMS
/////////////////////////////////////////////

/obj/effect/effect/smoke
	name = "smoke"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke"
	pixel_x = -32
	pixel_y = -32
	opacity = 0
	anchored = 1
	mouse_opacity = 0
	animate_movement = 0
	var/amount = 4
	var/lifetime = 5
	var/opaque = 1 //whether the smoke can block the view when in enough amount

/obj/effect/effect/smoke/proc/fade_out(frames = 16)
	if(alpha == 0) //Handle already transparent case
		return
	if(frames == 0)
		frames = 1 //We will just assume that by 0 frames, the coder meant "during one frame".
	var/step = alpha / frames
	for(var/i = 0, i < frames, i++)
		alpha -= step
		sleep(world.tick_lag)

/obj/effect/effect/smoke/New()
	..()
	create_reagents(500)
	SSobj.processing |= src


/obj/effect/effect/smoke/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/effect/effect/smoke/proc/kill_smoke()
	SSobj.processing.Remove(src)
	spawn(0)
		fade_out()
	spawn(10)
		qdel(src)

/obj/effect/effect/smoke/process()
	lifetime--
	if(lifetime < 1)
		kill_smoke()
		return 0
	for(var/mob/living/L in range(0,src))
		smoke_mob(L)
	return 1

/obj/effect/effect/smoke/proc/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return 0
	if(lifetime<1)
		return 0
	if(C.internal != null || C.has_smoke_protection())
		return 0
	if(C.smoke_delay)
		return 0
	C.smoke_delay++
	spawn(10)
		if(C)
			C.smoke_delay = 0
	return 1

/obj/effect/effect/smoke/proc/spread_smoke()
	var/turf/t_loc = get_turf(src)
	var/list/newsmokes = list()
	for(var/turf/T in t_loc.GetAtmosAdjacentTurfs())
		var/obj/effect/effect/smoke/foundsmoke = locate() in T //Don't spread smoke where there's already smoke!
		if(foundsmoke)
			continue
		for(var/mob/living/L in T)
			smoke_mob(L)
		var/obj/effect/effect/smoke/S = new type(T)
		reagents.copy_to(S, reagents.total_volume)
		S.dir = pick(cardinal)
		S.amount = amount-1
		S.color = color
		S.lifetime = lifetime
		if(S.amount>0)
			if(opaque)
				S.opacity = 1
			newsmokes.Add(S)

	if(newsmokes.len)
		spawn(1) //the smoke spreads rapidly but not instantly
			for(var/obj/effect/effect/smoke/SM in newsmokes)
				SM.spread_smoke()

/datum/effect_system/smoke_spread
	var/amount = 10
	var/smoke_type = /obj/effect/effect/smoke

/datum/effect_system/smoke_spread/set_up(radius = 5, loca)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	amount = radius

/datum/effect_system/smoke_spread/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/effect/smoke/S = new smoke_type(location)
	S.amount = amount
	if(S.amount)
		S.spread_smoke()



/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/bad
	lifetime = 8

/obj/effect/effect/smoke/bad/smoke_mob(mob/living/carbon/M)
	if(..())
		M.drop_item()
		M.adjustOxyLoss(1)
		M.emote("cough")
		return 1

/obj/effect/effect/smoke/bad/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0) return 1
	if(istype(mover, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = mover
		B.damage = (B.damage/2)
	return 1



/datum/effect_system/smoke_spread/bad
	smoke_type = /obj/effect/effect/smoke/bad

/////////////////////////////////////////////
// Nanofrost smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/freezing
	name = "nanofrost smoke"
	color = "#B2FFFF"
	opaque = 0

/datum/effect_system/smoke_spread/freezing
	smoke_type = /obj/effect/effect/smoke/freezing
	var/blast = 0

/datum/effect_system/smoke_spread/freezing/proc/Chilled(atom/A)
	if(istype(A, /turf/simulated))
		var/turf/simulated/T = A
		if(T.air)
			var/datum/gas_mixture/G = T.air
			if(get_dist(T, location) < 2) // Otherwise we'll get silliness like people using Nanofrost to kill people through walls with cold air
				G.temperature = 2
			T.air_update_turf()
			for(var/obj/effect/hotspot/H in T)
				qdel(H)
				if(G.toxins)
					G.nitrogen += (G.toxins)
					G.toxins = 0
		for(var/obj/machinery/atmospherics/components/unary/U in T)
			if(!isnull(U.welded) && !U.welded) //must be an unwelded vent pump or vent scrubber.
				U.welded = 1
				U.update_icon()
				U.visible_message("<span class='danger'>[U] was frozen shut!</span>")
		for(var/mob/living/L in T)
			L.ExtinguishMob()
		for(var/obj/item/Item in T)
			Item.extinguish()
	return

/datum/effect_system/smoke_spread/freezing/set_up(radius = 5, loca, blasting = 0)
	..()
	blast = blasting

/datum/effect_system/smoke_spread/freezing/start()
	if(blast)
		for(var/turf/T in trange(2, location))
			Chilled(T)
	..()



/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/sleeping
	color = "#9C3636"
	lifetime = 10

/obj/effect/effect/smoke/sleeping/smoke_mob(mob/living/carbon/M)
	if(..())
		M.drop_item()
		M.sleeping = max(M.sleeping,10)
		M.emote("cough")
		return 1

/datum/effect_system/smoke_spread/sleeping
	smoke_type = /obj/effect/effect/smoke/sleeping

/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/chem
	lifetime = 10


/obj/effect/effect/smoke/chem/process()
	if(..())
		var/turf/T = get_turf(src)
		var/fraction = 1/initial(lifetime)
		for(var/atom/movable/AM in T)
			if(AM.type == src.type)
				continue
			reagents.reaction(AM, TOUCH, fraction)

 		reagents.reaction(T, TOUCH, fraction)
		return 1

/obj/effect/effect/smoke/chem/smoke_mob(mob/living/carbon/M)
	if(lifetime<1)
		return 0
	if(!istype(M))
		return 0
	var/mob/living/carbon/C = M
	if(C.internal != null || C.has_smoke_protection())
		return 0
	var/fraction = 1/initial(lifetime)
	reagents.copy_to(C, fraction*reagents.total_volume)
	reagents.reaction(M, INGEST, fraction)
	return 1



/datum/effect_system/smoke_spread/chem
	var/obj/chemholder
	smoke_type = /obj/effect/effect/smoke/chem

/datum/effect_system/smoke_spread/chem/New()
	..()
	chemholder = PoolOrNew(/obj)
	var/datum/reagents/R = new/datum/reagents(500)
	chemholder.reagents = R
	R.my_atom = chemholder

/datum/effect_system/smoke_spread/chem/Destroy()
	qdel(chemholder)
	chemholder = null
	return ..()

/datum/effect_system/smoke_spread/chem/set_up(datum/reagents/carry = null, radius = 1, loca, silent = 0)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	amount = radius
	carry.copy_to(chemholder, 4*carry.total_volume) //The smoke holds 4 times the total reagents volume for balance purposes.

	if(!silent)
		var/contained = ""
		for(var/reagent in carry.reagent_list)
			contained += " [reagent] "
		if(contained)
			contained = "\[[contained]\]"
		var/area/A = get_area(location)

		var/where = "[A.name] | [location.x], [location.y]"
		var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

		if(carry.my_atom.fingerprintslast)
			var/mob/M = get_mob_by_key(carry.my_atom.fingerprintslast)
			var/more = ""
			if(M)
				more = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>?</a>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[M]'>FLW</A>) "
			message_admins("A chemical smoke reaction has taken place in ([whereLink])[contained]. Last associated key is [carry.my_atom.fingerprintslast][more].", 0, 1)
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last associated key is [carry.my_atom.fingerprintslast].")
		else
			message_admins("A chemical smoke reaction has taken place in ([whereLink]). No associated key.", 0, 1)
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. No associated key.")


/datum/effect_system/smoke_spread/chem/start()
	var/color = mix_color_from_reagents(chemholder.reagents.reagent_list)
	if(holder)
		location = get_turf(holder)
	var/obj/effect/effect/smoke/chem/S = new smoke_type(location)

	if(chemholder.reagents.total_volume > 1) // can't split 1 very well
		chemholder.reagents.copy_to(S, chemholder.reagents.total_volume)

	if(color)
		S.color = color // give the smoke color, if it has any to begin with
	S.amount = amount
	if(S.amount)
		S.spread_smoke() //calling process right now so the smoke immediately attacks mobs.