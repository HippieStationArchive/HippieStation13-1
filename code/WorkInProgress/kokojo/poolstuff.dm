/mob
  var/swimming = 0

/turf/simulated/pool
	name = "pool"
	icon = 'icons/turf/pool.dmi'
	thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/obj/item
	var/image/in_water = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite


/mob
	var/image/in_water = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite


//
/turf/simulated/pool/water/Entered(atom/A)
	if(iscarbon(A))
		var/icon/I = new /icon(icon, icon_state)
		I.Blend(new /icon('icons/turf/pool.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
		I.Blend(new /icon('icons/turf/pool.dmi', "overlay"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparent
		//not sure if this is worth it. It attaches the blood_overlay to every item of the same type if they don't have one already made.
		for(var/mob/living/carbon/swimmer in src.loc)
			if(swimmer.type == type && !swimmer.in_water)
				swimmer.in_water = image(I)



/turf/simulated/pool/poolborder
	name = "Pool Border"
	desc = "No running around the pool!"
	density = 0
	icon_state = "side"


/turf/simulated/pool/water/
	name = "poolwater"
	desc = "You're safer here than in the deep."
	icon_state = "shallow"

/turf/simulated/pool/poolborder/Entered(atom/A, atom/OL)
	var/mob/living/carbon/nonwalker = A
	..()
	if(iscarbon(nonwalker) && !nonwalker.lying && nonwalker.m_intent != "walk")
		if(prob(1))
			nonwalker.Stun(2)
			nonwalker.Weaken(2)
			nonwalker.adjustBruteLoss(2)
			playsound(nonwalker.loc, 'sound/misc/slip.ogg', 50, 1, -3)

//Put people out of the water
/turf/simulated/pool/poolborder/MouseDrop_T(mob/M as mob, mob/user as mob)
	var/mob/living/carbon/human/acting = user
	var/mob/living/carbon/human/actee = M
	if( user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
		return
	if(M.swimming == !1) //can't put yourself up if you are not swimming
		return
	else
		if(user == M)
			M.visible_message("<span class='notice'>[user] is getting out the pool", \
							"<span class='notice'>You start getting out of the pool.</span>")
			if(do_mob(user, M, 20))
				M.loc = src
				M.swimming = 0
				user << "<span class='notice'>You get out of the pool.</span>"
				if(acting.staminaloss > 38 && acting.staminaloss < 45)
					user << "<span class='notice'>You feel refreshed and cleaned by the exercise!</span>"
					user.reagents.add_reagent("hyperzine", 5)
					user.reagents.add_reagent("anti_toxin", 3)
		else
			M.visible_message("<span class='notice'>You start getting [M] out of the pool.", \
							"<span class='notice'>[M] is being pulled to the poolborder by [user].</span>")
			if(do_mob(user, M, 20))
				M.loc = src
				M.swimming = 0
				user << "<span class='notice'>You get [M] out of the pool.</span>"
				if(actee.staminaloss > 38 && actee.staminaloss < 45)
					M << "<span class='notice'>You feel refreshed and cleaned by the exercise!</span>"
					M.reagents.add_reagent("hyperzine", 5)
					M.reagents.add_reagent("anti_toxin", 3)
				return

//put people in water, including you
/turf/simulated/pool/water/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
		return
	if(!ishuman(user)) // no silicons or drones in mechas.
		return
	if(M.swimming == 1) //can't lower yourself again
		return
	else
		if(user == M)
			M.visible_message("<span class='notice'>[user] is descending in the pool", \
							"<span class='notice'>You start lowering yourself in the pool.</span>")
			if(do_mob(user, M, 20))
				M.loc = src
				M.swimming = 1
				user << "<span class='notice'>You lower yourself in the pool.</span>"
		else
			M.visible_message("<span class='notice'>You start lowering [M] in the pool.", \
							"<span class='notice'>[M] is being put in the water by [user].</span>")
			if(do_mob(user, M, 20))
				M.loc = src
				M.swimming = 1
				user << "<span class='notice'>You lower [M] in the water.</span>"
				return

/turf/simulated/pool/water/Entered(atom/movable/Z, atom/OL) //EMP code + water overlay.
	..()
//	generate_water_overlay()
	Z.emp_act(1)



//What happens if you don't drop in it like a good person would
/turf/simulated/pool/water/Entered(atom/A, atom/OL)
	..()
	if (istype(A,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/swimborg = A
		swimborg << "<span class='userdanger'>Your magnesium core explodes in reaction to the water!</span>"
		swimborg.self_destruct()
		if(swimborg.connected_ai)
			swimborg.connected_ai << "<br><br><span class='alert'>ALERT - Cyborg magnesium core failure detected: [swimborg.name]</span><br>"
	else if(iscarbon(A))
		var/mob/living/carbon/human/huuman = A
		huuman.staminaloss += 1
		huuman.overlays += image('icons/turf/pool.dmi', "overlay")
		if(huuman.swimming == 1 || huuman.layer == 5.1) //People on the swimmingboard should not trigger messages
			playsound(src, 'sound/items/water_shake.ogg', 20, 1)
			huuman.ExtinguishMob()
			return
		if(huuman.swimming == 0)
			if(istype(huuman, /mob/living/carbon))
				if (huuman.wear_mask)
					for(var/mob/B in viewers(huuman, 7))
						B.show_message("<span class='notice'>[huuman] falls in the water!</span>", 1)
						playsound(src, 'sound/effects/splash.ogg', 60, 1, 1)
						huuman.Weaken(1)
						huuman.swimming = 1
						huuman.ExtinguishMob()
					return
				else
					huuman.drop_item()
					huuman.adjustOxyLoss(10)
					if (huuman.coughedtime != 1)
						huuman.coughedtime = 1
						huuman.emote("cough")
						spawn(20)
							if(huuman && huuman.loc)
								huuman.coughedtime = 0
					for(var/mob/B in viewers(huuman, 7))
						B.show_message("<span class='danger'>[huuman] falls in and takes a drink!</span>", 1)
						playsound(src, 'sound/effects/splash.ogg', 60, 1, 1)
						huuman.Weaken(3)
						huuman.swimming = 1
						huuman.ExtinguishMob()
			else
				return


/obj/structure/pool
	name = "pool"
	icon = 'icons/turf/pool.dmi'
	anchored = 1

/obj/structure/pool/ladder
	name = "Ladder"
	icon_state = "ladder"
	desc = "Are you getting in or are you getting out?."
	dir=4

/obj/structure/pool/ladder/attack_hand(mob/user as mob)
	if(iscarbon(user))
		var/mob/living/carbon/ladderman = user
		if(ladderman.y == src.y && ladderman.swimming == 0)
			ladderman.swimming = 1
			sleep(1)
			var/atom/move_target = get_edge_target_turf(src, dir)
			step_towards(ladderman, move_target)
		else if(ladderman.y == src.y && ladderman.x == src.x && ladderman.swimming == 1)
			ladderman.swimming = 0
			sleep(1)
			world << "2[src] 3[ladderman]"

			step_towards(ladderman, src)

/obj/structure/pool/Rboard
	name = "JumpBoard"
	density = 1
	icon_state = "boardright"
	desc = "The less-loved portion of the jumping board."
	dir = 4

/obj/structure/pool/Rboard/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/pool/Lboard
	name = "JumpBoard"
	icon_state = "boardleft"
	desc = "Get on there to jump!"
	layer = 5
	dir = 8
	var/jumping = 0

/obj/structure/pool/Lboard/proc/backswim(obj/O as obj, mob/user as mob) //Puts the sprite back to it's maiden condition after a jump.
	if(jumping == 1)
		for(var/mob/jumpee in src.loc) //hackzors.
			playsound(jumpee, 'sound/effects/splash.ogg', 60, 1, 1)
			jumpee.layer = 4
			jumpee.pixel_x = 0
			jumpee.pixel_y = 0
			jumpee.stunned = 1
			jumpee.swimming = 1

/obj/structure/pool/Lboard/attack_hand(mob/user as mob)
	if(iscarbon(user))
		var/mob/living/carbon/jumper = user
		if(jumping == 1)
			user << "<span class='notice'>Someone else is already making a jump!</span>"
			return
		var/turf/T = get_turf(src)
		if(user.swimming)
			return
		else
			switch( alert("Jump from the board?", "Jumpboard", "Yes!", "No!"))
				if("Yes!")
					jumper.visible_message("<span class='notice'>[user] climbs up \the [src]!</span>", \
										 "<span class='notice'>You climb up \the [src] and prepares to jump!</span>")
					jumper.canmove = 0
					jumper.stunned = 4
					jumping = 1
					jumper.layer = 5.1
					jumper.pixel_x = 3
					jumper.pixel_y = 7
					jumper.dir=8
					spawn(1) //somehow necessary
						jumper.loc = T
						jumper.stunned = 4
						spawn(10)
							var/randn = rand(1, 100)
							switch(randn)
								if(1 to 20)
									jumper.visible_message("<span class='notice'>[user] goes for a small dive!</span>", \
														 "<span class='notice'>You go for a small dive.</span>")
									sleep(15)
									backswim()
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 1, 1)
								if(21 to 40)
									jumper.visible_message("<span class='notice'>[user] goes for a dive!</span>", \
														 "<span class='notice'>You're going for a dive!</span>")
									sleep(20)
									backswim()
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 2, 1)

								if(41 to 60)
									jumper.visible_message("<span class='notice'>[user] goes for a long dive! Stay far away!</span>", \
											"<span class='notice'>You're going for a long dive!!</span>")
									sleep(25)
									backswim()
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 3, 1)

								if(61 to 80)
									jumper.visible_message("<span class='notice'>[user] goes for a awesome dive! Don't stand in \his way!</span>", \
														 "<span class='notice'>You feel like this dive will be awesome</span>")
									sleep(30)
									backswim()
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 4, 1)
								if(81 to 91)
									sleep(20)
									backswim()
									jumper.visible_message("<span class='danger'>[user] misses \his step!</span>", \
												 "<span class='userdanger'>You misstep!</span>")
									var/atom/throw_target = get_edge_target_turf(src, dir)
									jumper.throw_at(throw_target, 0, 1)
									jumper.Weaken(5)
									jumper.adjustBruteLoss(10)

								if(91 to 100)
									jumper.visible_message("<span class='notice'>[user] is preparing for the legendary dive! Can he make it?</span>", \
														 "<span class='userdanger'>You start preparing for a legendary dive!</span>")
									jumper.SpinAnimation(7,1)

									sleep(30)
									if(prob(75))
										backswim()
										jumper.visible_message("<span class='notice'>[user] fails!</span>", \
												 "<span class='userdanger'>You can't quite do it!</span>")
										var/atom/throw_target = get_edge_target_turf(src, dir)
										jumper.throw_at(throw_target, 1, 1)
									else
										jumper.fire_stacks = min(1,jumper.fire_stacks + 1)
										jumper.IgniteMob()
										sleep(5)
										backswim()
										jumper.visible_message("<span class='danger'>[user] bursts into flame of pure awesomness!</span>", \
											 "<span class='userdanger'>No one can stop you now!</span>")
										var/atom/throw_target = get_edge_target_turf(src, dir)
										jumper.throw_at(throw_target, 8, 1)
							spawn(35)
								jumping = 0


				if("No!")
					return




/turf/simulated/pool/poolborder/CanPass(atom/movable/A, turf/T)
	var/obj/structure/stool/bed/B = A
	if (istype(A, /obj/structure/stool/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0
	else
		if(istype(A, /mob/living)) // You Shall Not Pass!
			var/mob/living/M = A
			if(M.swimming)
				return 0
	return ..()


/turf/simulated/pool/water/shallow
	icon_state = "shallow"

/turf/simulated/pool/water/deep
	desc = "Nanostrasen does not cover drowning."
	icon_state = "deep"

/obj/machinery/drain
	name = "Drain"
	icon = 'icons/turf/pool.dmi'
	icon_state = "drain"
	desc = "This is strangely useless."
	anchored = 1

/obj/machinery/poolfilter
	name = "Filter"
	icon = 'icons/turf/pool.dmi'
	icon_state = "filter"
	desc = "The part of the pool that swallows dangerous stuff"
	anchored = 1

/obj/machinery/pooldrain/emag_act(user as mob)
	if(!emagged)
		user << "\red You disable \the [src]'s shark filter. Run!" //you better be
		emagged = 1
		src.icon_state = "filter_b"
		spawn(50)
			if(prob(50))
				new /mob/living/simple_animal/hostile/shark(src.loc)
			else
				if(prob(50))
					new /mob/living/simple_animal/hostile/shark/kawaii(src.loc)
				else
					new /mob/living/simple_animal/hostile/shark/laser(src.loc)







//obj/item/weapon/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
//	if ((CLUMSY in user.mutations) && prob(50))
//		user << "<span class='danger'> You accidentally cut yourself with \the [src].</span>"
//		user.take_organ_damage(20)
//		return
//	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
//	return ..()



//Splash
//turf/simulated/pool/water/attackby(obj/O as obj, mob/user as mob)
//	visible_message("<span class='name'>[src]</span> splashes [obj] in the water!")





//	var/pushdirection // push things that get caught in the transit tile this direction

//turf/unsimulated/beach/water/New()
//	..()
//	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)
//standing	+= image("icon"='icons/effects/genetics.dmi', "icon_state"="fire_s", "layer"=-MUTATIONS_LAYER)





//shamelessly stolen from paradise. Credits to tigercat2000.
//Modified a lot by Kokojo, because of that damn UI. I mean FUCK.
/obj/machinery/poolcontroller
	name = "Pool Controller"
	desc = "A controller for the nearby pool."
	icon = 'icons/turf/pool.dmi'
	icon_state = "poolcnorm"
	anchored = 1
	density = 1
	var/amount_per_transfer_from_this = 5
	var/list/linkedturfs = list() //List contains all of the linked pool turfs to this controller, assignment happens on New()
	var/temperature = "normal" //The temperature of the pool, starts off on normal, which has no effects.
	var/temperaturecolor = "" //used for nanoUI fancyness
	var/srange = 5 //The range of the search for pool turfs, change this for bigger or smaller pools.
	var/linkedmist = list() //Used to keep track of created mist
	var/misted = 0 //Used to check for mist.
	var/chem_volume = 5


/obj/machinery/poolcontroller/New() //This proc automatically happens on world start
	create_reagents(chem_volume)
	for(var/turf/simulated/pool/water/W in range(srange,src)) //Search for /turf/simulated/beach/water in the range of var/srange
		src.linkedturfs += W //Add found pool turfs to the central list.
	..() //Changed to call parent as per MarkvA's recommendation

/obj/machinery/poolcontroller/emag_act(user as mob) //Emag_act, this is called when it is hit with a cryptographic sequencer.
	if(!emagged) //If it is not already emagged, emag it.
		user << "\red You disable \the [src]'s temperature safeguards." //Inform the mob of what emagging does.
		emagged = 1 //Set the emag var to true.

/obj/machinery/poolcontroller/attackby(obj/item/P as obj, mob/user as mob, params) //Proc is called when a user hits the pool controller with something.

	if(istype(P,/obj/item/device/multitool)) //If the mob hits the pool controller with a multitool, reset the emagged status
		if(emagged) //Check the emag status
			user << "\red You re-enable \the [src]'s temperature safeguards." //Inform the user that they have just fixed the safeguards.
			emagged = 0 //Set the emagged var to false.
			return
	if (istype(P,/obj/item/weapon/reagent_containers/glass/beaker/large))
		if (P.reagents.total_volume >= 100)
			if(adminlog)
				log_say("[key_name(user)] has spilled chemicals in the pool")
				message_admins("[key_name_admin(user)] has spilled chemicals in the pool .")
			var/transfered = P.reagents.trans_to(src, chem_volume)
			if(transfered)	//if reagents were transfered, show the message
				user << "<span class='danger'>You spill the reagents in the reagent duplicator</span>"

			else
				user << "<span class='danger'>You'll need more to have an effect on the pool.</span>"
		else
			user << "\red Nothing happens." //If not emagged, don't do anything, and don't tell the user that it can be emagged.

		return //Return, nothing else needs to be done.
	else //If it's not a multitool, defer to /obj/machinery/attackby
		..()

//procs
/obj/machinery/poolcontroller/proc/poison()
	for(var/turf/simulated/pool/water/W in linkedturfs)
		for(var/mob/living/swimee in W)
			reagents.reaction(swimee, INGEST)
			reagents.trans_to(swimee, 1)
	reagents.remove_any(1)

/obj/machinery/poolcontroller/process()
	updatePool() //Call the mob affecting proc
	poison()

/obj/machinery/poolcontroller/proc/updatePool()
	for(var/turf/simulated/pool/water/W in linkedturfs) //Check for pool-turfs linked to the controller.
		for(var/mob/M in W) //Check for mobs in the linked pool-turfs.
			//Sanity checks, don't affect robuts, AI eyes, and observers
//			if(isAIEye(M))
//				return
			if(issilicon(M))
				return
			if(isobserver(M))
				return
			//End sanity checks, go on
			switch(temperature) //Apply different effects based on what the temperature is set to.
				if("scalding") //Burn the mob.
					M.bodytemperature = min(500, M.bodytemperature + 35) //heat mob at 35k(elvin) per cycle
					if(M.bodytemperature >= 400 && !M.stat)
						M << "<span class='danger'>You're boiling alive!</span>"
					return

				if("frigid") //Freeze the mob.
					M.bodytemperature = max(80, M.bodytemperature - 35) //cool mob at -35k per cycle
					if(M.bodytemperature <= 215 && !M.stat)
						M << "<span class='danger'>You're  being frozen solid!</span>"
					return

				if("normal") //Normal temp does nothing, because it's just room temperature water.
					return

				if("warm") //Gently warm the mob.
					M.bodytemperature = min(360, M.bodytemperature + 20) //Heats up mobs till the termometer shows up
					return

				if("cool") //Gently cool the mob.
					M.bodytemperature = max(250, M.bodytemperature - 20) //Cools mobs till the termometer shows up
					return
		for(var/obj/effect/decal/cleanable/decal in W)
			del(decal)

/obj/machinery/poolcontroller/proc/miston() //Spawn /obj/effect/mist (from the shower) on all linked pool tiles
	for(var/turf/simulated/pool/water/W in linkedturfs)
		var/M = new /obj/effect/mist(W)
		if(misted)
			return
		linkedmist += M

	misted = 1 //var just to keep track of when the mist on proc has been called.

/obj/machinery/poolcontroller/proc/mistoff() //Delete all /obj/effect/mist from all linked pool tiles.
	for(var/obj/effect/mist/M in linkedmist)
		del(M)
	misted = 0 //no mist left, turn off the tracking var






/obj/machinery/poolcontroller/attack_hand(mob/user)
	user.set_machine(src)
	var/dat
	if(emagged)
		dat += "<a href='?src=\ref[src];Scalding=1'>Scalding</a><br>"
	dat += "<a href='?src=\ref[src];Warm=1'>Warm</a><br>"
	dat += "<a href='?src=\ref[src];Normal=1'>Normal</a><br>"
	dat += "<a href='?src=\ref[src];Cool=1'>Cool</a><br>"
	if(emagged)
		dat += "<a href='?src=\ref[src];Frigid=1'>Frigid</a><br>"

	var/datum/browser/popup = new(user, "Pool Controller", name, 350, 250)
	popup.set_content(dat)
	popup.open()

/obj/machinery/poolcontroller/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	if(href_list["Scalding"])
		src.temperature = "scalding"
		src.icon_state = "poolcscald"
		miston()
	if(href_list["Warm"])
		src.temperature = "warm"
		src.icon_state = "poolcwarm"
		mistoff()
	if(href_list["Normal"])
		src.temperature = "normal"
		src.icon_state = "poolcnorm"
		mistoff()
	if(href_list["Cool"])
		src.temperature = "cool"
		src.icon_state = "poolccool"
		mistoff()
	if(href_list["Frigid"])
		src.temperature = "frigid"
		src.icon_state = "poolcfrig"
		mistoff()
	update_icon()
	updateUsrDialog()

