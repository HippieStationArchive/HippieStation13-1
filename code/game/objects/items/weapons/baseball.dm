/*Contains:
*	Baseball bats
*	Baseball ball
*/

/obj/item/weapon/baseballbat
	name = "baseball bat"
	desc = "A smooth wooden club used in baseball to hit the ball. Or to purify your adversaries."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bbat"
	item_state = "bbat"
	slot_flags = SLOT_BELT //Including the belt sprite to look cool
	force = 12 //moderate force
	throwforce = 10
	throw_speed = 3
	throw_range = 4

	//Special variables for special functionality. I don't define vars or add on to procs here because I'd go insane doing that.
	//Check items.dm for var definitions
	special_throw = 1
	deflectItem = 1
	specthrowsound = 'sound/weapons/basebat.ogg'
	throwrange_mult = 1.5 //Increases throw range by 1.5
	throwforce_mult = 1.5 //Multiply the throwforce of thrown object meagerly
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
	force = 15 //as strong as a null rod, supergood
	throwforce = 12
	specthrow_maxwclass = 3 //You can bat normal items with metal bat

//TODO: Add knockout chance to baseball
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
	if(!zone)
		zone = ran_zone("chest", 65)
	var/armor = run_armor_check(get_organ(check_zone(zone)), "melee", "<span class='warning'>Your armor has protected your [parse_zone(zone)].</span>", "<span class='warning'>Your armor has softened a hit to your [parse_zone(zone)].</span>")
	if(armor >= 100) return
	if(zone == "head") //Pure RNG to score a stun
		if(stat == CONSCIOUS && prob(60) && armor < 50) //High chance to make up for the already-RNG zone picking
			visible_message("<span class='danger'>[src] has been knocked unconscious!</span>", \
							"<span class='userdanger'>[src] has been knocked unconscious!</span>")
			apply_effect(20, PARALYZE, armor)
			ticker.mode.remove_revolutionary(mind)
			ticker.mode.remove_gangster(mind)