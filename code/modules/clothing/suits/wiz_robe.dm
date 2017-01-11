/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 20, rad = 20)
	strip_delay = 50
	put_on_delay = 50
	unacidable = 1
	burn_state = 0 //Magic is not fireproof.

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking red hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"

/obj/item/clothing/head/wizard/yellow
	name = "yellow wizard hat"
	desc = "Strange-looking yellow hat-wear that most certainly belongs to a powerful magic user."
	icon_state = "yellowwizard"

/obj/item/clothing/head/wizard/black
	name = "black wizard hat"
	desc = "Strange-looking black hat-wear that most certainly belongs to a real skeleton. Spooky."
	icon_state = "blackwizard"

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/wizard/marisa
	name = "witch hat"
	desc = "Strange-looking hat-wear. Makes you want to cast fireballs."
	icon_state = "marisa"

/obj/item/clothing/head/wizard/magus
	name = "\improper Magus helm"
	desc = "A mysterious helmet that hums with an unearthly power."
	icon_state = "magus"
	item_state = "magus"

/obj/item/clothing/head/wizard/santa
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	flags = BLOCKHAIR

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificent, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 20, rad = 20)
	allowed = list(/obj/item/weapon/teleportation_scroll)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 50
	put_on_delay = 50
	unacidable = 1
	burn_state = 0 //Enjoy using fireball! :^)

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificent red gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/yellow
	name = "yellow wizard robe"
	desc = "A magnificant yellow gem-lined robe that seems to radiate power."
	icon_state = "yellowwizard"
	item_state = "yellowwizrobe"

/obj/item/clothing/suit/wizrobe/black
	name = "black wizard robe"
	desc = "An unnerving black gem-lined robe that reeks of death and decay."
	icon_state = "blackwizard"
	item_state = "blackwizrobe"

/obj/item/clothing/suit/wizrobe/marisa
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "\improper Magus robe"
	desc = "A set of armored robes that seem to radiate a dark power."
	icon_state = "magusblue"
	item_state = "magusblue"

/obj/item/clothing/suit/wizrobe/magusred
	name = "\improper Magus robe"
	desc = "A set of armored robes that seem to radiate a dark power."
	icon_state = "magusred"
	item_state = "magusred"


/obj/item/clothing/suit/wizrobe/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	item_state = "wizrobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	unacidable = 0
	burn_state = 0 //Burnable

/obj/item/clothing/head/wizard/marisa/fake
	name = "witch hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	unacidable = 0

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	unacidable = 0

/obj/item/clothing/suit/wizrobe/blackmage
	name = "black mage's robes"
	desc = "At least it's no longer a bathrobe."
	icon_state = "blackmage"
	item_state = "blackmage"

/obj/item/clothing/head/wizard/blackmage
	name = "black mage's hat"
	desc = "The Wizard Federation has banned pointy hats due to it being a 'safety hazard'."
	icon_state = "blackmage"
	item_state = "blackmage"
	flags = BLOCKHAIR

/obj/item/clothing/suit/wizrobe/greywizard
	name = "grey wizard robe"
	desc = "A wizard is never late. Nor is he early. He arrives when he's had EI NATH."
	icon_state = "greywizard"
	item_state = "greywizard"

/obj/item/clothing/head/wizard/greywizard
	name = "grey wizard hat"
	desc = "FOOL OF A TOOK."
	icon_state = "greywizard"
	item_state = "greywizard"

/obj/item/clothing/suit/wizrobe/greenwizard
	name = "green wizard robe"
	desc = "The mere thought of a space druid is considered heresy."
	icon_state = "greenwizard"
	item_state = "greenwizard"

/obj/item/clothing/head/wizard/greenwizard
	name = "green wizard hat"
	desc = "eki eki eki patang!"
	icon_state = "greenwizard"
	item_state = "greenwizard"

/obj/item/clothing/suit/wizrobe/jesterwizard
	name = "jester robe"
	desc = "The previous owner died to a mob of angry cluwnes. He claimed it was a prank right until the bitter end."
	icon_state = "jesterwizard"
	item_state = "jesterwizard"

/obj/item/clothing/head/wizard/jesterwizard
	name = "jester wizard hat"
	desc = "Show those fools that magic literally is a joke."
	icon_state = "jesterwizard"
	item_state = "jesterwizard"

/obj/item/clothing/suit/wizrobe/pimpwizard
	name = "purple wizard robe"
	desc = "No matter what people tell you, this is not a pimp's bathrobe."
	icon_state = "pimpwizard"
	item_state = "pimpwizard"

/obj/item/clothing/head/wizard/pimpwizard
	name = "purple wizard hat"
	desc = "No matter what people tell you, this is not a pimp hat!"
	icon_state = "pimpwizard"
	item_state = "pimpwizard"

/obj/item/clothing/suit/wizrobe/rainbowwizard
	name = "rainbow wizard robe"
	desc = "Why would you pick a single robe color if you can just have all the colors in one!"
	icon_state = "rainbowwizard"
	item_state = "rainbowwizard"

/obj/item/clothing/head/wizard/rainbowwizard
	name = "rainbow wizard hat"
	desc = "Also known as the grey wizard hat to colorblind people."
	icon_state = "rainbowwizard"
	item_state = "rainbowwizard"

/obj/item/clothing/suit/wizrobe/whitewizard
	name = "white wizard robe"
	desc = "Doesn't allow you to come back from the dead, but it does look fashionable!"
	icon_state = "whitewizard"
	item_state = "whitewizard"

/obj/item/clothing/head/wizard/whitewizard
	name = "white wizard hat"
	desc = "The balrog of morgoth!"
	icon_state = "whitewizard"
	item_state = "whitewizard"

// Lord Robes

/obj/item/clothing/suit/wizrobe/necrolord
	name = "Necrolord robes"
	desc = "One of the lord robes, powerful sets of robes belonging to some of the Wizard Federation's most talented wizards. This robe in particular belongs to Nehalim the Damned, who was infamous for spamming NPC mobs that were annoying as fuck to deal with. He died later on when one of his opponents flamed at him, literally."
	icon_state = "necrolord"
	item_state = "necrolord"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 30, bomb = 30, bio = 30, rad = 30)
	allowed = list(/obj/item/weapon/teleportation_scroll, /obj/item/weapon/gun/magic/staff/staffofrevenant)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/head/wizard/necrolord
	name = "Necrolord hood"
	desc = "One of the lord robes, powerful sets of robes belonging to some of the Wizard federation's most talented wizards."
	icon_state = "necrolord"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 30, bomb = 30, bio = 30, rad = 30)
	flags = BLOCKHAIR
