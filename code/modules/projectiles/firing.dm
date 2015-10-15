/obj/item/ammo_casing/proc/fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params, distro, quiet, zone_override = "")
	distro += variance
	for (var/i = max(1, pellets), i > 0, i--)
		var/curloc = user.loc
		var/targloc = get_turf(target)
		ready_proj(target, user, quiet, zone_override)
		if(distro)
			targloc = spread(targloc, curloc, distro)
		if(!throw_proj(target, targloc, user, params))
			return 0
		if(i > 1)
			newshot()
	user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))
	update_icon()
	return 1

/obj/item/ammo_casing/proc/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if (!BB)
		return
	BB.original = target
	BB.firer = user
	if (zone_override)
		BB.def_zone = zone_override
	else
		BB.def_zone = user.zone_sel.selecting
	BB.suppressed = quiet

	if(reagents && BB.reagents)
		reagents.trans_to(BB, reagents.total_volume) //For chemical darts/bullets
		qdel(reagents)

/obj/item/ammo_casing/proc/throw_proj(atom/target, turf/targloc, mob/living/user, params)
	var/turf/curloc = user.loc
	if (!istype(targloc) || !istype(curloc) || !BB)
		return 0
	if(targloc == curloc)
		if(target) //if the target is right on our location we go straight to bullet_act()
			target.bullet_act(BB, BB.def_zone)
		qdel(BB)
		BB = null
		return 1
	BB.loc = get_turf(user)
	BB.starting = get_turf(user)
	BB.current = curloc
	BB.yo = targloc.y - curloc.y
	BB.xo = targloc.x - curloc.x

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			BB.p_x = text2num(mouse_control["icon-x"])
		if(mouse_control["icon-y"])
			BB.p_y = text2num(mouse_control["icon-y"])
	if(BB)
		BB.fire()
	BB = null
	return 1

/obj/item/ammo_casing/proc/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)

//	gaussian(0, distro)