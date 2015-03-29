//Brought back as a traitor assistant-only item!
//TODO: Use this function below instead
// // Called just before an attack_hand(), in mob/UnarmedAttack()
// /obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
// 	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/stungloves
	desc = "On closer inspection, these are yellow gloves with some kind of device attached to them..."
	name = "budget insulated gloves"
	icon_state = "stungloves"
	item_state = "ygloves"
	siemens_coefficient = 1.5
	item_color = "yellow"
	stunOnTouch = 1
	stunforce = 15 //Stun baton stunforce is 21
	energyCost = 100
	atk_verb = "stunned"
	cell_type = /obj/item/weapon/stock_parts/cell //Contains 1000 charge.

/obj/item/clothing/gloves/stungloves/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		return
	power_supply.give(power_supply.maxcharge)