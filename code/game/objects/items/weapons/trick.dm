///////////////////Trick Syndicate Deck of Cards/////////////////

/obj/item/weapon/trickcards
	var/parentdeck = null
	var/deckstyle = "syndicate"
	var/card_hitsound = 'sound/weapons/bladeslice.ogg'
	var/card_force = 5
	var/card_throwforce = 10
	var/card_throw_speed = 3
	var/card_throw_range = 7
	var/card_embed_chance = 0
	var/card_sharpness
	var/list/card_attack_verb = list("attacked")
	
/obj/item/weapon/trickcards/New()
	..()
	
/obj/item/weapon/trickcards/proc/apply_card_vars(obj/item/weapon/trickcards/newobj, obj/item/weapon/trickcards/sourceobj)
	if(!istype(sourceobj))
		return
		
/obj/item/weapon/trickcards/trickdeck
	name = " a suspicious looking deck of tricky cards"
	desc = "A deck of space-grade playing cards. The cards seem to have hidden machinations in them."
	icon = 'icons/obj/toy.dmi'
	deckstyle = "syndicate"
	icon_state = "deck_syndicate_full"
	w_class = 2
	var/cooldown = 0
	var/list/cards = list()

/obj/item/weapon/trickcards/trickdeck/New()
	..()
	icon_state = "deck_[deckstyle]_full"
	for(var/i = 2; i <= 10; i++)
		cards += "[i] of Hearts"
		cards += "[i] of Spades"
		cards += "[i] of Clubs"
		cards += "[i] of Diamonds"
	cards += "King of Hearts"
	cards += "King of Spades"
	cards += "King of Clubs"
	cards += "King of Diamonds"
	cards += "Queen of Hearts"
	cards += "Queen of Spades"
	cards += "Queen of Clubs"
	cards += "Queen of Diamonds"
	cards += "Jack of Hearts"
	cards += "Jack of Spades"
	cards += "Jack of Clubs"
	cards += "Jack of Diamonds"
	cards += "Ace of Hearts"
	cards += "Ace of Spades"
	cards += "Ace of Clubs"
	cards += "Ace of Diamonds"
	
/obj/item/weapon/trickcards/trickdeck/attack_hand(mob/user)
	if(user.lying)
		return
	var/choice = null
	if(cards.len == 0)
		user << "<span class='warning'>There are no more cards to draw!</span>"
		return
	var/obj/item/weapon/trickcards/tricksinglecard/H = new/obj/item/weapon/trickcards/tricksinglecard(user.loc)
	choice = cards[1]
	H.cardname = choice
	H.parentdeck = src
	var/O = src
	H.apply_card_vars(H,O)
	src.cards -= choice
	H.pickup(user)
	user.put_in_hands(H)
	user.visible_message("[user] draws a card from the deck.", "<span class='notice'>You draw a card from the deck.</span>")
	update_icon()
	
/obj/item/weapon/trickcards/trickdeck/update_icon()
	if(cards.len > 26)
		icon_state = "deck_[deckstyle]_full"
	else if(cards.len > 10)
		icon_state = "deck_[deckstyle]_half"
	else if(cards.len > 0)
		icon_state = "deck_[deckstyle]_low"
	else if(!cards.len)
		icon_state = "deck_[deckstyle]_empty"
		
/obj/item/weapon/trickcards/trickdeck/attack_self(mob/user)
	if(cooldown < world.time - 50)
		cards = shuffle(cards)
		playsound(user, 'sound/items/cardshuffle.ogg', 50, 1)
		user.visible_message("[user] shuffles the deck.", "<span class='notice'>You shuffle the deck.</span>")
		cooldown = world.time

/obj/item/weapon/trickcards/trickdeck/attackby(obj/item/weapon/trickcards/I, mob/living/user, params)
	..()
	if(istype(I, /obj/item/weapon/trickcards/tricksinglecard))
		var/obj/item/weapon/trickcards/tricksinglecard/C = I
		if(C.parentdeck == src)
			if(!user.unEquip(C))
				user << "<span class='warning'>The card is stuck to your hand, you can't add it to the deck!</span>"
				return
			src.cards += C.cardname
			user.visible_message("[user] adds a card to the bottom of the deck.","<span class='notice'>You add the card to the bottom of the deck.</span>")
			qdel(C)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"
	if(istype(I, /obj/item/weapon/trickcards/trickcardhand))
		var/obj/item/weapon/trickcards/trickcardhand/C = I
		if(C.parentdeck == src)
			if(!user.unEquip(C))
				user << "<span class='warning'>The hand of cards is stuck to your hand, you can't add it to the deck!</span>"
				return
			src.cards += C.currenthand
			user.visible_message("[user] puts their hand of cards in the deck.", "<span class='notice'>You put the hand of cards in the deck.</span>")
			qdel(C)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"
	update_icon()

/obj/item/weapon/trickcards/trickdeck/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(!ishuman(usr) || usr.incapacitated() || usr.lying)
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			usr << "<span class='notice'>You pick up the deck.</span>"

		else if(istype(over_object, /obj/screen))
			switch(over_object.name)
				if("l_hand")
					if(!remove_item_from_storage(M))
						M.unEquip(src)
					M.put_in_l_hand(src)
				else if("r_hand")
					if(!remove_item_from_storage(M))
						M.unEquip(src)
					M.put_in_r_hand(src)
				usr << "<span class='notice'>You pick up the deck.</span>"
	else
		usr << "<span class='warning'>You can't reach it from here!</span>"
		
/obj/item/weapon/trickcards/trickcardhand
	name = "hand of cards"
	desc = "A number of cards not in a deck, customarily held in ones hand."
	icon = 'icons/obj/toy.dmi'
	icon_state = "syndicate_hand2"
	w_class = 1
	var/list/currenthand = list()
	var/choice = null
	
/obj/item/weapon/trickcards/trickcardhand/attack_self(mob/user)
	user.set_machine(src)
	interact(user)

/obj/item/weapon/trickcards/trickcardhand/interact(mob/user)
	var/dat = "You have:<BR>"
	for(var/t in currenthand)
		dat += "<A href='?src=\ref[src];pick=[t]'>A [t].</A><BR>"
	dat += "Which card will you remove next?"
	var/datum/browser/popup = new(user, "cardhand", "Hand of Cards", 400, 240)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.set_content(dat)
	popup.open()

obj/item/weapon/trickcards/tricksinglecard/throw_impact(mob/living/user)
	if(!..())
		switch(rand(1,20))
			if(1)
				visible_message("<span class='notice'>The card cuts through space!</span>")
				playsound(get_turf(src), 'sound/effects/phasein.ogg', 100, 1, -1)													
				do_teleport(user, user, 20)						
			if(2)
				visible_message("<span class='notice'>The card emits smoke!</span>")
				playsound(get_turf(src), 'sound/effects/bamf.ogg', 100, 1, -1)
				var/datum/effect_system/smoke_spread/smoke = new	
				smoke.set_up(10, user.loc)
				smoke.start()
			if(3)
				visible_message("<span class='notice'>The card shines with a metallic sheen.</span>")
				user.adjustBruteLoss(30)
				playsound(get_turf(src), 'sound/weapons/smash.ogg', 100, 1, -1)							
			if(4)
				visible_message("<span class='notice'>The card emits heat on its surface.</span>")
				user.adjustFireLoss(30)
				playsound(get_turf(src), 'sound/weapons/sear.ogg', 100, 1, -1)				
			if(5)
				visible_message("<span class='notice'>The card emits fire.</span>")
				playsound(get_turf(src), 'sound/effects/fire.ogg', 100, 1, -1)
				var/turf/T = get_turf(user)
				for(var/turf/turf in range(1,T))
					PoolOrNew(/obj/effect/hotspot, turf)
			if(6)
				visible_message("<span class='notice'>The card stops time in the surrounding area.</span>")
				anchored = 1
				name = "chronofield"
				desc = "ZA WARUDO"
				icon = 'icons/effects/160x160.dmi'
				icon_state = "time"
				layer = FLY_LAYER
				pixel_x = -64
				pixel_y = -64
				unacidable = 1
				mouse_opacity = 0
				var/freezerange = 2
				var/duration = 140
				alpha = 125
				playsound(get_turf(src), 'sound/magic/TIMEPARADOX2.ogg', 100, 1, -1)
				while(loc)
					if(duration)
						for(var/mob/living/M in orange (freezerange, user.loc))
							M.stunned = 10
							M.anchored = 1
							user.stunned = 10
							user.anchored = 1
							if(istype(user, /mob/living/simple_animal/hostile))
								var/mob/living/simple_animal/hostile/H = M
								H.AIStatus = AI_OFF
								H.LoseTarget()
								continue
						for(var/obj/item/projectile/P in orange (freezerange, user.loc))
							P.paused = TRUE
						duration --
					else
						for(var/mob/living/M in orange (freezerange+2, user.loc))
							M.stunned = 0
							M.anchored = 0
							user.stunned = 0
							user.anchored = 0
							if(istype(M, /mob/living/simple_animal/hostile))
								var/mob/living/simple_animal/hostile/H = M
								H.AIStatus = initial(H.AIStatus)
								continue
						for(var/obj/item/projectile/P in orange(freezerange+2, user.loc))
							P.paused = FALSE
						qdel(src)
						return
					sleep(1)
			if(7)
				visible_message("<span class='notice'>The card emits an electrostatic discharge.</span>")
				user.electrocute_act(20, src)
				playsound(get_turf(src), 'sound/magic/LightningShock.ogg', 100, 1, -1)
			if(8)
				visible_message("<span class='notice'>The card emits a kinetic force on [user]!</span>")
				user.Stun(2)
				playsound(get_turf(src), 'sound/weapons/resonator_blast.ogg', 100, 1, -1)
				var/atom/throw_user = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				spawn(1)
					user.throw_at(throw_user, 200, 4)
			if(9)
				visible_message("<span class='notice'>The card explodes.</span>")
				explosion(src.loc,-1, 0, 2, 3, 0)
			if(10)
				visible_message("<span class='notice'>The card emits a high frequency vibration.</span>")
				user.Stun(6)
				user.Weaken(6)
				user.stuttering = 6
				playsound(get_turf(src), 'sound/weapons/taserhit.ogg', 100, 1, -1)		
			if(11)
				visible_message("<span class='notice'>The card mysteriously turns into a feral cat.</span>")
				var/deliveryamt = 1
				var/spawner_type = /mob/living/simple_animal/hostile/feral_cat
				if(spawner_type && deliveryamt)
					var/turf/T = get_turf(src)
					playsound(T, 'sound/effects/phasein.ogg', 100, 1)
					for(var/i=1, i<=deliveryamt, i++)
						var/atom/movable/x = new spawner_type
						x.loc = T
			if(12)
				visible_message("<span class='notice'>The card mysteriously vanishes.</span>")
				user.adjustBruteLoss(-10)//takes away damage from throw force
			if(13)
				var/obj/item/weapon/reagent_containers/food/snacks/cookie/C = new(get_turf(src))
				visible_message("<span class='notice'>The card mysteriously turns into a cookie.</span>")	
				C.name = "Cookie of Tricks"
			if(14)
				user.eye_blind = 10
				visible_message("<span class='notice'>The card cuts [user]'s eyes.</span>")
			if(15)
				visible_message("<span class='notice'>The card hits [user]'s throat.</span>")
				user.adjustOxyLoss(-50)
			if(16)
				visible_message("<span class='notice'>The card produces a bang!</span>")
				var/turf/T = get_turf(user)
				for(var/mob/living/M)
					M.show_message("<span class='warning'>BANG</span>", 2)
					playsound(loc, 'sound/effects/bang.ogg', 25, 1)
			
					var/ear_safety = M.check_ear_prot()
					var/distance = max(1,get_dist(src,T))

					if(M.weakeyes)
						M.visible_message("<span class='disarm'><b>[M]</b> screams and collapses!</span>")
						M << "<span class='userdanger'><font size=3>AAAAGH!</font></span>"
						M.Weaken(15) //hella stunned
						M.Stun(15)
						M.eye_stat += 8

					if(M.flash_eyes(affect_silicon = 1))
						M.Stun(max(10/distance, 3))
						M.Weaken(max(10/distance, 3))


					if(!ear_safety)
						M.Stun(max(10/distance, 3))
						M.Weaken(max(10/distance, 3))
						M.setEarDamage(M.ear_damage + rand(0, 5), max(M.ear_deaf,15))
						if (M.ear_damage >= 15)
							M << "<span class='warning'>Your ears start to ring badly!</span>"
							if(prob(M.ear_damage - 10 + 5))
								M << "<span class='warning'>You can't hear anything!</span>"
								M.disabilities |= DEAF
						else
							if (M.ear_damage >= 5)
								M << "<span class='warning'>Your ears start to ring!</span>"
			if(17)
				user.sleeping = 10
				visible_message("<span class='notice'>The card seems to cause sleepiness.</span>")
			if(18)
				visible_message("<span class='notice'>The card seems to cause hallucinations.</span>")	//hallucination sucks so im adding more to stack them up to make them better
				user.hallucination = 10
				user.hallucination = 10
				user.hallucination = 10
				user.hallucination = 10
				user.hallucination = 10
			if(19)
				visible_message("<span class='notice'>The card emits a cold air.</span>")
				user.bodytemperature = 20 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(20)
				visible_message("<span class='notice'>The card emits an electromagnetic pulse.</span>")
				empulse(src, 4, 10)

		
		qdel(src)
		return

obj/item/weapon/trickcards/trickcardhand/throw_impact(mob/living/user)
	if(!..())
		switch(rand(1,20))
			if(1)
				visible_message("<span class='notice'>The card cuts through space!</span>")
				playsound(get_turf(src), 'sound/effects/phasein.ogg', 100, 1, -1)													
				do_teleport(user, user, 20)						
			if(2)
				visible_message("<span class='notice'>The card emits smoke!</span>")
				playsound(get_turf(src), 'sound/effects/bamf.ogg', 100, 1, -1)
				var/datum/effect_system/smoke_spread/smoke = new	
				smoke.set_up(10, user.loc)
				smoke.start()
			if(3)
				visible_message("<span class='notice'>The card shines with a metallic sheen.</span>")
				user.adjustBruteLoss(30)
				playsound(get_turf(src), 'sound/weapons/smash.ogg', 100, 1, -1)							
			if(4)
				visible_message("<span class='notice'>The card emits heat on its surface.</span>")
				user.adjustFireLoss(30)
				playsound(get_turf(src), 'sound/weapons/sear.ogg', 100, 1, -1)				
			if(5)
				visible_message("<span class='notice'>The card emits fire.</span>")
				playsound(get_turf(src), 'sound/effects/fire.ogg', 100, 1, -1)
				var/turf/T = get_turf(user)
				for(var/turf/turf in range(1,T))
					PoolOrNew(/obj/effect/hotspot, turf)
			if(6)
				visible_message("<span class='notice'>The card stops time in the surrounding area.</span>")
				anchored = 1
				name = "chronofield"
				desc = "ZA WARUDO"
				icon = 'icons/effects/160x160.dmi'
				icon_state = "time"
				layer = FLY_LAYER
				pixel_x = -64
				pixel_y = -64
				unacidable = 1
				mouse_opacity = 0
				var/freezerange = 2
				var/duration = 140
				alpha = 125
				playsound(get_turf(src), 'sound/magic/TIMEPARADOX2.ogg', 100, 1, -1)
				while(loc)
					if(duration)
						for(var/mob/living/M in orange (freezerange, user.loc))
							M.stunned = 10
							M.anchored = 1
							user.stunned = 10
							user.anchored = 1
							if(istype(user, /mob/living/simple_animal/hostile))
								var/mob/living/simple_animal/hostile/H = M
								H.AIStatus = AI_OFF
								H.LoseTarget()
								continue
						for(var/obj/item/projectile/P in orange (freezerange, user.loc))
							P.paused = TRUE
						duration --
					else
						for(var/mob/living/M in orange (freezerange+2, user.loc))
							M.stunned = 0
							M.anchored = 0
							user.stunned = 0
							user.stunned = 0
							if(istype(M, /mob/living/simple_animal/hostile))
								var/mob/living/simple_animal/hostile/H = M
								H.AIStatus = initial(H.AIStatus)
								continue
						for(var/obj/item/projectile/P in orange(freezerange+2, user.loc))
							P.paused = FALSE
						qdel(src)
						return
					sleep(1)
			if(7)
				visible_message("<span class='notice'>The card emits an electrostatic discharge.</span>")
				user.electrocute_act(20, src)
				playsound(get_turf(src), 'sound/magic/LightningShock.ogg', 100, 1, -1)
			if(8)
				visible_message("<span class='notice'>The card emits a kinetic force on [user]!</span>")
				user.Stun(2)
				playsound(get_turf(src), 'sound/weapons/resonator_blast.ogg', 100, 1, -1)
				var/atom/throw_user = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				spawn(1)
					user.throw_at(throw_user, 200, 4)
			if(9)
				visible_message("<span class='notice'>The card explodes.</span>")
				explosion(src.loc,-1, 0, 2, 3, 0)
			if(10)
				visible_message("<span class='notice'>The card emits a high frequency vibration.</span>")
				user.Stun(6)
				user.Weaken(6)
				user.stuttering = 6
				playsound(get_turf(src), 'sound/weapons/taserhit.ogg', 100, 1, -1)		
			if(11)
				visible_message("<span class='notice'>The card mysteriously turns into a feral cat.</span>")
				var/deliveryamt = 1
				var/spawner_type = /mob/living/simple_animal/hostile/feral_cat
				if(spawner_type && deliveryamt)
					var/turf/T = get_turf(src)
					playsound(T, 'sound/effects/phasein.ogg', 100, 1)
					for(var/i=1, i<=deliveryamt, i++)
						var/atom/movable/x = new spawner_type
						x.loc = T
			if(12)
				visible_message("<span class='notice'>The card mysteriously vanishes.</span>")
				user.adjustBruteLoss(-10)//takes away damage from throw force
			if(13)
				var/obj/item/weapon/reagent_containers/food/snacks/cookie/C = new(get_turf(src))
				visible_message("<span class='notice'>The card mysteriously turns into a cookie.</span>")	
				C.name = "Cookie of Tricks"
			if(14)
				user.eye_blind = 10
				visible_message("<span class='notice'>The card cuts [user]'s eyes.</span>")
			if(15)
				visible_message("<span class='notice'>The card hits [user]'s throat.</span>")
				user.adjustOxyLoss(-50)
			if(16)
				visible_message("<span class='notice'>The card produces a bang!</span>")
				var/turf/T = get_turf(user)
				for(var/mob/living/M)
					M.show_message("<span class='warning'>BANG</span>", 2)
					playsound(loc, 'sound/effects/bang.ogg', 25, 1)
			
					var/ear_safety = M.check_ear_prot()
					var/distance = max(1,get_dist(src,T))

					if(M.weakeyes)
						M.visible_message("<span class='disarm'><b>[M]</b> screams and collapses!</span>")
						M << "<span class='userdanger'><font size=3>AAAAGH!</font></span>"
						M.Weaken(15) //hella stunned
						M.Stun(15)
						M.eye_stat += 8

					if(M.flash_eyes(affect_silicon = 1))
						M.Stun(max(10/distance, 3))
						M.Weaken(max(10/distance, 3))


					if(!ear_safety)
						M.Stun(max(10/distance, 3))
						M.Weaken(max(10/distance, 3))
						M.setEarDamage(M.ear_damage + rand(0, 5), max(M.ear_deaf,15))
						if (M.ear_damage >= 15)
							M << "<span class='warning'>Your ears start to ring badly!</span>"
							if(prob(M.ear_damage - 10 + 5))
								M << "<span class='warning'>You can't hear anything!</span>"
								M.disabilities |= DEAF
						else
							if (M.ear_damage >= 5)
								M << "<span class='warning'>Your ears start to ring!</span>"
			if(17)
				user.sleeping = 10
				visible_message("<span class='notice'>The card seems to cause sleepiness.</span>")
			if(18)
				visible_message("<span class='notice'>The card seems to cause hallucination.</span>")	//hallucination sucks so im adding more to stack them up to make them better
				user.hallucination = 10
				user.hallucination = 10
				user.hallucination = 10
				user.hallucination = 10
				user.hallucination = 10
			if(19)
				visible_message("<span class='notice'>The card emits a cold air.</span>")
				user.bodytemperature = 20 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(20)
				visible_message("<span class='notice'>The card emits an electromagnetic pulse.</span>")
				empulse(src, 4, 10)

		
		qdel(src)
		return

	
/obj/item/weapon/trickcards/trickcardhand/Topic(href, href_list)
	if(..())
		return
	if(usr.stat || !ishuman(usr))
		return
	var/mob/living/carbon/human/cardUser = usr
	var/O = src
	if(href_list["pick"])
		if (cardUser.get_item_by_slot(slot_l_hand) == src || cardUser.get_item_by_slot(slot_r_hand) == src)
			var/choice = href_list["pick"]
			var/obj/item/weapon/trickcards/tricksinglecard/C = new/obj/item/weapon/trickcards/tricksinglecard(cardUser.loc)
			src.currenthand -= choice
			C.parentdeck = src.parentdeck
			C.cardname = choice
			C.apply_card_vars(C,O)
			C.pickup(cardUser)
			cardUser.put_in_any_hand_if_possible(C)
			cardUser.visible_message("<span class='notice'>[cardUser] draws a card from \his hand.</span>", "<span class='notice'>You take the [C.cardname] from your hand.</span>")

			interact(cardUser)
			if(src.currenthand.len < 3)
				src.icon_state = "[deckstyle]_hand2"
			else if(src.currenthand.len < 4)
				src.icon_state = "[deckstyle]_hand3"
			else if(src.currenthand.len < 5)
				src.icon_state = "[deckstyle]_hand4"
			if(src.currenthand.len == 1)
				var/obj/item/weapon/trickcards/tricksinglecard/N = new/obj/item/weapon/trickcards/tricksinglecard(src.loc)
				N.parentdeck = src.parentdeck
				N.cardname = src.currenthand[1]
				N.apply_card_vars(N,O)
				cardUser.unEquip(src)
				N.pickup(cardUser)
				cardUser.put_in_any_hand_if_possible(N)
				cardUser << "<span class='notice'>You also take [currenthand[1]] and hold it.</span>"
				cardUser << browse(null, "window=cardhand")
				qdel(src)
		return

/obj/item/weapon/trickcards/trickcardhand/attackby(obj/item/weapon/trickcards/tricksinglecard/C, mob/living/user, params)
	if(istype(C))
		if(C.parentdeck == src.parentdeck)
			src.currenthand += C.cardname
			user.unEquip(C)
			user.visible_message("[user] adds a card to their hand.", "<span class='notice'>You add the [C.cardname] to your hand.</span>")
			interact(user)
			if(currenthand.len > 4)
				src.icon_state = "[deckstyle]_hand5"
			else if(currenthand.len > 3)
				src.icon_state = "[deckstyle]_hand4"
			else if(currenthand.len > 2)
				src.icon_state = "[deckstyle]_hand3"
			qdel(C)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"
			
/obj/item/weapon/trickcards/trickcardhand/apply_card_vars(obj/item/weapon/trickcards/newobj,obj/item/weapon/trickcards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "[deckstyle]_hand2" 
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	if(sourceobj.burn_state == -1)
		newobj.burn_state = -1
		
/obj/item/weapon/trickcards/tricksinglecard
	name = "card"
	desc = "a card"
	icon = 'icons/obj/toy.dmi'
	icon_state = "singlecard_syndicate_down"
	w_class = 1
	var/cardname = null
	var/flipped = 0
	pixel_x = -5
	
/obj/item/weapon/trickcards/tricksinglecard/examine(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/cardUser = user
		if(cardUser.get_item_by_slot(slot_l_hand) == src || cardUser.get_item_by_slot(slot_r_hand) == src)
			cardUser.visible_message("[cardUser] checks \his card.", "<span class='notice'>The card reads: [src.cardname]</span>")
		else
			cardUser << "<span class='warning'>You need to have the card in your hand to check it!</span>"
			
/obj/item/weapon/trickcards/tricksinglecard/verb/Flip()
	set name = "Flip Card"
	set category = "Object"
	set src in range(1)
	if(usr.stat || !ishuman(usr) || usr.restrained())
		return
	if(!flipped)
		src.flipped = 1
		if (cardname)
			src.icon_state = "sc_[cardname]_[deckstyle]"
			src.name = src.cardname
		else
			src.icon_state = "sc_Ace of Spades_[deckstyle]"
			src.name = "What Card"
		src.pixel_x = 5
	else if(flipped)
		src.flipped = 0
		src.icon_state = "singlecard_down_[deckstyle]"
		src.name = "card"
		src.pixel_x = -5
		
/obj/item/weapon/trickcards/tricksinglecard/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/trickcards/tricksinglecard/))
		var/obj/item/weapon/trickcards/tricksinglecard/C = I
		if(C.parentdeck == src.parentdeck)
			var/obj/item/weapon/trickcards/trickcardhand/H = new/obj/item/weapon/trickcards/trickcardhand(user.loc)
			H.currenthand += C.cardname
			H.currenthand += src.cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			user.unEquip(C)
			H.pickup(user)
			user.put_in_active_hand(H)
			user << "<span class='notice'>You combine the [C.cardname] and the [src.cardname] into a hand.</span>"
			qdel(C)
			qdel(src)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"
			
	if(istype(I, /obj/item/weapon/trickcards/trickcardhand/))
		var/obj/item/weapon/trickcards/trickcardhand/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.unEquip(src)
			user.visible_message("[user] adds a card to \his hand.", "<span class='notice'>You add the [cardname] to your hand.</span>")
			H.interact(user)
			if(H.currenthand.len > 4)
				H.icon_state = "[deckstyle]_hand5"
			else if(H.currenthand.len > 3)
				H.icon_state = "[deckstyle]_hand4"
			else if(H.currenthand.len > 2)
				H.icon_state = "[deckstyle]_hand3"
			qdel(src)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"

/obj/item/weapon/trickcards/tricksinglecard/attack_self(mob/user)
	if(usr.stat || !ishuman(usr) || usr.restrained())
		return
	Flip()
	
/obj/item/weapon/trickcards/tricksinglecard/apply_card_vars(obj/item/weapon/trickcards/tricksinglecard/newobj,obj/item/weapon/trickcards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "singlecard_down_[deckstyle]"
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.hitsound = newobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.force = newobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.throwforce = newobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.throw_speed = newobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.throw_range = newobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.attack_verb = newobj.card_attack_verb
	newobj.card_embed_chance = sourceobj.card_embed_chance
	newobj.embed_chance = newobj.card_embed_chance
	newobj.card_sharpness = sourceobj.card_sharpness
	newobj.sharpness = newobj.card_sharpness
