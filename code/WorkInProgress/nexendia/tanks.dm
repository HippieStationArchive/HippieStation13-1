//Tiny Tanks!  ~Nexendia

/obj/mecha/combat/tank
	desc = "A small Tank used by /NT/ Mercenaries or by a really bored Roboticist."
	name = "\improper tank"
	icon_state = "tank"
	icon = 'code/WorkInProgress/nexendia/tanks.dmi'
	alpha = 255
	opacity = 0
	step_in = 2
	dir_in = 1 //Facing North.
	health = 165
	deflect_chance = 15
	damage_absorption = list("brute"=0.8,"bomb"=0.6)
	max_temperature = 15000
	wreckage = null
	operation_req_access = list()
	add_req_access = 0
	internal_damage_threshold = 25
	max_equip = 2
	step_energy_drain = 3
	var/thrusters = 0 //can't forget this lmao
	stepsound = 'sound/effects/mowermove1.ogg'
	turnsound = 'sound/effects/mowermove2.ogg'

/obj/mecha/combat/tank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank
	ME.attach(src)
	return

/obj/mecha/combat/tank/add_cell(var/obj/item/weapon/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 20000
	cell.maxcharge = 20000

/obj/mecha/combat/tank/synditank
	desc = "A highly dangerous Tank designed for boarding operations onto other Stations!."
	name = "\improper syndi tank"
	icon_state = "tankred"
	health = 400
	deflect_chance = 20
	damage_absorption = list("brute"=0.7,"fire"=1.1,"bullet"=0.75,"laser"=0.85,"energy"=0.9,"bomb"=0.8)
	max_temperature = 17000
	wreckage = null
	add_req_access = 0
	internal_damage_threshold = 30
	max_equip = 2
	step_energy_drain = 6

/obj/mecha/combat/tank/synditank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank/syndi
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine
	ME.attach(src)
	return

/obj/mecha/combat/tank/synditank/add_cell(var/obj/item/weapon/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000

/obj/mecha/combat/tank/synditank/Process_Spacemove(var/movement_dir = 0)
	if(..())
		return 1
	if(thrusters && movement_dir && use_power(step_energy_drain))
		return 1
	return 0

/obj/mecha/combat/tank/synditank/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle thrusters"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(src.occupant)
		if(get_charge() > 0)
			thrusters = !thrusters
			src.log_message("Toggled thrusters.")
			src.occupant_message("<font color='[src.thrusters?"blue":"red"]'>Thrusters [thrusters?"en":"dis"]abled.")
	return

/obj/mecha/combat/tank/synditank/Topic(href, href_list)
	..()
	if (href_list["toggle_thrusters"])
		src.toggle_thrusters()
	return


//Weeaboo and Plushie tank removed as deemed to fucking stupid to even bother keeping ;~;

/*
		TANK WEAPONS BELOW!!!
*/

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank
	name = "\improper 30mm Tank AutoCannon"
	desc = "A light AutoCannon for Tanks."
	fire_sound = "sound/weapons/Gunshot_silenced.ogg"  //Sounds tankish..
	icon_state = "mecha_carbine" //Just a temp sprite for now..  Nien bby please make me one
	equip_cooldown = 18
	projectile = /obj/item/projectile/bullet/tank
	projectiles = 10
	projectile_energy_cost = 50

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank/syndi
	equip_cooldown = 12
	projectile = /obj/item/projectile/bullet/tank/syndi

/obj/item/projectile/bullet/tank
	damage = 18 //20 just seems a bit much

/obj/item/projectile/bullet/tank/syndi
	damage = 30  //Tank Cannon Stronk!
