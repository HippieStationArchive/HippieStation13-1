/obj/item/stack/staples
	name = "Staples"
	singular_name = "Staple"
	desc = "Staples for use with staplegun."
	icon = 'icons/obj/staples.dmi'
	icon_state = "staples"
	item_state = "staples"
	force = 0
	throw_speed = 2
	throw_range = 7
	throwforce = 1  //Why the fuck did this have 10 throwforce?
	w_class = 1
	materials = list(MAT_METAL = 100)
	max_amount = 10

/obj/item/stack/staples/New(var/loc, var/amount=null)
	update_icon()
	return ..()

/obj/item/stack/staples/update_icon()
	if(get_amount() <= 1)
		icon_state = "staple"
		name = "Staple"
	else
		icon_state = "staples"
		name = "Staples"

/obj/item/weapon/staplegun
	name = "Staple gun"
	desc = "Insert paper you want to staple and then use the gun on a wall/floor. CAUTION: Don't use on people."
	icon = 'icons/obj/staples.dmi'
	icon_state = "staplegun"
	force = 0
	stamina_percentage = 0.5
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	w_class = 2
	var/ammo = 5
	var/max_ammo = 10
	var/obj/item/weapon/paper/P = null //TODO: Make papers attachable to people
	var/obj/item/organ/internal/butt/B = null

/obj/item/weapon/staplegun/New()
	..()
	update_icon()

/obj/item/weapon/staplegun/examine()
	..()
	usr << "It contains [ammo]/[max_ammo] staples."
	if(istype(P))
		usr << "There's [P] loaded in it."
	if(istype(B))
		usr << "There's... a butt loaded in it?What."

/obj/item/weapon/staplegun/update_icon()
	var/amt = max(0, min(round(ammo/1.5), 6))
	overlays.Cut()
	overlays += icon(icon, "[icon_state][amt]")

/obj/item/weapon/staplegun/attack(mob/living/target, mob/living/user)
	if(ammo <= 0)
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
		return

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(user.zone_sel.selecting =="groin")
			if(!H.w_uniform)
				if(!(/obj/item/organ/internal/butt in H.internal_organs))
					if(istype(B))
						B.Insert(target)
						if(target == user)
							user.visible_message("<span class='danger'>[user] staples his butt back on his groin!</span>", "<span class='userdanger'>You staple your butt back on, but it looks loose!</span>")
						else
							user.visible_message("<span class='danger'>[user] staples the butt back on [H]'s groin!</span>", "<span class='userdanger'>You staple the butt back on [H]'s groin, but it looks loose!</span>")
						B.loose = 1
						B = null
				else
					if(target == user)
						user << "<span class='danger'>You already have a butt!</span>"
					else
						user << "<span class='danger'>[H] already has a butt!</span>"
					return 0
			else
				if(target == user)
					user << "<span class='danger'>You must remove your jumpsuit before doing that!</span>"
				else
					user << "<span class='danger'>You must remove his jumpsuit before doing that!</span>"
				return 0
		var/obj/item/organ/limb/O = H.get_organ(ran_zone(check_zone(user.zone_sel.selecting), 65))
		var/armor = H.run_armor_check(O, "melee")
		if(armor <= 40 && istype(O))
			H.throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
			if(istype(P)) //If the staplegun contains paper...
				P.loc = H
				P.update_icon()
				O.embedded_objects |= P
				P.add_blood(H)//it embedded itself in you, of course it's bloody!
				O.take_damage(P.w_class*P.embedded_impact_pain_multiplier)
				P = null
			else
				var/obj/item/stack/staples/S = new /obj/item/stack/staples(H, 1)
				O.embedded_objects |= S
				S.add_blood(H)//it embedded itself in you, of course it's bloody!
				O.take_damage(S.w_class*S.embedded_impact_pain_multiplier)
			H.apply_damage(2, BRUTE, O, armor)
			H.update_damage_overlays()

			H.attack_log += "\[[time_stamp()]\] <font color='red'>Has been stapled by [usr.name]([usr.ckey]) @ [H.x],[H.y],[H.z]</font>" //cheesy attack log bug fix

			usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has stapled [target.name]([target.ckey]) @ [usr.x],[usr.y],[usr.z]</font>"

			visible_message("<span class='danger'>[user] has stapled [target] in the [O]!</span>",
							"<span class='userdanger'>[user] has stapled [target] in the [O]!</span>")
		else
			visible_message("<span class='danger'>[user] has attempted to staple [target] in the [O]!</span>",
				"<span class='userdanger'>[user] has attempted to staple [target] in the [O]!</span>")
	else
		target.adjustBruteLoss(5) //Just harm 'em

		usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has stapled [target.name]([target.ckey]) @ [usr.x],[usr.y],[usr.z]</font>" //cheesy attack log bug fix

		target.attack_log += "\[[time_stamp()]\] <font color='red'>Has been stapled by [usr.name]([usr.ckey]) @ [target.x],[target.y],[target.z]</font>"

		visible_message("<span class='danger'>[user] has stapled [target]!</span>",
						"<span class='userdanger'>[user] has stapled [target]!</span>")

	playsound(user, 'sound/weapons/staplegun.ogg', 50, 1)
	ammo -= 1
	update_icon()

/obj/item/weapon/staplegun/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(ammo <= 0)
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
		return

	if(istype(P))
		if(isturf(target))
			var/turf/T = target
			playsound(T, 'sound/weapons/staplegun.ogg', 50, 1)
			user.visible_message("<span class='danger'>[user] has stapled [P] into the [target]!</span>")
			P.loc = T
			P.attached = T
			P.flags |= NODROP //Make the paper appear stapled
			P.anchored = 1 //like why would you want to pull this around
			P.update_icon() //Since it has attached var set it'll add a staple overlay to it
			P = null
			ammo -= 1
			update_icon()

/obj/item/weapon/staplegun/attack_self(mob/user) //TODO: Take out staples in a stack if there's no paper
	if(istype(P))
		user << "<span class='notice'>You take out \the [P] out of \the [src]."
		P.loc = user.loc
		P = null

/obj/item/weapon/staplegun/attackby(obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/staples))
		if(ammo < max_ammo)
			var/obj/item/stack/staples/S = I
			var/amt = max_ammo - ammo
			if(S.amount < amt)
				amt = S.amount
			S.amount -= amt
			if (S.amount <= 0)
				user.unEquip(S, 1)
				qdel(S)
			ammo += amt
			update_icon()
			user << "<span class='notice'>You insert [amt] staples in \the [src]. Now it contains [ammo] staples."
		else
			user << "<span class='notice'>\The [src] is already full!</span>"

	if(istype(I, /obj/item/weapon/paper))
		if(!istype(P))
			user.drop_item()
			I.loc = src
			P = I
			user << "<span class='notice'>You put \the [P] in \the [src]."
		else
			user << "<span class='notice'>There is already a paper in \the [src]!"
	if(istype(I, /obj/item/organ/internal/butt))
		if(!istype(P))
			if(!istype(B))
				user.drop_item()
				I.loc = src
				B = I
				user << "<span class='notice'>You put \the [B] in \the [src].</span>"
			else
				user << "<span class='notice'>There is already a butt in \the [src]!</span>"
		else
			user << "<span class='notice'>There is already a paper in \the [src]!</span>"
