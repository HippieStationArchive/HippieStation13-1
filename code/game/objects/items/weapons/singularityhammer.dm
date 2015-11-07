/obj/item/weapon/twohanded/singularityhammer
	name = "singularity hammer"
	desc = "The pinnacle of close combat technology, the hammer harnesses the power of a miniaturized singularity to deal crushing blows."
	icon_state = "mjollnir0"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = 5
	force_unwielded = 5
	force_wielded = 20
	throwforce = 15
	throw_range = 1
	w_class = 5
	var/charged = 5
	origin_tech = "combat=5;bluespace=4"



/obj/item/weapon/twohanded/singularityhammer/New()
	..()
	SSobj.processing |= src


/obj/item/weapon/twohanded/singularityhammer/Destroy()
	SSobj.processing.Remove(src)
	return ..()


/obj/item/weapon/twohanded/singularityhammer/process()
	if(charged < 5)
		charged++
	return

/obj/item/weapon/twohanded/singularityhammer/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return


/obj/item/weapon/twohanded/singularityhammer/proc/vortex(turf/pull, mob/wielder)
	for(var/atom/X in orange(5,pull))
		if(istype(X, /atom/movable))
			if(X == wielder) continue
			if((X) &&(!X:anchored) && (!istype(X,/mob/living/carbon/human)))
				step_towards(X,pull)
				step_towards(X,pull)
				step_towards(X,pull)
			else if(istype(X,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = X
				if(istype(H.shoes,/obj/item/clothing/shoes/magboots))
					var/obj/item/clothing/shoes/magboots/M = H.shoes
					if(M.magpulse)
						continue
				H.apply_effect(1, WEAKEN, 0)
				step_towards(H,pull)
				step_towards(H,pull)
				step_towards(H,pull)
	return



/obj/item/weapon/twohanded/singularityhammer/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	if(!proximity) return
	if(wielded)
		if(charged == 5)
			charged = 0
			if(istype(A, /mob/living/))
				var/mob/living/Z = A
				Z.take_organ_damage(20,0)
			playsound(user, 'sound/weapons/marauder.ogg', 50, 1)
			var/turf/target = get_turf(A)
			vortex(target,user)


/obj/item/weapon/twohanded/mjollnir
	name = "Mjollnir"
	desc = "A weapon worthy of a god, able to strike with the force of a lightning bolt. It crackles with barely contained energy."
	icon_state = "mjollnir0"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = 5
	force_unwielded = 5
	force_wielded = 20
	throwforce = 30
	throw_range = 7
	w_class = 5
	//var/charged = 5
	origin_tech = "combat=5;powerstorage=5"

/obj/item/weapon/twohanded/mjollnir/proc/shock(mob/living/target)
	var/datum/effect/effect/system/lightning_spread/s = new /datum/effect/effect/system/lightning_spread
	s.set_up(5, 1, target.loc)
	s.start()
	target.take_organ_damage(0,30)
	target.visible_message("<span class='danger'>[target.name] was shocked by the [src.name]!</span>", \
		"<span class='userdanger'>You feel a powerful shock course through your body sending you flying!</span>", \
		"<span class='italics'>You hear a heavy electrical crack!</span>")
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 200, 4)
	return


/obj/item/weapon/twohanded/mjollnir/attack(mob/M, mob/user)
	..()
	spawn(0)
	if(wielded)
		//if(charged == 5)
		//charged = 0
		playsound(src.loc, "sparks", 50, 1)
		if(istype(M, /mob/living))
			M.Stun(10)
			shock(M)


/obj/item/weapon/twohanded/mjollnir/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return

//POWER FIST
//This thing is a mish-mash of singularity hammer and mjollnir code, but it seems to work well.

/obj/item/weapon/twohanded/powerfist
	name = "Power Fist"
	desc = "A set of large gloves. One glove holds the power cell while the other is a plasteel mechanically powered fist which can deliver a massive blow to any target with the ability to throw them across a room. The power fist itself can only be used once every half to two-thirds of a second approximately."
	icon_state = "powerfist0"
	flags = CONDUCT
	force = 5
	force_unwielded = 5
	force_wielded = 10
	throwforce = 10
	throw_range = 7
	w_class = 3
	var/charged = 1		//This might need to be raised, because lower charge = the faster the power fist is ready to...power fist someone again. After testing this seems good to me actually.
	origin_tech = "combat=5;powerstorage=3"

/obj/item/weapon/twohanded/powerfist/New()
	..()
	SSobj.processing |= src


/obj/item/weapon/twohanded/powerfist/Destroy()
	SSobj.processing.Remove(src)
	return ..()


/obj/item/weapon/twohanded/powerfist/process()
	if(charged < 1)
		charged++
	return

/obj/item/weapon/twohanded/powerfist/afterattack(mob/living/target)
	var/datum/effect/effect/system/lightning_spread/s = new /datum/effect/effect/system/lightning_spread
	if(wielded)
		if(charged == 1)
			charged = 0
			s.set_up(5, 1, target.loc)
			s.start()
			target.take_organ_damage(15,0)
			target.visible_message("<span class='danger'>[target.name] was power-fisted by the [src.name]!</span>", \
				"<span class='userdanger'>You hear a loud crack!</span>", \
				"<span class='italics'>You hear the sound of bones crunching!</span>")
			var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
			target.throw_at(throw_target, 10, 0.2)
			playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, 1)
			target.adjustStaminaLoss(20)
			return

/obj/item/weapon/twohanded/powerfist/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "powerfist[wielded]"
	return
