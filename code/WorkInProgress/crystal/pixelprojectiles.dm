//Test file

/obj/item/weapon/gun/projectile/NewGun
	desc = "The revolutionary new kind of projectile-based gun! WOOT"
	name = "new projectile gun"
	icon_state = "pistol"
	w_class = 3.0

	mag_type = /obj/item/ammo_box/magazine/NewProj
	burst_size = 1
	fire_delay = 0

/obj/item/ammo_box/magazine/NewProj
	name = "NewProj magazine"
	icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/NewProj
	caliber = "10mm"
	max_ammo = 30
	multiple_sprites = 2

/obj/item/ammo_casing/NewProj
	desc = "A SPECIAL bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/NewProj

/obj/item/projectile/NewProj
	icon_state="newbullet"
	kill_count = 25
	animate_movement = 0
	speed = 3

/obj/item/projectile/NewProj/fire()
	spawn()
		while(loc)
			if(kill_count < 1)
				qdel(src)
				return
			kill_count--
			if((!( current ) || loc == current))
				current = locate(Clamp(x+xo,1,world.maxx),Clamp(y+yo,1,world.maxy),z)

			if(!Angle) //Something's weeeird
				// world.log << "Projectile [src] was created without angle defined. Defining angle based on target..."
				Angle=round(Get_Angle(src,current))
			// world << "[Angle] angle"
			overlays.Cut()
			var/icon/I=new(initial(icon),icon_state) //using initial(icon) makes sure that the angle for that is reset as well
			I.Turn(Angle)
			// I.DrawBox(rgb(255,0,0,50),1,1,32,32)
			icon = I
			var/Pixel_x=round(sin(Angle)+16*sin(Angle)*2)
			var/Pixel_y=round(cos(Angle)+16*cos(Angle)*2)
			var/pixel_x_offset = pixel_x + Pixel_x
			var/pixel_y_offset = pixel_y + Pixel_y
			var/new_x = x
			var/new_y = y
			//Not sure if using whiles for this is good
			while(pixel_x_offset > 16)
				// world << "Pre-adjust coords (x++): xy [pixel_x] xy offset [pixel_x_offset]"
				pixel_x_offset -= 32
				pixel_x -= 32
				new_x++// x++
			while(pixel_x_offset < -16)
				// world << "Pre-adjust coords (x--): xy [pixel_x] xy offset [pixel_x_offset]"
				pixel_x_offset += 32
				pixel_x += 32
				new_x--

			while(pixel_y_offset > 16)
				// world << "Pre-adjust coords (y++): py [pixel_y] py offset [pixel_y_offset]"
				pixel_y_offset -= 32
				pixel_y -= 32
				new_y++
			while(pixel_y_offset < -16)
				// world << "Pre-adjust coords (y--): py [pixel_y] py offset [pixel_y_offset]"
				pixel_y_offset += 32
				pixel_y += 32
				new_y--

			step_towards(src, locate(new_x, new_y, z)) //Original projectiles stepped towards 'current'
			if(speed <= 1)
				speed = 1 //Lowest possible value
				pixel_x = pixel_x_offset
				pixel_y = pixel_y_offset
			else
				animate(src, pixel_x = pixel_x_offset, pixel_y = pixel_y_offset, time = speed - 1)

			var/turf/T = get_turf(src)
			if(T)
				T.color = "#6666FF"
				spawn(10)
					T.color = initial(T.color)

			if(!bumped && ((original && original.layer>=2.75) || ismob(original)))
				if(loc == get_turf(original))
					if(!(original in permutated))
						Bump(original)
			Range()
			sleep(speed)


//ATTEMPTS AT PIXEL-PRECISE PROJECTILES BELOW
//Pixel-precise collision won't really work in SS13 since it's largely tile-based.
//Thanks to Marquesas of Goon for talking some sense into me lol

// /obj/item/projectile/NewProj/Crossed(atom/movable/A)
// 	..()
// 	if(!A.CanPass(src, get_step(src, A.dir), 1, 0))
//	if(A in CheckHit()) //The crossed atom will be part of the hitlist if the projectile crossed that atom with it's center
// 		Hit(A)

// /obj/item/projectile/NewProj/Bump(atom/A)
// 	if(A in CheckHit()) //The crossed atom will be part of the hitlist if the projectile crossed that atom with it's center
// 		Hit(A)

// /obj/item/projectile/NewProj/proc/CheckHit(var/NoDense) //Bool var
// 	var/rough_x = 0
// 	var/rough_y = 0
// 	var/final_x = 0
// 	var/final_y = 0
// 	var/list/hitlist = new
// 	//Assume standards
// 	var/i_width = world.icon_size
// 	var/i_height = world.icon_size

// 	//Find a value to divide pixel_ by
// 	var/n_width = (world.icon_size - (i_width/2))
// 	var/n_height = (world.icon_size - (i_height/2))

// 	//DY and DX
// 	rough_x = round(pixel_x/n_width)
// 	rough_y = round(pixel_y/n_height)

// 	//Find coordinates
// 	final_x = x + rough_x
// 	final_y = y + rough_y

// 	if(final_x || final_y)
// 		var/turf/T = locate(final_x, final_y, z)
// 		if(!T) return
// 		for(var/atom/A in T.contents)
// 			if((!NoDense && !A.density) || A == src) continue //Atom is not dense, meaning we can't collide with it. We also should ignore ourselves.

// 			var/icon/AMicon = icon(A.icon, A.icon_state)
// 			var/hitcheck = AMicon.GetPixel(pixel_x + (i_width/2), pixel_y + (i_height/2), dir=A.dir) //if the pixel is completely transparent this will return null. We offset pixel_x and pixel_y by 16 because of the projectile icons being centered.
// 			// AMicon.DrawBox("#FF0000", pixel_x + (i_width/2), pixel_y + (i_height/2))
// 			// A.icon = AMicon
// 			if(hitcheck) //Okay! Our projectile's icon center has touched the object!
// 				hitlist += A //Add the atom to collision checks
// 			//if((A && A.layer>=2.75) || ismob(A)))

// 	return hitlist //There's a problem of prioritizing collisions. Should it be the object with biggest layer? Or object with closest layer to the bullet's? Or just the latest instance in the list?