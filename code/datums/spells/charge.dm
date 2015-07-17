/obj/effect/proc_holder/spell/targeted/charge
	name = "Charge"
	desc = "This spell can be used to charge up spent magical artifacts, among other things."

	school = "transmutation"
	charge_max = 600
	clothes_req = 0
	invocation = "DIRI CEL"
	invocation_type = "whisper"
	range = -1
	cooldown_min = 400 //50 deciseconds reduction per rank
	include_user = 1


/obj/effect/proc_holder/spell/targeted/charge/cast(list/targets)
	for(var/mob/living/user in targets)
		var/list/hand_items = list(user.get_active_hand(),user.get_inactive_hand())
		var/charged_item = null
		var/burnt_out = 0
		for(var/obj/item in hand_items)
			if(istype(item, /obj/item/weapon/grab))
				var/obj/item/weapon/grab/G = item
				if(G.affecting)
					var/mob/M = G.affecting
					if(M.mob_spell_list.len != 0 || (M.mind && M.mind.spell_list.len != 0))
						for(var/obj/effect/proc_holder/spell/S in M.mob_spell_list)
							S.charge_counter = S.charge_max
						if(M.mind)
							for(var/obj/effect/proc_holder/spell/S in M.mind.spell_list)
								S.charge_counter = S.charge_max
						M <<"<span class='notice'>you feel raw magic flowing through you, it feels good!</span>"
					else
						M <<"<span class='notice'>you feel very strange for a moment, but then it passes.</span>"
						burnt_out = 1
					charged_item = M
					break
			else if(istype(item, /obj/item/weapon/spellbook/oneuse))
				var/obj/item/weapon/spellbook/oneuse/I = item
				if(prob(80))
					user.visible_message("<span class='warning'>[I] catches fire!</span>")
					qdel(I)
				else
					I.used = 0
					charged_item = I
					break
			else if(istype(item, /obj/item/weapon/gun/magic))
				var/obj/item/weapon/gun/magic/I = item
				if(prob(80) && !I.can_charge)
					I.max_charges--
				if(I.max_charges <= 0)
					I.max_charges = 0
					burnt_out = 1
				I.charges = I.max_charges
				if(istype(item,/obj/item/weapon/gun/magic/wand) && I.max_charges != 0)
					var/obj/item/weapon/gun/magic/W = item
					W.icon_state = initial(W.icon_state)
				charged_item = I
				break
			else if(istype(item, /obj/item/weapon/stock_parts/cell/))
				var/obj/item/weapon/stock_parts/cell/C = item
				if(prob(80))
					C.maxcharge -= 200
				if(C.maxcharge <= 1) //Div by 0 protection
					C.maxcharge = 1
					burnt_out = 1
				C.charge = C.maxcharge
				charged_item = C
				break
			else if(item.contents)
				var/obj/I = null
				for(I in item.contents)
					if(istype(I, /obj/item/weapon/stock_parts/cell/))
						var/obj/item/weapon/stock_parts/cell/C = I
						if(prob(80))
							C.maxcharge -= 200
						if(C.maxcharge <= 1) //Div by 0 protection
							C.maxcharge = 1
							burnt_out = 1
						C.charge = C.maxcharge
						item.update_icon()
						charged_item = item
						break
		if(!charged_item)
			user << "<span class='notice'>you feel magical power surging to your hands, but the feeling rapidly fades...</span>"
		else if(burnt_out)
			user << "<span class='caution'>[charged_item] doesn't seem to be reacting to the spell...</span>"
		else
			user << "<span class='notice'>[charged_item] suddenly feels very warm!</span>"





//doesn't need another file


/obj/effect/proc_holder/spell/targeted/lightning
	name = "Lightning Bolt"
	desc = "Throws a lightning bolt at the nearby enemy. Classic."
	charge_type = "recharge"
	charge_max	= 300
	clothes_req = 1
	invocation = "UN'LTD P'WAH!"
	invocation_type = "shout"
	range = 7
	cooldown_min = 30
	selection_type = "view"
	random_target = 1
	var/energy = 0
	var/ready = 0

/obj/effect/bolt
	name = "Lightning bolt"
	icon = 'icons/effects/effects.dmi'
	icon_state = "lightning"
	luminosity = 3

/obj/effect/proc_holder/spell/targeted/lightning/Click()
	if(!ready)
		if(cast_check())
			StartChargeup()
	else
		if(cast_check(skipcharge=1))
			choose_targets()
	return 1

/obj/effect/proc_holder/spell/targeted/lightning/proc/StartChargeup(mob/user = usr)
	ready = 1
	user << "<span class='notice'>You start gathering the power.</span>"
	//TODO: Add visual indictaor of charging
	spawn(0)
		while(ready)
			sleep(1)
			energy++
			if(energy >= 100 && ready)
				Discharge()

/obj/effect/proc_holder/spell/targeted/lightning/proc/Discharge(mob/user = usr)
	var/mob/living/M = user
	M.electrocute_act(25,"Lightning Bolt")
	M << "<span class='danger'>You lose control over the spell.</span>"
	energy = 0
	ready = 0
	start_recharge()


/obj/effect/proc_holder/spell/targeted/lightning/cast(list/targets, mob/user = usr)
	if(!targets.len)
		user << "<span class='notice'>No target found in range.</span>"
		return

	var/mob/living/carbon/target = targets[1]

	if(!(target in oview(range)))
		user << "<span class='notice'>They are too far away!</span>"
		return

	user.Beam(target,icon_state="lightning",icon='icons/effects/effects.dmi',time=5)

	switch(energy)
		if(0 to 25)
			target.electrocute_act(10,"Lightning Bolt")
		if(25 to 75)
			target.electrocute_act(25,"Lightning Bolt")
		if(75 to 100)
			//CHAIN LIGHTNING
			Bolt(user,target,energy,user)
	ready = 0
	energy = 0

/obj/effect/proc_holder/spell/targeted/lightning/proc/Bolt(mob/origin,mob/target,bolt_energy,mob/user = usr)
	origin.Beam(target,icon_state="lightning",icon='icons/effects/effects.dmi',time=5)
	var/mob/living/carbon/current = target
	if(bolt_energy < 75)
		current.electrocute_act(25,"Lightning Bolt")
	else
		current.electrocute_act(25,"Lightning Bolt")
		var/list/possible_targets = new
		for(var/mob/living/M in view_or_range(range,target,"view"))
			if(user == M || target == M) // || origin == M ? Not sure double shockings is good or not
				continue
			possible_targets += M
		var/mob/living/next = pick(possible_targets)
		if(next)
			Bolt(current,next,bolt_energy-6,user) // 5 max bounces