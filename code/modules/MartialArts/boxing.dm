/datum/martial_art/boxing
	name = "Boxing"
	priority = 10

/datum/martial_art/boxing/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A << "<span class='warning'>Can't disarm while boxing!</span>"
	A.changeNext_move(1) //So you're not fucked with delays
	return 1

/datum/martial_art/boxing/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A << "<span class='warning'>Can't grab while boxing!</span>"
	A.changeNext_move(1) //So you're not fucked with delays
	return 1

/datum/martial_art/boxing/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)

	var/atk_verb = pick("left hook","right hook","straight punch")

	var/damage = rand(5,8)
	//No unfair species advantage when boxing pls!
	// if(A.dna)
	// 	damage += A.dna.species.punchmod
	if(!damage)
		add_logs(A, D, "attempted to box")
		if(A.dna)
			playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		else
			playsound(D.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			D.visible_message("<span class='warning'>[A] has attempted to hit [D] with a [atk_verb]!</span>")
			return 0


	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")
	var/zonebias = affecting.name == "chest" ? 20 : 0
	var/knockout_prob = (D.getStaminaLoss() / 2) + zonebias
	var/staminacap = 50

	playsound(D.loc, pick("boxgloves"), 25, 1, -1)

	damage += affecting.name == "head" ? rand(0, 2) : 0
	if(affecting.name == "head")
		if(A.zone_sel.selecting == "eyes")
			staminacap = 30 //Lesser damage cap, you're hitting someone right between their eyes right?
			knockout_prob += 5 //Slightly higher knockout chance when aiming for the eyes
			atk_verb = "jab"
		else if(A.zone_sel.selecting == "mouth")
			atk_verb = "uppercut"
	D.apply_damage(damage, STAMINA, affecting, armor_block)
	if(D.getStaminaLoss() > staminacap && affecting.name in list("head", "chest")) //So you can't knock someone out with a haymaker to the arm.
		if((D.stat != DEAD) && prob(knockout_prob))
			if(affecting.name == "head") //Head stun is harder to score but causes longer stun, just like normal combat
				D.visible_message("<span class='danger'>[A] has knocked [D] out with \an [atk_verb]!</span>", \
									"<span class='userdanger'>[A] has knocked [D] out with \an [atk_verb]!</span>")
				D.apply_effect(20, PARALYZE, armor_block)
				add_logs(A, D, "uppercut", addition="(boxing)")
			else
				D.visible_message("<span class='danger'>[A] has knocked [D] out with a haymaker!</span>", \
								"<span class='userdanger'>[A] has knocked [D] out with a haymaker!</span>")
				D.apply_effect(10,WEAKEN,armor_block)
				D.SetSleeping(5)
				add_logs(A, D, "knocked out", addition="(boxing)")
			D.forcesay(hit_appends)
			return 1
		else if(D.lying)
			D.forcesay(hit_appends)

	D.visible_message("<span class='danger'>[A] has hit [D] with \an [atk_verb] in \the [affecting.getDisplayName()]!</span>", \
								"<span class='userdanger'>[A] has hit [D] with \an [atk_verb] in \the [affecting.getDisplayName()]!</span>")
	add_logs(A, D, "boxed")
	return 1
