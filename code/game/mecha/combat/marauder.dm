/obj/mecha/combat/marauder
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	name = "\improper Marauder"
	icon_state = "marauder"
	step_in = 5
	health = 500
	deflect_chance = 25
	damage_absorption = list("brute"=0.5,"fire"=0.7,"bullet"=0.45,"laser"=0.6,"energy"=0.7,"bomb"=0.7)
	max_temperature = 60000
	infra_luminosity = 3
	var/zoom = 0
	var/reset_stretch = 0 //What value to reset the user's icon size after you get out?
	var/smoke = 5
	var/smoke_ready = 1
	var/smoke_cooldown = 100
	var/datum/effect_system/smoke_spread/smoke_system = new
	operation_req_access = list(access_cent_specops)
	wreckage = /obj/structure/mecha_wreckage/marauder
	add_req_access = 0
	internal_damage_threshold = 25
	force = 45
	max_equip = 4
	var/datum/action/mecha/mech_smoke/smoke_action = new
	var/datum/action/mecha/mech_zoom/zoom_action = new

/obj/mecha/combat/marauder/New()
	..()
	smoke_system.set_up(3, src)
	smoke_system.attach(src)

/obj/mecha/combat/marauder/Destroy()
	qdel(smoke_system)
	smoke_system = null
	return ..()

/obj/mecha/combat/marauder/relaymove(mob/user,direction)
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
	return ..()

/obj/mecha/combat/marauder/GrantActions(var/mob/living/user, var/human_occupant = 0)
	..()
	smoke_action.chassis = src
	smoke_action.Grant(user)

	thrusters_action.chassis = src
	thrusters_action.Grant(user)

	zoom_action.chassis = src
	zoom_action.Grant(user)

/obj/mecha/combat/marauder/RemoveActions(var/mob/living/user, var/human_occupant = 0)
	..()
	smoke_action.Remove(user)
	thrusters_action.Remove(user)
	zoom_action.Remove(user)

/obj/mecha/combat/marauder/go_out()
	if(src.occupant && src.occupant.client)
		winset(src.occupant.client, "mapwindow.map", "icon-size=[src.reset_stretch]")
		src.occupant.client.view = world.view
		src.zoom = 0
	..()
	return


/obj/mecha/combat/marauder/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke]<br>
				<b>Thrusters:</b> [thrusters?"on":"off"]<br>
				<b>Zoom:</b> [zoom?"on":"off"]
					"}
	return output


/obj/mecha/combat/marauder/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/missile_rack(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster(src)
	ME.attach(src)

/obj/mecha/combat/marauder/seraph
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	name = "\improper Seraph"
	icon_state = "seraph"
	operation_req_access = list(access_cent_specops)
	step_in = 3
	health = 550
	wreckage = /obj/structure/mecha_wreckage/seraph
	internal_damage_threshold = 20
	force = 55
	max_equip = 5

/obj/mecha/combat/marauder/seraph/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/missile_rack(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster(src)
	ME.attach(src)

/obj/mecha/combat/marauder/mauler
	desc = "Heavy-duty, combat exosuit, developed off of the existing Marauder model."
	name = "\improper Mauler"
	icon_state = "mauler"
	operation_req_access = list(access_syndicate)
	wreckage = /obj/structure/mecha_wreckage/mauler
	max_equip = 5

/obj/mecha/combat/marauder/mauler/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/missile_rack(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster(src)
	ME.attach(src)


/datum/action/mecha/mech_smoke
	name = "Smoke"
	button_icon_state = "mech_smoke"

/datum/action/mecha/mech_smoke/Activate()
	if(!owner || !chassis || chassis.occupant != owner)
		return
	var/obj/mecha/combat/marauder/M = chassis
	if(M.smoke_ready && M.smoke>0)
		M.smoke_system.start()
		M.smoke--
		M.smoke_ready = 0
		spawn(M.smoke_cooldown)
			M.smoke_ready = 1

/datum/action/mecha/mech_zoom
	name = "Zoom"
	button_icon_state = "mech_zoom_off"

/datum/action/mecha/mech_zoom/Activate()
	if(!owner || !chassis || chassis.occupant != owner)
		return
	var/obj/mecha/combat/marauder/M = chassis
	if(owner.client)
		M.zoom = !M.zoom
		button_icon_state = "mech_zoom_[M.zoom ? "on" : "off"]"
		M.log_message("Toggled zoom mode.")
		M.occupant_message("<font color='[M.zoom?"blue":"red"]'>Zoom mode [M.zoom?"en":"dis"]abled.</font>")
		if(M.zoom)
			M.reset_stretch = winget(M.occupant.client, "mapwindow.map", "icon-size")
			winset(M.occupant.client, "mapwindow.map", "icon-size=0")
			owner.client.view = 12
			owner << sound('sound/mecha/imag_enh.ogg',volume=50)
		else
			owner.client.view = world.view//world.view - default mob view size
