//WATER EFFECTS

/obj/effect/particle_effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	var/life = 15
	mouse_opacity = 0


/obj/effect/particle_effect/water/New()
	..()
	spawn( 70 )
		qdel(src)

/obj/effect/particle_effect/water/Move(turf/newloc)
	if (--src.life < 1)
		qdel(src)
		return 0
	if(newloc.density)
		return 0
	.=..()

/obj/effect/particle_effect/water/Bump(atom/A)
	if(reagents)
		reagents.reaction(A)
	return ..()


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect_system/steam_spread/steam = new /datum/effect_system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/particle_effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	density = 0

/obj/effect/particle_effect/steam/New()
	..()
	spawn(20)
		qdel(src)

/datum/effect_system/steam_spread
	effect_type = /obj/effect/particle_effect/steam