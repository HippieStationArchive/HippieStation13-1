//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/force_multi = 2 // The bigger this number, the more chance it'll break.
	var/shattered = 0


/obj/structure/mirror/attack_hand(mob/user)
	if(shattered)
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
			if(userloc != H.loc)
				return	//no tele-grooming
			if(new_style)
				H.facial_hair_style = new_style
		else
			H.facial_hair_style = "Shaved"

		//handle normal hair
		var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
		if(userloc != H.loc)
			return	//no tele-grooming
		if(new_style)
			H.hair_style = new_style

		H.update_hair()


/obj/structure/mirror/proc/shatter()
	if(shattered)
		return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(obj/item/projectile/Proj)
	if(prob(Proj.damage * force_multi))
		if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
			if(!shattered)
				shatter()
			else
				playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()


/obj/structure/mirror/attackby(obj/item/I, mob/living/user, params)
	user.do_attack_animation(src)
	if(I.damtype == STAMINA)
		return
	if(shattered)
		if(istype(I, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = I
			if(WT.remove_fuel(0, user))
				user << "<span class='notice'>You begin repairing [src]...</span>"
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				if(do_after(user, 10/I.toolspeed, target = src))
					if(!user || !WT || !WT.isOn())
						return
					user << "<span class='notice'>You repair [src].</span>"
					shattered = 0
					icon_state = initial(icon_state)
					desc = initial(desc)
				return
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * force_multi))
		visible_message("<span class='warning'>[user] smashes [src] with [I].</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)


/obj/structure/mirror/attack_alien(mob/living/user)
	user.do_attack_animation(src)
	if(islarva(user))
		return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_animal(mob/living/user)
	if(!isanimal(user))
		return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0)
		return
	M.do_attack_animation(src)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_slime(mob/living/user)
	user.do_attack_animation(src)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()

/obj/structure/mirror/magic
	name = "magic mirror"
	desc = "Turn and face the strange... face."
	icon_state = "magic_mirror"
	var/list/races_blacklist = list("l_shadowling", "shadowling", "shadow", "pod", "plant", "adamantine", "slime", "skeleton", "golem", "meeseeks_1", "zombie", "abductor", "plasmaman")
	var/list/choosable_races = list()

/obj/structure/mirror/magic/New()
	if(!choosable_races.len)
		for(var/speciestype in typesof(/datum/species) - /datum/species)
			var/datum/species/S = new speciestype()
			if(!(S.id in races_blacklist))
				choosable_races += S.id
	..()

/obj/structure/mirror/magic/badmin/New()
	for(var/speciestype in typesof(/datum/species) - /datum/species)
		var/datum/species/S = new speciestype()
		choosable_races += S.id
	..()

/obj/structure/mirror/magic/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/choice = input(user, "Something to change?", "Magical Grooming") as null|anything in list("name", "race", "gender", "hair", "eyes")

	switch(choice)
		if("name")
			var/newname = copytext(sanitize(input(H, "Who are we again?", "Name change", H.name) as null|text),1,MAX_NAME_LEN)

			if(!newname)
				return

			H.real_name = newname
			H.name = newname
			if(H.mind)
				H.mind.name = newname

		if("race")
			var/newrace
			var/racechoice = input(H, "What are we again?", "Race change") as null|anything in choosable_races
			newrace = species_list[racechoice]

			if(!newrace)
				return

			H.set_species(newrace, icon_update=0)

			if(H.dna.species.use_skintones)
				var/new_s_tone = input(user, "Choose your skin tone:", "Race change")  as null|anything in skin_tones

				if(new_s_tone)
					H.skin_tone = new_s_tone
					H.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)

			if(MUTCOLORS in H.dna.species.specflags)
				var/new_mutantcolor = input(user, "Choose your skin color:", "Race change") as color|null
				if(new_mutantcolor)
					var/temp_hsv = RGBtoHSV(new_mutantcolor)

					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright
						H.dna.features["mcolor"] = sanitize_hexcolor(new_mutantcolor)

					else
						H << "<span class='notice'>Invalid color. Your color is not bright enough.</span>"

			H.update_body()
			H.update_hair()
			H.update_body_parts()
			H.update_mutations_overlay() // no hulk lizard

		if("gender")
			if(!(H.gender in list("male", "female"))) //blame the patriarchy
				return

			if(H.gender == "male")
				if(alert(H, "Become a Witch?", "Confirmation", "Yes", "No") == "Yes")
					H.gender = "female"
					H << "<span class='notice'>Man, you feel like a woman!</span>"
				else
					return

			else
				if(alert(H, "Become a Warlock?", "Confirmation", "Yes", "No") == "Yes")
					H.gender = "male"
					H << "<span class='notice'>Whoa man, you feel like a man!</span>"
				else
					return
			H.dna.update_ui_block(DNA_GENDER_BLOCK)
			H.update_body()
			H.update_mutations_overlay() //(hulk male/female)


		if("hair")
			var/hairchoice = alert(H, "Hair style or hair color?", "Change Hair", "Style", "Color")

			if(hairchoice == "Style") //So you just want to use a mirror then?
				..()
			else
				var/new_hair_color = input(H, "Choose your hair color", "Hair Color") as null|color
				if(new_hair_color)
					H.hair_color = sanitize_hexcolor(new_hair_color)
					H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
				if(H.gender == "male")
					var/new_face_color = input(H, "Choose your facial hair color", "Hair Color") as null|color
					if(new_face_color)
						H.facial_hair_color = sanitize_hexcolor(new_face_color)
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
				H.update_hair()

		if("eyes")
			var/new_eye_color = input(H, "Choose your eye color", "Eye Color") as null|color
			if(new_eye_color)
				H.eye_color = sanitize_hexcolor(new_eye_color)
				H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				H.update_body()

/obj/structure/mirrorbase
	name = "mobile mirror base"
	desc = "The skeleton of a large reflective mirror."
	icon = 'icons/obj/structures.dmi'
	icon_state = "mirror_reflect_state0"
	density = 1
	anchored = 0
	var/state = 0 // Bit map below
	/*
		1 = Silver (must be placed first)
		2 = Reinforced glass (must be placed last)
	*/

/obj/structure/mirrorbase/attackby(obj/item/I, mob/living/user, params)
	if (istype(I, /obj/item/stack/sheet/mineral/silver) && !(state & 1))
		var/obj/item/stack/sheet/mineral/silver/S = I

		if (S.get_amount() > 0)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)

			if (do_after(user, 10, target = src))
				state |= 1
				S.use(1)
				user << "<span class='notice'>You add a sheet of silver.</span>"
				icon_state = "mirror_reflect_state1"

	else if (istype(I, /obj/item/stack/sheet/rglass) && !(state & 2) && (state & 1))
		var/obj/item/stack/sheet/rglass/G = I

		if (G.get_amount() > 0)
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)

			if (do_after(user, 10, target = src))
				state |= 2
				G.use(1)
				user << "<span class='notice'>You add a sheet of reinforced glass.</span>"
				icon_state = "mirror_reflect_state2"

	else if (istype(I, /obj/item/weapon/screwdriver) && state == 3)
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)

		if (do_after(user, 10, target = src))
			var/obj/structure/mirror/mobile/M = new /obj/structure/mirror/mobile(loc)
			M.add_fingerprint(user)
			user << "<span class='notice'>You fasten the glass cover.</span>"
			qdel(src)

	else if (istype(I, /obj/item/weapon/crowbar))
		if (state & 2)
			var/obj/item/stack/sheet/rglass/G = new (user.loc)
			G.add_fingerprint(user)
			state &= ~2
			user << "<span class='notice'>You remove the glass.</span>"
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			icon_state = "mirror_reflect_state1"

		else if ((state & 1) && !(state & 2))
			var/obj/item/stack/sheet/mineral/silver/S = new (user.loc)
			S.add_fingerprint(user)
			state &= ~1
			user << "<span class='notice'>You remove the silver.</span>"
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			icon_state = "mirror_reflect_state0"

/obj/structure/mirror/mobile
	name = "mobile mirror"
	desc = "A very reflective mirror that can be moved. Use a wrench to anchor it in place. Use a crowbar to adjust the direction."
	icon = 'icons/obj/structures.dmi'
	icon_state = "mirror_reflect"
	density = 1
	anchored = 0
	force_multi = 1 // Quite durable

/obj/structure/mirror/attackby(obj/item/I, mob/living/user, params)
	if (!shattered)
		if (istype(I, /obj/item/weapon/wrench))
			if (anchored)
				anchored = 0
			else
				anchored = 1

			add_fingerprint(user)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			visible_message("<span class='warning'>[user] [anchored ? "" : "un"]anchors the [name]!</span>", \
				            "<span class='warning'>You [anchored ? "" : "un"]anchors the [name]!</span>")

		else if (istype(I, /obj/item/weapon/crowbar))
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			var/new_dir = input("Enter direction:", "Direction") as null|anything in list("North", "North East", "East", "South East", "South", "South West", "West", "North West", "Cancel")

			if (new_dir && user.canUseTopic(src) && in_range(src, user))
				new_dir = replacetext(uppertext(new_dir), " ", "")

				if (new_dir == "CANCEL")
					return 0
				else
					dir = text2dir(new_dir)

		else if (istype(I, /obj/item/weapon/screwdriver))
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)

			if (do_after(user, 10, target = src))
				var/obj/structure/mirrorbase/M = new /obj/structure/mirrorbase(loc)
				M.state = 3
				M.icon_state = "mirror_reflect_state2"
				user << "<span class='notice'>You unfasten the glass cover.</span>"
				qdel(src)

		else 
			return ..()
	else 
		return ..()

/obj/structure/mirror/mobile/bullet_act(obj/item/projectile/P)
	if(!shattered && (istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)))
		if (P.starting)
			// Maths is fun
			var/firing_angle = SimplifyDegrees(Atan2(x - P.starting.x, y - P.starting.y))
			var/mirror_angle = dir2angle(dir)

			// Subtracting the angle from 270 gives us a value that's
			// agreeable with BYOND's directions
			firing_angle = SimplifyDegrees(270 - firing_angle)

			var/diff = SimplifyDegrees(firing_angle - mirror_angle)

			// This figures out if the mirror's face was hit by the projectile
			if (diff >= 270 || diff <= 90)
				var/turf/curloc = get_turf(src)
				P.original = locate(x, y, z)
				P.starting = curloc
				P.current = curloc
				P.firer = src
				// This is actually overpowered because it means projectiles 
				// can be fired into a loop of mirrors and go on endlessly potentially
				P.range = initial(P.range)

				// This is the new angle the projectile will be
				var/out_angle = SimplifyDegrees(P.Angle + 180 - (diff * 2))

				// Minor drift from 0
				if (out_angle == 0)
					out_angle += pick(0.001, -0.001)

				P.Angle = out_angle

				if (P.legacy)
					var/normal = sqrt((P.xo * P.xo) + (P.yo * P.yo))
					P.xo = sin(out_angle) * normal
					P.yo = cos(out_angle) * normal

				return -1
		else
			return 0

/obj/structure/mirror/mobile/shatter()
	if(shattered)
		return

	shattered = 1
	icon_state = "mirror_reflect_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

/obj/structure/mirror/mobile/examine(mob/user)
	..()

	if (shattered)
		user << "<span class='notice'>It appears to be broken. Use a welding tool to repair</span>"

/obj/structure/mirror/mobile/AltClick(mob/user)
	if (!user.canUseTopic(src))
		user << "<span class='warning'>You can't do that right now!</span>"
		return

	if (!in_range(src, user) || anchored || shattered)
		return
	else
		dir = turn(dir, -45)
