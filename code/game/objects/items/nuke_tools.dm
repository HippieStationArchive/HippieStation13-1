//Items for nuke theft traitor objective

//the nuke core - objective item
/obj/item/nuke_core
	name = "plutonium core"
	desc = "Extremely radioactive. Wear goggles."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "plutonium_core"
	item_state = "plutoniumcore"
	var/pulse = 0
	var/cooldown = 0

/obj/item/nuke_core/New()
	SSobj.processing += src

/obj/item/nuke_core/attackby(obj/item/nuke_core_container/container, mob/user)
	if(istype(container))
		container.load(src, user)
	else
		..()

/obj/item/nuke_core/process()
	if(cooldown < world.time - 60)
		cooldown = world.time
		flick("plutonium_core_pulse", src)
		radiation_pulse(get_turf(src), 1, 4, 40, 1)

//nuke core box, for carrying the core
/obj/item/nuke_core_container
	name = "nuke core container"
	desc = "Solid container for radioactive objects."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "core_container_empty"
	item_state = "tile"
	var/obj/item/nuke_core/core = null

/obj/item/nuke_core_container/proc/load(obj/item/nuke_core/ncore, mob/user)
	if(core || !istype(ncore))
		return 0
	ncore.loc = src
	core = ncore
	icon_state = "core_container_loaded"
	user << "<span class='warning'>Container is sealing...</span>"
	spawn(50)
		SSobj.processing -= core
		icon_state = "core_container_sealed"
		playsound(loc, 'sound/items/Deconstruct.ogg', 100, 1)
		if(loc == user)
			user << "<span class='warning'>Container is sealed, the radiation is contained.</span>"
	return 1

/obj/item/nuke_core_container/attackby(obj/item/nuke_core/core, mob/user)
	if(istype(core))
		if(!user.unEquip(core))
			user << "<span class='warning'>The [core] is stuck to your hand!</span>"
			return
		else
			load(core, user)
	else
		..()

//snowflake screwdriver, works as a key to start nuke theft, traitor only
/obj/item/weapon/screwdriver/nuke
	name = "screwdriver"
	desc = "A screwdriver with an ultra thin tip."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "screwdriver_nuke"
	item_state = "screwdriver_nuke"
	toolspeed = 2

/obj/item/weapon/screwdriver/nuke/New()
//to skip screwdriver icon update

/obj/item/weapon/paper/nuke_instructions
	info = "How to break into a Nanotrasen self-destruct terminal and remove its plutonium core:<br>\
	<ul>\
	<li>Use a screwdriver with a very thin tip (provided) to unscrew the terminal's front panel</li>\
	<li>Dislodge and remove the front panel with a crowbar</li>\
	<li>Cut the inner metal plate with a welding tool</li>\
	<li>Pry off the inner plate with a crowbar to expose the radioactive core</li>\
	<li>Use the core container to remove the plutonium core; the container will take some time to seal</li>\
	<li>???</li>"
