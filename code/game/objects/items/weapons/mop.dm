#define is_cleanable(A) (istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/rune))

/obj/item/weapon/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3
	stamina_percentage = 0.7
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	w_class = 3
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	burn_state = 0 //Burnable
	var/mopping = 0
	var/mopcount = 0
	var/mopcap = 5
	var/mopspeed = 30
	hitsound = 'sound/weapons/mop.ogg'

/obj/item/weapon/mop/New()
	create_reagents(mopcap)


obj/item/weapon/mop/proc/clean(turf/simulated/A)
	if(reagents.has_reagent("water", 1) || reagents.has_reagent("holywater", 1)|| reagents.has_reagent("vodka", 1))
		A.clean_blood()
		A.thermite = 0
		for(var/obj/effect/O in A)
			if(is_cleanable(O))
				qdel(O)
	reagents.reaction(A, TOUCH, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	reagents.remove_any(1)			//reaction() doesn't use up the reagents


/obj/item/weapon/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return

	if(reagents.total_volume < 1)
		user << "<span class='warning'>Your mop is dry!</span>"
		return

	var/turf/simulated/turf = A
	if(is_cleanable(A))
		turf = A.loc
	A = null

	if(istype(turf))
		user.visible_message("[user] begins to clean \the [turf] with [src].", "<span class='notice'>You begin to clean \the [turf] with [src]...</span>")

		if(do_after(user, src.mopspeed, target = turf))
			user << "<span class='notice'>You finish mopping.</span>"
			clean(turf)


/obj/effect/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/soap))
		return
	..()


/obj/item/weapon/mop/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	J.put_in_cart(src, user)
	J.mymop=src
	J.update_icon()

/obj/item/weapon/mop/cyborg

/obj/item/weapon/mop/cyborg/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	return
