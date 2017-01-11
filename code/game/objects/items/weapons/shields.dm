/obj/item/weapon/shield
	name = "shield"
	icon = 'icons/obj/weapons.dmi'
	attack_verb = list("shoved", "bashed")
	block_chance = list(melee = 60, bullet = 50, laser = 40, energy = 30) //defaultorino vars
	blocksound = 'sound/items/dodgeball.ogg'

/obj/item/weapon/shield/roman
	name = "roman shield"
	desc = "Bears an inscription on the inside: <i>\"Romanes venio domus\"</i>."
	icon_state = "roman_shield"
	item_state = "roman_shield"
	slot_flags = SLOT_BACK
	force = 8
	stamina_percentage = 0.75
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = 4
	materials = list(MAT_GLASS=7500, MAT_METAL=1000)
	origin_tech = "materials=2"
	block_chance = list(melee = 60, bullet = 50, laser = 50, energy = 50) //Skeleton-exclusive atm, sooo

/obj/item/weapon/shield/roman/toy /* Used for the Theatre Vending Machine */
	name = "replica roman shield"
	desc = "Bears an inscription on the inside: <i>\"Made in Space China\"</i>."
	block_chance = list(melee = 0, bullet = 0, laser = 0, energy = 0)

//Deployable shields, woo!
//Basically "defensive stance" for shields like riot, etc.
/obj/item/weapon/shield/deployable
	block_chance = list(melee = 0, bullet = 0, laser = 0, energy = 0)
	var/list/block_chance_deployed = list(melee = 60, bullet = 50, laser = 40, energy = 30)
	var/slowdown_deployed = 0
	var/force_deployed = 0
	var/active = 0

/obj/item/weapon/shield/deployable/New()
	..()
	icon_state = "[icon_state][active]"

/obj/item/weapon/shield/deployable/attack_self(mob/living/user)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.disabilities & CLUMSY && prob(50))
		H << "<span class='warning'>You beat yourself in the head with [src].</span>"
		H.take_organ_damage(force)
	active = !active
	icon_state = "[initial(icon_state)][active]"
	playsound(src.loc, 'sound/weapons/raise.ogg', 50, 1)

	if(active)
		block_chance = block_chance_deployed
		slowdown = slowdown_deployed
		user << "<span class='notice'>You raise \the [src].</span>"
	else
		block_chance = initial(block_chance)
		slowdown = initial(slowdown)
		user << "<span class='notice'>You lower \the [src]</span>"
	add_fingerprint(user)


/obj/item/weapon/shield/deployable/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects and bullets from connecting with the body of the shield wielder."
	icon_state = "riot"
	slot_flags = SLOT_BACK
	force = 8
	stamina_percentage = 0.75
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = 4
	materials = list(MAT_GLASS=7500, MAT_METAL=1000)
	origin_tech = "materials=2"
	slowdown_deployed = 2
	block_chance_deployed = list(melee = 70, bullet = 60, laser = 40, energy = 30) //Reason why melee value is so high is because the shield applies sizable slowdown to you now. It should be viable to give you an edge in melee combat mostly.
	var/cooldown = 0

/obj/item/weapon/shield/deployable/riot/attack_self(mob/living/user)
	..()
	block_push = active

/obj/item/weapon/shield/deployable/riot/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/melee/baton) && active)
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/deployable/riot/dropped(mob/user)
	if(active && user)
		attack_self(user)

/obj/item/weapon/shield/deployable/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most melee attacks. Protects user from almost all energy projectiles. It can be retracted, expanded, and stored anywhere."
	icon_state = "eshield"
	force = 3
	throwforce = 3
	throw_speed = 3
	throw_range = 5
	w_class = 1
	origin_tech = "materials=4;magnets=3;syndicate=4"
	block_chance = list(melee = 60, bullet = 70, laser = 60, energy = 40) //Energy var is irrelevant as far as I'm concerned due to IsReflect() (correct me if I'm wrong - might be good against disablers?)
	force_deployed = 10

/obj/item/weapon/shield/deployable/energy/IsReflect()
	return (active)

/obj/item/weapon/shield/deployable/energy/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.disabilities & CLUMSY && prob(50))
		H << "<span class='warning'>You beat yourself in the head with [src].</span>"
		H.take_organ_damage(force)
	active = !active
	icon_state = "eshield[active]"

	if(active)
		block_chance = block_chance_deployed
		slowdown = slowdown_deployed
		force = force_deployed
		throwforce = 8
		throw_speed = 2
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 35, 1)
		user << "<span class='notice'>[src] is now active.</span>"
	else
		force = initial(force)
		throwforce = initial(throwforce)
		throw_speed = initial(throw_speed)
		w_class = initial(w_class)
		playsound(user, 'sound/weapons/saberoff.ogg', 35, 1)
		user << "<span class='notice'>[src] can now be concealed.</span>"
	add_fingerprint(user)

/obj/item/weapon/shield/deployable/tele
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "teleriot"
	slot_flags = null
	force = 3
	stamina_percentage = 0.75
	throwforce = 3
	throw_speed = 3
	throw_range = 4
	w_class = 3
	materials = list(MAT_GLASS=7500, MAT_METAL=1000)
	origin_tech = "materials=2"
	force_deployed = 8
	block_chance_deployed = list(melee = 50, bullet = 30, laser = 20, energy = 20)

/obj/item/weapon/shield/deployable/tele/hit_reaction(mob/owner, attack_text, final_block_chance)
	if(active)
		return ..()
	return 0

/obj/item/weapon/shield/deployable/tele/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.disabilities & CLUMSY && prob(50))
		H << "<span class='warning'>You beat yourself in the head with [src].</span>"
		H.take_organ_damage(force)
	active = !active
	icon_state = "teleriot[active]"
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)

	if(active)
		block_chance = block_chance_deployed
		slowdown = slowdown_deployed
		force = force_deployed
		stamina_percentage = 0.75
		throwforce = 5
		throw_speed = 2
		w_class = 4
		slot_flags = SLOT_BACK
		user << "<span class='notice'>You extend \the [src].</span>"
	else
		block_chance = initial(block_chance)
		slowdown = initial(slowdown)
		force = initial(force)
		throwforce = initial(throwforce)
		throw_speed = initial(throw_speed)
		w_class = initial(w_class)
		slot_flags = initial(slot_flags)
		user << "<span class='notice'>[src] can now be concealed.</span>"
	add_fingerprint(user)
