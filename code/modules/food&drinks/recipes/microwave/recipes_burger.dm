
// see code/datums/recipe.dm

////////////////////////////////////////////////BURGERS////////////////////////////////////////////////

//Snowflake race burgers
/datum/recipe/burger/human/lizard
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/human/lizard

/datum/recipe/burger/human/bird
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/bird
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/human/bird

/datum/recipe/burger/human/robo
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/robo
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/human/robo

/datum/recipe/burger/human/cat
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/cat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/human/cat

//Put this AFTER the snowflake race burgers
/datum/recipe/burger/human
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/human

//Overrides make_food() to rename the burger
/datum/recipe/burger/human/make_food(var/obj/container as obj)
	var/human_name
	for (var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/HM in container)
		if (!HM.subjectname)
			continue
		human_name = HM.subjectname
		break
	var/lastname_index = findtext(human_name, " ")
	if (lastname_index)
		human_name = copytext(human_name,lastname_index+1)

	var/obj/item/weapon/reagent_containers/food/snacks/burger/human/HB = ..(container)
	if(human_name)
		HB.name = human_name + " burger"
	return HB

//Regular burgers
//do not place this recipe before /datum/recipe/human
/datum/recipe/burger/plain
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger

/datum/recipe/burger/appendix
	reagents = list("flour" = 5)
	items = list(
		/obj/item/organ/internal/appendix
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/appendix

/datum/recipe/burger/brain
	reagents = list("flour" = 5)
	items = list(
		/obj/item/organ/internal/brain
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/brain

/datum/recipe/burger/xeno
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/xeno

/datum/recipe/burger/fish
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/fish

/datum/recipe/burger/tofu
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/tofu

/datum/recipe/burger/ghost
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/ectoplasm
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/ghost

/datum/recipe/burger/clown
	reagents = list("flour" = 5)
	items = list(
		/obj/item/clothing/mask/gas/clown_hat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/clown

/datum/recipe/burger/mime
	reagents = list("flour" = 5)
	items = list(
		/obj/item/clothing/mask/gas/mime
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/mime

/datum/recipe/burger/red
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/toy/crayon/red,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/red

/datum/recipe/burger/orange
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/toy/crayon/orange,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/orange

/datum/recipe/burger/yellow
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/toy/crayon/yellow,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/yellow

/datum/recipe/burger/green
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/toy/crayon/green,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/green

/datum/recipe/burger/blue
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/toy/crayon/blue,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/blue

/datum/recipe/burger/purple
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/toy/crayon/purple,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/purple

/datum/recipe/burger/spell
	reagents = list("flour" = 5)
	items = list(
		/obj/item/clothing/head/wizard/fake,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/spell

/datum/recipe/burger/spell
	reagents = list("flour" = 5)
	items = list(
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/spell

/datum/recipe/burger/bigbite
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/bigbite

/datum/recipe/burger/superbite
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5, "flour" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab,
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato,
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato,
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato,
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/superbite

/datum/recipe/burger/slime
	reagents = list("slimejelly" = 5, "flour" = 5)
	items = list()
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/jelly/slime

/datum/recipe/burger/jelly
	reagents = list("cherryjelly" = 5, "flour" = 5)
	items = list()
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/jelly/cherry

/datum/recipe/burger/rat
	reagents = list("flour" = 5)
	items = list(
		/obj/item/trash/deadmouse
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/rat

/datum/recipe/burger/corgi
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/corgi
