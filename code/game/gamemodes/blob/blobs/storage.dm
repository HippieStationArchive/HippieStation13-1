/obj/effect/blob/storage
	name = "storage blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_resource"
	desc = "A huge, smooth mass supported by tendrils."
	health = 60
	maxhealth = 60

/obj/effect/blob/storage/update_icon()
	if(health <= 0)
		overmind.max_blob_points -= 50
		qdel(src)

/obj/effect/blob/storage/PulseAnimation(activate = 0)
	if(activate)
		..()
	return

/obj/effect/blob/storage/proc/update_max_blob_points(new_point_increase)
	if(overmind)
		overmind.max_blob_points += new_point_increase