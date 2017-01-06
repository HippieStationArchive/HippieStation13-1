/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption
	name = "Eruption"
	desc = "Gradually set fire to <b>EVERYTHING</b> you can see, setting fire to yourself as well. The closer the fire is to the centre, the longer it lasts. In addition, you are also stunned (but not knocked down) for the duration of the spell. You should seriously consider getting a method to deal with the precarious situation of setting yourself on fire, with spells such as Ethereal Jaunt or the Wizard Hardsuit."

	school = "evocation"
	charge_max = 600
	clothes_req = 1
	invocation = "DIE, INSECT!"
	invocation_type = "shout"
	cooldown_min = 200

	summon_type = list(/obj/effect/hotspot)
	summon_amt = 225 //quite literally everything
	summon_ignore_prev_spawn_points = 1
	range = 1

	action_icon_state = "eruption"
	sound = "sound/magic/Fireball.ogg"

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/cast(list/targets,mob/user = usr)
	user.Stun(3)
	var/list/viewarea = view(range, usr)
	targets = list()
	for(var/turf/T in viewarea)
		targets += T
	..()
	visciouscycle()

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/proc/visciouscycle()
	if(range <= 6)
		sound = null
		invocation = null
		spawn(5)
			range += 1
			cast()
	else
		invocation = "DIE, INSECT!"
		sound = "sound/magic/Fireball.ogg"
		range = 1
		return
