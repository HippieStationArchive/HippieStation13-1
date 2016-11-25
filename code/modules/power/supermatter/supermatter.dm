#define NITROGEN_RETARDATION_FACTOR 0.15	//Higher == N2 slows reaction more
#define THERMAL_RELEASE_MODIFIER 100		//Higher == more heat released during reaction
#define PLASMA_RELEASE_MODIFIER 250		//Higher == less plasma released by reaction
#define OXYGEN_RELEASE_MODIFIER 500		//Higher == less oxygen released at high temperature/power
#define REACTION_POWER_MODIFIER 1.1			//Higher == more overall power

/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
#define POWER_FACTOR 0.5
#define DECAY_FACTOR 700			//Affects how fast the supermatter power decays
#define CRITICAL_TEMPERATURE 800	//K
#define CHARGING_FACTOR 0.05
#define DAMAGE_RATE_LIMIT 3			//damage rate cap at power = 300, scales linearly with power


//These would be what you would get at point blank, decreases with distance
#define DETONATION_RADS 200
#define DETONATION_HALLUCINATION 600


#define WARNING_DELAY 30			//seconds between warnings.

/obj/machinery/power/supermatter
	name = "Supermatter"
	desc = "A strangely translucent and iridescent crystal. \red You get headaches just from looking at it."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "darkmatter"
	density = 1
	anchored = 0
	luminosity = 4
	pressure_resistance = 85000

	var/max_luminosity = 8 // Now varies based on power.
	var/max_power=2000

	var/gasefficency = 3

	var/base_icon_state = "darkmatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	var/warning_color = "#B8B800"
	var/emergency_color = "#D9D900"

	var/grav_pulling = 0
	var/pull_radius = 6
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 400
	var/pull_ticks = 4
	var/explosion_power = 6

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundand explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0
	var/sound_played = 0
	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//        var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.02

	var/obj/item/device/radio/radio

	var/debug = 0
	var/has_been_powered = 0

/obj/machinery/power/supermatter/New()
	. = ..()
	radio = new (src)


/obj/machinery/power/supermatter/Destroy()
	qdel(radio)
	. = ..()

/obj/machinery/power/supermatter/proc/explode()
	message_admins("Supermatter exploded at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("Supermatter exploded at ([x],[y],[z])")
	anchored = 1
	grav_pulling = 1
	exploded = 1
	for(var/mob/living/mob in living_mob_list)
		if(loc.z == mob.loc.z)
			if(istype(mob, /mob/living/carbon/human))
				//Hilariously enough, running into a closet should make you get hit the hardest.
				var/mob/living/carbon/human/H = mob
				H.hallucination += max(0, min(300, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(mob, src) + 1)) ) )
			var/rads = DETONATION_RADS * sqrt( 1 / (get_dist(mob, src) + 1) )
			var/blocked = mob.run_armor_check(null, "rad", "Your clothes feel warm.", "Your clothes feel warm.")
			mob.apply_effect(rads, IRRADIATE, blocked)
	spawn(pull_time)
		explosion(get_turf(src), explosion_power, explosion_power * 2, explosion_power * 4, explosion_power * 6, 1, 1)
		qdel(src)
		return

//Changes color and luminosity of the light to these values if they were not already set
///obj/machinery/power/supermatter/proc/shift_light(var/lum, var/clr)
//	if(l_color != clr)
//		l_color = clr
//	if(luminosity != lum)
//		SetLuminosity(lum)

/obj/machinery/power/supermatter/throw_impact(atom/hit_atom)
	if(!..())
		explode()

/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		radio.talk_into(src, alert_msg)

/obj/machinery/power/supermatter/process()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(istype(L, /turf/space))	// Stop processing this stuff if we've been ejected.
		return

	if(!has_been_powered) //Not been powered
		return

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		color = warning_color
		if(damage > emergency_point)
			color = emergency_color
			//shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && (world.timeofday - lastwarning) >= WARNING_DELAY * 10)
			announce_warning()
	//else
		//shift_light(4,initial(l_color))
	if(grav_pulling)
		supermatter_pull()

	//Ok, get the air from the turf
	var/datum/gas_mixture/env = L.return_air()

	//Remove gas from surrounding area
	var/datum/gas_mixture/removed = env.remove(gasefficency * env.total_moles())

	if(!removed || !removed.total_moles())
		damage += max((power-1600)/10, 0)
		power = min(power, 1600)
		return 1

	damage_archived = damage
	damage = max( damage + ( (removed.temperature - 600) / 75 ) , 0 ) // damage = 0 or (removed temp - 800) / 150
	//Ok, 100% oxygen atmosphere = best reaction
	//Maxes out at 100% oxygen pressure
	oxygen = max(min((removed.oxygen - (removed.nitrogen * NITROGEN_RETARDATION_FACTOR)) / MOLES_CELLSTANDARD, 1), 0)

	var/temp_factor = 50

	if(oxygen > 0.8)
		// with a perfect gas mix, make the power less based on heat
		icon_state = "[base_icon_state]_glow"
	else
		// in normal mode, base the produced energy around the heat
		temp_factor = 30
		icon_state = base_icon_state

	power = max( (removed.temperature * temp_factor / T0C) * oxygen + power, 0) //Total laser power plus an overload

	//We've generated power, now let's transfer it to the collectors for storing/usage
	transfer_energy()

	var/device_energy = power * REACTION_POWER_MODIFIER

	//To figure out how much temperature to add each tick, consider that at one atmosphere's worth
	//of pure oxygen, with all four lasers firing at standard energy and no N2 present, at room temperature
	//that the device energy is around 2140. At that stage, we don't want too much heat to be put out
	//Since the core is effectively "cold"

	//Also keep in mind we are only adding this temperature to (efficiency)% of the one tile the rock
	//is on. An increase of 4*C @ 25% efficiency here results in an increase of 1*C / (#tilesincore) overall.
	removed.temperature += (device_energy / THERMAL_RELEASE_MODIFIER)

	removed.temperature = max(0, min(removed.temperature, 2500))

	//Calculate how much gas to release
	removed.toxins += max(device_energy / PLASMA_RELEASE_MODIFIER, 0)

	removed.oxygen += max((device_energy + removed.temperature - T0C) / OXYGEN_RELEASE_MODIFIER, 0)

	if (debug)
		visible_message("[src]: Releasing [round(removed.temperature)] temp.")
		visible_message("[src]: Releasing [round(removed.toxins)] toxins.")
		visible_message("[src]: Releasing [round(removed.oxygen)] oxygen.")

		//visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

	env.merge(removed)

	for(var/mob/living/carbon/human/l in view(src, min(7, round(power ** 0.25)))) // If they can see it without mesons on.  Bad on them.
		if(!istype(l.glasses, /obj/item/clothing/glasses/meson))
			l.hallucination = max(0, min(200, l.hallucination + power * config_hallucination_power * sqrt( 1 / max(1, get_dist(l, src)) ) ) )

	for(var/mob/living/l in range(src, round((power / 100) ** 0.5)))
		var/rads = (power / 5) * sqrt( 1 / max(get_dist(l, src),1) )
		var/blocked = l.run_armor_check(null, "rad", "Your clothes feel warm.", "Your clothes feel warm.")
		l.apply_effect(rads, IRRADIATE, blocked)

	power -= (power/500)**3

	// Lighting based on power output.
	SetLuminosity(Clamp(round(Clamp(power/max_power,0,1)*max_luminosity), 4, max_luminosity))

	return 1


/obj/machinery/power/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.

	if(!has_been_powered)
		var A = Proj.firer
		if(ismob(A))
			var/mob/M = A
			investigate_log("Projectile was fired by [M.ckey]", "supermatter")

		investigate_log("has been powered for the first time.", "supermatter")
		message_admins("[src] has been powered for the first time <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.")
		has_been_powered = 1

	if(istype(Proj, /obj/item/projectile/beam))
		power += Proj.damage * config_bullet_energy	* CHARGING_FACTOR / POWER_FACTOR
	else
		damage += Proj.damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"
	return

/obj/machinery/power/supermatter/attack_ai(mob/user as mob)
	user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"

/obj/machinery/power/supermatter/attack_hand(mob/living/user)
	if(!istype(user))
		return
	user.visible_message("<span class='danger'>\The [user] reaches out and touches \the [src], inducing a resonance... \his body starts to glow and bursts into flames before flashing into ash.</span>",\
		"<span class='userdanger'>You reach out and touch \the [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class='italics'>You hear an unearthly noise as a wave of heat washes over you.</span>")

	playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/obj/machinery/power/supermatter/proc/transfer_energy()
	for(var/obj/machinery/power/rad_collector/R in rad_collectors)
		var/distance = get_dist(R, src)
		if(distance <= 15)
			//for collectors using standard phoron tanks at 1013 kPa, the actual power generated will be this power*POWER_FACTOR*20*29 = power*POWER_FACTOR*580
			R.receive_pulse(power * POWER_FACTOR * (min(3/distance, 1))**2)
	return

/obj/machinery/power/supermatter/attackby(obj/item/W, mob/living/user, params)
	if(!istype(W) || (W.flags & ABSTRACT) || !istype(user))
		return
	if(user.drop_item(W))
		Consume(W)
		user.visible_message("<span class='danger'>As [user] touches \the [src] with \a [W], silence fills the room...</span>",\
			"<span class='userdanger'>You touch \the [src] with \the [W], and everything suddenly goes silent.\"</span>\n<span class='notice'>\The [W] flashes into dust as you flinch away from \the [src].</span>",\
			"<span class='italics'>Everything suddenly goes silent.</span>")

		playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1)

		radiation_pulse(get_turf(src), 1, 1, 150, 1)


/obj/machinery/power/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /mob/living))
		AM.visible_message("<span class='danger'>\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class='userdanger'>You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class='italics'>You hear an unearthly noise as a wave of heat washes over you.</span>")
	else if(isobj(AM) && !istype(AM, /obj/effect))
		AM.visible_message("<span class='danger'>\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class='italics'>You hear a loud crack as you are washed with a wave of heat.</span>")
	else
		return

	playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1)

	Consume(AM)


/obj/machinery/power/supermatter/singularity_act()
	var/gain = 100
	investigate_log("Supermatter shard consumed by singularity.","singulo")
	message_admins("Singularity has consumed a supermatter shard and can now become stage six.")
	visible_message("<span class='userdanger'>[src] is consumed by the singularity!</span>")
	for(var/mob/M in mob_list)
		M << 'sound/effects/supermatter.ogg' //everyone goan know bout this
		M << "<span class='boldannounce'>A horrible screeching fills your ears, and a wave of dread washes over you...</span>"
	qdel(src)
	return(gain)

/obj/machinery/power/supermatter/proc/Consume(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/user = AM
		if(user.ckey)
			log_attack("[src] has consumed [pulledby ? "(being pulled by [pulledby])" : "last touched by [fingerprintslast]"] [AM]/([key_name(user)])")
		user.dust()
		power += 200
		message_admins("[src] has consumed [key_name_admin(user)]<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.")
		investigate_log("has consumed [key_name(user)].", "supermatter")
	else if(isobj(AM) && !istype(AM, /obj/effect))
		investigate_log("has consumed [AM].", "supermatter")
		qdel(AM)

		//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/l in range(10))
		if(l in view())
			l.show_message("<span class=\"warning\">As \the [src] slowly stops resonating, you find your skin covered in new radiation burns.</span>", 1,\
				"<span class=\"warning\">The unearthly ringing subsides and you notice you have new radiation burns.</span>", 2)
		else
			l.show_message("<span class=\"warning\">You hear an uneartly ringing and notice your skin is covered in fresh radiation burns.</span>", 2)
		var/rads = 500 * sqrt( 1 / (get_dist(l, src) + 1) )
		var/blocked = l.run_armor_check(null, "rad", "Your clothes feel warm.", "Your clothes feel warm.")
		l.apply_effect(rads, IRRADIATE, blocked)

/obj/machinery/power/supermatter/proc/supermatter_pull()
	set background = BACKGROUND_ENABLED
	if(sound_played == 0)
		switch(rand(1,2))
			if(1)
				playsound(src.loc, 'sound/misc/smboom2.ogg', 100, 0, 16)
			if(2)
				playsound(src.loc, 'sound/misc/smboom1.ogg', 100, 0, 16)

	sound_played = 1
	if(pull_ticks != 0)
		spawn((pull_time / pull_ticks) - 15)
			for(var/atom/X in orange(pull_radius,src))
				var/dist = get_dist(X, src)
				var/obj/machinery/power/supermatter/S = src

				if(dist > 4) //consume_range
					X.singularity_pull(S, STAGE_FIVE)
				else if(dist <= 4) //consume_range
					if(istype(src, /obj/machinery/power/supermatter)) continue // don't delete us yo
					explosion(X.loc,1,2,3)
					qdel(X)
		pull_ticks = pull_ticks - 1
	return

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. \red You get headaches just from looking at it."
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	max_luminosity = 5
	max_power=3000

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_radius = 5
	pull_time = 45
	explosion_power = 3
	pressure_resistance = 65000

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return