/datum/martial_art/boxing
	name = "Boxing"
	priority = 10

/datum/martial_art/boxing/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A << "<span class='warning'> Can't disarm while boxing!</span>"
	A.changeNext_move(1) //So you're not fucked with delays
	return 1

/datum/martial_art/boxing/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A << "<span class='warning'> Can't grab while boxing!</span>"
	A.changeNext_move(1) //So you're not fucked with delays
	return 1

/datum/martial_art/boxing/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_logs(A, D, "punched")
	A.do_attack_animation(D)

	var/atk_verb = pick("left hook","right hook","straight punch")

	var/damage = rand(5,8)
	if(A.dna)
		damage += A.dna.species.punchmod
	if(!damage)
		if(A.dna)
			playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		else
			playsound(D.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			D.visible_message("<span class='warning'>[A] has attempted to hit [D] with a [atk_verb]!</span>")
			return 0


	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, pick("boxgloves"), 25, 1, -1)


	D.visible_message("<span class='danger'>[A] has hit [D] with a [atk_verb]!</span>", \
								"<span class='userdanger'>[A] has hit [D] with a [atk_verb]!</span>")

	D.apply_damage(damage, STAMINA, affecting, armor_block)
	if(D.getStaminaLoss() > 50)
		var/knockout_prob = D.getStaminaLoss() + rand(-15,15)
		if((D.stat != DEAD) && prob(knockout_prob))
			D.visible_message("<span class='danger'>[A] has knocked [D] out with a haymaker!</span>", \
								"<span class='userdanger'>[A] has knocked [D] out with a haymaker!</span>")
			D.apply_effect(10,WEAKEN,armor_block)
			D.SetSleeping(5)
			D.forcesay(hit_appends)
		else if(D.lying)
			D.forcesay(hit_appends)
	return 1
