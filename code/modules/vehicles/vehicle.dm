/*
This is the base file for the Artic Station Vehicle code,
Dont touch this file unless you know your shit about this.

Well techincally it's now Hippie Station.
but i'll port it back to Arctic station if we get back to it
*/

/obj/vehicle
	name = "vehicle"
	desc = "You shouldnt be seeing this"
	icon = 'icons/vehicles/vehicle.dmi'
	density = 1
	opacity = 0
	anchored = 1
	var/health = 200 //Alot of this shit is getting set by the chassis
	var/maxhealth = 200
	var/lastmove = 0
	var/list/blacklist = list() //Black list for parts
	var/exposed = 0 //Used for calculating attacks, whether it hits the driver/occupants
	var/occupants_max = 0 //Max occupants
	var/occupants = 0 //The driver is technically not an occupant
	var/mob/living/carbon/human/driver //Driver of said vehicle, take his inputs
	var/mass = 500 // Mass of the vehicle, used for movement calculations and collision
	var/max_mass = 500 //Max mass, so you can't load up like 500 engines for no raisen.
	var/locked = 0 //Can you add/remove parts?
	var/active = 0 //Is the vehicle's engine active?


	var/list/parts = list() //Holder for all vehicle parts

	var/datum/action/vehicle/exit_vehicle/exit_vehicle = new
	var/installing = 0
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/vehicle_parts
	name = "vehicle part"
	icon = null
	icon_state = "blank"
	w_class = 5  //Will vary between parts
	flags = CONDUCT
	origin_tech = "programming=2;materials=2"
	var/durability = 100 //Durability of the part
	var/weight = 10 //Mass of part
	slowdown = 2
	var/part_type = null

/obj/vehicle/update_icon()
	overlays.Cut()
	var/obj/item/vehicle_parts/chassis/C = locate() in parts
	var/obj/item/vehicle_parts/propulsion/P = locate() in parts
	if(P) //Needs better unique sprites. Formatting should just end up being part_chassis
		//overlays += "[P.icon_state]_[C.icon_state]
		overlays += P.icon_state
	if(C)
		//overlays += "[P.icon_state]_[C.icon_state]
		overlays += C.icon_state

/obj/vehicle/attackby(var/obj/item/I, mob/user, params)
	var/obj/item/weapon/reagent_containers/fueltank/F = locate() in parts
	var/obj/item/weapon/stock_parts/cell/C = locate() in parts
	for(I in blacklist)
		user << "<span class='notice'>You can't attach [I] to [src]!</span>"
		return
	if(istype(I,/obj/item/weapon/weldingtool) && user.a_intent != "harm")
		var/obj/item/weapon/weldingtool/WT = I
		user.changeNext_move(CLICK_CD_MELEE)
		if(WT.remove_fuel(5,user))
			if(src.health<initial(src.health))
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				src.health += min(10, maxhealth-health)
				user << "<span class='notice'>You repair some damage to [src]</span>"
			else
				user << "<span class='notice'>[src] is at full health</span>"
		else
			user << "<span class='notice'>The [WT] must be on!</span>"
	if(istype(I,/obj/item/weapon/reagent_containers/fueltank) || istype(I,/obj/item/vehicle_parts))
		var/obj/item/vehicle_parts/O = I
		if(compareParts(O))
			user << "<span class='warning'>[src] already has a [O.part_type]</span>"
			return
		if(installing)
			return
		if((O.weight + mass) > max_mass)
			user << "<span class='warning'>[src] is too heavy!</span>"
		else
			installing = 1
			user.changeNext_move(CLICK_CD_MELEE) //To prevent spam
			user << "<span class='notice'>You begin to install [I] into [src]</span>"
			if(do_after(user, 40, target = src))
				user << "<span class='notice'>You install [I] into [src]</span>"
				user.drop_item()
				parts += I
				I.forceMove(src)
				update_stats()
				installing = 0
			else
				user << "<span class='notice'>You stop installing [I]</span>"
				installing = 0

	if(istype(I,/obj/item/weapon/stock_parts/cell))
		if(C)
			user << "<span class='notice'>There is already a cell installed in [src]</span>"
			return
		if(installing)
			return
		else
			installing = 1
			user.changeNext_move(CLICK_CD_MELEE) //To prevent spam
			user << "<span class='notice'>You begin to install [I] into [src]</span>"
			if(do_after(user, 40, target = src))
				user << "<span class='notice'>You install [I] into [src]</span>"
				user.drop_item()
				parts += I
				I.forceMove(src)
				update_stats()
				installing = 0
			else
				user << "<span class='notice'>You stop installing [I]</span>"
				installing = 0

	if(istype(I,/obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/R = I
		if(isrobot(user))
			return
		if(!F)
			user << "<span class='warning'>[src] has no fuel tank!</span>"
			return
		if(!R.possible_transfer_amounts)
			return
		if(F.reagents.total_volume == F.volume)
			user << "<span class='warning'>[src]'s fuel tank is full!</span>"
			return
		else
			var/trans = R.reagents.trans_to(F, R.amount_per_transfer_from_this)
			user << "<span class='notice'>You transfer [trans] units to [src]'s fuel tank</span>"

	else
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		if(I.hitsound)
			playsound(src,I.hitsound,30,1)
		if(I.force)
			if(I.force < 10) //Innate armor for all vehicles
				user.visible_message("<span class='danger'>[user] attacks [src], but \his attack does nothing!</span>", \
					"<span class='userdanger'>You hit [src] with [I.name], but deal no damage!</span>")
			else
				take_damage(I.force,I.damtype)
				user.visible_message("<span class='danger'>[user] attacks [src] with the [I.name]!</span>", \
					"<span class='danger'>You hit [src] with the [I.name]</span>")



/obj/vehicle/proc/compareParts(var/obj/item/vehicle_parts/input) //Meant for checking parts and whether there is already one installed or not.
	for(var/obj/item/F in parts)
		if(istype(F,/obj/item/weapon/stock_parts/cell))
			continue //Fuck that
		var/obj/item/vehicle_parts/N = F
		if(istype(input,/obj/item/weapon/stock_parts/cell))
			return 1
		else if(input.part_type == "seat") //Seats are ignored, of course.
			return 0
		else if(input.part_type == N.part_type)
			return 1
	return 0






/obj/vehicle/examine(mob/user)
	..()
	var/integrity = health/maxhealth*100
	switch(integrity)
		if(101 to INFINITY)
			user << "It's in a state not comprehenisble by you."
		if(85 to 100)
			user << "It's fully intact."
		if(65 to 85)
			user << "It's slightly damaged."
		if(45 to 65)
			user << "It's badly damaged."
		if(25 to 45)
			user << "It's heavily damaged."
		else
			user << "It's falling apart."
	if(parts)
		user << "It has:"
		for(var/obj/item/part in parts)
			if(istype(part,/obj/item/weapon/reagent_containers/fueltank))
				var/obj/item/weapon/reagent_containers/fueltank/check = part
				var/list/rbeaker = list()
				for(var/datum/reagent/R in check.reagents.reagent_list)
					rbeaker += R.name
				var/contained = english_list(rbeaker)
				user << "\icon[part] [part] and has [check.reagents.total_volume] out of a max [check.volume], containing [contained]"
			else
				user << "\icon[part] [part]"

/obj/vehicle/Bump(var/atom/obstacle, yes)
	if(yes)
		if(..())
			return
		var/obj/item/vehicle_parts/chassis/C = locate() in parts
		C.bump_act(obstacle)
		if(istype(obstacle, /obj))
			var/obj/O = obstacle
			if(!O.anchored)
				step(obstacle, dir)
		else if(istype(obstacle, /mob))
			step(obstacle, dir)


/obj/vehicle/proc/GrantActions(var/mob/living/user)
	exit_vehicle.vehicle = src
	exit_vehicle.Grant(user)

/obj/vehicle/proc/RemoveActions(var/mob/living/user)
	exit_vehicle.Remove(usr)

/obj/vehicle/proc/exit(var/atom/newloc = loc)
	RemoveActions()
	usr.forceMove(newloc)
	if(usr == driver)
		driver = null
	else
		occupants--
	usr.reset_view()

/obj/vehicle/Destroy(var/atom/newloc = loc)
	for(var/mob/M in src)
		RemoveActions(M)
		M.forceMove(newloc)
		M.reset_view()
	..()

/datum/action/vehicle
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUNNED | AB_CHECK_ALIVE
	action_type = AB_INNATE
	var/obj/vehicle/vehicle

/datum/action/vehicle/exit_vehicle
	name = "Leave Vehicle"
	button_icon_state = "mech_eject"

/datum/action/vehicle/exit_vehicle/Activate()
	if(!owner || !iscarbon(owner))
		return
	if(!vehicle)
		return
	vehicle.exit()

/obj/vehicle/New()
	for(var/obj/item/O in parts)
		O.loc = src
	update_stats()
	var/obj/item/vehicle_parts/engine/E = locate() in parts
	var/obj/item/weapon/reagent_containers/fueltank/F = locate() in parts
	if(!F)
		return
	if(!E)
		return
	F.reagents.add_reagent(E.fueltype, F.volume) //Debug stuff




/obj/vehicle/test/New()
	parts = newlist(/obj/item/weapon/reagent_containers/fueltank, /obj/item/vehicle_parts/propulsion, /obj/item/vehicle_parts/engine,
					/obj/item/vehicle_parts/chassis, /obj/item/vehicle_parts/seat, /obj/item/weapon/stock_parts/cell,
					/obj/item/vehicle_parts/armor)
	update_stats()
	..()


/obj/vehicle/proc/update_stats()
	mass = 0 //Reset mass to recalc
	occupants_max = 0 //Reset to recalc
	for(var/obj/item/P in parts)
		P.loc = src //TRIPLE CHECKS BECAUSE YES
		var/obj/item/vehicle_parts/O = P
		if(istype(P,/obj/item/weapon/stock_parts/cell))
			continue //Ignore cells
		if(O.part_type == "seat")
			occupants_max++
		if(!O.weight)
			continue //Ignore weightless objects
		mass += O.weight
	update_icon()

/obj/vehicle/proc/click_action(atom/target,mob/user,params)
	if(user.incapacitated())
		return
	if(src == target)
		return
	var/obj/item/W = user.get_active_hand()
	if(istype(W,/obj/item/weapon/gun))
		can_fire(W,target,user,params)

/obj/vehicle/proc/do_newshot(obj/item/weapon/gun/energy/egun)
	egun.newshot()

/obj/vehicle/proc/can_fire(obj/item/weapon/gun/gun,atom/target,mob/user,params) //DRIVE BY SHOOTING, BOYS
	if(istype(gun,/obj/item/weapon/gun/energy))
		do_newshot(gun)
	if(target in user.contents)
		return
	if(target == user)
		return
	if(gun.clumsy_check && gun.can_shoot()) //Clusmy check
		if(istype(user, /mob/living))
			var/mob/living/M = user
			if (M.disabilities & CLUMSY && prob(40))
				user << "<span class='userdanger'>You shoot yourself in the foot with \the [src], but hold onto the gun!</span>"
				var/shot_leg = pick("l_leg", "r_leg")
				gun.process_fire(user,user,0,params, zone_override = shot_leg)
				return

	if(isliving(user))
		var/mob/living/L = user
		if(!gun.can_trigger_gun(L))
			return
	gun.process_fire(target,user,1,params)




/obj/vehicle/relaymove(mob/user, direction, atom/A)
	var/obj/item/vehicle_parts/propulsion/P = locate() in parts
	var/obj/item/vehicle_parts/engine/E = locate() in parts
	var/obj/item/weapon/reagent_containers/fueltank/F = locate() in parts
	var/obj/item/weapon/stock_parts/cell/B = locate() in parts
	if((!Process_Spacemove(direction) && !P.nograv) || (!has_gravity(src.loc) && !P.nograv))
		return
	if(!driver) //Return if no driver
		return
	if(!E)
		driver << "<span class='warning'>[src] has no engine!</span>"
		return
	if(!lastmove && user == driver)
		var/engine = E.engine_act(F,B, user)
		if(engine == "nocell")
			driver << "<span class='warning'>[src]'s ignition does nothing</span>"
			return
		else if(engine == "nofuel")
			driver << "<span class='warning'>[src]'s engine sputters</span>"
			return

		if(step(src, direction))
			lastmove = 1
			spawn(mass / E.engine_power)
				lastmove = 0



/obj/vehicle/MouseDrop_T(atom/M, mob/user)
	if (!user.canUseTopic(src) || (user != M))
		return
	if(!ishuman(user)) // no silicons or drones in vehicles.
		return
	if(user.buckled)
		user << "<span class='warning'>You are currently buckled and cannot move.</span>"
		return
	if(occupants >= occupants_max && driver)
		user << "<span class='warning'>The [src.name] is full!</span>"
		return
	if(user.buckled_mob)
		user << "<span class='warning'>You can't enter the exosuit with [user.buckled_mob] attached to you!</span>"
		return

	visible_message("[user] starts to climb into [src].")

	if(do_after(user, 40, target = src))
		if(user.buckled)
			user << "<span class='warning'>You have been buckled and cannot move.</span>"
		else
			moved_inside(user)
	else
		user << "<span class='warning'>You stop entering [src]!</span>"
	return

/obj/vehicle/proc/moved_inside(mob/living/carbon/human/H)
	if(H && H.client && H in range(1))
		if(!driver)
			driver = H
		else if(occupants < occupants_max)
			occupants++
		H.reset_view(src)
		GrantActions(H)
		H.stop_pulling()
		H.forceMove(src)
		add_fingerprint(H)
		forceMove(loc)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		return 1
	else
		return 0