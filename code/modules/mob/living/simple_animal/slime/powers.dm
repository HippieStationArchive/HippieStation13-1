/mob/living/simple_animal/slime/verb/Feed()
	set category = "Slime"
	set desc = "This will let you feed on any valid creature in the surrounding area. This should also be used to halt the feeding process."

	if(stat)
		return 0

	var/list/choices = list()
	for(var/mob/living/C in view(1,src))
		if(C!=src && Adjacent(C))
			choices += C

	var/mob/living/M = input(src,"Who do you wish to feed on?") in null|choices
	if(!M) return 0
	if(CanFeedon(M))
		Feedon(M)
		return 1

/mob/living/simple_animal/slime/proc/CanFeedon(mob/living/M)
	if(!Adjacent(M))
		return 0

	if(buckled)
		Feedstop()
		return 0

	if(isslime(M))
		src << "<span class='warning'><i>I can't latch onto another slime...</i></span>"
		return 0

	if(docile)
		src << "<span class='notice'><i>I'm not hungry anymore...</i></span>"
		return 0

	if(stat)
		src << "<span class='warning'><i>I must be conscious to do this...</i></span>"
		return 0

	if(M.stat == DEAD)
		src << "<span class='warning'><i>This subject does not have a strong enough life energy...</i></span>"
		return 0

	if(isslime(M.buckled_mob))
		src << "<span class='warning'><i>Another slime is already feeding on this subject...</i></span>"
		return 0
	return 1

/mob/living/simple_animal/slime/proc/Feedon(mob/living/M)
	if(M.buckle_mob(src, force=1))
		M.visible_message("<span class='danger'>The [name] has latched onto [M]!</span>", \
						"<span class='userdanger'>The [name] has latched onto [M]!</span>")
	else
		src << "<span class='warning'><i>I have failed to latch onto the subject</i></span>"

/mob/living/simple_animal/slime/proc/Feedstop(silent=0)
	if(buckled)
		if(!silent)
			visible_message("<span class='warning'>[src] has let go of [buckled]!</span>", \
							"<span class='notice'><i>I stopped feeding.</i></span>")
		buckled.unbuckle_mob(force=1)

/mob/living/simple_animal/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return
	if(!is_adult)
		if(amount_grown >= 10)
			is_adult = 1
			maxHealth = 200
			amount_grown = 0
			regenerate_icons()
			name = text("[colour] [is_adult ? "adult" : "baby"] slime ([number])")
		else
			src << "<i>I am not ready to evolve yet...</i>"
	else
		src << "<i>I have already evolved...</i>"

/mob/living/simple_animal/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes."

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return

	if(is_adult)
		if(amount_grown >= 10)
			if(stat)
				src << "<i>I must be conscious to do this...</i>"
				return

			var/list/babies = list()
			var/new_nutrition = round(nutrition * 0.9)
			var/new_powerlevel = round(powerlevel / 4)
			for(var/i=1,i<=4,i++)
				var/mob/living/simple_animal/slime/M = new /mob/living/simple_animal/slime/(loc)
				if(mutation_chance >= 100)
					M.colour = "rainbow"
				else if(prob(mutation_chance))
					M.colour = slime_mutation[rand(1,4)]
				else
					M.colour = colour
				if(ckey)	M.nutrition = new_nutrition //Player slimes are more robust at spliting. Once an oversight of poor copypasta, now a feature!
				M.powerlevel = new_powerlevel
				if(i != 1) step_away(M,src)
				M.Friends = Friends.Copy()
				babies += M
				M.mutation_chance = Clamp(mutation_chance+(rand(5,-5)),0,100)
				feedback_add_details("slime_babies_born","slimebirth_[replacetext(M.colour," ","_")]")

			var/mob/living/simple_animal/slime/new_slime = pick(babies)
			new_slime.a_intent = "harm"
			new_slime.languages = languages
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			src << "<i>I am not ready to reproduce yet...</i>"
	else
		src << "<i>I am not old enough to reproduce yet...</i>"