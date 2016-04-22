/obj/vehicle/proc/take_damage(amount, type="brute")
	if(amount)
		var/damage = absorbDamage(amount,type)
		health -= damage
		update_health()

/obj/vehicle/bullet_act(obj/item/projectile/Proj)
	if(Proj.nodamage)
		return
	take_damage(Proj.force,Proj.damtype)

/obj/vehicle/proc/update_health()
	if(src.health > 0)

	else
		qdel(src)

/obj/vehicle/proc/absorbDamage(damage,damage_type)
	var/coeff = 1
	var/obj/item/vehicle_parts/armor/A = locate() in parts
	if(!A)
		return damage*coeff
	else if(A.vehicle_armor[damage_type])
		coeff = A.vehicle_armor[damage_type]
	return damage*coeff