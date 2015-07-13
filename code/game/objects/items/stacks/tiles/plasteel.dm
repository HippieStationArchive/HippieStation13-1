/obj/item/stack/tile/plasteel
	name = "floor tile"
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon"
	icon_state = "tile"
	w_class = 3.0
	force = 6.0
	m_amt = 937.5
	throwforce = 10.0
	throw_speed = 3
	throw_range = 7
	flags = CONDUCT
	max_amount = 60
	turf_type = /turf/simulated/floor/plasteel

/obj/item/stack/tile/plasteel/cyborg
	desc = "The ground you walk on" //Not the usual floor tile desc as that refers to throwing, Cyborgs can't do that - RR
	m_amt = 0 // All other Borg versions of items have no Metal or Glass - RR
	is_cyborg = 1
	cost = 125

/obj/item/stack/tile/plasteel/New(var/loc, var/amount=null)
	..()
	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)
	return

/obj/item/stack/tile/plasteel/attackby(obj/item/W as obj, mob/user as mob, params)

	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(get_amount() < 4)
			user << "<span class='warning'>You need at least four tiles to do this.</span>"
			return

		if(WT.remove_fuel(0,user))
			var/obj/item/stack/sheet/metal/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			user.visible_message("<span class='warning'>[user.name] shaped [src] into metal with the weldingtool.</span>", \
						 "<span class='notice'>You shaped [src] into metal with the weldingtool.</span>", \
						 "<span class='warning'>You hear welding.</span>")
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(4)
			if (!R && replace)
				user.put_in_hands(new_item)
		return
	else
		..()
