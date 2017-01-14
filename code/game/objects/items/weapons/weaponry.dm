/obj/item/weapon/banhammer
	desc = "<font color='red'><b>BWOINK</b></font>"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 1
	throw_speed = 3
	throw_range = 7
	attack_verb = list("banned")

/obj/item/weapon/banhammer/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life.</span>")
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)

/obj/item/weapon/banhammer/attack(mob/M, mob/user)
	M << "<font color='red'><b> You have been banned FOR NO REISIN by [user]<b></font>"
	user << "<font color='red'>You have <b>BANNED</b> [M]</font>"
	playsound(loc, 'sound/effects/adminhelp.ogg', 30) //we want them to jump out of their skin


/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of Nar-Sie's followers."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 15
	stamina_percentage = 0.7
	throw_speed = 3
	throw_range = 4
	throwforce = 10
	w_class = 3
	melee_rename = 1
	melee_reskin = 1
	hitsound = 'sound/weapons/genhit2.ogg'


/obj/item/weapon/nullrod/New()
	moptions["Default"] = "nullrod"
	moptions["Seraphim Sword"] = "asword"
	moptions["God Axe"] = "gaxe"
	moptions["Jesus Mace"] = "jmace"
	moptions["Cancel"] = null

/obj/item/weapon/nullrod/attackby(obj/item/A, mob/user, params)
	if(melee_rename)
		if(istype(A, /obj/item/weapon/pen))
			rename_wopit(user)

/obj/item/weapon/attack_hand(mob/user)
	if(melee_reskin && !mreskinned && loc == user)
		reskin_wopit(user)
		return
	..()

/obj/item/weapon/nullrod/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	slot_flags = SLOT_BELT
	force = 2
	stamina_percentage = 0.95  //Unbelievably shitty sword, can't even fathom killing anyone with it.
	throwforce = 1
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE

/obj/item/weapon/sord/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(BRUTELOSS)

/obj/item/weapon/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	hitsound = 'sound/weapons/bladeslice.ogg'
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 40
	throwforce = 10
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = list(melee = 70, bullet = 30, laser = 0, energy = 0) //How do you even block lasers with a claymore!?
	sharpness = IS_SHARP_ACCURATE

/obj/item/weapon/claymore/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(BRUTELOSS)

/obj/item/weapon/katana
	name = "katana"
	desc = "Woefully underpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 40
	throwforce = 10
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = list(melee = 80, bullet = 40, laser = 40, energy = 30) //Decent...ish
	sharpness = IS_SHARP_ACCURATE

/obj/item/weapon/katana/cursed
	slot_flags = null

/obj/item/weapon/katana/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</span>")
	return(BRUTELOSS)

/obj/item/weapon/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 9
	stamina_percentage = 0.65
	throwforce = 10
	w_class = 3
	materials = list(MAT_METAL=1000)
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

/obj/item/weapon/wirerod/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weapon/shard))
		var/obj/item/weapon/twohanded/spear/S = new

		if(!remove_item_from_storage(user))
			user.unEquip(src)
		user.unEquip(I)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>"
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/weapon/wirecutters))
		var/obj/item/weapon/melee/baton/cattleprod/P = new

		if(!remove_item_from_storage(user))
			user.unEquip(src)
		user.unEquip(I)

		user.put_in_hands(P)
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
		qdel(I)
		qdel(src)
	else if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/welder = I
		if(welder.remove_fuel(1,user))
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)
			user << "<span class='notice'>You weld \the [src] in half.</span>"
			var/obj/item/garrotehandles/S = new

			if(!remove_item_from_storage(user))
				user.unEquip(src)

			user.put_in_hands(S)
			qdel(src)

/obj/item/weapon/throwing_star
	name = "throwing star"
	desc = "An ancient weapon still used to this day due to it's ease of lodging itself into victim's body parts"
	icon_state = "throwingstar"
	item_state = "eshield0"
	force = 2
	throwforce = 20 //This is never used on mobs since this has a 100% embed chance.
	throw_speed = 4
	embedded_pain_multiplier = 4
	w_class = 2
	embed_chance = 100
	sharpness = IS_SHARP

//5*(2*4) = 5*8 = 45, 45 damage if you hit one person with all 5 stars.
//Not counting the damage it will do while embedded (2*4 = 8, at 15% chance)
/obj/item/weapon/storage/box/throwing_stars/New()
	..()
	contents = list()
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)

/obj/item/weapon/caltrop
	name = "caltrop"
	desc = "Small, spiked traps designed to hamper pursuers when left on the ground."
	icon_state = "caltrop"
	item_state = "caltrop"
	force = 5
	throwforce = 10
	throw_speed = 4
	embedded_pain_multiplier = 4
	w_class = 2
	embed_chance = 35
	sharpness = IS_SHARP
	attack_verb = list("stabbed", "impaled")

/obj/item/weapon/caltrop/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/M = AM
		M.adjustStaminaLoss(8)
		var/mob/living/carbon/human/H = AM
		if(!(PIERCEIMMUNE in H.dna.species.specflags))
			var/obj/item/organ/limb/O = H.get_organ(pick("l_leg", "r_leg"))
			H.apply_damage(10, BRUTE, O)
			if(prob(embed_chance)*2)
				H.throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
				O.embedded_objects |= src
				src.add_blood(H)//it embedded itself in you, of course it's bloody!
				src.loc = H
				H.visible_message("<span class='warning'>\The [src] has embedded into [H]'s [O]!</span>",
								"<span class='userdanger'>You feel [src] lodge into your [O]!</span>")
				H.update_damage_overlays() //Update the fancy embeds
				H.emote("scream")
		return 1

obj/item/weapon/storage/box/caltrop
	name = "box"

obj/item/weapon/storage/box/caltrop/New()
	..()
	contents = list()
	new /obj/item/weapon/caltrop(src)
	new /obj/item/weapon/caltrop(src)
	new /obj/item/weapon/caltrop(src)
	new /obj/item/weapon/caltrop(src)
	new /obj/item/weapon/caltrop(src)

/obj/item/weapon/switchblade
	name = "switchblade"
	icon_state = "switchblade"
	desc = "A sharp, concealable, spring-loaded knife."
	flags = CONDUCT
	force = 3
	w_class = 2
	throwforce = 5
	throw_speed = 3
	throw_range = 6
	materials = list(MAT_METAL=12000)
	origin_tech = "materials=1"
	hitsound = 'sound/weapons/Genhit.ogg'
	attack_verb = list("stubbed", "poked")
	var/extended = 0

/obj/item/weapon/switchblade/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	if(extended)
		playsound(user, 'sound/weapons/raise.ogg', 20, 1, -4)
		force = 20
		w_class = 3
		throwforce = 15
		sharpness = IS_SHARP_ACCURATE
		icon_state = "switchblade_ext"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		hitsound = 'sound/weapons/bladeslice.ogg'
	else
		playsound(user, 'sound/weapons/raise.ogg', 20, 1, -4)
		force = 3
		w_class = 2
		throwforce = 5
		sharpness = IS_BLUNT
		icon_state = "switchblade"
		attack_verb = list("stubbed", "poked")
		hitsound = 'sound/weapons/Genhit.ogg'

/obj/item/weapon/switchblade/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting \his own throat with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/weapon/pocketknife
	name = "pocket knife"
	desc = "Small, concealable blade that fits in the pocket nicely."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pocketknife"
	force = 3
	throwforce = 3
	hitsound = "swing_hit" //it starts deactivated
	throw_speed = 3
	throw_range = 8
	var/active = 0
	var/active_force = 12
	var/deactive_force = 3
	w_class = 1 //note to self: weight class
	sharpness = IS_BLUNT

/obj/item/weapon/pocketknife/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting \his own throat with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/weapon/pocketknife/attack_self(mob/living/user)
	if (user.disabilities & CLUMSY && prob(50))
		user << "<span class='warning'>You accidentally cut yourself with [src], like a doofus!</span>"
		user.take_organ_damage(5,0)
	active = !active
	if (active)
		force = active_force
		throwforce = 14
		sharpness = IS_SHARP_ACCURATE
		hitsound = 'sound/weapons/knife.ogg'
		attack_verb = list("stabbed", "torn", "cut", "sliced")
		icon_state = "pocketknife_open"
		w_class = 3
		playsound(user, 'sound/weapons/raise.ogg', 20, 1)
		user << "<span class='notice'>[src] is now open.</span>"
	else
		force = deactive_force
		throwforce = 3
		sharpness = IS_BLUNT
		hitsound = "swing_hit"
		attack_verb = null
		icon_state = "pocketknife"
		w_class = 1
		playsound(user, 'sound/weapons/raise.ogg', 20, 1)
		user << "<span class='notice'>[src] is now closed.</span>"
	add_fingerprint(user)
	return

/obj/item/weapon/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	force = 3
	throwforce = 2
	throw_speed = 3
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/weapon/phone/suicide_act(mob/user) //TODO: Make noosing work for this one like the cables
	if(locate(/obj/structure/stool) in user.loc)
		user.visible_message("<span class='notice'>[user] begins to tie a noose with the [src.name]'s cord! It looks like \he's trying to commit suicide.</span>")
	else
		user.visible_message("<span class='notice'>[user] is strangling \himself with the [src.name]'s cord! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/weapon/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	force = 5
	throwforce = 5
	w_class = 2
	materials = list(MAT_METAL=50)
	burn_state = 0
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/cane/update_slowdown(mob/user)
	var/mob/living/carbon/human/H = user
	var/slow = 0
	if(istype(H))
		slow = (H.get_num_legs(1) < 2) ? -2 : 0 //Negates slowdown caused by lack of a leg
	return slow

/obj/item/weapon/staff
	name = "wizards staff"
	desc = "Apparently a staff used by the wizard. Can be used as a crutch."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = 2
	flags = NOSHIELD
	attack_verb = list("bludgeoned", "whacked", "disciplined")
	burn_state = 0 //Burnable

/obj/item/weapon/staff/update_slowdown(mob/user)
	var/mob/living/carbon/human/H = user
	var/slow = 0
	if(istype(H))
		slow = (H.get_num_legs(1) < 2) ? -2 : 0 //Negates slowdown caused by lack of a leg
	return slow

/obj/item/weapon/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included. Can be used as a crutch."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

/obj/item/weapon/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar. Can be used as a crutch."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stick"
	item_state = "stick"
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = 2
	flags = NOSHIELD

/obj/item/weapon/ectoplasm
	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/weapon/ectoplasm/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is inhaling the [src.name]! It looks like \he's trying to visit the astral plane.</span>")
	return (OXYLOSS)

/obj/item/weapon/icepick
	name = "ice pick"
	desc = "Perfect for breaking ice, or piercing skulls."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "icepick"
	item_state = "icepick"
	force = 7
	throwforce = 5
	throw_speed = 4
	throw_range = 6
	w_class = 1
	attack_verb = list("stabbed", "picked", "lobotomized")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/icepick/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))	return ..()
	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()
	if(user.disabilities & CLUMSY && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/weapon/cane/pimpstick
	name = "pimp stick"
	desc = "A gold-rimmed cane, with a gleaming diamond set at the top. Great for bashing in kneecaps. Can be used as a crutch."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pimpstick"
	item_state = "pimpstick"
	force = 10
	throwforce = 7
	w_class = 3
	flags = NOSHIELD
	attack_verb = list("pimped", "smacked", "disciplined", "busted", "capped", "decked")
