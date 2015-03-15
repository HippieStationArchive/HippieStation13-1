/obj/item/weapon/staffofregrowth
	name = "staff of regrowth"
	desc = "An artefact that spits fully matured space vines at where it is casted."
	icon = 'icons/obj/gun.dmi'
	icon_state = "staffofregrowth"
	item_state = "staffofregrowth"
	hitsound = 'sound/weapons/emitter.ogg'
	flags =  CONDUCT
	w_class = 5
	origin_tech = null
	var/max_charges = 10
	var/charges = 10
	var/charge_tick = 0
	var/recharge_rate = 4
	var/no_den_usage = 1

/obj/item/weapon/staffofregrowth/New()
	..()
	//SSobj.processing += src

/obj/item/weapon/staffofregrowth/Destroy()
	//SSobj.processing -= src
	..()

/obj/item/weapon/staffofregrowth/examine(mob/user)
	..()
	user << "<span class='notice'>[src] has [charges] left.</span>"

/obj/item/weapon/staffofregrowth/afterattack(atom/target, mob/living/user as mob, flag)
	if(no_den_usage)
		var/area/A = get_area(user)
		if(istype(A, /area/wizard_station))
			user << "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].<span>"
			return
		else
			no_den_usage = 0

	if(charges > 0)
		charges--
		var/turf/T = get_turf(target)

		var/obj/effect/spacevine/SV = new(T)
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x + 1, T.y, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x - 1, T.y, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x, T.y + 1, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x, T.y - 1, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x + 1, T.y + 1, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x - 1, T.y - 1, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x + 1, T.y - 1, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		SV = new(locate(T.x - 1, T.y + 1, T.z))
		SV.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		SV.energy = 2
		SV.opacity = 1

		UpdateAffectingLights()
	else
		user << "<span class='warning'>[src] is out of charges!</span>"

	..()

/obj/item/weapon/staffofregrowth/process()
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges) return 0
	charge_tick = 0
	charges++
	return 1