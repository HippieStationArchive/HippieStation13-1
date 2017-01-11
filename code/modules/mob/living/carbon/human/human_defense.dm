/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
emp_act
*/


/mob/living/carbon/human/getarmor(def_zone, type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(islimb(def_zone))
			return checkarmor(def_zone, type)
		var/obj/item/organ/limb/affecting = getrandomorgan(def_zone)
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your limbs for protection, and averages out the values
	for(var/obj/item/organ/limb/H in organs)
		armorval += checkarmor(H, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(obj/item/organ/limb/def_zone, type)
	if(!type)	return 0
	if(!istype(def_zone)) return 0
	var/protection = 1 //Avoid divide by zero.
	var/list/armor_slots = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/ar in armor_slots)
		if(!ar)	continue
		if(ar && istype(ar ,/obj/item/clothing) || istype(ar ,/obj/item/weapon/storage/backpack))
			var/obj/item/C = ar
			if(C.body_parts_covered & def_zone.body_part)
				protection *= (1-(C.armor[type]/100)) //Mutliplicative stacking. (1-(Armor/100)) gives the fraction of damage not deflected by the armor, i.e armor=80, protection *= 0.2
	return ((1-protection)*100) // After multiplying the fractions of damage not blocked together to get the total fraction of damage not blocked, convert back to percent damage that IS blocked.

/mob/living/carbon/human/on_hit(proj_type)
	dna.species.on_hit(proj_type, src)

/mob/living/carbon/human/bullet_act(obj/item/projectile/P, def_zone)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		if(check_reflect(def_zone)) // Checks if you've passed a reflection% check
			visible_message("<span class='danger'>The [P.name] gets reflected by [src]!</span>", \
							"<span class='userdanger'>The [P.name] gets reflected by [src]!</span>")
			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/turf/curloc = get_turf(src)

				// redirect the projectile
				P.original = locate(new_x, new_y, P.z)
				P.starting = curloc
				P.current = curloc
				P.firer = src
				P.yo = new_y - curloc.y
				P.xo = new_x - curloc.x
				P.Angle = ""//round(Get_Angle(P,P.original))

			return -1 // complete projectile permutation

	var/obj/item/organ/limb/affecting = get_organ(check_zone(def_zone))
	if(!affecting)
		visible_message("<span class='danger'>\a [P] wizzes past [src]!</span>", "<span class='userdanger'>\a [P] wizzes past you!</span>")
		return -1 //No arm, no hit

	var/shieldcheck = check_shields(P.damage, "the [P.name]", P, 0, P.armour_penetration, P.flag)
	if(shieldcheck)
		if(isliving(shieldcheck)) //Meatshield
			var/mob/living/L = shieldcheck
			L.bullet_act(P, def_zone)
		else
			P.on_hit(src, 100, def_zone)
		return 2
	return (..(P , def_zone))

/mob/living/carbon/human/proc/check_reflect(def_zone) //Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
	if(wear_suit)
		if(wear_suit.IsReflect(def_zone) == 1)
			return 1
	if(l_hand)
		if(l_hand.IsReflect(def_zone) == 1)
			return 1
	if(r_hand)
		if(r_hand.IsReflect(def_zone) == 1)
			return 1
	return 0


//End Here

/mob/living/carbon/human/proc/check_shields(damage = 0, attack_text = "the attack", atom/movable/AM, thrown_proj = 0, armour_penetration = 0, type = "melee")
	if(AM)
		if(AM.flags & NOSHIELD) //weapon ignores shields altogether
			return 0
	if(!type)
		type = "melee" //otherwise it runtimes
	if(l_hand && !istype(l_hand, /obj/item/clothing))
		var/final_block_chance = l_hand.block_chance[type] - (Clamp((armour_penetration-l_hand.armour_penetration)/2,0,100)) //So armour piercing blades can still be parried by other blades, for example
		if(l_hand.hit_reaction(src, attack_text, final_block_chance, damage, type))
			return 1
	if(r_hand && !istype(r_hand, /obj/item/clothing))
		var/final_block_chance = r_hand.block_chance[type] - (Clamp((armour_penetration-r_hand.armour_penetration)/2,0,100)) //Need to reset the var so it doesn't carry over modifications between attempts
		if(r_hand.hit_reaction(src, attack_text, final_block_chance, damage, type))
			return 1
	if(wear_suit)
		var/final_block_chance = wear_suit.block_chance[type] - (Clamp((armour_penetration-wear_suit.armour_penetration)/2,0,100))
		if(wear_suit.hit_reaction(src, attack_text, final_block_chance, damage, type))
			return 1
	if(w_uniform)
		var/final_block_chance = w_uniform.block_chance[type] - (Clamp((armour_penetration-w_uniform.armour_penetration)/2,0,100))
		if(w_uniform.hit_reaction(src, attack_text, final_block_chance, damage, type))
			return 1
	return 0

/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user, def_zone)
	if(!I || !user)	return 0

	var/obj/item/organ/limb/target_limb = get_organ(check_zone(user.zone_sel.selecting))
	var/obj/item/organ/limb/affecting = get_organ(ran_zone(user.zone_sel.selecting))
	var/hit_area = parse_zone(Bodypart2name(affecting))
	var/target_area = parse_zone(Bodypart2name(target_limb))
	feedback_add_details("item_used_for_combat","[I.type]|[I.force]")
	feedback_add_details("zone_targeted","[target_area]")

	// the attacked_by code varies among species
	return dna.species.spec_attacked_by(I,user,def_zone,affecting,hit_area,src.a_intent,target_limb,target_area,src)

/mob/living/carbon/human/emp_act(severity)
	var/informed = 0
	for(var/obj/item/organ/limb/L in src.organs)
		if(L.status == ORGAN_ROBOTIC)
			if(!informed)
				src << "<span class='userdanger'>You feel a sharp pain as your robotic limbs overload.</span>"
				informed = 1
			switch(severity)
				if(1)
					L.take_damage(0,10)
					src.Stun(10)
				if(2)
					L.take_damage(0,5)
					src.Stun(5)
	..()

/mob/living/carbon/human/acid_act(acidpwr, toxpwr, acid_volume)
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = min(acidpwr*acid_volume/200, toxpwr)
	var/acid_volume_left = acid_volume
	var/acid_decay = 100/acidpwr // how much volume we lose per item we try to melt. 5 for fluoro, 10 for sulphuric

	//HEAD//
	var/obj/item/clothing/head_clothes = null
	if(glasses)
		head_clothes = glasses
	if(wear_mask)
		head_clothes = wear_mask
	if(head)
		head_clothes = head
	if(head_clothes)
		if(!head_clothes.unacidable)
			head_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0) //We remove some of the acid volume.
			update_inv_glasses()
			update_inv_wear_mask()
			update_inv_head()
		else
			src << "<span class='notice'>Your [head_clothes.name] protects your head and face from the acid!</span>"
	else
		. = get_organ("head")
		if(.)
			damaged += .
		if(ears)
			inventory_items_to_kill += ears

	//CHEST//
	var/obj/item/clothing/chest_clothes = null
	if(w_uniform)
		chest_clothes = w_uniform
	if(wear_suit)
		chest_clothes = wear_suit
	if(chest_clothes)
		if(!chest_clothes.unacidable)
			chest_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [chest_clothes.name] protects your body from the acid!</span>"
	else
		. = get_organ("chest")
		if(.)
			damaged += .
		if(wear_id)
			inventory_items_to_kill += wear_id
		if(r_store)
			inventory_items_to_kill += r_store
		if(l_store)
			inventory_items_to_kill += l_store
		if(s_store)
			inventory_items_to_kill += s_store


	//ARMS & HANDS//
	var/obj/item/clothing/arm_clothes = null
	if(gloves)
		arm_clothes = gloves
	if(w_uniform && (w_uniform.body_parts_covered & HANDS) || w_uniform && (w_uniform.body_parts_covered & ARMS))
		arm_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & HANDS) || wear_suit && (wear_suit.body_parts_covered & ARMS))
		arm_clothes = wear_suit
	if(arm_clothes)
		if(!arm_clothes.unacidable)
			arm_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_gloves()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [arm_clothes.name] protects your arms and hands from the acid!</span>"
	else
		. = get_organ("r_arm")
		if(.)
			damaged += .
		. = get_organ("l_arm")
		if(.)
			damaged += .


	//LEGS & FEET//
	var/obj/item/clothing/leg_clothes = null
	if(shoes)
		leg_clothes = shoes
	if(w_uniform && (w_uniform.body_parts_covered & FEET) || w_uniform && (w_uniform.body_parts_covered & LEGS))
		leg_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & FEET) || wear_suit && (wear_suit.body_parts_covered & LEGS))
		leg_clothes = wear_suit
	if(leg_clothes)
		if(!leg_clothes.unacidable)
			leg_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_shoes()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [leg_clothes.name] protects your legs and feet from the acid!</span>"
	else
		. = get_organ("r_leg")
		if(.)
			damaged += .
		. = get_organ("l_leg")
		if(.)
			damaged += .


	//DAMAGE//
	for(var/obj/item/organ/limb/affecting in damaged)
		affecting.take_damage(acidity, 2*acidity)

		if(Bodypart2name(affecting.body_part) == "head")
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.take_damage(acidity, 2*acidity)
				emote("scream")
				facial_hair_style = "Shaved"
				hair_style = "Bald"
				update_hair()
				status_flags |= DISFIGURED

		update_damage_overlays()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(back)
		inventory_items_to_kill += back
	if(belt)
		inventory_items_to_kill += belt
	if(r_hand)
		inventory_items_to_kill += r_hand
	if(l_hand)
		inventory_items_to_kill += l_hand

	for(var/obj/item/I in inventory_items_to_kill)
		I.acid_act(acidpwr, acid_volume_left)
		acid_volume_left = max(acid_volume_left - acid_decay, 0)

/mob/living/carbon/human/grabbedby(mob/living/user)
	if(user.zone_sel.selecting == "groin")
		var/obj/item/organ/internal/butt/B = src.getorgan(/obj/item/organ/internal/butt)
		if(!w_uniform)
			if(B)
				if(user == src)
					user.visible_message("<span class='warning'>[user] starts inspecting \his own ass!</span>", "<span class='warning'>You start inspecting your ass!</span>")
				else
					user.visible_message("<span class='warning'>[user] starts inspecting [src]'s ass!</span>", "<span class='warning'>You start inspecting [src]'s ass!</span>")
				if(do_mob(user, src, 40))
					if(B.contents.len)
						if(user == src)
							user.visible_message("<span class='warning'>[user] inspects \his own ass!</span>", "<span class='warning'>You inspect your ass!</span>")
						else
							user.visible_message("<span class='warning'>[user] inspects [src]'s ass!</span>", "<span class='warning'>You inspect [src]'s ass!</span>")
						var/obj/item/O = pick(B.contents)
						O.loc = get_turf(src)
						B.contents -= O
						B.stored -= O.itemstorevalue
						return 0
					else
						user.visible_message("<span class='warning'>There's nothing in here!</span>")
						return 0
				else
					if(user == src)
						user.visible_message("<span class='warning'>[user] fails to inspect \his own ass!</span>", "<span class='warning'>You fail to inspect your ass!</span>")
					else
						user.visible_message("<span class='warning'>[user] fails to inspect [src]'s ass!</span>", "<span class='warning'>You fail to inspect [src]'s ass!</span>")
					return 0
			else
				user << "<span class='warning'>There's nothing to inspect!</span>"
				return 0
		else
			if(user == src)
				user.visible_message("<span class='warning'>[user] grabs \his own butt!</span>", "<span class='warning'>You grab your own butt!</span>")
				user << "<span class='warning'>You'll need to remove your jumpsuit first!</span>"
			else
				user.visible_message("<span class='warning'>[user] grabs [src]'s butt!</span>", "<span class='warning'>You grab [src]'s butt!</span>")
				user << "<span class='warning'>You'll need to remove [src]'s jumpsuit first!</span>"
				src << "<span class='warning'>You feel your butt being grabbed!</span>"
			return 0
	if(w_uniform)
		w_uniform.add_fingerprint(user)
	..()


/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	if(..())
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/shieldcheck = check_shields(damage, "the [M.name]", "", "", M.armour_penetration)
		if(shieldcheck)
			if(isliving(shieldcheck))
				var/mob/living/L = shieldcheck
				L.attack_animal(M)
			return 0
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/item/organ/limb/affecting = get_organ(ran_zone(dam_zone))
		var/armor = run_armor_check(affecting, "melee")
		apply_damage(damage, M.melee_damage_type, affecting, armor, "", "", M.armour_penetration)
		updatehealth()


/mob/living/carbon/human/attack_larva(mob/living/carbon/alien/larva/M)

	if(..()) //successful larva bite.
		var/damage = rand(1, 3)
		var/shieldcheck = check_shields(damage, "the [M.name]")
		if(shieldcheck)
			if(isliving(shieldcheck))
				var/mob/living/L = shieldcheck
				L.attack_larva(M)
			return 0
		if(stat != DEAD)
			M.amount_grown = min(M.amount_grown + damage, M.max_grown)
			var/obj/item/organ/limb/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")
			apply_damage(damage, BRUTE, affecting, armor_block)
			updatehealth()


/mob/living/carbon/human/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime attack
		var/damage = rand(5, 25)
		if(M.is_adult)
			damage = rand(10, 35)

		var/shieldcheck = check_shields(damage, "the [M.name]")
		if(shieldcheck)
			if(isliving(shieldcheck))
				var/mob/living/L = shieldcheck
				L.attack_slime(M)
			return 0

		var/dam_zone = pick("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg", "groin")

		var/obj/item/organ/limb/affecting = get_organ(ran_zone(dam_zone))
		var/armor_block = run_armor_check(affecting, "melee")
		apply_damage(damage, BRUTE, affecting, armor_block)

/mob/living/carbon/human/mech_melee_attack(obj/mecha/M)

	if(M.occupant.a_intent == "harm")
		if(M.damtype == BRUTE)
			step_away(src,M,15)
		var/obj/item/organ/limb/temp = get_organ(pick("chest", "chest", "chest", "head"))
		if(temp)
			var/update = 0
			switch(M.damtype)
				if(BRUTE)
					if(M.force > 20)
						Paralyse(1)
					update |= temp.take_damage(rand(M.force/2, M.force), 0)
					playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				if(BURN)
					update |= temp.take_damage(0, rand(M.force/2, M.force))
					playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if(TOX)
					M.mech_toxin_damage(src)
				else
					return
			if(update)
				update_damage_overlays(0)
			updatehealth()

		visible_message("<span class='danger'>[M.name] has hit [src]!</span>", \
								"<span class='userdanger'>[M.name] has hit [src]!</span>")
		//TODO: Change this to use the damtype word not int
		add_logs(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")

	else
		..()

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = 0, hitpush = 1, blocked = 0, zone)
	var/obj/item/I
	var/throwpower = 30
	if(istype(AM, /obj/item))
		I = AM
		throwpower = I.throwforce
		zone = ran_zone(I.throwing_def_zone, 65)
	if(check_shields(throwpower, "\the [AM.name]", AM, 1))
		hitpush = 0
		skipcatch = 1
		blocked = 1
	else if(I)
		var/obj/item/B = get_active_hand()
		if(istype(B) && B.deflectItem && B.specthrow_maxwclass >= I.w_class)
			throw_mode_off()
			visible_message("<span class='warning'>[src] has [B.specthrowmsg] [I]!</span>")
			var/atom/throw_target = get_edge_target_turf(src, src.dir)
			I.throw_at(throw_target, I.throw_range, I.throw_speed)
			if(B.specthrowsound)
				playsound(loc, B.specthrowsound, 50, 1, -7)
			return //Effectively deflected
		if(can_embed(I) || I.assthrown)
			if((!in_throw_mode || get_active_hand()) && (prob(I.embed_chance) && !(dna && (PIERCEIMMUNE in dna.species.specflags))) || I.assthrown)
				throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
				var/obj/item/organ/limb/L = get_organ(check_zone(zone))
				if(istype(L))
					L.embedded_objects |= I
					I.add_blood(src)//it embedded itself in you, of course it's bloody!
					I.loc = src
					L.take_damage(I.w_class*I.embedded_impact_pain_multiplier)
					visible_message("<span class='danger'>\The [I.name] embeds itself in [src]'s [L]!</span>","<span class='userdanger'>\The [I.name] embeds itself in your [L]!</span>")
					hitpush = 0
					skipcatch = 1 //can't catch the now embedded item
	return ..(I, skipcatch, hitpush, blocked, zone)
