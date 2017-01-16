/obj/effect/proc_holder/spell/targeted/jesus_btw
	name = "Miracle: Blood To Wine!"
	desc = "This miracle turns blood into wine, leaving anybody nearby extremely intoxicated and unable to fight for a few minutes."
	clothes_req = 0
	max_targets = 0
	range = 7
	panel = "Miracles"
	charge_max = 600
	invocation_type = "none"


/obj/effect/proc_holder/spell/targeted/jesus_btw/cast(list/targets,mob/user = usr)

	for(var/mob/living/carbon/human/target in targets)
		var/kotime = 0
		var/dist = range-get_dist(user,target)
		target.Dizzy(15)
		if(target.reagents)
			target.reagents.add_reagent("wine",rand(25,100))
		if(prob(100*dist/range))
			kotime = rand(10,60)
			spawn(kotime)
				target.apply_effect(rand(5,20), PARALYZE)

/obj/effect/proc_holder/spell/targeted/jesus_revive
	name = "Miracle: Ressurection!"
	desc = "After a short channeling period, this miracle brings a target back from the dead."
	clothes_req = 0
	max_targets = 1
	range = 1
	panel = "Miracles"
	charge_max = 400
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/jesus_revive/cast(list/targets,mob/user = usr)

	for(var/mob/living/carbon/human/target in targets)
		if(target.stat == DEAD)
			target.notify_ghost_cloning("[user] the Messiah is attempting to give you life. Re-enter your corpse if you want to be revived!")
			if(do_mob(user,target,80))
				target.revive()
		else
			user << "Ressurection only works on the dead!"

/obj/effect/proc_holder/spell/targeted/jesus_revive/cure
	name = "Miracle: Heal The Sick!"
	desc = "With the power of this miracle, Jesus can return any living being to full health and will remove any disease or mutation affecting the target."
	range = 7
	charge_max = 200

/obj/effect/proc_holder/spell/targeted/jesus_revive/cure/cast(list/targets,mob/user = usr)

	for(var/mob/living/carbon/human/target in targets)
		if(target.stat != DEAD)
			target.apply_effect(8, PARALYZE)
			target.revive()
		else
			user << "Use Ressurection to bring somebody back to life!"

/obj/effect/proc_holder/spell/targeted/jesus_deconvert
	name = "Miracle: Repent for your Sins!"
	desc = "After channeling for two minutes, this miracle will show any sinner the righteous path, removing their antagonist status."
	clothes_req = 0
	max_targets = 1
	range = 1
	panel = "Miracles"
	charge_max = 6000
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/jesus_deconvert/cast(list/targets,mob/user = usr)

	for(var/mob/living/carbon/human/target in targets)
		if(target.stat != DEAD || target.mind)
			var/is_antag = target.mind.special_role
			if(do_mob(user,target,400))
				if(is_antag)
					target << "<span class='danger'>You remain unwavering in your evil ways!</span>"
				if(do_mob(user,target,400))
					if(is_antag)
						target << "<span class='danger'>But this [user.name] guy is pretty convincing...</span>"
					if(do_mob(user,target,400) && is_antag)
						target << "<span class='userdanger'>You finally see the light! You are no longer an antagonist thanks to [user.name] the Messiah and may live a sin-free life!</span>"
						target.mind.remove_all_antag()
						message_admins("[target]/([target.ckey]) has had their antagonist status removed by [user]/([user.ckey]) the Messiah.")
						user << "You feel the deep sin within [target.name] slowly fade away"
					else
						target << "You feel refreshed as you are freed of the sins of your past."
		else
			user << "Only those alive in body and mind may repent!"


/obj/effect/proc_holder/spell/aoe_turf/knock/jesus

	name = "Miracle: Parting Waves"
	desc = "Once used to split the very ocean in two, this miracle is now relegated to opening airlocks. Extremely useful."
	invocation_type = "none"
	panel = "Miracles"
