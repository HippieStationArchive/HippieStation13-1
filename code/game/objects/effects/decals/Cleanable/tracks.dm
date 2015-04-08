//Mostly /vg/code with adjustments

// 5 seconds
#define TRACKS_CRUSTIFY_TIME   50

/datum/fluidtrack
	var/direction=0
	var/basecolor="#A10808" //Colors are not yet implemented lol
	var/wet=0
	var/amt=0
	var/fresh=1
	var/crusty=0
	var/image/overlay

/datum/fluidtrack/New(_direction,_color,_wet,_amt)
	src.direction=_direction
	src.basecolor=_color
	src.wet=_wet
	src.amt=_amt

/obj/effect/decal/cleanable/blood/trackss
	amount = 0
	random_icon_states = null
	var/dirs=0
	icon = 'icons/effects/footprints.dmi'
	icon_state = ""
	var/coming_state="human1"
	var/going_state="human2"
	var/updatedtracks=0

	// dir = id in stack
	var/list/setdirs=list(
		"1"=0,
		"2"=0,
		"4"=0,
		"8"=0,
		"16"=0,
		"32"=0,
		"64"=0,
		"128"=0
	)

	// List of laid tracks and their colors.
	var/list/datum/fluidtrack/stack=list()
	/**
	* Add tracks to an existing trail.
	*
	* @param DNA bloodDNA to add to collection.
	* @param comingdir Direction tracks come from, or 0.
	* @param goingdir Direction tracks are going to (or 0).
	* @param bloodcolor Color of the blood when wet.
	*/
/obj/effect/decal/cleanable/blood/trackss/proc/AddTracks(var/list/DNA, var/comingdir, var/goingdir, var/bloodamt=5, var/bloodcolor="#A10808")
	var/updated=0
	// Shift our goingdir 4 spaces to the left so it's in the GOING bitblock.
	var/realgoing=goingdir<<4

	// Current bit
	var/b=0

	// When tracks will start to dry out
	var/t=world.time + TRACKS_CRUSTIFY_TIME

	var/datum/fluidtrack/track
	// world.log << "Called AddTracks for tracks"
	// Process 4 bits
	for(var/bi=0;bi<4;bi++)
		b=1<<bi
		// COMING BIT
		// If setting
		if(comingdir&b)
			// If not wet or not set
			if(dirs&b)
				var/sid=setdirs["[b]"]
				track=stack[sid]
				if(track.amt >= bloodamt)//if(track.wet==t && track.basecolor==bloodcolor)
					// world.log << "Skipping COMING track because [track.amt] >= [bloodamt]"
					continue
				// Remove existing stack entry
				stack.Remove(track)
			track=new /datum/fluidtrack(b,bloodcolor,t,bloodamt)
			stack.Add(track)
			setdirs["[b]"]=stack.Find(track)
			updatedtracks |= b
			updated=1

		// GOING BIT (shift up 4)
		b=b<<4
		if(realgoing&b)
			// If not wet or not set
			if(dirs&b)
				var/sid=setdirs["[b]"]
				track=stack[sid]
				if(track.amt >= bloodamt)//if(track.wet==t && track.basecolor==bloodcolor)
					// world.log << "Skipping GOING track because [track.amt] >= [bloodamt]"
					continue
				// Remove existing stack entry
				stack.Remove(track)
			track=new /datum/fluidtrack(b,bloodcolor,t,bloodamt)
			stack.Add(track)
			setdirs["[b]"]=stack.Find(track)
			updatedtracks |= b
			updated=1

	dirs |= comingdir|realgoing
	blood_DNA |= DNA.Copy()
	if(updated)
		update_icon()

/obj/effect/decal/cleanable/blood/trackss/remove_ex_blood() //removes existant blood on the turf
	return

/obj/effect/decal/cleanable/blood/trackss/update_icon()
	overlays.Cut()
	color = "#FFFFFF"
	var/truedir=0
	// world.log << "FOOTPRINTS: Called update_icon"
	// Update ONLY the overlays that have changed.
	for(var/datum/fluidtrack/track in stack)
		var/stack_idx=setdirs["[track.direction]"]
		var/state=coming_state
		truedir=track.direction
		if(truedir&240) // Check if we're in the GOING block
			state=going_state
			truedir=truedir>>4

		if(track.overlay)
			track.overlay=null
		// var/image/I = image(icon, icon_state=state, dir=num2dir(truedir))
		// I.color = track.basecolor
		var/icon/add = icon(icon, state, truedir)
		add.Blend(track.basecolor, ICON_MULTIPLY) //Adjust color
		add += rgb(0,0,0, max(0, min(track.amt*40, 255))) //This adds alpha
		// add.Blend(track.basecolor,ICON_MULTIPLY)
		// flat.Blend(add,ICON_OVERLAY)

		track.fresh=0
		track.overlay=add
		stack[stack_idx]=track
		overlays += add
		// world.log << "Updated [src] with new [track.overlay] overlay with [track.basecolor] color"
	updatedtracks=0 // Clear our memory of updated tracks.

	// var/truedir=0
	// var/icon/flat = icon('icons/effects/footprints.dmi')

	// // Update ONLY the overlays that have changed.
	// for(var/datum/fluidtrack/track in stack)
	// 	// TODO: Uncomment when the block above is fixed.
	// 	//if(!(updatedtracks&track.direction) && !track.fresh)
	// 	//	continue
	// 	//world << "[track.amt] AMT for track"  //crystal for fucks sake
	// 	var/stack_idx=setdirs["[track.direction]"]
	// 	var/state="blood[coming_state]"
	// 	truedir=track.direction
	// 	if(truedir&240) // Check if we're in the GOING block
	// 		state="blood[going_state]"
	// 		truedir=truedir>>4
	// 	var/icon/add = icon('icons/effects/footprints.dmi', state, num2dir(truedir))
	// 	// add.Blend("#FFFFFF",ICON_MULTIPLY)
	// 	add.Blend(rgb(255,255,255, max(0, min(track.amt*40, 255))), ICON_MULTIPLY)
	// 	flat.Blend(add,ICON_OVERLAY)

	// 	track.fresh=0
	// 	stack[stack_idx]=track

	// icon = flat
	// updatedtracks=0 // Clear our memory of updated tracks.

/obj/effect/decal/cleanable/blood/trackss/footprints
	name = "wet footprints"
	desc = "Whoops..."
	dryname = "dried footprints"
	drydesc = "Whoops..."
	coming_state = "human1"
	going_state  = "human2"
	amount = 0

/obj/effect/decal/cleanable/blood/trackss/footprints/xeno
	coming_state = "claw1"
	going_state  = "claw2"

// /obj/effect/decal/cleanable/blood/trackss/wheels
// 	name = "wet tracks"
// 	desc = "Whoops..."
// 	coming_state = "wheels"
// 	going_state  = ""
// 	desc = "They look like tracks left by wheels."
// 	gender = PLURAL
// 	random_icon_states = null
// 	amount = 0

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null
	amount = 0