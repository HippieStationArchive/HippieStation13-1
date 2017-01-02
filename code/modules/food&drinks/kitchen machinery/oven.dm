var/global/list/oven_choices = typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook)
var/global/list/candy_choices = typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/candy)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/candy)
var/global/list/still_choices = typesof(/obj/item/weapon/reagent_containers/food/drinks/bottle/customizable/)-(/obj/item/weapon/reagent_containers/food/drinks/bottle/customizable/)

/obj/machinery/cooking
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"
	var/orig = "oven"
	var/production_meth = "cooking"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	var/grown_only = 0
	idle_power_usage = 5
	var/on = FALSE	//Is it making food already?
	var/list/food_choices = list()
	var/pickcolor = 0 //Does it let you pick color?
/obj/machinery/cooking/New()
	..()
	updatefood()

/obj/machinery/cooking/attackby(obj/item/I, mob/user)
	if(on)
		user << "The machine is already running."
		return
	if(istype(I,/obj/item/weapon/wrench))
		if(!anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			anchored = 1
			user << "You wrench [src] in place."
			return
		else if(anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			anchored = 0
			user << "You unwrench [src]."
			return
	if(!anchored)
		user << "The machine must be anchored to be usable!"
		return
	if(!istype(I,/obj/item/weapon/reagent_containers/food/snacks/))
		user << "That isn't food."
		return
	if(!istype(I,/obj/item/weapon/reagent_containers/food/snacks/grown/) && grown_only)
		user << "You can only still grown items."
		return

	var/obj/item/weapon/reagent_containers/food/snacks/F = I
	var/obj/item/weapon/reagent_containers/food/C
	var/colorpick
	user.drop_item()
	F.loc = src
	C = input("Select food to make.", "Cooking", C) in food_choices
	if(!C)
		return
	if(pickcolor)
		var/temp = input(user, "Please select color.", "Candy color") as color
		if (user.restrained() || user.stat)
			return
		colorpick = temp
	user << "You put [F] into [src] for [production_meth]."
	user.drop_item()
	F.loc = src
	on = TRUE
	icon_state = "[orig]_on"
	sleep(100)
	on = FALSE
	icon_state = "[orig]_off"
	var/obj/item/weapon/reagent_containers/food/foodtype = new C.type(src.loc)
	foodtype.loc = get_turf(src)
	if(colorpick)
		F.filling_color = colorpick
	foodtype.attackby(F,user) //why
	// user << "[colorpick] color"
	playsound(loc, 'sound/machines/ding.ogg', 50, 1, -7)
	// return

/obj/machinery/cooking/proc/updatefood()
	return

/obj/machinery/cooking/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon_state = "oven_off"
	pickcolor = 1

/obj/machinery/cooking/oven/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/cook/V = new U
		src.food_choices += V
	return

/obj/machinery/cooking/candy
	name = "candy machine"
	desc = "Get yer box of deep fried deep fried deep fried deep fried cotton candy cereal sandwich cookies here!"
	icon_state = "mixer_off"
	orig = "mixer"
	production_meth = "candizing"
	pickcolor = 1

/obj/machinery/cooking/candy/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/candy)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/candy))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/candy/V = new U
		src.food_choices += V
	return

//Currently broken. attackby checks for snacks when this uses drinks.
/obj/machinery/cooking/still
	name = "still"
	desc = "Alright, so, t'make some moonshine, fust yo' gotta combine some of this hyar egg wif th' deep fried sausage."
	icon_state = "still_off"
	orig = "still"
	grown_only = 1
	production_meth = "brewing"
	pickcolor = 1


/obj/machinery/cooking/still/New()
	var/list/foodtemp = still_choices
	still_choices = list()
	for(var/F in foodtemp)
		var/obj/item/weapon/reagent_containers/food/drinks/bottle/customizable/V = new F
		still_choices.Add(V)
	..()

/obj/machinery/cooking/still/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/cook/V = new U
		src.food_choices += V
	return
