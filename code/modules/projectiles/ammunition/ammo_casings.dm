/obj/item/ammo_casing/a357
	desc = "A .357 cartridge."
	icon_state = "casing_357"
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/a50
	desc = "A .50 Action Express cartridge."
	icon_state = "casing_357"
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/c38
	desc = "A .38 Special rubber-bullet cartridge."
	icon_state = "casing_38"
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/weakbullet2

/obj/item/ammo_casing/c10mm
	desc = "A 10mm cartridge."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/midbullet3

/obj/item/ammo_casing/c44
	desc = "A .44 AMP cartridge."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/heavybullet2

/obj/item/ammo_casing/caseless/a68
	desc = "A 6.8x43mm cartridge."
	caliber = "6.8"
	projectile_type = /obj/item/projectile/bullet/heavybullet3

/obj/item/ammo_casing/c9mm
	desc = "A 9mm cartridge."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/weakbullet3

/obj/item/ammo_casing/c9mmap
	desc = "An armour-piercing 9mm cartridge."
	caliber = "9mm"
	projectile_type =/obj/item/projectile/bullet/armourpiercing

/obj/item/ammo_casing/c9mmtox
	desc = "A toxic 9mm cartridge."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/toxinbullet

/obj/item/ammo_casing/c9mminc
	desc = "An incendiary 9mm cartridge."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/incendiary/firebullet

/obj/item/ammo_casing/c45
	desc = "A .45 ACP cartridge."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge lead slug."
	icon_state = "blshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet
	materials = list(MAT_METAL=4000)


/obj/item/ammo_casing/shotgun/buckshot
	name = "buckshot shell"
	desc = "A 12 gauge buckshot shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet
	pellets = 5
	variance = 25

/obj/item/ammo_casing/shotgun/rubbershot
	name = "rubber shot"
	desc = "A shotgun casing filled with densely-packed rubber balls, used to incapacitate crowds from a distance."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/rpellet
	pellets = 5
	variance = 25
	materials = list(MAT_METAL=4000)


/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag slug"
	desc = "A weak beanbag slug for riot control."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/weakbullet
	materials = list(MAT_METAL=250)


/obj/item/ammo_casing/shotgun/improvised
	name = "improvised shell"
	desc = "A shotgun shell loaded with metal shards and weak propellant."
	icon_state = "improvshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shrapnel
	materials = list(MAT_METAL=250)
	pellets = 5
	variance = 40


/obj/item/ammo_casing/shotgun/improvised/overload
	name = "overloaded improvised shell"
	desc = "A shotgun shell overloaded with metal shards and powerful propellant. Almost as effective as buckshot."
	icon_state = "improvshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shrapnel
	materials = list(MAT_METAL=250)
	pellets = 9
	variance = 50
	
/obj/item/ammo_casing/shotgun/coinshot
	name = "coinshot shell"
	desc = "A shotgun shell loaded with coins and weak propellant. Stings like hell."
	icon_state = "improvshell"
	projectile_type = /obj/item/projectile/bullet/pellet/coinshot
	materials = list(MAT_METAL=250)
	pellets = 5
	variance = 30
	
/obj/item/ammo_casing/shotgun/coinshot/overload
	name = "overloaded coinshot shell"
	desc = "A shotgun shell loaded with coins and powerful propellant. Liable to leave your target writhing in pain."
	icon_state = "improvshell"
	projectile_type = /obj/item/projectile/bullet/pellet/coinshot/overload
	materials = list(MAT_METAL=250)
	pellets = 5
	variance = 35

/obj/item/ammo_casing/shotgun/stunslug
	name = "taser slug"
	desc = "A stunning taser slug."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/bullet/stunshot
	materials = list(MAT_METAL=250)


/obj/item/ammo_casing/shotgun/meteorshot
	name = "meteorshot shell"
	desc = "A shotgun shell rigged with CMC technology, which launches a massive slug when fired."
	icon_state = "mshell"
	projectile_type = /obj/item/projectile/bullet/meteorshot

/obj/item/ammo_casing/shotgun/pulseslug
	name = "pulse slug"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "pshell"
	projectile_type = /obj/item/projectile/beam/pulse/shot

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary slug"
	desc = "An incendiary-coated shotgun slug."
	icon_state = "ishell"
	projectile_type = /obj/item/projectile/bullet/incendiary/shell

/obj/item/ammo_casing/shotgun/frag12
	name = "FRAG-12 slug"
	desc = "A high explosive breaching round for a 12 gauge shotgun."
	icon_state = "heshell"
	projectile_type = /obj/item/projectile/bullet/frag12

/obj/item/ammo_casing/shotgun/incendiary/dragonsbreath
	name = "dragonsbreath shell"
	desc = "A shotgun shell which fires a spread of incendiary pellets."
	icon_state = "ishell2"
	projectile_type = /obj/item/projectile/bullet/incendiary/shell/dragonsbreath
	pellets = 4
	variance = 35

/obj/item/ammo_casing/shotgun/ion
	name = "ion shell"
	desc = "An advanced shotgun shell which uses a subspace ansible crystal to produce an effect similar to a standard ion rifle. \
	The unique properties of the crystal splot the pulse into a spread of individually weaker bolts."
	icon_state = "ionshell"
	projectile_type = /obj/item/projectile/ion/weak
	pellets = 4
	variance = 36

/obj/item/ammo_casing/shotgun/laserslug
	name = "laser slug"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a laser weapon in a ballistic package."
	icon_state = "lshell"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/shotgun/techshell
	name = "unloaded technological shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	icon_state = "cshell"
	projectile_type = null

/obj/item/ammo_casing/shotgun/dart
	name = "shotgun dart"
	desc = "A dart for use in shotguns. Can be injected with up to 30 units of any chemical."
	icon_state = "cshell"
	projectile_type = /obj/item/projectile/bullet/dart

/obj/item/ammo_casing/shotgun/dart/New()
	..()
	flags |= NOREACT
	flags |= OPENCONTAINER
	create_reagents(30)

/obj/item/ammo_casing/shotgun/dart/attackby()
	return

/obj/item/ammo_casing/shotgun/dart/bioterror
	desc = "A shotgun dart filled with deadly toxins."

/obj/item/ammo_casing/shotgun/dart/bioterror/New()
	..()
	reagents.add_reagent("neurotoxin", 6)
	reagents.add_reagent("spore", 6)
	reagents.add_reagent("mutetoxin", 6) //;HELP OPS IN MAINT
	reagents.add_reagent("coniine", 6)
	reagents.add_reagent("sodium_thiopental", 6)

/obj/item/ammo_casing/shotgun/dart/assassination
	desc = "A specialist shotgun dart designed to inncapacitate and kill the target over time, so you can get very far away from your target"

/obj/item/ammo_casing/shotgun/dart/assassination/New()
	..()
	reagents.add_reagent("neurotoxin", 6)
	reagents.add_reagent("lexorin", 6)

/obj/item/ammo_casing/a545
	desc = "A 5.45x39mm cartridge."
	icon_state = "casing_545"
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/weakbullet3

/obj/item/ammo_casing/a556
	desc = "A 5.56x45mm cartridge."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/heavybullet
	icon_state = "casing_545"

/obj/item/ammo_casing/a762x39
	desc = "A 7.62x39mm bullet casing."
	icon_state = "casing_762x39"
	caliber = "7.62x39"
	projectile_type = /obj/item/projectile/bullet/heavybullet

/obj/item/ammo_casing/caseless
	desc = "A caseless cartridge."


/obj/item/ammo_casing/caseless/fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params, distro, quiet)
	if (..())
		loc = null
		return 1
	else
		return 0

/obj/item/ammo_casing/caseless/update_icon()
	..()
	icon_state = "[initial(icon_state)]"

/obj/item/ammo_casing/caseless/a75
	desc = "A .75 cartridge."
	caliber = "75"
	icon_state = "s-casing-live"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/caseless/cplasma
	desc = "A disposable, specialized plasma cartridge."
	caliber = "plasma"
	icon_state = "casing_plasma"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/a40mm
	name = "40mm HE shell"
	desc = "A cased high explosive grenade that can only be activated once fired out of a grenade launcher."
	caliber = "40mm"
	icon_state = "40mmHE"
	projectile_type = /obj/item/projectile/bullet/a40mm

/obj/item/ammo_casing/caseless/magspear
	name = "magnetic spear"
	desc = "A reusable spear that is typically loaded into kinetic spearguns."
	projectile_type = /obj/item/projectile/bullet/reusable/magspear
	caliber = "speargun"
	icon_state = "magspear"
	throwforce = 15 //still deadly when thrown
	throw_speed = 3

/obj/item/ammo_casing/caseless/foam_dart
	name = "foam dart"
	desc = "Its nerf or nothing! Ages 8 and up."
	projectile_type = /obj/item/projectile/bullet/reusable/foam_dart
	caliber = "foam_force"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foamdart"
	var/modified = 0

/obj/item/ammo_casing/caseless/foam_dart/update_icon()
	..()
	if (modified)
		icon_state = "foamdart_empty"
		desc = "Its nerf or nothing! ... Although, this one doesn't look too safe."

/obj/item/ammo_casing/caseless/foam_dart/attackby(obj/item/A, mob/user, params)
	..()
	if (istype(A, /obj/item/weapon/screwdriver) && !modified)
		modified = 1
		BB.damage_type = BRUTE
		icon_state = "foamdart_empty"
		desc = "Its nerf or nothing! ... Although, this one doesn't look too safe."
		user << "<span class='notice'>You pop the safety cap off of [src].</span>"
	else if ((istype(A, /obj/item/weapon/pen)) && modified && !BB.contents.len)
		if(!user.unEquip(A))
			return
		A.loc = BB
		BB.damage += 10
		user << "<span class='notice'>You insert [A] into [src].</span>"
	return

/obj/item/ammo_casing/caseless/foam_dart/riot
	name = "riot foam dart"
	desc = "Whose smart idea was it to use toys as crowd control? Ages 18 and up."
	projectile_type = /obj/item/projectile/bullet/reusable/foam_dart/riot
	icon_state = "foamdart_riot"

/obj/item/ammo_casing/a762rubber
	desc = "A Rubber 7.62x51mm cartridge."
	icon_state = "762steel-casing"
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/weakbullet2

/obj/item/ammo_casing/musket
	name = "paper cartridge"
	desc = "A paper cartridge for a breechloading rifle."
	icon_state = "papercartridge"
	caliber = "musket"
	projectile_type = /obj/item/projectile/bullet/midbullet2

/obj/item/ammo_casing/minieball // lazy memecuck,putting it in here
	name = "minie ball"
	desc = "A small projectile with grooves"
	icon_state = "minieball"
