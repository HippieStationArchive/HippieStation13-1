/obj/item/weapon/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos"
	name = "syndicate minibomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"

/obj/item/weapon/grenade/syndieminibomb/prime(mob/living/carbon/user)
	update_mob()
	message_admins("A syndicate minibomb has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> last touched by [key_name_admin(fingerprintslast)]")
	log_game("A syndicate minibomb has exploded at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>([src.x],[src.y],[src.z])</a> last touched by [key_name_admin(fingerprintslast)]")
	explosion(src.loc,1,2,4,flame_range = 2)
	qdel(src)

/obj/item/weapon/grenade/syndieminibomb/concussion
	name = "HE Grenade"
	desc = "A compact shrapnel grenade meant to devestate nearby organisms and cause some damage in the process. Pull pin and throw opposite direction."
	icon_state = "concussion"
	origin_tech = "materials=3;magnets=4;syndicate=2"
