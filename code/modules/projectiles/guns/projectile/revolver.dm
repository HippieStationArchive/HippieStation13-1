/obj/item/weapon/gun/projectile/revolver
	name = "\improper .357 revolver"
	desc = "A suspicious revolver. Uses .357 ammo." //usually used by syndicates
	icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder
	mag_load_sound = null
	mag_unload_sound = null		//Revolvers already have their own sfx for this kind of stuff
	chamber_sound = null
	fire_sound = 'sound/weapons/revolver_shoot.ogg'
	pin = /obj/item/device/firing_pin/area/syndicate

/obj/item/weapon/gun/projectile/revolver/New()
	..()
	if(!istype(magazine, /obj/item/ammo_box/magazine/internal/cylinder))
		verbs -= /obj/item/weapon/gun/projectile/revolver/verb/spin

/obj/item/weapon/gun/projectile/revolver/chamber_round(var/spin = 1)
	if(spin)
		chambered = magazine.get_round(1)
	else
		chambered = magazine.stored_ammo[1]
	return

/obj/item/weapon/gun/projectile/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round(1)

/obj/item/weapon/gun/projectile/revolver/process_chamber()
	return ..(0, 1)

/obj/item/weapon/gun/projectile/revolver/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		user << "<span class='notice'>You load [num_loaded] shell\s into \the [src].</span>"
		A.update_icon()
		if(istype(A, /obj/item/ammo_casing))
			playsound(user.loc, pick('sound/effects/wep_misc/bullet_insert.ogg', 'sound/effects/wep_misc/bullet_insert2.ogg'), 30, 1, -2)
		else
			playsound(user.loc, 'sound/effects/wep_misc/reload1.ogg', 30, 1, -2)
		update_icon()
		chamber_round(0)

	if(unique_rename)
		if(istype(A, /obj/item/weapon/pen))
			rename_gun(user)

/obj/item/weapon/gun/projectile/revolver/attack_self(mob/living/user)
	var/num_unloaded = 0
	chambered = null
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		if(CB)
			CB.loc = get_turf(src.loc)
			CB.SpinAnimation(10, 1)
			CB.update_icon()
			num_unloaded++
		playsound(CB.loc, pick('sound/effects/wep_misc/ShellCasing1.ogg', 'sound/effects/wep_misc/ShellCasing2.ogg', 'sound/effects/wep_misc/ShellCasing3.ogg'), 15, 1, -1)
	if (num_unloaded)
		user << "<span class='notice'>You unload [num_unloaded] shell\s from [src].</span>"
	else
		user << "<span class='warning'>[src] is empty!</span>"

/obj/item/weapon/gun/projectile/revolver/verb/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if(istype(magazine, /obj/item/ammo_box/magazine/internal/cylinder))
		var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
		C.spin()
		chamber_round(0)
		usr.visible_message("[usr] spins [src]'s chamber.", "<span class='notice'>You spin [src]'s chamber.</span>")
	else
		verbs -= /obj/item/weapon/gun/projectile/revolver/verb/spin


/obj/item/weapon/gun/projectile/revolver/can_shoot()
	return get_ammo(0,0)

/obj/item/weapon/gun/projectile/revolver/get_ammo(countchambered = 0, countempties = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/weapon/gun/projectile/revolver/examine(mob/user)
	..()
	user << "[get_ammo(0,0)] of those are live rounds."

/obj/item/weapon/gun/projectile/revolver/detective
	name = "\improper .38 Mars Special"
	desc = "A cheap Martian knock-off of a classic law enforcement firearm. Uses .38-special rounds."
	icon_state = "detective"
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	unique_rename = 1
	unique_reskin = 1
	pin = /obj/item/device/firing_pin/generic

/obj/item/weapon/gun/projectile/revolver/detective/New()
	..()
	options["Default"] = "detective"
	options["Leopard Spots"] = "detective_leopard"
	options["Black Panther"] = "detective_panther"
	options["Gold Trim"] = "detective_gold"
	options["The Peacemaker"] = "detective_peacemaker"
	options["Blue Sliver"] = "detective_bluesilver"
	options["Cancel"] = null

/obj/item/weapon/gun/projectile/revolver/detective/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, message = 1, params, zone_override = "")
	if(magazine.caliber != initial(magazine.caliber))
		if(prob(70 - (magazine.ammo_count() * 10)))	//minimum probability of 10, maximum of 60
			playsound(user, fire_sound, 50, 1)
			user << "<span class='userdanger'>[src] blows up in your face!</span>"
			user.take_organ_damage(0,20)
			user.unEquip(src)
			return 0
	..()

/obj/item/weapon/gun/projectile/revolver/detective/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/weapon/screwdriver))
		if(magazine.caliber == "38")
			user << "<span class='notice'>You begin to reinforce the barrel of [src]...</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//you know the drill
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='userdanger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30/A.toolspeed, target = src))
				if(magazine.ammo_count())
					user << "<span class='warning'>You can't modify it!</span>"
					return
				magazine.caliber = "357"
				desc = "The barrel and chamber assembly seems to have been modified."
				user << "<span class='notice'>You reinforce the barrel of [src]. Now it will fire .357 rounds.</span>"
		else
			user << "<span class='notice'>You begin to revert the modifications to [src]...</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//and again
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='userdanger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30/A.toolspeed, target = src))
				if(magazine.ammo_count())
					user << "<span class='warning'>You can't modify it!</span>"
					return
				magazine.caliber = "38"
				desc = initial(desc)
				user << "<span class='notice'>You remove the modifications on [src]. Now it will fire .38 rounds.</span>"


/obj/item/weapon/gun/projectile/revolver/mateba
	name = "\improper Unica 6 auto-revolver"
	desc = "A retro high-powered autorevolver typically used by officers of the New Russia military. Uses .357 ammo."
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"
	fire_sound = 'sound/weapons/revolver_big.ogg'
	pin = /obj/item/device/firing_pin/generic

/obj/item/weapon/gun/projectile/revolver/nagant
	name = "\improper Nagant M1895"
	desc = "A very, very old revolver. It's been modified to shoot .357 ammo."
	icon_state = "nagant"
	origin_tech = "combat=2;materials=2"
	pin = /obj/item/device/firing_pin/generic

// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/weapon/gun/projectile/revolver/russian
	name = "\improper russian revolver"
	desc = "A Russian-made revolver for drinking games. Uses .357 ammo, and has a mechanism requiring you to spin the chamber before each trigger pull."
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/rus357
	var/spun = 0
	pin = /obj/item/device/firing_pin/generic

/obj/item/weapon/gun/projectile/revolver/russian/New()
	..()
	Spin()
	update_icon()

/obj/item/weapon/gun/projectile/revolver/russian/proc/Spin()
	chambered = null
	var/random = rand(1, magazine.max_ammo)
	if(random <= get_ammo(0,0))
		chamber_round()
	spun = 1

/obj/item/weapon/gun/projectile/revolver/russian/attackby(obj/item/A, mob/user, params)
	var/num_loaded = ..()
	if(num_loaded)
		user.visible_message("[user] loads a single bullet into the revolver and spins the chamber.", "<span class='notice'>You load a single bullet into the chamber and spin it.</span>")
	else
		user.visible_message("[user] spins the chamber of the revolver.", "<span class='notice'>You spin the revolver's chamber.</span>")
	if(get_ammo() > 0)
		Spin()
	update_icon()
	A.update_icon()
	return

/obj/item/weapon/gun/projectile/revolver/russian/attack_self(mob/user)
	if(!spun && can_shoot())
		user.visible_message("[user] spins the chamber of the revolver.", "<span class='notice'>You spin the revolver's chamber.</span>")
		Spin()
	else
		var/num_unloaded = 0
		while (get_ammo() > 0)
			var/obj/item/ammo_casing/CB
			CB = magazine.get_round()
			chambered = null
			CB.loc = get_turf(src.loc)
			CB.update_icon()
			num_unloaded++
		if (num_unloaded)
			user << "<span class='notice'>You unload [num_unloaded] shell\s from [src].</span>"
		else
			user << "<span class='notice'>[src] is empty.</span>"

/obj/item/weapon/gun/projectile/revolver/russian/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.a_intent == "harm") // Flogging action
				return

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		if(ismob(target))
			user << "<span class='warning'>A mechanism prevents you from shooting anyone but yourself!</span>"
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			user << "<span class='warning'>You need to spin the revolver's chamber first!</span>"
			return

		spun = 0

		if(chambered)
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire(user, user))
				playsound(user, fire_sound, 50, 1)
				var/zone = check_zone(user.zone_sel.selecting)
				var/obj/item/organ/limb/affecting = H.get_organ(zone)
				if(zone == "head" || zone == "eyes" || zone == "mouth")
					user.apply_damage(300, BRUTE, affecting)
					user.visible_message("<span class='danger'>[user.name] fires [src] at \his head!</span>", "<span class='userdanger'>You fire [src] at your head!</span>", "<span class='italics'>You hear a gunshot!</span>")
				else
					user.visible_message("<span class='danger'>[user.name] cowardly fires [src] at \his [affecting]!</span>", "<span class='userdanger'>You cowardly fire [src] at your [affecting]!</span>", "<span class='italics'>You hear a gunshot!</span>")
				return

		user.visible_message("<span class='danger'>*click*</span>")
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)


/obj/item/weapon/gun/projectile/revolver/rigatoni
	name = "italian revolver"
	desc = "A black snubnosed .38 revolver. Very italian."
	icon_state = "rigavolver"
	item_state = "rigavolver"
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	pin = /obj/item/device/firing_pin/generic

/obj/item/weapon/gun/energy/revolver/cyborg
	name = "cyborg revolver"
	desc = "An autorevolver that fires 3d-printed flachettes slowly regenerated using a cyborg's internal power source."
	item_state = "mateba"
	cell_type = "/obj/item/weapon/stock_parts/cell/secborg"
	ammo_type = list(/obj/item/ammo_casing/energy/c3dbullet)
	var/charge_tick = 0
	var/recharge_time = 10
	pin = /obj/item/device/firing_pin/generic

/obj/item/weapon/gun/energy/revolver/cyborg/update_icon()
	return

/obj/item/weapon/gun/energy/revolver/cyborg/New()
	..()
	SSobj.processing += src


/obj/item/weapon/gun/energy/revolver/cyborg/Destroy()
	SSobj.processing += src
	..()

/obj/item/weapon/gun/energy/revolver/cyborg/process()
	charge_tick++
	if(charge_tick < recharge_time) return 0
	charge_tick = 0

	if(!power_supply) return 0 //sanity
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			var/obj/item/ammo_casing/energy/shot = ammo_type[select] //Necessary to find cost of shot
			if(R.cell.use(shot.e_cost)) 		//Take power from the borg...
				power_supply.give(shot.e_cost)	//...to recharge the shot

	return 1

/obj/item/weapon/gun/energy/revolver/plasmoidcombi
	name = "Plasma-.357 Combi Revolver"
	desc = "A highly advanced ballistic-energy weapon hybrid capable of firing both singular plasmoid bursts and printed .357 rounds, printing .357 rounds incurs a significant power draw"
	cell_type = /obj/item/weapon/stock_parts/cell/combi
	icon_state = "plasmoid_combi_revolver"
	ammo_type = list(/obj/item/ammo_casing/energy/plasmoid, /obj/item/ammo_casing/energy/e357)
	pin = /obj/item/device/firing_pin/generic

/obj/item/weapon/gun/energy/revolver/plasmoidcombi/attack_self(mob/living/user)
	select_fire(user)