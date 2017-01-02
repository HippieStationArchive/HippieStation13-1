/obj/item/weapon/reagent_containers/food/snacks/meat
	var/subjectname = ""

/obj/item/weapon/reagent_containers/food/snacks/meat/slab
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	dried_type = /obj/item/weapon/reagent_containers/food/snacks/sosjerky
	bitesize = 3
	list_reagents = list("nutriment" = 3)
	slices_num = 3
	filling_color = "#FF0000"

///////////////////////////////////// HUMAN MEATS //////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	name = "-meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	icon_state = "slimemeat"
	desc = "Because jello wasn't offensive enough to vegans"
	list_reagents = list("nutriment" = 3, "slimejelly" = 3)
	filling_color = "#00FFFF"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem
	icon_state = "golemmeat"
	desc = "Edible rocks, welcome to the future"
	list_reagents = list("nutriment" = 3, "iron" = 3)
	filling_color = "#A9A9A9"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem/adamantine
	icon_state = "agolemmeat"
	desc = "From the slime pen to the rune to the kitchen, science"
	filling_color = "#66CDAA"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	icon_state = "lizardmeat"
	desc = "Delicious dino damage"
	filling_color = "#6B8E23"
	name = "-lizard meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/bird
	icon_state = "fishfillet"
	desc = "Looks like chicken meat"
	filling_color = "#3B2E43"
	name = "-bird meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/robo
	icon_state = "IPCmeat"
	desc = "Crunchy IPC meat"
	filling_color = "#ffffff"
	name = "-IPC meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/plant
	icon_state = "plantmeat"
	desc = "All the joys of healthy eating with all the fun of cannibalism"
	filling_color = "#E9967A"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/shadow
	icon_state = "shadowmeat"
	desc = "Ow, the edge"
	filling_color = "#202020"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	icon_state = "flymeat"
	desc = "Nothing says tasty like maggot filled radioactive mutant flesh"
	list_reagents = list("nutriment" = 3, "uranium" = 3)

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/moth
	icon_state = "mothmeat"
	desc = "How did they get enough meat from a moth?"
	list_reagents = list("nutriment" = 3, "uranium" = 0.5)

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	name = "-bone"
	icon_state = "skeletonmeat"
	desc = "There's a point where this needs to stop and clearly we have passed it"
	filling_color = "#F0F0F0"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	name = "-meat (rotten)"
	icon_state = "lizardmeat" //Close enough.
	desc = "Halfway to becoming fertilizer for your garden."
	filling_color = "#6B8E23"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/meeseeks
	icon_state = "meatseeks"
	desc = "A multidimensional piece of meat. Don't take too long cooking it."

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fried
	name = "fried meat"
	icon_state = "deepfriedmeat"
	desc = "For the refined fatman."
	filling_color = "#61380B"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/cat
	icon_state = "rottenmeat"
	desc = "Aww, the kitty is playing dead."
	filling_color = "#ff69b4"
	name = "-cat meat"


////////////////////////////////////// OTHER MEATS ////////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/meat/slab/synthmeat
	name = "synthmeat"
	desc = "A synthetic slab of meat."

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/meatproduct
	name = "meat product"
	desc = "A meatlike substance created by food chemists from... well...."

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey
	name = "monkey meat"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi
	name = "corgi meat"
	desc = "Tastes like... well you know..."

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/pug
	name = "pug meat"
	desc = "Tastes like... well you know..."

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/killertomato
	name = "killer tomato meat"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	list_reagents = list("nutriment" = 2)
	filling_color = "#FF0000"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/bear
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	list_reagents = list("nutriment" = 12, "morphine" = 5, "vitamin" = 2)
	filling_color = "#FFB6C1"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno
	name = "xeno meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	list_reagents = list("nutriment" = 3, "vitamin" = 1)
	bitesize = 4
	filling_color = "#32CD32"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/spider
	name = "spider meat"
	desc = "A slab of spider meat."
	icon_state = "spidermeat"
	list_reagents = list("nutriment" = 3, "toxin" = 3, "vitamin" = 1)
	filling_color = "#7CFC00"

////////////////////////////////////// MEAT STEAKS ///////////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/meat/steak
	name = "steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatsteak"
	list_reagents = list("nutriment" = 5)
	bonus_reagents = list("nutriment" = 2, "vitamin" = 1)
	trash = /obj/item/trash/plate
	filling_color = "#B22222"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human/mutant/lizard
	name = "lizard steak"
	desc = "A piece of hot spicy lizard meat."

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human/mutant/bird
	name = "bird steak"
	desc = "A piece of hot spicy bird meat."

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human/mutant/robo
	name = "robo steak"
	desc = "A piece of hot spicy robo meat."

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human/mutant/cat
	name = "cat steak"
	desc = "A piece of hot spicy cat meat."

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/killertomato
	name = "killer tomato steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/bear
	name = "bear steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/xeno
	name = "xeno steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/spider
	name = "spider steak"

/obj/item/weapon/reagent_containers/food/snacks/meat/steak/Tbone
	name = "T-bone steak"
	desc = "The bone seems a bit odd..."
	bonus_reagents = list("nutriment" = 3, "vitamin" = 3)