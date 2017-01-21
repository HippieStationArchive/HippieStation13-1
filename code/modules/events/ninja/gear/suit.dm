
/*

Contents:
- The Ninja Space Suit
- Ninja Space Suit Procs

*/


//Suit


/obj/item/clothing/suit/space/space_ninja
	name = "ninja suit"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for Spider Clan assassins."
	icon_state = "s-ninja"
	item_state = "s-ninja_suit"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals,/obj/item/weapon/stock_parts/cell)
	slowdown = 0
	unacidable = 1
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	strip_delay = 12

		//Important parts of the suit.
	var/mob/living/carbon/human/affecting = null
	var/obj/item/weapon/stock_parts/cell/cell
	var/datum/effect_system/spark_spread/spark_system
	var/list/reagent_list = list("omnizine","salbutamol","spaceacillin","charcoal","nutriment","radium","potass_iodide")//The reagents ids which are added to the suit at New().
	var/list/stored_research = list()//For stealing station research.
	var/obj/item/weapon/disk/tech_disk/t_disk//To copy design onto disk.
	var/obj/item/weapon/katana/energy/energyKatana //For teleporting the katana back to the ninja (It's an ability)

		//Other articles of ninja gear worn together, used to easily reference them after initializing.
	var/obj/item/clothing/head/helmet/space/space_ninja/n_hood
	var/obj/item/clothing/shoes/space_ninja/n_shoes
	var/obj/item/clothing/gloves/space_ninja/n_gloves

		//Main function variables.
	var/s_initialized = 0//Suit starts off.
	var/s_coold = 0//If the suit is on cooldown. Can be used to attach different cooldowns to abilities. Ticks down every second based on suit ntick().
	var/s_cost = 5//Base energy cost each ntick.
	var/s_acost = 25//Additional cost for additional powers active.
	var/s_delay = 40//How fast the suit does certain things, lower is faster. Can be overridden in specific procs. Also determines adverse probability.
	var/a_transfer = 20//How much reagent is transferred when injecting.
	var/r_maxamount = 80//How much reagent in total there is.

		//Support function variables.
	var/spideros = 0//Mode of SpiderOS. This can change so I won't bother listing the modes here (0 is hub). Check ninja_equipment.dm for how it all works.
	var/s_active = 0//Stealth off.
	var/s_busy = 0//Is the suit busy with a process? Like AI hacking. Used for safety functions.

		//Ability function variables.
	var/s_bombs = 10//Number of starting ninja smoke bombs.
	var/a_boost = 3//Number of adrenaline boosters.


/obj/item/clothing/suit/space/space_ninja/New()
	..()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/init//suit initialize verb

	//Spark Init
	spark_system = new()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	//Research Init
	stored_research = new()
	for(var/T in typesof(/datum/tech) - /datum/tech)//Store up on research.
		stored_research += new T(src)

	//Reagent Init
	var/reagent_amount
	for(var/reagent_id in reagent_list)
		reagent_amount += reagent_id == "radium" ? r_maxamount+(a_boost*a_transfer) : r_maxamount
	reagents = new(reagent_amount)
	reagents.my_atom = src
	for(var/reagent_id in reagent_list)
		reagent_id == "radium" ? reagents.add_reagent(reagent_id, r_maxamount+(a_boost*a_transfer)) : reagents.add_reagent(reagent_id, r_maxamount)//It will take into account radium used for adrenaline boosting.

	//Cell Init
	cell = new/obj/item/weapon/stock_parts/cell/high
	cell.charge = 9000


/obj/item/clothing/suit/space/space_ninja/Destroy()
	if(affecting)
		affecting << browse(null, "window=hack spideros")
	return ..()


//Simply deletes all the attachments and self, killing all related procs.
/obj/item/clothing/suit/space/space_ninja/proc/terminate()
	qdel(n_hood)
	qdel(n_gloves)
	qdel(n_shoes)
	qdel(src)


//Randomizes suit parameters.
/obj/item/clothing/suit/space/space_ninja/proc/randomize_param()
	s_cost = rand(1,20)
	s_acost = rand(20,100)
	s_delay = rand(10,100)
	s_bombs = rand(5,20)
	a_boost = rand(1,7)


//This proc prevents the suit from being taken off.
/obj/item/clothing/suit/space/space_ninja/proc/lock_suit(mob/living/carbon/human/H, checkIcons = 0)
	if(!istype(H))
		return 0
	if(checkIcons)
		icon_state = H.gender==FEMALE ? "s-ninjanf" : "s-ninjan"
		H.gloves.icon_state = "s-ninjan"
		H.gloves.item_state = "s-ninjan"
	else
		if(H.mind.special_role!="Space Ninja")
			H << "\red <B>fÄTaL ÈÈRRoR</B>: 382200-*#00CÖDE <B>RED</B>\nUNAUHORIZED USÈ DETÈCeD\nCoMMÈNCING SUB-R0UIN3 13...\nTÈRMInATING U-U-USÈR..."
			H.gib()
			return 0
		if(!istype(H.head, /obj/item/clothing/head/helmet/space/space_ninja))
			H << "<span class='userdanger'>ERROR</span>: 100113 UNABLE TO LOCATE HEAD GEAR\nABORTING..."
			return 0
		if(!istype(H.shoes, /obj/item/clothing/shoes/space_ninja))
			H << "<span class='userdanger'>ERROR</span>: 122011 UNABLE TO LOCATE FOOT GEAR\nABORTING..."
			return 0
		if(!istype(H.gloves, /obj/item/clothing/gloves/space_ninja))
			H << "<span class='userdanger'>ERROR</span>: 110223 UNABLE TO LOCATE HAND GEAR\nABORTING..."
			return 0

		affecting = H
		flags |= NODROP //colons make me go all |=
		slowdown = 0
		n_hood = H.head
		n_hood.flags |= NODROP
		n_shoes = H.shoes
		n_shoes.flags |= NODROP
		n_shoes.slowdown--
		n_gloves = H.gloves
		n_gloves.flags |= NODROP

	return 1


//This proc allows the suit to be taken off.
/obj/item/clothing/suit/space/space_ninja/proc/unlock_suit()
	affecting = null
	flags &= ~NODROP
	slowdown = 1
	icon_state = "s-ninja"
	if(n_hood)//Should be attached, might not be attached.
		n_hood.flags &= ~NODROP
	if(n_shoes)
		n_shoes.flags &= ~NODROP
		n_shoes.slowdown++
	if(n_gloves)
		n_gloves.icon_state = "s-ninja"
		n_gloves.item_state = "s-ninja"
		n_gloves.flags &= ~NODROP
		n_gloves.candrain=0
		n_gloves.draining=0


/obj/item/clothing/suit/space/space_ninja/examine(mob/user)
	..()
	if(s_initialized)
		if(user == affecting)
			user << "All systems operational. Current energy capacity: <B>[cell.charge]</B>."
			user << "The CLOAK-tech device is <B>[s_active?"active":"inactive"]</B>."
			user << "There are <B>[s_bombs]</B> smoke bomb\s remaining."
			user << "There are <B>[a_boost]</B> adrenaline booster\s remaining."


/*
This section has been moved from suit_attackby.dm
Remove and replace if it causes issues.
-QC
*/
/obj/item/clothing/suit/space/space_ninja/attackby(obj/item/I, mob/U, params)
	if(U==affecting)//Safety, in case you try doing this without wearing the suit/being the person with the suit.

		if(istype(I, /obj/item/weapon/reagent_containers/glass))//If it's a glass beaker.
			var/total_reagent_transfer//Keep track of this stuff.
			for(var/reagent_id in reagent_list)
				var/datum/reagent/R = I.reagents.has_reagent(reagent_id)//Mostly to pull up the name of the reagent after calculating. Also easier to use than writing long proc paths.
				if(R&&reagents.get_reagent_amount(reagent_id)<r_maxamount+(reagent_id == "radium"?(a_boost*a_transfer):0)&&R.volume>=a_transfer)//Radium is always special.
					//Here we determine how much reagent will actually transfer if there is enough to transfer or there is a need of transfer. Minimum of max amount available (using a_transfer) or amount needed.
					var/amount_to_transfer = min( (r_maxamount+(reagent_id == "radium"?(a_boost*a_transfer):0)-reagents.get_reagent_amount(reagent_id)) ,(round(R.volume/a_transfer))*a_transfer)//In the end here, we round the amount available, then multiply it again.
					R.volume -= amount_to_transfer//Remove from reagent volume. Don't want to delete the reagent now since we need to perserve the name.
					reagents.add_reagent(reagent_id, amount_to_transfer)//Add to suit. Reactions are not important.
					total_reagent_transfer += amount_to_transfer//Add to total reagent trans.
					U << "Added [amount_to_transfer] units of [R.name]."//Reports on the specific reagent added.
					I.reagents.update_total()//Now we manually update the total to make sure everything is properly shoved under the rug.

			U << "Replenished a total of [total_reagent_transfer ? total_reagent_transfer : "zero"] chemical units."//Let the player know how much total volume was added.
			return

		else if(istype(I, /obj/item/weapon/stock_parts/cell))
			var/obj/item/weapon/stock_parts/cell/CELL = I
			if(CELL.maxcharge > cell.maxcharge && n_gloves && n_gloves.candrain)
				U << "<span class='notice'>Higher maximum capacity detected.\nUpgrading...</span>"
				if (n_gloves && n_gloves.candrain && do_after(U,s_delay, target = src))
					U.drop_item()
					CELL.loc = src
					CELL.charge = min(CELL.charge+cell.charge, CELL.maxcharge)
					var/obj/item/weapon/stock_parts/cell/old_cell = cell
					old_cell.charge = 0
					U.put_in_hands(old_cell)
					old_cell.add_fingerprint(U)
					old_cell.corrupt()
					old_cell.updateicon()
					cell = CELL
					U << "<span class='notice'>Upgrade complete. Maximum capacity: <b>[round(cell.maxcharge/100)]</b>%</span>"
				else
					U << "<span class='danger'>Procedure interrupted. Protocol terminated.</span>"
			return

		else if(istype(I, /obj/item/weapon/disk/tech_disk))//If it's a data disk, we want to copy the research on to the suit.
			var/obj/item/weapon/disk/tech_disk/TD = I
			if(TD.stored)//If it has something on it.
				U << "Research information detected, processing..."
				if(do_after(U,s_delay, target = src))
					for(var/datum/tech/current_data in stored_research)
						if(current_data.id==TD.stored.id)
							if(current_data.level<TD.stored.level)
								current_data.level=TD.stored.level
							break
					TD.stored = null
					U << "<span class='notice'>Data analyzed and updated. Disk erased.</span>"
				else
					U << "<span class='userdanger'>ERROR</span>: Procedure interrupted. Process terminated."
			else
				I.loc = src
				t_disk = I
				U << "<span class='notice'>You slot \the [I] into \the [src].</span>"
			return
	..()


//Gloves

/obj/item/clothing/gloves/space_ninja
	desc = "These nano-enhanced gloves insulate from electricity and provide fire resistance."
	name = "ninja gloves"
	icon_state = "s-ninja"
	item_state = "s-ninja"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 120
	var/draining = 0
	var/candrain = 0
	var/mindrain = 200
	var/maxdrain = 400


/obj/item/clothing/gloves/space_ninja/Touch(atom/A,proximity)
	if(!candrain || draining)
		return 0
	if(!istype(loc, /mob/living/carbon/human))
		return 0 //Only works while worn

	var/mob/living/carbon/human/H = loc

	var/obj/item/clothing/suit/space/space_ninja/suit = H.wear_suit
	if(!istype(suit))
		return 0
	if(isturf(A))
		return 0

	if(!proximity)
		return 0

	A.add_fingerprint(H)

	draining = 1
	var/drained = A.ninjadrain_act(suit,H,src)
	draining = 0

	if(isnum(drained)) //Numerical values of drained handle their feedback here, Alpha values handle it themselves (Research hacking)
		if(drained)
			H << "<span class='notice'>Gained <B>[drained]</B> energy from \the [A].</span>"
		else
			H << "<span class='danger'>\The [A] has run dry of power, you must find another source!</span>"
	else
		drained = 0 //as to not cancel attack_hand()

	return drained


/obj/item/clothing/gloves/space_ninja/proc/toggled()
	set name = "Toggle Interaction"
	set desc = "Toggles special interaction on or off."
	set category = "Ninja Equip"

	var/mob/living/carbon/human/U = loc
	U << "You <b>[candrain?"disable":"enable"]</b> special interaction."
	candrain=!candrain


/obj/item/clothing/gloves/space_ninja/examine(mob/user)
	..()
	if(flags & NODROP)
		user << "The energy drain mechanism is: <B>[candrain?"active":"inactive"]</B>."


//Head


/obj/item/clothing/head/helmet/space/space_ninja
	desc = "What may appear to be a simple black garment is in fact a highly sophisticated nano-weave helmet. Standard issue ninja gear."
	name = "ninja hood"
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 25)
	strip_delay = 12
	unacidable = 1
	blockTracking = 1


//Mask


/obj/item/clothing/mask/gas/voice/space_ninja
	name = "ninja mask"
	desc = "A close-fitting mask that acts both as an air filter and a post-modern fashion statement."
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	vchange = 1
	strip_delay = 120

/obj/item/clothing/mask/gas/voice/space_ninja/speechModification(message)
	if(voice == "Unknown")
		if(copytext(message, 1, 2) != "*")
			var/list/temp_message = splittext(message, " ")
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++)
				pick_list += i
			for(var/i=1, i <= abs(temp_message.len/3), i++)
				var/H = pick(pick_list)
				if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
				temp_message[H] = ninjaspeak(temp_message[H])
				pick_list -= H
			message = jointext(temp_message, " ")

			//The Alternate speech mod is now the main one.
			message = replacetext(message, "l", "r")
			message = replacetext(message, "rr", "ru")
			message = replacetext(message, "v", "b")
			message = replacetext(message, "f", "hu")
			message = replacetext(message, "'t", "")
			message = replacetext(message, "t ", "to ")
			message = replacetext(message, " I ", " ai ")
			message = replacetext(message, "th", "z")
			message = replacetext(message, "is", "izu")
			message = replacetext(message, "ziz", "zis")
			message = replacetext(message, "se", "su")
			message = replacetext(message, "br", "bur")
			message = replacetext(message, "ry", "ri")
			message = replacetext(message, "you", "yuu")
			message = replacetext(message, "ck", "cku")
			message = replacetext(message, "eu", "uu")
			message = replacetext(message, "ow", "au")
			message = replacetext(message, "are", "aa")
			message = replacetext(message, "ay", "ayu")
			message = replacetext(message, "ea", "ii")
			message = replacetext(message, "ch", "chi")
			message = replacetext(message, "than", "sen")
			message = replacetext(message, ".", "")
			message = lowertext(message)

	return message



/obj/item/clothing/mask/gas/voice/space_ninja/New()
	verbs += /obj/item/clothing/mask/gas/voice/space_ninja/proc/togglev


//This proc is linked to human life.dm. It determines what hud icons to display based on mind special role for most mobs.
/obj/item/clothing/mask/gas/voice/space_ninja/proc/assess_targets(list/target_list, mob/living/carbon/U)
	var/icon/tempHud = 'icons/mob/hud.dmi'
	for(var/mob/living/target in target_list)
		if(iscarbon(target))
			switch(target.mind.special_role)
				if("traitor")
					U.client.images += image(tempHud,target,"hudtraitor")
				if("Revolutionary","Head Revolutionary")
					U.client.images += image(tempHud,target,"hudrevolutionary")
				if("Cultist")
					U.client.images += image(tempHud,target,"hudcultist")
				if("Changeling")
					U.client.images += image(tempHud,target,"hudchangeling")
				if("Wizard","Fake Wizard")
					U.client.images += image(tempHud,target,"hudwizard")
				if("Hunter","Sentinel","Drone","Queen")
					U.client.images += image(tempHud,target,"hudalien")
				if("Syndicate")
					U.client.images += image(tempHud,target,"hudoperative")
				if("Death Commando")
					U.client.images += image(tempHud,target,"huddeathsquad")
				if("Space Ninja")
					U.client.images += image(tempHud,target,"hudninja")
				else//If we don't know what role they have but they have one.
					U.client.images += image(tempHud,target,"hudunknown1")
		else if(issilicon(target))//If the silicon mob has no law datum, no inherent laws, or a law zero, add them to the hud.
			var/mob/living/silicon/silicon_target = target
			if(!silicon_target.laws||(silicon_target.laws&&(silicon_target.laws.zeroth||!silicon_target.laws.inherent.len)))
				if(isrobot(silicon_target))//Different icons for robutts and AI.
					U.client.images += image(tempHud,silicon_target,"hudmalborg")
				else
					U.client.images += image(tempHud,silicon_target,"hudmalai")
	return 1


/obj/item/clothing/mask/gas/voice/space_ninja/proc/togglev()
	set name = "Toggle Voice"
	set desc = "Toggles the voice synthesizer on or off."
	set category = "Ninja Equip"

	var/mob/U = loc//Can't toggle voice when you're not wearing the mask.
	var/vchange = (alert("Would you like to synthesize a new name or turn off the voice synthesizer?",,"New Name","Turn Off"))
	if(vchange == "New Name")
		var/chance = rand(1,100)
		switch(chance)
			if(1 to 50)//High chance of a regular name.
				voice = "[rand(0,1) == 1 ? pick(first_names_female) : pick(first_names_male)] [pick(last_names)]"
			if(51 to 70)//Smaller chance of a lizard name.
				voice = "[pick(lizard_name(MALE),lizard_name(FEMALE))]"
			if(71 to 80)//Small chance of a clown name.
				voice = "[pick(clown_names)]"
			if(81 to 90)//Small chance of a wizard name.
				voice = "[pick(wizard_first)] [pick(wizard_second)]"
			if(91 to 100)//Small chance of an existing crew name.
				var/list/names = list()
				for(var/mob/living/carbon/human/M in player_list)
					if(M == U || !M.client || !M.real_name)
						continue
					names.Add(M.real_name)
				voice = !names.len ? "Cuban Pete" : pick(names)
		U << "You are now mimicking <B>[voice]</B>."
	else
		U << "The voice synthesizer is [voice!="Unknown"?"now":"already"] deactivated."
		voice = "Unknown"
	return


/obj/item/clothing/mask/gas/voice/space_ninja/examine(mob/user)
	..()
	user << "Voice mimicking algorithm is set <B>[!vchange?"inactive":"active"]</B>."


//Shoes


/obj/item/clothing/shoes/space_ninja
	name = "ninja shoes"
	desc = "A pair of running shoes. Excellent for running and even better for smashing skulls."
	icon_state = "s-ninja"
	item_state = "secshoes"
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	strip_delay = 120
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT


//Katana
//Moving this here since it's technically part of the suit, and will save space -QC
/obj/item/weapon/katana/energy
	name = "energy katana"
	desc = "A katana infused with strong energy."
	icon_state = "energy_katana"
	item_state = "energy_katana"
	force = 40
	throwforce = 20
	armour_penetration = 15
	var/datum/effect_system/spark_spread/spark_system

/obj/item/weapon/katana/energy/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!user || !target)
		return

	if(proximity_flag)
		if(isobj(target) || issilicon(target))
			spark_system.start()
			playsound(user, "sparks", 50, 1)
			playsound(user, 'sound/weapons/blade1.ogg', 50, 1)
			target.emag_act(user)


//If we hit the Ninja who owns this Katana, they catch it.
//Works for if the Ninja throws it or it throws itself or someone tries
//To throw it at the ninja
/obj/item/weapon/katana/energy/throw_impact(atom/hit_atom)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H.wear_suit, /obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/SN = H.wear_suit
			if(SN.energyKatana == src)
				returnToOwner(H, 0, 1)
				return

	..()

/obj/item/weapon/katana/energy/proc/returnToOwner(mob/living/carbon/human/user, doSpark = 1, caught = 0)
	if(!istype(user))
		return
	loc = get_turf(src)

	if(doSpark)
		spark_system.start()
		playsound(get_turf(src), "sparks", 50, 1)

	var/msg = ""

	if(user.put_in_hands(src))
		msg = "Your Energy Katana teleports into your hand!"
	else if(user.equip_to_slot_if_possible(src, slot_belt, 0, 1, 1))
		msg = "Your Energy Katana teleports back to you, sheathing itself as it does so!</span>"
	else
		loc = get_turf(user)
		msg = "Your Energy Katana teleports to your location!"

	if(caught)
		if(loc == user)
			msg = "You catch your Energy Katana!"
		else
			msg = "Your Energy Katana lands at your feet!"

	if(msg)
		user << "<span class='notice'>[msg]</span>"

/obj/item/weapon/katana/energy/New()
	..()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)


/obj/item/weapon/katana/energy/Del()
	qdel(spark_system)
	spark_system = null
	..()

/obj/item/weapon/katana/energy/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()
