/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/mob/living/carbon/owner = null
	var/status = ORGAN_ORGANIC


//Old Datum Limbs:
// code/modules/unused/limbs.dm


/obj/item/organ/limb
	name = "limb"
	var/body_part = null
	var/brutestate = 0
	var/burnstate = 0
	var/brute_dam = 0
	var/bloodloss = 0
	var/max_bloodloss = 2
	var/burn_dam = 0
	var/max_damage = 0
	var/list/embedded_objects = list()



/obj/item/organ/limb/chest
	name = "chest"
	desc = "why is it detached..."
	icon_state = "chest"
	max_damage = 200
	body_part = CHEST

/obj/item/stack/teeth
	name = "teeth"
	singular_name = "tooth"
	w_class = 1
	throwforce = 2
	max_amount = 32
	// gender = PLURAL
	desc = "Welp. Someone had their teeth knocked out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "teeth"

/obj/item/stack/teeth/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] jams [src] into \his eyes! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/stack/teeth/human
	name = "human teeth"
	singular_name = "human tooth"

/obj/item/stack/teeth/human/New()
	..()
	transform *= TransformUsingVariable(0.25, 1, 0.5) //Half-size the teeth

/obj/item/stack/teeth/human/gold //Special traitor objective maybe?
	name = "golden teeth"
	singular_name = "gold tooth"
	desc = "Someone spent a fortune on these."
	icon_state = "teeth_gold"

/obj/item/stack/teeth/human/wood
	name = "wooden teeth"
	singular_name = "wooden tooth"
	desc = "Made from the worst trees botany can provide."
	icon_state = "teeth_wood"

/obj/item/stack/teeth/generic //Used for species without unique teeth defined yet
	name = "teeth"

/obj/item/stack/teeth/generic/New()
	..()
	transform *= TransformUsingVariable(0.25, 1, 0.5) //Half-size the teeth

/obj/item/stack/teeth/replacement
	name = "replacement teeth"
	singular_name = "replacement tooth"
	// gender = PLURAL
	desc = "First teeth, now replacements. When does it end?"
	icon_state = "dentals"

/obj/item/stack/teeth/replacement/New()
	..()
	transform *= TransformUsingVariable(0.25, 1, 0.5) //Half-size the teeth

/obj/item/stack/teeth/cat
	name = "tarajan teeth"
	singular_name = "tarajan tooth"
	desc = "Treasured trophy."
	sharpness = IS_SHARP
	icon_state = "teeth_cat"

/obj/item/stack/teeth/cat/New()
	..()
	transform *= TransformUsingVariable(0.35, 1, 0.5) //resize the teeth

/obj/item/stack/teeth/lizard
	name = "lizard teeth"
	singular_name = "lizard tooth"
	desc = "They're quite sharp."
	sharpness = IS_SHARP
	icon_state = "teeth_cat"

/obj/item/stack/teeth/lizard/New()
	..()
	transform *= TransformUsingVariable(0.30, 1, 0.5) //resize the teeth

/obj/item/stack/teeth/xeno
	name = "xenomorph teeth"
	singular_name = "xenomorph tooth"
	desc = "The only way to get these is to capture a xenomorph and surgically remove their teeth."
	throwforce = 4
	sharpness = IS_SHARP
	icon_state = "teeth_xeno"
	max_amount = 48

/obj/item/organ/limb/head
	name = "head"
	desc = "what a way to get a head in life..."
	icon_state = "head"
	max_damage = 200
	body_part = HEAD
	var/list/teeth_list = list() //Teeth are added in carbon/human/New()
	var/max_teeth = 32 //Changed based on teeth type the species spawns with
	var/max_dentals = 1
	var/list/dentals = list() //Dentals - pills inserted into teeth. I'd die trying to keep track of these for every single tooth.

/obj/item/organ/limb/head/proc/get_teeth() //returns collective amount of teeth
	var/amt = 0
	if(!teeth_list) teeth_list = list()
	for(var/obj/item/stack/teeth in teeth_list)
		amt += teeth.amount
	return amt

/obj/item/organ/limb/head/proc/knock_out_teeth(throw_dir, num=32) //Won't support knocking teeth out of a dismembered head or anything like that yet.
	num = Clamp(num, 1, 32)
	var/done = 0
	if(teeth_list && teeth_list.len) //We still have teeth
		var/stacks = rand(1,3)
		for(var/curr = 1 to stacks) //Random amount of teeth stacks
			var/obj/item/stack/teeth/teeth = pick(teeth_list)
			if(!teeth || teeth.zero_amount()) return //No teeth left, abort!
			var/drop = round(min(teeth.amount, num)/stacks) //Calculate the amount of teeth in the stack
			var/obj/item/stack/teeth/T = new teeth.type(owner.loc, drop)
			T.copy_evidences(teeth)
			teeth.use(drop)
			T.add_blood(owner)
			var/turf/target = get_turf(owner.loc)
			var/range = rand(2,T.throw_range)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf.density)
					break
			T.throw_at(target,T.throw_range,T.throw_speed)
			teeth.zero_amount() //Try to delete the teeth
			done = 1
	return done

/obj/item/organ/limb/l_arm
	name = "l_arm"
	desc = "why is it detached..."
	icon_state = "l_arm"
	max_damage = 75
	body_part = ARM_LEFT


/obj/item/organ/limb/l_leg
	name = "l_leg"
	desc = "why is it detached..."
	icon_state = "l_leg"
	max_damage = 75
	body_part = LEG_LEFT


/obj/item/organ/limb/r_arm
	name = "r_arm"
	desc = "why is it detached..."
	icon_state = "r_arm"
	max_damage = 75
	body_part = ARM_RIGHT


/obj/item/organ/limb/r_leg
	name = "r_leg"
	desc = "why is it detached..."
	icon_state = "r_leg"
	max_damage = 75
	body_part = LEG_RIGHT

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/organ/limb/proc/take_damage(brute, burn, bleed)
	if(owner && (owner.status_flags & GODMODE))	return 0	//godmode
	brute	= max(brute,0)
	burn	= max(burn,0)
	bleed = max(bleed,0)

	if(status == ORGAN_ROBOTIC) //This makes robolimbs not damageable by chems and makes it stronger
		brute = max(0, brute - 5)
		burn = max(0, burn - 4)
		bleed = 0 //Robotic limbs don't bleed, stupid!

	bloodloss = min(bloodloss + bleed, max_bloodloss)
	var/can_inflict = max_damage - (brute_dam + burn_dam)
	if(!can_inflict)	return 0

	if((brute + burn) < can_inflict)
		brute_dam	+= brute
		burn_dam	+= burn
	else
		if(brute > 0)
			if(burn > 0)
				brute	= round( (brute/(brute+burn)) * can_inflict, 1 )
				burn	= can_inflict - brute	//gets whatever damage is left over
				brute_dam	+= brute
				burn_dam	+= burn
			else
				brute_dam	+= can_inflict
		else
			if(burn > 0)
				burn_dam	+= can_inflict
			else
				return 0
	return update_organ_icon()


//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/organ/limb/proc/heal_damage(brute, burn, bleed, robotic)

	if(robotic && status != ORGAN_ROBOTIC) // This makes organic limbs not heal when the proc is in Robotic mode.
		brute = max(0, brute - 3)
		burn = max(0, burn - 3)

	if(!robotic && status == ORGAN_ROBOTIC) // This makes robolimbs not healable by chems.
		brute = max(0, brute - 3)
		burn = max(0, burn - 3)

	brute_dam	= max(brute_dam - brute, 0)
	burn_dam	= max(burn_dam - burn, 0)
	bloodloss	= max(bloodloss - bleed, 0)
	return update_organ_icon()


//Returns total damage...kinda pointless really
/obj/item/organ/limb/proc/get_damage()
	return brute_dam + burn_dam


//Updates an organ's brute/burn states for use by update_damage_overlays()
//Returns 1 if we need to update overlays. 0 otherwise.
/obj/item/organ/limb/proc/update_organ_icon()
	if(status == ORGAN_ORGANIC) //Robotic limbs show no damage - RR
		var/tbrute	= round( (brute_dam/max_damage)*3, 1 )
		var/tburn	= round( (burn_dam/max_damage)*3, 1 )
		if((tbrute != brutestate) || (tburn != burnstate))
			brutestate = tbrute
			burnstate = tburn
			return 1
		return 0

//Returns a display name for the organ
/obj/item/organ/limb/proc/getDisplayName() //Added "Chest" and "Head" just in case, this may not be needed
	switch(name)
		if("l_leg")		return "left leg"
		if("r_leg")		return "right leg"
		if("l_arm")		return "left arm"
		if("r_arm")		return "right arm"
		if("chest")     return "chest"
		if("head")		return "head"
		else			return name


//Remove all embedded objects from all limbs on the human mob
/mob/living/carbon/human/proc/remove_all_embedded_objects()
	var/turf/T = get_turf(src)

	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			L.embedded_objects -= I
			I.loc = T

	clear_alert("embeddedobject")

/mob/living/carbon/human/proc/has_embedded_objects()
	. = 0
	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			return 1
