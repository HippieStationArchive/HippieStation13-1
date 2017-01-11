/obj/machinery/monkey_recycler
	name = "monkey recycler"
	desc = "A machine used for recycling dead monkeys into monkey cubes. It currently produces 1 cube for every 5 monkeys inserted." // except it literally never does
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50
	var/grinded = 0
	var/required_grind = 5
	var/cube_production = 1


/obj/machinery/monkey_recycler/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/monkey_recycler(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	RefreshParts()

/obj/machinery/monkey_recycler/RefreshParts()
	var/req_grind = 5
	var/cubes_made = 1
	for(var/obj/item/weapon/stock_parts/manipulator/B in component_parts)
		req_grind -= B.rating
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		cubes_made = M.rating
	cube_production = cubes_made
	required_grind = req_grind
	src.desc = "A machine used for recycling dead monkeys into monkey cubes. It currently produces [cubes_made] cube(s) for every [required_grind] monkey(s) inserted."

/obj/machinery/monkey_recycler/attackby(obj/item/O, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", O))
		return

	if(exchange_parts(user, O))
		return

	if(default_pry_open(O))
		return

	if(default_unfasten_wrench(user, O))
		power_change()
		return

	default_deconstruction_crowbar(O)

	if (src.stat != 0) //NOPOWER etc
		return
	if (istype(O, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		if(!user.Adjacent(G.affecting))
			return
		var/grabbed = G.affecting
		if(ismonkey(grabbed))
			var/mob/living/carbon/monkey/target = grabbed
			if(target.stat == 0)
				user << "<span class='warning'>The monkey is struggling far too much to put it in the recycler.</span>"
				return
			if(target.buckled || target.buckled_mob)
				user << "<span class='warning'>The monkey is attached to something.</span>"
				return
			if(!user.drop_item())
				return
			qdel(target)
			user << "<span class='notice'>You stuff the monkey into the machine.</span>"
			playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
			var/offset = prob(50) ? -2 : 2
			animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
			use_power(500)
			grinded++
			sleep(50)
			pixel_x = initial(pixel_x) //return to its spot after shaking
			user << "<span class='notice'>The machine now has [grinded] monkey\s worth of material stored.</span>"

		else
			user << "<span class='danger'>The machine only accepts monkeys!</span>"
	return

/obj/machinery/monkey_recycler/attack_hand(mob/user)
	if (src.stat != 0) //NOPOWER etc
		return
	if(grinded >= required_grind)
		user << "<span class='notice'>The machine hisses loudly as it condenses the grinded monkey meat. After a moment, it dispenses a brand new monkey cube.</span>"
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, 1)
		grinded -= required_grind
		for(var/i = 0, i < cube_production, i++)
			new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src.loc)
		user << "<span class='notice'>The machine's display flashes that it has [grinded] monkeys worth of material left.</span>"
	else
		user << "<span class='danger'>The machine needs at least [required_grind] monkey(s) worth of material to produce a monkey cube. It only has [grinded].</span>"
	return
