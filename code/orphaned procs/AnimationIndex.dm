//Generally this file will contain atom animations using animate()

//Pass color as a HEX you nerds
/proc/flash_color(var/atom/A, var/inputcolor, var/time, var/loops = 0)
	if(!istype(A) || !inputcolor || !time || !loops)
		return
	var/original_color = A.color
	animate(A,color = inputcolor, time = time,  loop = loops, easing = LINEAR_EASING)
	animate(A, color = original_color, time = time, loop = loops, easing = LINEAR_EASING)