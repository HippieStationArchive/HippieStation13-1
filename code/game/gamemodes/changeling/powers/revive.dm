/obj/effect/proc_holder/changeling/revive
	name = "Regenerate"
	desc = "We regenerate, healing all damage from our form."
	req_stat = DEAD

//Revive from revival stasis
/obj/effect/proc_holder/changeling/revive/sting_action(mob/living/carbon/user)
	user.revive()
	user << "<span class='notice'>We have regenerated.</span>"
	user.mind.changeling.purchasedpowers -= src
	feedback_add_details("changeling_powers","CR")
	return 1
