/obj/item/missile_equipment/payload/nuclear
	name = "tactical nuclear warhead"
	desc = "An incredibly dangerous warhead. Detonates when the missile is triggered."
	icon_state = "ion"
	hull_damage = 80

/obj/item/missile_equipment/payload/nuclear/on_trigger(var/atom/triggerer)
	var/list/relevant_z = GetConnectedZlevels(loc.z)

	for(var/mob/living/M in GLOB.player_list)
		var/turf/T = get_turf(M)
		if(!T || !(T.z in relevant_z))
			continue
		to_chat("<font size='4' color='red'><b>Suddenly a bright blinding flash appears in nearby outer space, followed by a deadly shockwave!</b></font>")
		if(M.eyecheck() < FLASH_PROTECTION_MAJOR)
			M.flash_eyes()
			M.updatehealth()
		if(!isdeaf(M)) //Meanwhile front might have exploded
			sound_to(M, sound('sound/effects/explosionfar.ogg'))

	if(istype(triggerer, /obj/effect/shield))
		explosion(get_turf(src), 64, EX_ACT_DEVASTATING, turf_breaker = TRUE)
		empulse(get_turf(src), rand(20,40), rand(50,80))
	else
		SSradiation.radiate(get_turf(triggerer), 40)
		explosion(get_turf(triggerer), 64, EX_ACT_DEVASTATING, turf_breaker = TRUE)
		empulse(get_turf(triggerer), rand(20,40), rand(50,80))

	..()

/obj/item/missile_equipment/payload/doomsday //adminbus
	name = "doomsday warhead"
	desc = "An incredibly dangerous warhead. Detonates when the missile is triggered."
	icon_state = "nuclear"
	hull_damage = 400

/obj/item/missile_equipment/payload/doomsday/on_trigger(var/atom/triggerer)
	var/list/relevant_z = GetConnectedZlevels(loc.z)

	for(var/mob/living/M in GLOB.player_list)
		var/turf/T = get_turf(M)
		if(!T || !(T.z in relevant_z))
			continue
		to_chat("<font size='5' color='red'><b>Your doomsday is calling...</b></font>")
		if(M.eyecheck() < FLASH_PROTECTION_MAJOR)
			M.flash_eyes()
			M.updatehealth()
		if(!isdeaf(M)) //Meanwhile front might have exploded
			sound_to(M, sound('sound/effects/explosionfar.ogg'))

	if(istype(triggerer, /obj/effect/shield))
		explosion(get_turf(src), 300, EX_ACT_DEVASTATING, turf_breaker = TRUE)
		empulse(get_turf(src), rand(50,75), rand(75,100))
	else
		SSradiation.radiate(get_turf(triggerer), 400)
		explosion(get_turf(triggerer), 300, EX_ACT_DEVASTATING, turf_breaker = TRUE)
		empulse(get_turf(triggerer), rand(50,75), rand(75,100))

	..()