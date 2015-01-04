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
	hitsound = 'sound/new_sound/weapons/chainofcommand.ogg'

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

/obj/item/weapon/melee/truncheon/attack(mob/M, mob/living/user)
	add_fingerprint(user)
	if((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>You club yourself over the head!</span>"
		user.Weaken(7)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2 * force, BRUTE, "head")
			H.forcesay(hit_appends)
		else
			user.take_organ_damage(2 * force)
		return
	add_logs(user, M, "attacked", object="[src.name]")

	if(isrobot(M)) // Don't stun borgs, fix for issue #2436
		..()
		return
	if(!isliving(M)) // Don't stun nonhuman things
		return

	var/mob/living/L = M
	if(user.a_intent == "harm" || (extendable && !on))
		..()
		// playsound(loc, pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg'), 50, 1, -1)
	else
		playsound(loc, 'sound/new_sound/weapons/baton1.ogg', 50, 1, -1)
		L.apply_damage(3.5 * force, STAMINA)
		M.visible_message("<span class='danger'>[M] has been disciplined with [src] by [user]!</span>", \
							"<span class='userdanger'>[M] has been disciplined with [src] by [user]!</span>")

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.forcesay(hit_appends)

/obj/item/weapon/melee/truncheon/classic_baton
	name = "police baton"
	desc = "A truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "nightstickfiber"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("beaten")

/obj/item/weapon/melee/truncheon/classic_baton/New()
	item_color = pick("lwood", "fiber", "dwood")
	icon_state = "nightstick[item_color]"
	item_state = "nightstick[item_color]"

/obj/item/weapon/melee/truncheon/telebaton
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	slot_flags = SLOT_BELT
	w_class = 2
	force = 3
	extendable = 1

/obj/item/weapon/melee/truncheon/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user << "<span class ='warning'>You extend the baton.</span>"
		icon_state = "telebaton_1"
		item_state = "nullrod"
		w_class = 4 //doesnt fit in backpack when its on for balance
		force = 10 //seclite damage
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user << "<span class ='notice'>You collapse the baton.</span>"
		icon_state = "telebaton_0"
		item_state = "telebaton_0" //no sprite in other words
		slot_flags = SLOT_BELT
		w_class = 2
		force = 3 //not so robust now
		attack_verb = list("hit", "poked")

	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)

/*/obj/item/weapon/melee/truncheon/telebaton/attack(mob/target as mob, mob/living/user as mob)
	if(on)
		add_fingerprint(user)
		if((CLUMSY in user.mutations) && prob(50))
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
				add_logs(user, target, "stunned", object="telescopic baton")
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
*/

/obj/item/weapon/melee/combatknife
	name = "combat knife"
	desc = "An extremely sharp military combat knife favored by syndicate agents."
	icon = 'icons/obj/Knives.dmi'
	icon_state = "buckknife"
	flags = CONDUCT
	force = 18.0
	w_class = 1.0
	slot_flags = SLOT_BELT
	throwforce = 22.0
	throw_speed = 3
	throw_range = 8
	attack_verb = list("stabbed", "torn", "cut", "sliced")
	hitsound = 'sound/New_Sound/weapons/knife.ogg'

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
		hitsound = 'sound/New_Sound/weapons/knife.ogg'
		attack_verb = list("stabbed", "torn", "cut", "sliced")
		icon_state = "pocketknife_open"
		w_class = 3
		playsound(user, 'sound/New_Sound/weapons/wielding/raise.ogg', 20, 1)
		user << "<span class='notice'>[src] is now open.</span>"
	else
		force = deactive_force
		throwforce = 3
		hitsound = "swing_hit"
		attack_verb = null
		icon_state = "pocketknife"
		w_class = 1
		playsound(user, 'sound/New_Sound/weapons/wielding/raise.ogg', 20, 1)
		user << "<span class='notice'>[src] is now closed.</span>"
	add_fingerprint(user)
	return