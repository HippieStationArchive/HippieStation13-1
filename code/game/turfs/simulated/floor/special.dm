/turf/simulated/floor/special
    name = "floor"
    icon = 'icons/turf/special.dmi'
    icon_state = "floor"

/turf/simulated/floor/special/New() //this is only to fix a fucking boxing ring
	..() // goddamn it Red you broke the air controller entirely with this shit - Iamgoofball
	icon_regular_floor = "[icon_state]"
	icon_plating = "[icon_state]p"
	broken_states = list("platingdmg1", "platingdmg2", "platingdmg3")
	burnt_states = list("panelscorched")
	..()