/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/current_target = null
	var/temporary = 0

/datum/martial_art/proc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/grab_reinforce_act(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D) //Called on reinforce grab
	return 0

/datum/martial_art/proc/grab_attack_act(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D) //Called on attack with the grab
	return 0

/datum/martial_art/proc/grab_process(obj/item/weapon/grab/G, mob/living/carbon/human/A, mob/living/carbon/human/D) //Called on grab process. Returning 1 will override it.
	return 0

/datum/martial_art/proc/tablepush_act(mob/living/carbon/human/A, mob/living/carbon/human/D) //Called when you tablepush someone
	return 0

/datum/martial_art/proc/add_to_streak(element,mob/living/carbon/human/A,mob/living/carbon/human/D)
	if(istype(D) && D != current_target)
		current_target = D
		streak = ""
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	if(istype(A))
		A.hud_used.combo_object.update_icon(streak)

/datum/martial_art/proc/basic_hit(mob/living/carbon/human/A,mob/living/carbon/human/D)
	A.do_attack_animation(D)
	var/damage = rand(0,9) + A.dna.species.punchmod
	var/atk_verb = A.dna.species.attack_verb
	if(D.lying)
		atk_verb = "kick"

	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")
	var/dmgcheck = D.apply_damage(damage, BRUTE, affecting, armor_block)
	if(!damage || !dmgcheck)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>")
		add_logs(A, D, "attempted to [atk_verb]")
		return 0

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)
	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
								"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>")

	add_logs(A, D, "punched")

	if((D.stat != DEAD) && damage >= 9)
		D.visible_message("<span class='danger'>[A] has weakened [D]!!</span>", \
								"<span class='userdanger'>[A] has weakened [D]!</span>")
		D.apply_effect(4, WEAKEN, armor_block)
		D.forcesay(hit_appends)
	else if(D.lying)
		D.forcesay(hit_appends)
	return 1

/datum/martial_art/proc/teach(mob/living/carbon/human/H,make_temporary=0)
	if(make_temporary)
		temporary = 1
	if(!temporary)
		if(H.martial_art_base)
			H.martial_art_base.remove(H) //Notify the user that his previous martial art was switched. Also updates verbs, etc.
		H.martial_art_base = src
	H.martial_art = src

/datum/martial_art/proc/remove(mob/living/carbon/human/H)
	if(H.martial_art != src && H.martial_art_base != src)
		return
	H.martial_art = H.martial_art_base
