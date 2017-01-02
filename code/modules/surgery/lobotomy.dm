/datum/surgery/lobotomy //this is so fucked up who the fuck let people do this in real life
	name = "lobotomy"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/lobotomize) //real lobotomies are just slamming an ice pick near your eye, its like this for balance
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("eyes")

/datum/surgery_step/lobotomize
	implements = list(/obj/item/weapon/icepick = 100, /obj/item/weapon/screwdriver = 75, /obj/item/weapon/kitchen/fork = 50, /obj/item/weapon/pen = 25, /obj/item/stack/rods = 25) //variety is the spice of life my friend
	time = 64

/datum/surgery_step/lobtomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to push [tool] into [target]'s eye socket.", "<span class='notice'>You begin to lobotomize [target]...</span>")

/datum/surgery_step/lobotomize/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully lobotomizes [target]!", "<span class='notice'>You succeed in lobotomizing [target].</span>")
	target.emote("drool")
	if(target.mind)
		target << "<span class='userdanger'>You feel like a drooling idiot...</span>"
		target.dna.add_mutation(CLOWNMUT)
		target.dna.add_mutation(SMILE)
		target.dna.add_mutation(NERVOUS)
		target.adjustBrainLoss(50)
	add_logs(user, target, "lobotomized", addition = "INTENT: [uppertext(user.a_intent)]")
	return 1
