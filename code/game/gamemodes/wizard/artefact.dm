
//Apprenticeship contract - moved to antag_spawner.dm

///////////////////////////Veil Render//////////////////////

/obj/item/weapon/veilrender
	name = "veil render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast city."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "render"
	force = 15
	throwforce = 10
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/charges = 1
	var/spawn_type = /obj/singularity/narsie/wizard
	var/spawn_amt = 1
	var/activate_descriptor = "reality"
	var/rend_desc = "You should run now."
	var/spawn_fast = 0 //if 1, ignores checking for mobs on loc before spawning

/obj/item/weapon/veilrender/attack_self(mob/user)
	if(charges > 0)
		new /obj/effect/rend(get_turf(user), spawn_type, spawn_amt, rend_desc, spawn_fast)
		charges--
		user.visible_message("<span class='boldannounce'>[src] hums with power as [user] deals a blow to [activate_descriptor] itself!</span>")
	else
		user << "<span class='danger'>The unearthly energies that powered the blade are now dormant.</span>"

/obj/effect/rend
	name = "tear in the fabric of reality"
	desc = "You should run now."
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	density = 1
	unacidable = 1
	anchored = 1
	var/spawn_path = /mob/living/simple_animal/cow //defaulty cows to prevent unintentional narsies
	var/spawn_amt_left = 20
	var/spawn_fast = 0

/obj/effect/rend/New(loc, var/spawn_type, var/spawn_amt, var/desc, var/spawn_fast)
	src.spawn_path = spawn_type
	src.spawn_amt_left = spawn_amt
	src.desc = desc
	src.spawn_fast = spawn_fast
	SSobj.processing |= src
	return

/obj/effect/rend/process()
	if(!spawn_fast)
		if(locate(/mob) in loc)
			return
	new spawn_path(loc)
	spawn_amt_left--
	if(spawn_amt_left <= 0)
		qdel(src)

/obj/effect/rend/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='danger'>[user] seals \the [src] with \the [I].</span>")
		qdel(src)
		return
	..()

/obj/item/weapon/veilrender/vealrender
	name = "veal render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast farm."
	spawn_type = /mob/living/simple_animal/cow
	spawn_amt = 20
	activate_descriptor = "hunger"
	rend_desc = "Reverberates with the sound of ten thousand moos."

/obj/item/weapon/veilrender/lesserveilrender
	name = "lesser veil render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of an ancient temple."
	spawn_type = /mob/living/simple_animal/hostile/faithless
	spawn_amt = 8
	activate_descriptor = "reality"
	rend_desc = "Reverberates with the sound of despair."

/obj/item/weapon/veilrender/honkrender
	name = "honk render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast circus."
	spawn_type = /mob/living/simple_animal/hostile/retaliate/clown
	spawn_amt = 10
	activate_descriptor = "depression"
	rend_desc = "Gently wafting with the sounds of endless laughter."
	icon_state = "clownrender"

/obj/item/weapon/veilrender/honkrender/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/items/bikehorn.ogg', 50, 1, -1) //plays instead of tap.ogg!
	return ..()

/////////////////////////////////////////Scrying///////////////////

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state ="bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/user)
	user << "<span class='notice'>You can see...everything!</span>"
	visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")
	user.ghostize(1)
	return

/////////////////////////////////////////Necromantic Stone///////////////////

/obj/item/device/necromantic_stone
	name = "necromantic stone"
	desc = "A shard capable of resurrecting humans as skeleton thralls."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "necrostone"
	item_state = "electronic"
	origin_tech = "bluespace=4;materials=4"
	w_class = 1
	var/list/spooky_scaries = list()
	var/unlimited = 0
	var/maxskeles = 3

/obj/item/device/necromantic_stone/unlimited
	unlimited = 1

/obj/item/device/necromantic_stone/oneuse //Used as a chaplain traitor item
	maxskeles = 1

/obj/item/device/necromantic_stone/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!istype(M))
		return ..()

	if(!istype(user) || !user.canUseTopic(M,1))
		return

	if(M.stat != DEAD)
		user << "<span class='warning'>This artifact can only affect the dead!</span>"
		return

	if(!M.mind || !M.client)
		user << "<span class='warning'>There is no soul connected to this body...</span>"
		return

	check_spooky()//clean out/refresh the list
	if(spooky_scaries.len >= maxskeles && !unlimited)
		user << "<span class='warning'>This artifact can only affect three undead at a time!</span>"
		return

	M.set_species(/datum/species/skeleton, icon_update=0)
	M.revive()
	spooky_scaries |= M
	M << "<span class='userdanger'>You have been revived by </span><B>[user.real_name]!</B>"
	M << "<span class='userdanger'>They are your master now, assist them even if it costs you your new life!</span>"

	equip_roman_skeleton(M)

	var/mob/living/carbon/human/master = user
	var/datum/objective/protect/protect_master = new /datum/objective/protect
	protect_master.owner = M.mind
	protect_master.target = master.mind
	protect_master.explanation_text = "Protect [master.real_name], your master."
	M.mind.objectives += protect_master
	ticker.mode.traitors += M.mind
	M.mind.special_role = "skeleton-thrall"


	desc = "A shard capable of resurrecting humans as skeleton thralls[unlimited ? "." : ", [spooky_scaries.len]/[maxskeles] active thralls."]"

/obj/item/device/necromantic_stone/proc/check_spooky()
	if(unlimited) //no point, the list isn't used.
		return

	for(var/X in spooky_scaries)
		if(!istype(X, /mob/living/carbon/human))
			spooky_scaries.Remove(X)
			continue
		var/mob/living/carbon/human/H = X
		if(H.stat == DEAD)
			spooky_scaries.Remove(X)
			continue
	listclearnulls(spooky_scaries)

//Funny gimmick, skeletons always seem to wear roman/ancient armour
/obj/item/device/necromantic_stone/proc/equip_roman_skeleton(mob/living/carbon/human/H)
	for(var/obj/item/I in H)
		if (istype(I, /obj/item/weapon/implant) || istype(I, /obj/item/organ)) continue
		H.unEquip(I)

	var/hat = pick(/obj/item/clothing/head/helmet/roman, /obj/item/clothing/head/helmet/roman/legionaire)
	H.equip_to_slot_or_del(new hat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roman(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roman(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/roman(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/claymore(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/twohanded/spear(H), slot_back)



/////////////////////Multiverse Blade////////////////////
var/global/list/multiverse = list()

/obj/item/weapon/multisword
	name = "multiverse sword"
	desc = "A weapon capable of conquering the universe and beyond. Activate it to summon copies of yourself from others dimensions to fight by your side."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "energy_katana"
	item_state = "energy_katana"
	hitsound = 'sound/weapons/bladeslice2.ogg'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 20
	throwforce = 10
	w_class = 2
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE
	var/faction = list("unassigned")
	var/cooldown = 0
	var/assigned = "unassigned"
	var/evil = TRUE

/obj/item/weapon/multisword/New()
	..()
	multiverse |= src


/obj/item/weapon/multisword/Destroy()
	multiverse.Remove(src)
	return ..()

/obj/item/weapon/multisword/attack_self(mob/user)
	if(user.mind.special_role == "apprentice")
		user << "<span class='warning'>You know better than to touch your teacher's stuff.</span>"
		return
	if(cooldown < world.time)
		var/faction_check = 0
		for(var/F in faction)
			if(F in user.faction)
				faction_check = 1
				break
		if(faction_check == 0)
			faction = list("[user.real_name]")
			assigned = "[user.real_name]"
			user.faction = list("[user.real_name]")
			user << "You bind the sword to yourself. You can now use it to summon help."
			if(!usr.mind.special_role)
				if(prob(30))
					user << "<span class='warning'><B>With your new found power you could easily conquer the station!</B></span>"
					var/datum/objective/hijackclone/hijack_objective = new /datum/objective/hijackclone
					hijack_objective.owner = usr.mind
					usr.mind.objectives += hijack_objective
					hijack_objective.explanation_text = "Ensure only [usr.real_name] and their copies are on the shuttle!"
					usr << "<B>Objective #[1]</B>: [hijack_objective.explanation_text]"
					ticker.mode.traitors += usr.mind
					usr.mind.special_role = "[usr.real_name] Prime"
					evil = TRUE
				else
					user << "<span class='warning'><B>With your new found power you could easily defend the station!</B></span>"
					var/datum/objective/survive/new_objective = new /datum/objective/survive
					new_objective.owner = usr.mind
					new_objective.explanation_text = "Survive, and help defend the innocent from the mobs of multiverse clones."
					usr << "<B>Objective #[1]</B>: [new_objective.explanation_text]"
					usr.mind.objectives += new_objective
					ticker.mode.traitors += usr.mind
					usr.mind.special_role = "[usr.real_name] Prime"
					evil = FALSE
		else
			var/list/candidates = get_candidates(ROLE_WIZARD)
			if(candidates.len)
				var/client/C = pick(candidates)
				spawn_copy(C, get_turf(user.loc), user)
				user << "<span class='warning'><B>The sword flashes, and you find yourself face to face with...you!</B></span>"
				cooldown = world.time + 400
				for(var/obj/item/weapon/multisword/M in multiverse)
					if(M.assigned == assigned)
						M.cooldown = cooldown

			else
				user << "You fail to summon any copies of yourself. Perhaps you should try again in a bit."
	else
		user << "<span class='warning'><B>[src] is recharging! Keep in mind it shares a cooldown with the swords wielded by your copies.</span>"


/obj/item/weapon/multisword/proc/spawn_copy(var/client/C, var/turf/T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M, icon_updates=0)
	M.key = C.key
	M.mind.name = usr.real_name
	M << "<B>You are an alternate version of [usr.real_name] from another universe! Help them accomplish their goals at all costs.</B>"
	M.real_name = usr.real_name
	M.name = usr.real_name
	M.faction = list("[usr.real_name]")
	if(prob(50))
		var/list/all_species = list()
		for(var/speciestype in typesof(/datum/species) - /datum/species)
			var/datum/species/S = new speciestype()
			if(!S.dangerous_existence)
				all_species += speciestype
		M.set_species(pick(all_species), icon_update=0)
	M.update_body()
	M.update_hair()
	M.update_body_parts()
	M.dna.update_dna_identity()
	equip_copy(M)

	if(evil)
		var/datum/objective/hijackclone/hijack_objective = new /datum/objective/hijackclone
		hijack_objective.owner = M.mind
		M.mind.objectives += hijack_objective
		hijack_objective.explanation_text = "Ensure only [usr.real_name] and their copies are on the shuttle!"
		M << "<B>Objective #[1]</B>: [hijack_objective.explanation_text]"
		M.mind.special_role = "multiverse traveller"
		log_game("[M.key] was made a multiverse traveller with the objective to help [usr.real_name] hijack.")
	else
		var/datum/objective/protect/new_objective = new /datum/objective/protect
		new_objective.owner = M.mind
		new_objective.target = usr.mind
		new_objective.explanation_text = "Protect [usr.real_name], your copy, and help them defend the innocent from the mobs of multiverse clones."
		M.mind.objectives += new_objective
		M << "<B>Objective #[1]</B>: [new_objective.explanation_text]"
		M.mind.special_role = "multiverse traveller"
		log_game("[M.key] was made a multiverse traveller with the objective to help [usr.real_name] protect the station.")

/obj/item/weapon/multisword/proc/equip_copy(var/mob/living/carbon/human/M)

	var/obj/item/weapon/multisword/sword = new /obj/item/weapon/multisword
	sword.assigned = assigned
	sword.faction = list("[assigned]")
	sword.evil = evil

	var/randomize = pick("mobster","roman","wizard","cyborg","syndicate","assistant", "animu", "cultist", "highlander", "clown", "killer", "pirate", "soviet", "officer", "gladiator")

	switch(randomize)
		if("mobster")
			M.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/black(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(M), slot_glasses)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/really_black(M), slot_w_uniform)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("roman")
			var/hat = pick(/obj/item/clothing/head/helmet/roman, /obj/item/clothing/head/helmet/roman/legionaire)
			M.equip_to_slot_or_del(new hat(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/roman(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/roman(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/weapon/shield/roman(M), slot_l_hand)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("wizard")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/red(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/red(M), slot_head)
			M.equip_to_slot_or_del(sword, slot_r_hand)
		if("cyborg")
			for(var/obj/item/organ/limb/affecting in M.organs)
				affecting.change_organ(ORGAN_ROBOTIC)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(M), slot_glasses)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("syndicate")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(M),slot_wear_mask)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("assistant")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("animu")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/kitty(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/schoolgirl/red(M), slot_w_uniform)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("cultist")
			M.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("highlander")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/kilt(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beret(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("clown")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(M), slot_l_store)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("killer")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/overalls(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/white(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/latex(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/welding(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/scalpel(M), slot_r_store)
			M.equip_to_slot_or_del(sword, slot_r_hand)
			for(var/obj/item/carried_item in M.contents)
				if(!istype(carried_item, /obj/item/weapon/implant))
					carried_item.add_blood(M)

		if("pirate")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(M), slot_glasses)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("soviet")
			M.equip_to_slot_or_del(new /obj/item/clothing/head/hgpiratecap(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/hgpirate(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(M), slot_w_uniform)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("officer")
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/beret(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/havana(M), slot_wear_mask)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/jacket/miljacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(M), slot_glasses)
			M.equip_to_slot_or_del(sword, slot_r_hand)

		if("gladiator")
			M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/gladiator(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(M), slot_shoes)
			M.equip_to_slot_or_del(sword, slot_r_hand)


		else
			return

	M.update_icons()

	var/obj/item/weapon/card/id/W = new /obj/item/weapon/card/id
	W.icon_state = "centcom"
	W.access += access_maint_tunnels
	W.assignment = "Multiverse Traveller"
	W.registered_name = M.real_name
	W.update_label(M.real_name)
	M.equip_to_slot_or_del(W, slot_wear_id)


/obj/item/voodoo
	name = "wicker doll"
	desc = "Something creepy about it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "voodoo"
	item_state = "electronic"
	var/mob/living/carbon/human/target = null
	var/list/mob/living/carbon/human/possible = list()
	var/obj/item/link = null
	var/cooldown_time = 30 //3s
	var/cooldown = 0
	burntime = 0
	burn_state = 0

/obj/item/voodoo/attackby(obj/item/I, mob/user, params)
	if(target && cooldown < world.time)
		if(I.is_hot())
			target << "<span class='userdanger'>You suddenly feel very hot</span>"
			target.bodytemperature += 50
			GiveHint(target)
		else if(is_pointed(I))
			target << "<span class='userdanger'>You feel a stabbing pain in [parse_zone(user.zone_sel.selecting)]!</span>"
			target.Weaken(2)
			GiveHint(target)
		else if(istype(I,/obj/item/weapon/bikehorn))
			target << "<span class='userdanger'>HONK</span>"
			target << 'sound/items/AirHorn.ogg'
			target.adjustEarDamage(0,3)
			GiveHint(target)
		cooldown = world.time +cooldown_time
		return

	if(!link)
		if(I.loc == user && istype(I) && I.w_class <= 2)
			user.drop_item()
			I.loc = src
			link = I
			user << "You attach [I] to the doll."
			update_targets()
	..()

/obj/item/voodoo/check_eye(mob/user)
	return src.loc == user

/obj/item/voodoo/attack_self(mob/user)
	if(!target && possible.len)
		target = input(user, "Select your victim!", "Voodoo") as null|anything in possible
		return

	if(user.zone_sel.selecting == "chest")
		if(link)
			target = null
			link.loc = get_turf(src)
			user << "<span class='notice'>You remove the [link] from the doll.</span>"
			link = null
			update_targets()
			return

	if(target && cooldown < world.time)
		switch(user.zone_sel.selecting)
			if("mouth")
				var/wgw =  sanitize(input(user, "What would you like the victim to say", "Voodoo", null)  as text)
				target.say(wgw)
				log_game("[user][user.key] made [target][target.key] say [wgw] with a voodoo doll.")
			if("eyes")
				user.set_machine(src)
				if(user.client)
					user.client.eye = target
					user.client.perspective = EYE_PERSPECTIVE
				spawn(100)
					user.reset_view()
					user.unset_machine()
			if("r_leg","l_leg")
				user << "<span class='notice'>You move the doll's legs around.</span>"
				var/turf/T = get_step(target,pick(cardinal))
				target.Move(T)
			if("r_arm","l_arm")
				//use active hand on random nearby mob
				var/list/nearby_mobs = list()
				for(var/mob/living/L in range(1,target))
					if(L!=target)
						nearby_mobs |= L
				if(nearby_mobs.len)
					var/mob/living/T = pick(nearby_mobs)
					log_game("[user][user.key] made [target][target.key] click on [T] with a voodoo doll.")
					target.ClickOn(T)
					GiveHint(target)
			if("head")
				user << "<span class='notice'>You smack the doll's head with your hand.</span>"
				target.Dizzy(10)
				target << "<span class='warning'>You suddenly feel as if your head was hit with a hammer!</span>"
				GiveHint(target,user)
		cooldown = world.time + cooldown_time

/obj/item/voodoo/proc/update_targets()
	possible = list()
	if(!link)
		return
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(md5(H.dna.uni_identity) in link.fingerprints)
			possible |= H

/obj/item/voodoo/proc/GiveHint(mob/victim,force=0)
	if(prob(50) || force)
		var/way = dir2text(get_dir(victim,get_turf(src)))
		victim << "<span class='notice'>You feel a dark presence from [way]</span>"
	if(prob(20) || force)
		var/area/A = get_area(src)
		victim << "<span class='notice'>You feel a dark presence from [A.name]</span>"

/obj/item/voodoo/fire_act()
	if(target)
		target.adjust_fire_stacks(20)
		target.IgniteMob()
		GiveHint(target,1)
	return ..()

// Syndicate Voodoo Item box
/obj/item/weapon/paper/voodoo
	name = "Voodoo Guide"
	icon_state = "alienpaper_words"
	info = {"Greetings muggle! The Wizard Federation likes to congratulate you on your purchase! Note that the Wizard Federation does not accept refunds of any sorts and that all purchases are final.<br>
 <br>
 <b>How to use</b><br>
 <br>
 First, you need to acquire an item touched by the person you want to control. Their fingerprints need to be on it, meaning that glove-wearers are likely to not leave any fingerprints at all. In addition, the item needs to be classified as a tiny or small item, otherwise you cannot attach it to the doll.<br>
 When you do get your hands onto an item with their fingerprints however, simply attach the item to the doll then activate it within your hand. Select the name of the person you want to manipulate and you'll bind their soul to the voodoo doll. The linked item can be removed by simply targetting the chest and activating it in your hand.
 <br><br>
 <b>Torture 101</b><br>
 <br>
 You can torment your victim in various way, but note that some of the more aggresive methods will notify the target of your general direction (and even the room you are currently in if they are lucky). Make sure that if you are being aggresive that you are always on the move or he may track you down.<br>
 <br>
 One of the most common ways of tormenting the victim is by simply using your empty hand. By selecting any body part besides the chest you will trigger various effects. By targetting the mouth you can force people to say things whatever you please, by targetting the eyes you can see the world trough your victims eyes and by targetting the legs you can move them in a random direction. All of these do not give a warning.<br>
 By selecting the head you can make your victim dizzy for a while, as well as giving them a small message notifying them of the pain they are going trough. In addition, selecting the arms makes them use the item they are currently holding on the target (with the selected intent). These 2 actions do reveal your directions.<br>
 Alternatively, you can use various items on them. Stabbing them with a pointy object weakens them for a period of time, using a "hot" item (typically lighters) on the doll increases his body temprature and using a bike horn (or air horn) causes a very loud horn to honk in their ears, damaging their ears as well as being incredibly annoying. All 3 of these actions reveal your direction.<br>
 If you feel like you will have no more purpose for the voodoo doll, you can set it ablaze, setting your target on fire as well. It will be incredibly hard extinguishing the doll before it burns up, so it is generally best to save this for last
"}

/obj/item/weapon/paper/voodoo/update_icon()
	return

/obj/item/weapon/storage/box/syndie_kit/voodoo
	name = "voodoo kit"

/obj/item/weapon/storage/box/syndie_kit/voodoo/New()
	..()
	new /obj/item/voodoo(src)
	new /obj/item/weapon/paper/voodoo(src)
	return
