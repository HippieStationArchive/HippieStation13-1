/*Contains:
*	Baseball bats
*	Baseball ball
*/

//TODO: Make wooden baseball bat require you to create a stick from wood then sharpen it with a knife.

//The best thing about the bat? You can deflect items when you have throw intent with bat in active hand.
//The worst thing? You can accidentaly throw the bat itself, just like in real life!
/obj/item/weapon/baseballbat
	name = "baseball bat"
	desc = "A smooth wooden club used in baseball to hit the ball. Or to purify your adversaries." //Reference nobody is going to get, woo. (Google "OFF by Mortis Ghost")
	icon = 'icons/obj/toy.dmi'
	icon_state = "bbat"
	item_state = "bbat"
	slot_flags = SLOT_BELT //Including the belt sprite to look cool
	force = 10
	throwforce = 10
	throw_speed = 3
	throw_range = 4
	special_throw = 1
	deflectItem = 1
	specthrowsound = 'sound/weapons/basebat.ogg'
	throwrange_mult = 1.5 //Increases throw range by 1.5
	throwforce_mult = 1.2 //Multiply the throwforce of thrown object meagerly - don't make this too high
	specthrow_maxwclass = 2 //Max weight class that you can throw
	specthrowmsg = "batted"
	w_class = 3
	burn_state = 0

// /mob/living/carbon/throw_item(atom/target)
// 	..()

/obj/item/weapon/baseballbat/wood

/obj/item/weapon/baseballbat/metal
	name = "metal baseball bat"
	desc = "A smooth metal club used in baseball to hit the ball. Or to purify your adversaries."
	icon_state = "bbat_metal"
	item_state = "bbat_metal"
	force = 15 //Buffed again. It's kind of expensive to mass produce it since every 50 metal you can only get 3 bats.
	throwforce = 13
	specthrow_maxwclass = 3 //You can bat normal sized items with metal bat
	burn_state = -1

/obj/item/weapon/baseballbat/spike
	name = "spiked baseball bat"
	desc = "A wooden baseball bat with metal spikes crudely attached."
	icon_state = "bbat_spike"
	item_state = "bbat_spike"
	force = 13
	throwforce = 15 // Its got spikes sticking out of it
	burn_state = 0
	armour_penetration = 20

/obj/item/baseball
	name = "baseball"
	desc = "Pitch it to the batter."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bball"
	w_class = 1.0
	force = 0
	throwforce = 5
	throw_range = 7

/obj/item/weapon/baseballbat/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] smashes the baseball bat into \his head! It looks like \he's trying to commit suicide..</span>")
	return (BRUTELOSS)

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch, hitpush = 1, blocked = 0, zone)
	..()
	var/obj/item/baseball/I = AM
	if(!istype(I))
		return
	if(zone == "")
		zone = ran_zone("chest", 65)
	var/armor = getarmor(get_organ(check_zone(zone), "melee"))
	if(armor >= 100) return
	if(zone == "head" && I.throwforce >= 6) //This is kind of a terrible way to check if the baseball was batted but whatever
		if(stat == CONSCIOUS && prob(50)) //decent chance to make up for the already-RNG zone picking
			if(armor < 40) //It only KO's you if you don't have head armor
				visible_message("<span class='danger'>[src] has been knocked unconscious!</span>", \
								"<span class='userdanger'>[src] has been knocked unconscious!</span>")
				apply_effect(6, PARALYZE, armor) //Since it's ranged, we don't want to make KO too OP
				if(prob(50))
					ticker.mode.remove_revolutionary(mind)
					ticker.mode.remove_gangster(mind)
			else //Knock them down instead
				visible_message("<span class='danger'>[src] has been knocked down!</span>", \
								"<span class='userdanger'>[src] has been knocked down!</span>")
				apply_effect(5, WEAKEN, armor)
				apply_effect(3, STUN, armor)