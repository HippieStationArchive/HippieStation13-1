/obj/item/weapon/reagent_containers/food/snacks
	name = "snack"
	desc = "Yummy."
	icon = 'icons/obj/food/food.dmi'
	icon_state = null
	var/bitesize = 2
	var/bitecount = 0
	var/trash = null
	var/slice_path    // for sliceable food. path of the item resulting from the slicing
	var/slices_num
	var/eatverb
	var/wrapped = 0
	var/dried_type = null
	var/potency = null
	var/dry = 0
	var/filling_color = "#FFFFFF" //color to use when added to custom food.
	var/custom_food_type = null  //for food customizing. path of the custom food to create
	var/junkiness = 0  //for junk food. used to lower human satiety.
	var/list/bonus_reagents = list() //the amount of reagents (usually nutriment and vitamin) added to crafted/cooked snacks, on top of the ingredients reagents.
	var/customfoodfilling = 1 // whether it can be used as filling in custom food

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/weapon/reagent_containers/food/snacks/proc/On_Consume()
	if(!usr)	return
	if(!reagents.total_volume)
		usr.unEquip(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item/weapon/grown))
				var/obj/item/TrashItem = new trash(usr,src.potency)
				usr.put_in_hands(TrashItem)
			else if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return


/obj/item/weapon/reagent_containers/food/snacks/attack_self(mob/user)
	return


/obj/item/weapon/reagent_containers/food/snacks/attack(mob/M, mob/user, def_zone)
	if(user.zone_sel.selecting =="groin" && user.a_intent == "grab")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/butt/B = H.getorgan(/obj/item/organ/internal/butt)
			if(B)
				if(!H.w_uniform)
					var/buttspace = B.capacity - B.stored
					if(!itemstorevalue)
						switch(w_class)
							if(1) itemstorevalue += 1 // tiny
							if(2) itemstorevalue += 2 // small
							if(3) itemstorevalue += 4 // normal
							else itemstorevalue = -1 // too big
					if(itemstorevalue != -1)//if the item is not too big
						if(B.stored < B.capacity && itemstorevalue <= buttspace) // if the butt can still hold an item
							if(H == user)
								user.visible_message("<span class='notice'>You stuff \the [src] into your butt.</span>", "<span class='warning'>[user] stuffs \the [src] into his own butt.</span>")
							else
								H.visible_message("<span class='warning'>[user] attempts to stuff \the [src] inside [H]'s butt...</span>", "<span class='warning'>You attempt to stuff \the [src] inside [H]'s butt...</span>")
								if(!do_mob(user, H))
									if(H == user)
										user << "<span class='warning'>You fail to stuff \the [src] in your butt.</span>"
									else
										user << "<span class='warning'>You fail to stuff \the [src] in [H]'s butt.</span>"
									return 0
								H.visible_message("<span class='danger'>[user] stuffs \the [src] inside [H]'s butt.</span>", "<span class='userdanger'>You stuff \the [src] inside [H]'s butt.</span>")
							user.unEquip(src)
							add_logs(user, M, "stuffed", object="[reagentlist(src)]")
							B.contents += src
							B.stored += itemstorevalue
							for(var/i = 1 to reagents.total_volume)
								if(!(src in B.contents))
									break
								sleep(50)
								reagents.trans_to(M, 1)
								i++
							if(trash)
								if(ispath(trash,/obj/item/weapon/grown))
									var/obj/item/TrashItem = new trash(usr,src.potency)
									B.contents += TrashItem
									TrashItem.itemstorevalue = itemstorevalue
								else if(ispath(trash,/obj/item))
									var/obj/item/TrashItem = new trash(usr)
									B.contents += TrashItem
									TrashItem.itemstorevalue = itemstorevalue
								else if(istype(trash,/obj/item))
									var/obj/item/T = trash
									B.contents += T
									T.itemstorevalue = itemstorevalue

							// Safely remove the item we have consumed
							if(B)
								if(B.contents)
									B.contents -= src

								B.stored -= itemstorevalue

							qdel(src)

							if(B.stored > B.capacity) // added this due to a trash item being inserted inside without any check, so stuff won't break,i am unsure on how useful this is
								var/obj/item/O = pick(B.contents)
								O.loc = get_turf(src)
								B.contents -= O
								B.stored -= O.itemstorevalue
								H << "<span class='warning'>Your butt cannot hold all those items, and one falls out!</span>"
							return 1
						else
							if(H == user)
								user << "<span class='warning'>Your butt is full!</span>"
							else
								user << "<span class='warning'>[H]'s butt is full!</span>"
							return 0
					else
						if(H == user)
							user << "<span class='warning'>This item is too big to fit in your butt!</span>"
						else
							user << "<span class='warning'>This item is too big to fit in [H]'s butt!</span>"
						return 0
				else
					if(H == user)
						user << "<span class='warning'>You'll need to remove your jumpsuit first.</span>"
					else
						user << "<span class='warning'>You'll need to remove [H]'s jumpsuit first.</span>"
						H << "<span class='warning'>You feel your butt being poked with \the [src]!</span>"
						user.visible_message("<span class='warning'>[user] pokes [H]'s butt with \the [src]!</span>", "<span class='warning'>You poke [H]'s butt with \the [src]!</span>")
					return 0
			else
				if(H == user)
					user << "<span class='warning'>You have no butt!</span>"
				else
					user << "<span class='warning'>[H] has no butt!</span>"
				return 0
		else
			user << "<span class='warning'>You can only do that to humans.</span>"
			return 0

	if(!eatverb)
		eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	if(!reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
		user << "<span class='notice'>None of [src] left, oh no!</span>"
		M.unEquip(src)	//so icons update :[
		qdel(src)
		return 0
	if(iscarbon(M))
		if(!canconsume(M, user))
			return 0

		var/fullness = M.nutrition + 10
		for(var/datum/reagent/consumable/C in M.reagents.reagent_list) //we add the nutrition value of what we're currently digesting
			fullness += C.nutriment_factor * C.volume / C.metabolization_rate

		if(M == user)								//If you're eating it yourself.
			if(junkiness && M.satiety < -150 && M.nutrition > NUTRITION_LEVEL_STARVING + 50 )
				M << "<span class='notice'>You don't feel like eating any more junk food at the moment.</span>"
				return 0

			if(wrapped)
				M << "<span class='warning'>You can't eat wrapped food!</span>"
				return 0
			else if(fullness <= 50)
				M << "<span class='notice'>You hungrily [eatverb] some of \the [src] and gobble it down!</span>"
			else if(fullness > 50 && fullness < 150)
				M << "<span class='notice'>You hungrily begin to [eatverb] \the [src].</span>"
			else if(fullness > 150 && fullness < 500)
				M << "<span class='notice'>You [eatverb] \the [src].</span>"
			else if(fullness > 500 && fullness < 600)
				M << "<span class='notice'>You unwillingly [eatverb] a bit of \the [src].</span>"
			else if(fullness > (600 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				M << "<span class='warning'>You cannot force any more of \the [src] to go down your throat!</span>"
				return 0
		else
			if(!isbrain(M))		//If you're feeding it to someone else.
				if(wrapped)
					return 0
				if(fullness <= (600 * (1 + M.overeatduration / 1000)))
					M.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>", \
										"<span class='userdanger'>[user] attempts to feed [M] [src].</span>")
				else
					M.visible_message("<span class='warning'>[user] cannot force anymore of [src] down [M]'s throat!</span>", \
										"<span class='warning'>[user] cannot force anymore of [src] down [M]'s throat!</span>")
					return 0

				if(!do_mob(user, M))
					return
				add_logs(user, M, "fed", reagentlist(src))
				M.visible_message("<span class='danger'>[user] forces [M] to eat [src].</span>", \
									"<span class='userdanger'>[user] feeds [M] to eat [src].</span>")

			else
				user << "<span class='warning'>[M] doesn't seem to have a mouth!</span>"
				return

		if(reagents)								//Handle ingestion of the reagent.
			if(M.satiety > -200)
				M.satiety -= junkiness
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(reagents.total_volume)
				var/fraction = min(bitesize/reagents.total_volume, 1)
				reagents.reaction(M, INGEST, fraction)
				reagents.trans_to(M, bitesize)
				bitecount++
				On_Consume()
			return 1

	return 0


/obj/item/weapon/reagent_containers/food/snacks/afterattack(obj/target, mob/user , proximity)
	return


/obj/item/weapon/reagent_containers/food/snacks/examine(mob/user)
	..()
	if(bitecount == 0)
		return
	else if(bitecount == 1)
		user << "[src] was bitten by someone!"
	else if(bitecount <= 3)
		user << "[src] was bitten [bitecount] times!"
	else
		user << "[src] was bitten multiple times!"


/obj/item/weapon/reagent_containers/food/snacks/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/storage))
		..() // -> item/attackby()
		return 0
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/S = W
		if(custom_food_type && ispath(custom_food_type))
			if(S.w_class > 2)
				user << "<span class='warning'>[S] is too big for [src]!</span>"
				return 0
			if(!S.customfoodfilling)
				user << "<span class='warning'>[src] can't be filled with [S]!</span>"
				return 0
			if(contents.len >= 20)
				user << "<span class='warning'>You can't add more ingredients to [src]!</span>"
				return 0
	var/sharp = W.is_sharp()
	if(sharp)
		if(slice(sharp, W, user))
			return 1

//Called when you finish tablecrafting a snack.
/obj/item/weapon/reagent_containers/food/snacks/CheckParts()
	if(bonus_reagents.len)
		for(var/r_id in bonus_reagents)
			var/amount = bonus_reagents[r_id]
			reagents.add_reagent(r_id, amount)

/obj/item/weapon/reagent_containers/food/snacks/proc/slice(accuracy, obj/item/weapon/W, mob/user)
	if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
		return 0

	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/optable) in src.loc) && \
			!(locate(/obj/item/weapon/storage/bag/tray) in src.loc) \
		)
		user << "<span class='warning'>You cannot slice [src] here! You need a table or at least a tray.</span>"
		return 1

	var/slices_lost = 0
	if (accuracy >= IS_SHARP_ACCURATE)
		user.visible_message( \
			"[user] slices [src].", \
			"<span class='notice'>You slice [src].</span>" \
		)
	else
		user.visible_message( \
			"[user] inaccurately slices [src] with [W]!", \
			"<span class='notice'>You inaccurately slice [src] with your [W]!</span>" \
		)
		slices_lost = rand(1,min(1,round(slices_num/2)))

	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i=1 to (slices_num-slices_lost))
		var/obj/item/weapon/reagent_containers/food/snacks/slice = new slice_path (loc)
		initialize_slice(slice, reagents_per_slice)
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/proc/initialize_slice(obj/item/weapon/reagent_containers/food/snacks/slice, reagents_per_slice)
	slice.create_reagents(slice.volume)
	reagents.trans_to(slice,reagents_per_slice)
	return

/obj/item/weapon/reagent_containers/food/snacks/proc/update_overlays(obj/item/weapon/reagent_containers/food/snacks/S)
	overlays.Cut()
	var/image/I = new(src.icon, "[initial(icon_state)]_filling")
	if(S.filling_color == "#FFFFFF")
		I.color = pick("#FF0000","#0000FF","#008000","#FFFF00")
	else
		I.color = S.filling_color

	overlays += I

// initialize_cooked_food() is called when microwaving the food
/obj/item/weapon/reagent_containers/food/snacks/proc/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/S, cooking_efficiency = 1)
	S.create_reagents(S.volume)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)
	if(S.bonus_reagents.len)
		for(var/r_id in S.bonus_reagents)
			var/amount = S.bonus_reagents[r_id] * cooking_efficiency
			S.reagents.add_reagent(r_id, amount)

/obj/item/weapon/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.loc = get_turf(src)
	return ..()

/obj/item/weapon/reagent_containers/food/snacks/attack_animal(mob/M)
	if(isanimal(M))
		if(iscorgi(M))
			if(bitecount == 0 || prob(50))
				M.emote("me", 1, "nibbles away at \the [src]")
			bitecount++
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where \the [src] was")
				if(sattisfaction_text)
					M.emote("me", 1, "[sattisfaction_text]")
				qdel(src)


//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use omnizine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.

//All foods are distributed among various categories. Use common sense.

/////////////////////////////////////////////////Store////////////////////////////////////////
// All the food items that can store an item inside itself, like bread or cake.


/obj/item/weapon/reagent_containers/food/snacks/store
	w_class = 3
	var/stored_item = 0

/obj/item/weapon/reagent_containers/food/snacks/store/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(W.w_class <= 2 & !istype(W, /obj/item/weapon/reagent_containers/food/snacks)) //can't slip snacks inside, they're used for custom foods.
		if(W.is_sharp())
			return 0
		if(stored_item)
			return 0
		if(!iscarbon(user))
			return 0
		if(contents.len >= 20)
			user << "<span class='warning'>[src] is full.</span>"
			return 0
		user << "<span class='notice'>You slip [W] inside [src].</span>"
		user.unEquip(W)
		add_fingerprint(user)
		contents += W
		stored_item = 1
		return 1 // no afterattack here

/obj/item/weapon/reagent_containers/food/snacks/MouseDrop(atom/over)
	var/turf/T = get_turf(src)
	var/obj/structure/table/TB = locate(/obj/structure/table) in T
	if(TB)
		TB.MouseDrop(over)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/deepfryholder
	name = "Deep Fried Foods Holder Obj"
	icon_state = "deepfried_holder_icon"
	bitesize = 2
