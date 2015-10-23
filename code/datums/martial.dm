/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/current_target = null
	var/temporary = 0
	var/datum/martial_art/base = null // The permanent style

/datum/martial_art/proc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/add_to_streak(element,mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	return

/datum/martial_art/proc/basic_hit(mob/living/carbon/human/A,mob/living/carbon/human/D)

	A.do_attack_animation(D)
	var/damage = rand(0,9) + A.dna.species.punchmod

	var/atk_verb = A.dna.species.attack_verb
	if(D.lying)
		atk_verb = "kick"

	if(!damage)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>")
		add_logs(A, D, "attempted to [atk_verb]")
		return 0

	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)
	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
								"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>")

	D.apply_damage(damage, BRUTE, affecting, armor_block)

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
	if(H.martial_art && H.martial_art.temporary)
		if(temporary)
			base = H.martial_art.base
		else
			H.martial_art.base = src //temporary styles have priority
			return
	H.martial_art = src

/datum/martial_art/proc/remove(mob/living/carbon/human/H)
	if(H.martial_art != src)
		return
	H.martial_art = base

/datum/martial_art/boxing
	name = "Boxing"

/datum/martial_art/boxing/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A << "<span class='warning'>Can't disarm while boxing!</span>"
	return 1

/datum/martial_art/boxing/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A << "<span class='warning'>Can't grab while boxing!</span>"
	return 1

/datum/martial_art/boxing/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)

	A.do_attack_animation(D)

	var/atk_verb = pick("left hook","right hook","straight punch")

	var/damage = rand(5,8) + A.dna.species.punchmod
	if(!damage)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to hit [D] with a [atk_verb]!</span>")
		add_logs(A, D, "attempted to hit", atk_verb)
		return 0


	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)

	D.visible_message("<span class='danger'>[A] has hit [D] with a [atk_verb]!</span>", \
								"<span class='userdanger'>[A] has hit [D] with a [atk_verb]!</span>")

	D.apply_damage(damage, STAMINA, affecting, armor_block)
	add_logs(A, D, "punched")
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

/datum/martial_art/wrestling
	name = "Wrestling"

/datum/martial_art/wrestling/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.grabbedby(A,1)
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G && prob(50))
		G.state = GRAB_AGGRESSIVE
		D.visible_message("<span class='danger'>[A] has [D] in a clinch!</span>", \
								"<span class='userdanger'>[A] has [D] in a clinch!</span>")
	else
		D.visible_message("<span class='danger'>[A] fails to get [D] in a clinch!</span>", \
								"<span class='userdanger'>[A] fails to get [D] in a clinch!</span>")
	return 1


/datum/martial_art/wrestling/proc/Suplex(mob/living/carbon/human/A, mob/living/carbon/human/D)

	D.visible_message("<span class='danger'>[A] suplexes [D]!</span>", \
								"<span class='userdanger'>[A] suplexes [D]!</span>")
	D.forceMove(A.loc)
	var/armor_block = D.run_armor_check(null, "melee")
	D.apply_damage(30, BRUTE, null, armor_block)
	D.apply_effect(6, WEAKEN, armor_block)
	add_logs(A, D, "suplexed")

	A.SpinAnimation(10,1)

	D.SpinAnimation(10,1)
	spawn(3)
		armor_block = A.run_armor_check(null, "melee")
		A.apply_effect(4, WEAKEN, armor_block)
	return

/datum/martial_art/wrestling/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(istype(A.get_inactive_hand(),/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = A.get_inactive_hand()
		if(G.affecting == D)
			Suplex(A,D)
			return 1
	harm_act(A,D)
	return 1

/datum/martial_art/wrestling/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.grabbedby(A,1)
	D.visible_message("<span class='danger'>[A] holds [D] down!</span>", \
								"<span class='userdanger'>[A] holds [D] down!</span>")
	var/obj/item/organ/limb/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(10, STAMINA, affecting, armor_block)
	return 1

#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define PLASMA_COMBO "HDDDH"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"

/datum/martial_art/plasma_fist/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,TORNADO_COMBO))
		streak = ""
		Tornado(A,D)
		return 1
	if(findtext(streak,THROWBACK_COMBO))
		streak = ""
		Throwback(A,D)
		return 1
	if(findtext(streak,PLASMA_COMBO))
		streak = ""
		Plasma(A,D)
		return 1
	return 0

/datum/martial_art/plasma_fist/proc/Tornado(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.say("TORNADO SWEEP!")
	spawn(0)
		for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
			A.dir = i
			playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1, -1)
			sleep(1)
	var/obj/effect/proc_holder/spell/aoe_turf/repulse/R = new(null)
	var/list/turfs = list()
	for(var/turf/T in range(1,A))
		turfs.Add(T)
	R.cast(turfs)
	return

/datum/martial_art/plasma_fist/proc/Throwback(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] has hit [D] with Plasma Punch!</span>", \
								"<span class='userdanger'>[A] has hit [D] with Plasma Punch!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 200, 4,A)
	A.say("HYAH!")
	return

/datum/martial_art/plasma_fist/proc/Plasma(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.do_attack_animation(D)
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	A.say("PLASMA FIST!")
	D.visible_message("<span class='danger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>", \
								"<span class='userdanger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>")
	var/obj/item/organ/internal/brain/B = D.getorgan(/obj/item/organ/internal/brain)
	if(B)
		B.loc = get_turf(D)
		B.transfer_identity(D)
		D.internal_organs -= B
	D.gib()
	return

/datum/martial_art/plasma_fist/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/plasma_fist/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/plasma_fist/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G")
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1


//Used by the gang of the same name. Uses combos. Basic attacks bypass armor and never miss
#define WRIST_WRENCH_COMBO "DD"
#define BACK_KICK_COMBO "HG"
#define STOMACH_KNEE_COMBO "GH"
#define HEAD_KICK_COMBO "DHH"
#define ELBOW_DROP_COMBO "HDHDH"
/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"

/datum/martial_art/the_sleeping_carp/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,WRIST_WRENCH_COMBO))
		streak = ""
		wristWrench(A,D)
		return 1
	if(findtext(streak,BACK_KICK_COMBO))
		streak = ""
		backKick(A,D)
		return 1
	if(findtext(streak,STOMACH_KNEE_COMBO))
		streak = ""
		kneeStomach(A,D)
		return 1
	if(findtext(streak,HEAD_KICK_COMBO))
		streak = ""
		headKick(A,D)
		return 1
	if(findtext(streak,ELBOW_DROP_COMBO))
		streak = ""
		elbowDrop(A,D)
		return 1
	return 0

/datum/martial_art/the_sleeping_carp/proc/wristWrench(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.stunned && !D.weakened)
		D.visible_message("<span class='warning'>[A] grabs [D]'s wrist and wrenches it sideways!</span>", \
						  "<span class='userdanger'>[A] grabs your wrist and violently wrenches it to the side!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.drop_item()
		D.apply_damage(5, BRUTE, pick("l_arm", "r_arm"))
		D.Stun(2)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/backKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A.dir == D.dir && !D.stat && !D.weakened)
		D.visible_message("<span class='warning'>[A] kicks [D] in the back!</span>", \
						  "<span class='userdanger'>[A] kicks you in the back, making you stumble and fall!</span>")
		step_to(D,get_step(D,D.dir),1)
		D.Weaken(4)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/kneeStomach(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		D.visible_message("<span class='warning'>[A] knees [D] in the stomach!</span>", \
						  "<span class'userdanger'>[A] winds you with a knee in the stomach!</span>")
		D.audible_message("<b>[D]</b> gags!")
		D.losebreath += 3
		D.Stun(1)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/headKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		D.visible_message("<span class='warning'>[A] kicks [D] in the head!</span>", \
						  "<span class='userdanger'>[A] kicks you in the jaw!</span>")
		D.apply_damage(20, BRUTE, "head")
		D.drop_item()
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 75, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/elbowDrop(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(D.weakened || D.resting || D.stat)
		D.visible_message("<span class='warning'>[A] elbow drops [D]!</span>", \
						  "<span class='userdanger'>[A] piledrives you with their elbow!</span>")
		if(D.stat)
			D.death() //FINISH HIM!
		D.apply_damage(50, BRUTE, "chest")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 100, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G")
	if(check_streak(A,D))
		return 1
	..()
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE //Instant aggressive grab

/datum/martial_art/the_sleeping_carp/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H")
	if(check_streak(A,D))
		return 1
	D.visible_message("<span class='danger'>[A] [pick("punches", "kicks", "chops", "hits", "slams")] [D]!</span>", \
					  "<span class='userdanger'>[A] hits you!</span>")
	D.apply_damage(10, BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
	return 1


/datum/martial_art/the_sleeping_carp/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D")
	if(check_streak(A,D))
		return 1
	return ..()

/mob/living/carbon/human/proc/sleeping_carp_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Sleeping Carp"

	usr << "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>"
	usr << "<span class='notice'>Wrist Wrench</span>: Disarm Disarm. Forces opponent to drop item in hand."
	usr << "<span class='notice'>Back Kick</span>: Harm Grab. Opponent must be facing away. Knocks down."
	usr << "<span class='notice'>Stomach Knee</span>: Grab Harm. Knocks the wind out of opponent and stuns."
	usr << "<span class='notice'>Head Kick</span>: Disarm Harm Harm. Decent damage, forces opponent to drop item in hand."
	usr << "<span class='notice'>Elbow Drop</span>: Harm Disarm Harm Disarm Harm. Opponent must be on the ground. Deals huge damage, instantly kills anyone in critical condition."

//Used by special forces, developed by The Boss and Naked Snake. Uses combos. Basic attacks bypass armor and never miss
#define Cqc3_COMBO "HHH"
/datum/martial_art/cqc
	name = "CQC"

/datum/martial_art/cqc/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,Cqc3_COMBO))
		streak = ""
		Cqc3(A,D)
		return 1
	if(streak != "")
		switch(streak)
			if("leg_sweep")
				streak = ""
				leg_sweep(A,D)
				return 1
			if("quick_choke")
				streak = ""
				quick_choke(A,D)
				return 1
		return 0
	return 0

/datum/martial_art/cqc/teach(var/mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You know the basics of CQC!</span>"
	H << "<span class = 'danger'>Recall your teachings using the Recall Training verb in the CQC menu, in your verbs menu.</span>"
	H.verbs += /mob/living/carbon/human/proc/cqc_help
	H.verbs += /mob/living/carbon/human/proc/leg_sweep
	H.verbs += /mob/living/carbon/human/proc/quick_choke

/datum/martial_art/cqc/remove(var/mob/living/carbon/human/H)
	..()
	H << "<span class = 'userdanger'>You forget the basics of CQC..</span>"
	H.verbs -= /mob/living/carbon/human/proc/cqc_help
	H.verbs -= /mob/living/carbon/human/proc/leg_sweep
	H.verbs -= /mob/living/carbon/human/proc/quick_choke

/datum/martial_art/cqc/proc/Cqc3(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.stunned && !D.weakened)
		D.visible_message("<span class='warning'>[A] sweeps [D]'s foot and makes them fall!</span>", \
						  "<span class='userdanger'>[A] sweeps your foot and you fall!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.drop_item()
		D.apply_damage(5, BRUTE, pick("l_leg", "r_leg"))
		D.Weaken(2)

/datum/martial_art/cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='warning'>[A] grapples [D]!</span>", \
						  "<span class='userdanger'>[A] grapples you!</span>")
	..()
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE
		playsound(get_turf(D), 'sound/weapons/grapple.ogg', 50, 1, -1)
		D.Stun(2)

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	add_to_streak("H")
	add_logs(A, D, "punched")
	A.do_attack_animation(D)
	D.visible_message("<span class='danger'>[A] [pick("punches", "strikes", "chops", "hits")] [D]!</span>", \
					  "<span class='userdanger'>[A] hits you!</span>")
	D.apply_damage(10, BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
	return 1

/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
		D.visible_message("<span class='warning'>[A] slams [D] onto the ground!</span>", \
						  "<span class='userdanger'>[A] slams you onto the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/judoslam.ogg', 50, 1, -1)
		D.drop_item()
		D.apply_damage(15, BRUTE, pick("chest"))
		D.Weaken(3)
		A.Stun(3)
		return 1

/mob/living/carbon/human/proc/cqc_help()
	set name = "Recall Training"
	set desc = "Try to remember some the basics of cqc."
	set category = "CQC"

	usr << "<b><i>You remember the training from your former mentor...</i></b>"
	usr << "<span class='notice'>Three Hit Combo</span>: Harm Harm Harm. Drops the opponent."
	usr << "<span class='notice'>Judo Slam</span>: Disarm. Slams the opponent on the ground, at the cost of limited mobility."
	usr << "<span class='notice'>Quick Choke</span>:Mutes and Deprives the opponent of oxygen for a short time, but at the cost of limited mobility"
	usr << "<span class='notice'>Leg Sweep</span>:Knocks an enemy down, doesn't do much damage."




/datum/martial_art/cqc/proc/leg_sweep(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(D.stat || D.weakened)
		return 0
	D.visible_message("<span class='warning'>[A] leg sweeps [D]!</span>", \
					  	"<span class='userdanger'>[A] leg sweeps you!</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.Weaken(1)
	A.Stun(2)
	return 1

/datum/martial_art/cqc/proc/quick_choke(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='warning'>[A] grabs and chokes [D]!</span>", \
				  	"<span class='userdanger'>[A] grabs and chokes you!</span>")
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, 1, -1)
	D.losebreath += 5
	D.adjustOxyLoss(15)
	D.silent += 6
	A.Stun(3)

	return 1

/mob/living/carbon/human/proc/leg_sweep()
	set name = "Leg Sweep"
	set desc = "Sets your next move to the Leg Sweep."
	set category = "CQC"
	usr << "<b><i>Your next attack will be a Leg Sweep.</i></b>"
	martial_art.streak = "leg_sweep"

/mob/living/carbon/human/proc/quick_choke()
	set name = "Quick Choke"
	set desc = "Sets your next move to the Quick Choke."
	set category = "CQC"
	usr << "<b><i>Your next attack will be a Quick Choke.</i></b>"
	martial_art.streak = "quick_choke"

//ITEMS

/obj/item/clothing/gloves/boxing
	var/datum/martial_art/boxing/style = new

/obj/item/clothing/gloves/boxing/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_gloves)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

/obj/item/clothing/gloves/boxing/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_gloves) == src)
		style.remove(H)
	return

/obj/item/weapon/storage/belt/champion/wrestling
	name = "Wrestling Belt"
	var/datum/martial_art/wrestling/style = new

/obj/item/weapon/storage/belt/champion/wrestling/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_belt)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

/obj/item/weapon/storage/belt/champion/wrestling/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_belt) == src)
		style.remove(H)
	return

/obj/item/weapon/plasma_fist_scroll
	name = "frayed scroll"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	var/used = 0

/obj/item/weapon/plasma_fist_scroll/attack_self(mob/user)
	if(!ishuman(user))
		return
	if(!used)
		var/mob/living/carbon/human/H = user
		var/datum/martial_art/plasma_fist/F = new/datum/martial_art/plasma_fist(null)
		F.teach(H)
		H << "<span class='boldannounce'>You have learned the ancient martial art of Plasma Fist.</span>"
		used = 1
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"

/obj/item/weapon/sleeping_carp_scroll
	name = "mysterious scroll"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of martial art."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"

/obj/item/weapon/sleeping_carp_scroll/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	user << "<span class='notice'>You begin to read the scroll...</span>"
	user << "<span class='sciradio'><i>And all at once the secrets of the Sleeping Carp fill your mind. The ancient clan's martial teachings have been imbued into this scroll. As you read through it, \
 	these secrets flood into your mind and body.<br>You now know the martial techniques of the Sleeping Carp. Your hand-to-hand combat has become much more effective, and you may now perform powerful \
 	combination attacks.<br>To learn more about these combos, use the Recall Teachings ability in the Sleeping Carp tab.</i></span>"
	user.verbs += /mob/living/carbon/human/proc/sleeping_carp_help
	var/datum/martial_art/the_sleeping_carp/theSleepingCarp = new(null)
	theSleepingCarp.teach(user)
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/obj/item/weapon/twohanded/bostaff
	name = "bo staff"
	desc = "A long, tall staff made of polished wood. Traditionally used in ancient old-Earth martial arts. Can be wielded to both kill and incapacitate."
	force = 10
	w_class = 4
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 24
	throwforce = 20
	throw_speed = 2
	attack_verb = list("smashed", "slammed", "whacked", "thwacked")
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bostaff0"

/obj/item/weapon/twohanded/bostaff/update_icon()
	icon_state = "bostaff[wielded]"
	return

/obj/item/weapon/twohanded/bostaff/attack(mob/target, mob/living/user)
	add_fingerprint(user)
	if((CLUMSY in user.disabilities) && prob(50))
		user << "<span class ='warning'>You club yourself over the head with [src].</span>"
		user.Weaken(3)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, "head")
		else
			user.take_organ_damage(2*force)
		return
	if(isrobot(target))
		return ..()
	if(!isliving(target))
		return ..()
	var/mob/living/carbon/C = target
	if(C.stat)
		user << "<span class='warning'>It would be dishonorable to attack a foe while they cannot retaliate.</span>"
		return
	switch(user.a_intent)
		if("disarm")
			if(!wielded)
				return ..()
			if(!ishuman(target))
				return ..()
			var/mob/living/carbon/human/H = target
			var/list/fluffmessages = list("[user] clubs [H] with [src]!", \
										  "[user] smacks [H] with the butt of [src]!", \
										  "[user] broadsides [H] with [src]!", \
										  "[user] smashes [H]'s head with [src]!", \
										  "[user] beats [H] with front of [src]!", \
										  "[user] twirls and slams [H] with [src]!")
			H.visible_message("<span class='warning'>[pick(fluffmessages)]</span>", \
								   "<span class='userdanger'>[pick(fluffmessages)]</span>")
			playsound(get_turf(user), 'sound/effects/woodhit.ogg', 75, 1, -1)
			H.adjustStaminaLoss(rand(13,20))
			if(prob(10))
				H.visible_message("<span class='warning'>[H] collapses!</span>", \
									   "<span class='userdanger'>Your legs give out!</span>")
				H.Weaken(4)
			if(H.staminaloss && !H.sleeping)
				var/total_health = (H.health - H.staminaloss)
				if(total_health <= config.health_threshold_crit && !H.stat)
					H.visible_message("<span class='warning'>[user] delivers a heavy hit to [H]'s head, knocking them out cold!</span>", \
										   "<span class='userdanger'>[user] knocks you unconscious!</span>")
					H.sleeping += 30
					H.adjustBrainLoss(25)
			return
		else
			return ..()
	return ..()

/obj/item/weapon/twohanded/bostaff/IsShield()
	if(wielded)
		return 1
	else
		return 0


/obj/item/clothing/gloves/cqc
	name = "tactical gloves"
	var/datum/martial_art/cqc/style = new

/obj/item/clothing/gloves/cqc/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_gloves)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)
	return

obj/item/clothing/gloves/cqc/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(slot_gloves) == src)
		style.remove(H)
	return

/obj/item/weapon/the_basics_of_cqc
	name = "the basics of cqc"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of fighting style."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"

/obj/item/weapon/the_basics_of_cqc/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	user << "<span class='notice'>You begin to read the scroll...</span>"
	user << "<span class='sciradio'><i>And all at once the secrets of the CQC fill your mind. This basic form of close quarters combat has been imbued into this scroll. As you read through it, \
 	these secrets flood into your mind and body.<br>You now know the martial techniques of the The Boss. Your hand-to-hand combat has become much more effective, and you may now perform powerful \
 	combination attacks.<br>To learn more about these combos, use the Recall Training ability in the CQC tab.</i></span>"
	user.verbs += /mob/living/carbon/human/proc/cqc_help
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)