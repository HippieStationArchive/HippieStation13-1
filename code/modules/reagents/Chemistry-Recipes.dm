///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/bi_product = null
	var/list/required_reagents = new/list()
	var/list/required_catalysts = new/list()

	// Both of these variables are mostly going to be used with slime cores - but if you want to, you can use them for other things
	var/atom/required_container = null // the container required for the reaction to happen
	var/required_other = 0 // an integer required for the reaction to happen

	var/result_amount = 0
	var/bi_amount = 0
	var/secondary = 0 // set to nonzero if secondary reaction
	var/mob_react = 1 //Determines if a chemical reaction can occur inside a mob
	var/list/required_machines = list(-1,-1,-1,-1,-1)// distillation , centrifuge , pressurized reaction chamber , bluespace particle reactor and radiation inducement chamber
	var/final_temp = 270
	var/heat_up_give = 20//basically the temperature can be anywhere from the reaction temperature to the reaction temperature + heat_up_give
	var/overheat_reaction = 0//should the gas smoke into a frothy nigthmare? Maybe.

/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume)
	return

	//I recommend you set the result amount to the total volume of all components.

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	id = "explosion_potassium"
	result = null
	required_reagents = list("water" = 1, "potassium" = 1)
	result_amount = 2
/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), location, 0, 0)
	e.start()
	holder.clear_reagents()
	return

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()
	return
/*
silicate
	name = "Silicate"
	id = "silicate"
	result = "silicate"
	required_reagents = list("aluminium" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 3
*/
/datum/chemical_reaction/stoxin
	name = "Sleep Toxin"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list("chloralhydrate" = 1, "sugar" = 4)
	result_amount = 5

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("ethanol" = 1, "anti_toxin" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	result = "inaprovaline"
	required_reagents = list("oxygen" = 1, "carbon" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/anti_toxin
	name = "Anti-Toxin (Dylovene)"
	id = "anti_toxin"
	result = "anti_toxin"
	required_reagents = list("silicon" = 1, "potassium" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3
//lcass chems , my maniacal nightmare
/datum/chemical_reaction/meth
	name = "Methamphetamine"
	id = "meth"
	result = "meth"
	required_catalysts = list("aluminium" = 5)
	required_reagents = list("tabuna" = 3, "ethanol" = 5,"ammonia" = 2)
	required_machines = list(420,-1,8,-1,-1)
	overheat_reaction = 1
	final_temp = 20
	heat_up_give = 1
	bi_amount = 2
	bi_product = "goop"
	result_amount = 8
/datum/chemical_reaction/superzine
	name = "Superzine"
	id = "Superzine"
	result = "Superzine"
	required_catalysts = list("mutagen" = 5)
	required_reagents = list("meth" = 2, "hexamine" = 2,"ethanol" = 2)
	required_machines = list(500,-1,78,-1,-1)
	overheat_reaction = 1
	final_temp = 120
	heat_up_give = 1
	bi_amount = 2
	bi_product = "dizinc"//if you over react set the entire room on fire, if you do it properly have a nice reward
	result_amount = 4
/datum/chemical_reaction/gib
	name = "Liquid gibs"
	id = "gib"
	result = "gib"
	required_reagents = list("water" = 2, "blood" = 2,"plasma" = 2)
	required_machines = list(350,-1,-1,-1,-1)
	overheat_reaction = 1
	final_temp = 320
	heat_up_give = 1
	bi_amount = 2
	bi_product = "blood"//if you over react set the entire room on fire, if you do it properly have a nice reward
	result_amount = 4
/datum/chemical_reaction/gib_splode
	name = "Liquid gibs explosion!"
	id = "gib_splode"
	result = null
	required_reagents = list("gib" = 1)
	required_machines = list(-1,1,-1,-1,-1)
/datum/chemical_reaction/gib_splode/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/size = 1
	if(created_volume >= 50)
		size = 3
	else if(created_volume >= 25)
		size = 2
	else
		size = 1
	for(var/turf/T in trange(size,get_turf(holder.my_atom)))
		var/obj/effect/decal/cleanable/blood/gibs/gib = pick(/obj/effect/decal/cleanable/blood/gibs/up,\
					/obj/effect/decal/cleanable/blood/gibs/down,\
					/obj/effect/decal/cleanable/blood/gibs,\
					/obj/effect/decal/cleanable/blood/gibs,\
					/obj/effect/decal/cleanable/blood/gibs/body,\
					/obj/effect/decal/cleanable/blood/gibs/limb,\
					/obj/effect/decal/cleanable/blood/gibs/core)
		new gib(T)
	holder.clear_reagents()
/datum/chemical_reaction/oxyplas
	name = "Plasminate"
	id = "oxyplas"
	result = "oxyplas"
	required_catalysts = list("iron" = 2)
	required_reagents = list("plasma" = 5, "water" = 3)
	required_machines = list(340,-1,-1,-1,-1)
	overheat_reaction = 1
	heat_up_give = 1
	bi_amount = 4
	bi_product = "hydrogen"//if you over react set the entire room on fire, if you do it properly have a nice reward
	result_amount = 4
/datum/chemical_reaction/proto
	name = "Protomatised Plasma"
	id = "proto"
	result = "proto"
	required_reagents = list("oxyplas" = 2, "hexamine" = 3)
	required_machines = list(320,-1,-1,20,-1)
	overheat_reaction = 1
	heat_up_give = 10
	bi_amount = 6
	bi_product = "radgoop"//if you over react set the entire room on fire, if you do it properly have a nice reward
	result_amount = 2
/datum/chemical_reaction/hexamine
	name = "Hexamine"
	id = "hexamine"
	result = "hexamine"
	required_catalysts = list("iron" = 3)
	required_reagents = list("ammonia" = 2, "carbon" = 3)
	required_machines = list(230,-1,35,-1,-1)
	heat_up_give = 10
	overheat_reaction = 1
	result_amount = 5
/datum/chemical_reaction/carbonf
	name = "Carbonic fluoride"
	id = "carbonf"
	result = "carbonf"
	required_reagents = list("ethanol" = 3, "fluorine" = 4)
	required_machines = list(320,-1,-1,-1,-1)
	bi_amount = 3
	bi_product = "oxygen"
	result_amount = 4
/datum/chemical_reaction/aluminiumf
	name = "Aluminium fluorate"
	id = "aluminiumf"
	result = "aluminiumf"
	required_reagents = list("carbonf" = 1, "oxygen" = 2,"aluminium" = 1)
	required_machines = list(230,-1,25,-1,-1)//makes use of two machines
	result_amount = 3
/datum/chemical_reaction/sodiumf
	name = "Sodium fluoride"
	id = "sodiumf"
	result = "sodiumf"
	required_reagents = list("carbonf" = 3, "sodium" = 4)
	required_machines = list(470,-1,-1,-1,-1)
	bi_amount = 3
	bi_product = "goop" //all that sodium waste has to go somewhere
	result_amount = 4
/datum/chemical_reaction/virogone
	name = "Cyclo-bromazine"
	id = "virogone"
	result = "virogone"
	required_reagents = list("aluminiumf" = 2, "sodiumf" = 3)
	required_machines = list(-1,-1,76,-1,-1)
	bi_amount = 3
	bi_product = "mutagen"//make sure you filter it
	result_amount = 1
/datum/chemical_reaction/atropine
	name = "Atropine"
	id = "atropine"
	result = "atropine"
	required_reagents = list("water" = 2, "carbon" = 5, "nitrogen" = 3)
	required_machines = list(-1,1,-1,-1,-1)
	bi_amount = 2
	bi_product = "toxin"
	result_amount = 3
/datum/chemical_reaction/sparky
	name = "Electrostatic substance"
	id = "sparky"
	result = "sparky"
	required_reagents = list("uranium" = 2, "carbon" = 2)
	required_machines = list(-1,-1,-1,6,-1)//needs the radio combobulator thing
	bi_amount = 2
	bi_product = "radgoop"
	result_amount = 5
/datum/chemical_reaction/impvolt
	name = "Translucent mixture"
	id = "impvolt"
	result = "impvolt"
	required_reagents = list("sparky" = 2, "emit" = 2)
	required_machines = list(290,-1,-1,-1,15)
	bi_amount = 1
	overheat_reaction = 1
	bi_product = "emit_on"//dangerous to make
	result_amount = 3
/datum/chemical_reaction/volt
	name = "Sparking mixture"
	id = "volt"
	result = "volt"
	required_reagents = list("impvolt" = 1, "methphos" = 2)
	required_machines = list(250,1,-1,-1,-1)
	bi_amount = 1
	overheat_reaction = 1
	bi_product = "dizinc"//dont overheat this shizzle , you will set the entire lab crew on fire!
	result_amount = 2
/datum/chemical_reaction/emit
	name = "Emittrium"
	id = "emit"
	result = "emit"
	required_reagents = list("uranium" = 1 , "sparky" = 2 , "oxyplas" = 2)
	required_machines = list(-1,-1,-1,-1,6)//oh boy is this nasty
	bi_amount = 1
	bi_product = "radium"
	result_amount = 4
/datum/chemical_reaction/emit_on
	name = "Emittrium_on"
	id = "emit_on"
	result = "emit_on"
	required_reagents = list("emit" = 1)
	required_machines = list(320,-1,-1,-1,-1)//oh boy is this nasty
	result_amount = 1
	overheat_reaction = 1
	heat_up_give = 400
/datum/chemical_reaction/defib
	name = "Exstatic mixture"
	id = "defib"
	result = "defib"
	required_reagents = list("sparky" = 2, "carbonf" = 2,"virogone" = 2)
	required_machines = list(-1,-1,70,-1,-1)//need a lot of pressure to cram all this gunk into a molecule
	result_amount = 4
/datum/chemical_reaction/life
	name = "Liquid life"
	id = "life"
	result = "life"
	required_reagents = list("Superzine" = 1, "virogone" = 1,"carbonf" = 1)
	required_machines = list(-1,-1,-1,-1,25)//oh boy is this nasty
	bi_amount = 1
	bi_product = "methphos"
	result_amount = 2
/datum/chemical_reaction/aus
	name = "Ausium"
	id = "aus"
	result = "aus"
	required_reagents = list("space_drugs" = 5, "ethanol" = 3,"lithium" = 2)
	required_machines = list(430,1,-1,-1,-1)
	result_amount = 5
/datum/chemical_reaction/impalco
	name = "Impure Superhol"
	id = "impalco"
	result = "impalco"
	required_reagents = list("ausium" = 2, "ethanol" = 3,"meth" = 2)
	required_machines = list(290,-1,5,-1,-1)
	result_amount = 5
/datum/chemical_reaction/alco
	name = "Superhol"
	id = "alco"
	result = "alco"
	required_reagents = list("impalco" = 4, "ethanol" = 3 , "isoprop" = 3)
	required_machines = list(-1,1,-1,-1,-1)
	bi_product = "ethanol"
	bi_amount = 3
	result_amount = 6
/datum/chemical_reaction/cryo
	name = "Cryonium"
	id = "cryo"
	result = "cryo"
	required_reagents = list("ammonia" = 3, "isoprop" = 2)
	required_machines = list(-1,-1,-1,-1,-1)
	overheat_reaction = 1
	heat_up_give = 40
	final_temp = 500
	result_amount = 5
/datum/chemical_reaction/pyro
	name = "Pyronium"
	id = "pyro"
	result = "pyro"
	required_reagents = list("plasma" = 3, "hexamine" = 2)
	required_machines = list(-1,-1,-1,-1,-1)
	overheat_reaction = 1
	heat_up_give = 1
	final_temp = 0
	result_amount = 5
/datum/chemical_reaction/dizinc
	name = "Diethyl Mercury"
	id = "dizinc"
	result = "dizinc"
	required_reagents = list("mercury" = 1, "ethanol" = 2,"hexamine" = 2)
	required_machines = list(290,-1,-1,-1,-1)
	overheat_reaction = 1
	result_amount = 3
/datum/chemical_reaction/dizincboom//milder explosion now
	name = "Moderate explosion"
	id = "dizincboom"
	result = null
	required_reagents = list("dizinc" = 1, "oxygen" = 1)//no other conditions required , it's that volatile
	result_amount = 1
/datum/chemical_reaction/dizincboom/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	explosion(location,0,round(created_volume/25,1),round(created_volume/20,1))
	holder.clear_reagents()
	return
/datum/chemical_reaction/sboom
	name = "Nitrogenated isopropyl alcohol"
	id = "sboom"
	result = "sboom"
	required_reagents = list("isoprop" = 1, "nitrogen" = 6,"carbon" = 3)
	required_machines = list(290,-1,35,-1,-1)
	required_catalysts = list("goop" = 1)
	final_temp = 100
	bi_amount = 5
	bi_product = "tabuna"
	result_amount = 5
/datum/chemical_reaction/superboom//the reaction is more difficult considering this can gib people
	name = "N-amino azidotetrazole"
	id = "superboom"
	result = "superboom"
	required_reagents = list("sboom" = 3, "ammonia" = 3,"dizinc" = 2)
	required_machines = list(280,-1,-1,15,-1)
	required_catalysts = list("tabunb" = 1)
	heat_up_give = 5
	final_temp = 100
	bi_amount = 3
	bi_product = "hydrogen"
	overheat_reaction = 1
	result_amount = 5
/datum/chemical_reaction/emote
	name = "Emotium"
	id = "emote"
	result = "emote"
	required_reagents = list("hyperzine" = 1, "sugar" = 2,"ammonia" = 1)
	required_machines = list(-1,1,-1,-1,-1)//oh boy is this nasty
	required_catalysts = list("ethanol" = 1)
	result_amount = 4
/datum/chemical_reaction/bear
	name = "Bearium"
	id = "bear"
	result = "bear"
	required_reagents = list("life" = 2, "volt" = 3,"meth" = 1)
	required_machines = list(460,-1,-1,-1,20)
	overheat_reaction = 1
	heat_up_give = 1
	final_temp = 350
	bi_amount = 2
	bi_product = "radgoop"
	result_amount = 4
/datum/chemical_reaction/fart
	name = "Fartium"
	id = "fart"
	result = "fart"
	required_reagents = list("Superzine" = 1, "emote" = 2,"meth" = 1)
	required_machines = list(370,-1,-1,25,-1)//oh boy is this nasty
	required_catalysts = list("defib" = 1)
	result_amount = 4

/datum/chemical_reaction/methphos
	name = "Methylphosphonyl difluoride"
	id = "methphos"
	result = "methphos"
	required_machines = list(-1,-1,26,-1,-1)
	required_reagents = list("hydrogen" = 3, "carbon" = 1, "phosphorus" = 1 , "oxygen" = 1, "fluorine" = 2)
	result_amount = 2
/datum/chemical_reaction/isoprop
	name = "Isopropyl alcohol"
	id = "isoprop"
	result = "isoprop"
	required_catalysts = list("aluminium" = 2)
	required_reagents = list("water" = 6, "carbon" = 3)
	result_amount = 5
/datum/chemical_reaction/sarin_a
	name = "Translucent mixture"
	id = "sarina"
	result = "sarina"
	required_reagents = list("isoprop" = 3, "methphos" = 2)
	result_amount = 3
/datum/chemical_reaction/sarin_b
	name = "Extremely dilute sarin"
	id = "sarinb"
	result = "sarinb"
	required_machines = list(300,-1,-1,-1,-1)
	heat_up_give = 0 //yer this is what makes it difficult to discover
	required_reagents = list("sarina" = 2)
	result_amount = 1
/datum/chemical_reaction/sarin
	name = "Sarin"
	id = "sarin"
	result = "sarin"
	overheat_reaction = 1 //hehehe quickest way to get killed as a lunatic chemist
	required_machines = list(-1,1,-1,-1,-1)
	required_reagents = list("sarinb" = 5) 
	result_amount = 3

/datum/chemical_reaction/impure_cyanide
	name = "Impure Cyanide"
	id = "icyanide"
	result = "icyanide"
	required_reagents = list("hydrogen" = 2, "carbon" = 2, "nitrogen" = 2)
	result_amount = 1

/datum/chemical_reaction/tabun_pa
	name = "Dimethlymine"
	id = "tabuna"
	result = "tabuna"
	required_machines = list(420,-1,-1,-1,-1)
	required_reagents = list("sodium" = 1,"water" = 3 ,"carbon" = 2, "nitrogen" = 1)
	bi_amount = 2
	bi_product = "oxygen"//from the water
	result_amount = 3
/datum/chemical_reaction/tabun_pb
	name = "Phosphoryll"
	id = "tabunb"
	result = "tabunb"
	required_reagents = list("chlorine" = 3,"phosphorus" = 1, "oxygen" = 1)
	result_amount = 1
/datum/chemical_reaction/tabun_pc
	name = "Noxious mixture"
	id = "tabunc"
	result = "tabunc"
	required_reagents = list("tabunb" = 2,"tabuna" = 1 )
	result_amount = 1
/datum/chemical_reaction/tabun
	name = "Tabun"
	id = "tabun"
	result = "tabun"
	required_machines = list(-1,1,-1,-1,-1)
	required_reagents = list("tabunc" = 3)
	result_amount = 1
	bi_amount = 5
	bi_product = "goop"
	result_amount = 5
/datum/chemical_reaction/cyanide
	name = "Cyanide"
	id = "cyanide"
	result = "cyanide"
	bi_product = "goop"
	required_machines = list(-1,1,-1,-1,-1)
	bi_amount = 5
	required_reagents = list("icyanide" = 10)
	result_amount = 5
//end of lcass' maniacal nightmare
/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminium" = 1, "iron" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = "lexorin"
	required_reagents = list("plasma" = 1, "hydrogen" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = "pacid"
	required_reagents = list("sacid" = 1, "chlorine" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = "synaptizine"
	required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	result = "hyronalin"
	required_reagents = list("radium" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	result = "arithrazine"
	required_reagents = list("hyronalin" = 1, "hydrogen" = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	result = "kelotane"
	required_reagents = list("silicon" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	result = "leporazine"
	required_reagents = list("silicon" = 1, "copper" = 1)
	required_catalysts = list("plasma" = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = "tricordrazine"
	required_reagents = list("inaprovaline" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	id = "alkysine"
	result = "alkysine"
	required_reagents = list("chlorine" = 1, "nitrogen" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	id = "dexalin"
	result = "dexalin"
	required_reagents = list("oxygen" = 2)
	required_catalysts = list("plasma" = 5)
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	id = "dermaline"
	result = "dermaline"
	required_reagents = list("oxygen" = 1, "phosphorus" = 1, "kelotane" = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	result = "dexalinp"
	required_reagents = list("dexalin" = 1, "carbon" = 1, "iron" = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	result = "bicaridine"
	required_reagents = list("inaprovaline" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	result = "hyperzine"
	required_reagents = list("sugar" = 1, "phosphorus" = 1, "sulfur" = 1,)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	result = "ryetalyn"
	required_reagents = list("arithrazine" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	result = "cryoxadone"
	required_reagents = list("dexalin" = 1, "water" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	result = "clonexadone"
	required_reagents = list("cryoxadone" = 1, "sodium" = 1)
	required_catalysts = list("plasma" = 5)
	result_amount = 2

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	result = "spaceacillin"
	required_reagents = list("cryptobiolin" = 1, "inaprovaline" = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "imidazoline"
	id = "imidazoline"
	result = "imidazoline"
	required_reagents = list("carbon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/inacusiate
	name = "inacusiate"
	id = "inacusiate"
	result = "inacusiate"
	required_reagents = list("water" = 1, "carbon" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	result = "ethylredoxrazine"
	required_reagents = list("oxygen" = 1, "anti_toxin" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/ethanoloxidation
	name = "ethanoloxidation"	//Kind of a placeholder in case someone ever changes it so that chemicals
	id = "ethanoloxidation"		//	react in the body. Also it would be silly if it didn't exist.
	result = "water"
	required_reagents = list("ethylredoxrazine" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)
	result_amount = 2
/datum/chemical_reaction/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), location, 0, 0)
	e.start()

	holder.clear_reagents()
	return

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("sodium" = 1, "chlorine" = 1)
	result_amount = 2

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = null
	required_reagents = list("aluminium" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = null
/datum/chemical_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/C in get_hearers_in_view(5, location))
		if(C.eyecheck())
			continue
		flick("e_flash", C.flash)
		if(get_dist(C, location) < 4)
			C.Weaken(5)
			continue
		C.Stun(5)

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = null
	required_reagents = list("aluminium" = 1, "plasma" = 1, "sacid" = 1 )
	result_amount = 1
/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/simulated/T = get_turf(holder.my_atom)
	if(istype(T))
		T.atmos_spawn_air(SPAWN_HEAT | SPAWN_TOXINS, created_volume)
	holder.del_reagent(id)
	return

/*
/datum/chemical_reaction/smoke
	name = "Smoke"
	id = "smoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1 )
	result_amount = null
	secondary = 1
	on_reaction(var/datum/reagents/holder, var/created_volume)
		var/location = get_turf(holder.my_atom)
		var/datum/effect/system/bad_smoke_spread/S = new /datum/effect/system/bad_smoke_spread
		S.attach(location)
		S.set_up(10, 0, location)
		playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
		spawn(0)
			S.start()
			sleep(10)
			S.start()
			sleep(10)
			S.start()
			sleep(10)
			S.start()
			sleep(10)
			S.start()
		holder.clear_reagents()
		return	*/

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	id = "chemsmoke"
	result = null
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = null
	secondary = 1
	mob_react = 1

/datum/chemical_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/chem_smoke_spread/S = new /datum/effect/effect/system/chem_smoke_spread
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		if(S)
			S.set_up(holder, 10, 0, location)
			S.start()
			sleep(10)
			S.start()
		if(holder && holder.my_atom)
			holder.clear_reagents()
	return

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	result = "chloralhydrate"
	required_reagents = list("ethanol" = 1, "chlorine" = 3, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/mutetoxin //i'll just fit this in here snugly between other unfun chemicals :v
	name = "Mute toxin"
	id = "mutetoxin"
	result = "mutetoxin"
	required_reagents = list("uranium" = 2, "water" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = "zombiepowder"
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
	result_amount = 2

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	result = "rezadone"
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = "mindbreaker"
	required_reagents = list("silicon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 5

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	id = "Lipozine"
	result = "lipozine"
	required_reagents = list("sodiumchloride" = 1, "ethanol" = 1, "radium" = 1)
	result_amount = 3

/datum/chemical_reaction/plasmasolidification
	name = "Solid Plasma"
	id = "solidplasma"
	result = null
	required_reagents = list("iron" = 5, "frostoil" = 5, "plasma" = 20)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/plasmasolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/stack/sheet/mineral/plasma(location)
	return

/datum/chemical_reaction/capsaicincondensation
	name = "Capsaicincondensation"
	id = "capsaicincondensation"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 1, "ethanol" = 5)
	result_amount = 5

/datum/chemical_reaction/inspectionitisplacebo //Only allow fake Ass-X to be mixed
	name = "Ass-X"
	id = "inspectionitisplacebo"
	result = "inspectionitisplacebo"
	required_reagents = list("blood" = 1, "nutriment" = 1, "sulfur" = 1) //sulfur because IT SMELLS LIKE FARTS. HA!
	result_amount = 1

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	required_reagents = list("water" = 5, "milk" = 5)
	result_amount = 15

/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	result = "blood"
	required_reagents = list("virusfood" = 1)
	required_catalysts = list("blood" = 1)
	var/level_min = 0
	var/level_max = 2

/datum/chemical_reaction/mix_virus/on_reaction(var/datum/reagents/holder, var/created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level_min, level_max)


/datum/chemical_reaction/mix_virus/mix_virus_2

	name = "Mix Virus 2"
	id = "mixvirus2"
	required_reagents = list("mutagen" = 1)
	level_min = 2
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_3

	name = "Mix Virus 3"
	id = "mixvirus3"
	required_reagents = list("plasma" = 1)
	level_min = 4
	level_max = 6

/datum/chemical_reaction/mix_virus/rem_virus

	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list("synaptizine" = 1)
	required_catalysts = list("blood" = 1)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(var/datum/reagents/holder, var/created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()



///////////////////////////////////////////////////////////////////////////////////

// foam and foam precursor

/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5


/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2
	mob_react = 1

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume)


	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution violently bubbles!</span>"

	location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution spews out foam!</span>"

	//world << "Holder volume is [holder.total_volume]"
	//for(var/datum/reagent/R in holder.reagent_list)
	//	world << "[R.name] = [R.volume]"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()
	return

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	result = null
	required_reagents = list("aluminium" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5
	mob_react = 1

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)


	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution spews out a metalic foam!</span>"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()
	return

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5
	mob_react = 1

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)


	var/location = get_turf(holder.my_atom)


	for(var/mob/M in viewers(5, location))
		M << "<span class='danger'>The solution spews out a metalic foam!</span>"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
	return



/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

// Synthesizing these three chemicals is pretty complex in real life, but fuck it, it's just a game!
/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

datum/chemical_reaction/weedkiller
	name = "Weed Killer"
	id = "weedkiller"
	result = "weedkiller"
	required_reagents = list("toxin" = 1, "ammonia" = 4)
	result_amount = 5

datum/chemical_reaction/pestkiller
	name = "Pest Killer"
	id = "pestkiller"
	result = "pestkiller"
	required_reagents = list("toxin" = 1, "ethanol" = 4)
	result_amount = 5

/////////////////////////////////////OLD SLIME CORE REACTIONS ///////////////////////////////
/*
/datum/chemical_reaction/slimepepper
	name = "Slime Condensedcapaicin"
	id = "m_condensedcapaicin"
	result = "condensedcapsaicin"
	required_reagents = list("sugar" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 1
/datum/chemical_reaction/slimefrost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = "frostoil"
	required_reagents = list("water" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 1
/datum/chemical_reaction/slimeglycerol
	name = "Slime Glycerol"
	id = "m_glycerol"
	result = "glycerol"
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 1

/datum/chemical_reaction/slime_explosion
	name = "Slime Explosion"
	id = "m_explosion"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 2
/datum/chemical_reaction/slime_explosion/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), location, 0, 0)
	e.start()

	holder.clear_reagents()
	return
/datum/chemical_reaction/slimejam
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("water" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 2
/datum/chemical_reaction/slimesynthi
	name = "Slime Synthetic Flesh"
	id = "m_flesh"
	result = null
	required_reagents = list("sugar" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 2
/datum/chemical_reaction/slimesynthi/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh(location)
	return

/datum/chemical_reaction/slimeenzyme
	name = "Slime Enzyme"
	id = "m_enzyme"
	result = "enzyme"
	required_reagents = list("blood" = 1, "water" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 3
/datum/chemical_reaction/slimeplasma
	name = "Slime Plasma"
	id = "m_plasma"
	result = "plasma"
	required_reagents = list("sugar" = 1, "blood" = 2)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 3
/datum/chemical_reaction/slimevirus
	name = "Slime Virus"
	id = "m_virus"
	result = null
	required_reagents = list("sugar" = 1, "sacid" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 3
/datum/chemical_reaction/slimevirus/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.clear_reagents()

	var/virus = pick(/datum/disease/advance/flu, /datum/disease/advance/cold, \
	 /datum/disease/pierrot_throat, /datum/disease/fake_gbs, \
	 /datum/disease/brainrot, /datum/disease/magnitis)


	var/datum/disease/F = new virus(0)
	var/list/data = list("viruses"= list(F))
	holder.add_reagent("blood", 20, data)

	holder.add_reagent("cyanide", rand(1,10))

	return

/datum/chemical_reaction/slimeteleport
	name = "Slime Teleport"
	id = "m_tele"
	result = null
	required_reagents = list("pacid" = 2, "mutagen" = 2)
	required_catalysts = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 4
/datum/chemical_reaction/slimeteleport/on_reaction(var/datum/reagents/holder, var/created_volume)

	// Calculate new position (searches through beacons in world)
	var/obj/item/device/radio/beacon/chosen
	var/list/possible = list()
	for(var/obj/item/device/radio/beacon/W in world)
		possible += W

	if(possible.len > 0)
		chosen = pick(possible)

	if(chosen)
	// Calculate previous position for transition

		var/turf/FROM = get_turf(holder.my_atom) // the turf of origin we're travelling FROM
		var/turf/TO = get_turf(chosen)			 // the turf of origin we're travelling TO

		playsound(TO, 'sound/effects/phasein.ogg', 100, 1)

		var/list/flashers = list()
		for(var/mob/living/carbon/human/M in viewers(TO, null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash) // flash dose faggots
				flashers += M

		var/y_distance = TO.y - FROM.y
		var/x_distance = TO.x - FROM.x
		for (var/atom/movable/A in range(2, FROM )) // iterate thru list of mobs in the area
			if(istype(A, /obj/item/device/radio/beacon)) continue // don't teleport beacons because that's just insanely stupid
			if( A.anchored && !istype(A, /mob/dead/observer) ) continue // don't teleport anchored things (computers, tables, windows, grilles, etc) because this causes problems!
			// do teleport ghosts however because hell why not

			var/turf/newloc = locate(A.x + x_distance, A.y + y_distance, TO.z) // calculate the new place
			if(!A.Move(newloc)) // if the atom, for some reason, can't move, FORCE them to move! :) We try Move() first to invoke any movement-related checks the atom needs to perform after moving
				A.loc = locate(A.x + x_distance, A.y + y_distance, TO.z)

			spawn()
				if(ismob(A) && !(A in flashers)) // don't flash if we're already doing an effect
					var/mob/M = A
					if(M.client)
						var/obj/blueeffect = new /obj(src)
						blueeffect.screen_loc = "WEST,SOUTH to EAST,NORTH"
						blueeffect.icon = 'icons/effects/effects.dmi'
						blueeffect.icon_state = "shieldsparkles"
						blueeffect.layer = 17
						blueeffect.mouse_opacity = 0
						M.client.screen += blueeffect
						sleep(20)
						M.client.screen -= blueeffect
						qdel(blueeffect)
/datum/chemical_reaction/slimecrit
	name = "Slime Crit"
	id = "m_tele"
	result = null
	required_reagents = list("sacid" = 1, "blood" = 1)
	required_catalysts = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 4
/datum/chemical_reaction/slimecrit/on_reaction(var/datum/reagents/holder, var/created_volume)

	var/blocked = list(/mob/living/simple_animal/hostile,
		/mob/living/simple_animal/hostile/pirate,
		/mob/living/simple_animal/hostile/pirate/ranged,
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/syndicate,
		/mob/living/simple_animal/hostile/syndicate/melee,
		/mob/living/simple_animal/hostile/syndicate/melee/space,
		/mob/living/simple_animal/hostile/syndicate/ranged,
		/mob/living/simple_animal/hostile/syndicate/ranged/space,
		/mob/living/simple_animal/hostile/alien/queen/large,
		/mob/living/simple_animal/clown
		)//exclusion list for things you don't want the reaction to create.
	var/list/critters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs

	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= created_volume, i++)
		var/chosen = pick(critters)
		var/mob/living/simple_animal/hostile/C = new chosen
		C.loc = get_turf(holder.my_atom)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))
/datum/chemical_reaction/slimebork
	name = "Slime Bork"
	id = "m_tele"
	result = null
	required_reagents = list("sugar" = 1, "water" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 4
/datum/chemical_reaction/slimebork/on_reaction(var/datum/reagents/holder, var/created_volume)

	var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks
	// BORK BORK BORK

	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= created_volume + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH,SOUTH,EAST,WEST))



/datum/chemical_reaction/slimechloral
	name = "Slime Chloral"
	id = "m_bunch"
	result = "chloralhydrate"
	required_reagents = list("blood" = 1, "water" = 2)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 5
/datum/chemical_reaction/slimeretro
	name = "Slime Retro"
	id = "m_xeno"
	result = null
	required_reagents = list("sugar" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 5
/datum/chemical_reaction/slimeretro/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/disease/F = new /datum/disease/dna_retrovirus(0)
	var/list/data = list("viruses"= list(F))
	holder.add_reagent("blood", 20, data)
/datum/chemical_reaction/slimefoam
	name = "Slime Foam"
	id = "m_foam"
	result = null
	required_reagents = list("sacid" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 5

/datum/chemical_reaction/slimefoam/on_reaction(var/datum/reagents/holder, var/created_volume)


	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		M << "\red The solution violently bubbles!"

	location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "\red The solution spews out foam!"

	//world << "Holder volume is [holder.total_volume]"
	//for(var/datum/reagent/R in holder.reagent_list)
	//	world << "[R.name] = [R.volume]"

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()
	return
*/
/////////////////////////////////////////////NEW SLIME CORE REACTIONS/////////////////////////////////////////////

//Grey
/datum/chemical_reaction/slimespawn
	name = "Slime Spawn"
	id = "m_spawn"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/grey
	required_other = 1
/datum/chemical_reaction/slimespawn/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>Infused with plasma, the core begins to quiver and grow, and soon a new baby slime emerges from it!</span>"), 1)
	var/mob/living/carbon/slime/S = new /mob/living/carbon/slime
	S.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slimeinaprov
	name = "Slime Inaprovaline"
	id = "m_inaprov"
	result = "inaprovaline"
	required_reagents = list("water" = 5)
	result_amount = 3
	required_other = 1
	required_container = /obj/item/slime_extract/grey
/datum/chemical_reaction/slimeinaprov/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

/datum/chemical_reaction/slimemonkey
	name = "Slime Monkey"
	id = "m_monkey"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/grey
	required_other = 1
/datum/chemical_reaction/slimemonkey/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/i = 1, i <= 3, i++)
		var /obj/item/weapon/reagent_containers/food/snacks/monkeycube/M = new /obj/item/weapon/reagent_containers/food/snacks/monkeycube
		M.loc = get_turf(holder.my_atom)

//Green
/datum/chemical_reaction/slimemutate
	name = "Mutation Toxin"
	id = "mutationtoxin"
	result = "mutationtoxin"
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_other = 1
	required_container = /obj/item/slime_extract/green
/datum/chemical_reaction/slimemutate/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

//Metal
/datum/chemical_reaction/slimemetal
	name = "Slime Metal"
	id = "m_metal"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/metal
	required_other = 1
/datum/chemical_reaction/slimemetal/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/stack/sheet/metal/M = new /obj/item/stack/sheet/metal
	M.amount = 15
	M.loc = get_turf(holder.my_atom)
	var/obj/item/stack/sheet/plasteel/P = new /obj/item/stack/sheet/plasteel
	P.amount = 5
	P.loc = get_turf(holder.my_atom)

//Gold
/datum/chemical_reaction/slimecrit
	name = "Slime Crit"
	id = "m_tele"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/gold
	required_other = 1
/datum/chemical_reaction/slimecrit/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>The slime extract begins to vibrate violently !</span>"), 1)
	spawn(50)

		if(holder && holder.my_atom)

			var/blocked = list(/mob/living/simple_animal/hostile,
				/mob/living/simple_animal/hostile/pirate,
				/mob/living/simple_animal/hostile/pirate/ranged,
				/mob/living/simple_animal/hostile/russian,
				/mob/living/simple_animal/hostile/russian/ranged,
				/mob/living/simple_animal/hostile/syndicate,
				/mob/living/simple_animal/hostile/syndicate/melee,
				/mob/living/simple_animal/hostile/syndicate/melee/space,
				/mob/living/simple_animal/hostile/syndicate/ranged,
				/mob/living/simple_animal/hostile/syndicate/ranged/space,
				/mob/living/simple_animal/hostile/alien/queen/large,
				/mob/living/simple_animal/hostile/retaliate,
				/mob/living/simple_animal/hostile/retaliate/clown,
				/mob/living/simple_animal/hostile/mushroom,
				/mob/living/simple_animal/hostile/asteroid,
				/mob/living/simple_animal/hostile/asteroid/basilisk,
				/mob/living/simple_animal/hostile/asteroid/goldgrub,
				/mob/living/simple_animal/hostile/asteroid/goliath,
				/mob/living/simple_animal/hostile/asteroid/hivelord,
				/mob/living/simple_animal/hostile/asteroid/hivelordbrood,
				/mob/living/simple_animal/hostile/carp/holocarp,
				/mob/living/simple_animal/hostile/mining_drone
				)//exclusion list for things you don't want the reaction to create.
			var/list/critters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs

			var/atom/A = holder.my_atom
			var/turf/T = get_turf(A)
			var/area/my_area = get_area(T)
			var/message = "A gold slime reaction has occured in [my_area.name]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</A>)"
			message += " (<A HREF='?_src_=vars;Vars=\ref[A]'>VV</A>)"

			var/mob/M = get(A, /mob)
			if(M)
				message += " - Carried By: [M.real_name] ([M.key]) (<A HREF='?_src_=holder;adminplayeropts=\ref[M]'>PP</A>) (<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>?</A>)"
			else
				message += " - Last Fingerprint: [(A.fingerprintslast ? A.fingerprintslast : "N/A")]"

			message_admins(message, 0, 1)

			playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

			for(var/mob/living/carbon/human/H in viewers(get_turf(holder.my_atom), null))
				if(H:eyecheck() <= 0)
					flick("e_flash", H.flash)

			for(var/i = 1, i <= 5, i++)
				var/chosen = pick(critters)
				var/mob/living/simple_animal/hostile/C = new chosen
				C.faction |= "slimesummon"
				C.loc = get_turf(holder.my_atom)
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(C, pick(NORTH,SOUTH,EAST,WEST))

/datum/chemical_reaction/slimecritlesser
	name = "Slime Crit Lesser"
	id = "m_tele3"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/gold
	required_other = 1
/datum/chemical_reaction/slimecritlesser/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>The slime extract begins to vibrate violently !</span>"), 1)
	spawn(50)

		if(holder && holder.my_atom)

			var/blocked = list(/mob/living/simple_animal/hostile,
				/mob/living/simple_animal/hostile/pirate,
				/mob/living/simple_animal/hostile/pirate/ranged,
				/mob/living/simple_animal/hostile/russian,
				/mob/living/simple_animal/hostile/russian/ranged,
				/mob/living/simple_animal/hostile/syndicate,
				/mob/living/simple_animal/hostile/syndicate/melee,
				/mob/living/simple_animal/hostile/syndicate/melee/space,
				/mob/living/simple_animal/hostile/syndicate/ranged,
				/mob/living/simple_animal/hostile/syndicate/ranged/space,
				/mob/living/simple_animal/hostile/alien/queen/large,
				/mob/living/simple_animal/hostile/retaliate,
				/mob/living/simple_animal/hostile/retaliate/clown,
				/mob/living/simple_animal/hostile/mushroom,
				/mob/living/simple_animal/hostile/asteroid,
				/mob/living/simple_animal/hostile/asteroid/basilisk,
				/mob/living/simple_animal/hostile/asteroid/goldgrub,
				/mob/living/simple_animal/hostile/asteroid/goliath,
				/mob/living/simple_animal/hostile/asteroid/hivelord,
				/mob/living/simple_animal/hostile/asteroid/hivelordbrood,
				/mob/living/simple_animal/hostile/carp/holocarp,
				/mob/living/simple_animal/hostile/mining_drone
				)//exclusion list for things you don't want the reaction to create.
			var/list/critters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs

			playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

			for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
				if(M:eyecheck() <= 0)
					flick("e_flash", M.flash)

			var/chosen = pick(critters)
			var/mob/living/simple_animal/hostile/C = new chosen
			C.faction |= "neutral"
			C.loc = get_turf(holder.my_atom)

//Silver
/datum/chemical_reaction/slimebork
	name = "Slime Bork"
	id = "m_tele2"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/silver
	required_other = 1
/datum/chemical_reaction/slimebork/on_reaction(var/datum/reagents/holder)

	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

	var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks
	// BORK BORK BORK

	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH,SOUTH,EAST,WEST))


/datum/chemical_reaction/slimebork2
	name = "Slime Bork 2"
	id = "m_tele4"
	result = null
	required_reagents = list("water" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/silver
	required_other = 1
/datum/chemical_reaction/slimebork2/on_reaction(var/datum/reagents/holder)

	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

	var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/drinks) - /obj/item/weapon/reagent_containers/food/drinks
	// BORK BORK BORK

	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH,SOUTH,EAST,WEST))


//Blue
/datum/chemical_reaction/slimefrost
	name = "Slime Frost Oil"
	id = "m_frostoil"
	result = "frostoil"
	required_reagents = list("plasma" = 1)
	result_amount = 10
	required_container = /obj/item/slime_extract/blue
	required_other = 1
/datum/chemical_reaction/slimefrost/on_reaction(var/datum/reagents/holder)
		feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

//Dark Blue
/datum/chemical_reaction/slimefreeze
	name = "Slime Freeze"
	id = "m_freeze"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/darkblue
	required_other = 1
/datum/chemical_reaction/slimefreeze/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>The slime extract begins to vibrate violently !</span>"), 1)
	spawn(50)
		if(holder && holder.my_atom)
			playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
			for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
				M.bodytemperature -= 240
				M << "<span class='notice'>You feel a chill!</span>"

//Orange
/datum/chemical_reaction/slimecasp
	name = "Slime Capsaicin Oil"
	id = "m_capsaicinoil"
	result = "capsaicin"
	required_reagents = list("blood" = 1)
	result_amount = 10
	required_container = /obj/item/slime_extract/orange
	required_other = 1
/datum/chemical_reaction/slimecasp/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

/datum/chemical_reaction/slimefire
	name = "Slime fire"
	id = "m_fire"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/orange
	required_other = 1
/datum/chemical_reaction/slimefire/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>The slime extract begins to vibrate violently !</span>"), 1)
	spawn(50)
		if(holder && holder.my_atom)
			var/turf/simulated/T = get_turf(holder.my_atom)
			if(istype(T))
				T.atmos_spawn_air(SPAWN_HEAT | SPAWN_TOXINS, 50)

//Yellow

/datum/chemical_reaction/slimeoverload
	name = "Slime EMP"
	id = "m_emp"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/yellow
	required_other = 1
/datum/chemical_reaction/slimeoverload/on_reaction(var/datum/reagents/holder, var/created_volume)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	empulse(get_turf(holder.my_atom), 3, 7)


/datum/chemical_reaction/slimecell
	name = "Slime Powercell"
	id = "m_cell"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/yellow
	required_other = 1
/datum/chemical_reaction/slimecell/on_reaction(var/datum/reagents/holder, var/created_volume)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/weapon/stock_parts/cell/slime/P = new /obj/item/weapon/stock_parts/cell/slime
	P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slimeglow
	name = "Slime Glow"
	id = "m_glow"
	result = null
	required_reagents = list("water" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/yellow
	required_other = 1
/datum/chemical_reaction/slimeglow/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>The slime begins to emit a soft light. Squeezing it will cause it to grow brightly.</span>"), 1)
	var/obj/item/device/flashlight/slime/F = new /obj/item/device/flashlight/slime
	F.loc = get_turf(holder.my_atom)

//Purple

/datum/chemical_reaction/slimepsteroid
	name = "Slime Steroid"
	id = "m_steroid"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/purple
	required_other = 1
/datum/chemical_reaction/slimepsteroid/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/weapon/slimesteroid/P = new /obj/item/weapon/slimesteroid
	P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slimejam
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("sugar" = 1)
	result_amount = 10
	required_container = /obj/item/slime_extract/purple
	required_other = 1
/datum/chemical_reaction/slimejam/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")


//Dark Purple
/datum/chemical_reaction/slimeplasma
	name = "Slime Plasma"
	id = "m_plasma"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/darkpurple
	required_other = 1
/datum/chemical_reaction/slimeplasma/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/stack/sheet/mineral/plasma/P = new /obj/item/stack/sheet/mineral/plasma
	P.amount = 10
	P.loc = get_turf(holder.my_atom)

//Red
/datum/chemical_reaction/slimeglycerol
	name = "Slime Glycerol"
	id = "m_glycerol"
	result = "glycerol"
	required_reagents = list("plasma" = 1)
	result_amount = 8
	required_container = /obj/item/slime_extract/red
	required_other = 1
/datum/chemical_reaction/slimeglycerol/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")


/datum/chemical_reaction/slimebloodlust
	name = "Bloodlust"
	id = "m_bloodlust"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/red
	required_other = 1
/datum/chemical_reaction/slimebloodlust/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = 1
		for(var/mob/O in viewers(get_turf(holder.my_atom), null))
			O.show_message(text("<span class='danger'>The [slime] is driven into a frenzy!</span>"), 1)

//Pink
/datum/chemical_reaction/slimeppotion
	name = "Slime Potion"
	id = "m_potion"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/pink
	required_other = 1
/datum/chemical_reaction/slimeppotion/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/slimepotion/P = new /obj/item/slimepotion
	P.loc = get_turf(holder.my_atom)


//Black
/datum/chemical_reaction/slimemutate2
	name = "Advanced Mutation Toxin"
	id = "mutationtoxin2"
	result = "amutationtoxin"
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_other = 1
	required_container = /obj/item/slime_extract/black
/datum/chemical_reaction/slimemutate2/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")

//Oil
/datum/chemical_reaction/slimeexplosion
	name = "Slime Explosion"
	id = "m_explosion"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/oil
	required_other = 1
/datum/chemical_reaction/slimeexplosion/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	for(var/mob/O in viewers(get_turf(holder.my_atom), null))
		O.show_message(text("<span class='danger'>The slime extract begins to vibrate violently !</span>"), 1)
	spawn(50)
		if(holder && holder.my_atom)
			explosion(get_turf(holder.my_atom), 1 ,3, 6)
//Light Pink
/datum/chemical_reaction/slimepotion2
	name = "Slime Potion 2"
	id = "m_potion2"
	result = null
	result_amount = 1
	required_container = /obj/item/slime_extract/lightpink
	required_reagents = list("plasma" = 1)
	required_other = 1
/datum/chemical_reaction/slimepotion2/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/slimepotion2/P = new /obj/item/slimepotion2
	P.loc = get_turf(holder.my_atom)
//Adamantine
/datum/chemical_reaction/slimegolem
	name = "Slime Golem"
	id = "m_golem"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/adamantine
	required_other = 1
/datum/chemical_reaction/slimegolem/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/effect/golemrune/Z = new /obj/effect/golemrune
	Z.loc = get_turf(holder.my_atom)
	notify_ghosts("Golem rune created in [get_area(Z)].", 'sound/effects/ghost2.ogg')

//Bluespace

/datum/chemical_reaction/slimecrystal
	name = "Slime Crystal"
	id = "m_crystal"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/bluespace
	required_other = 1
/datum/chemical_reaction/slimecrystal/on_reaction(var/datum/reagents/holder, var/created_volume)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	if(holder.my_atom)
		var/obj/item/bluespace_crystal/BC = new(get_turf(holder.my_atom))
		BC.visible_message("<span class='notice'>The [BC.name] appears out of thin air!</span>")

//Cerulean

/datum/chemical_reaction/slimepsteroid2
	name = "Slime Steroid 2"
	id = "m_steroid2"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/cerulean
	required_other = 1
/datum/chemical_reaction/slimepsteroid2/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/weapon/slimesteroid2/P = new /obj/item/weapon/slimesteroid2
	P.loc = get_turf(holder.my_atom)

//Sepia
/datum/chemical_reaction/slimecamera
	name = "Slime Camera"
	id = "m_camera"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/sepia
	required_other = 1
/datum/chemical_reaction/slimecamera/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/device/camera/P = new /obj/item/device/camera
	P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slimefilm
	name = "Slime Film"
	id = "m_film"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/sepia
	required_other = 1
/datum/chemical_reaction/slimefilm/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/obj/item/device/camera_film/P = new /obj/item/device/camera_film
	P.loc = get_turf(holder.my_atom)


//Pyrite

/datum/chemical_reaction/slimepaint
	name = "Slime Paint"
	id = "s_paint"
	result = null
	required_reagents = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_extract/pyrite
	required_other = 1
/datum/chemical_reaction/slimepaint/on_reaction(var/datum/reagents/holder)
	feedback_add_details("slime_cores_used","[replacetext(name," ","_")]")
	var/list/paints = typesof(/obj/item/weapon/paint) - /obj/item/weapon/paint
	var/chosen = pick(paints)
	var/obj/P = new chosen
	if(P)
		P.loc = get_turf(holder.my_atom)

