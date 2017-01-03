/obj/effect/proc_holder/spell/targeted/trigger/eruptionmulti
	name = "Eruption"
	desc = "Gradually set fire to <b>EVERYTHING</b> you can see, setting fire to yourself as well. The closer the fire is to the centre, the longer it lasts. In addition, you are also stunned (but not knocked down) for the duration of the spell. You should seriously consider getting a method to deal with the precarious situation of setting yourself on fire, with spells such as Ethereal Jaunt or the Wizard Hardsuit."

	school = "evocation"
	charge_max = 600
	clothes_req = 1
	invocation = "DIE, INSECT!"
	invocation_type = "shout"
	cooldown_min = 200
	include_user = 1

	action_icon_state = "eruption"
	sound = "sound/magic/Fireball.ogg"

/obj/effect/proc_holder/spell/targeted/trigger/eruptionmulti/cast(list/targets,mob/user = usr)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage1/stage1 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage1(loc)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage2/stage2 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage2(loc)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage3/stage3 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage3(loc)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage4/stage4 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage4(loc)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage5/stage5 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage5(loc)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage6/stage6 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage6(loc)
	var/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage7 = new /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption(loc)
	stage1.perform(targets, 1, user)
	spawn(4)
		stage2.perform(targets, 1, user)
	spawn(8)
		stage3.perform(targets, 1, user)
	spawn(12)
		stage4.perform(targets, 1, user)
		world << "[targets.len]"
	spawn(16)
		stage5.perform(targets, 1, user)
		world << "[targets.len]"
	spawn(20)
		stage6.perform(targets, 1, user)
		world << "[targets.len]"
	spawn(24)
		stage7.perform(targets, 1, user)
		world << "[targets.len]"

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption
	name = "Eruption"
	desc = "Sets fire to <b>EVERYTHING</b> you can see, setting fire to yourself as well. You should seriously consider getting a method to deal with the precarious situation of setting yourself on fire, such as Ethereal Jaunt and the Wizard Hardsuit."

	school = "evocation"
	charge_max = 400
	clothes_req = 1
	cooldown_min = 200

	action_icon_state = "eruption"
	sound = "sound/magic/Fireball.ogg"

	summon_type = list(/obj/effect/hotspot)
	summon_amt = 225 //quite literally everything
	summon_ignore_prev_spawn_points = 1
	range = 7

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage1
	range = 1

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage2
	range = 2

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage3
	range = 3

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage4
	range = 4

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage5
	range = 5

/obj/effect/proc_holder/spell/aoe_turf/conjure/eruption/stage6
	range = 6