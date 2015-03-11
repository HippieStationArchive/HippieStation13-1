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
	force = 10 //moderate force
	throwforce = 8
	throw_speed = 3
	throw_range = 4

	//Special variables for special functionality. I don't define vars or add on to procs here because I'd go insane doing that.
	//Check items.dm for var definitions
	special_throw = 1
	deflectItem = 1
	specthrowsound = 'sound/weapons/basebat.ogg'
	throwrange_mult = 1.5 //Increases throw range by 1.5
	throwforce_mult = 1.2 //Multiply the throwforce of thrown object meagerly - don't make this too high
	specthrow_maxwclass = 2 //Max weight class that you can throw
	specthrowmsg = "batted"

	w_class = 3

// /mob/living/carbon/throw_item(atom/target)
// 	..()

/obj/item/weapon/baseballbat/metal
	// name = "baseball bat"
	desc = "A smooth metal club used in baseball to hit the ball. Or to purify your adversaries."
	icon_state = "bbat_metal"
	item_state = "bbat_metal"
	force = 13 //Nerfed, shouldn't be the best thing on the station since it can be mass-produced, still good though.
	throwforce = 10
	specthrow_maxwclass = 3 //You can bat normal sized items with metal bat

/obj/item/baseball
	name = "baseball"
	desc = "Pitch it to the batter."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bball"
	w_class = 1.0
	force = 0
	throwforce = 5
	throw_range = 7

/mob/living/carbon/human/hitby(atom/movable/AM, zone)
	..()
	if(!istype(AM, /obj/item/baseball))
		return
	if(!zone)
		zone = ran_zone("chest", 65)
	var/armor = getarmor(get_organ(check_zone(zone), "melee"))
	if(armor >= 100) return
	if(zone == "head") //Pure RNG to score a stun
		if(stat == CONSCIOUS && prob(50) && armor < 40) //High chance to make up for the already-RNG zone picking
			visible_message("<span class='danger'>[src] has been knocked unconscious!</span>", \
							"<span class='userdanger'>[src] has been knocked unconscious!</span>")
			apply_effect(10, PARALYZE, armor) //Since it's ranged, we don't want to make KO too OP
			ticker.mode.remove_revolutionary(mind)
			ticker.mode.remove_gangster(mind)