//Conspicuously not-recent versions of suspicious cleanables

/obj/effect/decal/cleanable/blood/old
	name = "dried blood"
	desc = "Looks like it's been here a while.  Eew."
	amount = 0

/obj/effect/decal/cleanable/blood/old/New()
	..()
	color = adjust_brightness(color, -70) //Even less color than normal blood

/obj/effect/decal/cleanable/blood/old/dry() //We're already dry though
	return

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = "Oh god, why didn't anyone clean this up?  It smells terrible."
	amount = 0

/obj/effect/decal/cleanable/blood/gibs/old/New()
	..()
	dir = pick(1,2,4,8)
	color = adjust_brightness(color, -70)

/obj/effect/decal/cleanable/blood/gibs/old/dry() //We're already dry though
	return

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/old/New()
	..()
	icon_state += "-old"

/obj/effect/decal/cleanable/blood/gibs/robot/old
	name = "dusty robot debris"
	desc = "Looks like nobody has touched this in a while."