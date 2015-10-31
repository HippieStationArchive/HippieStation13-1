/obj/item/weapon/grenade/cluster
	desc = "It will explode into projectiles... or something."
	name = "cluster boom bang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "cluster_nade"
	item_state = "flashbang"
	origin_tech = "materials=2;combat=2"

	var/list/spawner_types = list() // all list entries must be object paths. You can have "entry" = num, num being weight.
	var/clusters = 1 // amount of type to deliver
	var/cluster_range_min = 3 //Minimal range for non-projectile movables
	var/cluster_range_max = 3 //Max range

/obj/item/weapon/grenade/cluster/prime()			// Prime now just handles the two loops that query for people in lockers and people who can see it.
	update_mob()
	if(spawner_types && spawner_types.len && clusters)
		// Make a quick flash
		var/turf/T = get_turf(src)
		if(!T) return //No turf, how the fuck.
		playsound(T, 'sound/effects/bang.ogg', 100, 1)

		for(var/i=1, i<=clusters, i++)
			spawn()
				var/picked = pickweight(spawner_types)
				var/atom/movable/M = PoolOrNew(picked, src.loc)
				M.loc = T
				
				var/spread = round((i / clusters - 0.5) * 360) //360 degree spread
				if(istype(M, /obj/item/projectile))
					var/obj/item/projectile/BB = M
					// var/turf/targloc = get_ranged_target_turf(BB, angle2dir(spread), world.maxx)
					// BB.starting = T
					// BB.current = T
					// BB.firer = usr
					// BB.yo = targloc.y - T.y
					// BB.xo = targloc.x - T.x
					BB.dir = angle2dir(spread)
					if(spread)
						BB.Angle = spread
					if(BB)
						BB.fire()

				else
					var/range = rand(cluster_range_min, cluster_range_max)
					var/turf/throw_at = get_ranged_target_turf(M, angle2dir(spread), range)
					M.throw_at(throw_at, range, 1)
	qdel(src)


/obj/item/weapon/grenade/cluster/taser
	name = "stun cluster grenade"
	desc = "It's a grenade that explodes into multiple electrodes."
	spawner_types = list(/obj/item/projectile/energy/electrode = 1)
	clusters = 8

/obj/item/weapon/grenade/cluster/makeshift
	name = "makeshift cluster grenade"
	desc = "This grenade explodes into shards, rods, etc."
	spawner_types = list(/obj/item/weapon/shard = 2, /obj/item/stack/rods = 1) //Rods have lower priority
	clusters = 8
	cluster_range_min = 2
	cluster_range_max = 5

/obj/item/weapon/grenade/cluster/bullet //Test grenade
	name = "bullet cluster grenade"
	desc = "It explodes into 16 bullets. Fukkin bullet hell."
	spawner_types = list(/obj/item/projectile/bullet/weakbullet3 = 1)
	clusters = 16