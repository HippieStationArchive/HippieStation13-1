
/*
/proc/samuraispawn()
	var/datum/game_mode/traitor/temp = new

	if(config.protect_roles_from_antagonist)
		temp.restricted_jobs += temp.protected_jobs

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in player_list)
		if(applicant.client.prefs.be_special & BE_TRAITOR)
			if(!applicant.stat)
				if(applicant.mind)
					if (!applicant.mind.special_role)
						if(!jobban_isbanned(applicant, "traitor") && !jobban_isbanned(applicant, "Syndicate"))
							if(!(applicant.job in temp.restricted_jobs))
								candidates += applicant

	if(candidates.len)
		var/numTratiors = min(candidates.len, 3)

		for(var/i = 0, i<numTratiors, i++)
			H = pick(candidates)
			H.mind.make_Tratiorevent()
			H.equip_samurai(H)
			candidates.Remove(H)

		return 1


	return 0
*/
/obj/structure/samuraimaker
	name = "thing"
	desc = "testing"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"

	attack_hand(mob/living/carbon/human/user as mob)
		user.equip_samurai(user)
		del(src)
/mob/living/carbon/human/proc/equip_samurai(mob/living/carbon/human/samurai_mob)
	if (!istype(samurai_mob))
		return
	for(var/obj/item/W in samurai_mob)
		del(W)
	del(samurai_mob.wear_suit)
	del(samurai_mob.head)
	del(samurai_mob.shoes)
	del(samurai_mob.r_hand)
	del(samurai_mob.r_store)
	del(samurai_mob.l_store)
	del(samurai_mob.belt)
	del(samurai_mob.r_store)
	del(samurai_mob.belt)
	del(samurai_mob.back)
	del(samurai_mob.ears)
	del(samurai_mob.gloves)
	del(samurai_mob.shoes)
	del(samurai_mob.wear_id)
	del(samurai_mob.wear_suit)
	del(samurai_mob.w_uniform)

	samurai_mob.equip_to_slot_or_del(new /obj/item/device/radio/headset(samurai_mob), slot_ears)
	samurai_mob.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(samurai_mob), slot_w_uniform)
	samurai_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(samurai_mob), slot_shoes)
	samurai_mob.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/samurai(samurai_mob), slot_wear_suit)
	samurai_mob.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/samurai(samurai_mob), slot_head)
	if(samurai_mob.backbag == 2) samurai_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(samurai_mob), slot_back)
	if(samurai_mob.backbag == 3) samurai_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(samurai_mob), slot_back)
	samurai_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box(samurai_mob), slot_in_backpack)
	samurai_mob.equip_to_slot_or_del(new /obj/item/weapon/katana/samurai(samurai_mob), slot_belt)
	samurai_mob.regenerate_icons()
	samurai_mob.client.screen += new/obj/screen/samurai/skill1
	samurai_mob.client.screen += new/obj/screen/samurai/skill2
	return 1


