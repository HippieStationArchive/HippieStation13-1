
#define REM REAGENTS_EFFECT_MULTIPLIER


//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 1.5
	metabolization_rate = 3 * REAGENTS_METABOLISM

datum/reagent/toxin/on_mob_life(var/mob/living/M as mob)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM)
	..()
	return

datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 1

datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0

datum/reagent/toxin/mutagen/reaction_mob(var/mob/living/carbon/M, var/method=TOUCH, var/volume)
	if(!..())
		return
	if(!istype(M) || !M.dna)
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	src = null
	if((method==TOUCH && prob(33)) || method==INGEST)
		randmuti(M)
		if(prob(98))
			randmutb(M)
		else
			randmutg(M)
		domutcheck(M, null)
		updateappearance(M)
	return

datum/reagent/toxin/mutagen/on_mob_life(var/mob/living/carbon/M)
	if(istype(M))
		M.apply_effect(5,IRRADIATE,0)
	..()
	return

datum/reagent/toxin/plasma
	name = "Plasma"
	id = "plasma"
	description = "Plasma in its liquid form."
	color = "#DB2D08" // rgb: 219, 45, 8
	toxpwr = 3

datum/reagent/toxin/plasma/on_mob_life(var/mob/living/M as mob)
	if(holder.has_reagent("inaprovaline"))
		holder.remove_reagent("inaprovaline", 2*REM)
	..()
	return

datum/reagent/toxin/plasma/reaction_obj(var/obj/O, var/volume)
	src = null
	/*if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg/slime))
		var/obj/item/weapon/reagent_containers/food/snacks/egg/slime/egg = O
		if (egg.grown)
			egg.Hatch()*/
	if((!O) || (!volume))	return 0
	O.atmos_spawn_air(SPAWN_TOXINS|SPAWN_20C, volume)

datum/reagent/toxin/plasma/reaction_turf(var/turf/simulated/T, var/volume)
	src = null
	if(istype(T))
		T.atmos_spawn_air(SPAWN_TOXINS|SPAWN_20C, volume)
	return

datum/reagent/toxin/plasma/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//Splashing people with plasma is stronger than fuel!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 5)
		return

datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0

datum/reagent/toxin/lexorin/on_mob_life(var/mob/living/M as mob)
	if(M.stat != DEAD)
		if(prob(33))
			M.take_organ_damage(1*REM, 0)
		M.adjustOxyLoss(3)
		if(prob(20))
			M.emote("gasp")
	..()
	return

datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

datum/reagent/toxin/slimejelly/on_mob_life(var/mob/living/M as mob)
	if(prob(10))
		M << "<span class='danger'>Your insides are burning!</span>"
		M.adjustToxLoss(rand(20,60)*REM)
	else if(prob(40))
		M.heal_organ_damage(5*REM,0)
	..()
	return
datum/reagent/toxin/aus//doesn't really work very well , someone should look at this.
	name = "Ausium"
	id = "aus"
	description = "You're a roight cant moit!"
	color = "#75AC53"
datum/reagent/toxin/aus/on_mob_life(var/mob/living/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.name = "Aussie Cant"
		H.adjustBrainLoss(50)//hahah
		holder.remove_reagent(src.id, 100, safety = 1)
datum/reagent/toxin/emit
	name = "Emittrium"
	id = "emit"
	description = "Try heating it."
	color = "#AAFFAA"
datum/reagent/toxin/impvolt
	name = "Translucent mixture"
	id = "impvolt"
	description = "It's sparking slightly."
	color = "#CABFAC"
datum/reagent/toxin/impvolt/on_mob_life(var/mob/living/M as mob)
	if(prob(25))
		M<<"<span class='userdanger'>Your insides burn!</span>"
		M.take_organ_damage(10)
		holder.remove_reagent(src.id,15)
datum/reagent/toxin/volt
	name = "Sparking mixture"
	id = "volt"
	description = " A bubbling concoction of sparks and static electricity."
	color = "#11BFAC"
datum/reagent/toxin/volt/on_mob_life(var/mob/living/M as mob)
	if(prob(20))
		for(var/mob/living/T in view(M.loc,6))
			var/obj/effect/lightning/eff = new /obj/effect/lightning(T.loc)

			eff.start()
			T.adjustFireLoss(15)
			T.adjustBrainLoss(10)
		playsound(M.loc,'sound/effects/thunder.ogg',50,1)
		holder.remove_reagent(src.id, 10, safety = 1)
datum/reagent/toxin/volt/on_fart(var/mob/living/M as mob)
	var/obj/effect/lightning/eff = new /obj/effect/lightning(M.loc)
	eff.start()
	playsound(M.loc,'sound/effects/thunder.ogg',50,1)
	M.gib()
datum/reagent/toxin/emit_on
	name = "Glowing Emittrium"
	id = "emit_on"
	description = "Run!"
	color = "#1211FB"
datum/reagent/toxin/emit_on/on_update()
	var/emit_dir = pick(1,2,3,4)
	var/obj/item/projectile/beam/emitter/A = PoolOrNew(/obj/item/projectile/beam/emitter,get_turf(holder.my_atom))
	switch(emit_dir)
		if(1)
			A.yo = 20
			A.xo = 0
		if(2)
			A.yo = 0
			A.xo = 20
		if(3)
			A.yo = 0
			A.xo = -20
		else
			A.yo = -20
			A.xo = 0
	A.fire()
	holder.remove_reagent(src.id,10,safety = 1)
datum/reagent/toxin/emit_on/on_mob_life(var/mob/living/M as mob)
	M.adjustFireLoss(10)
	var/emit_dir = pick(1,2,3,4)
	var/obj/item/projectile/beam/emitter/A = PoolOrNew(/obj/item/projectile/beam/emitter,get_turf(holder.my_atom))
	switch(emit_dir)
		if(1)
			A.yo = 20
			A.xo = 0
		if(2)
			A.yo = 0
			A.xo = 20
		if(3)
			A.yo = 0
			A.xo = -20
		else
			A.yo = -20
			A.xo = 0
	A.fire()
	holder.remove_reagent(src.id,10,safety = 1)
datum/reagent/toxin/emit_on/on_fart(var/mob/living/M as mob)
	M.adjustFireLoss(50)
	var/obj/item/projectile/beam/emitter/A = PoolOrNew(/obj/item/projectile/beam/emitter,get_turf(holder.my_atom))
	var/obj/item/projectile/beam/emitter/B = PoolOrNew(/obj/item/projectile/beam/emitter,get_turf(holder.my_atom))
	var/obj/item/projectile/beam/emitter/C = PoolOrNew(/obj/item/projectile/beam/emitter,get_turf(holder.my_atom))
	var/obj/item/projectile/beam/emitter/D = PoolOrNew(/obj/item/projectile/beam/emitter,get_turf(holder.my_atom))
	A.yo = 20
	A.xo = 0
	B.yo = 0
	B.xo = 20
	C.yo = 0
	C.xo = -20
	D.yo = -20
	D.xo = 0
	A.fire()
	B.fire()
	C.fire()
	D.fire()
	holder.remove_reagent(src.id,100,safety = 1)
datum/reagent/toxin/cryonium
	name = "Cryonium"
	id = "cryo"
	description = "Chilly."
	color = "#75AC53"
datum/reagent/toxin/cryonium/on_mob_life(var/mob/living/M as mob)
	M.bodytemperature -= 9//this is how you avoid super boom
datum/reagent/toxin/cryonium/on_update()
	if(!holder)
		return
	if(holder.present_machines[1]-5 >= 0)
		holder.present_machines[1] -= 5
	else
		holder.present_machines[1] -= (5- holder.present_machines[1])
	holder.remove_reagent(src.id,5)
datum/reagent/toxin/pyrosium
	name = "Pyrosium"
	id = "pyro"
	description = "Warm."
	color = "#75AC53"
datum/reagent/toxin/pyrosium/on_mob_life(var/mob/living/M as mob)
	M.bodytemperature += 9
	holder.remove_reagent(src.id,5,safety = 1)
datum/reagent/toxin/pyrosium/on_update()
	if(!holder)
		return
	if(holder.present_machines[1]+5 <= 500)
		holder.present_machines[1] += 5
	else
		holder.present_machines[1] += (500- holder.present_machines[1])
	holder.remove_reagent(src.id,5)
datum/reagent/toxin/emote
	name = "Pure Emotium"
	id = "emote"
	description = "This shouldn't be difficult to figure out."
	color = "#75AC53"
datum/reagent/toxin/emote/on_mob_life(var/mob/living/M as mob)
	if(prob(20))
		M.emote(pick("fart","flap","aflap","airguitar","blink","shrug","cough","sneeze","shake","twitch"))
		M.hallucination += 1
datum/reagent/toxin/smokep
	name = "Smoke Powder"
	id = "smokep"
	description = "Try farting I dare you!"
	color = "#75AC53"
datum/reagent/toxin/smokep/on_mob_life(var/mob/living/M as mob)
	if(prob(5))
		M.emote(pick("cough","sneeze"))
datum/reagent/toxin/smokep/on_fart(var/mob/living/M as mob)
	M.visible_message("<span class='danger'>[M] farts out a noxious cloud!</span>")
	create_smoke(holder, 10)

datum/reagent/toxin/fart//for wu eric
	name = "Fartium"
	id = "fart"
	description = "Hmm I wonder?"
	color = "#10AC53"
datum/reagent/toxin/fart/on_mob_life(var/mob/living/M as mob)
	if(prob(20))
		M.emote("fart")//yup thats it
datum/reagent/toxin/sboom
	name = "Nitrogenated isopropyl alcohol"
	id = "sboom"
	description = "Hmm , needs more nitrogen!"
	color = "#13BC5E"
datum/reagent/toxin/superboom
	name = "N-amino azidotetrazole"
	id = "superboom"
	description = "If this stuff is even slightly warmed it will make a mess."
	color = "#13BC5E"
datum/reagent/toxin/superboom/on_mob_life(var/mob/living/M as mob)
	if(M.bodytemperature > 285)//you CAN avoid it , just it's difficult
		var/location = get_turf(holder.my_atom)
		explosion(location,volume/20,volume/15,volume/10)
		holder.clear_reagents()
		return


datum/reagent/toxin/superboom/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if(M.bodytemperature > 285)
		var/location = get_turf(holder.my_atom)
		explosion(location,volume/20,volume/15,volume/10)
		holder.clear_reagents()
		return
datum/reagent/toxin/superboom/on_update()
	if(!holder)
		return
	if(holder.present_machines[1] >= 285)
		var/location = get_turf(holder.my_atom)
		explosion(location,volume/20,volume/15,volume/10)
		holder.clear_reagents()
		return

datum/reagent/toxin/ethyl
	name = "Ethyl alcohol"
	id = "ethyl"
	description = "Brilliant at burning"
	color = "#A245B2"
datum/reagent/toxin/carbonf
	name = "Carbonic fluoride"
	id = "carbonf"
	description = "A fairly nasty chemical used to produce potent medicines"
	color = "#A300B3"
datum/reagent/toxin/carbonf/on_mob_life(var/mob/living/M as mob)
	M.adjustToxLoss(4)
datum/reagent/toxin/sparky
	name = "Electrostatic substance"
	id = "sparky"
	description = "The lights glow nearby when this substance is around"
	color = "#A300B3"

datum/reagent/toxin/spark/on_mob_life(var/mob/living/M as mob)
	if(prob(10))
		M.adjustFireLoss(3)//extremely weak damage
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
		sparks.set_up(1, 1, src)
		sparks.start()
	if(prob(5))
		M.IgniteMob()
		M.adjust_fire_stacks(3)
		holder.remove_reagent(src.id, 5, safety = 1)
datum/reagent/toxin/dizinc
	name = "Diethyl zinc"
	id = "dizinc"
	description = "Definately dont spray this at the clown"
	color = "#000067"
datum/reagent/toxin/dizinc/on_mob_life(var/mob/living/M as mob)
	M.adjust_fire_stacks(6)
	M.IgniteMob()
	M.bodytemperature += 15 //it's getting HOT HOT HOT dunununu
	holder.remove_reagent(src.id, 5, safety = 1)
	return
datum/reagent/toxin/dizinc/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	M.adjust_fire_stacks(6)
	M.IgniteMob()
	holder.clear_reagents()
	return
datum/reagent/toxin/radgoop
	name = "Radioactive waste"
	id = "radgoop"
	description = "A filthy product left over from the production of nuclear materials"
	color = "#000067"

datum/reagent/toxin/radgoop/on_mob_life(var/mob/living/M as mob)
	if(prob(30))
		M.radiation ++
	return
datum/reagent/toxin/goop
	name = "Toxic goop"
	id = "goop"
	metabolization_rate = 20 * REAGENTS_METABOLISM
	description = "A filthy product left over from the production of poisons"
	color = "#A20067"
datum/reagent/toxin/goop/on_mob_life(var/mob/living/M as mob)
	if(prob(30))
		M.adjustToxLoss(2)
	return
datum/reagent/toxin/hexamine
	name = "Hexamine"
	id = "hexamine"
	description = "used in fuel production"
	color = "#000067"
datum/reagent/toxin/hexamine/on_mob_life(var/mob/living/M as mob)
	M.adjust_fire_stacks(3)//increases burn time
	holder.remove_reagent(src.id, 5, safety = 1)
	return
datum/reagent/toxin/hexamine/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	M.adjust_fire_stacks(10)//much more effective on the outside
	return
datum/reagent/toxin/oxyplas
	name = "Plasminate"
	id = "oxyplas"
	description = "Needs something extra."
	color = "#FF32A1"
datum/reagent/toxin/oxyplas/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	M.adjust_fire_stacks(20)//very effective
	return
datum/reagent/toxin/oxyplas/on_mob_life(var/mob/living/M as mob)
	M.adjust_fire_stacks(3)//increases burn time
	holder.remove_reagent(src.id, 5, safety = 1)
	return
datum/reagent/toxin/proto
	name = "Protomatised plasma"
	id = "proto"
	description = "I really really wouldn't heat this."
	color = "#FF0000"
	var/point = 0

datum/reagent/toxin/proto/on_update()
	if(!holder)
		return
	if(holder.present_machines[1] <= 350)
		point = 0
		return
	point += 1
	fire_ball(get_turf(holder.my_atom),point)
	holder.remove_reagent(src.id, 15, safety = 1)
datum/reagent/toxin/proto/on_mob_life(var/mob/living/carbon/M as mob)
	fire_ball(get_turf(holder.my_atom),point)
	holder.remove_reagent(src.id, 15, safety = 1)
	point += 1
datum/reagent/toxin/gib
	name = "Liquid gibs"
	id = "gib"
	description = "This does not smell very nice."
	color = "#FF1111"
datum/reagent/toxin/gib/on_mob_life(var/mob/living/carbon/M as mob)
	if(prob(10))
		new /obj/effect/gibspawner/generic(get_turf(holder.my_atom),null,M.dna)
		holder.remove_reagent(src.id,10,safety = 1)
datum/reagent/toxin/impalco
	name = "Impure Superhol"
	id = "impalco"
	description = "Looks like this will just taste like water!"
	color = "#CAD15A"
datum/reagent/toxin/alco
	name = "Superhol"
	id = "alco"
	description = "I'm wasted man!"
	color = "#CAD15A"
datum/reagent/toxin/alco/on_mob_life(var/mob/living/carbon/M as mob)
	if(!data)
		data = 1
	if(prob(15))
		if(data >= 5)
			M.Dizzy(2)
			M.confused += 1
		if(data >= 25 && data< 50)
			M.adjustBrainLoss(3)
			M.confused += 5
			M.Dizzy(5)
			M.visible_message("<span class='danger'>[M.name] vomits!</span>")
			playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
			var/turf/location = M.loc
			if(istype(location, /turf/simulated))
				location.add_vomit_floor(M)
				M.nutrition -= 95
		if(data >= 50)
			M.take_organ_damage(15)
			M.adjustBrainLoss(5)
			M.visible_message("<span class='danger'>[M.name] projectile vomits everywhere!</span>")
			var/turf/location = M.loc
			for(var/turf/T in trange(1,location))
				location.add_vomit_floor(M)
				if(prob(15))
					var/obj/effect/decal/cleanable/blood/gibs/gib = pick(/obj/effect/decal/cleanable/blood/gibs/body,/obj/effect/decal/cleanable/blood/gibs/core,/obj/effect/decal/cleanable/blood/gibs)
					new gib(T.loc)
	holder.remove_reagent(src.id,2)
datum/reagent/toxin/bear
	name = "Bearium"
	id = "bear"
	description = "If you like puns and gibbed monkeys you will like this."
	color = "#CAD15A"
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
datum/reagent/toxin/bear/on_mob_life(var/mob/living/carbon/M as mob)
	if(!data)
		data = 1
	if(data >= 5)
		if(prob(25))
			M.visible_message("<span class='danger'>[M.name] growls strangely.</span>")
	if(data >= 15)
		if(prob(15))
			M.emote(pick("twitch","blink_r","scream"))
			M.adjustBrainLoss(2)
	if(data >= 25)
		if(prob(15))
			M.visible_message("<span class='danger'>[M.name] vomits!</span>")
			playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
			var/turf/location = M.loc
			if(istype(location, /turf/simulated))
				location.add_vomit_floor(M)
				M.nutrition -= 95
	if(data >= 40)
		if(prob(25))
			M.visible_message("<span class='danger'>[M.name] projectile vomits everywhere!</span>")
			var/turf/location = M.loc
			M.adjustBruteLoss(10)
			M.adjustBrainLoss(10)//this gets much more serious
			for(var/turf/T in trange(1,location))
				if(istype(location, /turf/simulated))
					T.add_vomit_floor(M)
					if(prob(15))
						var/obj/effect/decal/cleanable/blood/gibs/gib = pick(/obj/effect/decal/cleanable/blood/gibs/body,/obj/effect/decal/cleanable/blood/gibs/core,/obj/effect/decal/cleanable/blood/gibs)
						new gib(T)
	if(data >= 50)
		if(prob(25))
			M.visible_message("<span class='danger'>[M.name] explodes in a shower of gibs leaving a space bear!</span>")
			var/mob/living/simple_animal/hostile/bear/bear = /mob/living/simple_animal/hostile/bear
			new bear(M.loc)
			M.gib()
	data++
	
datum/reagent/toxin/methphos
	name = "Methylphosphonyl difluoride"
	id = "methphos"
	description = "Maybe you could make something really really toxic out of this?"
	color = "#C8A5DC"
datum/reagent/toxin/isopropyl
	name = "Isopropyl alcohol"
	id = "isoprop"
	description = "Can make you sick and drunk at the same time. Amazing!"
	color = "#C8A5DC"
datum/reagent/toxin/sarin_a
	name = "Translucent mixture"
	id = "sarina"
	description = "This mixture has a very light white hint to it but is filled with impurities"
	color = "#AAAACB"
	toxpwr = 0.1
datum/reagent/toxin/sarin_a/on_mob_life(var/mob/living/M as mob)
	if(!data)
		data = 1
	M.adjustToxLoss(0.1 * REM)
	M.eye_blurry = max(M.eye_blurry, 1)
	if(data % 15 == 0)
		M.visible_message("<span class='danger'>[M.name] throws up!</span>", \
		"<span class='userdanger'>[M.name] throws up!</span>")
		playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
		var/turf/location = M.loc
		if(istype(location, /turf/simulated))
			location.add_vomit_floor(M)
		M.nutrition -= 95
datum/reagent/toxin/sarin_b
	name = "Extremely dilute sarin"
	id = "sarinb"
	description = "A very impure form of sarin"
	color = "#CCCCCC"
	toxpwr = 0.8
datum/reagent/toxin/sarin_B/on_mob_life(var/mob/living/M as mob)
	if(!data)
		data = 1
	M.adjustToxLoss(0.3 * REM)
	M.eye_blurry = max(M.eye_blurry, 5)
	if(data % 10 == 0)
		M.visible_message("<span class='danger'>[M] throws up!</span>", \
		"<span class='userdanger'>[M] throws up!</span>")
		playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
		var/turf/location = M.loc
		if(istype(location, /turf/simulated))
			location.add_vomit_floor(M)
		M.nutrition -= 95

datum/reagent/toxin/sarin //will kill very very quickly unless atropine is given
	name = "Sarin"
	id = "sarin"
	description = "Possibly the most toxic substance known to man"
	color = "#FFFFFF"
	toxpwr = 12
	metabolization_rate = 3 * REAGENTS_METABOLISM//same as tabun but with a much higher damage
datum/reagent/toxin/sarin/on_mob_life(var/mob/living/M as mob)
	if(!data) data = 1

	switch(data)
		if(1 to 12)
			M.adjustToxLoss(5* REM)
		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
			M.adjustToxLoss(7* REM)
			if(data % 5 == 0)
				M.visible_message("<span class='danger'>[M.name] throws up!</span>", \
				"<span class='userdanger'>[M.name] throws up!</span>")
				playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
				var/turf/location = M.loc
				if(istype(location, /turf/simulated))
					location.add_vomit_floor(M)
				M.nutrition -= 95
		if(15 to 25)
			M.Paralyse(2)
			M.drowsyness  = max(M.drowsyness, 20)
			M.adjustToxLoss(9* REM)
		if(25 to INFINITY)
			M.Paralyse(20)
			M.drowsyness  = max(M.drowsyness, 30)
			M.adjustToxLoss(12* REM)
	data++
	..()
	return

datum/reagent/toxin/tabun_pa
	name = "Dimethlymine"
	id = "tabuna"
	description = "A chemical that is used in the manufacturing of narcotics"
	color = "#CF3600" // rgb: 207, 54, 0
datum/reagent/toxin/tabun_pb
	name = "phosphoryll"
	id = "tabunb"
	description = "Hmm looks just like water"
	color = "#801E28"

datum/reagent/toxin/tabun_pc
	name = "Noxious mixture"
	id = "tabunc"
	description = "A bubbling mixture"
	color = "#CF3600" // rgb: 207, 54, 0
datum/reagent/toxin/tabun
	name = "Tabun"
	id = "tabun"
	description = "Made by your friendly neighbourhood nazis!"
	color = "#003333"
	toxpwr = 5
	metabolization_rate = 3 * REAGENTS_METABOLISM 

datum/reagent/toxin/tabun/on_mob_life(var/mob/living/M as mob)
	M.adjustToxLoss(7*REM)//This stuff is crazily powerful
	M.adjustBrainLoss(15)
	..()
	return
datum/reagent/toxin/icyanide
	name = "Impure cyanide"
	id = "icyanide"
	description = "The very impure form of cyanide"
	color = "#CF36AC" // rgb: 207, 54, 0
	toxpwr = 0.2
datum/reagent/toxin/icyanide/on_mob_life(var/mob/living/M as mob)
	M.adjustOxyLoss(0.1*REM)//much weaker than proper cyanide
	..()
	return

datum/reagent/toxin/cyanide
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 3

datum/reagent/toxin/cyanide/on_mob_life(var/mob/living/M as mob)
	M.adjustOxyLoss(3*REM)
	M.sleeping += 1
	..()
	return

datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

datum/reagent/toxin/minttoxin/on_mob_life(var/mob/living/M as mob)
	if (FAT in M.mutations)
		M.gib()
	..()
	return

datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded spess carp."
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

datum/reagent/toxin/zombiepowder/on_mob_life(var/mob/living/carbon/M as mob)
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.5*REM)
	M.Weaken(5)
	M.silent = max(M.silent, 5)
	M.tod = worldtime2text()
	..()
	return

datum/reagent/toxin/zombiepowder/Del()
	if(holder && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	..()

datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen. Not a thing to be messed with."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0

datum/reagent/toxin/mindbreaker/on_mob_life(var/mob/living/M)
	M.hallucination += 10
	..()
	return

datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

datum/reagent/toxin/plantbgone/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/structure/alien/weeds/))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15,35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O,/obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O,/obj/effect/spacevine))
		var/obj/effect/spacevine/SV = O
		SV.on_chem_effect(src)

datum/reagent/toxin/plantbgone/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	src = null
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			C.adjustToxLoss(2) // 4 toxic damage per application, doubled for some reason

datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	description = "A harmful toxic mixture to kill weeds. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75


datum/reagent/toxin/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	description = "A harmful toxic mixture to kill pests. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1

datum/reagent/toxin/pestkiller/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	src = null
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			C.adjustToxLoss(2) // 4 toxic damage per application, doubled for some reason

datum/reagent/toxin/stoxin
	name = "Sleep Toxin"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	color = "#E895CC" // rgb: 232, 149, 204
	toxpwr = 0

datum/reagent/toxin/stoxin/on_mob_life(var/mob/living/M as mob)
	if(!data) data = 1
	switch(data)
		if(1 to 12)
			if(prob(5))	M.emote("yawn")
		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 25)
			M.drowsyness  = max(M.drowsyness, 20)
		if(25 to INFINITY)
			M.Paralyse(20)
			M.drowsyness  = max(M.drowsyness, 30)
	data++
	..()
	return


datum/reagent/toxin/spore
	name = "Spore Toxin"
	id = "spore"
	description = "A toxic spore cloud which blocks vision when ingested."
	color = "#9ACD32"
	toxpwr = 0.5

datum/reagent/toxin/spore/on_mob_life(var/mob/living/M as mob)
	M.damageoverlaytemp = 60
	M.eye_blurry = max(M.eye_blurry, 3)
	..()
	return


datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin"
	id = "spore_burning"
	description = "A burning spore cloud."
	color = "#9ACD32"
	toxpwr = 0.5

datum/reagent/toxin/spore_burning/on_mob_life(var/mob/living/M as mob)
	..()
	M.adjust_fire_stacks(2)
	M.IgniteMob()

datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/toxin/chloralhydrate/on_mob_life(var/mob/living/M as mob)
	if(!data)
		data = 1
	data++
	switch(data)
		if(1 to 10)
			M.confused += 2
			M.drowsyness += 2
		if(10 to 75)
			M.sleeping += 1
		if(76 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss(max((data - 75)*0.2, 20)) //Nerfed as fuck. 200 toxloss from 15 units is a little overboard.
			//Chloral shouldn't be the most powerful poison in the game when it's so easy to make.
			// M << "[(data - 75)*0.2] [REM]" //Did I seriously forget to remove debug text aaaa
	..()
	return

datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/toxin/beer2/on_mob_life(var/mob/living/M as mob)
	if(!data)
		data = 1
	switch(data)
		if(1 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((data - 50)*REM)
	data++
	..()
	return



//ACID


datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A strong mineral acid with the molecular formula H2SO4."
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour

datum/reagent/toxin/acid/reaction_mob(var/mob/living/carbon/C, var/method=TOUCH, var/volume)
	if(!istype(C))
		return
	if(method != TOUCH)
		if(!C.unacidable)
			C.take_organ_damage(min(4*toxpwr, volume * toxpwr))
			return

	C.acid_act(acidpwr, toxpwr, volume)

datum/reagent/toxin/acid/reaction_obj(var/obj/O, var/volume)
	if(istype(O.loc, /mob)) //handled in human acid_act()
		return
	O.acid_act(acidpwr, toxpwr, volume)

datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	acidpwr = 20

datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	id = "coffeepowder"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5

datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	id = "teapowder"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.5

datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin"
	id = "mutetoxin"
	description = "A toxin that temporarily paralyzes the vocal cords."
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0

datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/M)
	M.silent += REM + 1 //If this var is increased by one or less, it will have no effect since silent is decreased right after reagents are handled in Life(). Hence the + 1.
	..()

datum/reagent/toxin/staminatoxin
	name = "Tirizene"
	id = "tirizene"
	description = "A toxin that affects the stamina of a person when injected into the bloodstream."
	color = "#6E2828"
	data = 13
	toxpwr = 0

datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/M)
	M.adjustStaminaLoss(REM * data)
	data = max(data - 1, 3)
	..()
datum/proc/fire_ball(turf/source,var/size = 1)
	for(var/turf/T in trange(size,source))
		new/obj/effect/hotspot(T)
	for(var/mob/living/M in range(size,source))
		M.adjust_fire_stacks(2)


// Undefine the alias for REAGENTS_EFFECT_MULTIPLER
#undef REM
