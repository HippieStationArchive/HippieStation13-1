//Coded by Nexendia~

/obj/item/dragon
	name = "bad dragon"
	desc = "You really shouldn't see this.. but if you do... Huzzah.. you found a bug.. please scream at Nexendia!"
	icon = 'icons/obj/dicks.dmi'
	icon_state = null
	force = 5
	w_class = 3
	throwforce = 5
	hitsound = 'sound/items/squishy.ogg'
	attack_verb = list("slapped")

/obj/item/dragon/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is shoving [src.name] down \his throat! It looks like they're trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/dragon/sea
	name = "sea dragon dildo"
	desc = "A sea dragon dildo, why this is on a spacestation we will never know..."
	icon_state = "seadragon"

/obj/item/dragon/canine
	name = "canine dildo"
	desc = "A canine dildo, why this is on a spacestation we will never know..."
	icon_state = "canine"
	throwforce = 7

/obj/item/dragon/equine
	name = "equine dildo"
	desc = "An equine dildo, why do we have this shit on a spacestation?"
	icon_state = "equine"
	force = 11
	w_class = 4
	throwforce = 9

/obj/structure/statue/dragon/shelf
	name = "dragon dildo shelf"
	desc = "A shelf for all your fucking oversized dildos.."
	icon = 'icons/obj/dicks.dmi'
	icon_state = "shelf2"

/obj/structure/statue/dragon/shelf/alt
	icon_state = "shelf1"

