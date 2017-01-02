//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!


#define TINT_IMPAIR 2			//Threshold of tint level to apply weld mask overlay
#define TINT_BLIND 3			//Threshold of tint level to obscure vision fully

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 10 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

/mob/living/carbon/human
	var/tinttotal = 0				// Total level of visualy impairing items



/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (notransform)
		return

	if(jobban_isbanned(src, "catban") && src.dna.species.name != "Tarajan")
		src.set_species(/datum/species/cat, icon_update=1)

	if(jobban_isbanned(src, "cluwneban") && !src.dna.check_mutation(CLUWNEMUT))
		src.dna.add_mutation(CLUWNEMUT)

	tinttotal = tintcheck() //here as both hud updates and status updates call it

	if(..())
		for(var/datum/mutation/human/HM in dna.mutations)
			HM.on_life(src)

		//heart attack stuff
		handle_heart()

		//Stuff jammed in your limbs hurts
		handle_embedded_objects()
	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	dna.species.spec_life(src) // for mutantraces
	if(hud_used && hud_used.combo_object && hud_used.combo_object.cooldown < world.time)
		hud_used.combo_object.update_icon()
	//If they're a vampire, do vampire-specific thingies
	if(is_vampire(src))
		handle_vampirism()

	handle_inventory()

/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	if((wear_suit && (wear_suit.flags & STOPSPRESSUREDMAGE)) && (head && (head.flags & STOPSPRESSUREDMAGE)))
		return ONE_ATMOSPHERE
	else
		return pressure


/mob/living/carbon/human/handle_disabilities()
	..()
	//Eyes
	if(!(disabilities & BLIND))
		if(tinttotal >= TINT_BLIND)		//covering your eyes heals blurry eyes faster
			eye_blurry = max(eye_blurry-2, 0)

	//Ears
	if(!(disabilities & DEAF))
		if(istype(ears, /obj/item/clothing/ears/earmuffs)) // earmuffs rest your ears, healing ear_deaf faster and ear_damage, but keeping you deaf.
			setEarDamage(max(ear_damage-0.10, 0), max(ear_deaf - 1, 1))


	if (getBrainLoss() >= 60 && stat != DEAD)
		if (prob(3))
			switch(pick(1,2,3,4,5))
				if(1)
					say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that faggot traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse","kamelien","eksrey","glowey skin")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH monkeyS", "stop grifing me!!!!", "SOTP IT#", "shiggey diggey!!", "A PIRATE APPEAR"))
				if(2)
					say(pick("FUS RO DAH","fucking 4rries!", "stat me", ">my face", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "PACKETS!!!", "port ba[pick("y", "i", "e")] med!!!!", "REVIRT GON CHEM!!!!!!!!", "youed call her a toeugh bithc", "closd for merbegging", "pray can u [pick("spawn", "MAke me", "creat")] [pick("zenomorfs", "ayleins", "treaitors", "sheadow linkgs", "ubdoocters")]???"))
				if(3)
					say(pick("GEY AWAY FROM ME U GREIFING PRICK!!!!", "ur a fuckeing autist!", ";HELP SHITECIRTY MURDERIN  MEE!!!", "hwat dose tha [pick("g", "squid", "r")] mean?????", "CAL; TEH SHUTTLE!!!!!", "wearnig siNGUARLTY IS .... FIne xDDDDDDDDD", "AI laW 22 Open door", "this SI mY stATIon......", "who the HELL do u thenk u r?!!!!", "geT THE FUCK OUTTTT", "H U G B O X", ";;CRAGING THIS STTAYTION WITH NIO SURVIVROS", "[pick("bager", "syebl")] is down11!!!!!!!!!!!!!!!!!", "PSHOOOM"))
				if(4)
					emote("drool")
				if(5)
					say(pick("REMOVE SINGULARITY", "INSTLL TEG", "TURBIN IS BEST ENGIENE", "SOLIRS CAN POWER THE HOLE STATION ANEWAY","DILDOS!!1!","hun~", "MY BREAIN HURTS!!1", ";NUUUUUUUURSE!??!?!", "dont be dong...", "SHOW YOUR BITCH ASS?!?!", ";dont feel so well", "YOU ARE THE super retard", "such beautiful duwang"))


/mob/living/carbon/human/handle_mutations_and_radiation()
	if(!dna || !dna.species.handle_mutations_and_radiation(src))
		..()

/mob/living/carbon/human/handle_chemicals_in_body()
	if(reagents)
		reagents.metabolize(src, can_overdose=1)

/mob/living/carbon/human/breathe()
	if(dna)
		if(!dna.species.breathe(src))
			..()

/mob/living/carbon/human/check_breath(datum/gas_mixture/breath)
	if(dna)
		dna.species.check_breath(breath, src)

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(dna)
		dna.species.handle_environment(environment, src)

///FIRE CODE
/mob/living/carbon/human/handle_fire()
	if(!dna || !dna.species.handle_fire(src))
		..()
	if(on_fire)
		var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
		if(wear_suit)
			if(wear_suit.max_heat_protection_temperature >= FIRE_SUIT_MAX_TEMP_PROTECT)
				thermal_protection += (wear_suit.max_heat_protection_temperature*0.7)
		if(head)
			if(head.max_heat_protection_temperature >= FIRE_HELM_MAX_TEMP_PROTECT)
				thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
		thermal_protection = round(thermal_protection)
		if(thermal_protection >= FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT)
			return
		if(thermal_protection >= FIRE_SUIT_MAX_TEMP_PROTECT)
			bodytemperature += 11
		else
			bodytemperature += (BODYTEMP_HEATING_MAX + (fire_stacks * 12))


/mob/living/carbon/human/IgniteMob()
	if(!dna || !dna.species.IgniteMob(src))
		..()

/mob/living/carbon/human/ExtinguishMob()
	if(!dna || !dna.species.ExtinguishMob(src))
		..()
//END FIRE CODE


//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.heat_protection
	if(w_uniform)
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


	return min(1,thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(wear_suit)
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.cold_protection
	if(w_uniform)
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.cold_protection
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_cold_protection(temperature)

	if(dna.check_mutation(COLDRES))
		return 1 //Fully protected from the cold.

	if(dna && COLDRES in dna.species.specflags)
		return 1

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1,thermal_protection)


/mob/living/carbon/human/handle_chemicals_in_body()
	..()
	if(dna)
		dna.species.handle_chemicals_in_body(src)

/mob/living/carbon/human/handle_vision()
	if(machine)
		if(!machine.check_eye(src))		reset_view(null)
	else
		if(!client.adminobs)			reset_view(null)
	if(dna)
		dna.species.handle_vision(src)

/mob/living/carbon/human/handle_hud_icons()
	if(dna)
		dna.species.handle_hud_icons(src)

/mob/living/carbon/human/handle_random_events()
	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 45 && nutrition > 20)
			lastpuke ++
			if(lastpuke >= 25) // about 25 second delay I guess
				Stun(5)

				visible_message("<span class='danger'>[src] throws up!</span>", \
						"<span class='userdanger'>[src] throws up!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				nutrition -= 20
				adjustToxLoss(-3)

				// make it so you can only puke so fast
				lastpuke = 0


/mob/living/carbon/human/handle_changeling()
	if(mind && hud_used)
		if(mind.changeling)
			mind.changeling.regenerate(src)
			hud_used.lingchemdisplay.invisibility = 0
			hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(mind.changeling.chem_charges)]</font></div>"
		else
			hud_used.lingchemdisplay.invisibility = 101

/mob/living/carbon/human/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(glasses)
		if(glasses.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(head)
		if(head.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	return .
/mob/living/carbon/human/proc/handle_embedded_objects()
	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			if(I.loc == src)
				if(prob(35) && L.bloodloss < 0.5) //decent probability to get increased bleeding, though so it doesn't stack up to ridiculous values
					L.take_damage(bleed=0.02)
				if(prob(I.embedded_pain_chance))
					L.take_damage(I.w_class*I.embedded_pain_multiplier)
					src << "<span class='userdanger'>\the [I] embedded in your [L] hurts!</span>"
			else
				L.embedded_objects -= I
				if(I.pinned) //Only the rodgun pins people down currently
					do_pindown(pinned_to, 0)
					pinned_to = null
					anchored = 0
					update_canmove()
					I.pinned = null

/mob/living/carbon/human/proc/handle_heart()
	if(!heart_attack)
		return
	else
		if(losebreath < 5)
			losebreath += 2
		adjustOxyLoss(5)
		adjustBruteLoss(1)

/mob/living/carbon/human/proc/handle_vampirism()
	var/datum/vampire/V = get_vampire(src)
	if(!V)
		return 0

	//Things that require clean blood and will not substitute dirty blood go under here
	if(V.clean_blood)
		//Vampires slowly recuperate wounds using clean blood passively
		if(!V.fast_heal && V.use_blood(0.01, 1))
			restore_blood() //The body's blood itself is kept high by the vampire's clean blood. This does kinda mean you can infinitely fill blood bags...
			adjustBruteLoss(-0.3)
			adjustFireLoss(-0.1) //Slower than others due to their fire vulnerability
			adjustToxLoss(-0.3)
			adjustOxyLoss(-2)
			adjustCloneLoss(-1)
			adjustBrainLoss(-1)
			if(losebreath)
				losebreath--

	//Vampires use blood to stay nourished
	if(V.use_blood(0.01, 1)) //Tiny, tiny amounts of clean blood
		nutrition = NUTRITION_LEVEL_WELL_FED
	else if(V.use_blood(0.1, 0)) //Or much larger amounts of dirty blood
		nutrition = NUTRITION_LEVEL_WELL_FED
	else //But if they have no blood at all...
		if(nutrition > 0)
			nutrition -= 50 //...they start starving FAST.
			nutrition = Clamp(nutrition, 0, INFINITY)

	//Sanguine Recuperation effects below this line
	if(V.fast_heal)
		if(V.use_blood(2, 1) || V.use_blood(6, 0)) //Either use 2 clean blood or 6 dirty blood
			adjustBruteLoss(-3)
			adjustFireLoss(-2)
			adjustToxLoss(-3)
			setOxyLoss(0) //With all that oxygenated blood, who needs to breathe?
			adjustCloneLoss(-3)
			adjustBrainLoss(-3)
			losebreath = 0
		else
			V.fast_heal = 0 //If we lack the blood to continue, disable it for conservation

	//Accelerated Recovery effects below this line
	if(V.stun_reduction)
		if(V.use_blood(3, 1) || V.use_blood(9, 0)) //Either use 3 clean blood or 9 dirty blood
			AdjustStunned(-2)
			AdjustWeakened(-2)
			AdjustParalysis(-2)
		else
			V.stun_reduction = 0


#undef HUMAN_MAX_OXYLOSS
