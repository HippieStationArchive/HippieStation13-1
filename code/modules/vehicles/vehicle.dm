/*
This is the base file for the Artic Station Vehicle code,
Dont touch this file unless you know your shit about this.
*/

/obj/vehicle
	name = "vehicle"
	desc = "Who the hell spawned this?"
	icon = 'icons/vehicles/Bike.dmi'
	icon_state = "blank"
	density = 1 //Dense. To raise the heat.
	opacity = 0 ///Not opaque by default. horrifying..
	anchored = 1 //no pulling around.
	var/lastmove = 0
	var/list/blacklist
	var/exposed = 0 //Used for calculating attacks, whether it hits the driver/occupants
	var/occupants_max = 0 //Max occupants
	var/occupants = 0 //The driver is technically not an occupant
	var/mob/living/carbon/human/driver //Driver of said vehicle, take his inputs
	var/mass = 500 // Mass of the vehicle, used for movement calculations and collision

	var/list/parts = list() //Holder for all vehicle parts

	var/datum/action/vehicle/exit_vehicle/exit_vehicle = new


/obj/vehicle/update_icon()
	overlays.Cut()
	var/obj/item/vehicle_parts/chassis/C = locate() in parts
	var/obj/item/vehicle_parts/propulsion/P = locate() in parts
	if(C)
		icon_state = C.icon_state
	if(P)
		overlays += P.icon_state

/obj/vehicle/attackby(var/obj/item/weapon/reagent_containers/I, mob/user, params)
	if(isrobot(user))
		return
	var/obj/item/weapon/reagent_containers/fueltank/F = locate() in parts
	if(!F)
		user << "<span class='warning'>[src] has no fuel tank!</span>"
		return
	if(!I.possible_transfer_amounts)
		return
	if(F.reagents.total_volume == F.volume)
		user << "<span class='warning'>[src]'s fuel tank is full!</span>"
		return
	else
		I.reagents.trans_to(F, I.amount_per_transfer_from_this)


/obj/vehicle/examine(mob/user)
	..()
	if(parts)
		user << "It's has:"
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
	name = "Eject From Mech"
	button_icon_state = "mech_eject"

/datum/action/vehicle/exit_vehicle/Activate()
	if(!owner || !iscarbon(owner))
		return
	if(!vehicle)
		return
	vehicle.exit()


/obj/vehicle/test/New()
	parts = newlist(/obj/item/weapon/reagent_containers/fueltank, /obj/item/vehicle_parts/propulsion, /obj/item/vehicle_parts/engine,
					/obj/item/vehicle_parts/chassis, /obj/item/vehicle_parts/seat, /obj/item/weapon/stock_parts/cell,
					/obj/item/vehicle_parts/armor)

	for(var/obj/item/O in parts)
		O.loc = src
	var/obj/item/vehicle_parts/engine/E = locate() in parts
	var/obj/item/weapon/reagent_containers/fueltank/F = locate() in parts
	F.reagents.add_reagent(E.fueltype, F.volume)
	update_stats()

/obj/vehicle/proc/update_stats()
	for(var/obj/item/vehicle_parts/O in parts)
		O.weight += mass
	update_icon()

/obj/vehicle/relaymove(mob/user, direction)
	var/obj/item/vehicle_parts/propulsion/P = locate() in parts
	var/obj/item/vehicle_parts/engine/E = locate() in parts
	var/obj/item/weapon/reagent_containers/fueltank/F = locate() in parts
	//var/obj/item/weapon/stock_parts/cell/B = locate() in parts
	if((!Process_Spacemove(direction)) || (!has_gravity(src.loc) && !P.nograv))
		return
	if(!driver) //Return if no driver
		return
	if(!lastmove && user == driver)
		if(!E)
			driver << "<span class='warning'>[src] has no engine!</span>"
			return
		if(!P)
			driver << "<span class='warning'>[src] has no method of moving!</span>"
			return
			/*
		if(!B || B.charge == 0)
			driver << "<span class='warning'>The [src]'s ignition does nothing</span>" //Thinking
			return
			*/
		if(!F || !F.reagents.has_reagent(E.fueltype, E.fueluse))
			driver << "<span class='warning'>[src]'s engine sputters.</span>"
			lastmove = 1
			spawn(5)
				lastmove = 0
				return
		if(step(src, direction))
			F.reagents.remove_reagent(E.fueltype, E.fueluse)

			if(!F.reagents.has_reagent(E.fueltype, E.fueluse))
				user.visible_message("<span class='danger'>[src]'s engine stops abruptly.</span>",
				"<span class='danger'>[src]'s engine stops abruptly</span>",
				"<span class='italics'>You hear an engine die down</span>")

			lastmove = 1
			spawn(mass / E.engine_power)
				lastmove = 0

/obj/vehicle/MouseDrop_T(mob/M, mob/user)
	if (!user.canUseTopic(src) || (user != M))
		return
	if(!ishuman(user)) // no silicons or drones in vehicles.
		return
	if(user.buckled)
		user << "<span class='warning'>You are currently buckled and cannot move.</span>"
		return
	if(occupants == occupants_max && driver)
		user << "<span class='warning'>The [src.name] is full!</span>"
		return
	for(var/mob/living/simple_animal/slime/S in range(1,user))
		if(S.Victim == user)
			user << "<span class='warning'>You're too busy getting your life sucked out of you!</span>"
			return

	visible_message("[user] starts to climb into [src.name].")

	if(do_after(user, 40, target = src))
		if(user.buckled)
			user << "<span class='warning'>You have been buckled and cannot move.</span>"
		else
			moved_inside(user)
	else
		user << "<span class='warning'>You stop entering the vehicle!</span>"
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