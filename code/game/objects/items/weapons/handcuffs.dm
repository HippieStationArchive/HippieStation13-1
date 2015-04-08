//Handcuffs

/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 5
	m_amt = 500
	origin_tech = "materials=1"
	var/breakouttime = 600 //Deciseconds = 60s = 1 minute
	var/cuffsound = 'sound/weapons/handcuffs.ogg'
	var/trashtype = null //for disposable cuffs
	var/icon_overlay = "handcuff" //So you can override the overlay for HUD + Mob with custom icon names.

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C, mob/user)
	if(CLUMSY in user.mutations && prob(50))
		user << "<span class='warning'>Uh... how do those things work?!</span>"
		apply_cuffs(user,user)

	if(!C.handcuffed)
		C.visible_message("<span class='danger'>[user] is trying to put [src.name] on [C]!</span>", \
							"<span class='userdanger'>[user] is trying to put [src.name] on [C]!</span>")

		playsound(loc, cuffsound, 30, 1, -2)
		if(do_mob(user, C, 30))
			apply_cuffs(C,user)
			user << "<span class='notice'>You handcuff [C].</span>"
			if(istype(src, /obj/item/weapon/handcuffs/cable))
				feedback_add_details("handcuffs","C")
			else
				feedback_add_details("handcuffs","H")

			add_logs(user, C, "handcuffed")
		else
			user << "<span class='warning'>You fail to handcuff [C].</span>"

/obj/item/weapon/handcuffs/proc/apply_cuffs(mob/living/carbon/target, mob/user)
	if(!target.handcuffed)
		user.drop_item()
		if(trashtype)
			target.handcuffed = new trashtype(target)
			qdel(src)
		else
			loc = target
			target.handcuffed = src
		target.update_inv_handcuffed(0)
		return

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_red"
	item_state = "coil_red"
	breakouttime = 300 //Deciseconds = 30s
	cuffsound = 'sound/weapons/cablecuff.ogg'

/obj/item/weapon/handcuffs/cable/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		new /obj/item/stack/cable_coil(user.loc, 15, item_color)
		user << "You unwrap the [src]."
		qdel(src)

//Isn't defining new subtypes a little redundant if you only change icon state of base type when creating cablecuffs?

/obj/item/weapon/handcuffs/cable/red
	icon_state = "cuff_red"

/obj/item/weapon/handcuffs/cable/yellow
	icon_state = "cuff_yellow"

/obj/item/weapon/handcuffs/cable/blue
	icon_state = "cuff_blue"
	item_state = "coil_blue"

/obj/item/weapon/handcuffs/cable/green
	icon_state = "cuff_green"

/obj/item/weapon/handcuffs/cable/pink
	icon_state = "cuff_pink"

/obj/item/weapon/handcuffs/cable/orange
	icon_state = "cuff_orange"

/obj/item/weapon/handcuffs/cable/cyan
	icon_state = "cuff_cyan"

/obj/item/weapon/handcuffs/cable/white
	icon_state = "cuff_white"

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod
			user.unEquip(src)
			user.put_in_hands(W)
			user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"
			qdel(src)
		else
			user << "<span class='warning'>You need one rod to make a wired rod.</span>"
			return

/obj/item/weapon/handcuffs/cable/zipties/cyborg/attack(mob/living/carbon/C, mob/user)
	if(isrobot(user))
		if(!C.handcuffed)
			playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
			C.visible_message("<span class='danger'>[user] is trying to put zipties on [C]!</span>", \
								"<span class='userdanger'>[user] is trying to put zipties on [C]!</span>")
			if(do_mob(user, C, 30))
				if(!C.handcuffed)
					C.handcuffed = new /obj/item/weapon/handcuffs/cable/zipties/used(C)
					C.update_inv_handcuffed(0)
					user << "<span class='notice'>You handcuff [C].</span>"
					add_logs(user, C, "handcuffed")
			else
				user << "<span class='warning'>You fail to handcuff [C].</span>"

/obj/item/weapon/handcuffs/cable/zipties
	name = "zipties"
	desc = "Plastic, disposable zipties that can be used to restrain temporarily but are destroyed after use."
	icon_state = "cuff_white"
	breakouttime = 450 //Deciseconds = 45s
	trashtype = /obj/item/weapon/handcuffs/cable/zipties/used

/obj/item/weapon/handcuffs/cable/zipties/used
	desc = "A pair of broken zipties."
	icon_state = "cuff_white_used"

/obj/item/weapon/handcuffs/cable/zipties/used/attack()
	return


//Legcuffs

/obj/item/weapon/legcuffs
	name = "leg cuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	throwforce = 0
	w_class = 3.0
	origin_tech = "materials=1"
	slowdown = 7
	var/breakouttime = 300	//Deciseconds = 30s = 0.5 minute

/obj/item/weapon/legcuffs/beartrap
	name = "bear trap"
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	var/armed = 0

/obj/item/weapon/legcuffs/beartrap/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the [src.name] on \his head! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/weapon/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		user << "<span class='notice'>[src] is now [armed ? "armed" : "disarmed"]</span>"


/obj/item/weapon/legcuffs/beartrap/Crossed(AM as mob|obj)
	if(armed && isturf(src.loc))
		if( (iscarbon(AM) || isanimal(AM)) && !istype(AM, /mob/living/simple_animal/parrot) && !istype(AM, /mob/living/simple_animal/construct) && !istype(AM, /mob/living/simple_animal/shade) && !istype(AM, /mob/living/simple_animal/hostile/viscerator))
			var/mob/living/L = AM
			armed = 0
			icon_state = "beartrap0"
			playsound(src.loc, 'sound/effects/snap.ogg', 50, 1)
			L.visible_message("<span class='danger'>[L] triggers \the [src].</span>", \
					"<span class='userdanger'>You trigger \the [src]!</span>")

			if(ishuman(AM))
				var/mob/living/carbon/H = AM
				if(H.lying)
					H.apply_damage(20,BRUTE,"chest")
				else
					H.apply_damage(20,BRUTE,(pick("l_leg", "r_leg")))
				if(!H.legcuffed) //beartrap can't cuff you leg if there's already a beartrap or legcuffs.
					H.legcuffed = src
					src.loc = H
					H.update_inv_legcuffed(0)
					feedback_add_details("handcuffs","B") //Yes, I know they're legcuffs. Don't change this, no need for an extra variable. The "B" is used to tell them apart.

			else
				L.apply_damage(20,BRUTE)
	..()