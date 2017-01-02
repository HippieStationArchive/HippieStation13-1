//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/weapon/gun/projectile/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "A break-operated grenade launcher."
	name = "grenade launcher"
	icon_state = "dshotgun-sawn"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	fire_sound = 'sound/weapons/grenadelauncher.ogg'
	w_class = 3

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/mgl
	name = "Strider MGL"
	desc = "An Aussec Armory-produced Multi-Grenade-Launcher. Can hold six 40mm grenades for maximum firepower."
	icon_state = "mgl"
	item_state = "riotgun"
	origin_tech = "combat=5"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	fire_sound = 'sound/weapons/grenadelauncher.ogg'
	w_class = 3
	slowdown = 1
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/cyborg
	desc = "A 6-shot grenade launcher."
	name = "multi grenade launcher"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_grenadelnchr"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/revolver/grenadelauncher/cyborg/attack_self()
	return

/obj/item/weapon/gun/projectile/automatic/gyropistol
	name = "\improper Gyrojet rocket pistol"
	desc = "A prototype pistol designed to fire self propelled rockets."
	icon_state = "gyropistol"
	fire_sound = 'sound/weapons/grenadelauncher.ogg'
	origin_tech = "combat=3"
	mag_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0
	action_button_name = null

/obj/item/weapon/gun/projectile/automatic/gyropistol/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/gyropistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "loaded" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/speargun
	name = "kinetic speargun"
	desc = "A weapon favored by carp hunters. Fires specialized spears using kinetic energy."
	icon_state = "speargun"
	item_state = "speargun"
	w_class = 4
	force = 10
	can_suppress = 0
	mag_type = /obj/item/ammo_box/magazine/internal/speargun
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	burst_size = 1
	fire_delay = 0
	select = 0
	action_button_name = null
	mag_load_sound = null
	mag_unload_sound = null
	chamber_sound = null

/obj/item/weapon/gun/projectile/automatic/speargun/update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/speargun/attack_self()
	return

/obj/item/weapon/gun/projectile/automatic/speargun/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/speargun/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		user << "<span class='notice'>You load [num_loaded] spear\s into \the [src].</span>"
		update_icon()
		chamber_round()

/obj/item/weapon/gun/buttlauncher
	name = "butt launcher"
	desc = "For HONKing on an extreme level!"
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "buttempty"
	item_state = "riotgun"
	w_class = 3.0
	throw_speed = 2
	throw_range = 7
	force = 5
	var/obj/item/organ/internal/butt/contained
	var/screwdrivered
	materials = list(MAT_METAL = 2000)

/obj/item/weapon/gun/buttlauncher/examine(mob/user)
	..()
	user << "[(contained)? "The [src.name] has a butt loaded!" : "The [src.name] is empty."]."

/obj/item/weapon/gun/buttlauncher/attackby(obj/item/I as obj, mob/user as mob, params)
	if(istype(I,/obj/item/organ/internal/butt))
		if(!contained)
			user<<"<span class='notice'>You insert the butt into the [src.name].</span>"
			contained = I
			user.drop_item()
			icon_state="buttfull"
			I.loc = src
		else
			user<<"<span class='notice'>There is already a butt loaded into the [src.name]. </span>"
	else
		user<<"<span class='notice'>Only butts fit!</span class='notice'>"

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
		user << "<span class='danger'>The [src.name] has no butts.</span>"

/obj/item/weapon/gun/buttlauncher/proc/throw_butt(target,mob/user)
	user.visible_message("<span class='danger'>[user] fires the [src.name]!</span>","<span class='userdanger'>You fire the [src.name]!</span>")
	contained.loc = user.loc
	contained.throw_at(target, 30, 4)//fly butts
	contained = null
	icon_state="buttempty"

//construction
/obj/item/weapon/buttlaunch1
	name = "butt launcher frame"
	desc = "The frame for a butt launcher"
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "buttempty"
	item_state = "riotgun"
/obj/item/weapon/buttlaunch1/attackby(obj/item/I as obj, mob/user as mob, params)
	if(istype(I,/obj/item/device/assembly/mousetrap))
		var/obj/launch = new /obj/item/weapon/buttlaunch2
		launch.loc = get_turf(user.loc)
		user<<"<span class='notice'>You attach the mouse trap to the [src.name].</span>"
		user.drop_item()
		qdel(I)
		qdel(src)
/obj/item/weapon/buttlaunch2
	name = "partially built butt launcher"
	desc = "The frame for a butt launcher, it has a mousetrap hastily taped to it."
	icon = 'icons/obj/buttlauncher.dmi'
	icon_state = "buttempty"
	item_state = "riotgun"
	var/screwdrivered = 0
/obj/item/weapon/buttlaunch2/attackby(obj/item/I as obj, mob/user as mob, params)
	if(istype(I,/obj/item/weapon/screwdriver))
		if(!screwdrivered)
			user<<"<span class='notice'>You secure the mousetrap to the [src.name].</span>"
			src.screwdrivered = 1
		else
			user<<"The screws won't go any tighter!"
	if(istype(I,/obj/item/weapon/wrench))
		if(screwdrivered)
			user<<"<span class='notice'>You add the wrench to the assembly.</span>"
			var/obj/launch = new /obj/item/weapon/gun/buttlauncher
			launch.loc = get_turf(user.loc)
			user.drop_item()
			qdel(I)
			qdel(src)
		else
			user<<"The mouse trap wobbles as you try to attach the wrench."