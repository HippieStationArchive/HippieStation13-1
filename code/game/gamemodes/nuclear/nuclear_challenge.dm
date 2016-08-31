#define CHALLENGE_TIME_LIMIT 4200 //2 minutes are spent dicking around in the lobby so you only used to have 3 minutes to declare or not declare
#define MIN_CHALLENGE_PLAYERS 50

/obj/item/device/nuclear_challenge
	name = "Declaration of War (Challenge Mode)"
	icon_state = "gangtool-red"
	item_state = "walkietalkie"
	desc = "Use to send a declaration of hostilities to the target, delaying your shuttle departure for 20 minutes while they prepare for your assault.  \
	Such a brazen move will attract the attention of powerful benefactors within the Syndicate, who will supply your team with a massive amount of bonus telecrystals.  \
	Must be used within five minutes, or your benefactors will lose interest."
	var/used = 0
	var/challenge_time = CHALLENGE_TIME_LIMIT
	var/datum/game_mode/nuclear/N

/obj/item/device/nuclear_challenge/New()
	N = ticker.mode

/obj/item/device/nuclear_challenge/attack_self(mob/living/user)
	if(!istype(N))
		return
	if(..())
		return
	if(N.podlaunch)
		user << "You can't declare war once you've starting launching the pod!"
		return
	if(player_list.len < MIN_CHALLENGE_PLAYERS)
		user << "The enemy crew is too small to be worth declaring war on."
		return
	if(user.z != ZLEVEL_CENTCOM)
		user << "You have to be at your base to use this."
		return

	if(world.time > challenge_time)
		user << "It's too late to declare hostilities. Your benefactors are already busy with other schemes. You'll have to make do with what you have on hand."
		return

	if(used) //First used check
		return

	var/are_you_sure = alert(user, "Consult your team carefully before you declare war on [station_name()]. Are you sure you want to alert the enemy crew? You have [round((challenge_time - world.time)/10)] seconds to decide", "Declare war?", "Yes", "No")
	if(are_you_sure == "No")
		user << "On second thought, the element of surprise isn't so bad after all."
		return

	if(used) //Second used check incase it's sustained in the dialog
		user << "You already declared war on the station!"
		return

	var/war_declaration = "[user.real_name] has declared his intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."
	var/custom_threat = alert(user, "Do you want to customize your declaration?", "Customize?", "Yes", "No")
	if(custom_threat == "Yes" && (world.time < challenge_time-600))
		war_declaration = stripped_input(user, "Insert your custom declaration", "Declaration")
		if(!war_declaration)
			return
	else if(world.time > challenge_time-600)
		user << "You don't have enough time to come up with any evil speeches now!"

	if(world.time > challenge_time) //Check the time limit again in case somebody intentionally holds the dialogue box to delay declarations
		user << "It's too late to declare hostilities. Your benefactors are already busy with other schemes. You'll have to make do with what you have on hand."
		return

	used = 1

	priority_announce(replacetext(war_declaration, "&#39;","'"), title = "Declaration of War by the [N.last_name] family", sound = 'sound/machines/Alarm.ogg')
	set_security_level(SEC_LEVEL_RED)
	user << "You've attracted the attention of powerful forces within the syndicate. A bonus bundle of telecrystals has been granted to your team. Great things await you if you complete the mission."

	for(var/obj/machinery/computer/shuttle/syndicate/S in machines)
		S.challenge = TRUE

	var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(get_turf(user))
	U.hidden_uplink.uplink_owner= "[user.key]"
	U.hidden_uplink.uses = 200
	U.hidden_uplink.mode_override = /datum/game_mode/nuclear //Maybe we can have a special set of items for the challenge uplink eventually
	qdel(src)


#undef CHALLENGE_TIME_LIMIT
#undef MIN_CHALLENGE_PLAYERS
