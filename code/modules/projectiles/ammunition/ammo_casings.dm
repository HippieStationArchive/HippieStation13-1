/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet
	icon_state = "casing_357"

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet
	icon_state = "casing_357"

/obj/item/ammo_casing/a556
	desc = "A 5.56x45mm bullet casing."
	caliber = "556"
	projectile_type = /obj/item/projectile/bullet/l85l
	icon_state = "casing_357"

/obj/item/ammo_casing/a556/s
	desc = "A 5.56x45mm bullet casing."
	caliber = "556"
	projectile_type = /obj/item/projectile/bullet/l85s
	icon_state = "casing_357"

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/weakbullet2
	icon_state = "casing_38"

/obj/item/ammo_casing/c10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/midbullet3

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/weakbullet3

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge lead slug."
	icon_state = "blshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet
	m_amt = 4000


/obj/item/ammo_casing/shotgun/buckshot
	name = "buckshot shell"
	desc = "A 12 gauge buckshot shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet
	pellets = 5
	variance = 0.8


/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag slug"
	desc = "A weak beanbag slug for riot control."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/weakbullet
	m_amt = 250


/obj/item/ammo_casing/shotgun/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/weak
	m_amt = 250
	pellets = 5
	variance = 0.8


/obj/item/ammo_casing/shotgun/stunslug
	name = "taser slug"
	desc = "A stunning taser slug."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/bullet/stunshot
	m_amt = 250


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
	variance = 0.9

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

/obj/item/ammo_casing/a762
	desc = "A 7.62x51mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet
	icon_state = "casing_762x51"

/obj/item/ammo_casing/a545
	desc = "A 5.45mm bullet casing."
	caliber = "a545"
	projectile_type = /obj/item/projectile/bullet/heavybullet
	icon_state = "casing_545"

/obj/item/ammo_casing/a762x39
	desc = "A 7.62x39mm bullet casing."
	caliber = "a7.62x39"
	projectile_type = /obj/item/projectile/bullet/heavybullet
	icon_state = "casing_762x39"

/obj/item/ammo_casing/caseless
	desc = "A caseless bullet casing."


/obj/item/ammo_casing/caseless/fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params, var/distro, var/quiet)
	if (..())
		loc = null
		return 1
	else
		return 0


/obj/item/ammo_casing/caseless/a75
	desc = "A .75 bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/a40mm
	name = "40mm HE shell"
	desc = "A cased high explosive grenade that can only be activated once fired out of a grenade launcher."
	caliber = "40mm"
	icon_state = "40mmHE"
	projectile_type = /obj/item/projectile/bullet/a40mm
