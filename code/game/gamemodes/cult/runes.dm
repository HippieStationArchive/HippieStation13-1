var/list/sacrificed = list()
var/list/non_revealed_runes = (typesof(/obj/effect/rune) - /obj/effect/rune/malformed - /obj/effect/rune )

/*

This file contains runes.
Runes are used by the cult to cause many different effects and are paramount to their success.
They are drawn with an arcane tome in blood, and are distinguishable to cultists and normal crew by examining.
Fake runes can be drawn in crayon to fool people.
Runes can either be invoked by one's self or with many different cultists. Each rune has a specific incantation that the cultists will say when invoking it.

To draw a rune, use an arcane tome and enter the words required. These words are in the tongue of the Geometer and must be entered as such.
Word definitions:
"ire" is Travel
"ego" is Self
"nahlizet" is Blood
"certum" is Join
"veri" is Hell
"jatkaa" is Other
"mgar" is Destroy
"balaq" is Technology
"karazet" is See
"geeri" is Hide

*/

/obj/effect/rune
	name = "rune"
	var/cultist_name = "basic rune"
	desc = "An odd collection of symbols drawn in what seems to be blood."
	var/cultist_desc = "A basic rune with no function." //This is shown to cultists who examine the rune in order to determine its true purpose.
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	unacidable = 1
	layer = TURF_LAYER
	color = rgb(255,0,0)
	mouse_opacity = 2

	var/invocation = "Aiy ele-mayo!" //This is said by cultists when the rune is invoked.
	var/grammar //This is only framework at the moment, but may be required to draw runes in the future
	var/req_cultists = 1 //The amount of cultists required around the rune to invoke it. If only 1, any cultist can invoke it.

	var/req_pylons = 0
	var/req_forges = 0
	var/req_archives = 0
	var/req_altars = 0

	var/req_keyword = 0 //If the rune requires a keyword - go figure amirite
	var/keyword //The actual keyword for the rune

/obj/effect/rune/examine(mob/user)
	..()
	if(iscultist(user) || user.stat == DEAD) //If they're a cultist or a ghost, tell them the effects
		user << "<b>Name:</b> [cultist_name]"
		user << "<b>Effects:</b> [cultist_desc]"
		//user << "<b>Words:</b> [grammar]"
		user << "<b>Required Acolytes:</b> [req_cultists]"
		if(req_keyword && keyword)
			user << "<b>Keyword:</b> [keyword]"

/obj/effect/rune/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/weapon/tome) && iscultist(user))
		user << "<span class='notice'>You carefully erase [src].</span>"
		qdel(src)
		return
	else if(istype(I, /obj/item/weapon/nullrod))
		user << "<span class='notice'>You disrupt the magic with [I].</span>"
		qdel(src)
		return
	return

/obj/effect/rune/attack_hand(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	if(!iscultist(user))
		user << "<span class='warning'>You aren't able to understand the words of [src].</span>"
		return
	if(can_invoke(user))
		invoke(user)
	else
		fail_invoke(user)

/*

There are a few different procs each rune runs through when a cultist activates it.
can_invoke() is called when a cultist activates the rune with an empty hand. If there are multiple cultists, this rune determines if the required amount is nearby.
invoke() is the rune's actual effects.
fail_invoke() is called when the rune fails, via not enough people around or otherwise. Typically this just has a generic 'fizzle' effect.
structure_check() searches for nearby cultist structures required for the invocation. Proper structures are pylons, forges, archives, and altars.

*/

/obj/effect/rune/proc/can_invoke(var/mob/living/user)
	//This proc determines if the rune can be invoked at the time. If there are multiple required cultists, it will find all nearby cultists.
	if(!structure_check(req_pylons, req_forges, req_archives, req_altars))
		return 0
	if(!keyword && req_keyword)
		return 0
	if(req_cultists <= 1)
		if(invocation)
			user.say(invocation)
		return 1
	else
		var/cultists_in_range = 0
		for(var/mob/living/L in range(1, src))
			if(iscultist(L))
				var/mob/living/carbon/human/H = L
				if(!istype(H))
					if(istype(L, /mob/living/simple_animal/construct))
						if(invocation)
							L.say(invocation)
						cultists_in_range++
					continue
				if(L.stat || (H.disabilities & MUTE) || H.silent)
					continue
				if(invocation)
					L.say(invocation)
				cultists_in_range++
		if(cultists_in_range >= req_cultists)
			return 1
		else
			return 0

/obj/effect/rune/proc/invoke(var/mob/living/user)
	//This proc contains the effects of the rune as well as things that happen afterwards. If you want it to spawn an object and then delete itself, have both here.

/obj/effect/rune/proc/fail_invoke(var/mob/living/user)
	//This proc contains the effects of a rune if it is not invoked correctly, through either invalid wording or not enough cultists. By default, it's just a basic fizzle.
	visible_message("<span class='warning'>The markings pulse with a small flash of red light, then fall dark.</span>")

/obj/effect/rune/proc/structure_check(var/rpylons, var/rforges, var/rarchives, var/raltars)
	var/pylons = 0
	var/forges = 0
	var/archives = 0
	var/altars = 0
	for(var/obj/structure/cult/pylon in orange(3,src))
		pylons++
	for(var/obj/structure/cult/forge in orange(3,src))
		forges++
	for(var/obj/structure/cult/tome in orange(3,src))
		archives++
	for(var/obj/structure/cult/talisman in orange(3,src))
		altars++
	if(pylons >= rpylons && forges >= rforges && archives >= rarchives && altars >= raltars)
		return 1
	return 0


//Malformed Rune: This forms if a rune is not drawn correctly. Invoking it does nothing but hurt the user.
/obj/effect/rune/malformed
	cultist_name = "malformed rune"
	cultist_desc = "A senseless rune written in gibberish. No good can come from invoking this."
	invocation = "Ra'sha yoka!"
	grammar = "N/A"

/obj/effect/rune/malformed/New()
	..()
	icon_state = "[rand(1,6)]"
	color = rgb(rand(0,255), rand(0,255), rand(0,255))

/obj/effect/rune/malformed/invoke(mob/living/user)
	user << "<span class='warning'><b>You feel your life force draining. The Geometer is displeased.</b></span>"
	user.apply_damage(30, BRUTE)
	qdel(src)

/mob/proc/null_rod_check() //The null rod, if equipped, will protect the holder from the effects of most runes
	var/obj/item/weapon/nullrod/N = locate() in src
	if(N)
		return 1
	return 0

var/list/teleport_runes = list()
//Rite of Translocation: Warps the user to a random teleport rune with the same keyword.
/obj/effect/rune/teleport
	cultist_name = "Teleport"
	cultist_desc = "Warps the user to a random rune of the same keyword."
	invocation = "Sas'so c'arta forbici!"
	icon_state = "2"
	color = rgb(0, 0, 255)
	grammar = "ire ego"
	req_keyword = 1

/obj/effect/rune/teleport/New()
	..()
	teleport_runes.Add(src)

/obj/effect/rune/teleport/Destroy()
	teleport_runes.Remove(src)
	..()

/obj/effect/rune/teleport/invoke(mob/living/user)
	var/list/potential_runes = list()
	for(var/obj/effect/rune/teleport/T in teleport_runes)
		if(T.keyword == src.keyword && T != src)
			potential_runes.Add(T)

	if(!potential_runes.len)
		user << "<span class='warning'>There are no runes with the same keyword!</span>"
		fail_invoke()
		log_game("Teleport rune failed - no candidates with matching keyword")
		return

	var/obj/effect/rune/selected_rune = pick(potential_runes)
	if(user.buckled)
		user.buckled.unbuckle_mob()
	user.visible_message("<span class='warning'>[user] vanishes in a flash of red light!</span>", \
						 "<span class='danger'>Your vision blurs, and you suddenly appear somewhere else.</span>")
	user.forceMove(get_turf(selected_rune))


var/list/teleport_other_runes = list()
//Rite of Forced Translocation: Warps the target to a random teleport rune with the same keyword.
/obj/effect/rune/teleport_other
	cultist_name = "Teleport Other"
	cultist_desc = "Warps the target to a random rune of the same keyword."
	invocation = "Sas'so c'arta forbica!"
	icon_state = "1"
	color = rgb(200, 0, 0)
	grammar = "ire jatkaa"
	req_keyword = 1

/obj/effect/rune/teleport_other/New()
	..()
	teleport_other_runes.Add(src)

/obj/effect/rune/teleport_other/Destroy()
	teleport_other_runes.Remove(src)
	..()

/obj/effect/rune/teleport_other/invoke(mob/living/user)
	var/list/potential_runes = list()
	for(var/obj/effect/rune/teleport_other/T in teleport_other_runes)
		if(T.keyword == src.keyword && T != src)
			potential_runes.Add(T)

	if(!potential_runes.len)
		user << "<span class='warning'>There are no runes with the same keyword!</span>"
		fail_invoke()
		log_game("Teleport Other rune failed - no candidates with matching keyword")
		return

	var/obj/effect/rune/selected_rune = pick(potential_runes)
	var/mob/living/target

	var/list/targets = list()
	for(var/mob/living/L in get_turf(src))
		if(L != user)
			targets.Add(L)
	if(!targets.len)
		user << "<span class='warning'>There are no targets standing on the rune!</span>"
		fail_invoke()
		log_game("Teleport Other rune failed - no targets on rune")
		return
	if(targets.len > 1)
		target = input(user, "Choose a person to teleport.", "Rite of Forced Translocation") as null|anything in targets - user
		if(!target)
			fail_invoke()
			return
	else
		target = targets[targets.len]
	if(target.buckled)
		target.buckled.unbuckle_mob()
	target.visible_message("<span class='warning'>[target] vanishes in a flash of red light!</span>", \
						   "<span class='danger'>Your vision blurs, and you suddenly appear somewhere else.</span>")
	target.forceMove(get_turf(selected_rune))


//Rite of Knowledge: Creates an arcane tome at the rune's location and destroys the rune.
/obj/effect/rune/summon_tome
	cultist_name = "Summon Tome"
	cultist_desc = "Pulls an arcane tome from the archives of the Geometer."
	invocation = "N'ath reth sh'yro eth d'raggathnor!"
	icon_state = "5"
	color = rgb(0, 0, 255)
	grammar = "karazet nahlizet ego"

/obj/effect/rune/summon_tome/invoke(mob/living/user)
	visible_message("<span class='warning'>A frayed tome materializes on the surface of [src], which dissolves into nothing.</span>")
	new /obj/item/weapon/tome(get_turf(src))
	qdel(src)


//Rite of Enlightenment: Converts a normal crewmember to the cult. Faster for every cultist nearby.
/obj/effect/rune/convert
	cultist_name = "Convert"
	cultist_desc = "Converts a normal crewmember on top of it to the cult. Does not work on loyalty-implanted crew."
	invocation = "Mah'weyh pleggh at e'ntrath!"
	icon_state = "3"
	color = rgb(255, 0, 0)
	grammar = "certum nahlizet ego"
	req_cultists = 2

/obj/effect/rune/convert/invoke(mob/living/user)
	var/list/convertees = list()
	var/turf/T = get_turf(src)
	for(var/mob/living/M in T.contents)
		if(!iscultist(M) && !isloyal(M))
			convertees.Add(M)
	if(!convertees.len)
		fail_invoke()
		log_game("Convert rune failed - no eligible convertees")
		return
	var/mob/living/new_cultist = pick(convertees)
	if(!is_convertable_to_cult(new_cultist.mind) || new_cultist.null_rod_check())
		user << "<span class='warning'>Something is shielding [new_cultist]'s mind!</span>"
		fail_invoke()
		log_game("Convert rune failed - convertee could not be converted")
		if(is_sacrifice_target(new_cultist.mind))
			for(var/mob/living/M in orange(1,src))
				if(iscultist(M))
					M << "<span class='cult'>\"I desire this one for myself. <i>SACRIFICE THEM!</i>\"</span>"
		return
	new_cultist.visible_message("<span class='warning'>[new_cultist] writhes in pain as the markings below them glow a bloody red!</span>", \
					  			"<span class='userdanger'><i>AAAAAAAAAAAAAA-</i></span>")
	ticker.mode.add_cultist(new_cultist.mind)
	new_cultist.mind.special_role = "Cultist"
	new_cultist << "<span class='purple'><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible, truth. The veil of reality has been ripped away \
	and something evil takes root.</i></b></span>"
	new_cultist << "<span class='purple'><b><i>Assist your new compatriots in their dark dealings. Your goal is theirs, and theirs is yours. You serve the Geometer above all else. Bring it back.\
	</i></b></span>"


//Rite of Tribute: Sacrifices a crew member to Nar-Sie. Places them into a soul shard if they're in their body.
/obj/effect/rune/sacrifice
	cultist_name = "Sacrifice"
	cultist_desc = "Sacrifices a crew member to the Geometer. May place them into a soul shard if their spirit remains in their body."
	icon_state = "3"
	invocation = "Ih wah'kd in teh'tin!"
	color = rgb(255, 255, 255)
	grammar = "veri nahlizet certum"
	var/rune_in_use = 0

/obj/effect/rune/sacrifice/New()
	..()
	icon_state = "[rand(1,6)]"

/obj/effect/rune/sacrifice/invoke(mob/living/user)
	if(rune_in_use)
		return
	rune_in_use = 1
	var/turf/T = get_turf(src)
	var/list/possible_targets = list()
	for(var/mob/living/M in T.contents)
		if(!iscultist(M))
			possible_targets.Add(M)
	var/mob/offering
	if(possible_targets.len > 1) //If there's more than one target, allow choice
		offering = input(user, "Choose an offering to sacrifice.", "Unholy Tribute") as null|anything in possible_targets
	else if(possible_targets.len) //Otherwise, if there's a target at all, pick the only one
		offering = possible_targets[possible_targets.len]
	if(!offering)
		rune_in_use = 0
		return
	if(offering.null_rod_check())
		user << "<span class='warning'>Something is blocking the Geometer's magic!</span>"
		log_game("Sacrifice rune failed - target has null rod")
		fail_invoke()
		rune_in_use = 0
		return
	if(((ishuman(offering) || isrobot(offering)) && offering.stat != DEAD) || is_sacrifice_target(offering.mind)) //Requires three people to sacrifice living targets or the round's target
		var/cultists_nearby = 1
		for(var/mob/living/M in orange(1,src))
			if(iscultist(M) && M != user)
				cultists_nearby++
				M.say(invocation)
		if(cultists_nearby < 3)
			user << "<span class='warning'>You require three acolytes to sacrifice greater targets!</span>"
			fail_invoke()
			log_game("Sacrifice rune failed - not enough acolytes and target is living")
			rune_in_use = 0
			return
	visible_message("<span class='warning'>[src] pulses blood red!</span>")
	color = rgb(255, 0, 0)
	spawn(5)
		color = initial(color)
	sac(offering)

/obj/effect/rune/sacrifice/proc/sac(mob/living/T)
	var/sacrifice_fulfilled
	if(T)
		if(istype(T, /mob/living/simple_animal/pet/dog/corgi))
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C))
					C << "<span class='warning'>Even dark gods from another plane have standards, sicko.</span>"
					if(C.reagents)
						C.reagents.add_reagent("hell_water", 2)
		if(T.mind)
			sacrificed.Add(T.mind)
			if(is_sacrifice_target(T.mind))
				sacrifice_fulfilled = 1
		for(var/mob/living/M in orange(1,src))
			if(iscultist(M))
				if(sacrifice_fulfilled)
					M << "<span class='cult'>\"Yes! This is the one I desire! You have done well.\"</span>"
				else
					if(ishuman(T) || isrobot(T))
						M << "<span class='cult'>\"I accept this sacrifice.\"</span>"
					else
						M << "<span class='cult'>\"I accept this meager sacrifice.\"</span>"
		if(T.mind)
			var/obj/item/device/soulstone/stone = new /obj/item/device/soulstone(get_turf(src))
			stone.invisibility = INVISIBILITY_MAXIMUM //so it's not picked up during transfer_soul()
			if(!stone.transfer_soul("FORCE", T, usr)) //If it cannot be added
				qdel(stone)
			if(stone)
				stone.invisibility = 0
			if(!T)
				rune_in_use = 0
				return
		if(isrobot(T))
			playsound(T, 'sound/magic/Disable_Tech.ogg', 100, 1)
			T.dust() //To prevent the MMI from remaining
		else
			playsound(T, 'sound/magic/Disintegrate.ogg', 100, 1)
			T.gib()
	rune_in_use = 0


//Ritual of Dimensional Rending: Calls forth the avatar of Nar-Sie upon the station.
/obj/effect/rune/narsie
	cultist_name = "Call Forth The Geometer"
	cultist_desc = "Tears apart dimensional barriers, calling forth the avatar of the Geometer."
	invocation = "Tok-lyr rqa'nap g'olt-ulotf!"
	req_cultists = 9
	icon = 'icons/effects/96x96.dmi'
	icon_state = "rune_large"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	grammar = "veri certum ego"
	var/used

/obj/effect/rune/narsie/invoke(mob/living/user)
	if(used)
		return
	if(ticker.mode.name == "cult")
		var/datum/game_mode/cult/cult_mode = ticker.mode
		if(!("eldergod" in cult_mode.cult_objectives))
			message_admins("[usr.real_name]([user.ckey]) tried to summon Nar-Sie when the objective was wrong")
			for(var/mob/living/M in orange(1,src))
				if(iscultist(M))
					M << "<span class='cult'><i>\"YOUR SOUL BURNS WITH YOUR ARROGANCE!!!\"</i></span>"
					if(M.reagents)
						M.reagents.add_reagent("hell_water", 10)
					M.Weaken(5)
			fail_invoke()
			log_game("Summon Nar-Sie rune failed - improper objective")
			return
		else
			if(cult_mode.sacrifice_target && !(cult_mode.sacrifice_target in sacrificed))
				for(var/mob/living/M in orange(1,src))
					if(iscultist(M))
						M << "<span class='warning'>The sacrifice is not complete. The portal lacks the power to open!</span>"
				fail_invoke()
				log_game("Summon Nar-Sie rune failed - sacrifice not complete")
				return
		if(!cult_mode.eldergod)
			for(var/mob/living/M in orange(1,src))
				if(iscultist(M))
					M << "<span class='warning'>The avatar of Nar-Sie is already on this plane!</span>"
				log_game("Summon Nar-Sie rune failed - already summoned")
				return
		//BEGIN THE SUMMONING
		used = 1
		world << 'sound/effects/dimensional_rend.ogg'
		world << "<b><i>Rip... <span class='big'>Rrrip...</span> <span class='reallybig'>RRRRRRRRRR--</span></i></b>"
		sleep(40)
		new /obj/singularity/narsie/large(get_turf(user)) //Causes Nar-Sie to spawn even if the rune has been removed
		cult_mode.eldergod = 0
	else
		fail_invoke()
		log_game("Summon Nar-Sie rune failed - gametype is not cult")
		return


//Rite of Resurrection: Requires two corpses. Revives one and gibs the other.
/obj/effect/rune/raise_dead
	cultist_name = "Raise Dead"
	cultist_desc = "Requires two corpses. The one placed upon the rune is brought to life, the other is turned to ash."
	invocation = null //Depends on the name of the user - see below
	icon_state = "1"
	color = rgb(255, 0, 0)
	grammar = "nahlizet certum veri"

/obj/effect/rune/raise_dead/invoke(mob/living/user)
	var/turf/T = get_turf(src)
	var/mob/living/mob_to_sacrifice
	var/mob/living/mob_to_revive
	var/list/potential_sacrifice_mobs = list()
	var/list/potential_revive_mobs = list()
	for(var/mob/living/M in orange(1,src))
		if(!(M in T.contents) && M.stat == DEAD)
			potential_sacrifice_mobs.Add(M)
	if(!potential_sacrifice_mobs.len)
		user << "<span class='warning'>There is no eligible sacrifices nearby!</span>"
		log_game("Raise Dead rune failed - no catalyst corpse")
		return
	mob_to_sacrifice = input(user, "Choose a corpse to sacrifice.", "Corpse to Sacrifice") as null|anything in potential_sacrifice_mobs
	for(var/mob/living/M in T.contents)
		if(M.stat == DEAD)
			potential_revive_mobs.Add(M)
	if(!potential_revive_mobs.len)
		user << "<span class='warning'>There is no eligible revival target on the rune!</span>"
		log_game("Raise Dead rune failed - no corpse to revived")
		return
	mob_to_revive = input(user, "Choose a corpse to revive.", "Corpse to Revive") as null|anything in potential_revive_mobs

	//Begin revival
	if(!in_range(mob_to_sacrifice,src))
		user << "<span class='warning'>The sacrificial target has been moved!</span>"
		fail_invoke()
		log_game("Raise Dead rune failed - catalyst corpse moved")
		return
	if(!(mob_to_revive in T.contents))
		user << "<span class='warning'>The corpse to revived has been moved!</span>"
		fail_invoke()
		log_game("Raise Dead rune failed - revival target moved")
		return
	if(mob_to_sacrifice.stat != DEAD)
		user << "<span class='warning'>The sacrifical target must be dead!</span>"
		fail_invoke()
		log_game("Raise Dead rune failed - catalyst corpse is not dead")
		return
	if(user.name == "Herbert West")
		user.say("To life, to life, I bring them!")
	else
		user.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
	mob_to_sacrifice.visible_message("<span class='warning'><b>[mob_to_sacrifice] disintegrates into black mist. The mist lingers, and then flows into [mob_to_revive]!</span>")
	mob_to_sacrifice.dust()
	sleep(20)
	if(!mob_to_revive || mob_to_revive.stat != DEAD)
		visible_message("<span class='warning'>The black mist rises and dissipates.</span>")
		return
	mob_to_revive << "<span class='cult'>\"PASNAR SAVRAE YAM'TOTH. Arise.\"</span>"
	mob_to_revive.visible_message("<span class='warning'>[mob_to_revive] draws in a huge breath, red light shining from their eyes.</span>", \
								  "<span class='userdanger'>You awaken suddenly from the void. You're alive!</span>")
	mob_to_revive.revive() //This does remove disabilities and such, but the rune might actually see some use because of it!

/obj/effect/rune/raise_dead/fail_invoke()
	for(var/mob/living/M in orange(1,src))
		if(M.stat == DEAD)
			M.visible_message("<span class='warning'>[M] twitches.</span>")


//Rite of Obscurity: Turns all runes within a 3-tile radius invisible.
/obj/effect/rune/hide_runes
	cultist_name = "Veil Runes"
	cultist_desc = "Turns nearby runes invisible. They can be revealed by using the Reveal Runes rune."
	invocation = "Kla'atu barada nikt'o!"
	icon_state = "1"
	color = rgb(0,0,255)
	grammar = "geeri karazet nahlizet"

/obj/effect/rune/hide_runes/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] darkens to black and vanishes.</span>")
	for(var/obj/effect/rune/R in orange(3,src))
		R.visible_message("<span class='danger'>[R] fades away.</span>")
		R.invisibility = INVISIBILITY_OBSERVER
		R.alpha = 100 //To help ghosts distinguish hidden runes
	for(var/mob/dead/observer/O in orange(3,src))
		if(!O.invisibility)
			O << "<span class='deadsay'><i>You suddenly feel as if you've vanished...</i></span>"
			O.invisibility = INVISIBILITY_OBSERVER
	qdel(src)


//Rite of True Sight: Turns ghosts and obscured runes visible
/obj/effect/rune/true_sight
	cultist_name = "Reveal Runes"
	cultist_desc = "Reveals all invisible objects nearby, from spirits to runes."
	invocation = "Nikt'o barada kla'atu!"
	icon_state = "4"
	color = rgb(255, 255, 255)
	grammar = "karazet geeri nahlizet"

/obj/effect/rune/true_sight/invoke()
	visible_message("<span class='warning'>[src] explodes in a flash of blinding light!</span>")
	for(var/mob/dead/observer/O in orange(3,src))
		O << "<span class='deadsay'><i>You suddenly feel very obvious...</i></span>"
		O.invisibility = 0
	for(var/obj/effect/rune/R in orange(3,src))
		R.invisibility = 0
		R.alpha = initial(R.alpha)
	qdel(src)


//Rite of False Truths: Makes runes appear like crayon ones
/obj/effect/rune/make_runes_fake
	cultist_name = "Disguise Runes"
	cultist_desc = "Causes all nearby runes (including itself) to resemble those drawn in crayon."
	invocation = "By'o isit!"
	icon_state = "4"
	color = rgb(0, 150, 0)
	grammar = "geeri nahlizet jatkaa"

/obj/effect/rune/make_runes_fake/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] flares brightly, then slowly dulls and appears mundane.</span>")
	for(var/obj/effect/rune/R in range(3,src))
		R.desc = "A rune drawn in crayon."


//Rite of Disruption: Emits an EMP blast.
/obj/effect/rune/emp
	cultist_name = "Electromagnetic Disruption"
	cultist_desc = "Emits a large electromagnetic pulse, hindering electronics and disabling silicons."
	invocation = "Ta'gh fara'qha fel d'amar det!"
	icon_state = "5"
	color = rgb(255, 0, 0)
	grammar = "mgar karazet balaq"

/obj/effect/rune/emp/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] wavers for a moment before vanishing.</span>")
	for(var/mob/living/carbon/C in orange(1,src))
		C << "<span class='warning'>You feel a minute vibration pass through you!</span>"
	playsound(get_turf(src), 'sound/items/Welder2.ogg', 25, 1)
	empulse(src, 4, 8) //A bit less than an EMP grenade
	qdel(src)


//Rite of Astral Communion: Separates one's spirit from their body. They will take damage while it is active.
/obj/effect/rune/astral
	cultist_name = "Astral Communion"
	cultist_desc = "Severs the link between one's spirit and body. This effect is taxing and one's physical body will take damage while this is active."
	invocation = "Fwe'sh mah erl nyag r'ya!"
	icon_state = "6"
	color = rgb(0, 0, 255)
	var/rune_in_use = 0 //One at a time, please!
	var/mob/living/affecting = null
	grammar = "veri ire ego"

/obj/effect/rune/astral/examine(mob/user)
	..()
	if(affecting)
		user << "<span class='warning'>A translucent field encases [user] above the rune!</span>"

/obj/effect/rune/astral/invoke(mob/living/user)
	if(rune_in_use)
		user << "<span class='warning'>[src] cannot support more than one body!</span>"
		fail_invoke()
		log_game("Astral Communion rune failed - more than one user")
		return
	var/turf/T = get_turf(src)
	if(!user in T.contents)
		user << "<span class='warning'>You must be standing on top of [src]!</span>"
		fail_invoke()
		log_game("Astral Communion rune failed - user not standing on rune")
		return
	rune_in_use = 1
	affecting = user
	user.color = src.color
	user.visible_message("<span class='warning'>[user] freezes statue-still, their eyes glowing blue.</span>", \
						 "<span class='danger'>You see what lies beyond. All is revealed. While this is a wondrous experience, your physical form will waste away in this state. Hurry...</span>")
	user.ghostize(1)
	while(user)
		if(!affecting)
			visible_message("<span class='warning'>[src] pulses gently before falling dark.</span>")
			affecting = null //In case it's assigned to a number or something
			rune_in_use = 0
			return
		affecting.apply_damage(1, BRUTE)
		if(!(user in T.contents))
			user.visible_message("<span class='warning'>A spectral tendril wraps around [user] and pulls them away!</span>")
			src.Beam(user,icon_state="b_beam",icon='icons/effects/beam.dmi',time=1)
			user.forceMove(get_turf(src)) //NO ESCAPE :^)
		if(user.key)
			user.visible_message("<span class='warning'>[user] slowly relaxes, the glow in their eyes dimming.</span>", \
								 "<span class='danger'>You are re-united with your physical form. [src] releases its hold over you.</span>")
			user.color = initial(user.color)
			user.Weaken(3)
			rune_in_use = 0
			affecting = null
			return
		if(user.stat == UNCONSCIOUS)
			if(prob(10))
				var/mob/dead/observer/G = user.get_ghost()
				if(G)
					G << "<span class='warning'>You feel the link between you and your body weakening... you must hurry!</span>"
		if(user.stat == DEAD)
			user.color = initial(user.color)
			rune_in_use = 0
			affecting = null
			var/mob/dead/observer/G = user.get_ghost()
			if(G)
				G << "<span class='warning'><b>You suddenly feel your physical form pass on. [src]'s exertion has killed you!</b></span>"
			return
		sleep(10)
	rune_in_use = 0


//Rite of the Corporeal Shield: When invoked, becomes solid and cannot be passed. Invoke again to undo.
/obj/effect/rune/wall
	cultist_name = "Form Shield"
	cultist_desc = "When invoked, makes the rune block passage. Can be invoked again to reverse this."
	invocation = "Khari'd! Eske'te tannin!"
	icon_state = "1"
	color = rgb(255, 0, 0)
	grammar = "mgar ire ego"

/obj/effect/rune/wall/examine(mob/user)
	..()
	if(density)
		user << "<span class='warning'>There is a barely perceptible shimmering of the air above [src].</span>"

/obj/effect/rune/wall/invoke(mob/living/user)
	density = !density
	user.visible_message("<span class='warning'>[user] places their hands on [src], and [density ? "the air above it begins to shimmer" : "the shimmer above it fades"].</span>", \
						 "<span class='warning'>You channel your life energy into [src], [density ? "preventing" : "allowing"] passage above it.</span>")
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.apply_damage(2, BRUTE, pick("l_arm", "r_arm"))

/obj/effect/rune/wall/blood_trail
	icon = 'icons/effects/blood.dmi'
	icon_state = "tracks"
	color = null
	density = 1

//Rite of the Unheard Whisper:  Deafens all non-cultists nearby.
/obj/effect/rune/deafen
	cultist_name = "Deafen"
	cultist_desc = "Causes all non-followers nearby to lose their hearing."
	invocation = "Sti kaliedir!"
	grammar = "geeri jatkaa karazet"
	color = rgb(0, 255, 0)
	icon_state = "4"

/obj/effect/rune/deafen/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] blurs for a moment before fading away.</span>")
	for(var/mob/living/carbon/C in range(7,src))
		if(!iscultist(C) && !C.null_rod_check())
			C << "<span class='warning'>The world around you goes quiet.</span>"
			C.adjustEarDamage(0,50)
	qdel(src)


//Rite of the Unseen Glance: Blinds all non-cultists nearby.
/obj/effect/rune/blind
	cultist_name = "Blind"
	cultist_desc = "Causes all non-followers nearby to lose their sight."
	invocation = "Sti kaliesin!"
	icon_state = "4"
	color = rgb(0, 0, 255)
	grammar = "mgar jatkaa karazet"

/obj/effect/rune/blind/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] emits a blinding red flash!</span>")
	for(var/mob/living/carbon/C in viewers(src))
		if(!iscultist(C) && !C.null_rod_check())
			C << "<span class='warning'><b>You can't see!</b></span>"
			C.flash_eyes(1, 1)
			C.eye_blurry += 50
			C.eye_blind += 20
	qdel(src)


//Rite of Disorientation: Stuns all non-cultists nearby for a brief time
/obj/effect/rune/stun
	cultist_name = "Stun"
	cultist_desc = "Stuns all nearby non-followers for a brief time."
	invocation = "Fuu ma'jin!"
	icon_state = "2"
	color = rgb(100, 0, 100)
	grammar = "certum geeri balaq"

/obj/effect/rune/stun/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] explodes in a bright flash!</span>")
	for(var/mob/living/M in viewers(src))
		if(!iscultist(M) && !M.null_rod_check())
			M << "<span class='warning'><b>You are disoriented by [src]!</b></span>"
			M.Weaken(3)
			M.Stun(3)
			M.flash_eyes(1,1)
	qdel(src)


//Rite of Joined Souls: Summons a single cultist. Requires 2 cultists.
/obj/effect/rune/summon
	cultist_name = "Summon Cultist"
	cultist_desc = "Summons a single cultist to the rune."
	invocation = "N'ath reth sh'yro eth d'rekkathnor!"
	req_cultists = 2
	icon_state = "5"
	color = rgb(0, 255, 0)
	grammar = "certum jatkaa ego"

/obj/effect/rune/summon/invoke(mob/living/user)
	var/list/cultists = list()
	for(var/datum/mind/M in ticker.mode.cult)
		cultists.Add(M.current)
	var/mob/living/cultist_to_summon = input("Who do you wish to call to [src]?", "Followers of the Geometer") as null|anything in (cultists - user)
	if(!cultist_to_summon)
		user << "<span class='warning'>You require a summoning target!</span>"
		fail_invoke()
		log_game("Summon Cultist rune failed - no target")
		return
	if(!iscultist(cultist_to_summon))
		user << "<span class='warning'>[cultist_to_summon] is not a follower of the Geometer!</span>"
		fail_invoke()
		log_game("Summon Cultist rune failed - no target")
		return
	if(cultist_to_summon.buckled)
		cultist_to_summon.buckled.unbuckle_mob()
	cultist_to_summon.visible_message("<span class='warning'>[cultist_to_summon] suddenly disappears in a flash of red light!</span>", \
									  "<span class='warning'><b>Overwhelming vertigo consumes you as you are hurled through the air!</b></span>")
	visible_message("<span class='warning'>A foggy shape materializes atop [src] and solidifes into [cultist_to_summon]!</span>")
	for(var/mob/living/carbon/C in orange(1,src))
		if(iscultist(C))
			C.apply_damage(10, BRUTE, "head")
	cultist_to_summon.loc = get_turf(src)
	qdel(src)


//Rite of Binding: Turns a nearby rune and a paper on top of the rune to a talisman, if both are valid.
/obj/effect/rune/imbue
	cultist_name = "Bind Talisman"
	cultist_desc = "Transforms papers and valid runes into talismans."
	invocation = "H'drak v'loso, mir'kanas verbot!"
	icon_state = "3"
	color = rgb(0, 0, 255)
	grammar = "veri balaq certum"

/obj/effect/rune/imbue/invoke(mob/living/user)
	var/turf/T = get_turf(src)
	var/list/papers_on_rune = list()
	for(var/obj/item/weapon/paper/P in T)
		if(!P.info)
			papers_on_rune.Add(P)
	if(!papers_on_rune.len)
		user << "<span class='warning'>There must be a blank paper on top of [src]!</span>"
		fail_invoke()
		log_game("Talisman Imbue rune failed - no blank papers on rune")
		return
	var/obj/item/weapon/paper/paper_to_imbue = pick(papers_on_rune)
	var/list/nearby_runes = list()
	for(var/obj/effect/rune/R in orange(1,src))
		nearby_runes.Add(R)
	if(!nearby_runes.len)
		user << "<span class='warning'>There are no runes near [src]!</span>"
		fail_invoke()
		log_game("Talisman Imbue rune failed - no nearby runes")
		return
	var/obj/effect/rune/picked_rune = pick(nearby_runes)
	var/list/split_rune_type = splittext("[picked_rune.type]", "/")
	var/imbue_type = split_rune_type[split_rune_type.len]
	var/talisman_type = text2path("/obj/item/weapon/paper/talisman/[imbue_type]")
	if(ispath(talisman_type))
		var/obj/item/weapon/paper/talisman/TA = new talisman_type(get_turf(src))
		if(istype(picked_rune, /obj/effect/rune/teleport))
			var/obj/effect/rune/teleport/TR = picked_rune
			var/obj/item/weapon/paper/talisman/teleport/TT = TA
			TT.keyword = TR.keyword
	else
		user << "<span class='warning'>The chosen rune was not a valid target!</span>"
		fail_invoke()
		log_game("Talisman Imbue rune failed - chosen rune invalid")
		return
	visible_message("<span class='warning'>[picked_rune] crumbles to dust, and bloody images form themselves on [paper_to_imbue].</span>")
	qdel(paper_to_imbue)
	qdel(picked_rune)


//Rite of Fabrication: Creates a construct shell out of 5 metal sheets.
/obj/effect/rune/construct_shell
	cultist_name = "Fabricate Shell"
	cultist_desc = "Turns five plasteel sheets into an empty construct shell, suitable for containing a soul shard."
	invocation = "Ethra p'ni dedol!"
	icon_state = "5"
	color = rgb(150, 150, 150)
	grammar = "ire veri balaq"

/obj/effect/rune/construct_shell/invoke(mob/living/user)
	var/turf/T = get_turf(src)
	for(var/obj/item/stack/sheet/S in T)
		if(istype(S, /obj/item/stack/sheet/plasteel))
			var/obj/item/stack/sheet/plasteel/M = S
			if(M.amount >= 5)
				new /obj/structure/constructshell(T)
				M.visible_message("<span class='warning'>[M] bends and twists into a new form!</span>")
				M.amount -= 5
				if(M.amount <= 0)
					qdel(M)
				qdel(src)
				return
			else
				user << "<span class='warning'>There must be at least five sheets of plasteel on [src]!</span>"
				fail_invoke()
				log_game("Construct Shell rune failed - not enough plasteel sheets")
				return


//Rite of Arming: Creates cult robes, a trophy rack, and a cult sword on the rune.
/obj/effect/rune/armor
	cultist_name = "Summon Arnaments"
	cultist_desc = "Equips the user with robes, shoes, a backpack, and a longsword. Items that cannot be equipped will not be summoned."
	invocation = "N'ath reth sh'yro eth draggathnor!"
	icon_state = "4"
	color = rgb(255, 0, 0)
	grammar = "veri mgar jatkaa"

/obj/effect/rune/armor/invoke(mob/living/user)
	visible_message("<span class='warning'>With the sound of clanging metal, [src] crumbles to dust!</span>")
	user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult/alt(user), slot_shoes)
	user.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/cultpack(user), slot_back)
	user.put_in_hands(new /obj/item/weapon/melee/cultblade(user))
	qdel(src)


//Rite of Leeching: Deals brute damage to the target and heals the same amount to the invoker.
/obj/effect/rune/leeching
	cultist_name = "Drain Life"
	cultist_desc = "Drains the life of the target on the rune, restoring it to the user."
	invocation = "Yu'gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!" //that's a mouthful
	icon_state = "2"
	color = rgb(255, 0, 0)
	grammar = "ire nahlizet ego"

/obj/effect/rune/leeching/invoke(mob/living/user)
	var/turf/T = get_turf(src)
	var/list/potential_targets = list()
	for(var/mob/living/carbon/M in T)
		if(M.stat != DEAD && M != user)
			potential_targets.Add(M)
	if(!potential_targets.len)
		user << "<span class='warning'>There must be a valid target on the rune!</span>"
		fail_invoke()
		log_game("Leeching rune failed - no valid targets")
		return
	var/mob/living/carbon/target = pick(potential_targets)
	var/drained_amount = rand(5,25)
	target.apply_damage(drained_amount, BRUTE, "chest")
	user.adjustBruteLoss(-drained_amount)
	user.adjustBloodLoss(-drained_amount/10)
	target << "<span class='warning'>You feel extremely weak.</span>"
	user.visible_message("<span class='warning'>Blood flows from the rune into [user]!</span>", \
						 "<span class='danger'>[target]'s blood flows into you, healing your wounds and revitalizing your spirit.</span>")


//Rite of Boiling Blood: Deals extremely high amounts of damage to non-cultists nearby
/obj/effect/rune/blood_boil
	cultist_name = "Boil Blood"
	cultist_desc = "Boils the blood of non-believers who can see the rune, dealing extreme amounts of damage."
	invocation = "Dedo ol'btoh!"
	icon_state = "4"
	color = rgb(255, 0, 0)
	req_cultists = 3
	grammar = "mgar karazet nahlizet"

/obj/effect/rune/blood_boil/invoke(mob/living/user)
	visible_message("<span class='warning'>[src] briefly bubbles before exploding!</span>")
	for(var/mob/living/carbon/C in viewers(src))
		if(!iscultist(C))
			if(C.null_rod_check())
				C << "<span class='userdanger'>The null rod suddenly burns hotly before returning to normal!</span>"
				continue
			C << "<span class='userdanger'>Agonizing heat overwhelms you!</span>"
			C.take_overall_damage(51,51)
	for(var/mob/living/carbon/M in orange(1,src))
		if(iscultist(M))
			M.apply_damage(15, BRUTE, pick("l_arm", "r_arm"))
			M << "<span class='warning'>[src] saps your strength!</span>"
	explosion(get_turf(src), -1, 0, 1, 5)
	qdel(src)


//Rite of Spectral Manifestation: Summons a ghost on top of the rune as a cultist human with no items. User must stand on the rune at all times, and takes damage for each summoned ghost.
/obj/effect/rune/manifest
	cultist_name = "Manifest Spirit"
	cultist_desc = "Manifests a spirit as a servant of the Geometer. The invoker must not move from atop the rune, and will take damage for each summoned spirit."
	invocation = "Gal'h'rfikk harfrandid mud'gib!" //how the fuck do you pronounce this
	icon_state = "6"
	color = rgb(255, 0, 0)
	grammar = "nahlizet karazet ire"

/obj/effect/rune/manifest/invoke(mob/living/user)
	if(!(user in get_turf(src)))
		user << "<span class='warning'>You must be standing on [src]!</span>"
		fail_invoke()
		log_game("Manifest rune failed - user not standing on rune")
		return
	var/list/ghosts_on_rune = list()
	for(var/mob/dead/observer/O in get_turf(src))
		if(O.client)
			ghosts_on_rune.Add(O)
	if(!ghosts_on_rune.len)
		user << "<span class='warning'>There are no spirits near [src]!</span>"
		fail_invoke()
		log_game("Manifest rune failed - no nearby ghosts")
		return
	var/mob/dead/observer/ghost_to_spawn = pick(ghosts_on_rune)
	var/mob/living/carbon/human/new_human = new(get_turf(src))
	new_human.real_name = ghost_to_spawn.real_name
	new_human.alpha = 150 //Makes them translucent
	visible_message("<span class='warning'>A cloud of red mist forms above [src], and from within steps... a man.</span>")
	user << "<span class='warning'>Your blood begins flowing into [src]. You must remain in place and conscious to maintain the forms of those summoned. This will hurt you slowly but surely...</span>"
	new_human.key = ghost_to_spawn.key
	ticker.mode.add_cultist(new_human.mind)
	new_human << "<span class='purple'><b><i>You are a servant of the Geometer. You have been made semi-corporeal by the cult, and you are to serve them at all costs.</i></b></span>"

	while(user in get_turf(src))
		if(user.stat)
			break
		user.apply_damage(1, BRUTE)
		sleep(30)

	if(new_human)
		new_human.visible_message("<span class='warning'>[new_human] suddenly dissolves into bones and ashes.</span>", \
								  "<span class='userdanger'>Your link to the world fades. Your form breaks apart.</span>")
		for(var/obj/I in new_human)
			new_human.unEquip(I)
		new_human.dust()
