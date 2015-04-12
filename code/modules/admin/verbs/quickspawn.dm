/client/proc/spawn_human()
	set category = "Debug"
	set name = "Spawn Human"

	if(!check_rights(R_SPAWN))	return
	var/turf/T = get_turf(src.mob)
	new /mob/living/carbon/human(T)
	T.turf_animation('icons/effects/96x96.dmi',"beamin",-32,0,MOB_LAYER+1,'sound/misc/adminspawn.ogg')
	feedback_add_details("admin_verb","SH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!