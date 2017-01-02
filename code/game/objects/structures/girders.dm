#define GIRDER_NORMAL 0
#define GIRDER_REINF_STRUTS 1
#define GIRDER_REINF 2
#define GIRDER_DISPLACED 3
#define GIRDER_DISASSEMBLED 4

/obj/structure/girder
	name = "girder"
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = 2
	var/state = GIRDER_NORMAL
	var/girderpasschance = 20 // percentage chance that a projectile passes through the girder.

/obj/structure/girder/attack_animal(mob/living/simple_animal/user)
	if(user.environment_smash >= 2)
		playsound(src, 'sound/effects/meteorimpact.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)

/obj/structure/girder/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(state == GIRDER_DISPLACED)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user.visible_message("<span class='warning'>[user] disassembles the girder.</span>", \
								"<span class='notice'>You start to disassemble the girder...</span>", "You hear clanking and banging noises.")
			if(do_after(user, 40/W.toolspeed, target = src))
				if(state != GIRDER_DISPLACED)
					return
				state = GIRDER_DISASSEMBLED
				user << "<span class='notice'>You disassemble the girder.</span>"
				var/obj/item/stack/sheet/metal/M = new (loc, 2)
				M.add_fingerprint(user)
				qdel(src)
		else if(state == GIRDER_REINF)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user << "<span class='notice'>You start unsecuring support struts...</span>"
			if(do_after(user, 40/W.toolspeed, target = src))
				if(state != GIRDER_REINF)
					return
				user << "<span class='notice'>You unsecure the support struts.</span>"
				state = GIRDER_REINF_STRUTS

	else if(istype(W, /obj/item/weapon/wrench))
		if(state == GIRDER_DISPLACED)
			if(!istype(loc, /turf/simulated/floor))
				user << "<span class='warning'>A floor must be present to secure the girder!</span>"
				return
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "<span class='notice'>You start securing the girder...</span>"
			if(do_after(user, 40/W.toolspeed, target = src))
				user << "<span class='notice'>You secure the girder.</span>"
				var/obj/structure/girder/G = new (loc)
				transfer_fingerprints_to(G)
				qdel(src)
		else if(state == GIRDER_NORMAL)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "<span class='notice'>You start unsecuring the girder...</span>"
			if(do_after(user, 40/W.toolspeed, target = src))
				user << "<span class='notice'>You unsecure the girder.</span>"
				var/obj/structure/girder/displaced/D = new (loc)
				transfer_fingerprints_to(D)
				qdel(src)

	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
		user << "<span class='notice'>You start slicing apart the girder...</span>"
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		if(do_after(user, 40/W.toolspeed, target = src))
			user << "<span class='notice'>You slice apart the girder.</span>"
			var/obj/item/stack/sheet/metal/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		user << "<span class='notice'>You start slicing apart the girder...</span>"
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		if(do_after(user, 70, target = src))
			user << "<span class='notice'>You slice apart the girder.</span>"
			var/obj/item/stack/sheet/metal/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)


	else if(istype(W, /obj/item/weapon/pickaxe/drill/jackhammer))
		var/obj/item/weapon/pickaxe/drill/jackhammer/D = W
		user << "<span class='notice'>You smash through the girder!</span>"
		new /obj/item/stack/sheet/metal(get_turf(src))
		D.playDigSound()
		qdel(src)

	else if(istype(W, /obj/item/weapon/wirecutters) && state == GIRDER_REINF_STRUTS)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user << "<span class='notice'>You start removing support struts...</span>"
		if(do_after(user, 40/W.toolspeed, target = src))
			user << "<span class='notice'>You remove the support struts.</span>"
			new /obj/item/stack/sheet/plasteel(get_turf(src))
			var/obj/structure/girder/G = new (loc)
			transfer_fingerprints_to(G)
			qdel(src)

	else if(istype(W, /obj/item/stack/sheet))
		if (istype(src.loc, /turf/simulated/wall))
			user << "<span class='warning'>There is already a wall present!</span>"
			return
		if (!istype(src.loc, /turf/simulated/floor))
			user << "<span class='warning'>A floor must be present to build a false wall!</span>"
			return
		if (locate(/obj/structure/falsewall) in src.loc.contents)
			user << "<span class='warning'>There is already a false wall present!</span>"
			return

		var/obj/item/stack/sheet/S = W
		switch(S.type)

			if(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal/cyborg)
				if(state == GIRDER_DISPLACED)
					if(S.get_amount() < 2)
						user << "<span class='warning'>You need two sheets of metal to create a false wall!</span>"
						return
					user << "<span class='notice'>You start building a false wall...</span>"
					if(do_after(user, 20, target = src))
						if(!src.loc || !S || S.get_amount() < 2)
							return
						S.use(2)
						user << "<span class='notice'>You create a false wall. Push on it to open or close the passage.</span>"
						var/obj/structure/falsewall/F = new (loc)
						transfer_fingerprints_to(F)
						qdel(src)
				else
					if(S.get_amount() < 2)
						user << "<span class='warning'>You need two sheets of metal to finish a wall!</span>"
						return
					user << "<span class='notice'>You start adding plating...</span>"
					if (do_after(user, 40, target = src))
						if(loc == null || S.get_amount() < 2)
							return
						S.use(2)
						user << "<span class='notice'>You add the plating.</span>"
						var/turf/T = get_turf(src)
						T.ChangeTurf(/turf/simulated/wall)
						transfer_fingerprints_to(T)
						qdel(src)
					return

			if(/obj/item/stack/sheet/plasteel)
				if(state == GIRDER_DISPLACED)
					if(S.amount < 2)
						user << "<span class='warning'>You need at least two sheets to create a false wall!</span>"
						return
					user << "<span class='notice'>You start building a reinforced false wall...</span>"
					if(do_after(user, 20, target = src))
						if(!src.loc || !S || S.amount < 2)
							return
						S.use(2)
						user << "<span class='notice'>You create a reinforced false wall. Push on it to open or close the passage.</span>"
						var/obj/structure/falsewall/reinforced/FW = new (loc)
						transfer_fingerprints_to(FW)
						qdel(src)
				else
					if(state == GIRDER_REINF)
						if(S.amount < 1)
							return
						user << "<span class='notice'>You start finalizing the reinforced wall...</span>"
						if(do_after(user, 50, target = src))
							if(!src.loc || !S || S.amount < 1)
								return
							S.use(1)
							user << "<span class='notice'>You fully reinforce the wall.</span>"
							var/turf/T = get_turf(src)
							T.ChangeTurf(/turf/simulated/wall/r_wall)
							transfer_fingerprints_to(T)
							qdel(src)
						return
					else
						if(S.amount < 1)
							return
						user << "<span class='notice'>You start reinforcing the girder...</span>"
						if (do_after(user, 60, target = src))
							if(!src.loc || !S || S.amount < 1)
								return
							S.use(1)
							user << "<span class='notice'>You reinforce the girder.</span>"
							var/obj/structure/girder/reinforced/R = new (loc)
							transfer_fingerprints_to(R)
							qdel(src)
						return

		if(S.sheettype)
			var/M = S.sheettype
			if(state == GIRDER_DISPLACED)
				if(S.amount < 2)
					user << "<span class='warning'>You need at least two sheets to create a false wall!</span>"
					return
				S.use(2)
				user << "<span class='notice'>You create a false wall. Push on it to open or close the passage.</span>"
				var/F = text2path("/obj/structure/falsewall/[M]")
				var/obj/structure/FW = new F (loc)
				transfer_fingerprints_to(FW)
				qdel(src)
			else
				if(S.amount < 2)
					user << "<span class='warning'>You need at least two sheets to add plating!</span>"
					return
				user << "<span class='notice'>You start adding plating...</span>"
				if (do_after(user, 40, target = src))
					if(!src.loc || !S || S.amount < 2)
						return
					S.use(2)
					user << "<span class='notice'>You add the plating.</span>"
					var/turf/T = get_turf(src)
					T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[M]"))
					transfer_fingerprints_to(T)
					qdel(src)
				return

		add_hiddenprint(user)

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			if(!user.drop_item())
				return
			P.loc = src.loc
			user << "<span class='notice'>You fit the pipe into \the [src].</span>"
	else
		..()


/obj/structure/girder/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0)
		return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return prob(girderpasschance)
	else
		if(istype(mover, /obj/item/projectile))
			return prob(girderpasschance)
		else
			return 0

/obj/structure/girder/blob_act()
	if(prob(40))
		qdel(src)

/obj/structure/girder/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(70))
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)
		if(3)
			if (prob(40))
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)

/obj/structure/girder/displaced
	name = "displaced girder"
	icon_state = "displaced"
	anchored = 0
	state = GIRDER_DISPLACED
	girderpasschance = 25
	layer = 2.45

/obj/structure/girder/reinforced
	name = "reinforced girder"
	icon_state = "reinforced"
	state = GIRDER_REINF
	girderpasschance = 0

/obj/structure/girder/reinforced/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(30))
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)
		if(3)
			if (prob(5))
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)


//////////////////////////////////////////// cult girder //////////////////////////////////////////////

/obj/structure/cultgirder
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	anchored = 1
	density = 1
	layer = 2

/obj/structure/cultgirder/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			user << "<span class='notice'>You start slicing apart the girder...</span>"
			if(do_after(user, 40/W.toolspeed, target = src))
				if( !WT.isOn() )
					return
				user << "<span class='notice'>You slice apart the girder.</span>"
				var/obj/effect/decal/remains/human/R = new (get_turf(src))
				transfer_fingerprints_to(R)
				qdel(src)

	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
		user << "<span class='notice'>You start slicing apart the girder...</span>"
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		if(do_after(user, 30, target = src))
			user << "<span class='notice'>You slice apart the girder.</span>"
			var/obj/effect/decal/remains/human/R = new (get_turf(src))
			transfer_fingerprints_to(R)
			qdel(src)

	else if(istype(W, /obj/item/weapon/pickaxe/drill/jackhammer))
		var/obj/item/weapon/pickaxe/drill/jackhammer/D = W
		user << "<span class='notice'>Your jackhammer smashes through the girder!</span>"
		var/obj/effect/decal/remains/human/R = new (get_turf(src))
		transfer_fingerprints_to(R)
		D.playDigSound()
		qdel(src)

/obj/structure/cultgirder/blob_act()
	if(prob(40))
		qdel(src)


/obj/structure/cultgirder/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(30))
				new /obj/effect/decal/remains/human(loc)
				qdel(src)
		if(3)
			if(prob(5))
				new /obj/effect/decal/remains/human(loc)
				qdel(src)
