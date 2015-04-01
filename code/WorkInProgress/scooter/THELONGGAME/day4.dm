/proc/stationspin(var/spans = 1)//placeholder until ported from FPcode
	while(spans)
		for(var/client/C in world)
			C.dir = 2
			spawn(5)
				C.dir = 4
				spawn(5)
					C.dir = 8
					spawn(3)
						C.dir = 1

			spans--
	sleep(5)