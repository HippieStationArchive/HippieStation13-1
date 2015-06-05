var/global/obj/structure/samurai/crystal/crystal = null

/obj/screen/samurai/skill1
	name = "Samurai Crystal"
	icon ='icons/vehicles/starship.dmi'
	icon_state="fire1"
	screen_loc = "1,4"
	var/canfire = 1
	var/crystalexists = 0

	DblClick()
		if(canfire)
			if(!crystalexists)
				usr << "You place down a crystal."
				var/obj/structure/samurai/crystal/C = new/obj/structure/samurai/crystal
				C.loc = usr.loc
				crystal = C
				crystalexists = 1
				crystal.samurai = usr
				return
			else
				icon_state="fire2"
				for(var/mob/living/C in range(3,usr))
					if(usr in range(4,crystal))
						if(C.stat == 2)
							C.soul()
							usr << "Soul captured."
			//	else
			//		usr << "No bodies nearby or not near the crystal."
				canfire = 0
				spawn(100)
					icon_state="fire1"
					usr << "Soul Removal is now ready"
					canfire = 1




/obj/screen/samurai/skill2
	name = "Recall"
	icon ='icons/vehicles/starship.dmi'
	icon_state="crane1"
	screen_loc = "1,5"
	var/canfire = 1
	var/crystalexists = 0

	DblClick()
		if(canfire)
			if(crystal)
				if(crystal.souls >= 1)
					usr.loc = crystal.loc
					usr << "You recall back to your Crystal."
					crystal.souls--
					crystal.soulremove()
					crystal.desc = "A crystal that houses souls of the dead. It currently houses [crystal.souls]."
					icon_state="crane2"
				spawn(100)
					icon_state="crane1"
					usr << "Recall is now ready."
					canfire = 1




/mob/proc/soul()


	var/mob/new_mob = new/mob/living/soul(src.loc)

	new_mob.key = key
	new_mob.a_intent = "hurt"
	new_mob << "Your soul has been trapped."

	crystal.contents.Add(new_mob)
	crystal.trapped.Add(new_mob)
	new_mob.canmove = 0
	new_mob.name = "Soul of [real_name]"
	new_mob.real_name = "Soul of [real_name]"
	crystal.luminosity++
	crystal.souls++
	crystal.desc = "A crystal that houses souls of the dead. It currently houses [crystal.souls]."
	del(src)

/mob/living/soul/mind_initialize()
	..()
	mind.assigned_role = "Soul"
	mind.special_role = ""
/mob/living/soul/verb/tracksamurai()
	var/switching = 0
	switch(switching)
		if(0)
			client.eye = crystal.samurai
		//	client.virtual_eye = crystal.samurai
			src << "You switch to viewing the Samurai"
			switching++
		if(1)
			client.eye = src
		//	client.virtual_eye = crystal.samurai
			src << "You switch to viewing the crystal."
			switching--
/obj/structure/samurai/crystal
	name = "Pylon"
	desc = "A crystal that houses souls of the dead."
	icon_state = "pylon"
	luminosity = 5
	icon = 'icons/obj/cult.dmi'
	var/souls = 0
	var/list/trapped = list()
	var/mob/living/carbon/samurai = null

/obj/structure/samurai/crystal/proc/soulremove()
	luminosity--
	for(var/mob/living/soul/C in src)
		trapped.Add(C)
	var/mob/living/soul/D = pick(trapped)
	D.loc = src.loc
	var/list/stuff = list("NOOOO!", "MY EXISTANCE!", "GOODBYE CRUEL WORLD!")
	D.say(pick(stuff))
	spawn(1)
		D.ghostize(D)
		spawn(1)
			del(D)
