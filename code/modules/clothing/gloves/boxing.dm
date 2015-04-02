/obj/item/clothing/gloves/boxing
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"
	put_on_delay = 60
	species_exception = list(/datum/species/golem, /datum/species/golem/adamantine) // now you too can be a golem boxing champion
	var/atk_verb = list("whammed", "knocked", "uppercut", "Hulk Hogan'd", "brought the smackdown on")
	var/hitsfx = list("boxgloves")

/obj/item/clothing/gloves/boxing/Touch(var/atom/A, var/proximity)
	var/mob/living/carbon/human/M = loc
	if(!istype(M)) return 0
	if(proximity && ishuman(A))
		var/mob/living/carbon/human/H = A
		var/damage = rand(0, 9)

		if(!damage)
			if(M.dna)
				playsound(H.loc, M.dna.species.miss_sound, 25, 1, -1)
			else
				playsound(H.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			H.visible_message("<span class='warning'>[M] has attempted to box [H]!</span>")
			return 1

		var/obj/item/organ/limb/affecting = H.get_organ(ran_zone(M.zone_sel.selecting))
		var/armor_block = H.run_armor_check(affecting, "melee")

		playsound(H.loc, pick(hitsfx), 25, 1, -1)

		H.visible_message("<span class='danger'>[M] has [pick(atk_verb)] [H]!</span>", \
						"<span class='userdanger'>[M] has [pick(atk_verb)] [H]!</span>")

		H.apply_damage(damage*2, STAMINA, affecting, armor_block)

		if((H.stat != DEAD) && damage >= 9)
			H.visible_message("<span class='danger'>[M] has weakened [H]!</span>", \
							"<span class='userdanger'>[M] has weakened [H]!</span>")
			H.apply_effect(4, WEAKEN, armor_block)
			H.forcesay(hit_appends)
		else if(H.lying)
			H.forcesay(hit_appends)
		return 1
	return 0

/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state = "boxinggreen"

/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state = "boxingblue"

/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state = "boxingyellow"
