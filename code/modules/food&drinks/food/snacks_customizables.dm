//TO-DO: Somehow color overlays for custom snacks based on the general color of the item you put into it.

/obj/item/weapon/reagent_containers/food/snacks/breadslice/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/burger/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/flatbread/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/pizza/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/boiledspagetti/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/pasta/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)

/obj/item/trash/plate/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/fullycustom/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)

/obj/item/trash/bowl
	name = "bowl"
	desc = "An empty bowl. Put some food in it to start making a soup."
	icon = 'icons/obj/food.dmi'
	icon_state = "soup"

/obj/item/trash/bowl/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/soup/S = new(get_turf(user))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/customizable
	name = "sandwich"
	desc = "A sandwich! A timeless classic."
	icon_state = "breadslice"
	var/baseicon = "breadslice"
	var/basename = "sandwich"
	var/top = 1	//Do we have a top?
	var/add_overlays = 1	//Do we stack?
//	var/offsetstuff = 1 //Do we offset the overlays?
	var/sandwich_limit = 2000
	var/fullycustom = 0
	var/list/descriptors = list("absurd","colossal","enormous","ridiculous","massive","oversized","cardiac-arresting","pipe-clogging","edible but sickening","sickening","gargantuan","mega","belly-burster","chest-burster")
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/ingredients = list()

	New()
		..()
		reagents.add_reagent("nutriment", 8)

//Customizable snacks accessible by kitchen machinery moved to snacks_oven.dm

/obj/item/weapon/reagent_containers/food/snacks/customizable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	baseicon = "personal_pizza"
	basename = "personal pizza"
	add_overlays = 0
	top = 0

/obj/item/weapon/reagent_containers/food/snacks/customizable/pasta
	name = "spagetti"
	desc = "Noodles. With stuff. Delicious."
	icon_state = "pasta_bot"
	baseicon = "pasta_bot"
	basename = "spagetti"
	add_overlays = 0
	top = 0

/obj/item/weapon/reagent_containers/food/snacks/customizable/fullycustom // In the event you fuckers find something I forgot to add a customizable food for.
	name = "on a plate"
	desc = "A unique dish."
	icon_state = "fullycustom"
	baseicon = "fullycustom"
	basename = "on a plate"
	add_overlays = 0
	top = 0
	fullycustom = 1

/obj/item/weapon/reagent_containers/food/snacks/customizable/soup
	name = "soup"
	desc = "A bowl with liquid and... stuff in it."
	icon_state = "soup"
	baseicon = "soup"
	basename = "soup"
	add_overlays = 0
	trash = /obj/item/trash/bowl
	top = 0

/obj/item/weapon/reagent_containers/food/snacks/customizable/burger
	name = "burger bun"
	desc = "A bun for a burger. Delicious."
	icon_state = "burger"
	baseicon = "burger"
	basename = "burger"

/obj/item/weapon/reagent_containers/food/snacks/customizable/attackby(obj/item/W as obj, mob/user as mob)
	if(src.contents.len > sandwich_limit)
		user << "<span class='warning'>If you put anything else in or on [src] it's going to make a mess.</span>"
		return
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		user << "<span class='notice'> You add [W] to [src].</span>"
		var/obj/item/weapon/reagent_containers/F = W
		F.reagents.trans_to(src, F.reagents.total_volume)
		user.drop_item()
		W.loc = src
		ingredients += W
		update()
		return
	..()

/obj/item/weapon/reagent_containers/food/snacks/customizable/proc/update()
	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	overlays.Cut()

	for(var/obj/item/weapon/reagent_containers/food/snacks/O in ingredients)

		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == ingredients.len)
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		if(!fullycustom)
			var/image/I = new(src.icon, "[baseicon]_filling")
			if(istype(O, /obj/item/weapon/reagent_containers/food/snacks))
				var/obj/item/weapon/reagent_containers/food/snacks/food = O
				if(food.filling_color != "#FFFFFF")
					I.color = food.filling_color
				else
					I.color = pick("#FF0000","#0000FF","#008000","#FFFF00")
			if(add_overlays)
				I.pixel_x = rand(-1,1)
				I.pixel_y = (i*2)+1
			overlays += I
		else
			var/image/F = new(O.icon, O.icon_state)
			F.pixel_x = rand(-1,1)
			F.pixel_y = rand(-1,1)
			overlays += F
			overlays += O.overlays

	if(top)
		var/image/T = new(src.icon, "[baseicon]_top")
		T.pixel_x = rand(-1,1)
		T.pixel_y = (ingredients.len * 2)+1
		overlays += T

	name = lowertext("[fullname] [basename]")
	if(length(name) > 500) name = "[pick(descriptors)] [basename]"
	w_class = n_ceil(Clamp((ingredients.len/2),1,3))

/obj/item/weapon/reagent_containers/food/snacks/customizable/Destroy()
	for(var/obj/item/O in ingredients)
		del(O) // qdelling certain foods causes runtimes up the ass sometimes, best just to standard del()
	..()

/obj/item/weapon/reagent_containers/food/snacks/customizable/examine()
	..()
	if(ingredients.len)
		var/whatsinside = pick(ingredients)
		usr << "<span class='notice'> You think you can see [whatsinside] in there.</span>"


///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

// Flour + egg = dough
/obj/item/weapon/reagent_containers/food/drinks/flour/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/egg))
		new /obj/item/weapon/reagent_containers/food/snacks/dough(get_turf(user))
		user << "You make some dough."
		del(W)
		del(src)

// Egg + flour = dough
/obj/item/weapon/reagent_containers/food/snacks/egg/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/drinks/flour))
		new /obj/item/weapon/reagent_containers/food/snacks/dough(get_turf(user))
		user << "You make some dough."
		del(W)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough. You can cook it to make a bun!"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

// Dough + rolling pin = flat dough
/obj/item/weapon/reagent_containers/food/snacks/dough/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/kitchen/rollingpin))
		if(isturf(loc))
			new /obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough(loc)
			user << "<span class='notice'>You flatten [src].</span>"
			qdel(src)
		else
			user << "<span class='notice'>You need to put [src] on a surface to roll it out!</span>"
	else
		..()

// slicable into 3xdoughslices
/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough. You can cook it to make a flat bread!"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/doughslice
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/flatbread
	name = "flat bread"
	desc = "A cooked flat dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat bread"
	// slice_path = /obj/item/weapon/reagent_containers/food/snacks/doughslice
	// slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 20) //Tasty on it's own!

/obj/item/weapon/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish." //What dish????
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 1)

/obj/item/weapon/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)
