var/list/possible_z_cures = list("spaceacillin", "leporazine", "synaptizine", "lipolicide")//, "silver", "gold")
var/list/zombie_cure = list()

/datum/disease/zombie
	name = "Zombie Virus"
	cure_text = ""
	cures = list()
	spread_text = "Zombie Bites"
	spread_flags = SPECIAL
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	cure_chance = 60
	longevity = 30
	desc = "Humans infected with this disease eventually will become a zombie that will spread the disease via biting."
	severity = BIOHAZARD
	stage_prob = 4
	visibility_flags = HIDDEN_SCANNER
	disease_flags = CURABLE|CAN_CARRY
	agent = "Z-Virus Beta"
	max_stages = 5
	undead = 1 //stage_act() will be called even if you're dead.

/datum/disease/zombie/New()
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
	spawn(0)
		ticker.mode.update_zombie_icons()

/datum/disease/zombie/cure()
	..()
	ticker.mode.update_zombie_icons()

/datum/disease/zombie/has_cure()
	if(affected_mob.stat == DEAD) //Cure won't work if the disease holder is already dead. The only thing to do now is to get rid of the corpse.
		return 0
	..()

/datum/disease/zombie/stage_act()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		if(H.dna.species.id == "zombie")
			cure()
			return //So repeated zombifications don't happen.

	var/prev_stage = stage
	..()
	if(stage != prev_stage) //stage changed
		ticker.mode.update_zombie_icons()
	if(affected_mob.stat != DEAD) //So flavortext doesn't show up on dead people. Transformation should still happen when dead though.
		if(stage >= max_stages)
			stage = max_stages - 1 //We're not dead yet, so let's switch back to stage 4
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
				else if(prob(5) && ishuman(affected_mob))
					var/mob/living/carbon/human/H = affected_mob
					H.vessel.remove_reagent("blood",rand(1,2))
					affected_mob.visible_message("<span class='warning'>[affected_mob] looks a bit pale...</span>", "<span class='notice'>You look a bit pale...</span>")
				else if(prob(5))
					affected_mob << "<span class='notice'>[pick("You feel hungry.", "You crave for food.")]</span>"
					affected_mob.overeatduration = max(affected_mob.overeatduration - 25, 0)
					affected_mob.nutrition = max(affected_mob.nutrition - 25, 0)
			if(4)
				if(prob(15))
					affected_mob << "<span class='notice'>[pick("You feel hot.", "You feel like you're burning.")]</span>"
					if(affected_mob.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
						affected_mob.bodytemperature = min(affected_mob.bodytemperature + (20 * stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
				else if(prob(3))
					affected_mob << "<span class='danger'>You feel faint...</span>"
					affected_mob.emote("faint")
				else if(prob(12))
					affected_mob << "<span class='notice'>[pick("You feel hungry.", "You crave for food.")]</span>"
					affected_mob.overeatduration = max(affected_mob.overeatduration - 25, 0)
					affected_mob.nutrition = max(affected_mob.nutrition - 25, 0)
				else if(prob(5) && ishuman(affected_mob))
					var/mob/living/carbon/human/H = affected_mob
					H.vessel.remove_reagent("blood",rand(1,4))
					affected_mob.visible_message("<span class='warning'>[affected_mob] looks very pale...</span>", "<span class='notice'>You look very pale...</span>")
				else if(prob(10))
					affected_mob.emote(pick("cough", "sneeze", "groan", "gasp"))
	else
		if(stage >= max_stages && ishuman(affected_mob))
			var/mob/living/carbon/human/H = affected_mob
			cure()
			H.Zombify()
			return
		if(stage_prob <= initial(stage_prob))
			stage_prob *= 2