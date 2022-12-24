/obj/item/psyarrow
	name = "psionic projectile"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/psychic_powers.dmi'
	icon_state = "tinker"
	throwforce = 8
	w_class = ITEM_SIZE_NORMAL
	sharp = TRUE
	var/mob/living/owner

/obj/item/psyarrow/proc/removed(mob/user)
	sleep(2)
	qdel(src)

/obj/item/psyarrow/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom))
		qdel(src)
	sleep(10)
	qdel(src)

/obj/item/psyarrow/master
	throwforce = 12

/obj/item/psyarrow/master/grand
	throwforce = 14

/obj/item/psyarrow/master/grand/paramount
	throwforce = 16

/obj/item/gun/launcher/crossbow/psibow
	name = "psychokinetic bow"
	icon = 'icons/obj/guns/crossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow-solid"
	atom_flags = 0
	color = "#0095ff"
	alpha = 100
	anchored = TRUE
	release_speed = 6
	bolt = new/obj/item/psyarrow
	var/maintain_cost = 2
	var/mob/living/owner
	draw_time = 10

/obj/item/gun/launcher/crossbow/psibow/master
	bolt = new/obj/item/psyarrow/master
	draw_time = 8
	maintain_cost = 3

/obj/item/gun/launcher/crossbow/psibow/master/grand
	bolt = new/obj/item/psyarrow/master/grand
	draw_time = 6
	maintain_cost = 4

/obj/item/gun/launcher/crossbow/psibow/master/grand/paramount
	bolt = new/obj/item/psyarrow/master/grand/paramount
	draw_time = 4
	maintain_cost = 5

/obj/item/gun/launcher/crossbow/psibow/New(var/mob/living/_owner)
	owner = _owner
	if(!istype(owner))
		qdel(src)
		return
	START_PROCESSING(SSprocessing, src)
	..()

/obj/item/gun/launcher/crossbow/psibow/attack_self(mob/living/user as mob)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
			bolt.dropInto(loc)
			var/obj/item/psyarrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/psibow/Destroy()
	if(istype(owner) && owner.psi)
		LAZYREMOVE(owner.psi.manifested_items, src)
		UNSETEMPTY(owner.psi.manifested_items)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/gun/launcher/crossbow/psibow/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/gun/launcher/crossbow/psibow/attack(var/mob/living/M, var/mob/living/user, var/target_zone)
	if(M.do_psionics_check(max(force, maintain_cost), user))
		to_chat(user, "<span class='danger'>\The [src] flickers violently out of phase!</span>")
		return 1
	. = ..()

/obj/item/gun/launcher/crossbow/psibow/afterattack(var/atom/target, var/mob/living/user, var/proximity)
	if(target.do_psionics_check(max(force, maintain_cost), user))
		to_chat(user, "<span class='danger'>\The [src] flickers violently out of phase!</span>")
		return
	. = ..(target, user, proximity)

/obj/item/gun/launcher/crossbow/psibow/dropped()
	..()
	qdel(src)

/obj/item/gun/launcher/crossbow/psibow/Process()
	if(istype(owner))
		owner.psi.spend_power(maintain_cost)
	if(!owner || owner.do_psionics_check(maintain_cost, owner) || loc != owner || (owner.l_hand != src && owner.r_hand != src))
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		else
			STOP_PROCESSING(SSprocessing, src)
