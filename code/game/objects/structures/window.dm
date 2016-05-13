/obj/structure/window
	name = "window"
	desc = "A window."
	icon_state = "window"
	density = 1
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1 //initially is 0 for tile smoothing
	flags = ON_BORDER
	var/maxhealth = 25
	var/health = 0
	var/ini_dir = null
	var/state = 0
	var/reinf = 0
	var/disassembled = 0
	var/wtype = "glass"
	var/fulltile = 0
	var/heat_proof = 0
	var/list/storeditems = list()
	var/temp_resistance = 800
//	var/silicate = 0 // number of units of silicate
//	var/icon/silicateIcon = null // the silicated icon
	var/image/crack_overlay
	can_be_unanchored = 1

/obj/structure/window/BlockSuperconductivity()
    if(heat_proof)
        return 1
    return 0


/obj/structure/window/examine(mob/user)
	..()
	user << "<span class='notice'>Alt-click to rotate it clockwise.</span>"

/obj/structure/window/New(Loc,re=0)
	..()
	health = maxhealth
	if(re)
		reinf = re
	storeditems.Add(new/obj/item/weapon/shard(src))
	if(fulltile)
		storeditems.Add(new/obj/item/weapon/shard(src))
	ini_dir = dir
	if(reinf)
		state = 2*anchored
		var/obj/item/stack/rods/R = new/obj/item/stack/rods(src)
		storeditems.Add(R)
		if(fulltile)
			R.add(1)

	air_update_turf(1)

	return

/obj/structure/window/bullet_act(obj/item/projectile/Proj)
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		health -= Proj.damage
		update_nearby_icons()
	..()
	if(health <= 0)
		spawnfragments()
	return


/obj/structure/window/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			spawnfragments()
			return
		if(3)
			if(prob(50))
				spawnfragments()
				return


/obj/structure/window/blob_act()
	spawnfragments()

/obj/structure/window/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		spawnfragments()

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(AM as mob|obj)
	..()
	var/tforce = 0
	if(ismob(AM))
		tforce = 40

	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce

	if(reinf)
		tforce *= 0.25

	playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
	health = max(0, health - tforce)
	if(health <= 7 && !reinf)
		anchored = 0
		update_nearby_icons()
		step(src, get_dir(AM, src))

	if(health <= 0)
		spawnfragments()
	update_nearby_icons()

/obj/structure/window/attack_tk(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	add_fingerprint(user)
	playsound(loc, 'sound/effects/Glassknock.ogg', 50, 1)

/obj/structure/window/attack_hulk(mob/living/carbon/human/user)
	if(!can_be_reached(user))
		return
	..(user, 1)
	user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
	user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
	add_fingerprint(user)
	hit(50)
	return 1

/obj/structure/window/attack_hand(mob/user)
	if(!can_be_reached(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("[user] knocks on [src].")
	add_fingerprint(user)
	playsound(loc, 'sound/effects/Glassknock.ogg', 50, 1)

/obj/structure/window/attack_paw(mob/user)
	return attack_hand(user)


/obj/structure/window/proc/attack_generic(mob/user, damage = 0)	//used by attack_alien, attack_animal, and attack_slime
	if(!can_be_reached(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	health -= damage
	if(health <= 0)
		user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
		spawnfragments()
	else	//for nicer text~
		user.visible_message("<span class='danger'>[user] smashes into [src]!</span>")
		playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)


/obj/structure/window/attack_alien(mob/living/user)
	user.do_attack_animation(src)
	if(islarva(user)) return
	attack_generic(user, 15)
	update_nearby_icons()

/obj/structure/window/attack_animal(mob/living/user)
	if(!isanimal(user))
		return

	var/mob/living/simple_animal/M = user
	M.do_attack_animation(src)
	if(M.melee_damage_upper <= 0 || (M.melee_damage_type != BRUTE && M.melee_damage_type != BURN))
		return

	attack_generic(M, M.melee_damage_upper)
	update_nearby_icons()

/obj/structure/window/attack_slime(mob/living/simple_animal/slime/user)
	user.do_attack_animation(src)
	if(!user.is_adult)
		return

	attack_generic(user, rand(10, 15))
	update_nearby_icons()

/obj/structure/window/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_reached(user))
		return 1 //skip the afterattack

	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		if(reinf && (state == 2 || state == 1))
			user << (state == 2 ? "<span class='notice'>You begin to unscrew the window from the frame...</span>" : "<span class='notice'>You begin to screw the window to the frame...</span>")
		else if(reinf && state == 0)
			user << (anchored ? "<span class='notice'>You begin to unscrew the frame from the floor...</span>" : "<span class='notice'>You begin to screw the frame to the floor...</span>")
		else if(!reinf)
			user << (anchored ? "<span class='notice'>You begin to unscrew the window from the floor...</span>" : "<span class='notice'>You begin to screw the window to the floor...</span>")

		if(do_after(user, 5/I.toolspeed, target = src))
			if(reinf && (state == 1 || state == 2))
				//If state was unfastened, fasten it, else do the reverse
				state = (state == 1 ? 2 : 1)
				user << (state == 1 ? "<span class='notice'>You unfasten the window from the frame.</span>" : "<span class='notice'>You fasten the window to the frame.</span>")
			else if(reinf && state == 0)
				anchored = !anchored
				update_nearby_icons()
				user << (anchored ? "<span class='notice'>You fasten the frame to the floor.</span>" : "<span class='notice'>You unfasten the frame from the floor.</span>")
			else if(!reinf)
				anchored = !anchored
				update_nearby_icons()
				user << (anchored ? "<span class='notice'>You fasten the window to the floor.</span>" : "<span class='notice'>You unfasten the window.</span>")

	else if (istype(I, /obj/item/weapon/crowbar) && reinf && (state == 0 || state == 1))
		user << (state == 0 ? "<span class='notice'>You begin to lever the window into the frame...</span>" : "<span class='notice'>You begin to lever the window out of the frame...</span>")
		playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		if(do_after(user, 5/I.toolspeed, target = src))
			//If state was out of frame, put into frame, else do the reverse
			state = (state == 0 ? 1 : 0)
			user << (state == 1 ? "<span class='notice'>You pry the window into the frame.</span>" : "<span class='notice'>You pry the window out of the frame.</span>")

	else if(istype(I, /obj/item/weapon/weldingtool) && user.a_intent == "help")
		var/obj/item/weapon/weldingtool/WT = I
		if(health < maxhealth)
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin repairing [src]...</span>"
				playsound(loc, 'sound/items/Welder.ogg', 5, 1)
				if(do_after(user, 5/I.toolspeed, target = src))
					health = maxhealth
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
		else
			user << "<span class='warning'>[src] is already in good condition!</span>"
			return
		update_nearby_icons()

	else if(istype(I, /obj/item/weapon/wrench) && !anchored)
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
		user << "<span class='notice'> You begin to disassemble [src]...</span>"
		if(do_after(user, 5/I.toolspeed, target = src))
			if(disassembled)
				return //Prevents multiple deconstruction attempts

			if(reinf)
				var/obj/item/stack/sheet/rglass/RG = new (user.loc)
				RG.add_fingerprint(user)
				if(fulltile) //fulltiles drop two panes
					RG = new (user.loc)
					RG.add_fingerprint(user)

			else
				var/obj/item/stack/sheet/glass/G = new (user.loc)
				G.add_fingerprint(user)
				if(fulltile)
					G = new (user.loc)
					G.add_fingerprint(user)

			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			disassembled = 1
			user << "<span class='notice'>You successfully disassemble [src].</span>"
			qdel(src)
	else if(istype(I, /obj/item/weapon/rcd)) //Do not attack the window if the user is holding an RCD
		return

	else
		if(I.damtype == BRUTE || I.damtype == BURN)
			user.changeNext_move(CLICK_CD_MELEE)
			hit(I.force)
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/mech_melee_attack(obj/mecha/M)
	if(..())
		hit(M.force, 1)


/obj/structure/window/proc/can_be_reached(mob/user)
	if(!fulltile)
		if(get_dir(user,src) & dir)
			for(var/obj/O in loc)
				if(!O.CanPass(user, user.loc, 1))
					return 0
	return 1

/obj/structure/window/proc/hit(damage, sound_effect = 1)
	if(reinf)
		damage *= 0.5
	health = max(0, health - damage)
	update_nearby_icons()
	if(sound_effect)
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	if(health <= 0)
		spawnfragments()
		return

/obj/structure/window/proc/spawnfragments()
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	var/turf/T = loc
	for(var/obj/item/I in storeditems)
		I.loc = T
		transfer_fingerprints_to(I)
	qdel(src)
	update_nearby_icons()

/obj/structure/window/verb/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if(anchored)
		usr << "<span class='warning'>It is fastened to the floor therefore you can't rotate it!</span>"
		return 0

	dir = turn(dir, 90)
//	updateSilicate()
	air_update_turf(1)
	ini_dir = dir
	add_fingerprint(usr)
	return


/obj/structure/window/verb/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if(anchored)
		usr << "<span class='warning'>It is fastened to the floor therefore you can't rotate it!</span>"
		return 0

	dir = turn(dir, 270)
//	updateSilicate()
	air_update_turf(1)
	ini_dir = dir
	add_fingerprint(usr)
	return

/obj/structure/window/AltClick(mob/user)
	..()
	if(!user.canUseTopic(user))
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		revrotate()

/*
/obj/structure/window/proc/updateSilicate() what do you call a syndicate silicon?
	if(silicateIcon && silicate)
		icon = initial(icon)

		var/icon/I = icon(icon,icon_state,dir)

		var/r = (silicate / 100) + 1
		var/g = (silicate / 70) + 1
		var/b = (silicate / 50) + 1
		I.SetIntensity(r,g,b)
		icon = I
		silicateIcon = I
*/

/obj/structure/window/Destroy()
	density = 0
	air_update_turf(1)
	if(!disassembled)
		playsound(src, "shatter", 70, 1)
	update_nearby_icons()
	return ..()


/obj/structure/window/Move()
	var/turf/T = loc
	..()
	dir = ini_dir
	move_update_air(T)

/obj/structure/window/CanAtmosPass(turf/T)
	if(get_dir(loc, T) == dir)
		return !density
	if(dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)
		return !density
	return 1

//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	if(smooth)
		smooth_icon_neighbors(src)

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(!src) return
		if(!fulltile)
			return

		var/ratio = health / maxhealth
		ratio = Ceiling(ratio*4) * 25

		if(smooth)
			smooth_icon(src)

		overlays -= crack_overlay
		if(ratio > 75)
			return
		crack_overlay = image('icons/obj/structures.dmi',"damage[ratio]",-(layer+0.1))
		overlays += crack_overlay

/obj/structure/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + temp_resistance)
		hit(round(exposed_volume / 100), 0)
	..()

/obj/structure/window/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
	return 0

/obj/structure/window/reinforced
	name = "reinforced window"
	icon_state = "rwindow"
	reinf = 1
	temp_resistance = 1600
	maxhealth = 50
	explosion_block = 1

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	icon_state = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	icon_state = "fwindow"


/* Full Tile Windows (more health) */

/obj/structure/window/fulltile
	icon = 'icons/obj/smooth_structures/window.dmi'
	icon_state = "window"
	dir = 5
	maxhealth = 50
	fulltile = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile)

/obj/structure/window/reinforced/fulltile
	icon = 'icons/obj/smooth_structures/reinforced_window.dmi'
	icon_state = "r_window"
	dir = 5
	maxhealth = 100
	fulltile = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile)

/obj/structure/window/reinforced/tinted/fulltile
	icon = 'icons/obj/smooth_structures/tinted_window.dmi'
	icon_state = "tinted_window"
	dir = 5
	fulltile = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile)

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "A reinforced, air-locked pod window."
	icon = 'icons/obj/smooth_structures/shuttle_window.dmi'
	icon_state = "shuttle_window"
	dir = 5
	maxhealth = 100
	wtype = "shuttle"
	fulltile = 1
	reinf = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	explosion_block = 1
	temp_resistance = 1600

/obj/structure/window/crystalwindow
	name = "crystal window"
	desc = "A very strong, air-locked, temperature resistant glass made from some kind of super strong crystal."
	icon_state = "rwindow"
	reinf = 1
	dir = 5
	maxhealth = 200
	fulltile = 1
	pressure_resistance = 32*ONE_ATMOSPHERE
	temp_resistance = 120000
	color = "#aa20aa"
	heat_proof = 1
	var/thermal_conductivity = 0.0
	var/heat_capacity = 312500 * 25 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall