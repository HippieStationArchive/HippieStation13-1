 /*
What are the archived variables for?
	Calculations are done using the archived variables with the results merged into the regular variables.
	This prevents race conditions that arise based on the order of tile processing.
*/
#define MINIMUM_HEAT_CAPACITY	0.0003
#define QUANTIZE(variable)		(round(variable,0.0000001))/*I feel the need to document what happens here. Basically this is used to catch most rounding errors, however it's previous value made it so that
															once gases got hot enough, most procedures wouldnt occur due to the fact that the mole counts would get rounded away. Thus, we lowered it a few orders of magnititude */

var/list/meta_gas_info = meta_gas_list() //see ATMOSPHERICS/gas_types.dm
var/list/cached_gases_list = null

/proc/gaslist(gasid)
	if(!cached_gases_list)
		cached_gases_list = new /list(meta_gas_info.len)

	if(!cached_gases_list[gasid])
		if(!meta_gas_info[gasid])
			CRASH("Error: no such gas type! Type : [gasid]")

		var/list/new_gas_list = new(3)
		new_gas_list[MOLES] = 0
		new_gas_list[ARCHIVE] = 0
		new_gas_list[GAS_META] = meta_gas_info[gasid]
		cached_gases_list[gasid] = new_gas_list

	var/list/gas = cached_gases_list[gasid]
	. = gas.Copy()

/datum/gas_mixture
	var/list/gases
	var/temperature //in Kelvin
	var/tmp/temperature_archived
	var/volume
	var/last_share
	var/tmp/fuel_burnt

/datum/gas_mixture/New(Volume = CELL_VOLUME)
	. = ..()
	gases = new
	temperature = 0
	temperature_archived = 0
	volume = Volume
	last_share = 0
	fuel_burnt = 0

	//listmos procs

		//assert_gas(gas_id) - used to guarantee that the gas list for this id exists.
		//Must be used before adding to a gas. May be used before reading from a gas.
/datum/gas_mixture/proc/assert_gas(gas_id)
	var/cached_gases = gases
	if(cached_gases[gas_id])
		return
	cached_gases[gas_id] = gaslist(gas_id) //see ATMOSPHERICS/gas_types.dm

		//assert_gases(args) - shorthand for calling assert_gas() once for each gas type.
/datum/gas_mixture/proc/assert_gases()
	for(var/id in args)
		assert_gas(id)

		//add_gas(gas_id) - similar to assert_gas(), but does not check for an existing
			//gas list for this id.
		//Used instead of assert_gas() when you know the gas does not exist. Faster than assert_gas().
/datum/gas_mixture/proc/add_gas(gas_id)
	gases[gas_id] = gaslist(gas_id)

		//add_gases(args) - shorthand for calling add_gas() once for each gas_type.
/datum/gas_mixture/proc/add_gases()
	for(var/id in args)
		add_gas(id)

		//garbage_collect() - removes any gas list which is empty.
		//Must be used after subtracting from a gas. Must be used after assert_gas()
			//if assert_gas() was called only to read from the gas.
		//By removing empty gases, processing speed is increased.
/datum/gas_mixture/proc/garbage_collect()
	var/list/cached_gases = gases
	for(var/id in cached_gases)
		var/gas = cached_gases[id]
		if(QUANTIZE(gas[MOLES]) <= 0 && QUANTIZE(gas[ARCHIVE]) <= 0)
			cached_gases -= id

	//PV=nRT - related procedures
/datum/gas_mixture/proc/heat_capacity()
	var/list/cached_gases = gases
	. = 0
	for(var/id in cached_gases)
		. += cached_gases[id][MOLES]*cached_gases[id][SPECIFIC_HEAT]

/datum/gas_mixture/proc/heat_capacity_archived()
	var/list/cached_gases = gases
	. = 0
	for(var/id in cached_gases)
		. += cached_gases[id][ARCHIVE]*cached_gases[id][SPECIFIC_HEAT]

/datum/gas_mixture/proc/total_moles()
	var/list/cached_gases = gases
	. = 0
	for(var/id in cached_gases)
		. += cached_gases[id][MOLES]

/datum/gas_mixture/proc/return_pressure()
	if(volume>0)
		return total_moles()*R_IDEAL_GAS_EQUATION*temperature/volume
	return 0

/datum/gas_mixture/proc/return_temperature()
	return temperature


/datum/gas_mixture/proc/return_volume()
	return max(0, volume)


/datum/gas_mixture/proc/thermal_energy()
	return temperature*heat_capacity()


//Procedures used for very specific events


/datum/gas_mixture/proc/react(atom/dump_location)
	var/list/procgases = gases //this speeds things up because >byond
	var/reacting = 0 //set to 1 if a notable reaction occured (used by pipe_network)
	if(temperature < TCMB)
		temperature = TCMB
	if(procgases["agent_b"] && temperature > 900 && procgases["plasma"] && procgases["co2"])
		if(procgases["plasma"][MOLES] > MINIMUM_HEAT_CAPACITY && procgases["co2"][MOLES] > MINIMUM_HEAT_CAPACITY)
			var/reaction_rate = min(procgases["co2"][MOLES]*0.75, procgases["plasma"][MOLES]*0.25, procgases["agent_b"][MOLES]*0.05)

			procgases["co2"][MOLES] -= reaction_rate

			assert_gas("o2") //only need to assert oxygen, as this reaction doesn't occur without the other gases existing
			procgases["o2"][MOLES] += reaction_rate

			procgases["agent_b"][MOLES] -= reaction_rate*0.05

			temperature -= (reaction_rate*20000)/heat_capacity()

			garbage_collect()

			reacting = 1
	/*
	if(thermal_energy() > (PLASMA_BINDING_ENERGY*10))
		if(procgases["plasma"] && procgases["co2"] && procgases["plasma"][MOLES] > MINIMUM_HEAT_CAPACITY && procgases["co2"][MOLES] > MINIMUM_HEAT_CAPACITY && (procgases["plasma"][MOLES]+procgases["co2"][MOLES])/total_moles() >= FUSION_PURITY_THRESHOLD)//Fusion wont occur if the level of impurities is too high.
			//world << "pre [temperature, [procgases["plasma"][MOLES]], [procgases["co2"][MOLES]]
			var/old_heat_capacity = heat_capacity()
			var/carbon_efficency = min(procgases["plasma"][MOLES]/procgases["co2"][MOLES],MAX_CARBON_EFFICENCY)
			var/reaction_energy = thermal_energy()
			var/moles_impurities = total_moles()-(procgases["plasma"][MOLES]+procgases["co2"][MOLES])

			var/plasma_fused = (PLASMA_FUSED_COEFFICENT*carbon_efficency)*(temperature/PLASMA_BINDING_ENERGY)
			var/carbon_catalyzed = (CARBON_CATALYST_COEFFICENT*carbon_efficency)*(temperature/PLASMA_BINDING_ENERGY)
			var/oxygen_added = carbon_catalyzed
			var/nitrogen_added = (plasma_fused-oxygen_added)-(thermal_energy()/PLASMA_BINDING_ENERGY)

			reaction_energy = max(reaction_energy+((carbon_efficency*procgases["plasma"][MOLES])/((moles_impurities/carbon_efficency)+2)*10)+((plasma_fused/(moles_impurities/carbon_efficency))*PLASMA_BINDING_ENERGY),0)

			assert_gases("o2", "n2")

			procgases["plasma"][MOLES] -= plasma_fused
			procgases["co2"][MOLES] -= carbon_catalyzed
			procgases["o2"][MOLES] += oxygen_added
			procgases["n2"][MOLES] += nitrogen_added

			garbage_collect()

			if(reaction_energy > 0)
				reacting = 1
				var/new_heat_capacity = heat_capacity()
				if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
					temperature = max(((temperature*old_heat_capacity + reaction_energy)/new_heat_capacity),TCMB)
					//Prevents whatever mechanism is causing it to hit negative temperatures.
				//world << "post [temperature], [procgases["plasma"][MOLES]], [procgases["co2"][MOLES]]
			*/
	fuel_burnt = 0
	if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		//world << "pre [temperature], [procgases["o2"][MOLES]], [procgases["plasma"][MOLES]]"
		if(fire())
			reacting = 1
		//world << "post [temperature], [procgases["o2"][MOLES]], [procgases["plasma"][MOLES]]"

	return reacting

/datum/gas_mixture/proc/fire()
	var/energy_released = 0
	var/old_heat_capacity = heat_capacity()
	var/list/procgases = gases //this speeds things up because accessing datum vars is slow

	if(procgases["v_fuel"] && procgases["v_fuel"][MOLES]) //General volatile gas burn
		var/burned_fuel

		if(!procgases["o2"])
			burned_fuel = 0
		else if(procgases["o2"][MOLES] < procgases["v_fuel"][MOLES])
			burned_fuel = procgases["o2"][MOLES]
			procgases["v_fuel"][MOLES] -= burned_fuel
			procgases["o2"][MOLES] = 0
		else
			burned_fuel = procgases["v_fuel"][MOLES]
			procgases["o2"][MOLES] -= procgases["v_fuel"][MOLES]

		if(burned_fuel)
			energy_released += FIRE_CARBON_ENERGY_RELEASED * burned_fuel

			assert_gas("co2")
			procgases["co2"][MOLES] += burned_fuel

			fuel_burnt += burned_fuel

	//Handle plasma burning
	if(procgases["plasma"] && procgases["plasma"][MOLES] > MINIMUM_HEAT_CAPACITY)
		var/plasma_burn_rate = 0
		var/oxygen_burn_rate = 0
		//more plasma released at higher temperatures
		var/temperature_scale
		if(temperature > PLASMA_UPPER_TEMPERATURE)
			temperature_scale = 1
		else
			temperature_scale = (temperature-PLASMA_MINIMUM_BURN_TEMPERATURE)/(PLASMA_UPPER_TEMPERATURE-PLASMA_MINIMUM_BURN_TEMPERATURE)
		if(temperature_scale > 0)
			assert_gas("o2")
			assert_gas("co2")
			oxygen_burn_rate = OXYGEN_BURN_RATE_BASE - temperature_scale
			if(procgases["o2"][MOLES] > procgases["plasma"][MOLES]*PLASMA_OXYGEN_FULLBURN)
				plasma_burn_rate = (procgases["plasma"][MOLES]*temperature_scale)/PLASMA_BURN_RATE_DELTA
			else
				plasma_burn_rate = (temperature_scale*(procgases["o2"][MOLES]/PLASMA_OXYGEN_FULLBURN))/PLASMA_BURN_RATE_DELTA
			if(plasma_burn_rate > MINIMUM_HEAT_CAPACITY)
				procgases["plasma"][MOLES] -= plasma_burn_rate
				procgases["o2"][MOLES] -= plasma_burn_rate*oxygen_burn_rate
				procgases["co2"][MOLES] += plasma_burn_rate

				energy_released += FIRE_PLASMA_ENERGY_RELEASED * (plasma_burn_rate)

				fuel_burnt += (plasma_burn_rate)*(1+oxygen_burn_rate)
				garbage_collect()

	if(energy_released > 0)
		var/new_heat_capacity = heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			temperature = (temperature*old_heat_capacity + energy_released)/new_heat_capacity

	return fuel_burnt

/datum/gas_mixture/proc/archive()
	//Update archived versions of variables
	//Returns: 1 in all cases

/datum/gas_mixture/proc/merge(datum/gas_mixture/giver)
	//Merges all air from giver into self. Deletes giver.
	//Returns: 1 in all cases

/datum/gas_mixture/proc/remove(amount)
	//Proportionally removes amount of gas from the gas_mixture
	//Returns: gas_mixture with the gases removed

/datum/gas_mixture/proc/remove_ratio(ratio)
	//Proportionally removes amount of gas from the gas_mixture
	//Returns: gas_mixture with the gases removed

/datum/gas_mixture/proc/copy_from(datum/gas_mixture/sample)
	//Copies variables from sample

/datum/gas_mixture/proc/share(datum/gas_mixture/sharer)
	//Performs air sharing calculations between two gas_mixtures assuming only 1 boundary length
	//Return: amount of gas exchanged (+ if sharer received)
/datum/gas_mixture/proc/mimic(turf/model)
	//Similar to share(...), except the model is not modified
	//Return: amount of gas exchanged

/datum/gas_mixture/proc/check_turf(turf/model)
	//Returns: 0 if self-check failed or 1 if check passes

/datum/gas_mixture/proc/temperature_mimic(turf/model, conduction_coefficient) //I want this proc to die a painful death

/datum/gas_mixture/proc/temperature_share(datum/gas_mixture/sharer, conduction_coefficient)

/datum/gas_mixture/proc/temperature_turf_share(turf/simulated/sharer, conduction_coefficient)

/datum/gas_mixture/proc/compare(datum/gas_mixture/sample)
	//Compares sample to self to see if within acceptable ranges that group processing may be enabled
	//returns: a string indicating what check failed, or "" if check passes

/datum/gas_mixture/proc/copy_from_turf(turf/model)
	//Copies all gas info from the turf into the gas list along with copying temperature, then archives

/datum/gas_mixture/archive()
	var/list/cached_gases = gases
	for(var/id in cached_gases)
		cached_gases[id][ARCHIVE] = cached_gases[id][MOLES]
	temperature_archived = temperature
	. = 1

/datum/gas_mixture/merge(datum/gas_mixture/giver)
	if(!giver)
		return 0

	if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = giver.heat_capacity()
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity)
			temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity
	var/list/cached_gases = gases //accessing datum vars is slower than proc vars
	var/list/giver_gases = giver.gases
	for(var/giver_id in giver_gases)
		assert_gas(giver_id)
		cached_gases[giver_id][MOLES] += giver_gases[giver_id][MOLES]

	. = 1

/datum/gas_mixture/remove(amount)

	var/sum = total_moles()
	amount = min(amount,sum) //Can not take more air than tile has!

	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new
	var/list/removed_gases = removed.gases //accessing datum vars is slower than proc vars
	var/list/cached_gases = gases

	for(var/id in cached_gases)
		removed.assert_gas(id)
		removed_gases[id][MOLES] = QUANTIZE((cached_gases[id][MOLES]/sum)*amount)
		cached_gases[id][MOLES] -= removed_gases[id][MOLES]

	removed.temperature = temperature

	garbage_collect()

	. = removed

/datum/gas_mixture/remove_ratio(ratio)
	if(ratio <= 0)
		return null

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new
	var/list/removed_gases = removed.gases //accessing datum vars is slower than proc vars
	var/list/cached_gases = gases

	for(var/id in cached_gases)
		removed.assert_gas(id)
		removed_gases[id][MOLES] = QUANTIZE(cached_gases[id][MOLES]*ratio)
		cached_gases[id][MOLES] -= removed_gases[id][MOLES]

	removed.temperature = temperature

	garbage_collect()

	. = removed

/datum/gas_mixture/copy_from(datum/gas_mixture/sample)
	var/list/cached_gases = gases //accessing datum vars is slower than proc vars
	var/list/sample_gases = sample.gases
	var/list/copied_gases = list()
	for(var/sample_id in sample_gases)
		assert_gas(sample_id)
		cached_gases[sample_id][MOLES] = sample_gases[sample_id][MOLES]
		copied_gases += sample_id
	for(var/id in cached_gases-copied_gases)
		assert_gas(id)
		cached_gases[id][MOLES] = 0

	garbage_collect()

	temperature = sample.temperature

	return 1

/datum/gas_mixture/check_turf(turf/model, atmos_adjacent_turfs = 4)
	var/datum/gas_mixture/copied = new
	copied.copy_from_turf(model)
	. = compare(copied, datatype = ARCHIVE, adjacents = atmos_adjacent_turfs)

/datum/gas_mixture/share(datum/gas_mixture/sharer, atmos_adjacent_turfs = 4)
	. = 0
	if(!sharer)
		return

	var/moved_moles = 0
	var/abs_moved_moles = 0
	//make this local to the proc for sanic speed
	var/list/sharercache = sharer.gases
	var/list/selfcache = gases

	var/delta_temperature = (temperature_archived - sharer.temperature_archived)

	var/old_self_heat_capacity = 0
	var/old_sharer_heat_capacity = 0

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		old_self_heat_capacity = heat_capacity()
		old_sharer_heat_capacity = sharer.heat_capacity()

	var/heat_capacity_self_to_sharer = 0 //heat capacity of the moles transferred from us to the sharer
	var/heat_capacity_sharer_to_self = 0 //heat capacity of the moles transferred from the sharer to us

	for(var/sharer_id in sharercache-selfcache)
		add_gas(sharer_id) //we can use add_gas() because we're looping only through the IDs not in our cache

	//GAS TRANSFER
	for(var/id in selfcache)
		if(!sharercache[id]) //checking here prevents an uneeded proc call if the check fails.
			sharer.add_gas(id)

		var/gas = selfcache[id]
		var/sharergas = sharercache[id]

		var/delta = QUANTIZE(gas[ARCHIVE] - sharergas[ARCHIVE])/(atmos_adjacent_turfs+1) //the amount of gas that gets moved between the mixtures

		if(delta && abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/gas_heat_capacity = delta * gas[SPECIFIC_HEAT]
			if(delta > 0)
				heat_capacity_self_to_sharer += gas_heat_capacity
			else
				heat_capacity_sharer_to_self -= gas_heat_capacity //subtract here instead of adding the absolute value because we know that delta is negative. saves a proc call.

		gas[MOLES]			-= delta
		sharergas[MOLES]	+= delta
		moved_moles			+= delta
		abs_moved_moles		+= abs(delta)

	last_share = abs_moved_moles

	//THERMAL ENERGY TRANSFER
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/new_self_heat_capacity = old_self_heat_capacity + heat_capacity_sharer_to_self - heat_capacity_self_to_sharer
		var/new_sharer_heat_capacity = old_sharer_heat_capacity + heat_capacity_self_to_sharer - heat_capacity_sharer_to_self

		//transfer of thermal energy (via changed heat capacity) between self and sharer
		if(new_self_heat_capacity > MINIMUM_HEAT_CAPACITY)
			temperature = (old_self_heat_capacity*temperature - heat_capacity_self_to_sharer*temperature_archived + heat_capacity_sharer_to_self*sharer.temperature_archived)/new_self_heat_capacity

		if(new_sharer_heat_capacity > MINIMUM_HEAT_CAPACITY)
			sharer.temperature = (old_sharer_heat_capacity*sharer.temperature-heat_capacity_sharer_to_self*sharer.temperature_archived + heat_capacity_self_to_sharer*temperature_archived)/new_sharer_heat_capacity
		//thermal energy of the system (self and sharer) is unchanged

			if(abs(old_sharer_heat_capacity) > MINIMUM_HEAT_CAPACITY)
				if(abs(new_sharer_heat_capacity/old_sharer_heat_capacity - 1) < 0.10) // <10% change in sharer heat capacity
					temperature_share(sharer, OPEN_HEAT_TRANSFER_COEFFICIENT)

	if((delta_temperature > MINIMUM_TEMPERATURE_TO_MOVE) || abs(moved_moles) > MINIMUM_MOLES_DELTA_TO_MOVE)
		var/delta_pressure = temperature_archived*(total_moles() + moved_moles) - sharer.temperature_archived*(sharer.total_moles() - moved_moles)
		. = delta_pressure*R_IDEAL_GAS_EQUATION/volume

	garbage_collect()
	sharer.garbage_collect()

/datum/gas_mixture/mimic(turf/model, atmos_adjacent_turfs = 4)
	var/datum/gas_mixture/copied = new
	copied.copy_from_turf(model)
	. = share(copied, atmos_adjacent_turfs)

/datum/gas_mixture/temperature_share(datum/gas_mixture/sharer, conduction_coefficient)
	//transfer of thermal energy (via conduction) between self and sharer
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity_archived()
		var/sharer_heat_capacity = sharer.heat_capacity_archived()

		if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

			temperature = max(temperature - heat/self_heat_capacity, TCMB)
			sharer.temperature = max(sharer.temperature + heat/sharer_heat_capacity, TCMB)
	//thermal energy of the system (self and sharer) is unchanged

/datum/gas_mixture/temperature_mimic(turf/model, conduction_coefficient)
	var/delta_temperature = (temperature - model.temperature)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()

		if((model.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*model.heat_capacity/(self_heat_capacity+model.heat_capacity))

			temperature = max(temperature - heat/self_heat_capacity, TCMB)

/datum/gas_mixture/temperature_turf_share(turf/simulated/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()

		if((sharer.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer.heat_capacity/(self_heat_capacity+sharer.heat_capacity))

			temperature = max(temperature - heat/self_heat_capacity, TCMB)
			sharer.temperature = max(sharer.temperature + heat/sharer.heat_capacity, TCMB)

/datum/gas_mixture/compare(datum/gas_mixture/sample, datatype = MOLES, adjacents = 0)
	. = ""
	var/list/sample_gases = sample.gases //accessing datum vars is slower than proc vars
	var/list/cached_gases = gases

	for(var/id in cached_gases|sample_gases)
		var/gas_moles = cached_gases[id] ? cached_gases[id][datatype] : 0
		var/sample_moles = sample_gases[id] ? sample_gases[id][datatype] : 0
		var/delta = abs(gas_moles - sample_moles)/(adjacents+1)
		if(delta > MINIMUM_AIR_TO_SUSPEND && \
			delta > gas_moles*MINIMUM_AIR_RATIO_TO_SUSPEND)
			return id

	if(total_moles() > MINIMUM_AIR_TO_SUSPEND)
		var/temp
		var/sample_temp

		switch(datatype)
			if(MOLES)
				temp = temperature
				sample_temp = sample.temperature
			if(ARCHIVE)
				temp = temperature_archived
				sample_temp = sample.temperature_archived

		var/delta_temperature = abs(temp-sample_temp)
		if((delta_temperature > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
			delta_temperature > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND*temp)
			return "temp"

/datum/gas_mixture/copy_from_turf(turf/model)
	assert_gases(arglist(hardcoded_gases))
	var/list/cached_gases = gases

	cached_gases["o2"][MOLES]		= model.oxygen
	cached_gases["n2"][MOLES]		= model.nitrogen
	cached_gases["plasma"][MOLES]	= model.toxins
	cached_gases["co2"][MOLES]		= model.carbon_dioxide

	for(var/id in cached_gases-hardcoded_gases)
		cached_gases[id][MOLES] = 0 //turfs don't account for anything other than the four old hardcoded gases

	temperature = model.temperature

	garbage_collect()
//Takes the amount of the gas you want to PP as an argument
//So I don't have to do some hacky switches/defines/magic strings

//eg:
//Tox_PP = get_partial_pressure(gas_mixture.toxins)
//O2_PP = get_partial_pressure(gas_mixture.oxygen)

//Does handle trace gases!

/datum/gas_mixture/proc/get_breath_partial_pressure(gas_pressure)
	return (gas_pressure*R_IDEAL_GAS_EQUATION*temperature)/BREATH_VOLUME


//Reverse of the above
/datum/gas_mixture/proc/get_true_breath_pressure(breath_pp)
	return (breath_pp*BREATH_VOLUME)/(R_IDEAL_GAS_EQUATION*temperature)

//Mathematical proofs:
/*

get_breath_partial_pressure(gas_pp) --> gas_pp/total_moles()*breath_pp = pp
get_true_breath_pressure(pp) --> gas_pp = pp/breath_pp*total_moles()

10/20*5 = 2.5
10 = 2.5/5*20

*/