// Closets for specific jobs

/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_door = "black"

/obj/structure/closet/gmcloset/New()
	..()
	new /obj/item/clothing/head/that(src)
	new /obj/item/device/radio/headset/headset_srv(src)
	new /obj/item/device/radio/headset/headset_srv(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/tie/waistcoat(src)
	new /obj/item/clothing/tie/waistcoat(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/weapon/reagent_containers/glass/rag(src)
	new /obj/item/weapon/reagent_containers/glass/rag(src)

/obj/structure/closet/chefcloset
	name = "\proper chef's closet"
	desc = "It's a storage unit for foodservice garments and mouse traps."
	icon_door = "black"

/obj/structure/closet/chefcloset/New()
	..()
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/device/radio/headset/headset_srv(src)
	new /obj/item/device/radio/headset/headset_srv(src)
	new /obj/item/clothing/tie/waistcoat(src)
	new /obj/item/clothing/tie/waistcoat(src)
	new /obj/item/clothing/suit/apron/chef(src)
	new /obj/item/clothing/suit/apron/chef(src)
	new /obj/item/clothing/suit/apron/chef(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/weapon/storage/box/mousetraps(src)
	new /obj/item/weapon/storage/box/mousetraps(src)
	new /obj/item/clothing/suit/toggle/chef(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/weapon/reagent_containers/glass/rag(src)

/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	icon_door = "mixed"

/obj/structure/closet/jcloset/New()
	..()
	new /obj/item/pornmag(src)
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/weapon/cartridge/janitor(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/head/soft/purple(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/holosign_creator(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/weapon/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/weapon/watertank/janitor(src)
	new /obj/item/weapon/storage/belt/janitor(src)


/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_door = "blue"

/obj/structure/closet/lawcloset/New()
	..()
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/bluesuit(src)
	new /obj/item/clothing/suit/toggle/lawyer(src)
	new /obj/item/clothing/under/lawyer/purpsuit(src)
	new /obj/item/clothing/suit/toggle/lawyer/purple(src)
	new /obj/item/clothing/under/lawyer/blacksuit(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for Nanotrasen-approved religious attire."
	icon_door = "black"

/obj/structure/closet/wardrobe/chaplain_black/New()
	..()
	contents = list()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/weapon/storage/backpack/cultpack (src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/clothing/head/helmet/knight/templar(src)
	new /obj/item/clothing/suit/armor/riot/knight/templar(src)
	return

/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	burn_state = 0 //Burnable
	burntime = 20

/obj/structure/closet/coffin/update_icon()
	overlays.Cut()
	if(!opened)
		if(icon_door)
			overlays += "[icon_door]_door"
		else
			overlays += "[icon_state]_door"
		if(welded)
			overlays += "nailed"
		if(secure)
			if(!broken)
				if(locked)
					overlays += "locked"
				else
					overlays += "unlocked"
			else
				overlays += "off"

	else
		if(icon_door_override)
			overlays += "[icon_door]_open"
		else
			overlays += "[icon_state]_open"

/obj/structure/closet/coffin/attackby(obj/item/weapon/W, mob/user, params)
	if(user.loc == src)
		return
	if(opened)
		if(istype(W, /obj/item/weapon/grab))
			if(large)
				var/obj/item/weapon/grab/G = W
				MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
				user.drop_item()
			else
				user << "<span class='notice'>\the [src] is too small to stuff [W] into!</span>"
			return
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(isrobot(user))
			return
		if(user.drop_item())
			W.Move(loc)
	else
		if(istype(W, /obj/item/stack/packageWrap))
			return
		if(istype(W, /obj/item/weapon/staplegun) && !welded)
			var/obj/item/weapon/staplegun/WS = W
			if(WS.ammo >= 10)
				user << "<span class='notice'>You begin stapling \the [src]...</span>"
				playsound(loc, 'sound/weapons/staplegun.ogg', 50, 1)
				if(do_after(user,40,5,1, target = src))
					if(opened || !istype(src, /obj/structure/closet) || !user || !WS || !user.loc )
						return
					playsound(loc, 'sound/weapons/staplegun.ogg', 50, 1)
					welded = 1
					user << "<span class='notice'>You staple [src] shut.</span>"
					update_icon()
					user.visible_message("[user.name] has stapled [src] shut with \the [WS].", "<span class='warning'>You staple [src] shut.</span>")
					WS.ammo = WS.ammo-10
				return
		if(istype(W, /obj/item/weapon/crowbar) && welded)
			user << "<span class='notice'>You begin prying out staples from \the [src]...</span>"
			playsound(loc, 'sound/items/crowbar.ogg', 50, 1)
			if(do_after(user,80,5,1, target = src))
				if(opened || !istype(src, /obj/structure/closet) || !user || !W || !user.loc )
					return
				playsound(loc, 'sound/items/crowbar.ogg', 50, 1)
				welded = 0
				user << "<span class='notice'>You pry off the staples keeping [src] shut.</span>"
				update_icon()
				user.visible_message("[user.name] has pried out the staples keeping [src] shut.", "<span class='warning'>You pry out staples keeping [src] shut.</span>")
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
				new/obj/item/stack/staples(src.loc)
			return

/obj/structure/closet/wardrobe/sec
	name = "security wardrobe"
	icon_door = "red"

/obj/structure/closet/wardrobe/sec/New()
	..()
	contents = list()
	new /obj/item/clothing/suit/hooded/wintercoat/security(src)
	new /obj/item/weapon/storage/backpack/security(src)
	new /obj/item/weapon/storage/backpack/satchel_sec(src)
	new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	return


/obj/structure/closet/wardrobe/cargotech
	name = "cargo wardrobe"
	icon_door = "orange"

/obj/structure/closet/wardrobe/cargotech/New()
	..()
	contents = list()
	new /obj/item/clothing/suit/hooded/wintercoat/cargo(src)
	new /obj/item/clothing/under/rank/cargotech(src)
	new /obj/item/clothing/under/rank/cargotech(src)
	new /obj/item/clothing/under/rank/cargotech(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/head/soft(src)
	new /obj/item/clothing/head/soft(src)
	new /obj/item/clothing/head/soft(src)
	new /obj/item/device/radio/headset/headset_cargo(src)

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_door = "atmos_wardrobe"

/obj/structure/closet/wardrobe/atmospherics_yellow/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/weapon/storage/backpack/satchel_norm(src)
	new /obj/item/weapon/storage/backpack(src)
	new /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos(src)
	new /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos(src)
	new /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	return

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/dufflebag/engineering(src)
	new /obj/item/weapon/storage/backpack/industrial(src)
	new /obj/item/weapon/storage/backpack/satchel_eng(src)
	new /obj/item/clothing/suit/hooded/wintercoat/engineering(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/suit/hazardvest(src)
	new /obj/item/clothing/suit/hazardvest(src)
	new /obj/item/clothing/suit/hazardvest(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	return

/obj/structure/closet/wardrobe/white/medical
	name = "medical doctor's wardrobe"

/obj/structure/closet/wardrobe/white/medical/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/dufflebag/med(src)
	new /obj/item/weapon/storage/backpack/medic(src)
	new /obj/item/weapon/storage/backpack/satchel_med(src)
	new /obj/item/clothing/suit/hooded/wintercoat/medical(src)
	new /obj/item/clothing/under/rank/nursesuit (src)
	new /obj/item/clothing/head/nursehat (src)
	new /obj/item/clothing/under/rank/medical/blue(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/suit/toggle/labcoat/emt(src)
	new /obj/item/clothing/suit/toggle/labcoat/emt(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/head/soft/emt(src)
	new /obj/item/clothing/head/soft/emt(src)
	new /obj/item/clothing/head/soft/emt(src)
	return

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/robotics_black/New()
	..()
	contents = list()
	new /obj/item/clothing/glasses/hud/diagnostic(src)
	new /obj/item/clothing/glasses/hud/diagnostic(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/chemistry_white/New()
	..()
	contents = list()
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/chemist(src)
	new /obj/item/clothing/suit/toggle/labcoat/chemist(src)
	new /obj/item/weapon/storage/backpack/chemistry(src)
	new /obj/item/weapon/storage/backpack/chemistry(src)
	new /obj/item/weapon/storage/backpack/satchel_chem(src)
	new /obj/item/weapon/storage/backpack/satchel_chem(src)
	new /obj/item/weapon/storage/bag/chemistry(src)
	new /obj/item/weapon/storage/bag/chemistry(src)
	new /obj/item/clothing/suit/bio_suit/general(src)
	new /obj/item/clothing/suit/bio_suit/general(src)
	new /obj/item/clothing/head/bio_hood/general(src)
	new /obj/item/clothing/head/bio_hood/general(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/genetics_white/New()
	..()
	contents = list()
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/genetics(src)
	new /obj/item/clothing/suit/toggle/labcoat/genetics(src)
	new /obj/item/weapon/storage/backpack/genetics(src)
	new /obj/item/weapon/storage/backpack/genetics(src)
	new /obj/item/weapon/storage/backpack/satchel_gen(src)
	new /obj/item/weapon/storage/backpack/satchel_gen(src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/virology_white/New()
	..()
	contents = list()
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/virologist(src)
	new /obj/item/clothing/suit/toggle/labcoat/virologist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/weapon/storage/backpack/virology(src)
	new /obj/item/weapon/storage/backpack/virology(src)
	new /obj/item/weapon/storage/backpack/satchel_vir(src)
	new /obj/item/weapon/storage/backpack/satchel_vir(src)
	return

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/science_white/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/science(src)
	new /obj/item/weapon/storage/backpack/science(src)
	new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/clothing/suit/hooded/wintercoat/science(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/toggle/labcoat/science(src)
	new /obj/item/clothing/suit/toggle/labcoat/science(src)
	new /obj/item/clothing/suit/toggle/labcoat/science(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	return

/obj/structure/closet/wardrobe/botanist
	name = "botanist wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/botanist/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/botany(src)
	new /obj/item/weapon/storage/backpack/botany(src)
	new /obj/item/weapon/storage/backpack/satchel_hyd(src)
	new /obj/item/weapon/storage/backpack/satchel_hyd(src)
	new /obj/item/clothing/suit/hooded/wintercoat/hydro(src)
	new /obj/item/clothing/suit/apron(src)
	new /obj/item/clothing/suit/apron(src)
	new /obj/item/clothing/suit/apron/overalls(src)
	new /obj/item/clothing/suit/apron/overalls(src)
	new /obj/item/clothing/under/rank/hydroponics(src)
	new /obj/item/clothing/under/rank/hydroponics(src)
	new /obj/item/clothing/under/rank/hydroponics(src)
	new /obj/item/clothing/mask/bandana(src)
	new /obj/item/clothing/mask/bandana(src)
	new /obj/item/clothing/mask/bandana(src)
