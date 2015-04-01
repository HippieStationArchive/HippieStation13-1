/obj/item/weapon/shard
	name = "shard"
	desc = "A nasty looking shard of glass."
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	w_class = 1.0
	force = 5.0 //Lower force than shanks
	throwforce = 10.0
	item_state = "shard-glass"
	g_amt = MINERAL_MATERIAL_AMOUNT
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/cooldown = 0
	insulated = 1 //For electrified grilles
	bleedcap = 10 //Can only bleed on second hit, at least
	bleedchance = 20 //Lower than shanks
	embedchance = 30 //Pretty high chance to embed itself in you

/obj/item/weapon/shard/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is slitting \his wrists with the shard of glass! It looks like \he's trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is slitting \his throat with the shard of glass! It looks like \he's trying to commit suicide.</span>"))
	return (BRUTELOSS)


/obj/item/weapon/shard/New()
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)

/obj/item/weapon/shard/afterattack(atom/A as mob|obj, mob/user, proximity)
	if(!proximity || !(src in user)) return
	if(isturf(A))
		return
	if(istype(A, /obj/item/weapon/storage))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves)
			H << "<span class='warning'>[src] cuts into your hand!</span>"
			var/organ = (H.hand ? "l_" : "r_") + "arm"
			var/obj/item/organ/limb/affecting = H.get_organ(organ)
			if(affecting.take_damage(force / 2))
				H.update_damage_overlays(0)
	else if(ismonkey(user))
		var/mob/living/carbon/monkey/M = user
		M << "<span class='warning'>[src] cuts into your hand!</span>"
		M.adjustBruteLoss(force / 2)


/obj/item/weapon/shard/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I
		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/glass/NG = new (user.loc)
			for(var/obj/item/stack/sheet/glass/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
			user << "<span class='notice'>You add the newly-formed glass to the stack. It now contains [NG.amount] sheet\s.</span>"
			qdel(src)
	..()

/obj/item/weapon/shard/Crossed(var/mob/AM)
	if(istype(AM))
		playsound(loc, 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(!H.shoes && !H.lying)
				var/obj/item/organ/limb/O = H.get_organ(pick("l_leg", "r_leg"))
				H.apply_damage(5, BRUTE, O)
				H.Weaken(3)
				if(prob(embedchance))
					src.add_blood(H)
					src.loc = H
					O.embedded += src //Lodge the object into the limb
					H.visible_message("<span class='warning'>\The [src] has embedded into [H]'s [O.getDisplayName()]!</span>",
									"<span class='userdanger'>You feel [src] lodge into your [O.getDisplayName()]!</span>")
					H.update_damage_overlays() //Update the fancy embeds
					H.emote("scream")
				if(cooldown < world.time - 10) //cooldown to avoid message spam. Too bad this cooldown is only for the shard itself.
					H.visible_message("<span class='danger'>[H] steps in the broken glass!</span>", \
							"<span class='userdanger'>You step in the broken glass!</span>")
					cooldown = world.time
			else if(H.lying && !H.w_uniform)
				var/obj/item/organ/limb/O = H.get_organ(ran_zone())
				H.apply_damage(5, BRUTE, O)
				if(prob(embedchance))
					src.add_blood(H)
					src.loc = H
					O.embedded += src //Lodge the object into the limb
					H.visible_message("<span class='warning'>\The [src] has embedded into [H]'s [O.getDisplayName()]!</span>",
								"<span class='userdanger'>You feel [src] lodge into your [O.getDisplayName()]!</span>")
					H.update_damage_overlays() //Update the fancy embeds
					H.emote("scream")
				if(cooldown < world.time - 10) //cooldown to avoid message spam. Too bad this cooldown is only for the shard itself.
					H.visible_message("<span class='danger'>[H] lay over the broken glass!</span>", \
							"<span class='userdanger'>You lay over the broken glass!</span>")
					cooldown = world.time