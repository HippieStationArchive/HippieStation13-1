/obj/item/weapon/katana/samurai
	name = "samurai katana"
	var/blood
	var/reward = 0 //The stage of the rewards
	var/mob/living/person
	var/fullupgrade = 0
	force = 13

	afterattack(atom/A, mob/user as mob)
		if(istype(A,/mob/living/carbon/human))
			var/mob/living/S = A
			if(!person)
				person = user
			if(user == person)
				if(!S.stat == 0)
					if(!fullupgrade)
						person << "There is no honor in bathing your blade in a dead opponent's blood!"
						return
					else
						if(S.client)
							var/mob/living/simple_animal/hostile/skel/X = new/mob/living/simple_animal/hostile/skel
							X.loc = S.loc
							X.client = S.client
							X << "You now serve [user.name] as a skeletal minion. Do as they say."
							del(S)
						else
							user << "This will not work on this person."

				blood += rand(5,100)
				if(blood >= 600 && blood <= 1200 && reward == 0)
					person << "Your katanas thirst for blood gives you the 'Charge!' ability!"
					reward = 1
				if(blood >= 1101 && blood <= 2000 && reward == 1)
					person << "Your katanas thirst for blood coats your blade in Poisoned Sake!"
					reward = 2
				if(blood >= 2201 && blood <= 3000 && reward == 3)
					person << "Your katanas thirst for blood gives you the 'Inspiration' ability!"

					reward = 3
				if(blood >= 3101 && blood <= 4000 && reward == 4)
					person << "Your katana heats up from the amount of blood on it increasing its damage!"
					reward = 4
					force = 40
				if(blood >= 4101 && blood <= 5000 && reward == 5)
					person << "Your katana's thirst for blood gives it the ability to seal a person's soul!"
					reward = 5
				if(blood >= 7101 && blood <= 8000 && reward == 6)
					person << "Your katana is fully powered and will now anyone you kill as a skeletal minion."
					reward = 6
					fullupgrade = 1

	////////////Sword effects
				if(reward >= 2)
					S.reagents.add_reagent("toxin", 1)
				if(reward >=5)
					if(!locate(NOCLONE, S.mutations))
						S.mutations |= NOCLONE
						S << "You feel your soul shattered"
	process()
		if(blood >= 200)
			blood -= rand(5,15)