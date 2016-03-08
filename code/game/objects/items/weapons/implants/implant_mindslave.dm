/obj/item/weapon/implant/mindslave
	name = "mindslave implant"
	desc = "Now YOU too can have your very own mindslave! Pop this implant into anybody and they'll obey any command you give for around 15 to 20 minutes."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0
	var/timerid
	var/slavememory

/obj/item/weapon/implant/mindslave/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Syndicate Mindslave implant MK1<BR>
				<b>Life:</b> Varies between 15 and 20 minutes.<BR>
				<b>Important Notes:</b> Personnel injected with this device become loyal to the user and will obey any command given for a limited time.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Allows user to command anyone implanted to do whatever they want.<BR>
				<b>Special Features:</b> Person with implant MUST obey any order you give. <BR>
				<b>Integrity:</b> Implant will last around 15 and 20 minutes."}
	return dat

/obj/item/weapon/implant/mindslave/implant(mob/target,mob/user)
	if(target == user)
		target <<"<span class='notice'>You can't implant yourself!</span>"
		return 0
	if(isloyal(target))
		target <<"<span class='danger'>Your loyalty implant rejects [user]'s mindslave!</span>"
		user <<"<span class='danger'>[target] somehow rejects the mindslave implant!</span>"
		return 0
	if(..())
		target << "<span class='notice'>You feel a surge of loyalty towards [user].</span>"
		target << "<span class='userdanger'> You MUST obey any command given to you by your master(that doesn't violate any rules). You are an antag while mindslaved.</span>"
		target << "<span class='danger'>You CANNOT harm your master.</span>"
		var/time = 9000 + rand(60,3000)
		timerid = addtimer(src,"remove_mindslave",time)
		target.mind.special_role = "Mindslave"
		slavememory = "<b>Your mindslave master is</b>: [user]. Obey any command they give you!"
		target.mind.store_memory(slavememory)
		return 1
	return 0

/obj/item/weapon/implant/mindslave/removed(mob/source)
	deltimer(timerid)
	remove_mindslave()
	..()

/obj/item/weapon/implant/mindslave/Destroy()
	deltimer(timerid)
	remove_mindslave()
	..()

/obj/item/weapon/implant/mindslave/proc/remove_mindslave()
	if(imp_in)
		imp_in.mind.special_role = ""
		imp_in << "<span class='userdanger'>You feel your free will come back to you! REMEMBER THAT YOU ARE NOW NO LONGER AN ANTAG, BUT YOU NO LONGER HAVE TO LISTEN TO YOUR MASTER.</span>"
		imp_in.memory -= slavememory

/obj/item/weapon/implanter/mindslave
	name = "implanter (mind slave)"

/obj/item/weapon/implanter/mindslave/New()
	imp = new /obj/item/weapon/implant/mindslave(src)
	..()
	update_icon()