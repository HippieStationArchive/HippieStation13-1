/* In this file:
 *
 * Plating
 * Airless
 * Airless plating
 * Engine floor
 */
// note that plating and engine floor do not call their parent attackby, unlike other flooring
// this is done in order to avoid inheriting the crowbar attackby

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	intact = 0
	broken_states = list("platingdmg1", "platingdmg2", "platingdmg3")
	burnt_states = list("panelscorched")

/turf/simulated/floor/plating/New()
	..()
	icon_plating = icon_state

/turf/simulated/floor/plating/update_icon()
	if(!..())
		return
	if(!broken && !burnt)
		icon_state = icon_plating //Because asteroids are 'platings' too.

/turf/simulated/floor/plating/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/stack/rods))
		if(broken || burnt)
			user << "<span class='warning'>Repair the plating first!</span>"
			return
		var/obj/item/stack/rods/R = C
		if (R.get_amount() < 2)
			user << "<span class='warning'>You need two rods to make a reinforced floor!</span>"
			return
		else
			user << "<span class='notice'>You begin reinforcing the floor...</span>"
			if(do_after(user, 30, target = src))
				if (R.get_amount() >= 2 && !istype(src, /turf/simulated/floor/engine))
					ChangeTurf(/turf/simulated/floor/engine)
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
					R.use(2)
					user << "<span class='notice'>You reinforce the floor.</span>"
				return
	else if(istype(C, /obj/item/stack/tile))
		if(!broken && !burnt)
			var/obj/item/stack/tile/W = C
			if(!W.use(1))
				return
			var/turf/simulated/floor/T = ChangeTurf(W.turf_type)
			if(istype(W,/obj/item/stack/tile/light)) //TODO: get rid of this ugly check somehow
				var/obj/item/stack/tile/light/L = W
				var/turf/simulated/floor/light/F = T
				F.state = L.state
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		else
			user << "<span class='warning'>This section is too damaged to support a tile! Use a welder to fix the damage.</span>"
	else if(istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/welder = C
		if( welder.isOn() && (broken || burnt) )
			if(welder.remove_fuel(0,user))
				user << "<span class='danger'>You fix some dents on the broken plating.</span>"
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
				icon_state = icon_plating
				burnt = 0
				broken = 0

/turf/simulated/floor/plating/airless
	icon_state = "plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000
	floor_tile = /obj/item/stack/rods

/turf/simulated/floor/engine/break_tile()
	return //unbreakable

/turf/simulated/floor/engine/burn_tile()
	return //unburnable

/turf/simulated/floor/engine/make_plating(force = 0)
	if(force)
		..()
	return //unplateable

/turf/simulated/floor/engine/attackby(obj/item/weapon/C, mob/user, params)
	if(!C || !user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "<span class='notice'>You begin removing rods...</span>"
		playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30/C.toolspeed, target = src))
			if(!istype(src, /turf/simulated/floor/engine))
				return
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor/plating)
			return


/turf/simulated/floor/engine/ex_act(severity,target)
	switch(severity)
		if(1)
			if(prob(80))
				ReplaceWithLattice()
			else if(prob(50))
				qdel(src)
			else
				make_plating(1)
		if(2)
			if(prob(50))
				make_plating(1)


/turf/simulated/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/simulated/floor/engine/cult/narsie_act()
	return

/turf/simulated/floor/engine/n20/New()
	..()
	var/datum/gas_mixture/adding = new
	var/datum/gas/sleeping_agent/trace_gas = new

	trace_gas.moles = 6000
	adding.trace_gases += trace_gas
	adding.temperature = T20C

	assume_air(adding)

/turf/simulated/floor/engine/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		if(builtin_tile)
			if(prob(30))
				builtin_tile.loc = src
				make_plating()
		else if(prob(30))
			ReplaceWithLattice()

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/plasteel/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/plating/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/simulated/floor/plating/abductor/New()
	..()
	icon_state = "alienpod[rand(1,9)]"



/turf/simulated/floor/plating/basalt
	name = "basalt floor"
	icon_state = "basalt1"

/turf/simulated/floor/plating/basalt/New()
	..()
	icon_state = "basalt[rand(1,12)]"

/turf/simulated/floor/plating/basalt/Destroy()
	return QDEL_HINT_LETMELIVE

/turf/simulated/floor/plating/basalt/ex_act()
	return ..()


///LAVA


/turf/simulated/floor/plating/lava
	name = "lava"
	icon_state = "lava"
	baseturf = /turf/simulated/floor/plating/lava //lava all the way down
	slowdown = 2
	var/processing = 0
	luminosity = 1

/turf/simulated/floor/plating/lava/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/plating/lava/deadly

/turf/simulated/floor/plating/lava/deadly/ex_act()
	return ..()

/turf/simulated/floor/plating/lava/deadly/Entered(atom/movable/AM)
	burn_stuff()
	if(!processing)
		processing = 1
		SSobj.processing |= src

/turf/simulated/floor/plating/lava/deadly/process()
	if(!contents)
		processing = 0
		SSobj.processing.Remove(src)
		return
	burn_stuff()

/turf/simulated/floor/plating/lava/deadly/proc/burn_stuff()
	for(var/atom/movable/AM in contents)
		if(!istype(AM))
			return
		if(istype(AM, /obj))
			var/obj/O = AM
			if(istype(O, /obj/effect/decal/cleanable/ash)) //So we don't get stuck burning the same ash pile forever
				qdel(O)
				return
			if(O.burn_state == -1)
				O.burn_state = 0 //Even fireproof things burn up in lava
			O.fire_act()
		else if (istype(AM, /mob/living))
			var/mob/living/L = AM
			L.adjustFireLoss(20)
			L.adjust_fire_stacks(20)
			L.IgniteMob()

/turf/simulated/floor/plating/lava/deadly/break_tile()
	return

/turf/simulated/floor/plating/lava/deadly/burn_tile()
	return

/turf/simulated/floor/plating/lava/deadly/attackby(obj/item/C, mob/user, params) //Lava isn't a good foundation to build on
	return

/turf/simulated/floor/plating/lava/deadly/smooth
	name = "lava"
	baseturf = /turf/simulated/floor/plating/lava/deadly/smooth
	smooth = SMOOTH_TRUE
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "smooth"
	canSmoothWith = list(/turf/simulated/wall)

/turf/simulated/floor/plating/lava/deadly/smooth/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
