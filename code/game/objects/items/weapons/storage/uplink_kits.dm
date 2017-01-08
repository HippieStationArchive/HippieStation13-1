/obj/item/weapon/storage/box/syndicate/

/obj/item/weapon/storage/box/syndicate/New()
	..()
	if(istype(ticker.mode,/datum/game_mode/traitor/king_disk))
		for(var/i = 0, i < 14, i++)
			new /obj/item/weapon/pinpointer(src)
	else
		switch (pickweight(list("spy" = 1, "boom" = 1, "snake" = 1, "screwed" = 1, "guns" = 1, "implant" = 1, "hacker" = 1, "ninja" = 1, "darklord" = 1)))
			if("spy")
				new /obj/item/weapon/pen/edagger(src)
				new /obj/item/weapon/reagent_containers/syringe/mulligan(src)
				new /obj/item/weapon/reagent_containers/syringe/mulligan(src)
				new /obj/item/weapon/card/id/syndicate(src)
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/weapon/reagent_containers/syringe/mulligan(src)
				new /obj/item/weapon/card/id/syndicate(src)
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/weapon/reagent_containers/syringe/mulligan(src)
				new /obj/item/weapon/card/id/syndicate(src)
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/weapon/storage/backpack/dufflebag/syndie/surgery(src)
				new /obj/item/weapon/storage/box/syndie_kit/imp_gmindslave(src)
				new /obj/item/weapon/storage/box/syndie_kit/imp_gmindslave(src)
				return

			if("snake")
				new /obj/item/weapon/melee/combatknife(src)
				new /obj/item/weapon/gun/projectile/automatic/pistol(src)
				new /obj/item/weapon/suppressor(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/weapon/gun/syringe/syndicate(src)
				new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
				new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
				new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
				new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
				new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
				new /obj/item/weapon/c4(src)
				new /obj/item/weapon/c4(src)
				new /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate(src)
				new /obj/item/clothing/gloves/cqc(src)
				new /obj/item/weapon/card/id/syndicate(src)
				return

			if("screwed")
				new /obj/item/device/sbeacondrop/bomb(src)
				new /obj/item/device/sbeacondrop/powersink(src)
				new /obj/item/device/sbeacondrop(src)
				new /obj/item/weapon/grenade/syndieminibomb(src)
				new /obj/item/weapon/cartridge/syndicate(src)
				new /obj/item/clothing/suit/space/hardsuit/syndi(src)
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/weapon/gun/projectile/automatic/pistol(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				return

			if("guns")
				new /obj/item/weapon/gun/projectile/revolver(src)
				new /obj/item/ammo_box/a357(src)
				new /obj/item/weapon/gun/projectile/automatic/pistol(src)
				new /obj/item/weapon/gun/projectile/automatic/pistol(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/ammo_box/magazine/m10mm(src)
				new /obj/item/weapon/c4(src)
				new /obj/item/weapon/c4(src)
				new /obj/item/weapon/c4(src)
				new /obj/item/clothing/under/suit_jacket/really_black(src)
				new /obj/item/clothing/suit/jacket/leather/overcoat(src)
				new /obj/item/clothing/glasses/sunglasses(src)
				return

			if("implant")
				new /obj/item/weapon/implanter/freedom(src)
				new /obj/item/weapon/implanter/emp(src)
				/*new /obj/item/weapon/implanter/adrenalin(src)*/
				new /obj/item/weapon/storage/box/syndie_kit/imp_macrobomb(src)
				new /obj/item/weapon/implanter/storage(src)
				new /obj/item/weapon/storage/box/syndie_kit/imp_mindslave(src)
				return

			if("hacker")
				new /obj/item/weapon/aiModule/syndicate(src)
				new /obj/item/weapon/c4(src)
				new /obj/item/weapon/card/id/syndicate(src)
				new /obj/item/clothing/suit/labcoat/chameleon(src)
				new /obj/item/clothing/under/chameleon(src)
				new /obj/item/weapon/card/emag(src)
				new /obj/item/device/encryptionkey/binary(src)
				new /obj/item/device/camera_bug(src)
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/weapon/aiModule/toyAI(src)
				new /obj/item/device/multitool/ai_detect(src)
				return

			if("darklord")
				new /obj/item/weapon/melee/energy/sword/saber(src)
				new /obj/item/weapon/melee/energy/sword/saber(src)
				/*new /obj/item/weapon/implanter/adrenalin(src)*/
				new /obj/item/weapon/dnainjector/telemut/darkbundle(src)
				new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
				new /obj/item/weapon/storage/box/syndie_kit/imp_mindslave(src)
				new /obj/item/weapon/card/id/syndicate(src)
				new /obj/item/weapon/spellbook/oneuse/summonitem(src)
				return

			if("ninja")
				new /obj/item/weapon/melee/energy/sword/saber(src)
				new /obj/item/weapon/storage/belt/ninja/full(src)
				new /obj/item/weapon/storage/box/throwing_stars(src)
				new /obj/item/weapon/storage/box/throwing_stars(src)
				new /obj/item/clothing/gloves/pickpocket(src)
				new /obj/item/clothing/mask/balaclava(src)
				new /obj/item/weapon/dnainjector/stealthmut/ninjabundle(src)
				new /obj/item/weapon/spellbook/oneuse/smoke(src)
				new /obj/item/device/doorCharge(src)
				new /obj/item/device/doorCharge(src)
				new /obj/item/weapon/storage/box/caltrop(src)
				return

			if("boom")
				for(var/i = 0, i < 20, i++)
					new /obj/item/weapon/c4(src)
				for(var/i = 0, i < 4, i++)
					new /obj/item/weapon/grenade/syndieminibomb(src)
				for(var/i = 0, i < 1, i++)
					new /obj/item/device/sbeacondrop/bomb(src)
				return

/obj/item/weapon/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom/New()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/freedom(O)
	O.update_icon()
	return

/*/obj/item/weapon/storage/box/syndie_kit/imp_compress
	name = "Compressed Matter Implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_compress/New()
	new /obj/item/weapon/implanter/compressed(src)
	..()
	return
*/

/obj/item/weapon/storage/box/syndie_kit/imp_microbomb
	name = "Microbomb Implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_microbomb/New()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/explosive(O)
	O.update_icon()
	..()
	return

/obj/item/weapon/storage/box/syndie_kit/imp_macrobomb
	name = "Macrobomb Implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_macrobomb/New()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/explosive/macro(O)
	O.update_icon()
	..()
	return

/obj/item/weapon/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_uplink/New()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/uplink(O)
	O.update_icon()
	return


/obj/item/weapon/storage/box/syndie_kit/imp_mindslave
	name = "Mindslave Implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_mindslave/New()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/mindslave(O)
	O.update_icon()
	return

/obj/item/weapon/storage/box/syndie_kit/imp_gmindslave
	name = "Greater Mindslave Implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_gmindslave/New()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/gmindslave(O)
	O.update_icon()
	return


/obj/item/weapon/storage/box/syndie_kit/caneshotgun

/obj/item/weapon/storage/box/syndie_kit/caneshotgun/New()
	..()
	new /obj/item/ammo_casing/shotgun/dart/assassination(src)
	new /obj/item/ammo_casing/shotgun/dart/assassination(src)
	new /obj/item/ammo_casing/shotgun/dart/assassination(src)
	new /obj/item/ammo_casing/shotgun/dart/assassination(src)
	new /obj/item/ammo_casing/shotgun/dart/assassination(src)
	new /obj/item/ammo_casing/shotgun/dart/assassination(src)
	new /obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/cane(src)

/obj/item/weapon/storage/box/syndie_kit/bioterror
	name = "bioterror syringe box"

/obj/item/weapon/storage/box/syndie_kit/bioterror/New()
	..()
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	new /obj/item/weapon/reagent_containers/syringe/bioterror(src)
	return

/*
/obj/item/weapon/storage/box/syndie_kit/imp_adrenal
	name = "boxed adrenal implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_adrenal/New()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/adrenalin(O)
	O.update_icon()
	return
*/


/obj/item/weapon/storage/box/syndie_kit/imp_storage
	name = "boxed storage implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_storage/New()
	..()
	new /obj/item/weapon/implanter/storage(src)
	return


/obj/item/weapon/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"
	can_hold = list(/obj/item/clothing/suit/space/syndicate, /obj/item/clothing/head/helmet/space/syndicate)
	max_w_class = 3

/obj/item/weapon/storage/box/syndie_kit/space/New()
	..()
	new /obj/item/clothing/suit/space/syndicate/black/red(src) // Black and red is so in right now
	new /obj/item/clothing/head/helmet/space/syndicate/black/red(src)
	return


/obj/item/weapon/storage/box/syndie_kit/emp
	name = "boxed EMP kit"

/obj/item/weapon/storage/box/syndie_kit/emp/New()
	..()
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/implanter/emp(src)
	new /obj/item/device/flashlight/emp(src)
	return

/obj/item/weapon/storage/box/syndie_kit/chemical
	name = "boxed chemical kit"
	storage_slots = 14

/obj/item/weapon/storage/box/syndie_kit/chemical/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/bottle/polonium(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/venom(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/wasting(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/cyanide(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/histamine(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/initropidril(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/pancuronium(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/sodium_thiopental(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/coniine(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/curare(src)
	new /obj/item/weapon/reagent_containers/food/drinks/beer/sleepy(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/amanitin(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	return

/obj/item/weapon/storage/box/syndie_kit/nuke
	name = "box"

/obj/item/weapon/storage/box/syndie_kit/nuke/New()
	..()
	new /obj/item/weapon/screwdriver/nuke(src)
	new /obj/item/nuke_core_container(src)
	new /obj/item/weapon/paper/nuke_instructions(src)

obj/item/weapon/storage/box/syndie_kit/shotguntender
	name = "shotgun ammo kit"

/obj/item/weapon/storage/box/syndie_kit/shotguntender/New()
	..()
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/stunslug(src)
	new /obj/item/ammo_casing/shotgun/incendiary/dragonsbreath(src)
	new /obj/item/ammo_casing/shotgun/incendiary/dragonsbreath(src)
	new /obj/item/ammo_casing/shotgun/dart/bioterror(src)
	return

/obj/item/weapon/storage/box/syndie_kit/hockeyset/New()
	..()
	new /obj/item/weapon/hockeypack(src)
	new /obj/item/clothing/head/helmet/hockey(src)
	new /obj/item/clothing/shoes/rollerskates/hockey(src)
	new /obj/item/clothing/suit/armor/hockey(src)
	new /obj/item/clothing/mask/gas/hockey(src)
	new /obj/item/weapon/storage/belt/hockey(src)
	return
