/obj/item/weapon/melee
	needs_permit = 1

/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=4"
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'sound/weapons/chainofcommand.ogg'

/obj/item/weapon/melee/chainofcommand/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (OXYLOSS)



/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 12 //9 hit crit
	w_class = 3
	var/cooldown = 0
	var/on = 1
	burn_state = 0

/obj/item/weapon/melee/classic_baton/attack(mob/target, mob/living/user)
	if(on)
		add_fingerprint(user)
		if((CLUMSY in user.disabilities) && prob(50))
			user << "<span class ='danger'>You club yourself over the head.</span>"
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, "head")
			else
				user.take_organ_damage(2*force)
			return
		if(isrobot(target))
			..()
			return
		if(!isliving(target))
			return
		if (user.a_intent == "harm")
			if(!..()) return
			if(!isrobot(target)) return
		else
			if(cooldown <= 0)
				playsound(get_turf(src), 'sound/effects/woodhit.ogg', 75, 1, -1)
				target.Weaken(3)
				add_logs(user, target, "stunned", src)
				src.add_fingerprint(user)
				target.visible_message("<span class ='danger'>[user] has knocked down [target] with \the [src]!</span>", \
					"<span class ='userdanger'>[user] has knocked down [target] with \the [src]!</span>")
				if(!iscarbon(user))
					target.LAssailant = null
				else
					target.LAssailant = user
				cooldown = 1
				spawn(40)
					cooldown = 0
		return
	else
		return ..()



/obj/item/weapon/melee/classic_baton/telescopic
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = null
	slot_flags = SLOT_BELT
	w_class = 2
	needs_permit = 0
	force = 0
	on = 0

/obj/item/weapon/melee/classic_baton/telescopic/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/internal/brain/B = H.getorgan(/obj/item/organ/internal/brain)

	user.visible_message("<span class='suicide'>[user] stuffs the [src] up their nose and presses the 'extend' button! It looks like they're trying to clear their mind.</span>")
	if(!on)
		src.attack_self(user)
	else
		playsound(loc, 'sound/weapons/batonextend.ogg', 50, 1)
		add_fingerprint(user)
	sleep(3)
	if (H && !qdeleted(H))
		if (B && !qdeleted(B))
			H.internal_organs -= B
			qdel(B)
		gibs(H.loc, H.viruses, H.dna)
		return (BRUTELOSS)
	return

/obj/item/weapon/melee/classic_baton/telescopic/attack_self(mob/user)
	on = !on
	if(on)
		user << "<span class ='warning'>You extend the baton.</span>"
		icon_state = "telebaton_1"
		item_state = "nullrod"
		w_class = 4 //doesnt fit in backpack when its on for balance
		force = 10 //stunbaton damage
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user << "<span class ='notice'>You collapse the baton.</span>"
		icon_state = "telebaton_0"
		item_state = null //no sprite for concealment even when in hand
		slot_flags = SLOT_BELT
		w_class = 2
		force = 0 //not so robust now
		attack_verb = list("hit", "poked")

	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)

//POWER FIST
//This thing -was- a mish-mash of singularity hammer and mjollnir code, and it had performed awfully.

/obj/item/weapon/melee/powerfist
	name = "Power Fist"
	desc = "A large mechanically powered fist made out of plasteel which can deliver a massive blow to any target with the ability to throw them across a room. The power fist needs approximately a second in between each punch before it is powered again."
	icon_state = "powerfist"
	item_state = "powerfist"
	flags = CONDUCT
	force = 30
	throwforce = 10
	throw_range = 7
	w_class = 3
	origin_tech = "combat=5;powerstorage=3"
	needs_permit = 0 //Other syndicate weapons don't piss off beepsky either
	var/click_delay = 1.3

/obj/item/weapon/melee/powerfist/attack(mob/living/target, mob/living/user)		//Keep this to powerfist/attack and NOT powerfist/afterattack , powerfist/afterattack gives this thing INFINITE range without further checks.
	var/datum/effect_system/lightning_spread/s = new /datum/effect_system/lightning_spread
	s.set_up(5, 1, target.loc)
	s.start()	//Executes these speshul effects on the hit target AKA victim.

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/limb/affecting = H.get_organ(ran_zone(user.zone_sel.selecting))
		var/armor_block = H.run_armor_check(affecting, "melee")
		target.apply_damage(force, BRUTE, affecting, armor_block)	//If it's a mob and humanoid, give it brute damage which ignores any armor for the hit body part.
	else
		target.apply_damage(force, BRUTE)	//If it's a mob but not a humanoid, just give it plain brute damage.

	target.visible_message("<span class='danger'>[target.name] was power-fisted by [user]!</span>", \
		"<span class='userdanger'>You hear a loud crack!</span>", \
		"<span class='italics'>You hear the sound of bones crunching!</span>")

	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	spawn(1)
		target.throw_at(throw_target, 10, 0.2)	//Throws the target 10 tiles

	playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, 1)

	add_logs(user, target, "power fisted", src)

	user.changeNext_move(CLICK_CD_MELEE * click_delay) //As a balance measure it's not as spammable as other weapons.

	return

/obj/item/weapon/melee/powerfist/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)	//Borrowed code from the fire axe yaaay
	if(!proximity) return
	if(A && (istype(A,/obj/structure/window) || istype(A,/obj/structure/grille))) //destroys windows and grilles in one hit
		if(istype(A,/obj/structure/window)) //should just make a window.Break() proc but couldn't bother with it
			var/obj/structure/window/W = A

			new /obj/item/weapon/shard( W.loc )
			if(W.reinf) new /obj/item/stack/rods( W.loc)

			if (W.dir == SOUTHWEST)
				new /obj/item/weapon/shard( W.loc )
				if(W.reinf) new /obj/item/stack/rods( W.loc)
		qdel(A)

//Bloodraven Chainsword from Facepunch

/obj/item/weapon/melee/chainsword
	name = "Chain Sword"
	desc = "An imperium sword with motorized teeth that run along the blade. These monomolecure edged reazor sharp teeth make an angry buzzing sound as they spin and are capable of cutting through any foe."
	icon_state = "chainsword_bloodravens"
	item_state = "chainsword_bloodravens"
	flags = CONDUCT
	force = 40
	w_class = 3
	armour_penetration = 20
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/chainsword.ogg'
	sharpness = IS_SHARP

//Combat Knife
/obj/item/weapon/melee/combatknife
	name = "combat knife"
	desc = "An extremely sharp military combat knife favored by syndicate agents."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckknife"
	flags = CONDUCT
	force = 17.0 //Reduced force to put bigger emphasis on bleeding
	w_class = 1.0
	slot_flags = SLOT_BELT
	throwforce = 20.0 //Robust, but not as robust as it could be if it succesfully embeds
	throw_speed = 3
	throw_range = 8
	attack_verb = list("stabbed", "torn", "cut", "sliced")
	hitsound = 'sound/weapons/knife.ogg'
	hitsound_extrarange = -3 //Sorta more sneaky beaky like
	//Embedding
	sharpness = IS_SHARP_ACCURATE
	embed_chance = 70 //Makes it an awesome throwing weapon.
	embedded_impact_pain_multiplier = 30 //w_class is multiplied into this to determine damage applied on embed.
	embedded_pain_multiplier = 6 //6 force applied when "it hurts"
	embedded_pain_chance = 25 //25% chance to be pained by the knife

/obj/item/weapon/melee/combatknife/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting \his own throat with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)
