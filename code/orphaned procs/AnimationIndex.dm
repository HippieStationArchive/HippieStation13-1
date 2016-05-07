//Generally this file will contain atom animations using animate()

//Pass color as a HEX you nerds
/proc/flash_and_shake(var/atom/A, var/inputcolor, var/time, var/loops = 0, var/xdif = 0, var/ydif = 0)
	if(!istype(A) || !inputcolor || !time || !loops)
		return
	var/original_color = A.color
	var/original_y = A.pixel_y
	var/original_x = A.pixel_x

	ydif += A.pixel_y
	xdif += A.pixel_x

	var/inverse_ydif = -ydif
	var/inverse_xdif = -xdif

	animate(A,color = inputcolor,pixel_x = rand(inverse_xdif,xdif), pixel_y = rand(inverse_ydif,ydif), time = time,  loop = loops, easing = ELASTIC_EASING)
	animate(A, color = original_color,pixel_x = original_x, pixel_y = original_y, time = time, loop = loops, easing = LINEAR_EASING)