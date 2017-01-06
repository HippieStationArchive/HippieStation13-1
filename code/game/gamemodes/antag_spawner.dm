/obj/item/weapon/antag_spawner
	throw_speed = 1
	throw_range = 5
	w_class = 1
	var/used = 0

/obj/item/weapon/antag_spawner/proc/spawn_antag(client/C, turf/T, type = "")
	return

/obj/item/weapon/antag_spawner/proc/equip_antag(mob/target)
	return

/obj/item/weapon/antag_spawner/contract
	name = "contract"
	desc = "A magic contract previously signed by an apprentice. In exchange for instruction in the magical arts, they are bound to answer your call for aid."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"

/obj/item/weapon/antag_spawner/contract/attack_self(mob/user)
	user.set_machine(src)
	var/dat
	if(used)
		dat = "<B>You have already summoned your apprentice.</B><BR>"
	else
		dat = "<B>Contract of Apprenticeship:</B><BR>"
		dat += "<I>Using this contract, you may summon an apprentice to aid you on your mission.</I><BR>"
		dat += "<I>If you are unable to establish contact with your apprentice, you can feed the contract back to the spellbook to refund your points.</I><BR>"
		dat += "<B>Your apprentice will get his own spellbook with 5 spell points, however it may not be spent on rituals or artifacts.</B><BR>"
		dat += "<A href='byond://?src=\ref[src];school=proceed'>Proceed</A><BR>"
		dat += "<I>Note that the acceptance of an apprentice is final and the Wizard Academy is not responsible for your loss at life at the hands of an apprentince.</I><BR>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/weapon/antag_spawner/contract/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return
	if(!istype(H, /mob/living/carbon/human))
		return 1

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["school"])
			if (used)
				H << "You already used this contract!"
				return
			var/list/candidates = get_candidates(ROLE_WIZARD)
			if(candidates.len)
				src.used = 1
				var/client/C = pick(candidates)
				spawn_antag(C, get_turf(H.loc), href_list["school"])
				if(H.mind)
					ticker.mode.update_wiz_icons_added(H.mind)
			else
				H << "Unable to reach your apprentice! You can either attack the spellbook with the contract to refund your points, or wait and try again later."

/obj/item/weapon/antag_spawner/contract/spawn_antag(client/C, turf/T, type = "")
	PoolOrNew(/obj/effect/particle_effect/smoke, T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M)
	M.key = C.key
	M << "<B>You are the [usr.real_name]'s apprentice! You are bound by magic contract to follow their orders and help them in accomplishing their goals."
	M << "<B>Your service has not gone unrewarded, however. Studying under [usr.real_name], you have learned powerful, spells. Select them in your spellbook."
	var/obj/item/weapon/spellbook/apprenticebook = new /obj/item/weapon/spellbook(M)
	M.equip_to_slot_or_del(apprenticebook, slot_r_hand)
	apprenticebook.owner_is_apprentice = 1
	apprenticebook.uses = 5

	equip_antag(M)
	var/wizard_name_first = pick(wizard_first)
	var/wizard_name_second = pick(wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	var/newname = copytext(sanitize(input(M, "You are the wizard's apprentice. Would you like to change your name to something else?", "Name change", randomname) as null|text),1,MAX_NAME_LEN)
	if (!newname)
		newname = randomname
	M.mind.name = newname
	M.real_name = newname
	M.name = newname
	M.dna.update_dna_identity()
	var/datum/objective/protect/new_objective = new /datum/objective/protect
	new_objective.owner = M:mind
	new_objective:target = usr:mind
	new_objective.explanation_text = "Protect [usr.real_name], the wizard."
	M.mind.objectives += new_objective
	ticker.mode.traitors += M.mind
	M.mind.special_role = "apprentice"
	ticker.mode.update_wiz_icons_added(M.mind)
	M << sound('sound/effects/magic.ogg')

/obj/item/weapon/antag_spawner/contract/equip_antag(mob/target)
	target.equip_to_slot_or_del(new /obj/item/device/radio/headset(target), slot_ears)
	target.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(target), slot_w_uniform)
	target.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(target), slot_shoes)
	target.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(target), slot_wear_suit)
	target.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(target), slot_head)
	target.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(target), slot_back)
	target.equip_to_slot_or_del(new /obj/item/weapon/storage/box(target), slot_in_backpack)
	target.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll/apprentice(target), slot_r_store)



///////////BORGS AND OPERATIVES


/obj/item/weapon/antag_spawner/nuke_ops
	name = "syndicate operative teleporter"
	desc = "A single-use teleporter designed to quickly reinforce operatives in the field."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/TC_cost = 0
	var/reinforcement_to_spawn
	var/list/possible_types = list("Assault", "Hacker", "Infiltrator" ,"Medical")


/obj/item/weapon/antag_spawner/nuke_ops/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
	if(!(user.mind in ticker.mode.syndicates))
		user << "<span class='danger'>AUTHENTICATION FAILURE. ACCESS DENIED.</span>"
		return 0
	if(user.z != ZLEVEL_CENTCOM)
		user << "<span class='warning'>[src] is out of range! It can only be used at your base!</span>"
		return 0
	return 1


/obj/item/weapon/antag_spawner/nuke_ops/attack_self(mob/user)

	if(!(check_usability(user)))
		return

	reinforcement_to_spawn = input("What type?", "Reinforcement Type", type) as null|anything in possible_types

	if(!reinforcement_to_spawn)
		return

	var/list/nuke_candidates = get_candidates(ROLE_OPERATIVE, 3000, "operative")
	if(nuke_candidates.len > 0)
		// Check again to make sure!
		if(!(check_usability(user)))
			return

		used = 1
		var/client/C = pick(nuke_candidates)
		spawn_antag(C, get_turf(src.loc), "syndieborg")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(4, 1, src)
		s.start()
	else
		user << "<span class='warning'>Unable to connect to Syndicate command. Please wait and try again later or use the teleporter on your uplink to get your points refunded.</span>"

/obj/item/weapon/antag_spawner/nuke_ops/spawn_antag(client/C, turf/T)
	var/nuke_code = "Ask your leader!"
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M)
	M.key = C.key
	var/obj/machinery/nuclearbomb/nuke = locate("syndienuke") in nuke_list
	if(nuke)
		nuke.r_code = nuke_code
	M.mind.make_Nuke(T, nuke_code, 0, FALSE, reinforcement_to_spawn)

//////SYNDICATE BORG

/obj/item/weapon/antag_spawner/nuke_ops/borg_tele
	name = "syndicate cyborg teleporter"
	desc = "A single-use teleporter designed to quickly reinforce operatives in the field.."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	possible_types = list("Assault", "Medical")

/obj/item/weapon/antag_spawner/nuke_ops/borg_tele/spawn_antag(client/C, turf/T)
	var/mob/living/silicon/robot/R
	switch(reinforcement_to_spawn)
		if("Medical")
			R = new /mob/living/silicon/robot/syndicate/medical(T)
		else
			R = new /mob/living/silicon/robot/syndicate(T) //Assault borg by default
	R.key = C.key
	ticker.mode.syndicates += R.mind
	ticker.mode.update_synd_icons_added(R.mind)
	R.mind.special_role = "syndicate"
	R.faction = list("syndicate")






///////////SLAUGHTER DEMON
/obj/item/weapon/antag_spawner/slaughter_demon
	name = "bottle of blood"
	desc = "A bottle of magically infused blood, the smell of which will attract extradimensional beings when broken."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"

/obj/item/weapon/antag_spawner/slaughter_demon/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>Somehow the bottle has already been emptied!</span>" // shouldn't happen as it destroys itself upon succesful summoning
		return 0
	if(user.z == ZLEVEL_CENTCOM)
		user << "<span class='warning'>There are no demons within this realm. Try using the [src] onboard the station.<span>"
		return 0
	return 1

/obj/item/weapon/antag_spawner/slaughter_demon/attack_self(mob/user)
	if(!(check_usability(user)))
		return

	var/list/wizard_candidates = get_candidates(ROLE_WIZARD, 3000, "slaughter demon") // best pref for slaughter demon, as it isn't a pref on it's own.
	if(wizard_candidates.len > 0)
		used = 1
		var/client/C = pick(wizard_candidates)
		spawn_antag(C, get_turf(src), "Slaughter Demon")
		playsound(loc, 'sound/effects/Glassbr2.ogg', 25, 1)
		user << "<font size=3><span class='danger'><b>The bottle sizzles and shatters as the contents splatter over the floor, only to burn away moments later. You feel a sense of dread wash over you as the contents dissapear without trace.</font></span>"
		qdel(src)
	else
		user << "<span class='warning'>No demons were attracted to the blood. You can either wait, or refund the bottle by using it on your book.</span>"

/obj/item/weapon/antag_spawner/slaughter_demon/spawn_antag(client/C, turf/T, type = "")

	var /obj/effect/dummy/slaughter/holder = PoolOrNew(/obj/effect/dummy/slaughter,T)
	var/mob/living/simple_animal/slaughter/S = new /mob/living/simple_animal/slaughter/(holder)
	S.holder = holder
	S.key = C.key
	S.mind.assigned_role = "Slaughter Demon"
	S.mind.special_role = "Slaughter Demon"
	ticker.mode.traitors += S.mind
	var/datum/objective/assassinate/new_objective = new /datum/objective/assassinate
	new_objective.owner = S.mind
	new_objective.target = usr.mind
	new_objective.explanation_text = "Kill [usr.real_name], the one who summoned you."
	S.mind.objectives += new_objective
	var/datum/objective/new_objective2 = new /datum/objective
	new_objective2.owner = S.mind
	new_objective2.explanation_text = "Kill everyone else while you're at it."
	S.mind.objectives += new_objective2
	S << S.playstyle_string
	S << "<B>You are currently not currently in the same plane of existence as the station. Ctrl+Click a blood pool to manifest.</B>"
	S << "<B>Objective #[1]</B>: [new_objective.explanation_text]"
	S << "<B>Objective #[2]</B>: [new_objective2.explanation_text]"

/obj/item/weapon/antag_spawner/vampire //Even edgier than the vial of blood
	name = "filled glass goblet"
	desc = "It's topped off with what seems to be blood. If one listens closely, they can hear a faint singing..."
	icon = 'icons/obj/vampire/vampire.dmi'
	icon_state = "glass_goblet_filled"
	w_class = 2
/obj/item/weapon/antag_spawner/vampire/examine(mob/user)
	..()
	if(is_vampire(user) && used)
		user << "<span class='warning'>If you are powerful enough, you may activate the goblet in your hand to refill it and create more vampires.</span>"
/obj/item/weapon/antag_spawner/vampire/attack_self(mob/living/carbon/human/user)
	if(!user.mind)
		return 0
	if(!istype(user))
		return 0
	if(is_vampire(user))
		if(!used)
			user << "<span class='warning'>[src] is already full.</span>"
			return
		var/datum/vampire/V = user.get_vampire()
		if(!V)
			return 0
		if(V.sucked_blood < 500) //They need quite a bit of blood
			user << "<span class='warning'>You are not powerful enough to fill the goblet.</span>"
			return 0
		else
			var/mob/living/carbon/human/H = user
			if(V.clean_blood < 50) //50 blood to fill the goblet
				user << "<span class='warning'>You do not possess enough clean blood to fill the goblet.</span>"
				return 0
			user.visible_message("<span class='warning'>[user] cuts their finger on the lip of [src] and begins dripping blood into it...</span>", "<span class='userdanger'>You begin preparing the goblet for conversion of fledgling vampires.</span>")
			H.apply_damage(5, BRUTE, pick("l_arm", "r_arm"))
			if(!do_after(user, 100, target = user))
				return 0
			user.visible_message("<span class='warning'>[user] fills [src] with their own blood!</span>", "<span class='userdanger'>You fill the goblet. You may now create an additional vampire.</span>")
			used = 0
			name = initial(name)
			desc = initial(desc)
			icon_state = initial(icon_state)
		return 1
	if(used)
		user << "<span class='notice'>The goblet is empty.</span>"
		return 0
	if(iscultist(user))
		user << "<span class='warning'>Nar-Sie does not interfere with the business of Lilith. No good can from this.</span>"
		return 0
	if(user.mind.assigned_role == "Chaplain")
		user.visible_message("<span class='warning'>[user] spills the contents of [src] onto the ground!</span>", \
							 "<span class='warning'>The disgusting blood in the goblet reeks of the unholy. You spill it onto the ground.</span>")
		used = 1
		name = "glass goblet"
		desc = "It's an empty glass goblet. It sparkles with a bright sheen."
		icon_state = "glass_goblet"
		return 0
	if(user.mind.changeling)
		user << "<span class='warning'>The demon whose blood fills this goblet refuses to bless our form.</span>"
		return 0
	if(isloyal(user))
		user << "<span class='warning'>Something about the goblet fills you with dread. You can't bring yourself to drink it.</span>"
		return 0
	user.visible_message("<span class='warning'>[user] slowly raises [src] to their lips with a trembling hand...</span>", \
						 "<span class='userdanger'>You slowly lift the goblet to your lips, the haunting song resonating in your ears...</span>")
	if(!do_after(user, 50, target = user))
		return 0
	if(used)
		return 0
	playsound(user, 'sound/items/drink.ogg', 10, 1)
	user.visible_message("<span class='warning'>[user] tips [src] up, spilling the contents into their mouth.</span>", \
						 "<span class='userdanger'>Something strange and terrifying enters your mind as you drink from the goblet...</span>")
	used = 1
	name = "glass goblet"
	desc = "It's an empty glass goblet. It has faint red stains at the bottom."
	icon_state = "glass_goblet"
	spawn(30)
		if(user)
			message_admins("[key_name_admin(user)] has been made a vampire by the glass goblet.")
			log_game("[key_name_admin(user)] has been made a vampire by the glass goblet.")
			user.make_mob_into_vampire()
/obj/item/weapon/antag_spawner/vampire/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(M == user)
		return attack_self(user)
	if(!is_vampire(user) || used)
		return ..()
	if(is_vampire(M))
		user << "<span class='warning'>[M] has already received Lilith's blessing!</span>"
		return 0
	var/datum/reagent/blood = M.get_blood(M.vessel)
	if(blood.volume > BLOOD_VOLUME_OKAY + 50) //Around the same drained by bloodsucking
		user << "<span class='warning'>[M] requires less blood in their body so that they may hunger for it!</span>"
		return 0
	if(iscultist(M))
		user << "<span class='warning'>[M] has already made a pact with another demon!</span>"
		return 0
	if(M.mind.changeling)
		user << "<span class='warning'>Lilith refuses to grant her blessing upon a changeling!</span>"
		return 0
	if(isloyal(M))
		user << "<span class='warning'>[M]'s mind is chained by corporate bonds!</span>"
		return 0
	if(M.mind && M.mind.assigned_role == "Chaplain")
		user << "<span class='warning'>[M]'s heretical aura wards away Lilith's blessing!</span>"
		return 0
	if(!M.mind || !M.client)
		user << "<span class='warning'>[M] must not be braindead or catatonic!</span>"
		return 0
	M.visible_message("<span class='warning'>[user] brings [src] to [M]'s lips and begins tipping it back!</span>", \
					  "<span class='userdanger'>A haunting song fills your ears as [user] begins forcing you to drink from [src]!</span>")
	if(!do_after(user, 100, target = M))
		return 0
	playsound(user, 'sound/items/drink.ogg', 10, 1)
	M.visible_message("<span class='warning'>[user] feeds [M] the contents of [src]!</span>", \
					  "<span class='userdanger'>Something strange and terrifying enters your mind as you drink from the goblet...</span>")
	used = 1
	name = "glass goblet"
	desc = "It's an empty glass goblet. It has faint red stains at the bottom."
	icon_state = "glass_goblet"
	spawn(30)
		if(M)
			M.make_mob_into_vampire()
/obj/item/weapon/antag_spawner/vampire/attack_hand(mob/user)
	if(ishuman(user) && user.mind && user.mind.assigned_role != "Chaplain" && !is_vampire(user) && !used)
		user << "<span class='warning'>The gentle harmony emanating from [src] grows louder for just a moment...</span>"
	..()
