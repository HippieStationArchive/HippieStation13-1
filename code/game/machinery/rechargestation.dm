/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 1000
	var/circuitboard = "/obj/item/weapon/circuitboard/cyborgrecharger"
	req_access = list(access_robotics)
	var/recharge_speed
	var/repairs
	state_open = 1

/obj/machinery/recharge_station/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/cyborgrecharger(null)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/cell/high(null)
	RefreshParts()
	update_icon()

/obj/machinery/recharge_station/RefreshParts()
	recharge_speed = 0
	repairs = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		recharge_speed += C.rating * 100
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		repairs += M.rating - 1
	for(var/obj/item/weapon/stock_parts/cell/C in component_parts)
		recharge_speed *= C.maxcharge / 10000


/obj/machinery/recharge_station/process()
	if(!is_operational())
		return

	if(occupant)
		process_occupant()
	return 1

/obj/machinery/recharge_station/relaymove(mob/user)
	if(user.stat)
		return
	open_machine()

/obj/machinery/recharge_station/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(occupant)
		occupant.emp_act(severity)
	open_machine()
	..(severity)

/obj/machinery/recharge_station/ex_act(severity, target)
	if(occupant)
		open_machine()
	..()

/obj/machinery/recharge_station/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/recharge_station/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/recharge_station/attackby(obj/item/P, mob/user, params)
	if(state_open)
		if(default_deconstruction_screwdriver(user, "borgdecon2", "borgcharger0", P))
			return

	if(exchange_parts(user, P))
		return

	if(default_pry_open(P))
		return

	default_deconstruction_crowbar(P)

/obj/machinery/recharge_station/attack_hand(mob/user)
	if(..(user,1,set_machine = 0))
		return

	toggle_open()
	add_fingerprint(user)

/obj/machinery/recharge_station/proc/toggle_open()
	if(state_open)
		close_machine()
	else
		open_machine()

/obj/machinery/recharge_station/open_machine()
	..()
	use_power = 1

/obj/machinery/recharge_station/close_machine()
	if(!panel_open)
		for(var/mob/living/silicon/robot/R in loc)
			R.stop_pulling()
			if(R.client)
				R.client.eye = src
				R.client.perspective = EYE_PERSPECTIVE
			R.loc = src
			occupant = R
			use_power = 2
			add_fingerprint(R)
			break
		state_open = 0
		density = 1
		update_icon()

/obj/machinery/recharge_station/update_icon()
	if(is_operational())
		if(state_open)
			icon_state = "borgcharger0"
		else
			icon_state = (occupant ? "borgcharger1" : "borgcharger2")
	else
		icon_state = (state_open ? "borgcharger-u0" : "borgcharger-u1")

/obj/machinery/recharge_station/power_change()
	..()
	update_icon()

/obj/machinery/recharge_station/proc/process_occupant()
	if(occupant)
		var/mob/living/silicon/robot/R = occupant
		restock_modules()
		if(repairs)
			R.heal_organ_damage(repairs, repairs - 1)
		if(R.cell)
			R.cell.charge = min(R.cell.charge + recharge_speed, R.cell.maxcharge)

/obj/machinery/recharge_station/proc/restock_modules()
	if(occupant)
		var/mob/living/silicon/robot/R = occupant
		if(R && R.module)
			var/coeff = recharge_speed / 200
			R.module.respawn_consumable(R, coeff)
