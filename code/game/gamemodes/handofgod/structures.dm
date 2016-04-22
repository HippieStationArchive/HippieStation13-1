/proc/build_hog_construction_lists()
	if(global_handofgod_traptypes.len && global_handofgod_structuretypes.len)
		return

	var/list/types = typesof(/obj/structure/divine) - /obj/structure/divine - /obj/structure/divine/trap
	for(var/T in types)
		var/obj/structure/divine/D = T
		if(initial(D.constructable))
			if(initial(D.trap))
				global_handofgod_traptypes[initial(D.name)] = T
			else
				global_handofgod_structuretypes[initial(D.name)] = T

/obj/structure/divine
	name = "divine construction site"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	desc = "An unfinished divine building"
	anchored = 1
	density = 1
	var/constructable = TRUE
	var/trap = FALSE // for hog list purposes
	var/metal_cost = 0
	var/glass_cost = 0
	var/lesser_gem_cost = 0
	var/greater_gem_cost = 0
	var/mob/camera/god/deity
	var/side = "" //used for colouring structures when construction is started by a deity
	var/health = 100
	var/maxhealth = 100
	var/overlay_icon_state // this is an icon state which will be applied on the (usually brown) structure chassis to make it clear what team is it of.
	var/image/overlay

/obj/structure/divine/New(location, mob/camera/god/G)
	..()
	assign_deity(G)
	if(overlay_icon_state)
		overlay = new(icon, overlay_icon_state)
	update_icons()


/obj/structure/divine/proc/update_icons()
	if(overlay)
		overlays.Cut()
		if(side) //if it has an overlay that needs to be applied
			overlay.color = side
			overlays += overlay


/obj/structure/divine/Destroy()
	if(deity)
		deity.structures -= src
	return ..()


/obj/structure/divine/proc/healthcheck()
	if(!health)
		visible_message("<span class='danger'>\The [src] was destroyed!</span>")
		qdel(src)


/obj/structure/divine/attackby(obj/item/I, mob/user)
	if(!I || (I.flags & ABSTRACT))
		return 0

	//Structure conversion/capture
	if(istype(I, /obj/item/weapon/godstaff))
		if(!is_in_any_team(user.mind))
			user << "<span class='notice'>You're not quite sure what the hell you're even doing.</span>"
			return
		var/obj/item/weapon/godstaff/G = I
		if(G.god && deity != G.god)
			assign_deity(G.god, alert_old_deity = TRUE)
			visible_message("<span class='boldnotice'>\The [src] has been captured by [user]!</span>")
		return

	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(get_turf(src), I.hitsound, 50, 1)
	visible_message("<span class='danger'>\The [src] has been attacked with \the [I][(user ? " by [user]" : ".")]!</span>")
	health = max(0, health-I.force)
	healthcheck()


/obj/structure/divine/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return 0

	if(Proj.damage_type == BRUTE || Proj.damage_type == BURN)
		health = max(0, health-Proj.damage)
		healthcheck()


/obj/structure/divine/attack_animal(mob/living/simple_animal/M)
	if(!M)
		return 0

	visible_message("<span class='danger'>\The [src] has been attacked by \the [M]!</span>")
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	if(!damage)
		return
	health = max(0, health-damage)
	healthcheck()


/obj/structure/divine/proc/assign_deity(mob/camera/god/new_deity, alert_old_deity = TRUE)
	if(!new_deity)
		return 0
	if(deity)
		if(alert_old_deity)
			deity << "<span class='danger'><B>Your [name] was captured by [new_deity]'s cult!</B></span>"
		deity.structures -= src
	deity = new_deity
	deity.structures |= src
	side = deity.side
	update_icons()
	return 1


/obj/structure/divine/construction_holder
	alpha = 125
	constructable = FALSE
	var/obj/structure/divine/construction_result = /obj/structure/divine //a path, but typed to /obj/structure/divine for initial()



/obj/structure/divine/construction_holder/assign_deity(mob/camera/god/new_deity, alert_old_deity = TRUE)
	if(..())
		color = side


/obj/structure/divine/construction_holder/attack_god(mob/camera/god/user)
	if(user.side == side && construction_result)
		user.add_faith(75)
		visible_message("<span class='danger'>[user] has cancelled \the [initial(construction_result.name)]")
		qdel(src)


/obj/structure/divine/construction_holder/proc/setup_construction(construct_type)
	if(ispath(construct_type))
		construction_result = construct_type
		name = "[initial(construction_result.name)] construction site "
		icon_state = initial(construction_result.icon_state)
		metal_cost = initial(construction_result.metal_cost)
		glass_cost = initial(construction_result.glass_cost)
		lesser_gem_cost = initial(construction_result.lesser_gem_cost)
		greater_gem_cost = initial(construction_result.greater_gem_cost)
		desc = "An unfinished [initial(construction_result.name)]."
		overlay_icon_state = initial(construction_result.overlay_icon_state)
	update_icons()


/obj/structure/divine/construction_holder/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return 0

	if(istype(I, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = I
		if(metal_cost)
			var/spend = min(metal_cost, M.amount)
			user << "<span class='notice'>You add [spend] metal to \the [src]."
			metal_cost = max(0, metal_cost - spend)
			M.use(spend)
			check_completion()
		else
			user << "<span class='notice'>\The [src] does not require any more metal!"
		return

	if(istype(I, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/G = I
		if(glass_cost)
			var/spend = min(glass_cost, G.amount)
			user << "<span class='notice'>You add [spend] glass to \the [src]."
			glass_cost = max(0, glass_cost - spend)
			G.use(spend)
			check_completion()
		else
			user << "<span class='notice'>\The [src] does not require any more glass!"
		return

	if(istype(I, /obj/item/stack/sheet/lessergem))
		var/obj/item/stack/sheet/lessergem/LG = I
		if(lesser_gem_cost)
			var/spend = min(lesser_gem_cost, LG.amount)
			user << "<span class='notice'>You add [spend] lesser gems to \the [src]."
			lesser_gem_cost = max(0, lesser_gem_cost - spend)
			LG.use(spend)
			check_completion()
		else
			user << "<span class='notice'>\The [src] does not require any more lesser gems!"
		return

	if(istype(I, /obj/item/stack/sheet/greatergem))
		var/obj/item/stack/sheet/greatergem/GG = I //GG!
		if(greater_gem_cost)
			var/spend = min(greater_gem_cost, GG.amount)
			user << "<span class='notice'>You add [spend] greater gems to \the [src]."
			greater_gem_cost = max(0, greater_gem_cost - spend)
			GG.use(spend)
			check_completion()
		else
			user << "<span class='notice'>\The [src] does not require any more greater gems!"
		return

	..()


/obj/structure/divine/construction_holder/proc/check_completion()
	if(!metal_cost && !glass_cost && !lesser_gem_cost && !greater_gem_cost)
		visible_message("<span class='notice'>\The [initial(construction_result.name)] is complete!</span>")
		new construction_result(get_turf(src), deity)
		qdel(src)


/obj/structure/divine/construction_holder/examine(mob/user)
	..()

	if(metal_cost || glass_cost || lesser_gem_cost || greater_gem_cost)
		user << "To finish construction it requires the following materials:"
		if(metal_cost)
			user << "[metal_cost] metal <IMG CLASS=icon SRC=icons/obj/items.dmi ICONSTATE='sheet-metal'>"
		if(glass_cost)
			user << "[glass_cost] glass <IMG CLASS=icon SRC=icons/obj/items.dmi ICONSTATE='sheet-glass'>"
		if(lesser_gem_cost)
			user << "[lesser_gem_cost] lesser gems <IMG CLASS=icon SRC=icons/obj/items.dmi ICONSTATE='sheet-lessergem'>"
		if(greater_gem_cost)
			user << "[greater_gem_cost] greater gems <IMG CLASS=icon SRC=icons/obj/items.dmi ICONSTATE='sheet-greatergem'>"


/obj/structure/divine/nexus
	name = "nexus"
	desc = "It anchors a deity to this world. It radiates an unusual aura. Cultists protect this at all costs. It looks well protected from explosive shock."
	icon_state = "nexus-frame"
	health = 500
	maxhealth = 500
	constructable = FALSE
	overlay_icon_state = "nexus-overlay"
	var/faith_regen_rate = 1
	var/list/powerpylons = list()


/obj/structure/divine/nexus/ex_act()
	return


/obj/structure/divine/nexus/healthcheck()
	if(deity)
		deity.update_health_hud()

	if(!health)
		if(!qdeleted(deity) && deity.nexus_required)
			deity << "<span class='danger'>Your nexus was destroyed. You feel yourself fading...</span>"
			qdel(deity)
		visible_message("<span class='danger'>\The [src] was destroyed!</span>")
		qdel(src)


/obj/structure/divine/nexus/New(location, mob/camera/god/G)
	..()
	SSobj.processing |= src


/obj/structure/divine/nexus/process()
	healthcheck()
	if(deity)
		deity.update_followers()
		deity.add_faith(faith_regen_rate + (powerpylons.len / 5) + (deity.alive_followers / 3))
		deity.max_faith = initial(deity.max_faith) + (deity.alive_followers*10) //10 followers = 100 max faith, so disaster() at around 20 followers
		deity.check_death()
		deity.check_prophet()


/obj/structure/divine/nexus/Destroy()
	SSobj.processing -= src
	return ..()


/obj/structure/divine/conduit
	name = "conduit"
	desc = "It allows a deity to extend their reach.  Their powers are just as potent near a conduit as a nexus."
	icon_state = "conduit-frame"
	health = 150
	maxhealth = 150
	metal_cost = 20
	glass_cost = 5
	overlay_icon_state = "conduit-overlay"

/obj/structure/divine/conduit/assign_deity(mob/camera/god/new_deity, alert_old_deity = TRUE)
	if(deity)
		deity.conduits -= src
	..()
	if(deity)
		deity.conduits += src


/obj/structure/divine/forge
	name = "forge"
	desc = "A forge fueled by divine might, it allows the creation of sacred and powerful artifacts.  It requires common materials to craft objects."
	icon_state = "forge-frame"
	health = 250
	maxhealth = 250
	density = 0
	maxhealth = 250
	metal_cost = 40
	overlay_icon_state = "forge-overlay"
	var/datum/material_container/materials
	var/faith = 0 // faith which a god can deposit, used to make stuff

/obj/structure/divine/forge/New(location, mob/camera/god/G)
	..()
	materials = new(src, list(MAT_METAL=1, MAT_GLASS=1), 225000)

/obj/structure/divine/forge/attack_hand(mob/living/user)
	if(is_in_any_team(user.mind) == side)
		interact(user)
	else
		user << "<span class='danger'>You try to interact with the weird machine, but you burn your hand on its engraved panel!</span>"
		user.adjustFireLoss(5)

/obj/structure/divine/forge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack))
		var/inserted = materials.insert_item(I)
		user << "<span class='notice'>You insert [inserted] sheet[inserted>1 ? "s" : ""] inside the forge.</span>"
	else
		..()

/obj/structure/divine/forge/attack_god(mob/camera/god/user)
	var/n = input("How much faith do you want to put in your forge?", "Deposit faith") as num|null
	if(n == null)
		return
	n = round(n) // to avoid 0.01 faith
	if(n <= 0)
		return
	if(user.faith < n)
		user << "<span class='userdanger'>You don't have enough faith to do that!</span>"
		return
	user.add_faith(-n)
	faith += n

/obj/structure/divine/forge/interact(mob/user) // shamefully copied from god structure/trap proc
	var/dat = ""
	//Materials jettison
	//Metal
	var/m_amount = materials.amount(MAT_METAL)
	dat += "* [m_amount] of Metal: "
	if(m_amount >= MINERAL_MATERIAL_AMOUNT) dat += "<A href='?src=\ref[src];ejectsheet=metal;ejectsheet_amt=1'>Eject</A> "
	if(m_amount >= MINERAL_MATERIAL_AMOUNT*5) dat += "<A href='?src=\ref[src];ejectsheet=metal;ejectsheet_amt=5'>5x</A> "
	if(m_amount >= MINERAL_MATERIAL_AMOUNT) dat += "<A href='?src=\ref[src];ejectsheet=metal;ejectsheet_amt=50'>All</A>"
	dat += "<BR>"
	//Glass
	var/g_amount = materials.amount(MAT_GLASS)
	dat += "* [g_amount] of Glass: "
	if(g_amount >= MINERAL_MATERIAL_AMOUNT) dat += "<A href='?src=\ref[src];ejectsheet=glass;ejectsheet_amt=1'>Eject</A> "
	if(g_amount >= MINERAL_MATERIAL_AMOUNT*5) dat += "<A href='?src=\ref[src];ejectsheet=glass;ejectsheet_amt=5'>5x</A> "
	if(g_amount >= MINERAL_MATERIAL_AMOUNT) dat += "<A href='?src=\ref[src];ejectsheet=glass;ejectsheet_amt=50'>All</A>"
	dat += "<BR>"
	dat += "* [faith] of Faith. <BR>"

	for(var/t in global_handofgod_itemtypes)
		var/obj/item/apath = t
		var/apathname = initial(apath.name)
		var/apathdesc = initial(apath.desc)
		dat += "<center><B>[capitalize(apathname)]</B></center><BR>"
		var/imgicon = "[initial(apath.icon)]"
		var/imgstate = "[initial(apath.icon_state)]"
		var/list/mats = initial(apath.materials)
		var/icon/I = icon(imgicon,imgstate)
		if(side) // safety check
			I.Blend("[side]", ICON_MULTIPLY) //icon multiply otherwise it'll become fluorescent-colored ew
		var/img_component = lowertext(apathname)
		//I hate byond, but atleast it autocaches these so it's only 1*number_of_items worth of actual calls
		user << browse_rsc(I,"hog_items-[img_component]-[side].png")
		dat += "<center><img src='hog_items-[img_component]-[side].png' height=64 width=64></center>"
		dat += "Description: [apathdesc]<BR>"
		dat += "Cost: "
		if(mats[MAT_METAL])
			dat += "[mats[MAT_METAL]] metal;"
		if(mats[MAT_GLASS])
			dat += "[mats[MAT_GLASS]] glass;"
		dat += "<BR>"
		dat += "<center><a href='?src=\ref[src];create_item=[apath]'>Construct [capitalize(apathname)]</a></center><BR><BR>"

	var/datum/browser/popup = new(user, "items","Construct items",350,500)
	popup.set_content(dat)
	popup.open()

/obj/structure/divine/forge/Topic(href, href_list)
	if(href_list["ejectsheet"])
		var/desired_num_sheets = text2num(href_list["ejectsheet_amt"])
		var/MAT
		switch(href_list["ejectsheet"])
			if("metal")
				MAT = MAT_METAL
			if("glass")
				MAT = MAT_GLASS
		materials.retrieve_sheets(desired_num_sheets, MAT)
	else if(href_list["create_item"])
		if(faith < 100) // you need atleast 100 faith to make any kind of item
			visible_message("<span class='danger'>There's not enough faith to make anything!</span>")
			return
		var/obj/item/divinepath = text2path(href_list["create_item"]) //it's a path but we need to initial() some vars
		if(!(divinepath in global_handofgod_itemtypes)) // to prevent href spoofing
			message_admins("Forge href exploit attempted by [key_name(usr, usr.client)]!")
			return
		var/list/mats = list()
		for(var/MAT in initial(divinepath.materials))
			mats[MAT] = initial(divinepath.materials[MAT])
		if(compareAllValues(materials.materials, mats)) //we got enough materials!yay
			new divinepath(get_turf(src), side)
			materials.use_amount(mats)
	updateUsrDialog()

/obj/structure/divine/forge/Destroy()
	qdel(materials)
	..()

/obj/structure/divine/convertaltar
	name = "conversion altar"
	desc = "An altar dedicated to a deity.  Cultists can \"forcefully teach\" their non-aligned crewmembers to join their side and take up their deity."
	icon_state = "convertaltar-frame"
	density = 0
	metal_cost = 15
	can_buckle = 1
	overlay_icon_state = "convertaltar-overlay"


/obj/structure/divine/convertaltar/attack_hand(mob/living/user)
	..()
	var/mob/living/carbon/human/H = locate() in get_turf(src)
	if(!is_in_any_team(user.mind))
		user << "<span class='notice'>You try to use it, but unfortunately you don't know any rituals.</span>"
		return
	if(!H)
		return
	if(!H.mind)
		user << "<span class='danger'>Only sentients may serve your deity.</span>"
		return
	if(is_in_any_team(user.mind) == side)
		user << "<span class='notice'>You invoke the conversion ritual.</span>"
		ticker.mode.add_hog_follower(H.mind, side)
	else
		user << "<span class='notice'>You invoke the conversion ritual.</span>"
		user << "<span class='danger'>But the altar ignores your words...</span>"


/obj/structure/divine/sacrificealtar
	name = "sacrificial altar"
	desc = "An altar designed to perform blood sacrifice for a deity.  The cultists performing the sacrifice will gain a powerful material to use in their forge.  Sacrificing a prophet will yield even better results."
	icon_state = "sacrificealtar-frame"
	density = 0
	metal_cost = 25
	can_buckle = 1
	overlay_icon_state = "sacrificealtar-overlay"


/obj/structure/divine/sacrificealtar/attack_hand(mob/living/user)
	..()
	var/mob/living/L = locate() in get_turf(src)
	if(!is_in_any_team(user.mind))
		user << "<span class='notice'>You try to use it, but unfortunately you don't know any rituals.</span>"
		return
	if(!L)
		return
	if(!L.mind)
		return
	if(is_in_any_team(user.mind) == side)
		if(is_in_any_team(L.mind) == side)
			user << "<span class='danger'>You cannot sacrifice a fellow cultist.</span>"
			return
		user << "<span class='notice'>You attempt to sacrifice [L] by invoking the sacrificial ritual.</span>"
		sacrifice(L)
	else
		user << "<span class='notice'>You attempt to sacrifice [L] by invoking the sacrificial ritual.</span>"
		user << "<span class='danger'>But the altar ignores your words...</span>"


/obj/structure/divine/sacrificealtar/proc/sacrifice(mob/living/L)
	if(!L)
		L = locate() in get_turf(src)
	if(L)
		if(ismonkey(L))
			var/luck = rand(1,4)
			if(luck > 3)
				new /obj/item/stack/sheet/lessergem(get_turf(src))

		else if(ishuman(L))
			var/mob/living/carbon/human/H = L

			//Sacrifice altars can't teamkill
			if(!H.mind || is_in_any_team(H.mind) == side)
				return

			if(what_rank(H.mind) == "Prophet")
				new /obj/item/stack/sheet/greatergem(get_turf(src))
				if(deity)
					deity.prophets_sacrificed_in_name++
			else
				new /obj/item/stack/sheet/lessergem(get_turf(src))

		else if(isAI(L) || istype(L, /mob/living/carbon/alien/humanoid/royal)) // tbh praetorians are nice people too
			new /obj/item/stack/sheet/greatergem(get_turf(src))
		else
			new /obj/item/stack/sheet/lessergem(get_turf(src))
		L.gib()


/obj/structure/divine/healingfountain
	name = "healing fountain"
	desc = "A fountain containing the waters of life... or death, depending on where your allegiances lie."
	icon_state = "fountain-frame"
	metal_cost = 10
	glass_cost = 5
	overlay_icon_state = "fountain-overlay"
	var/time_between_uses = 1800
	var/last_process = 0
	var/cult_only = TRUE

/obj/structure/divine/healingfountain/anyone
	desc = "A fountain containing the waters of life."
	cult_only = FALSE

/obj/structure/divine/healingfountain/attack_hand(mob/living/user)
	if(last_process + time_between_uses > world.time)
		user << "<span class='notice'>The fountain appears to be empty.</span>"
		return
	last_process = world.time
	if((is_in_any_team(user.mind) != side)  && cult_only)// if it's a nonbeliever/an enemy,why the fuck could enemies heal with this?
		user << "<span class='danger'><B>The water burns!</b></spam>"
		user.reagents.add_reagent("hell_water",20)
	else
		user << "<span class='notice'>The water feels warm and soothing as you touch it. The fountain immediately dries up shortly afterwards.</span>"
		user.reagents.add_reagent("godblood",20)
	update_icons()
	spawn(time_between_uses)
		if(src)
			update_icons()

/obj/structure/divine/healingfountain/update_icons()
	overlays.Cut()
	if(last_process + time_between_uses < world.time)
		..()

/obj/structure/divine/powerpylon
	name = "power pylon"
	desc = "A pylon which increases the deity's rate it can influence the world, by increasing its faith."
	icon_state = "powerpylon-frame"
	density = 1
	health = 30
	maxhealth = 30
	metal_cost = 5
	glass_cost = 20
	overlay_icon_state = "powerpylon-overlay"


/obj/structure/divine/powerpylon/New(location, mob/camera/god/G)
	..()
	if(deity && deity.god_nexus)
		deity.god_nexus.powerpylons |= src


/obj/structure/divine/powerpylon/Destroy()
	if(deity && deity.god_nexus)
		deity.god_nexus.powerpylons -= src
	return ..()


/obj/structure/divine/defensepylon
	name = "defense pylon"
	desc = "A pylon which is blessed to withstand many blows, and fire strong bolts at nonbelievers. A god can toggle it."
	icon_state = "defensepylonoffline-frame"
	health = 150
	maxhealth = 150
	metal_cost = 25
	glass_cost = 30
	overlay_icon_state = "defensepylonoffline-overlay"
	var/obj/machinery/gun_turret/defensepylon_internal_turret/pylon_gun


/obj/structure/divine/defensepylon/New(location, mob/camera/god/G)
	..()
	pylon_gun = new()
	pylon_gun.faction = side
	pylon_gun.base = src


/obj/structure/divine/defensepylon/Destroy()
	qdel(pylon_gun) //just in case
	return ..()


/obj/structure/divine/defensepylon/examine(mob/user)
        ..()
        user << "<span class='notice'>\The [src] looks [pylon_gun.on ? "on" : "off"].</span>"

/obj/structure/divine/defensepylon/attack_god(mob/camera/god/user)
	if(user.side == side)
		pylon_gun.on = !pylon_gun.on
		icon_state = (pylon_gun.on) ? "defensepylon-frame" : "defensepylonoffline-frame"
		overlay_icon_state = (pylon_gun.on) ? "defensepylon-overlay" : "defensepylonoffline-overlay"
		update_icons()


//This sits inside the defensepylon, to avoid copypasta
/obj/machinery/gun_turret/defensepylon_internal_turret
	name = "defense pylon"
	desc = "A pylon which is blessed to withstand many blows, and fire strong bolts at nonbelievers."
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "defensepylon"
	health = 200
	base_icon_state = "defensepylon"
	scan_range = 7
	projectile_type = /obj/item/projectile/beam/pylon_bolt
	fire_sound = 'sound/weapons/emitter2.ogg'
	faction = ""
	var/on = 0

/obj/machinery/gun_turret/defensepylon_internal_turret/process()
	if(on)
		..()

/obj/machinery/gun_turret/defensepylon_internal_turret/should_target(atom/target)
	if(ismob(target))
		var/mob/M = target
		if(!M.stat && !(M.status_flags & NEARCRIT) && (!M.mind || is_in_any_team(M.mind) != faction))
			return 1
	else if(istype(target, /obj/mecha))
		var/obj/mecha/M = target
		if(M.occupant && should_target(M.occupant))
			return 1
	return 0

/obj/machinery/gun_turret/defensepylon_internal_turret/fire(atom/target)
	var/obj/item/projectile/beam/pylon_bolt/A = ..()
	if(A)
		A.color = faction
		A.side = faction

/obj/item/projectile/beam/pylon_bolt
	name = "divine bolt"
	icon_state = "darkshard"
	damage = 15
	var/side

/obj/item/projectile/beam/pylon_bolt/New()
	..()
	icon_state = pick("darkshard", "lightshard")

/obj/item/projectile/beam/pylon_bolt/Bump(atom/A, yes)
	if(ismob(A))
		var/mob/B = A
		if(B.mind && (is_in_any_team(B.mind) == side))
			return 0
	if(istype(A, /obj/structure/divine))
		var/obj/structure/divine/D = A
		if(D.side == side)
			return 0
	..()

/obj/structure/divine/shrine
	name = "shrine"
	desc = "A shrine dedicated to a deity."
	icon_state = "shrine-frame"
	metal_cost = 15
	glass_cost = 15
	overlay_icon_state = "shrine-overlay"


/obj/structure/divine/shrine/assign_deity(mob/camera/god/new_deity, alert_old_deity = TRUE)
	if(..())
		name = "shrine to [new_deity.name]"
		desc = "A shrine dedicated to [new_deity.name]"


/obj/structure/divine/translocator
	name = "translocator"
	desc = "A powerful structure, made with a greater gem.  It allows a deity to move their nexus to where this stands"
	icon_state = "translocator-frame"
	health = 100
	maxhealth = 100
	metal_cost = 20
	glass_cost = 20
	greater_gem_cost = 1
	overlay_icon_state = "translocator-overlay"


/obj/structure/divine/lazarusaltar
	name = "lazarus altar"
	desc = "A very powerful altar capable of bringing life back to the recently deceased, made with a greater gem.  It can revive anyone and will heal virtually all wounds, but they are but a shell of their former self."
	icon_state = "lazarus-frame"
	density = 0
	health = 100
	maxhealth = 100
	metal_cost = 20
	greater_gem_cost = 1
	overlay_icon_state = "lazarus-overlay"

/obj/structure/divine/lazarusaltar/New(location, mob/camera/god/G)
	..()
	overlay = new('icons/obj/hand_of_god_structures.dmi', "lazarus-overlay")

/obj/structure/divine/lazarusaltar/attack_hand(mob/living/user)
	var/mob/living/L = locate() in get_turf(src)
	if(!is_in_any_team(user.mind))
		user << "<span class='notice'>You try to use it, but unfortunately you don't know any rituals.</span>"
		return
	if(!L)
		return

	if(is_in_any_team(user.mind) == side)
		user << "<span class='notice'>You attempt to revive [L] by invoking the rebirth ritual.</span>"
		L.revive()
		L.adjustCloneLoss(50)
		L.adjustStaminaLoss(100)
	else
		user << "<span class='notice'>You attempt to revive [L] by invoking the rebirth ritual.</span>"
		user << "<span class='danger'>But the altar ignores your words...</span>"
