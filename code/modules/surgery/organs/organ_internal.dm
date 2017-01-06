/obj/item/organ/internal
	origin_tech = "biotech=2"
	force = 1
	w_class = 2
	throwforce = 0
	var/zone = "chest"
	var/slot
	var/vital = 0
	var/organ_action_name = null

/obj/item/organ/internal/proc/Insert(mob/living/carbon/M, special = 0)
	if(!iscarbon(M) || owner == M)
		return

	var/obj/item/organ/internal/replaced = M.getorganslot(slot)
	if(replaced)
		replaced.Remove(M, special = 1)

	owner = M
	M.internal_organs |= src
	loc = M
	if(organ_action_name)
		action_button_name = organ_action_name


/obj/item/organ/internal/proc/Remove(mob/living/carbon/M, special = 0)
	owner = null
	if(M)
		M.internal_organs -= src
		if(vital && !special)
			M.death()

	if(organ_action_name)
		action_button_name = null

/obj/item/organ/internal/proc/on_find(mob/living/finder)
	return

/obj/item/organ/internal/proc/on_life()
	return

/obj/item/organ/internal/proc/prepare_eat()
	var/obj/item/weapon/reagent_containers/food/snacks/organ/S = new
	S.name = name
	S.desc = desc
	S.icon = icon
	S.icon_state = icon_state
	S.origin_tech = origin_tech
	S.w_class = w_class

	return S

/obj/item/weapon/reagent_containers/food/snacks/organ
	name = "appendix"
	icon_state = "appendix"
	icon = 'icons/obj/surgery.dmi'

	list_reagents = list("nutriment" = 5)


/obj/item/organ/internal/Destroy()
	if(owner)
		Remove(owner, 1)
	return ..()

/obj/item/organ/internal/attack(mob/living/carbon/M, mob/user)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(status == ORGAN_ORGANIC)
			var/obj/item/weapon/reagent_containers/food/snacks/S = prepare_eat()
			if(S)
				H.drop_item()
				H.put_in_active_hand(S)
				S.attack(H, H)
				qdel(src)
	else
		..()

//Looking for brains?
//Try code/modules/mob/living/carbon/brain/brain_item.dm



/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	zone = "chest"
	slot = "heart"
	origin_tech = "biotech=3"
	vital = 1
	var/beating = 1

/obj/item/organ/internal/heart/update_icon()
	if(beating)
		icon_state = "heart-on"
	else
		icon_state = "heart-off"

/obj/item/organ/internal/heart/Insert(mob/living/carbon/M, special = 0)
	..()
	beating = 1
	update_icon()

/obj/item/organ/internal/heart/Remove(mob/living/carbon/M, special = 0)
	..()
	spawn(120)
		beating = 0
		update_icon()

/obj/item/organ/internal/heart/prepare_eat()
	var/obj/S = ..()
	S.icon_state = "heart-off"
	return S



/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	zone = "groin"
	slot = "appendix"
	var/inflamed = 0

/obj/item/organ/internal/appendix/update_icon()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"
	else
		icon_state = "appendix"
		name = "appendix"

/obj/item/organ/internal/appendix/Remove(mob/living/carbon/M, special = 0)
	for(var/datum/disease/appendicitis/A in M.viruses)
		A.cure()
		inflamed = 1
	update_icon()
	..()

/obj/item/organ/internal/appendix/Insert(mob/living/carbon/M, special = 0)
	..()
	if(inflamed)
		M.AddDisease(new /datum/disease/appendicitis)

/obj/item/organ/internal/appendix/prepare_eat()
	var/obj/S = ..()
	if(inflamed)
		S.reagents.add_reagent("????", 5)
	return S

/obj/item/organ/internal/butt //nvm i need to make it internal for surgery fuck
	name = "butt"
	desc = "extremely treasured body part"
	icon_state = "butt"
	item_state = "butt"
	zone = "groin"
	slot = "butt"
	throwforce = 5
	throw_speed = 4
	force = 5
	hitsound = 'sound/misc/fart.ogg'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	embed_chance = 5 //This is a joke
	var/loose = 0
	var/capacity = 2 // this is how much items the butt can hold. 1 means only 1 tiny item, while 2 means 2 tiny items OR 1 small item.
	var/stored = 0 //how many items are inside

/obj/item/organ/internal/butt/xeno //XENOMORPH BUTTS ARE BEST BUTTS yes i agree
	name = "alien butt"
	desc = "best trophy ever"
	icon_state = "xenobutt"
	item_state = "xenobutt"
	capacity = 3 // aka either 3 tiny items or 1 small+1 tiny. xenos are huge,their butt should be bigger too

/obj/item/organ/internal/butt/bluebutt // bluespace butts, science
	name = "butt of holding"
	desc = "This butt has bluespace properties, letting you store more items in it. Four tiny items, or two small ones, or one normal one can fit."
	icon_state = "bluebutt"
	item_state = "bluebutt"
	origin_tech = "bluespace=5;biotech=4"
	capacity = 4

/obj/item/organ/internal/butt/attackby(var/obj/item/W, mob/user as mob, params) // copypasting bot manufucturing process, im a lazy fuck

	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		user.drop_item()
		qdel(W)
		var/turf/T = get_turf(src.loc)
		var/obj/machinery/bot/buttbot/B = new(T)
		if(istype(src, /obj/item/organ/internal/butt/xeno))
			B.xeno = 1
			B.icon_state = "buttbot_xeno"
			B.speech_list = list("hissing butts", "hiss hiss motherfucker", "nice trophy nerd", "butt", "woop get an alien inspection")
		user << "<span class='notice'>You add the robot arm to the butt and... What?</span>"
		user.drop_item(src)
		qdel(src)

/obj/item/organ/internal/butt/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/M = hit_atom
	playsound(src, 'sound/misc/fart.ogg', 50, 1, 5)
	if((ishuman(hit_atom)))
		M.apply_damage(5, STAMINA)
		if(prob(5))
			M.Weaken(3)
			visible_message("<span class='danger'>The [src.name] smacks [M] right in the face!</span>", 3)

/obj/item/organ/internal/shadowtumor
	name = "black tumor"
	desc = "A tiny black mass with red tendrils trailing from it. It seems to shrivel in the light."
	icon_state = "blacktumor"
	origin_tech = "biotech=4"
	w_class = 1
	zone = "head"
	slot = "brain_tumor"
	var/health = 3

/obj/item/organ/internal/shadowtumor/New()
	..()
	SSobj.processing |= src

/obj/item/organ/internal/shadowtumor/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/organ/internal/shadowtumor/process()
	if(isturf(loc))
		var/turf/T = loc
		var/light_count = T.get_lumcount()
		if(light_count > LIGHT_DAM_THRESHOLD && health > 0) //Die in the light
			health--
		else if(light_count < LIGHT_HEAL_THRESHOLD && health < 3) //Heal in the dark
			health++
		if(health <= 0)
			visible_message("<span class='warning'>[src] collapses in on itself!</span>")
			qdel(src)

/obj/item/organ/internal/chemgland
	name = "experimental organ"
	desc = "It faintly resembles an organ, it looks like it can be surgically implanted."
	icon_state = "chemgland1"
	flags = NOBLUDGEON
	origin_tech = "biotech=3"
	slot = "chemgland"
	force = 0
	var/chem_1 =  null
	var/chem_2 =  null

/obj/item/organ/internal/chemgland/New()
	icon_state = pick("chemgland1","chemgland2","chemgland3","chemgland4","chemgland5","chemgland6","chemgland7","chemgland8","chemgland9","chemgland10","chemgland11","chemgland12")
	name = "[pick("spiky","twisted","odd","horrific","bloated","tumor","tumorous","deformed","cancerous","smooth","convulsing","fleshy","organic","alien","lumpy","warped")][pick("-like"," looking","")] [pick("organ","tissue","gland")]"
	var/list/chemgland_chems = list("rezadone", "histamine", "hippiesdelight", "ethanol", "mushroomhallucinogen", "heroin", /*"bath_salts", "methamphetamine", "crank",*/ "nicotine", "space_drugs", "aranesp", "carrotjuice", "krokodil", "fartium", "laughter", "colorful_reagent", "serotrotium", "mulligan", "holywater", "histamine", "toxinsspecial", "hell_ramen", "venom", "cyanide", "sulfonal", "lipolicide", "heparin", "teslium", "rotatium", "bleach", "unholywater", "mercury", "frostoil", "mine_salve", "calomel", "sleeptoxin", "mutagen", "lexorin", "mindbreaker", "spore", "spore_burning", "tirizene", "synaptizine", "icecoffee", "coffee", "hot_coco", "leporazine", "oxandrolone", "charcoal", "potass_iodide", "sal_acid", "salbutamol", "perfluorodecalin", "ephedrine", "oculine", "atropine", "antihol", "insulin", "kelotane", "dexalin", "mannitol", "bromelain", "cafe_latte")
	chem_1 =  pick(chemgland_chems)
	chem_2 =  pick(chemgland_chems)

/obj/item/organ/internal/chemgland/on_life()
	..()
	if(prob(5))
		owner.reagents.add_reagent(chem_1,1)
		owner.reagents.add_reagent(chem_2,1)

/obj/item/organ/internal/chemgland/throw_impact(atom/hit_atom)
	..()
	playsound(get_turf(src), pick('sound/misc/splat.ogg', 'sound/misc/splort.ogg'), 50, 1, -1)

