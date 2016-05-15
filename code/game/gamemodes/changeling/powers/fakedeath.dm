/obj/effect/proc_holder/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We fall into a stasis, allowing us to regenerate and trick our enemies."
	chemical_cost = 15
	evopoints_cost = 0
	req_dna = 1
	req_stat = DEAD
	max_genetic_damage = 100


//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/obj/effect/proc_holder/changeling/fakedeath/sting_action(mob/living/user)
	user << "<span class='notice'>We begin our stasis, preparing energy to arise once more.</span>"
	user.status_flags |= FAKEDEATH		//play dead
	user.update_canmove()
	if(user.stat != DEAD)
		user.emote("deathgasp")
		user.death(0) //Actually die
		user.tod = worldtime2text()
	spawn(LING_FAKEDEATH_TIME)
		if(user && user.mind && user.mind.changeling && user.mind.changeling.purchasedpowers)
			user << "<span class='notice'>We are ready to regenerate.</span>"
			user.mind.changeling.purchasedpowers += new /obj/effect/proc_holder/changeling/revive(null)
	feedback_add_details("changeling_powers","FD")
	return 1

/obj/effect/proc_holder/changeling/fakedeath/can_sting(mob/user)
	if(isobj(user.loc))
		user << "<span class='warning'>We cannot regenerate while inside an object.</span>"
		return
	if(user.status_flags & FAKEDEATH)
		user << "<span class='warning'>We are already regenerating.</span>"
		return
	if(user.stat != DEAD) //Confirmation for living changelings if they want to fake their death
		switch(alert("Are we sure we wish to fake our own death?",,"Yes", "No"))
			if("No")
				return
	return ..()