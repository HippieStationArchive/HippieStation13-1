/obj/effect/proc_holder/changeling/digitalcamo
	name = "Digital Camouflage"
	desc = "By evolving the ability to distort our form and proprotions, we defeat common altgorithms used to detect lifeforms on cameras."
	helptext = "We cannot be tracked by camera or seen by AI units while using this skill. We must constantly expend chemicals to maintain our form like this."
	evopoints_cost = 2

//Prevents AIs tracking you
/obj/effect/proc_holder/changeling/digitalcamo/sting_action(mob/user)
	var/datum/changeling/changeling=user.mind.changeling
	if(user.digitalcamo)
		user << "<span class='notice'>We return to normal.</span>"
		user.digitalcamo = 0
		changeling.chem_recharge_slowdown -= 0.5
		return

	user << "<span class='notice'>We distort our form to hide from the AI</span>"
	user.digitalcamo = 1
	changeling.chem_recharge_slowdown += 0.5

	feedback_add_details("changeling_powers","CAM")
	return 1

/obj/effect/proc_holder/changeling/digitalcamo/on_refund(mob/user)
	user.digitalcamo = 0