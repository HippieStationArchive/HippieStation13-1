/obj/item/weapon/
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	
	var/melee_rename = 0
	var/melee_reskin = 0
	var/mreskinned = 0
	var/list/moptions = list()
	
/obj/item/weapon/proc/rename_wopit(mob/M)
	var/input = stripped_input(M,"What do you want to name the wopit?", ,"", MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src) && !M.restrained() && M.canmove)
		name = input
		M << "You name the wopit [input]. Say hello to your new friend."
		return
		
/obj/item/weapon/proc/reskin_wopit(mob/M)
	var/choice = input(M,"Warning, you can only reskin your wopit once!","Reskin Wopit") in moptions

	if(src && choice && !M.stat && in_range(M,src) && !M.restrained() && M.canmove)
		if(moptions[choice] == null)
			return
		else
			icon_state = moptions[choice]
			item_state = moptions[choice]
		M << "Your wopit is now skinned as [choice]. Say hello to your new friend."
		mreskinned = 1
		return

/obj/item/weapon/New()
	..()
	if(!hitsound)
		if(damtype == BURN)
			hitsound = 'sound/items/welder.ogg'
		if(damtype == BRUTE)
			hitsound = "swing_hit"
