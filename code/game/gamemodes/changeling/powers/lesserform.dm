/obj/effect/proc_holder/changeling/lesserform
	name = "Lesser Form"
	desc = "We debase ourselves and become lesser. We become a monkey."
	helptext = "This will cause us to unequip any items we cannot wear."
	chemical_cost = 5
	evopoints_cost = 0 //Innate
	req_dna = 3 //Tier 2
	genetic_damage = 3
	req_human = 1

//Transform into a monkey.
/obj/effect/proc_holder/changeling/lesserform/sting_action(mob/living/carbon/human/user)
	if(!user || user.notransform)
		return 0
	user << "<span class='warning'>Our genes cry out!</span>"
	var/obj/item/organ/internal/cyberimp/eyes/O = user.getorganslot("eye_ling")
	if(O)
		O.Remove(user)
		qdel(O)
	user.monkeyize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE)

	feedback_add_details("changeling_powers","LF")
	return 1