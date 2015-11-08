var/list/possible_z_cures = list("spaceacillin", "leporazine", "synaptizine", "lipolicide", "silver", "gold")
var/list/zombie_cure = list()

/datum/disease/transformation/zombie
	name = "Zombie Virus"
	cure_text = ""
	cures = list()
	spread_text = "Zombie Bites"
	spread_flags = SPECIAL
	viable_mobtypes = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	permeability_mod = 1
	cure_chance = 60
	longevity = 30
	desc = "Zombies with this disease will bite humans, causing them to mutate into one."
	severity = BIOHAZARD
	stage_prob = 3
	visibility_flags = HIDDEN_SCANNER
	agent = "Z-Virus Beta"

	undead = 1 //stage_act() will be called even if you're dead.

	stage1	= null
	stage2	= null
	stage3	= null
	stage4	= null
	stage5	= null

/datum/disease/transformation/zombie/New()
	..()
	if(!zombie_cure || !zombie_cure.len) //Randomize zombie cure every round
		zombie_cure = list()
		for(var/i = 0 to 1) //Zombie cure will ALWAYS require two ingredients
			var/picked = pick(possible_z_cures)
			zombie_cure += picked
			possible_z_cures -= picked
	for(var/str in zombie_cure)
		cure_text += "[length(cure_text) > 0 ? "&" : ""][str]"
	cures = zombie_cure

/datum/disease/transformation/zombie/do_disease_transformation(mob/living/carbon/affected_mob)
	if(affected_mob.notransform) return
	affected_mob.death(1)
	affected_mob.notransform = 1
	sleep(30)
	Zombify(affected_mob)
	cure()

/datum/disease/transformation/zombie/has_cure()
	if(affected_mob.stat == DEAD) //Cure won't work if the disease holder is already dead. The only thing to do now is to get rid of the corpse.
		return 0
	..()

/datum/disease/transformation/zombie/stage_act()
	..()
	if(affected_mob.stat != DEAD) //So flavortext doesn't show up on dead people. Transformation should still happen when dead though.
		switch(stage)
			if(2)
				if(prob(2))
					affected_mob.emote(pick("cough", "sneeze"))
			if(3)
				if(prob(5))
					affected_mob.emote(pick("cough", "sneeze"))
				else if(prob(5))
					affected_mob << "<span class='notice'>[pick("You're having difficulty breathing.", "Your breathing becomes heavy.")]</span>"
					affected_mob.emote("gasp")
				else if(prob(5))
					affected_mob << "<span class='danger'>You feel a stabbing pain in your head.</span>"
					affected_mob.confused += 10
				else if(prob(5))
					if(ishuman(affected_mob))
						var/mob/living/carbon/human/H = affected_mob
						H.vessel.remove_reagent("blood",rand(1,5))
					affected_mob.visible_message("<span class='warning'>[affected_mob] looks a bit pale...</span>", "<span class='notice'>You look a bit pale...</span>")
			if(4)
				if(ishuman(affected_mob))
					var/mob/living/carbon/human/H = affected_mob
					H.vessel.remove_reagent("blood",rand(1,2))
				if(prob(15))
					affected_mob << "<span class='notice'>[pick("You feel hot.", "You feel like you're burning.")]</span>"
					if(affected_mob.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
						affected_mob.bodytemperature = min(affected_mob.bodytemperature + (20 * stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
				else if(prob(3))
					affected_mob << "<span class='danger'>You feel faint...</span>"
					affected_mob.emote("faint")
				else if(prob(5))
					affected_mob.visible_message("<span class='warning'>[affected_mob] looks very pale...</span>", "<span class='notice'>You look very pale...</span>")
				else if(prob(7))
					affected_mob.emote(pick("cough", "sneeze", "groan", "gasp"))

/proc/Zombify(mob/living/carbon/human/H)
	// if(!H.HasDisease(/datum/disease/transformation/zombie)) return //Let's not turn someone into a zombie if they no longer have it
	if(!istype(H)) return
	H.set_species(/datum/species/zombie)
	var/mob/living/simple_animal/hostile/zombie/Z = new /mob/living/simple_animal/hostile/zombie(H.loc)
	Z.faction = list("zombie")
	Z.appearance = H.appearance
	Z.transform = matrix()
	Z.pixel_y = 0
	for(var/mob/dead/observer/ghost in player_list)
		if(H.real_name == ghost.real_name)
			ghost.reenter_corpse()
			break
	Z.ckey = H.ckey
	H.stat = DEAD
	H.loc = Z
	Z.stored_corpse = H
	playsound(Z.loc, pick('sound/effects/bodyscrape-01.ogg', 'sound/effects/bodyscrape-02.ogg'), 40, 1, -2)
	Z.visible_message("<span class='danger'>[Z] staggers to their feet!</span>", "<span class='userdanger'>You have transformed into a Zombie. Spread the infection!</span>")