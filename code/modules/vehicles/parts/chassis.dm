/obj/item/vehicle_parts/chassis
	name = "chassis"
	var/max_mass = 300
	icon = 'icons/vehicles/chassis.dmi'
	var/occupants_max = 2
	icon_state = "chassis"
	part_type = "chassis"

/obj/item/vehicle_parts/chassis/attack_self(mob/user)
	if(ishuman(user))
		user << "<span class='notice'>You start to assemble [src] into a proper chassis.</span>"
		if(do_after(user, 40))
			var/obj/vehicle/vehicle = new /obj/vehicle(get_turf(src))
			user.drop_item()
			vehicle.parts += src
			forceMove(vehicle)
			vehicle.update_stats()
			user << "<span class='notice'>You assemble [src].</span>"
		else
			user << "<span class='notice'>You stop assembling [src].</span>"

/obj/item/vehicle_parts/chassis/proc/bump_act(bumped) //Chassis determines what else happens during the bumping, whether it's a player or a wall, whatever it is.
	return

/obj/item/vehicle_parts/chassis/clang
	name = "Clanging chassis"
	desc = "Occasionally goes CLANG when you touch shit"

/obj/item/vehicle_parts/chassis/clang/bump_act(bumped)
	if(prob(10))
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		audible_message("CLANG")