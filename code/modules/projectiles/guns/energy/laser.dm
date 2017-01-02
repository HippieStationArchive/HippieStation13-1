/obj/item/weapon/gun/energy/laser
	name = "laser gun"
	desc = "A basic energy-based laser gun that fires concentrated beams of light which pass through glass and thin metal."
	icon_state = "laser"
	item_state = "laser"
	w_class = 3
	materials = list(MAT_METAL=2000)
	origin_tech = "combat=3;magnets=2"
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1

////////Basic Weapons////////////////

/obj/item/weapon/gun/energy/laser/rifle
	name = "laser rifle"
	desc = "A focused laser weapon capable of producing a beam of light that is made for maximum damage and accuracy."
	icon_state = "laser_rifle"
	item_state = "laser"
	w_class = 4
	origin_tech = "combat=4;materials=3;powerstorage=4"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/rifle)

/obj/item/weapon/gun/energy/laser/pistol
	name = "laser pistol"
	desc = "A low powered laser weapon that is small and robust. Pocket size."
	icon_state = "laser_pistol"
	item_state = "gun"
	w_class = 2
	origin_tech = "combat=2;materials=3;powerstorage=2"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pistol)
	slot_flags = SLOT_POCKET

/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/practice)
	clumsy_check = 0
	needs_permit = 0

/obj/item/weapon/gun/energy/laser/retro
	name ="retro laser gun"
	icon_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by Nanotrasen's private security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	ammo_x_offset = 3

/obj/item/weapon/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the L.A.S.E.R. cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = "laser"
	w_class = 4
	force = 10
	stamina_percentage = 0.4
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=3;powerstorage=3"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/heavy)
	ammo_x_offset = 3

/obj/item/weapon/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts that pass through multiple soft targets and heavier materials"
	icon_state = "xray"
	item_state = "laser"
	origin_tech = "combat=5;materials=3;magnets=2;syndicate=2"
	ammo_type = list(/obj/item/ammo_casing/energy/xray)
	pin = null
	ammo_x_offset = 3

/obj/item/weapon/gun/energy/laser/hypercannon
	name = "laser hypercannon"
	desc = "An advanced laser cannon that does more damage the farther away the target is."
	icon_state = "laser_hypercannon"
	item_state = "alc"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = "combat=4;materials=3;powerstorage=3"
	cell_type = /obj/item/weapon/stock_parts/cell/laser/hypercannon
	ammo_type = list(/obj/item/ammo_casing/energy/laser/hyper)

/obj/item/projectile/beam/laser/accelerator/Range()
	..()
	damage = min(damage+10, 100)

/obj/item/weapon/gun/energy/laser/hypercannon/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/energy/shot = chambered
		power_supply.use(shot.e_cost)//... drain the power_supply cell
		canshoot = 0
		spawn(10)
			canshoot = 1
			if(power_supply.charge >= shot.e_cost)
				playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	chambered = null //either way, released the prepared shot
	return

/obj/item/weapon/gun/energy/laser/cyborg
	icon_state = "cyborg_laser"
	can_charge = 0
	desc = "An energy-based laser gun that draws power from the cyborg's internal energy cell directly. So this is what freedom looks like?"

/obj/item/weapon/gun/energy/laser/cyborg/newshot()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			var/obj/item/ammo_casing/energy/shot = ammo_type[select] //Necessary to find cost of shot
			if(R.cell.use(shot.e_cost))
				chambered = shot
				chambered.newshot()
	return

/obj/item/weapon/gun/energy/laser/cyborg/emp_act()
	return

////////Multistate Weapons///////////

/obj/item/weapon/gun/energy/laser/hybrid
	multistate = 1
	name = "hybrid laser gun"
	icon_state = "laser_hybrid"
	item_state = ""
	desc = "An advanced laser weapon that is able to increase and decrease its beam for either non-lethal and lethal combat."
	origin_tech = "combat=4;materials=4;powerstorage=4"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)

/obj/item/weapon/gun/energy/laser/hybrid/attack_self(mob/living/user as mob) //For multistate processing
	select_fire(user)
	multistate_update()
	update_icon(user)

/obj/item/weapon/gun/energy/laser/hybrid/pistol
	multistate = 1
	name = "hybrid laser pistol"
	icon_state = "laser_hybrid_pistol"
	item_state = "gun"
	desc = "A compact laser weapon that is able to increase and decrease its beam for either non-lethal and lethal combat."
	origin_tech = "combat=4;materials=4;powerstorage=4"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
	slot_flags = SLOT_POCKET
	cell_type = /obj/item/weapon/stock_parts/cell/laser/pistol_hybrid

/obj/item/weapon/gun/energy/laser/scatter
	name = "scatter laser gun"
	desc = "A laser gun equipped with a refraction kit that spreads bolts."
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/laser/scatter)

/obj/item/weapon/gun/energy/laser/scatter/attack_self(mob/living/user as mob)
	select_fire(user)
	update_icon()

////////Self Charging Weapons////////

/obj/item/weapon/gun/energy/laser/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	stamina_percentage = 0.6
	origin_tech = null
	var/charge_tick = 0
	ammo_x_offset = 3

/obj/item/weapon/gun/energy/laser/captain/New()
	..()
	SSobj.processing |= src


/obj/item/weapon/gun/energy/laser/captain/Destroy()
	SSobj.processing.Remove(src)
	return ..()


/obj/item/weapon/gun/energy/laser/captain/process()
	charge_tick++
	if(charge_tick < 4) return 0
	charge_tick = 0
	if(!power_supply) return 0
	power_supply.give(100)
	update_icon()
	return 1

////////Laser Tag////////////////////

/obj/item/weapon/gun/energy/laser/bluetag
	name = "laser tag gun"
	icon_state = "bluetag"
	desc = "A retro laser gun modified to fire harmless blue beams of light. Sound effects included!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag)
	origin_tech = "combat=1;magnets=2"
	clumsy_check = 0
	needs_permit = 0
	var/charge_tick = 0
	pin = /obj/item/device/firing_pin/tag/blue
	ammo_x_offset = 2

/obj/item/weapon/gun/energy/laser/bluetag/New()
	..()
	SSobj.processing |= src

/obj/item/weapon/gun/energy/laser/bluetag/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/item/weapon/gun/energy/laser/bluetag/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	update_icon()
	return 1


/obj/item/weapon/gun/energy/laser/redtag
	name = "laser tag gun"
	icon_state = "redtag"
	desc = "A retro laser gun modified to fire harmless beams red of light. Sound effects included!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag)
	origin_tech = "combat=1;magnets=2"
	clumsy_check = 0
	needs_permit = 0
	var/charge_tick = 0
	pin = /obj/item/device/firing_pin/tag/red
	ammo_x_offset = 2

/obj/item/weapon/gun/energy/laser/redtag/New()
	..()
	SSobj.processing |= src

/obj/item/weapon/gun/energy/laser/redtag/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/item/weapon/gun/energy/laser/redtag/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	update_icon()
	return 1
