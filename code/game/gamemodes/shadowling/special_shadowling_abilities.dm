//In here: useratch and Ascendance
var/list/possibleShadowlingNames = list("U'ruan", "Y`shej", "Nex", "userel-uae", "Noaey'gief", "Mii`mahza", "Amerziox", "Gyrg-mylin", "Kanet'pruunance", "Vigistaezian") //Unpronouncable 2: electric boogalo
/obj/effect/proc_holder/spell/self/shadowling_hatch
	name = "Hatch"
	desc = "Casts off your disguise."
	panel = "Shadowling Evolution"
	charge_max = 3000
	human_req = 1
	clothes_req = 0
	action_icon_state = "hatch"

/obj/effect/proc_holder/spell/self/shadowling_hatch/cast(mob/living/carbon/human/user)
	if(user.stat || !ishuman(user) || !user || !is_shadow(user)) return
	var/hatch_or_no = alert(user,"Are you sure you want to hatch? You cannot undo this!",,"Yes","No")
	switch (hatch_or_no)
		if("No")
			user << "<span class='warning'>You decide against hatching for now."
			charge_counter = charge_max
			return
		if("Yes")
			user.Stun(INFINITY) //This is bad but notransform won't work.
			user.visible_message("<span class='warning'>[user]'s things suddenly slip off. They hunch over and vomit up a copious amount of purple goo which begins to shape around them!</span>", \
							"<span class='shadowling'>You remove any equipment which would hinder your hatching and begin regurgitating the resin which will protect you.</span>")

			for(var/obj/item/I in user) //drops all items
				if (istype(I, /obj/item/weapon/implant) || istype(I, /obj/item/organ))
					continue
				user.unEquip(I)

			sleep(50)
			var/turf/simulated/floor/F
			var/turf/shadowturf = get_turf(user)
			for(F in orange(1, user))
				new /obj/structure/alien/resin/wall/shadowling(F)
			for(var/obj/structure/alien/resin/wall/shadowling/R in shadowturf) //extremely hacky
				qdel(R)
				new /obj/structure/alien/weeds/node(shadowturf) //Dim lighting in the chrysalis -- removes itself afterwards

			user.visible_message("<span class='warning'>A chrysalis forms around [user], sealing them inside.</span>", \
							"<span class='shadowling'>You create your chrysalis and begin to contort within.</span>")

			sleep(100)
			user.visible_message("<span class='warning'><b>The skin on [user]'s back begins to split apart. Black spines slowly emerge from the divide.</b></span>", \
							"<span class='shadowling'>Spines pierce your back. Your claws break apart your fingers. You feel excruciating pain as your true form begins its exit.</span>")

			sleep(90)
			user.visible_message("<span class='warning'><b>[user], skin shifting, begins tearing at the walls around them.</b></span>", \
							"<span class='shadowling'>Your false skin slips away. You begin tearing at the fragile membrane protecting you.</span>")

			sleep(80)
			playsound(user.loc, 'sound/weapons/slash.ogg', 25, 1)
			user << "<i><b>You rip and slice.</b></i>"
			sleep(10)
			playsound(user.loc, 'sound/weapons/slashmiss.ogg', 25, 1)
			user << "<i><b>The chrysalis falls like water before you.</b></i>"
			sleep(10)
			playsound(user.loc, 'sound/weapons/slice.ogg', 25, 1)
			user << "<i><b>You are free!</b></i>"

			sleep(10)
			playsound(user.loc, 'sound/effects/ghost.ogg', 100, 1)
			var/newNameId = pick(possibleShadowlingNames)
			possibleShadowlingNames.Remove(newNameId)
			user.real_name = newNameId
			user.name = user.real_name
			user.SetStunned(0)
			user << "<i><b><font size=3>YOU LIVE!!!</i></b></font>"

			for(var/obj/structure/alien/resin/wall/shadowling/W in orange(1, user))
				playsound(W, 'sound/effects/splat.ogg', 50, 1)
				qdel(W)
			for(var/obj/structure/alien/weeds/node/N in shadowturf)
				qdel(N)
			user.visible_message("<span class='warning'>The chrysalis explodes in a shower of purple flesh and fluid!</span>")
			user.underwear = "Nude"
			user.undershirt = "Nude"
			user.socks = "Nude"
			user.faction |= "faithless"

			user.equip_to_slot_or_del(new /obj/item/clothing/under/shadowling(user), slot_w_uniform)
			user.equip_to_slot_or_del(new /obj/item/clothing/shoes/shadowling(user), slot_shoes)
			user.equip_to_slot_or_del(new /obj/item/clothing/suit/space/shadowling(user), slot_wear_suit)
			user.equip_to_slot_or_del(new /obj/item/clothing/head/shadowling(user), slot_head)
			user.equip_to_slot_or_del(new /obj/item/clothing/gloves/shadowling(user), slot_gloves)
			user.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/shadowling(user), slot_wear_mask)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/shadowling(user), slot_glasses)
			user.set_species(/datum/species/shadow/ling) //can't be a shadowling without being a shadowling

			user.mind.remove_spell(src)

			sleep(10)
			user << "<span class='shadowling'><b><i>Your powers are awoken. You may now live to your fullest extent. Remember your goal. Cooperate with your thralls and allies.</b></i></span>"
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/enthrall(null))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/glare(null))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/veil(null))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadow_walk(null))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/flashfreeze(null))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/collective_mind(null))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_regenarmor(null))
			//user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowling_extend_shuttle(null))



/obj/effect/proc_holder/spell/self/shadowling_ascend
	name = "Ascend"
	desc = "Enters your true form."
	panel = "Shadowling Evolution"
	charge_max = 3000
	clothes_req = 0
	action_icon_state = "ascend"

/obj/effect/proc_holder/spell/self/shadowling_ascend/cast(mob/living/carbon/human/H,mob/user = user)
	if(!shadowling_check(user))
		return
	var/hatch_or_no = alert(user,"It is time to ascend. Are you sure about this?",,"Yes","No")
	switch(hatch_or_no)
		if("No")
			user << "<span class='warning'>You decide against ascending for now."
			charge_counter = charge_max
			return
		if("Yes")
			user.notransform = 1
			user.visible_message("<span class='warning'>[user]'s things suddenly slip off. They gently rise into the air, red light glowing in their eyes.</span>", \
							"<span class='shadowling'>You rise into the air and get ready for your transformation.</span>")

			for(var/obj/item/I in user) //drops all items
				user.unEquip(I)

				sleep(50)

				user.visible_message("<span class='warning'>[user]'s skin begins to crack and harden.</span>", \
								"<span class='shadowling'>Your flesh begins creating a shield around yourself.</span>")

				sleep(100)
				user.visible_message("<span class='warning'>The small horns on [user]'s head slowly grow and elongate.</span>", \
								  "<span class='shadowling'>Your body continues to mutate. Your telepathic abilities grow.</span>") //y-your horns are so big, senpai...!~

				sleep(90)
				user.visible_message("<span class='warning'>[user]'s body begins to violently stretch and contort.</span>", \
								  "<span class='shadowling'>You begin to rend apart the final barriers to godhood.</span>")

				sleep(40)
				user << "<i><b>Yes!</b></i>"
				sleep(10)
				user << "<i><b><span class='big'>YES!!</span></b></i>"
				sleep(10)
				user << "<i><b><span class='reallybig'>YE--</span></b></i>"
				sleep(1)
				for(var/mob/living/M in orange(7, user))
					M.Weaken(10)
					M << "<span class='userdanger'>An immense pressure slams you onto the ground!</span>"
				world << "<font size=5><span class='shadowling'><b>\"VYSuserA NERADA YEKuserEZET U'RUU!!\"</font></span>"
				world << 'sound/hallucinations/veryfar_noise.ogg'
				for(var/obj/machinery/power/apc/A in apcs_list)
					A.overload_lighting()
				var/mob/A = new /mob/living/simple_animal/ascendant_shadowling(user.loc)
				for(var/obj/effect/proc_holder/spell/S in user.mind.spell_list)
					if(S == src) continue
					user.mind.remove_spell(S)
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/annihilate(null))
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/hypnosis(null))
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_phase_shift(null))
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/ascendant_storm(null))
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_hivemind_ascendant(null))
				user.mind.transfer_to(A)
				A.name = user.real_name
				if(A.real_name)
					A.real_name = user.real_name
				user.invisibility = 60 //This is pretty bad, but is also necessary for the shuttle call to function properly
				user.loc = A
				sleep(50)
				if(!ticker.mode.shadowling_ascended)
					SSshuttle.emergency.request(null, 0.3)
					SSshuttle.emergencyNoRecall = 1
				ticker.mode.shadowling_ascended = 1
				A.mind.remove_spell(src)
				qdel(user)
