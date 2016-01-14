/obj/item/weapon/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion. Must be attached to an IV drip."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 400
	flags = OPENCONTAINER //you can fill a tank with 1000u of chems,not like you can empty bloodpacks without an IV anywhoo

	var/blood_type = null

/obj/item/weapon/reagent_containers/blood/New()
	..()
	if(blood_type != null)
		name = "blood pack [blood_type]"
		reagents.add_reagent("blood", 400, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))
		update_icon()

/obj/item/weapon/reagent_containers/blood/attack_self(mob/user)
	if(is_vampire(user) && reagents.has_reagent("blood"))
		user.visible_message("<span class='warning'>[user] squeezes the contents of [src] into their mouth!</span>",\
							 "<span class='danger'>You resign yourself to drinking the filthy blood from [src].</span>")
		for(var/datum/reagent/R in reagents.reagent_list)
			user.reagents.add_reagent(R.id, R.volume)
			reagents.remove_reagent(R.id, R.volume)
		return 1
	..()

/obj/item/weapon/reagent_containers/blood/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/bloodpack.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/weapon/reagent_containers/blood/random/New()
	blood_type = pick("A+", "A-", "B+", "B-", "O+", "O-")
	..()

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
	name = "empty blood pack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"

/obj/item/weapon/reagent_containers/blood/empty/New()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/blood/empty/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/empty/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/blood/empty/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/blood/empty/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/blood/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/weapon/pen) || istype(I, /obj/item/toy/crayon))

		var/t = stripped_input(user, "What would you like to label the blood pack?", name, null, 53)
		if(!user.canUseTopic(src))
			return
		if(user.get_active_hand() != I)
			return
		if(!in_range(src, user) && loc != user)
			return
		if(t)
			name = "blood pack - [t]"
		else
			name = "blood pack"
		return