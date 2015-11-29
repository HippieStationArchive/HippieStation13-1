/obj/effect/proc_holder/changeling/synaptic_enhancement //Synaptic Enhancement; allows changelings to attack faster
	name = "Synaptic Enhancement"
	desc = "We redirect mental pathways to devote more energy to muscle movement."
	helptext = "The delay between attacks and actions will be halved. We must constantly expend chemicals to maintain our form like this."
	evopoints_cost = 5
	req_dna = 6 //Tier 3
	chemical_cost = 30
	var/active = FALSE

/obj/effect/proc_holder/changeling/synaptic_enhancement/sting_action(mob/user)
	var/datum/changeling/changeling=user.mind.changeling
	active = !active
	user << "<span class='notice'>We [active ? "quicken our mind, this will completely halt chemical regeneration when active" : "return to normal"].</span>"
	if(active)
		user.next_move_modifier = 0.5
		changeling.chem_recharge_slowdown += 1
		user << "<span class='notice'>Use this power again to return to our original voice and return chemical production to normal levels.</span>"
	else
		user.next_move_modifier = initial(user.next_move_modifier)
		changeling.chem_recharge_slowdown -= 1
		return

	feedback_add_details("changeling_powers","SE")
	return 1

/obj/effect/proc_holder/changeling/synaptic_enhancement/on_refund(mob/user)
	user.next_move_modifier = initial(user.next_move_modifier)
