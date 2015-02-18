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

/obj/item/weapon/melee/truncheon
	name = "prototype baton"
	desc = "A baton prototype. You shouldn't be able to find this."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "nightstickfiber"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("beaten")
	var/extendable = 0
	var/on = 0
	var/delay = 0
	var/stamina = 0
	var/cooldown = 0

/obj/item/weapon/melee/truncheon/attack(mob/target as mob, mob/living/user as mob)
// if(on)
	add_fingerprint(user)
	if((CLUMSY in user.mutations) && prob(50))
		user << "<span class ='danger'>You club yourself over the head.</span>"
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(force, BRUTE, "head")
		else
			user.take_organ_damage(force)
		return
	if(isrobot(target))
		..()
		return
	// if(!isliving(target))
	// 	return
	if (user.a_intent == "harm" || (extendable && !on))
		if(!..()) return
		if(!isrobot(target)) return
	else
		if(cooldown <= 0)
			playsound(user, 'sound/weapons/baton1.ogg', 50, 1, -1)
			if(stamina)
				var/mob/living/carbon/human/H = target
				H.apply_damage(3.5 * force, STAMINA)
			else
				target.Weaken(3)
			add_logs(user, target, "stunned", object=name)
			src.add_fingerprint(user)
			target.visible_message("<span class ='danger'>[user] has knocked down [target] with \the [src]!</span>", \
				"<span class ='userdanger'>[user] has knocked down [target] with \the [src]!</span>")
			if(!iscarbon(user))
				target.LAssailant = null
			else
				target.LAssailant = user
			if(delay >= 1)
				cooldown = 1
				spawn(delay)
					cooldown = 0
	return
// else
	// return ..()

/obj/item/weapon/melee/truncheon/telebaton
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	slot_flags = SLOT_BELT
	w_class = 2
	force = 0
	throwforce = 5
	extendable = 1
	delay = 40

/obj/item/weapon/melee/truncheon/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user << "<span class ='warning'>You extend the baton.</span>"
		icon_state = "telebaton_1"
		item_state = "nullrod"
		w_class = 4 //doesnt fit in backpack when its on for balance
		force = 5 //seclite damage
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user << "<span class ='notice'>You collapse the baton.</span>"
		icon_state = "telebaton_0"
		item_state = "telebaton_0" //no sprite in other words
		slot_flags = SLOT_BELT
		w_class = 2
		force = 0 //not so robust now
		attack_verb = list("hit", "poked")

	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)

/obj/item/weapon/melee/truncheon/classic_baton
	name = "police baton"
	desc = "A classic truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "nightstickfiber"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("smacked", "struck", "cracked", "beaten")
	stamina = 1
	// delay = 2

/obj/item/weapon/melee/truncheon/classic_baton/New()
	item_color = pick("lwood", "fiber", "dwood")
	icon_state = "nightstick[item_color]"
	item_state = "nightstick[item_color]"
	hitsound = "swing_hit"

/obj/item/weapon/melee/combatknife
	name = "combat knife"
	desc = "An extremely sharp military combat knife favored by syndicate agents."
	icon = 'icons/obj/Knives.dmi'
	icon_state = "buckknife"
	flags = CONDUCT
	force = 17.0 //Reduced force to put bigger emphasis on bleeding
	bleedcap = 0 //Can cause bleeding even on first stab
	bleedchance = 30 //Higher chance to cause bleeding - same as kitchen knife
	w_class = 1.0
	slot_flags = SLOT_BELT
	throwforce = 20.0 //Robust as fuck when thrown
	throw_speed = 3
	throw_range = 8
	attack_verb = list("stabbed", "torn", "cut", "sliced")
	hitsound = 'sound/weapons/knife.ogg'

/obj/item/weapon/melee/concealable
	var/active = 0
	var/active_force = 0 //force when active
	var/deactive_force = 0 //force when off

/obj/item/weapon/melee/concealable/pocketknife
	name = "pocket knife"
	desc = "Small, concealable blade that fits in the pocket nicely."
	icon = 'icons/obj/Knives.dmi'
	icon_state = "pocketknife"
	force = 3
	throwforce = 3
	hitsound = "swing_hit" //it starts deactivated
	throw_speed = 3
	throw_range = 8
	active_force = 12
	deactive_force = 3
	w_class = 1 //note to self: weight class

/obj/item/weapon/melee/concealable/pocketknife/attack_self(mob/living/user)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>You accidentally cut yourself with [src], like a doofus!</span>"
		user.take_organ_damage(5,5)
	active = !active
	if (active)
		force = active_force
		throwforce = 14
		hitsound = 'sound/weapons/knife.ogg'
		attack_verb = list("stabbed", "torn", "cut", "sliced")
		icon_state = "pocketknife_open"
		w_class = 3
		bleedcap = 20 //Reduce bleedcap
		playsound(user, 'sound/weapons/raise.ogg', 20, 1)
		user << "<span class='notice'>[src] is now open.</span>"
	else
		force = deactive_force
		throwforce = 3
		hitsound = "swing_hit"
		attack_verb = null
		icon_state = "pocketknife"
		w_class = 1
		bleedcap = 40 //restore bleedcap
		playsound(user, 'sound/weapons/raise.ogg', 20, 1)
		user << "<span class='notice'>[src] is now closed.</span>"
	add_fingerprint(user)
	return