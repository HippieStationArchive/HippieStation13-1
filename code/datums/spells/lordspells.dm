// Necrolord
/obj/effect/proc_holder/spell/targeted/trigger/soulflare
	name = "Soulflare"
	desc = "Deals high damage to an enemy in 3 different damage types, as well as paralyzing them for 5 seconds. If it hits an enemy in critical condition, it instantly kills them."
	school = "transmutation"
	charge_max = 300
	clothes_req = 1
	invocation = "NEKROSIS"
	invocation_type = "shout"
	message = "<span class='notice'>Your head feels like it's being burned as you fall to the ground!</span>"
	cooldown_min = 50 //12 deciseconds reduction per rank

	starting_spells = list("/obj/effect/proc_holder/spell/targeted/inflict_handler/soulflare")

	action_icon_state = "soulflare"

/obj/effect/proc_holder/spell/targeted/inflict_handler/soulflare
	amt_paralysis = 5
	amt_dam_fire = 15
	amt_dam_brute = 15
	amt_dam_tox = 15
	sound="sound/magic/Necrolord_Soulflare_Cast.ogg"

/obj/effect/proc_holder/spell/targeted/inflict_handler/soulflare/cast(list/targets, mob/user = usr)
	var/obj/effect/proc_holder/spell/targeted/trigger/soulflare/SF = locate(/obj/effect/proc_holder/spell/targeted/trigger/soulflare, user.mob_spell_list)
	var/mob/living/carbon/target = targets[1]
	if(target.health <= 0)
		target.adjustOxyLoss(500)
		user << "<span class='notice'>You've successfully killed [target], refunding your spell</span>"
		user << 'sound/magic/Necrolord_Soulflare_Crit.ogg'
		SF.charge_counter = 300
	..()

/obj/effect/proc_holder/spell/targeted/explodecorpse
	name = "Corpse Explosion"
	desc = "Explodes a corpse, in a very, very big and pretty explosion."
	school = "transmutation"
	charge_max = 200
	clothes_req = 1
	invocation = "BO'NES T'O BO'MS"
	invocation_type = "shout"
	cooldown_min = 10
	centcom_cancast = 0
	sound="sound/magic/Necrolord_Soulflare_Cast.ogg"

	action_icon_state = "raisedead"

/obj/effect/proc_holder/spell/targeted/explodecorpse/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/target = targets[1]
	if(target.stat & DEAD)
		message_admins("[user] casted corpse explosion on [target]")
		explosion(target,1,2,5)
		user << "<font color=purple><b>You redirect an absurd amount of energy into [target]'s corpse, causing it to violently explode!</font>"
	else
		user << "<span class='warning'>[target] isn't a dead corpse!</span>"
		charge_counter = 60

/obj/effect/proc_holder/spell/self/soulsplit
	name = "Soulsplit"
	desc = "Enter a wraith-like form, traveling at very high speeds and moving trough objects. However, maintaining this form requires you to be at full health to maintain concentration!"
	school = "transmutation"
	charge_max = 300
	clothes_req = 1
	centcom_cancast = 0
	invocation = "TRAVEL ME BONES"
	invocation_type = "shout"
	cooldown_min = 10

	action_icon_state = "soulsplit"

/obj/effect/proc_holder/spell/self/soulsplit/cast(list/targets, mob/living/user = usr)
	if(user.health >= 100)
		user << "<font color=purple><b>You enter your wraith form, leaving you vulnerable yet very maneuvreable.</font>"
		user.incorporeal_move = 2
		spawn(35)
			user << "<span class='warning'>Soulsplit wears off!"
			user.incorporeal_move = 0
	else
		user << "<span class='warning'>You cannot concentrate on casing soulsplit while injured!</span>"
		charge_counter = 300
