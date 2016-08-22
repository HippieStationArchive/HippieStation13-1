/obj/item/weapon/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 10
	stamina_percentage = 0.75
	throwforce = 7
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("beaten")
	var/stunforce = 7
	var/status = 0
	var/obj/item/weapon/stock_parts/cell/high/bcell = null
	var/hitcost = 1000

/obj/item/weapon/melee/baton/suicide_act(mob/user) //TODO: Make this suicide less lame
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/weapon/melee/baton/New()
	..()
	update_icon()
	return

/obj/item/weapon/melee/baton/CheckParts()
	bcell = locate(/obj/item/weapon/stock_parts/cell) in contents
	update_icon()

/obj/item/weapon/melee/baton/loaded/New() //this one starts with a cell pre-installed.
	..()
	bcell = new(src)
	update_icon()
	return

/obj/item/weapon/melee/baton/proc/deductcharge(chrgdeductamt)
	if(bcell)
		. = bcell.use(chrgdeductamt)
		if(bcell.charge >= hitcost) // If after the deduction the baton doesn't have enough charge for a stun hit it turns off.
			return
	if(status)
		status = 0
		update_icon()
		playsound(loc, "sparks", 75, 1, -1)
	return 0


/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

/obj/item/weapon/melee/baton/examine(mob/user)
	..()
	if(bcell)
		user <<"<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>"
	else
		user <<"<span class='warning'>The baton does not have a power source installed.</span>"

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/stock_parts/cell))
		var/obj/item/weapon/stock_parts/cell/C = W
		if(bcell)
			user << "<span class='notice'>[src] already has a cell.</span>"
		else
			if(C.maxcharge <= hitcost)
				user << "<span class='notice'>[src] requires a higher capacity cell.</span>"
				return
			if(!user.unEquip(W))
				return
			W.loc = src
			bcell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
			update_icon()

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(bcell)
			bcell.updateicon()
			bcell.loc = get_turf(src.loc)
			bcell = null
			user << "<span class='notice'>You remove the cell from [src].</span>"
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		user << "<span class='notice'>[src] is now [status ? "on" : "off"].</span>"
		playsound(loc, "sparks", 75, 1, -1)
	else
		status = 0
		if(!bcell)
			user << "<span class='warning'>[src] does not have a power source!</span>"
		else if (bcell.maxcharge <= hitcost)
			user << "<span class='warning'>[src] requires a higher capacity cell.</span>"
		else
			user << "<span class='warning'>[src] is out of charge.</span>"
	update_icon()
	add_fingerprint(user)

/obj/item/weapon/melee/baton/attack(mob/M, mob/living/carbon/human/user)
	if(status && user.disabilities & CLUMSY && prob(50))
		user.visible_message("<span class='danger'>[user] accidentally hits themself with [src]!</span>", \
							"<span class='userdanger'>You accidentally hit yourself with [src]!</span>")
		baton_stun(user, user, stunforce*2, 1) //disabled warning
		return

	if(isrobot(M))
		..()
		return
	if(!isliving(M))
		return

	var/mob/living/L = M
	if(L.mind)
		var/datum/mind/mind = L.mind
		feedback_add_details("stuns", "[mind.key]|[type]")

	if(user.a_intent != "harm")
		if(status)
			if(baton_stun(L, user))
				user.do_attack_animation(L)
				return
		L.visible_message("<span class='warning'>[user] has prodded [L] with [src]. Luckily it was off.</span>", \
						"<span class='warning'>[user] has prodded you with [src]. Luckily it was off</span>")
	else
		if(status)
			baton_stun(L, user, round(stunforce/2))
		..()

/obj/item/weapon/melee/baton/throw_impact(atom/A)
	..()
	if(iscarbon(A) && src.loc != A) //This checks if the stun baton's location isn't in the dude's hands or inside him
		var/mob/living/carbon/H = A
		if(prob(50) && status)
			baton_stun(H, usr)

/obj/item/weapon/melee/baton/proc/baton_stun(mob/living/L, mob/user, sforce = stunforce, disablewarning = 0)
	if(!istype(L))
		return 0
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(!R || !R.cell || !R.cell.use(hitcost))
			return 0
	else
		if(!deductcharge(hitcost))
			return 0

	user.lastattacked = L
	L.lastattacker = user

	L.Stun(sforce)
	L.Weaken(sforce)
	L.apply_effect(STUTTER, sforce)
	if(!disablewarning)
		L.visible_message("<span class='danger'>[user] has stunned [L] with [src]!</span>", \
								"<span class='userdanger'>[user] has stunned you with [src]!</span>")
	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	add_logs(user, L, "stunned")
	return 1

/obj/item/weapon/melee/baton/emp_act(severity)
	if(deductcharge(1000 / severity))
		if(bcell.reliability != 100 && prob(50/severity))
			bcell.reliability -= 10 / severity
	..()

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 7
	stamina_percentage = 0.4 //It's got sharp bits on it
	throwforce = 5
	stunforce = 5
	hitcost = 2500
	slot_flags = null
