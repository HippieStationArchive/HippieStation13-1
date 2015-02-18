//Bullet items that are supposed to be lodged into organs are located here

/obj/item/bullet //When extractred through surgery
	name = "bullet" //TO DO: Set the name of the bullet to the bullet type (9mm, etc.). Also add unique ID tying the bullet with the gun for forensics investigations.
	desc = "Seems to be a spent bullet."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bullet"

/obj/item/bullet/New()
	..()
	pixel_x = rand(-4, 4)	//Randomizes postion
	pixel_y = rand(-4, 4)