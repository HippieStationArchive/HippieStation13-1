//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/weapon/gun/projectile/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "A break-operated grenade launcher."
	name = "grenade launcher"
	icon_state = "dshotgun-sawn"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	w_class = 3

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/attackby(var/obj/item/A, mob/user)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/weapon/gun/projectile/revolver/grenademulti
	desc = "A revolving 6-shot grenade launcher."
	name = "multi grenade launcher"
	icon_state = "bulldog"
	item_state = "bulldog"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti

/obj/item/weapon/gun/projectile/automatic/gyropistol
	name = "gyrojet pistol"
	desc = "A prototype pistol designed to fire self propelled rockets."
	icon_state = "gyropistol"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = "combat=3"
	mag_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0

/obj/item/weapon/gun/projectile/automatic/gyropistol/process_chamber(var/eject_casing = 0, var/empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/gyropistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "loaded" : ""]"
	return
/obj/item/weapon/gun/buttlauncher
	name = "Butt Launcher"
	desc = "For HONKing on an extreme level!"
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "buttempty"
	item_state = "riotgun"
	w_class = 2.0
	throw_speed = 2
	throw_range = 7
	force = 5.0
	var/obj/item/organ/butt/contained
	var/screwdrivered
	m_amt = 2000

/obj/item/weapon/gun/buttlauncher/examine(mob/user)
	..()
	user << "[(contained)? "The [src.name] has a butt loaded!" : "The [src.name] is empty"]."

/obj/item/weapon/gun/buttlauncher/attackby(obj/item/I as obj, mob/user as mob, params)

	if(istype(I,/obj/item/organ/butt))
		if(!contained)
			user<<"<span class='notice'>You insert the Butt into the [src.name].</span>"
			contained = I
			user.drop_item()
			icon_state="buttfull"
			I.loc = src
		else
			user<<"<span class='notice'>There is already a Butt loaded into the [src.name]. </span>"
	else
		user<<"<span class='notice'>Only suitable for Butts or other Butt related items!</span class='notice'>"

/obj/item/weapon/gun/buttlauncher/afterattack(obj/target, mob/user , flag)

	if (istype(target, /obj/item/weapon/storage/backpack ))
		return

	else if (locate (/obj/structure/table, src.loc))
		return

	else if(target == user)
		return

	if(contained)
		spawn(0) throw_butt(target,user)
	else
		user << "<span class='danger'>The [src.name] has no Butts.</span>"

/obj/item/weapon/gun/buttlauncher/proc/throw_butt(target,mob/user)
	user.visible_message("<span class='danger'>[user] fires the [src.name]!</span>","<span class='userdanger'>You fire the [src.name]</span>")
	contained.loc = user.loc
	contained.throw_at(target, 30, 4)//fly butts
	contained = null
	icon_state="buttempty"

//construction
/obj/item/weapon/buttlaunch1
	name = "Butt launcher frame"
	desc = "The frame for a butt launcer"
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "buttempty"
	item_state = "riotgun"
/obj/item/weapon/buttlaunch1/attackby(obj/item/I as obj, mob/user as mob, params)
	if(istype(I,/obj/item/device/assembly/mousetrap))
		var/obj/launch = new /obj/item/weapon/buttlaunch2()
		launch.loc = get_turf(user.loc)
		user<<"<span class='notice'>You attach the mouse trap to the [src.name].</span>"
		user.drop_item()
		qdel(I)
		qdel(src)
/obj/item/weapon/buttlaunch2
	name = "Partially build butt launcher"
	desc = "The frame for a butt launcer , it has a mousetrap hastily taped to it."
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "buttempty"
	item_state = "riotgun"
	var/screwdrivered = 0
/obj/item/weapon/buttlaunch2/attackby(obj/item/I as obj, mob/user as mob, params)
	if(istype(I,/obj/item/weapon/screwdriver))
		if(!screwdrivered)
			user<<"<span class='notice'>You secure the moustrap to the [src.name].</span>"
		else
			user<<"The screws wont go any tighter!"
	if(istype(I,/obj/item/weapon/wrench))
		if(screwdrivered)
			user<<"<span class='notice'>You add the wrench to the assembly.</span>"
			var/obj/launch = new /obj/item/weapon/gun/buttlauncher()
			launch.loc = get_turf(user.loc)
			user.drop_item()
			qdel(I)
			qdel(src)
		else
			user<<"The mouse trap wobbles as you try to attach the wrench"

/obj/item/organ/butt/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/M = hit_atom
	playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
	if((ishuman(hit_atom)))
		M.apply_damage(5, STAMINA)
		M.adjustToxLoss(-5)
		if(prob(5))
			M.Weaken(3)
			visible_message("<span class='danger'>The [src.name] smacks [M] right in the face!</span>", 3)
