/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 2)
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	emote_taunt = list("gnashes")
	taunt_chance = 30
	speed = 0
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("gnashes")

	//Space carp aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

	faction = list("carp")
	flying = 1
	gold_core_spawnable = 1

/mob/living/simple_animal/hostile/carp/Process_Spacemove(movement_dir = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.adjustStaminaLoss(8)

/mob/living/simple_animal/hostile/carp/holocarp
	icon_state = "holocarp"
	icon_living = "holocarp"
	maxbodytemp = INFINITY
	gold_core_spawnable = 0

/mob/living/simple_animal/hostile/carp/holocarp/death()
	..(1)
	ghostize()
	qdel(src)
	return

/mob/living/simple_animal/hostile/carp/megacarp
	icon = 'icons/mob/alienqueen.dmi'
	name = "Mega Space Carp"
	desc = "A ferocious, fang bearing creature that resembles a shark. This one seems especially ticked off."
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"
	icon_gib = "megacarp_gib"
	maxHealth = 65
	health = 65
	pixel_x = -16
	mob_size = MOB_SIZE_LARGE

	melee_damage_lower = 20
	melee_damage_upper = 20


///////////////////////////////////////////////
/mob/living/simple_animal/hostile/livingplush
	name = "Living Plushie"
	desc = "Flying, adorable, huggable, and certainly kosher."
	icon_state = "livingplush"
	icon_living = "livingplush"
	icon_dead = "living_dead"
	icon_gib = "brownbear_gib"
	speak = list("Squee!","Squeeze me!","SQUEE!","Squee~")
	speak_emote = list("lovingly says","wheezes")
	emote_hear = list("flutters around")
	emote_see = list("floats around")
	speak_chance = 3  //This should slow down the emotes though I am not 100% sure   ~Nexendia
	turns_per_move = 3  //Same as above.. not 100% sure  ~Nexendia
	see_in_dark = 8
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/candy = 7)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "tries to rip open"
	attacktext = "tries to rip open"
	speed = 0
	maxHealth = 200
	health = 200
	incorporeal_move = 1
	var/datum/reagents/udder = null

	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "Violently squees"
	attack_sound = 'sound/items/squeak1.ogg'
	//Space carp aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

	faction = list("carp")
	vision_range = 0

/mob/living/simple_animal/hostile/livingplush/Process_Spacemove(var/movement_dir = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/livingplush/FindTarget()
	. = ..()
	if(.)
		emote("me", 1, "smiles at [.]!")

/mob/living/simple_animal/hostile/livingplush/AttackingTarget()
	. =..()
	var/mob/living/carbon/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/livingplush/New()
	udder = new(10)
	udder.my_atom = src
	..()

/mob/living/simple_animal/hostile/livingplush/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stat == CONSCIOUS && istype(O, /obj/item/weapon/reagent_containers/glass))
		user.visible_message("<span class='notice'>[user] gets some strange liquid from [src] using \the [O].</span>")
		var/obj/item/weapon/reagent_containers/glass/G = O
		var/transfered = udder.trans_id_to(G, "mushroomhallucinogen", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			user << "<span class='danger'>[O] is full.</span>"
		if(!transfered)
			user << "<span class='danger'>The living plushie is out of juice. Try later.</span>"
	else
		..()



/mob/living/simple_animal/hostile/livingplush/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(10))
			playsound(src, pick('sound/items/squeak1.ogg', 'sound/items/squeak2.ogg'), 40, 1)
			udder.add_reagent("mushroomhallucinogen", rand(1, 2))