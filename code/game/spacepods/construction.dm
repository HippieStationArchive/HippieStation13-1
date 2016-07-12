/obj/structure/spacepod_frame
	density = 1
	opacity = 0
	bound_width = 64
	bound_height = 64
	anchored = 1
	layer = 3.9
	name = "space pod frame"
	icon = 'icons/48x48/pod_construction.dmi'
	icon_state = "pod_1"

	var/datum/construction/construct

/obj/structure/spacepod_frame/New()
	..()

	construct = new /datum/construction/reversible/pod(src)

	dir = EAST

/obj/structure/spacepod_frame/attackby(obj/item/W as obj, mob/user as mob)
	if(!construct || !construct.action(W, user))
		return ..()
	return 1

/obj/structure/spacepod_frame/attack_hand()
	return

/datum/construction/reversible/pod/spawn_result(mob/user as mob)
	..()
	feedback_inc("spacepod_created",1)
	return

/datum/construction/reversible/pod/action(atom/used_atom,mob/user)
	return check_step(used_atom,user)

/datum/construction/reversible/pod/custom_action(index as num, diff as num, atom/used_atom, mob/user)
	if(istype(used_atom, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/W = used_atom
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(istype(used_atom, /obj/item/weapon/wrench))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/screwdriver))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/wirecutters))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = used_atom
		if (C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			user << ("<span class='warning'>There's not enough cable to finish the task!</span>")
			return 0
	else if(istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if(S.amount < 5)
			user << ("<span class='warning'>There's not enough material in this stack!</span>")
			return 0
		else
			S.use(5)
	return 1

/datum/construction/pod/action(atom/used_atom,mob/user)
	return check_all_steps(used_atom,user)

/datum/construction/pod/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/ripley(const_holder)
	const_holder.icon = 'icons/48x48/pod_construction.dmi'
	const_holder.icon_state = "pod1"
	const_holder.density = 1
	const_holder.overlays.len = 0
	qdel(src)
	return


/datum/construction/reversible/pod
	result = "/obj/spacepod/civilian"
	steps = list(	//1
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The armor is secured."),
					 //2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="The armor is installed."),
					 //3
					 list("key"=/obj/item/pod_parts/armor,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="The bulkhead is sealed."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The bulkhead is secured."),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="The bulkhead is installed"),
					 //6
					 list("key"=/obj/item/stack/sheet/metal,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The core is secured."),
					 //7
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="The core is installed but loose."),
					 //8
					 list("key"=/obj/item/pod_parts/core,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The main board is secured"),
					 //9
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="The main board is installed."),
					 //10
					 list("key"=/obj/item/weapon/circuitboard/mecha/pod,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wires are secred."),
					 //11
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wirecutters,
					 		"desc"="The wires are strewn about."),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"desc"="An empty pod frame.")
					)

/datum/construction/reversible/pod/action(atom/used_atom,mob/user)
	return check_step(used_atom,user)

/datum/construction/reversible/pod/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(12)
			user.visible_message("[user] adds wires to [holder].", "<span class='notice'>You add wires to the [holder].</span>")
			holder.icon_state = "pod_2"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures [holder] wiring.", "<span class='notice'>You secure [holder] wiring.</span>")
				holder.icon_state = "pod_3"
			else
				user.visible_message("[user] cuts out [holder] wiring", "<span class='notice'>You cut out [holder] wiring.</span>")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(user))
				coil.amount = 4
				holder.icon_state = "pod_1"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] adds the main board to [holder].", "<span class='notice'>You add the main board to [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "pod_4"
			else
				user.visible_message("[user] unsecures [holder]'s wiring", "<span class='notice'>You unsecure [holder]'s wiring</span>")
				holder.icon_state = "pod_2"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the main board of [holder].", "<span class='notice'>You secure the main board of [holder].</span>")
				holder.icon_state = "pod_5"
			else
				user.visible_message("[user] pries out the main board from [holder].", "<span class='notice'>You pry out the main board from [holder].</span>")
				new /obj/item/weapon/circuitboard/mecha/pod(get_turf(user))
				holder.icon_state = "pod_3"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the pod core into [holder].", "<span class='notice'>You install the pod core into [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "pod_6"
			else
				user.visible_message("[user] unsecures the main board of [holder].", "<span class='notice'>You unsecure the main board of [holder].</span>")
				holder.icon_state = "pod_4"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the pod core of [holder].", "<span class='notice'>You secure the pod core [holder].</span>")
				holder.icon_state = "pod_7"
			else
				user.visible_message("[user] removes the pod core from the [holder].", "<span class='notice'>You remove the pod core from [holder].</span>")
				holder.icon_state = "pod_5"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] adds a bulkhead to [holder].", "<span class='notice'>You add a bulkhead to [holder].</span>")
				holder.icon_state = "pod_8"
			else
				user.visible_message("[user] unsecures the pod core.", "<span class='notice'>You unsecure the pod core.</span>")
				holder.icon_state = "pod_6"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures the bulkhead.", "<span class='notice'>You secure the bulkhead.</span>")
				holder.icon_state = "pod_9"
			else
				user.visible_message("[user] removes the bulkhead from [holder].", "<span class='notice'>You remove the bulkhead from [holder].</span>")
				var/obj/item/stack/sheet/metal/MS = new /obj/item/stack/sheet/metal(get_turf(user))
				MS.amount = 5
				holder.icon_state = "pod_7"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] seals the bulkhead of [holder].", "<span class='notice'>You seal the bulkhead of [holder].</span>")
				holder.icon_state = "pod_10"
			else
				user.visible_message("[user] unsecures the bulkhead.", "<span class='notice'>You unsecure the bulkhead.</span>")
				holder.icon_state = "pod_8"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs the pod armor.", "<span class='notice'>You install the pod armor.</span>")
				qdel(used_atom)
				holder.icon_state = "pod_11"
			else
				user.visible_message("[user] breaks the seal on [holder]'s bulkhead.", "<span class='notice'>You break the seal on [holder]'s bulk head.</span>")
				holder.icon_state = "pod_9"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures the pod armor onto [holder].", "<span class='notice'>You secure the pod armor onto [holder].</span>")
				holder.icon_state = "pod_12"
			else
				user.visible_message("[user] pries the pod armor off of [holder].", "<span class='notice'>You pry the pod armor of of [holder].</span>")
				holder.icon_state = "pod_10"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds the pod armor onto [holder].", "<span class='notice'>You weld the pod armor onto [holder].</span>")
			else
				user.visible_message("[user] unsecures the pod armor.", "<span class='notice'>You unsecures the pod armor.</span>")
	return 1