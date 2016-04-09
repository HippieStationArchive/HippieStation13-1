/obj/item/weapon/implant/mindslave/
	name = "mindslave implant"
	desc = "Now YOU too can have your very own mindslave! Pop this implant into anybody and they'll obey any command you give for around 15 to 20 minutes."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0
	var/timerid
	var/datum/objective/protect/protect_objective

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
	if(target.mind)
		if(target == user)
			target <<"<span class='notice'>You can't implant yourself!</span>"
			return 0
		if(isloyal(target))
			target <<"<span class='danger'>Your loyalty implant rejects [user]'s mindslave!</span>"
			user <<"<span class='danger'>[target] somehow rejects the mindslave implant!</span>"
			return 0
		if(..())
			target << "<span class='notice'>You feel a surge of loyalty towards [user].</span>"
			target << "<span class='danger'>You have been mindslaved by [user]! Until the implant expires, they are your master. You MUST obey any command given to you and CANNOT harm your master unless they order you to do so.</span>"
			var/time = 9000 + rand(60,3000)
			timerid = addtimer(src,"remove_mindslave",time)
			if(!target.mind.special_role)
				target.mind.special_role = "Mindslave"
				ticker.mode.traitors |= target.mind
			protect_objective = new /datum/objective/protect
			protect_objective.owner = target.mind
			protect_objective.target = user.mind
			protect_objective.explanation_text = "Protect [user], your mindslave master. Obey any command given by them."
			target.mind.objectives += protect_objective
			message_admins("[user]/([user.ckey]) made a mindslave out of [target]/([target.ckey]).")
			return 1
	user <<"<span class='notice'>[target] has no mind!</span>"
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
		if(imp_in.mind.special_role == "Mindslave")
			imp_in.mind.special_role = ""
			ticker.mode.traitors -= imp_in.mind
		imp_in << "<span class='userdanger'>You feel your free will come back to you! You no longer have to obey your master!</span>"
		imp_in << "<span class='userdanger'>If you were not an antagonist BEFORE being mindslave, then you no longer are one.</span>"
		qdel(protect_objective)
		message_admins("[imp_in]/([imp_in.ckey]) is no longer a mindslave.")

/obj/item/weapon/implanter/mindslave
	name = "implanter (mind slave)"

/obj/item/weapon/implanter/mindslave/New()
	imp = new /obj/item/weapon/implant/mindslave(src)
	..()
	update_icon()

/obj/item/weapon/implant/gmindslave
	name = "greater mindslave implant"
	desc = "Now YOU too can have your very own mindslave! A more durable version of the mindslave implant. Pop this implant into anybody and they'll obey any command. Doesn't work on fellow Syndicate"
	origin_tech = "materials=2;biotech=5;programming=4"
	activated = 0
	var/datum/objective/protect/protect_objective
	
/obj/item/weapon/implant/gmindslave/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Syndicate Mindslave implant MK1<BR>
				<b>Life:</b> Forever. <BR>
				<b>Important Notes:</b> Personnel injected with this device become loyal to the user and will obey any command.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Allows user to command anyone implanted to do whatever they want.<BR>
				<b>Special Features:</b> Person with implant MUST obey any order you give. <BR>
				<b>Integrity:</b> Implant will last forever."}
	return dat

/obj/item/weapon/implant/gmindslave/implant(mob/target,mob/user)
	if(target.mind)
		if(target == user)
			target <<"<span class='notice'>You can't implant yourself!</span>"
			return 0
		if(isloyal(target))
			target <<"<span class='danger'>Your loyalty implant rejects [user]'s mindslave!</span>"
			user <<"<span class='danger'>[target] somehow rejects the mindslave implant!</span>"
			return 0
		if(target.mind in ticker.mode.traitors)
			target.visible_message("[target] seems to resist the implant!", "You feel a familiar sensation in your head that quickly dissipates.")
			return 0
		if(target.mind in ticker.mode.changelings)
			target.visible_message("[target] seems to resist the implant!", "You feel a familiar sensation in your head that quickly dissipates.")
			return 0
		if(..())
			target << "<span class='notice'>You feel a surge of loyalty towards [user].</span>"
			target << "<span class='userdanger'>You have been mindslaved by [user]! From now on, they are your master. You MUST obey any command given to you and CANNOT harm your master unless they order you to do so.</span>"
			if(!target.mind.special_role)
				target.mind.special_role = "GMindslave"
				ticker.mode.traitors |= target.mind
			protect_objective = new /datum/objective/protect
			protect_objective.owner = target.mind
			protect_objective.target = user.mind
			protect_objective.explanation_text = "Protect and obey [user], your master."
			target.mind.objectives += protect_objective
			message_admins("[user]/([user.ckey]) made a mindslave out of [target]/([target.ckey]).")
			return 1
	user <<"<span class='notice'>[target] has no mind!</span>"
	return 0
	
/obj/item/weapon/implanter/gmindslave/
	name = "implanter (greater mind slave)"
	
/obj/item/weapon/implanter/gmindslave/New()
	imp = new /obj/item/weapon/implant/gmindslave(src)
	..()
	update_icon()