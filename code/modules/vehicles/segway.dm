/obj/structure/stool/bed/chair/janicart/secway
	name = "secway"
	desc = "A brave security cyborg gave its life to help you look like a complete tool."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "secway"
	callme = "secway"
	anchored = 0 //This is not so heavy

/obj/structure/stool/bed/chair/janicart/secway/relaymove(mob/user as mob, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	if(istype(user.l_hand, /obj/item/key/security) || istype(user.r_hand, /obj/item/key/security))
		if(!Process_Spacemove(direction))
			return
		step(src, direction)
		update_mob()
		handle_rotation()
	else
		user << "<span class='notice'>You'll need the keys in one of your hands to drive this [callme].</span>"

/obj/structure/stool/bed/chair/janicart/secway/update_mob()
	if(buckled_mob)
		buckled_mob.dir = dir
		buckled_mob.pixel_y = 4
