/obj/structure/reagent_dispensers
	name = "storage tank"
	desc = "It can hold large amount of chemicals."
	icon = 'icons/obj/chemtank.dmi'
	icon_state = "chemtank"
	density = 1
	anchored = 0
	pressure_resistance = 2*ONE_ATMOSPHERE
	var/list/brokenvars = list("storage tank", "chemtank", /obj/structure/reagent_dispensers)// when it blows up,what will it become,made it qdel src and make a statuelike thing to avoid having to change syringes,droppers,glasses etc with snowflakey checks
	var/exploded = 0 // if atleast one reaction happened in boom(), this becomes 1
	var/list/bypassUIicons = list( // list which have all the icons where reagent overlay and update_icon proc in general must not work
		"peppertank",
		"water_cooler",
		"beerkeg",
		"virusfoodtank",
		"honk_cooler",
	)

/obj/structure/reagent_dispensers/on_reagent_change()
	update_icon()

/obj/structure/reagent_dispensers/attack_hand()
	..()
	update_icon()

/obj/structure/reagent_dispensers/update_icon()
	overlays.Cut()
	if(icon_state in bypassUIicons) return // can't do overlay fun things on stuff like peppertank/virus tank/watercooler
	if(reagents.total_volume)
		switch(reagents.get_master_reagent_id())//is master chem weldingfuel?change the iconstate into weldingfuel tank,same for water
			if("welding_fuel")
				name = "fueltank"
				desc = "It can hold large amount of chemicals. Mainly used to hold fuel."
				icon_state = "weldtank"
			if("water")
				name = "watertank"
				desc = "It can hold large amount of chemicals. Mainly used to hold water."
				icon_state = "watertank"
			else
				name = "storage tank"
				desc = "It can hold large amount of chemicals."
				icon_state = "chemtank"
		var/image/filling = image('icons/obj/chemtank.dmi', src, "tankfilling1")
		var/percent = round((reagents.total_volume / reagents.maximum_volume) * 100)
		switch(percent)
			if(0 to 25)			filling.icon_state = "tankfilling1"
			if(25 to 50)		filling.icon_state = "tankfilling2"
			if(50 to 75)		filling.icon_state = "tankfilling3"
			if(75 to INFINITY)	filling.icon_state = "tankfilling4"
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling
	if(!(flags & INJECTONLY))//here we check the lid!we want it to appear if it's closed.
		var/image/lid = image('icons/obj/chemtank.dmi', src, "tanklid")
		overlays += lid

/obj/structure/reagent_dispensers/proc/boom(atom/A) // detonate and explode were already taken and i hate two procs with the same name
	if(A && istype(A, /mob))
		var/mob/user = A
		message_admins("[key_name_admin(user)] triggered a chemtank explosion at [src ? "[x],[y],[z]" : "Carbonhell fucked up again, whine at him"] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>.")
		log_game("[key_name(user)] triggered a chemtank explosion at [src ? "[x],[y],[z]" : "Carbonhell fucked up again, whine at him"].")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has detonated a chem tank @ [src ? "[x],[y],[z]" : "UNKNOWN LOCATION"]</font>")
	if(reagents && reagents.reagent_list.len && !exploded)
		reagents.chem_temp = 1000
		reagents.handle_reactions()
		if(!src) return 1// safety check,explosion could've deleted it!
		exploded = 1
		var/volumepereffect = reagents.total_volume / 9
		var/list/effectlist = list()
		visible_message("<span class='danger'>[src] ruptures, spraying its contents everywhere!</span>")
		spawn(-1)
			for(var/i in 1 to 11) // i will be later used for direction. i'm a smart man am i not?admit it fucker
				if(i == 3 || i == 7) continue // those aren't directions.
				var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src))
				W.create_reagents(200) // maximum it should hold is 200
				reagents.trans_to(W,volumepereffect)
				W.color = mix_color_from_reagents(W.reagents.reagent_list)
				if(i != 11) // 11 is for the effect on the same tile of the src
					step(W,i)
				for(var/atom/B in get_turf(W))
					if(B == W || B.invisibility) //we ignore the effect itself and stuff below the floor
						continue
					W.reagents.reaction(B, VAPOR)
				W.reagents.reaction(get_turf(W), TOUCH)
				effectlist += W
			for(var/i in 1 to effectlist.len)
				sleep(10)
				qdel(effectlist[i])
	new /obj/structure/brokentank(get_turf(src), broken = brokenvars)
	qdel(src)
	return 1

/obj/structure/reagent_dispensers/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if(prob(50))
				boom()
				return
		if(3)
			if(prob(5))
				boom()
				return
		else
	return

/obj/structure/reagent_dispensers/blob_act()
	boom()

/obj/structure/reagent_dispensers/fire_act()
	if(prob(50))
		boom()

/obj/structure/reagent_dispensers/attackby(obj/item/weapon/W, mob/user, params)
	if(!exploded)
		if(istype(W, /obj/item/weapon/screwdriver))
			if(!(flags & INJECTONLY))
				user << "<span class='notice'>You unfasten the tank's cap.</span>"
				flags |= INJECTONLY
			else
				user << "<span class='notice'>You fasten the tank's cap.</span>"
				flags &= ~INJECTONLY
	update_icon()
	return

/obj/structure/reagent_dispensers/New()
	..()
	create_reagents(1000)
	update_icon()

/obj/structure/reagent_dispensers/examine(mob/user)
	..()
	user << "It contains [reagents.total_volume] units."

/obj/structure/reagent_dispensers/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/beam)||istype(Proj,/obj/item/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(Proj.nodamage)
				return
			boom(Proj.firer)

////Roundstart dispensers
//watertank
/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "It can hold large amount of chemicals. Mainly used to hold water."
	icon_state = "watertank"
	brokenvars = list("watertank", "watertank", /obj/structure/reagent_dispensers/watertank)

/obj/structure/reagent_dispensers/watertank/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("water",1000)
	update_icon()

//fueltank
/obj/structure/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "It can hold large amount of chemicals. Mainly used to hold fuel."
	icon_state = "weldtank"
	brokenvars = list("fuel tank", "weldtank", /obj/structure/reagent_dispensers/fueltank)

/obj/structure/reagent_dispensers/fueltank/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("welding_fuel",1000)
	update_icon()

//peppertank
/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refill pepper spray canisters."
	icon_state = "peppertank"
	brokenvars = list("pepper spray refiller", "peppertank", /obj/structure/reagent_dispensers/peppertank)
	anchored = 1
	density = 0

/obj/structure/reagent_dispensers/peppertank/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("condensedcapsaicin",1000)

//watercooler
/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink"
	icon_state = "water_cooler"
	anchored = 1
	var/cups = 50
	brokenvars = list("water-cooler", "water_cooler", /obj/structure/reagent_dispensers/water_cooler)

/obj/structure/reagent_dispensers/water_cooler/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("water",500)

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/living/carbon/human/user)
	if((!istype(user)) || (user.stat))
		return
	if(cups <= 0)
		user << "<span class='warning'>No cups left!</span>"
		return
	cups--
	user.put_in_hands(new /obj/item/weapon/reagent_containers/food/drinks/sillycup)
	user.visible_message("[user] gets a cup from [src].","<span class='notice'>You get a cup from [src].</span>")

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/paper))
		if(!user.drop_item())
			return
		qdel(I)
		cups++
		return

	if (istype(I, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to tighten \the [src] to the floor...</span>"
			if (do_after(user, 20, target = src))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'>You tighten \the [src]'s casters. Anchoring it down.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to loosen \the [src]'s casters...</span>"
			if (do_after(user, 40, target = src))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'>You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				anchored = 0
	else
		..()

//beerkeg
/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon_state = "beerkeg"
	brokenvars = list("beer keg", "beerkeg", /obj/structure/reagent_dispensers/beerkeg)

/obj/structure/reagent_dispensers/beerkeg/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("beer",1000)

//virusfood
/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon_state = "virusfoodtank"
	anchored = 1
	density = 0
	brokenvars = list("virus food dispenser", "virusfoodtank", /obj/structure/reagent_dispensers/virusfood)

/obj/structure/reagent_dispensers/virusfood/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("virusfood", 1000)

//broken tank obj
/obj/structure/brokentank
	name = "broken storage tank"
	desc = "It can't hold anything, it's broken."
	icon = 'icons/obj/chemtank.dmi'
	icon_state = "chemtank"
	density = 1
	anchored = 0
	pressure_resistance = 2*ONE_ATMOSPHERE
	var/repairedpath = /obj/structure/reagent_dispensers

/obj/structure/brokentank/New(list/broken)
	..()
	name = "broken [broken[1]]"
	icon_state = "[broken[2]]broken"
	repairedpath = broken[3]

/obj/structure/brokentank/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			user << "<span class='notice'>You start fixing the holes inside [src]...</span>"
			if(do_after(user, 50, target = src))
				user << "<span class='notice'>You fix the holes inside [src].</span>"
				new repairedpath(get_turf(src), empty = 1)
				qdel(src)
	else
		user << "<span class='notice'>This is too broken to be helpful!Fix it with a welder.</span>"
	return

//honkcooler
/obj/structure/reagent_dispensers/honk_cooler
	name = "Honk-Cooler"
	desc = "A machine filled with the clown's thick juice! NICE!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "honk_cooler"
	anchored = 1
	var/cups = 50
	brokenvars = list("honk-cooler", "honk_cooler", /obj/structure/reagent_dispensers/honk_cooler)

/obj/structure/reagent_dispensers/honk_cooler/New(loc, empty = 0)
	..()
	if(!empty) reagents.add_reagent("banana",500)

/obj/structure/reagent_dispensers/honk_cooler/attack_hand(mob/living/carbon/human/user)
	if((!istype(user)) || (user.stat))
		return
	if(cups <= 0)
		user << "<span class='warning'>What? No cups?</span>"
		return
	cups--
	user.put_in_hands(new /obj/item/weapon/reagent_containers/food/drinks/sillycup)
	user.visible_message("[user] gets a cup from [src].","<span class='notice'>You get a cup from [src].</span>")

/obj/structure/reagent_dispensers/honk_cooler/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/paper))
		if(!user.drop_item())
			return
		qdel(I)
		cups++
		return

	if (istype(I, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to tighten \the [src] to the floor...</span>"
			if (do_after(user, 20, target = src))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'>You tighten \the [src]'s casters. Anchoring it down.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to loosen \the [src]'s casters...</span>"
			if (do_after(user, 40, target = src))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'>You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				anchored = 0
	else
		..()
