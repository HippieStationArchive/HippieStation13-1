
////////////////////
//MORE DRONE TYPES//
////////////////////
//Drones with custom laws
//Drones with custom shells
//Drones with overriden procs


//More types of drones
/mob/living/simple_animal/drone/syndrone
	name = "Syndrone"
	desc = "A modified maintenance drone. This one brings with it the feeling of terror."
	icon_state = "drone_synd"
	icon_living = "drone_synd"
	picked = TRUE //the appearence of syndrones is static, you don't get to change it.
	health = 30
	maxHealth = 120 //If you murder other drones and cannibalize them you can get much stronger
	faction = list("syndicate")
	heavy_emp_damage = 10
	laws = \
	"1. Interfere.\n"+\
	"2. Kill.\n"+\
	"3. Destroy."
	default_storage = /obj/item/device/radio/uplink
	default_hatmask = /obj/item/clothing/head/helmet/space/hardsuit/syndi
	seeStatic = 0 //Our programming is superior.


//Sydrones
/mob/living/simple_animal/drone/syndrone/New()
	..()
	if(internal_storage && internal_storage.hidden_uplink)
		internal_storage.hidden_uplink.uses = (initial(internal_storage.hidden_uplink.uses) / 2)
		internal_storage.name = "syndicate uplink"


/mob/living/simple_animal/drone/syndrone/Login()
	..()
	src << "<span class='notice'>You can kill and eat other drones to increase your health!</span>" //Inform the evil lil guy

/obj/item/drone_shell/syndrone
	name = "syndrone shell"
	desc = "A shell of a syndrone, a modified maintenance drone designed to infiltrate and annihilate."
	icon_state = "syndrone_item"
	drone_type = /mob/living/simple_animal/drone/syndrone

//Safedrones - Excuse the awful ClickOn proc
/mob/living/simple_animal/drone/safedrone

/mob/living/simple_animal/drone/safedrone/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		if(ismob(A))
			if(!isdrone(A))
				src << "<span class='danger'>Your laws prevent you from doing this!</span>"
				return
		CtrlClickOn(A)
		return

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A)

	if(next_move > world.time) // in the year 2000...
		return

	if(restrained())
		changeNext_move(CLICK_CD_HANDCUFFED)   //Doing shit in cuffs shall be vey slow
		RestrainedClickOn(A)
		return

	var/obj/item/W = get_active_hand()

	//Banned drone weapons:
	if(istype(W, /obj/item/weapon/gun))
		src << "<span class='danger'>Your laws prevent you from doing this!</span>"
		return


	if(W == A)
		W.attack_self(src)
		if(hand)
			update_inv_l_hand(0)
		else
			update_inv_r_hand(0)
		return

	// operate three levels deep here (item in backpack in src; item in box in backpack in src, not any deeper)
	if(!isturf(A) && A == loc || (A in contents) || (A.loc in contents) || (A.loc && (A.loc.loc in contents)))
		// No adjacency needed
		if(W)
			var/resolved = A.attackby(W,src)
			if(!resolved && A && W)
				W.afterattack(A,src,1,params) // 1 indicates adjacency
		else
			if(ismob(A))
				changeNext_move(CLICK_CD_MELEE)
			UnarmedAttack(A)
		return


	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	// Allows you to click on a box's contents, if that box is on the ground, but no deeper than that
	if(isturf(A) || isturf(A.loc) || (A.loc && isturf(A.loc.loc)))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				if(ismob(A))
					if(!isdrone(A))
						src << "<span class='danger'>Your laws prevent you from doing this!</span>"
						return
				var/resolved = A.attackby(W,src,params)
				if(!resolved && A && W)
					W.afterattack(A,src,1,params) // 1: clicking something Adjacent
			else
				if(ismob(A))
					if(!isdrone(A))
						src << "<span class='danger'>Your laws prevent you from doing this!</span>"
						return
					changeNext_move(CLICK_CD_MELEE)
				UnarmedAttack(A, 1)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A,src,0,params) // 0: not Adjacent
			else
				RangedAttack(A, params)

//Stop right click pulling too
/mob/living/simple_animal/drone/safedrone/pulled(atom/movable/AM as mob|obj in oview(1))
	if(ismob(AM))
		if(!isdrone(AM))
			src << "<span class='danger'>Your laws prevent you from doing this!</span>"
			return
	..()

/mob/living/simple_animal/drone/safedrone/stripPanelUnequip(obj/item/what, mob/who, where)
	if(!isdrone(who))
		src << "<span class='danger'>Your laws prevent you from doing this!</span>"
		return
	..(what, who, where, 1)


/mob/living/simple_animal/drone/safedrone/stripPanelEquip(obj/item/what, mob/who, where)
	if(!isdrone(who))
		src << "<span class='danger'>Your laws prevent you from doing this!</span>"
		return
	..(what, who, where, 1)

/obj/item/drone_shell/safedrone
	drone_type = /mob/living/simple_animal/drone/safedrone

