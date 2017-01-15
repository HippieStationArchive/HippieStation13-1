
/obj/item/clothing/suit/armor/banecoat
    name = "banecoat"
    desc = "When Gotham is in ashes, then you have my permission to die."
    icon_state = "banecoat"
    item_state = "banecoat"
    body_parts_covered = CHEST|GROIN|ARMS|LEGS
    armor = list(melee = 20, bullet = 25, laser = 10)
    flags_inv = HIDEJUMPSUIT
    cold_protection = CHEST|GROIN|LEGS|ARMS
    heat_protection = CHEST|GROIN|LEGS|ARMS
    strip_delay = 80

/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	put_on_delay = 40
	burn_state = -1 //Won't burn in fires
	can_be_washed = 0

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "A slim armored vest that protects against most types of damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/chestrig
	name = "chestrig"
	desc = "A lightweight, flat-green camoflauge vest which can carry just about any kind of gear, at the cost of offering virtually no protection."
	icon_state = "chestrig"
	item_state = "chestrig"
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/defender
	name = "Defender MK2 Body Armor"
	desc = "A New-Russia combat armor vest with a flat-green camoflauge. It uses ceramic plates to grant the wearer extremely effective protection against ballistic weaponry and moderate protection from explosions."
	icon_state = "defender"
	item_state = "defender"
	armor = list(melee = 35, bullet = 80, laser = 20, energy = 15, bomb = 45, bio = 0, rad = 0)
	strip_delay = 70
	put_on_delay = 50

/obj/item/clothing/suit/armor/hev_suit
	name = "H.E.V Suit"
	desc = "A highly advanced Hazardous Environment suit, this is the Mk7 version. Able to efficiently protect the user from just about any danger that a true scientist in the field may encounter. Also has some moderate protection from lasers, bullets, and blunt objects, just incase an angry military force decides to attempt to stop the progression of SCIENCE!"
	icon_state = "hev"
	item_state = "armor"
	w_class = 4		//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	strip_delay = 120
	put_on_delay = 70
	unacidable = 1	//Acids have no effect
	burn_state = -1 //Not Burnable
	armor = list(melee = 40, bullet = 45, laser = 45, energy = 30, bomb = 90, bio = 100, rad = 90)

/obj/item/clothing/suit/armor/vest/alt
	name = "armor"
	desc = "An armored vest that protects against most types of damage. This is a civilian variant."
	icon_state = "armoralt"
	item_state = "armoralt"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/hos
	name = "armored greatcoat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style for those with a commanding presence."
	icon_state = "hos"
	item_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "armored trenchoat"
	desc = "A trenchcoat enchanced with a special lightweight kevlar. The epitome of tactical plainclothes."
	icon_state = "hostrench"
	item_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "A red jacket with silver rank pips and body armor strapped on top."
	icon_state = "warden_jacket"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	burn_state = 0 //Burnable

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "warden's armored jacket"
	desc = "A navy-blue armored jacket with blue shoulder designations and '/Warden/' stitched into one of the chest pockets."
	icon_state = "warden_alt"

/obj/item/clothing/suit/armor/vest/leather
	name = "security overcoat"
	desc = "Lightly armored leather overcoat meant as casual wear for high-ranking officers. Bears the crest of Nanotrasen Security."
	icon_state = "leathercoat-sec"
	item_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "captain's carapace"
	desc = "An armored vest reinforced with ceramic plates and pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon_state = "capcarapace"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/capcarapace/alt
	name = "captain's parade jacket"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "capformal"
	item_state = "capspacesuit"

/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags = THICKMATERIAL
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 80
	put_on_delay = 60
	slowdown = 1

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof armor"
	desc = "A bulletproof vest that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 25, bullet = 80, laser = 10, energy = 10, bomb = 40, bio = 0, rad = 0)
	strip_delay = 70
	put_on_delay = 50

/obj/item/clothing/suit/armor/heavycombat
	name = "MK48 Heavy Combat Armor"
	desc = "A full-body combat armor produced by Ion Incorporated for its private military forces. Often seen worn by riflemen or other combat troops. Covers the entire body excluding the head with ceramic plates infused with goliath plates and coated in ablative materials, allowing for extreme ballistic protection and moderate laser or energy protection. Comes in a dark, urban camouflage."
	icon_state = "combat_armor"
	item_state = "combat_armor"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 65, bullet = 90, laser = 50, energy = 35, bomb = 75, bio = 0, rad = 30)
	strip_delay = 130
	put_on_delay = 75
	slowdown = 0.2
	unacidable = 1

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles, as well as occasionally reflecting them."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	var/hit_reflect_chance = 40

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list("chest", "groin"))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return 0
	if (prob(hit_reflect_chance))
		return 1

/obj/item/clothing/suit/armor/vest/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	allowed = list(/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	burn_state = 0 //Burnable


//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone seperated our Research Director from his own head!"
	var/active = 0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	action_button_name = "Toggle Armor"
	unacidable = 1
	hit_reaction_chance = 25
	slowdown = 1

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	src.active = !( src.active )
	if (src.active)
		user << "<span class='notice'>[src] is now active.</span>"
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		user << "<span class='notice'>[src] is now inactive.</span>"
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()

/obj/item/clothing/suit/armor/reactive/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		var/mob/living/carbon/human/H = owner
		owner.visible_message("<span class='danger'>The reactive teleport system flings [H] clear of [attack_text]!</span>")
		var/list/turfs = new/list()
		for(var/turf/T in orange(6, H))
			if(T.density)
				continue
			if(T.x>world.maxx-6 || T.x<6)
				continue
			if(T.y>world.maxy-6 || T.y<6)
				continue
			turfs += T
		if(!turfs.len)
			turfs += pick(/turf in orange(6, H))
		var/turf/picked = pick(turfs)
		if(!isturf(picked))
			return
		if(H.buckled)
			H.buckled.unbuckle_mob()
		H.forceMove(picked)
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/fire
	name = "reactive incendiary armor"

/obj/item/clothing/suit/armor/reactive/fire/hit_reaction(mob/living/carbon/human/owner, attack_text)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		owner.visible_message("<span class='danger'>The [src] blocks the [attack_text], sending out jets of flame!</span>")
		for(var/mob/living/carbon/C in range(3, owner))
			if(C != owner)
				C.fire_stacks += 4
				C.IgniteMob()
		owner.fire_stacks = -20
		return 1
	return 0


/obj/item/clothing/suit/armor/reactive/stealth
	name = "reactive stealth armor"

/obj/item/clothing/suit/armor/reactive/stealth/hit_reaction(mob/living/carbon/human/owner, attack_text)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		var/mob/living/simple_animal/hostile/illusion/escape/E = new(owner.loc)
		E.Copy_Parent(owner, 50)
		E.GiveTarget(owner) //so it starts running right away
		E.Goto(owner, E.move_to_delay, E.minimum_distance)
		owner.alpha = 0
		owner.visible_message("<span class='danger'>[owner] is hit by [attack_text] in the chest!</span>") //We pretend to be hit, since blocking it would stop the message otherwise
		spawn(40)
			owner.alpha = initial(owner.alpha)
		return 1

//All of the armor below is mostly unused


/obj/item/clothing/suit/armor/centcom
	name = "\improper Centcom armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals/emergency_oxygen)
	flags = THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit"
	desc = "Pukish armor."	//classy.
	icon_state = "tdgreen"
	item_state = "tdgreen"


/obj/item/clothing/suit/armor/riot/knight
	name = "plate armour"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks."
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	item_state = "knight_yellow"

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/suit/armor/riot/knight/templar
	name = "crusader armour"
	desc = "God wills it!"
	icon_state = "knight_templar"
	item_state = "knight_templar"

/obj/item/clothing/suit/armor/riot/knight/templar/holy
	var/active = 0
	name = "crusader armour"
	desc = "A holy suit of armor, blessed in holy water and tears."
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0) //No armor
	unacidable = 1
	hit_reaction_chance = 50
	action_button_name = "Toggle Blessing"

/obj/item/clothing/suit/armor/riot/knight/templar/holy/New()
	..()
	SSobj.processing.Add(src)

/obj/item/clothing/suit/armor/riot/knight/templar/holy/Destroy()
	..()
	SSobj.processing.Remove(src)

/obj/item/clothing/suit/armor/riot/knight/templar/holy/process()
	if(active)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.stat == DEAD)
				active = !active
				flags &= ~NODROP

/obj/item/clothing/suit/armor/riot/knight/templar/holy/attack_self(mob/user)
	active = !active
	if(active)
		user << "<span class='notice'>[src] has been blessed.</span>"
		flags |= NODROP
	else
		user << "<span class='notice'>[src] has been unblessed.</span>"
		flags &= ~NODROP
	add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/riot/knight/templar/holy/hit_reaction(mob/living/carbon/human/owner, attack_text, damage)
	if(!active)
		return
	if(prob(hit_reaction_chance) && damage)
		owner.visible_message("<span class='danger'>The [src] blocks the [attack_text], sending out arcs of holy lightning!</span>")
		for(var/mob/living/M in view(3, owner))
			if(M == owner)
				continue
			owner.Beam(M,icon_state="purple_lightning",icon='icons/effects/effects.dmi',time=5)
			M.adjustFireLoss(20)
			playsound(M, 'sound/machines/defib_zap.ogg', 50, 1, -1)
		return 1

/obj/item/clothing/suit/armor/hockey
	name = "Ka-Nada winter sport combat suit"
	desc = "A suit of armour used by Ka-Nada Special Sport Forces teams. Protects you from the elements as well as your opponents."
	icon_state = "hockey_suit"
	item_state = "hockey_suit"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/weapon/tank/internals)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	flags = THICKMATERIAL | NODROP | STOPSPRESSUREDMAGE
	armor = list(melee = 70, bullet = 45, laser = 80, energy = 45, bomb = 75, bio = 0, rad = 30)
	unacidable = 1
