/obj/effect/proc_holder/changeling/synaptic_enhancement //Synaptic Enhancement; allows changelings to attack faster
	name = "Synaptic Enhancement"
	desc = "We redirect mental pathways to devote more energy to muscle movement."
	helptext = "The delay between attacks and actions will be halved. This will halt our chemical regeneration."
	evopoints_cost = 8 //This is a VERY powerful lil piece of shit, especially if you use it in conjunction with a high-damage weapon.
	req_dna = 6 //Tier 3
	chemical_cost = 0 //Chemical cost is hardcoded
	var/active = FALSE

/obj/effect/proc_holder/changeling/synaptic_enhancement/sting_action(mob/user)
	var/datum/changeling/changeling=user.mind.changeling
	if(!active)
		if(chemical_cost <= 30) //Hardcoded chem cost
			user << "<span class='warning'>We require at least 30 units to do that!</span>"
			return
		active = 1
		changeling.chem_storage -= 30
		user.next_move_modifier = 0.5
		changeling.chem_recharge_slowdown += changeling.chem_recharge_rate //Reduces chemical always, regardless of glands
		user << "<span class='notice'>We quicken our mind, this will completely halt chemical regeneration when active.</span>"
		user << "<span class='notice'>Use this power again to return to our original voice and return chemical production to normal levels.</span>"
	else
		active = 0
		user.next_move_modifier = initial(user.next_move_modifier)
		changeling.chem_recharge_slowdown -= changeling.chem_recharge_rate //Restore the slowdown to normal
		user << "<span class='notice'>We return to normal.</span>"
		return

	feedback_add_details("changeling_powers","SE")
	return 1

/obj/effect/proc_holder/changeling/synaptic_enhancement/on_refund(mob/user)
	user.next_move_modifier = initial(user.next_move_modifier)