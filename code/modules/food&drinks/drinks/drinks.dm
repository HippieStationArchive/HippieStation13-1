////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	flags = OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,25)
	volume = 50
	banned_reagents = list("pacid","sacid")

/obj/item/weapon/reagent_containers/food/drinks/on_reagent_change()
	if (gulp_size < 5) gulp_size = 5
	else gulp_size = max(round(reagents.total_volume / 5), 5)

/obj/item/weapon/reagent_containers/food/drinks/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/drinks/examine()
	..()
	if (!(usr in range(0)) && usr!=src.loc) return
	if(!reagents || reagents.total_volume==0)
		usr << "\blue \The [src] is empty!"
	else if (reagents.total_volume<=src.volume/4)
		usr << "\blue \The [src] is almost empty!"
	else if (reagents.total_volume<=src.volume*0.66)
		usr << "\blue \The [src] is half full!"
	else if (reagents.total_volume<=src.volume*0.90)
		usr << "\blue \The [src] is almost full!"
	else
		usr << "\blue \The [src] is full!"

/obj/item/weapon/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)

	if(!reagents || !reagents.total_volume)
		user << "<span class='alert'>None of [src] left, oh no!</span>"
		return 0

	if(!canconsume(M, user))
		return 0

	if(M == user)
		M << "<span class='notice'>You swallow a gulp of [src].</span>"
		if(reagents.total_volume)
			reagents.reaction(M, INGEST)
			spawn(5)
				reagents.trans_to(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
		return 1

	M.visible_message("<span class='warning'>[user] attempts to feed [src] to [M].</span>")
	if(!do_mob(user, M)) return
	if(!reagents.total_volume) return // The drink might be empty after the delay, such as by spam-feeding
	M.visible_message("<span class='warning'>[user] feeds [src] to [M].</span>")
	add_logs(user, M, "fed", object="[reagentlist(src)]")
	if(reagents.total_volume)
		reagents.reaction(M, INGEST)
		spawn(5)
			reagents.trans_to(M, gulp_size)

	playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
	return 1


/obj/item/weapon/reagent_containers/food/drinks/afterattack(obj/target, mob/user , proximity)
	if(!proximity) return
	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

		if(!target.reagents.total_volume)
			user << "<span class='warning'>[target] is empty.</span>"
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			user << "<span class='warning'>[src] is full.</span>"
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		user << "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>"

	// Banned reagent checker ported from every other container that already utilizes it.
	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(istype(target, /obj/item/weapon/reagent_containers/spray))
			var/obj/item/weapon/reagent_containers/RC = target // copied from glass regant checker
			for(var/bad_reg in RC.banned_reagents)
				if(reagents.has_reagent(bad_reg, 1)) //Message is a bit "Game-y" but I can't think up a better one.
					user << "<span class='warning'>A chemical in [src] is far too dangerous to transfer to [target]!</span>"
					return

		if(!reagents.total_volume)
			user << "<span class='warning'>[src] is empty.</span>"
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			user << "<span class='warning'>[target] is full.</span>"
			return
		var/refill = reagents.get_master_reagent_id()
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		user << "<span class='notice'> You transfer [trans] units of the solution to [target].</span>"

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			var/mob/living/silicon/robot/bro = user
			bro.cell.use(30)
			spawn(600)
				reagents.add_reagent(refill, trans)

	return

////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	w_class = 4
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = CONDUCT | OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/golden_cup/tournament_26_06_2011
	desc = "A golden cup. It will be presented to a winner of tournament 26 june and name of the winner will be graved on it."


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "Space Milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"

/obj/item/weapon/reagent_containers/food/drinks/milk/New()
	..()
	reagents.add_reagent("milk", 50)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"

/obj/item/weapon/reagent_containers/food/drinks/flour/New()
	..()
	reagents.add_reagent("flour", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "SoyMilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"

/obj/item/weapon/reagent_containers/food/drinks/soymilk/New()
	..()
	reagents.add_reagent("soymilk", 50)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"

/obj/item/weapon/reagent_containers/food/drinks/coffee/New()
	..()
	reagents.add_reagent("coffee", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "tea"
	item_state = "coffee"

/obj/item/weapon/reagent_containers/food/drinks/tea/New()
	..()
	reagents.add_reagent("tea", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"

/obj/item/weapon/reagent_containers/food/drinks/ice/New()
	..()
	reagents.add_reagent("ice", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "tea"
	item_state = "coffee"

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate/New()
	..()
	reagents.add_reagent("hot_coco", 30)
	reagents.add_reagent("sugar", 5)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen/New()
	..()
	reagents.add_reagent("dry_ramen", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/beer
	name = "Space Beer"
	desc = "Beer. In space."
	icon_state = "beer"

/obj/item/weapon/reagent_containers/food/drinks/beer/New()
	..()
	reagents.add_reagent("beer", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"

/obj/item/weapon/reagent_containers/food/drinks/ale/New()
	..()
	reagents.add_reagent("ale", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/sillycup
	name = "Paper Cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10

/obj/item/weapon/reagent_containers/food/drinks/sillycup/New()
	..()
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "Shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 100

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "captain's flask"
	desc = "A silver flask belonging to the captain"
	icon_state = "flask"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/flask/det
	name = "detective's flask"
	desc = "The detective's only true friend."
	icon_state = "detflask"
	New()
		..()
		reagents.add_reagent("whiskey", 30)

/obj/item/weapon/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the british flag emblazoned on it."
	icon_state = "britcup"
	volume = 30

//////////////////////////soda_cans//
//These are in their own group to be used as IED's in /obj/item/weapon/grenade/ghettobomb.dm

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/attack(mob/M, mob/user)
	if(M == user && !src.reagents.total_volume && user.a_intent == "harm" && user.zone_sel.selecting == "head")
		user.visible_message("<span class='notice'>[user] crushes the can of [src] on \his forehead!</span>", "<span class='notice'>You crush the can of [src] on your forehead!</span>")
		playsound(user.loc,'sound/weapons/pierce.ogg', rand(10,50), 1)
		var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(user.loc)
		crushed_can.icon_state = icon_state
		qdel(src)
	..()

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola/New()
	..()
	reagents.add_reagent("cola", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/tonic
	name = "T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/tonic/New()
	..()
	reagents.add_reagent("tonic", 50)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/sodawater
	name = "Soda Water"
	desc = "A can of soda water. Why not make a scotch and soda?"
	icon_state = "sodawater"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/sodawater/New()
	..()
	reagents.add_reagent("sodawater", 50)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/lemon_lime
	name = "Orange Soda"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/lemon_lime/New()
	..()
	name = "Lemon-Lime Soda"
	reagents.add_reagent("lemon_lime", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_up/New()
	..()
	reagents.add_reagent("space_up", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/starkist
	name = "Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/starkist/New()
	..()
	reagents.add_reagent("cola", 15)
	reagents.add_reagent("orangejuice", 15)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_mountain_wind
	name = "Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_mountain_wind/New()
	..()
	reagents.add_reagent("spacemountainwind", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsably."
	icon_state = "thirteen_loko"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/thirteenloko/New()
	..()
	reagents.add_reagent("thirteenloko", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/dr_gibb
	name = "Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/dr_gibb/New()
	..()
	reagents.add_reagent("dr_gibb", 30)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

