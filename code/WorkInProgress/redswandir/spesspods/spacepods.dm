#define DAMAGE			1
#define FIRE			2

/obj/mecha/spacepod
	name = "space pod"
	desc = "A space pod, traditionally used for space travel by those who don't have space gear."
	icon = 'icons/mecha/pods.dmi'
	icon_state = "pod_civ"
	force = 30
	internal_damage_threshold = 50
	maint_access = 0
	step_in = 2
	layer = 3.9
	health = 500
	bound_width = 64
	bound_height = 64
	damage_absorption = list("brute"=0.9,"fire"=1,"bullet"=0.8,"laser"=0.8,"energy"=1,"bomb"=0.4)
	var/datum/spacepod/equipment/equipment_system
	var/list/pod_overlays
	var/hatch_open = 0
	var/next_firetime = 0
	var/list/cargo = new
	var/cargo_capacity = 15

/obj/mecha/spacepod/New()
	. = ..()
	if(!pod_overlays)
		pod_overlays = new/list(2)
		pod_overlays[DAMAGE] = image(icon, icon_state="pod_damage")
		pod_overlays[FIRE] = image(icon, icon_state="pod_fire")
	bound_width = 64
	bound_height = 64
	src.use_internal_tank = 1
	equipment_system = new(src)

/obj/mecha/spacepod/mechturn(direction)
	dir = direction
	return 1

/obj/mecha/spacepod/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		//playsound(src,'sound/mecha/mechstep.ogg',25,1)
		return
	else
		return

/obj/mecha/spacepod/mechsteprand()
	var/result = step_rand(src)
	if(result)
		//playsound(src,'sound/mecha/mechstep.ogg',25,1)
		return
	else
		return


/obj/mecha/spacepod/Destroy()
	explosion(get_turf(loc), 0, 1, 3, 4)
	..()

/obj/mecha/spacepod/proc/update_icons()
	if(!pod_overlays)
		pod_overlays = new/list(2)
		pod_overlays[DAMAGE] = image(icon, icon_state="pod_damage")
		pod_overlays[FIRE] = image(icon, icon_state="pod_fire")

	if(health <= round(initial(health)/2))
		overlays += pod_overlays[DAMAGE]
		if(health <= round(initial(health)/4))
			overlays += pod_overlays[FIRE]
		else
			overlays -= pod_overlays[FIRE]
	else
		overlays -= pod_overlays[DAMAGE]

/obj/mecha/spacepod/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		hatch_open = !hatch_open
		user << "<span class='notice'>You [hatch_open ? "open" : "close"] the maintenance hatch.</span>"
	if(istype(W, /obj/item/weapon/stock_parts/cell))
		if(!hatch_open)
			return ..()
		if(cell)
			user << "<span class='notice'>The pod already has a cell.</span>"
			return
		user.drop_item(W)
		cell = W
		W.loc = src
		return
	if(istype(W, /obj/item/mecha_parts/spod_equipment))
		if(!hatch_open)
			return ..()
		if(!equipment_system)
			user << "<span class='warning'>The pod has no equipment datum, PANIC!!!!! and adminhelp it and complain fucking everywhere about it so Red can see it</span>"
			playsound(src,'sound/misc/no.ogg',80,0) //oh god why
			return
		if(istype(W, /obj/item/mecha_parts/spod_equipment/weaponry))
			if(equipment_system.weapon_system)
				user << "<span class='notice'>The pod already has a weapon system, remove it first.</span>"
				return
			else
				user << "<span class='notice'>You insert \the [W] into the equipment system.</span>"
				user.drop_item(W)
				W.loc = equipment_system
				equipment_system.weapon_system = W
				equipment_system.weapon_system.my_atom = src
				var/path = text2path("[W.type]/proc/fire_weapon_system")
				if(path)
					verbs += path
				return


/obj/mecha/spacepod/attack_hand(mob/user as mob)
	if(!hatch_open)
		return ..()
	if(!equipment_system || !istype(equipment_system))
		user << "<span class='warning'>The pod has no equpment datum, or is the wrong type, SCREAM and SHOUT at Redswandir</span>"
		return
	var/list/possible = list()
	if(cell)
		possible.Add("Energy Cell")
	if(equipment_system.weapon_system)
		possible.Add("Weapon System")
	var/obj/item/mecha_parts/spod_equipment/SPE
	switch(input(user, "Remove which equipment?", null, null) as null|anything in possible)
		if("Energy Cell")
			if(user.put_in_any_hand_if_possible(cell))
				user << "<span class='notice'>You remove \the [cell] from the space pod</span>"
				cell = null
		if("Weapon System")
			SPE = equipment_system.weapon_system
			if(user.put_in_any_hand_if_possible(SPE))
				user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
				SPE.my_atom = null
				equipment_system.weapon_system = null
			else
				user << "<span class='warning'>You need an open hand to do that.</span>"
	return





/obj/mecha/spacepod/spacepod
	icon_state = "pod_civ"
	desc = "A space pod, traditionally used for space travel by those who don't have space gear. This is the sleek and unexpensive civilian model."
	health = 300

/obj/mecha/spacepod/spacepod/New()
	..()
	var/obj/item/mecha_parts/spod_equipment/A1 = new /obj/item/mecha_parts/spod_equipment/tool/wormhole_generator
	var/obj/item/mecha_parts/spod_equipment/A2 = new /obj/item/mecha_parts/spod_equipment/engine/basic
	A1.attach(src)
	A2.attach(src)
	return

/obj/mecha/spacepod/security
	name = "security space pod"
	icon_state = "pod_mil"
	desc = "A space pod, traditionally used for space travel. This dark grey space pod has a Nanotrasen Military insignia on the side."
	health = 400

/obj/mecha/spacepod/security/New()
	..()
	var/obj/item/mecha_parts/spod_equipment/A1 = new /obj/item/mecha_parts/spod_equipment/tool/wormhole_generator
	var/obj/item/mecha_parts/spod_equipment/A2 = new /obj/item/mecha_parts/spod_equipment/engine/basic
	var/obj/item/mecha_parts/spod_equipment/SG = new /obj/item/mecha_parts/spod_equipment/weaponry/taser
	A1.attach(src)
	A2.attach(src)
	SG.attach(src)
	return

/obj/mecha/spacepod/mining
	name = "mining space pod"
	icon_state = "pod_industrial"
	desc = "A space pod, traditionally used for space travel. This rough looking space pod is reinforced and ready for industrial work."

/obj/mecha/spacepod/mining/New()
	..()
	var/obj/item/mecha_parts/spod_equipment/A1 = new /obj/item/mecha_parts/spod_equipment/tool/wormhole_generator
	var/obj/item/mecha_parts/spod_equipment/A2 = new /obj/item/mecha_parts/spod_equipment/engine/basic
	var/obj/item/mecha_parts/spod_equipment/M1 = new /obj/item/mecha_parts/spod_equipment/tool/drill
	var/obj/item/mecha_parts/spod_equipment/M2 = new /obj/item/mecha_parts/spod_equipment/tool/hydraulic_clamp
	A1.attach(src)
	A2.attach(src)
	M1.attach(src)
	M2.attach(src)
	return

/obj/mecha/spacepod/syndie
	name = "syndicate space pod"
	icon_state = "pod_syndi"
	desc = "A space pod, traditionally used for space travel. This menacing military space pod has 'Eat Shit NT' sprayed on it's side."

/obj/mecha/spacepod/syndie/New()
	..()
	var/obj/item/mecha_parts/spod_equipment/A1 = new /obj/item/mecha_parts/spod_equipment/tool/wormhole_generator
	var/obj/item/mecha_parts/spod_equipment/A2 = new /obj/item/mecha_parts/spod_equipment/engine/basic
	var/obj/item/mecha_parts/spod_equipment/SG = new /obj/item/mecha_parts/spod_equipment/weaponry/laser
	A1.attach(src)
	A2.attach(src)
	SG.attach(src)
	return




#undef DAMAGE
#undef FIRE