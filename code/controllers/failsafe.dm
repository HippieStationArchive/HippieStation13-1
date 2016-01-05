 /**
  * Failsafe
  *
  * Pretty much pokes the MC to make sure it's still alive.
 **/

var/datum/controller/failsafe/Failsafe

/datum/controller/failsafe // This thing pretty much just keeps poking the master controller
	name = "Failsafe"

	// The length of time to check on the MC (in deciseconds).
	// Set to 0 to disable.
	var/processing_interval = 100
	// The alert level. For every failed poke, we drop a DEFCON level. Once we hit DEFCON 1, restart the MC.
	var/defcon = 0

	// Track the MC iteration to make sure its still on track.
	var/master_iteration = 0

/datum/controller/failsafe/New()
	// Highlander-style: there can only be one! Kill off the old and replace it with the new.
	if(Failsafe != src)
		if(istype(Failsafe))
			qdel(Failsafe)
	Failsafe = src
	Failsafe.process()

/datum/controller/failsafe/process()
	spawn(0)
		while(1) // More efficient than recursion, 1 to avoid an infinite loop.
			if(!Master)
				// Replace the missing Master! This should never, ever happen.
				new /datum/controller/master()
			// Only poke it if overrides are not in effect.
			if(processing_interval > 0)
				if(Master.processing_interval > 0)
					// Check if processing is done yet.
					if(Master.iteration == master_iteration)
						switch(defcon)
							if(1 to 3)
								++defcon
							if(4)
								admins << "<span class='boldannounce'>Warning: DEFCON [defcon]. The Master Controller has not fired in the last [defcon * processing_interval] ticks. Automatic restart in [processing_interval] ticks.</span>"
								defcon = 5
							if(5)
								admins << "<span class='boldannounce'>Warning: DEFCON [defcon]. The Master Controller has still not fired within the last [defcon * processing_interval] ticks. Killing and restarting...</span>"
								// Replace the old master controller by creating a new one.
								new/datum/controller/master()
								// Get it rolling again.
								Master.process()
								defcon = 0
					else
						defcon = 0
						master_iteration = Master.iteration
				sleep(processing_interval)
			else
				defcon = 0
				sleep(100)

/datum/controller/failsafe/proc/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug("Initializing...", src)

	stat("Failsafe Controller:", statclick.update("Defcon: [Failsafe.defcon] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])"))