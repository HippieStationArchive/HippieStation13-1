/obj/item/weapon/implant/weapons_auth
	name = "firearms authentication implant"
	desc = "Lets you shoot your guns"
	icon_state = "auth"
	origin_tech = "materials=2;magnets=2;programming=2;biotech=5;syndicate=5"
	activated = 0

/obj/item/weapon/implant/weapons_auth/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Firearms Authentication Implant<BR>
				<b>Life:</b> 4 hours after death of host<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Allows operation of implant-locked weaponry, preventing equipment from falling into enemy hands."}
	return dat

/*
/obj/item/weapon/implant/adrenalin
	name = "adrenal implant"
	desc = "Removes all stuns and knockdowns."
	icon_state = "adrenal"
	origin_tech = "materials=2;biotech=4;combat=3;syndicate=4"
	uses = 3

/obj/item/weapon/implant/adrenalin/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Cybersun Industries Adrenaline Implant<BR>
				<b>Life:</b> Five days.<BR>
				<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
				<HR>
				<b>Implant Details:</b> Subjects injected with implant can activate an injection of medical cocktails.<BR>
				<b>Function:</b> Removes stuns, increases speed, and has a mild healing effect.<BR>
				<b>Integrity:</b> Implant can only be used three times before reserves are depleted."}
	return dat

/obj/item/weapon/implant/adrenalin/activate()
	if(uses < 1)	return 0
	uses--
	imp_in << "<span class='notice'>You feel a sudden surge of energy!</span>"
	imp_in.SetStunned(0)
	imp_in.SetWeakened(0)
	imp_in.SetParalysis(0)
	imp_in.adjustStaminaLoss(-75)
	imp_in.lying = 0
	imp_in.update_canmove()

	imp_in.reagents.add_reagent("synaptizine", 10)
	imp_in.reagents.add_reagent("omnizine", 10)
	imp_in.reagents.add_reagent("stimulants", 10)
*/

/*
/obj/item/weapon/implant/adrenalin/false
	desc = "Removes all stuns and knockdowns. It looks like it might've been tampered with."
	var/implant_type = 0

/obj/item/weapon/implant/adrenalin/false/New()
	implant_type = rand(1,10)
	uses = pick(3,3,3,2,4)

/obj/item/weapon/implant/adrenalin/false/activate()
	if(uses < 1)
		implant_type = 1
	uses--
	switch(implant_type)
		if(1,2)
			imp_in << "<span class='userdanger'>You feel...what's that noise?!?!</span>"
			playsound(loc, 'sound/items/timer.ogg', 30, 0)
			sleep(5)
			playsound(loc, 'sound/items/timer.ogg', 30, 0)
			sleep(5)
			playsound(loc, 'sound/items/timer.ogg', 30, 0)
			sleep(5)
			explosion(src,1,2,4,4,4)
			if(imp_in)
				imp_in.gib()
		if(3 to 5)
			imp_in << "<span class='danger'>You feel a sudden surge of pain!</span>"
			imp_in.reagents.add_reagent("cyanide", 10)
			imp_in.reagents.add_reagent("chloralhydrate", 10)
		if(6,7)
			imp_in << "<span class='notice'>You feel wet...</span>"
			imp_in.reagents.add_reagent("water", 30)
		if(8,9)
			imp_in << "<span class='notice'>You feel a mild surge of energy!</span>"
			imp_in.AdjustStunned(-4)
			imp_in.AdjustWeakened(-4)
			imp_in.AdjustParalysis(-4)
			imp_in.adjustStaminaLoss(-50)
			imp_in.lying = 0
			imp_in.update_canmove()
			imp_in.reagents.add_reagent("tricordrazine", 10)
			imp_in.reagents.add_reagent("ephedrine", 10)
		if(10)
			imp_in << "<span class='notice'>You feel a sudden surge of energy!</span>"
			imp_in.SetStunned(0)
			imp_in.SetWeakened(0)
			imp_in.SetParalysis(0)
			imp_in.adjustStaminaLoss(-75)
			imp_in.lying = 0
			imp_in.update_canmove()
			imp_in.reagents.add_reagent("synaptizine", 10)
			imp_in.reagents.add_reagent("omnizine", 10)
			imp_in.reagents.add_reagent("stimulants", 10)
*/
/obj/item/weapon/implant/emp
	name = "emp implant"
	desc = "Triggers an EMP."
	icon_state = "emp"
	origin_tech = "materials=2;biotech=3;magnets=4;syndicate=4"
	uses = 2

/obj/item/weapon/implant/emp/activate()
	if (src.uses < 1)	return 0
	src.uses--
	empulse(imp_in, 3, 5)
