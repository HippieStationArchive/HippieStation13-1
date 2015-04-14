//Revenants: based off of wraiths from Goon
//"Ghosts" that are invisible and move like ghosts, cannot take damage while invsible
//Don't hear deadchat and are NOT normal ghosts
//Admin-spawn or random event

/mob/living/simple_animal/revenant
	name = "revenant"
	desc = "A malevolent spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "revenant_idle"
	incorporeal_move = 1
	invisibility = INVISIBILITY_OBSERVER
	health = 25
	maxHealth = 25
	see_in_dark = 255
	see_invisible = SEE_INVISIBLE_OBSERVER
	languages = ALL
	response_help   = "passes through"
	response_disarm = "swings at"
	response_harm   = "punches"
	minbodytemp = 0
	maxbodytemp = INFINITY
	harm_intent_damage = 5
	speak_emote = list("hisses", "spits", "growls")
	friendly = "touches"
	status_flags = 0
	wander = 0
	density = 0

	var/essence = 25 //The resource of revenants. Max health is equal to twice this amount
	var/essence_regen_cap = 25 //The regeneration cap of essence (go figure); regenerates every Life() tick up to this amount.
	var/essence_regen = 1 //If the revenant regenerates essence or not; 1 for yes, 0 for no
	var/essence_min = 1 //The minimum amount of essence a revenant can have; by default, it never drops below one
	var/strikes = 2 //How many times a revenant can die before dying for good
	var/revealed = 0 //If the revenant can take damage from normal sources.

/mob/living/simple_animal/revenant/Life()
	..()
	if(essence < essence_min)
		essence = essence_min
		if(strikes > 0)
			strikes--
			src << "<span class='warning'>Your essence has dropped below critical levels. You barely manage to save yourself - [strikes ? "you can't keep this up!" : "next time, it's death."]</span>"
		else if(strikes <= 0)
			src << "<span class='warning'><b>NO! No... it's too late, you can feel yourself fading...</b></span>"
			src.notransform = 1
			src.revealed = 1
			src.invisibility = 0
			playsound(src, 'sound/effects/screech.ogg', 100, 1)
			src.visible_message("<b>The revenant</b> lets out a waning screech as violet mist swirls around its dissolving body!")
			sleep(30)
			src.death()
	maxHealth = essence * 2
	if(!revealed)
		health = maxHealth //Heals to full when not revealed
	if(essence < essence_regen_cap && essence_regen)
		essence += 1

/mob/living/simple_animal/revenant/say(message)
	return 0 //Revenants cannot speak out loud.

/mob/living/simple_animal/revenant/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Current essence: [essence]E")

/mob/living/simple_animal/revenant/New()
	..()
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 255
	spawn(20)
		if(src.mind)
			src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/revenant_drain_lesser
			src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/revenant_drain_greater
			src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/revenant_transmit
			src.mind.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/revenant_light
			src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/revenant_strangulate
			src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/revenant_life_tap
		else
			qdel(src)

/mob/living/simple_animal/revenant/death()
	..(1)
	src.invisibility = 0
	visible_message("<span class='danger'>[src] pulses with an eldritch purple light as its form unwinds into smoke.</span>")
	ghostize()
	qdel(src)
	return

/mob/living/simple_animal/revenant/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/weapon/nullrod))
		src.visible_message("<b>The revenant</b> screeches and flails!", \
							"<span class='userdanger'>The null rod invokes agony in you! You feel your essence draining away!</span>")
		src.essence -= 25 //hella effective
		if(prob(5))
			src.visible_message("<span class='warning'><b>The revenant is torn apart by the null rod!</b></span>")
			playsound(src, 'sound/effects/supermatter.ogg', 100, 1)
			src.death()



/obj/effect/proc_holder/spell/proc/essence_check(var/essence_cost, var/silent = 0)
	var/mob/living/simple_animal/revenant/W = usr
	if(W.essence < essence_cost)
		if(!silent)
			W << "<span class='warning'>You need [essence_cost]E to use [name] but you only have [W.essence]E available. Harvest some more things.</span>"
		return 0
	W.essence -= essence_cost
	return 1



/mob/living/simple_animal/revenant/proc/change_essence_amount(var/essence_amt, var/mode = 0, var/silent = 0, var/source = null, var/mob/living/simple_animal/revenant/user = usr)
	//Mode 1 is essence subtracted, mode 0 is essence added
	//Example use: revenant.change_essence_amount(25, 0, 0, "the debug") would tell him "Gained 25E from the debug."
	if(!essence_amt)
		return
	if(mode)
		user.essence -= essence_amt
	else
		user.essence += essence_amt
	if(!silent)
		if(source)
			user << "<span class='info'>[mode ? "Lost" : "Gained"] [essence_amt]E from [source].</span>"
		else
			user << "<span class='info'>[mode ? "Lost" : "Gained"] [essence_amt]E.</span>"
	return 1