/obj/effect/proc_holder/changeling/synaptic_enhancement //Synaptic Enhancement; allows changelings to attack faster
	name = "Synaptic Enhancement"
	desc = "We redirect mental pathways to devote more energy to muscle movement."
	helptext = "The delay between attacks and actions will be halved. This will halt our chemical regeneration."
	evopoints_cost = 6 //Reduced the cost for it to see more use, 8 points was a tad too much
	req_dna = 6 //Tier 3
	chemical_cost = 30
	var/active = 0

/obj/effect/proc_holder/changeling/synaptic_enhancement/sting_action(mob/user)
	var/datum/changeling/changeling=user.mind.changeling
	if(!active)
		user << "<span class='notice'>We quicken our mind, this will completely halt chemical regeneration when active.</span>"
		user << "<span class='notice'>Use this power again to return to our original voice and return chemical production to normal levels.</span>"
		active = 1
		changeling.chem_recharge_slowdown += changeling.chem_recharge_rate
		user.next_move_modifier /= 2
		feedback_add_details("changeling_powers","SE")
	else
		active = 0
		user.next_move_modifier = initial(user.next_move_modifier)
		changeling.chem_recharge_slowdown -= changeling.chem_recharge_rate//Restore the slowdown to normal
		user << "<span class='notice'>We return to normal.</span>"
	return 1

/obj/effect/proc_holder/changeling/synaptic_enhancement/take_chemical_cost(datum/changeling/changeling)
	..() //They've already paid
	if(active) //Refund is hardly working
		chemical_cost = 0
	else
		chemical_cost = 30

/obj/effect/proc_holder/changeling/synaptic_enhancement/on_refund(mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	user.next_move_modifier = initial(user.next_move_modifier)
	if(active)
		changeling.chem_recharge_slowdown -= changeling.chem_recharge_rate