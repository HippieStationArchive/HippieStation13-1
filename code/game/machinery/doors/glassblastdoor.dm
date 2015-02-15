//THROUGH SWEAT AND TEARS HAVE I ADAPTED THIS DOOR TO NEWTG'S SHITTY AS FUCK DAMAGE SYSTEM HOLY SHIT FUCK

//A breakable glass version, used in brig cells.
/obj/machinery/door/poddoor/glass
	name = "cell door"
	desc = "A large heavy metal blast door. Now with windows! Can be repaired with a welder or reinforced glass (when it's completely broken)"
	icon_state = "pdoor_glass_closed"
	glass = 1
	//damage_sound = 'sound/effects/Glasshit.ogg'
	var/next_door_state = 1//Controls if it should open or close 0 =  open 1 = close

	var/health = 200
	var/maxhealth = 200
	var/damage_resistance = 0
	var/weldcooldown = 0 //So you can't spam welder to repair it instantly

	opacity = 0

	examine()
		..()
		var/damage = "terrible"
		if(health >= maxhealth)
			damage = "pristine"
		else if(health > maxhealth*0.7)
			damage = "good"
		else if(health > maxhealth*0.3)
			damage = "bad"
		usr << "It appears to be in [damage] condition."
		return


	close(var/forced = 0, var/ignorepower = 0)
		if(stat & BROKEN || (!ignorepower && (stat & NOPOWER)))
			return 0
		if(src.operating)
			return 0
		if(!ticker)
			return 0
		src.operating = 1
		flick("pdoor_glass_close", src)
		src.icon_state = "pdoor_glass_closed"
		layer = 3.1
		air_update_turf(1)

		sleep(5)
		density = 1
		playsound(src.loc, 'sound/machines/blast_door.ogg', 100, 1)
		crush()

		sleep(5)
		operating = 0

		return 1


	open(var/forced = 0, var/ignorepower = 0)
		if(stat & BROKEN || (!ignorepower && (stat & NOPOWER)))
			return 0
		if(src.operating)
			return 0
		if(!ticker)
			return 0
		src.operating = 1
		flick("pdoor_glass_open", src)
		src.icon_state = "pdoor_glass_opened"
		playsound(src.loc, 'sound/machines/blast_door.ogg', 100, 1)
		layer = 2.7
		sleep(5)
		density = 0
		sleep(5)
		operating = 0

		if(!forced && auto_close)
			spawn(auto_close)
				// Checks for being able to close are in close().
				close()

		return 1

		//return (..())


	process()
		..()
		if(stat & (NOPOWER|BROKEN))
			return 0
		if(next_door_state != density)
			switch(next_door_state)
				if(0)
					open()
				if(1)
					close()
		return


	attackby(obj/item/W as obj, mob/user as mob)
		if(!istype(W)||!istype(user))
			return 0
		user.changeNext_move(CLICK_CD_MELEE)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(user.a_intent == "help") //so you can still break windows with welding tools
				if(health < maxhealth)
					if(health <= 0)
						user << "<span class='notice'>You need reinforced glass to fix this door!</span>"
					else if(WT.remove_fuel(0,user) && weldcooldown < world.time)
						weldcooldown = world.time + 5 //half a second cooldown
						user << "<span class='notice'>You weld some of the [src]'s cracks and dents.</span>"
						health += 20
						if(health > maxhealth)
							health = maxhealth
						update_health()
						playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
				else
					user << "<span class='notice'>[src] is already in good condition.</span>"
		else if(istype(W,/obj/item/stack/sheet/rglass))
			var/obj/item/stack/sheet/rglass/GL = W
			if(health <= 0)
				if(GL.use(2))
					user << "<span class='notice'>You repair [src].</span>"
					health = 20
					update_health()
					playsound(loc, 'sound/items/Deconstruct.ogg', 40, 1)
				else
					user << "<span class='notice'>You need more glass.</span>"
		else if(stat & BROKEN)//No hitting it after it breaks
			return 0
		else if(..())//Could crowbar it or such so stop here
			return 1

//		damaged_by(W, user) Currently here as obj level attackby is commented out
		// if(istype(W, /obj/item/weapon/grab) || istype(W, /obj/item/weapon/plastique) || istype(W, /obj/item/weapon/reagent_containers/spray) || istype(W, /obj/item/weapon/packageWrap) | istype(W, /obj/item/device/detective_scanner))
		// 	return
		else
			damaged_by(W, user)
//		visible_message("\red <B>[src] has been hit by [user] with [W]</B>", 1)
		return 1


	//destroy_object()//Taken care of by check health as this can be fixed
	//	return

	emp_act(severity)
		return 0

	proc/update_health()
		if(health > 0)
			if(stat & BROKEN)
				stat &= ~BROKEN//If we are above 0 then we can function
				close()//Close the door, it will be set properly by the open/close state shortly
			return 1
		stat |= BROKEN//We are now broken
		src.icon_state = "pdoor_glass_broken"
		//src.SetOpacity(0)
		spawn(10)
			src.density = 0
			air_update_turf(1)
		return 0


//TODO ODS, remove this when we finish adding ODS
	bullet_act(var/obj/item/projectile/Bullet)// need to go over projectiles this is tmp
		if(Bullet.damtype == BRUTE || Bullet.damtype == BURN)
			health -= Bullet.damage
			update_health()
	//		damaged_by(Bullet)
		return ..()

//Below is what should be in objs.dm and not re-defined every time a fucking damageable object is created.
	proc/damaged_by(var/obj/item/W, var/mob/user = null, var/use_armor = 1)
		var/amount = W.force
		if(use_armor)
			amount = max((W.force-damage_resistance), 1)
		var/averb = "hit"
		if(W.attack_verb.len)
			averb = pick(W.attack_verb)
		if(W.force == 0 || amount <= 0 || damage_resistance == -1)
			visible_message("\red <b>\The [src] has been [averb] with \the [W][(user ? " by [user]" : "")] to no affect!</b>")
			return
		else
			visible_message("\red <b>\The [src] has been [averb] with \the [W][(user ? " by [user]!" : "!")]</b>")
		var/mob/living/L = user
		if(L)
			L.do_attack_animation(src)
		damage(amount,0)//Already calc'd armor above
		return


	proc/damage(var/amount, var/use_armor = 1, var/use_sound = 1)
		if(damage_resistance == -1)
			return
		if(use_armor)
			amount = max((amount-damage_resistance), 1)
		if(amount > 0)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 80, 1, -1)
		health -= amount
		update_health()
		return


	//Called to finish off an item
	proc/destroy_object()
		// if(!defer_powernet_rebuild)
		//if(SSpower.defer_powernet_rebuild <= 0)//This is a very ugly hack to make it not use message when a bomb goes off.  Its needed for the moment, will fix later
		visible_message("\red [src] breaks!")//Add something to prevent a bomb from causing this to run
		Del()
		return