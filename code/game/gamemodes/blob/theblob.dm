//I will need to recode parts of this but I am way too tired atm
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	luminosity = 3
	desc = "A thick wall of writhing tendrils."
	density = 0 //this being 0 causes two bugs, being able to attack blob tiles behind other blobs and being unable to move on blob tiles in no gravity, but turning it to 1 causes the blob mobs to be unable to path through blobs, which is probably worse.
	opacity = 0
	anchored = 1
	explosion_block = 1
	var/health = 30
	var/maxhealth = 30
	var/health_regen = 2
	var/health_timestamp = 0
	var/brute_resist = 2
	var/fire_resist = 1
	var/mob/camera/blob/overmind


/obj/effect/blob/New(loc)
	blobs += src
	src.dir = pick(1, 2, 4, 8)
	src.update_icon()
	..(loc)
	for(var/atom/A in loc)
		A.blob_act()
	return


/obj/effect/blob/Destroy()
	blobs -= src
	if(isturf(loc)) //Necessary because Expand() is retarded and spawns a blob and then deletes it
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
	return ..()


/obj/effect/blob/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0)	return 1
	if(istype(mover) && mover.checkpass(PASSBLOB))	return 1
	return 0


/obj/effect/blob/process()
	Life()
	return

/obj/effect/blob/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/damage = Clamp(0.01 * exposed_temperature, 0, 4)
	take_damage(damage, BURN)

/obj/effect/blob/proc/Life()
	return

/obj/effect/blob/proc/PulseAnimation()
	if(!istype(src, /obj/effect/blob/core) || !istype(src, /obj/effect/blob/node))
		flick("[icon_state]_glow", src)
	return

/obj/effect/blob/proc/RegenHealth()
	// All blobs heal over time when pulsed, but it has a cool down
	if(health_timestamp > world.time)
		return 0
	health = min(maxhealth, health+health_regen)
	update_icon()
	health_timestamp = world.time + 10 // 1 seconds

/obj/effect/blob/proc/pulseLoop(num)
	var/a_color
	if(overmind)
		a_color = overmind.blob_reagent_datum.color
	for(var/i = 1; i < 8; i += i)
		Pulse(num, i, a_color)

/obj/effect/blob/proc/Pulse(pulse = 0, origin_dir = 0, a_color)//Todo: Fix spaceblob expand

	set background = BACKGROUND_ENABLED

	PulseAnimation()

	RegenHealth()

	if(run_action())//If we can do something here then we dont need to pulse more
		return

	if(pulse > 30)
		return//Inf loop check

	//Looking for another blob to pulse
	var/list/dirs = list(1,2,4,8)
	dirs.Remove(origin_dir)//Dont pulse the guy who pulsed us
	for(var/i = 1 to 4)
		if(!dirs.len)	break
		var/dirn = pick(dirs)
		dirs.Remove(dirn)
		var/turf/T = get_step(src, dirn)
		var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
		if(!B)
			expand(T,1,a_color)//No blob here so try and expand
			return
		B.adjustcolors(a_color)

		B.Pulse((pulse+1),get_dir(src.loc,T), a_color)
		return
	return


/obj/effect/blob/proc/run_action()
	return 0


/obj/effect/blob/proc/expand(turf/T = null, prob = 1, a_color)
	if(prob && !prob(health))	return
	if(!T)
		var/list/dirs = list(1,2,4,8)
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			if(!(locate(/obj/effect/blob) in T))	break
			else	T = null

	if(!T)	return 0
	var/obj/effect/blob/B = new /obj/effect/blob/normal(src.loc)
	if(istype(T, /turf/space) && prob(65))
		B.health = 0
	B.color = a_color
	B.density = 1
	if(T.Enter(B,src))//Attempt to move into the tile
		B.density = initial(B.density)
		B.loc = T
		B.update_icon()
	else
		T.blob_act()//If we cant move in hit the turf
		B.loc = null //So we don't play the splat sound, see Destroy()
		qdel(B)

	for(var/atom/A in T)//Hit everything in the turf
		A.blob_act()
	return 1

/obj/effect/blob/ex_act(severity, target)
	..()
	var/damage = 150 - 20 * severity
	take_damage(damage, BRUTE)

/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	..()
	take_damage(Proj.damage, Proj.damage_type)
	return 0

/obj/effect/blob/Crossed(mob/living/L)
	..()
	L.blob_act()


/obj/effect/blob/attackby(obj/item/weapon/W, mob/living/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>[user] has attacked the [src.name] with \the [W]!</span>")
	if(W.damtype == BURN)
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
	take_damage(W.force, W.damtype)

/obj/effect/blob/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>\The [M] has attacked the [src.name]!</span>")
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	take_damage(damage, BRUTE)
	return

/obj/effect/blob/attack_alien(mob/living/carbon/alien/humanoid/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>[M] has slashed the [src.name]!</span>")
	var/damage = rand(15, 30)
	take_damage(damage, BRUTE)
	return

/obj/effect/blob/proc/take_damage(damage, damage_type)
	if(!damage || damage_type == STAMINA) // Avoid divide by zero errors
		return
	switch(damage_type)
		if(BRUTE)
			damage /= max(brute_resist, 1)
		if(BURN)
			damage /= max(fire_resist, 1)
	health -= damage
	update_icon()

/obj/effect/blob/proc/change_to(type)
	if(!ispath(type))
		throw EXCEPTION("change_to(): invalid type for blob")
		return
	var/obj/effect/blob/B = new type(src.loc)
	if(!istype(type, /obj/effect/blob/core) || !istype(type, /obj/effect/blob/node))
		B.color = color
	else
		B.adjustcolors(color)
	qdel(src)
	return B

/obj/effect/blob/proc/adjustcolors(a_color)
	if(a_color)
		color = a_color
	return

/obj/effect/blob/examine(mob/user)
	..()
	user << "It seems to be made of [get_chem_name()]."
	return

/obj/effect/blob/proc/get_chem_name()
	for(var/mob/camera/blob/B in mob_list)
		if(lowertext(B.blob_reagent_datum.color) == lowertext(src.color)) // Goddamit why we use strings for these
			return B.blob_reagent_datum.name
	return "unknown"

/obj/effect/blob/normal
	icon_state = "blob"
	luminosity = 0
	health = 21
	maxhealth = 25
	health_regen = 1
	brute_resist = 4

/obj/effect/blob/normal/update_icon()
	if(health <= 0)
		qdel(src)
	else if(health <= 10)
		icon_state = "blob_damaged"
		name = "fragile blob"
		desc = "A thin lattice of slightly twitching tendrils."
		brute_resist = 2
	else
		icon_state = "blob"
		name = "blob"
		desc = "A thick wall of writhing tendrils."
		brute_resist = 4

/* // Used to create the glow sprites. Remember to set the animate loop to 1, instead of infinite!

var/datum/blob_colour/B = new()

/datum/blob_colour/New()
	..()
	var/icon/I = 'icons/mob/blob.dmi'
	I += rgb(35, 35, 0)
	if(isfile("icons/mob/blob_result.dmi"))
		fdel("icons/mob/blob_result.dmi")
	fcopy(I, "icons/mob/blob_result.dmi")

*/
