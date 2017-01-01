#define SKINTYPE_MONKEY 1
#define SKINTYPE_ALIEN 2
#define SKINTYPE_CORGI 3

#define MEATTYPE_MONKEY 1
#define MEATTYPE_ALIEN 2
#define MEATTYPE_CORGI 3

//////Kitchen Spike

/obj/structure/kitchenspike_frame
	name = "meatspike frame"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spikeframe"
	desc = "The frame of a meat spike."
	density = 1
	anchored = 0

/obj/structure/kitchenspike_frame/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if(default_unfasten_wrench(user, I))
		return
	else if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if(R.get_amount() >= 4)
			R.use(4)
			user << "<span class='notice'>You add spikes to the frame.</span>"
			var/obj/F = new /obj/structure/kitchenspike(src.loc,)
			transfer_fingerprints_to(F)
			qdel(src)

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals"
	density = 1
	anchored = 1
	buckle_lying = 0
	can_buckle = 1
	var/meat = 0
	var/occupied = 0
	var/meattype = null
	var/skin = 0
	var/skintype = null

/obj/structure/kitchenspike/attack_paw(mob/user)
	return src.attack_hand(usr)


/obj/structure/kitchenspike/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/crowbar))
		if(!src.buckled_mob)
			playsound(loc, 'sound/items/Crowbar.ogg', 100, 1)
			if(do_after(user, 20/I.toolspeed, target = src))
				user << "<span class='notice'>You pry the spikes out of the frame.</span>"
				new /obj/item/stack/rods(loc, 4)
				var/obj/F = new /obj/structure/kitchenspike_frame(src.loc,)
				transfer_fingerprints_to(F)
				qdel(src)
		else
			user << "<span class='notice'>You can't do that while something's on the spike!</span>"
		return
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		if(istype(G.affecting, /mob/living/carbon/monkey))
			if(src.occupied == 0)
				src.icon_state = "spikebloody"
				src.occupied = 1
				src.meat = 5
				src.meattype = MEATTYPE_MONKEY
				src.skin = 1
				src.skintype = SKINTYPE_MONKEY
				for(var/mob/O in viewers(src, null))
					O.show_message(text("<span class='danger'>[user] has forced [G.affecting] onto the spike, killing them instantly!</span>"))
				qdel(G.affecting)
				qdel(G)
		if(istype(G.affecting, /mob/living/carbon/alien))
			if(src.occupied == 0)
				src.icon_state = "spikebloodygreen"
				src.occupied = 1
				src.meat = 5
				src.meattype = MEATTYPE_ALIEN
				src.skin = 1
				src.skintype = SKINTYPE_ALIEN
				for(var/mob/O in viewers(src, null))
					O.show_message(text("<span class='danger'>[user] has forced [G.affecting] onto the spike, killing them instantly!</span>"))
				qdel(G.affecting)
				qdel(G)
		if(istype(G.affecting, /mob/living/simple_animal/pet/dog/corgi))
			if(src.occupied == 0)
				src.icon_state = "spikebloodycorgi"
				src.occupied = 1
				src.meat = 5
				src.meattype = MEATTYPE_CORGI
				src.skin = 1
				src.skintype = SKINTYPE_CORGI
				for(var/mob/O in viewers(src, null))
					O.show_message(text("<span class='danger'>[user] has forced [G.affecting] onto the spike, killing them instantly!</span>"))
				qdel(G.affecting)
				qdel(G)
		if(istype(G.affecting, /mob/living/))
			if(!buckled_mob && !occupied)
				if(do_mob(user, src, 120))
					if(buckled_mob) //to prevent spam/queing up attacks
						return
					if(G.affecting.buckled)
						return
					var/mob/living/H = G.affecting
					playsound(src.loc, "sound/effects/splat.ogg", 25, 1)
					H.visible_message("<span class='danger'>[user] slams [G.affecting] onto the meat spike!</span>", "<span class='userdanger'>[user] slams you onto the meat spike!</span>", "<span class='italics'>You hear a squishy wet noise.</span>")
					H.loc = src.loc
					H.emote("scream")
					if(istype(H, /mob/living/carbon/human)) //So you don't get human blood when you spike a giant spidere
						var/turf/pos = get_turf(H)
						pos.add_blood_floor(H)
					H.adjustBruteLoss(30)
					H.buckled = src
					H.dir = 2
					buckled_mob = H
					var/matrix/m180 = matrix(H.transform)
					m180.Turn(180)
					animate(H, transform = m180, time = 3)
					H.pixel_y = H.get_standard_pixel_y_offset(180)
					add_logs(user, H, "meatspiked")
					return
		user << "<span class='danger'>You can't use that on the spike!</span>"
		return
	..()

/obj/structure/kitchenspike/user_buckle_mob(mob/living/M, mob/living/user) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/kitchenspike/user_unbuckle_mob(mob/living/carbon/human/user)
	if(buckled_mob && buckled_mob.buckled == src)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message(\
				"[user.name] tries to pull [M.name] free of the [src]!",\
				"<span class='notice'>[user.name] is trying to pull you off the [src], opening up fresh wounds!</span>",\
				"<span class='italics'>You hear a squishy wet noise.</span>")
			if(!do_after(user, 300, target = src))
				if(M && M.buckled)
					M.visible_message(\
					"[user.name] fails to free [M.name]!",\
					"<span class='notice'>[user.name] fails to pull you off of the [src].</span>")
				return

		else
			M.visible_message(\
			"<span class='warning'>[M.name] struggles to break free from the [src]!</span>",\
			"<span class='notice'>You struggle to break free from the [src], exacerbating your wounds! (Stay still for two minutes.)</span>",\
			"<span class='italics'>You hear a wet squishing noise..</span>")
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M && M.buckled)
					M << "<span class='warning'>You fail to free yourself!</span>"
				return
		if(!M.buckled)
			return
		var/matrix/m180 = matrix(M.transform)
		m180.Turn(180)
		animate(M, transform = m180, time = 3)
		M.pixel_y = M.get_standard_pixel_y_offset(180)
		M.adjustBruteLoss(30)
		src.visible_message(text("<span class='danger'>[M] falls free of the [src]!</span>"))
		unbuckle_mob()
		M.emote("scream")
		M.AdjustWeakened(10)

/obj/structure/kitchenspike/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.occupied)
		if(src.meattype == MEATTYPE_MONKEY && src.skintype == SKINTYPE_MONKEY)
			if(src.skin >= 1)
				src.skin--
				new /obj/item/stack/sheet/animalhide/monkey(src.loc)
				user << "You remove the hide from the monkey!"
			else if(src.meat > 1)
				src.meat--
				new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey(src.loc )
				usr << "You remove some meat from the monkey."
			else if(src.meat == 1)
				src.meat--
				new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey(src.loc)
				usr << "You remove the last piece of meat from the monkey!"
				src.icon_state = "spike"
				src.occupied = 0
		if(src.meattype == MEATTYPE_ALIEN && src.skintype == SKINTYPE_ALIEN)
			if(src.skin >= 1)
				src.skin--
				new /obj/item/stack/sheet/animalhide/xeno(src.loc)
				user << "You remove the hide from the alien!"
			else if(src.meat > 1)
				src.meat--
				new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno(src.loc )
				usr << "You remove some meat from the alien."
			else if(src.meat == 1)
				src.meat--
				new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno(src.loc)
				usr << "You remove the last piece of meat from the alien!"
				src.icon_state = "spike"
				src.occupied = 0
		if(src.meattype == MEATTYPE_CORGI && src.skintype == SKINTYPE_CORGI)
			if(src.skin >= 1)
				src.skin--
				new /obj/item/stack/sheet/animalhide/corgi(src.loc)
				user << "You remove the hide from the corgi!"
			else if(src.meat > 1)
				src.meat--
				new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi(src.loc )
				usr << "You remove some meat from the corgi."
			else if(src.meat == 1)
				src.meat--
				new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi(src.loc)
				usr << "You remove the last piece of meat from the corgi!"
				src.icon_state = "spike"
				src.occupied = 0