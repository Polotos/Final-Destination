/obj/structure/ship_munition/ammobox/minigun
	name = "57mm RP ammo box"
	desc = "Ammo box that contains 57mm rocket-propelled rounds."
	icon_state = "crate_closed_ammo"
	ammo_count = 420
	ammo_type = /obj/item/projectile/bullet/minigun

/obj/structure/ship_munition/ammobox/minigun/high_explosive
	name = "57mm RP-HE ammo box"
	desc = "Ammo box that contains 57mm rocket-propelled high explosive rounds."
	ammo_type = /obj/item/projectile/bullet/minigun/high_explosive

/obj/item/projectile/bullet/minigun
	name = "minigun bullet"
	icon_state= "bolter"
	damage = 300
	damage_flags = DAM_BULLET | DAM_SHARP | DAM_EDGE
	armor_penetration = 30
	muzzle_type = null
	fire_sound = null
	distance_falloff = 0.1
	life_span = 200
	var/explosion_radius = 5
	var/explosion_max_power = EX_ACT_HEAVY

	var/exploded = FALSE

/obj/item/projectile/bullet/minigun/high_explosive/Bump(atom/A as mob|obj|turf|area, forced=0)
	var/backwards = turn(dir, 180)
	if(!exploded)
		exploded = TRUE
		explosion(get_step(get_turf(A), backwards), explosion_radius, explosion_max_power, adminlog = 0)
		qdel(src)