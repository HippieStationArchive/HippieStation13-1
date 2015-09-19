

proc/IsBanned(var/client/client)
	var/key = client.ckey
	var/address = client.address
	var/computer_id = client.computer_id
	var/evasion = 0
	if(ckey(key) in admin_datums)
		//It has proven to be a bad idea to make admins completely immune to bans, making them have to wait for someone with daemon access
		//to add a daemon ban to finally stop them. Admin tempbans and admin permabans are special, high-level ban types, which are there to help
		//deal with rogue admins quicker. If admin tempbans or admin permabans are ever needed, it should be consider a big deal. The same applies if
		//admin bans are ever abused. This ban type does NOT check for IP or Computer ID. The reason for this is so a player cannot find/steal an admin's
		//computer id, set it on his computer, get himself banned, resulting in the admin getting banned aswell. - this happens to also be the reason why
		//admins were immune to bans in the first place.
		if(!config.ban_legacy_system)
			var/ckeytext = ckey(key)

			if(!establish_db_connection())
				world.log << "Ban database connection failure. Admin [ckeytext] not checked"
				diary << "Ban database connection failure. Admin [ckeytext] not checked"
				return

			var/DBQuery/query = dbcon.NewQuery("SELECT ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM [format_table_name("ban")] WHERE (ckey = '[ckeytext]') AND (bantype = 'ADMIN_PERMABAN'  OR (bantype = 'ADMIN_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")

			query.Execute()

			while(query.NextRow())
				var/pckey = query.item[1]
				var/ackey = query.item[4]
				var/reason = query.item[5]
				var/expiration = query.item[6]
				var/duration = query.item[7]
				var/bantime = query.item[8]
				var/bantype = query.item[9]

				var/expires = ""
				if(text2num(duration) > 0)
					
					expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

				var/desc = "\nReason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"

				return list("reason"="[bantype]", "desc"="[desc]")

		return ..()

	//Guest Checking
	if(!guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	if(config.ban_legacy_system)

		//Ban Checking
		. = CheckBan( ckey(key), computer_id, address )
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
			return .

		return ..()	//default pager ban stuff

	else

		var/ckeytext = ckey(key)

		if(!establish_db_connection())
			world.log << "Ban database connection failure. Key [ckeytext] not checked"
			diary << "Ban database connection failure. Key [ckeytext] not checked"
			return

		var/failedcid = 1
		var/failedip = 1

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '[address]' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR computerid = '[computer_id]' "

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM [format_table_name("ban")] WHERE (ckey = '[ckeytext]' [ipquery] [cidquery]) AND (bantype = 'PERMABAN'  OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")

		query.Execute()

		while(query.NextRow())
			var/pckey = query.item[1]
			var/ackey = query.item[4]
			var/reason = query.item[5]
			var/expiration = query.item[6]
			var/duration = query.item[7]
			var/bantime = query.item[8]
			var/computerid = query.item[3]
			var/ip = query.item[2]
			var/savefile/banfile
			var/client/player 
			for(var/client/c in clients)
				if(ckeytext == c.ckey)
					banfile = get_banfile(c)
					player = c
					break
			if(banfile)
				var/bcid
				var/bip
				var/bkey
				banfile["cid"] >> bcid
				banfile["ip"] >> bip
				banfile["key"] >> bkey
				if(bcid != computer_id)
					log_admin("Unmatched CID found on banned player [ckeytext] , updating ban file.")
				if(bip != address)
					log_admin("Unmatched Ip address found on banned player [ckeytext] , updating ban file.")
				if(bkey != ckeytext)
					reason +="Ban upped to a permanent ban for attempted ban evasion."
					AddBan(pckey, computer_id, reason, ackey, 0, 0, address)
					evasion = 1
				add_banfile(player)//update their ban file
			else
				notes_add(ckeytext, "New ban file added , if multiple notes like this show up they may be attempting to evade the ban.")
				add_banfile(player)
			if(computerid != computer_id || address != ip)
				var/length = text2num(duration)
				if(length > 0)
					UpdateTime()
					var/btime = duration - CMinutes
					AddBan(pckey, computer_id, reason, ackey, 1, btime, address)
				else
					AddBan(pckey, computer_id, reason, ackey, 0, 0, address)
				if(computerid != computer_id)
					notes_add(ckeytext, "New computer ID ban added for computer id: [computer_id] , if multiple of these notes are showing up they may be attempting to evade the ban.")
				else
					notes_add(ckeytext, "New Ip address ban added for Ip address: [address] , if multiple of these notes are showing up they may be attempting to evade the ban.")
			if(pckey != ckeytext && !evasion)//dont want double bannings
				reason +="Ban upped to a permanent ban for attempted ban evasion."
				AddBan(pckey, computer_id, reason, ackey, 0, 0, address)
			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			var/desc = "Reason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"
			client << "[desc]. [expires ? "." : "This is a permanent ban"]"
			del(client)

		if (failedcid)
			log_access("[key] has logged in with a blank computer id in the ban check.")
		if (failedip)
			log_access("[key] has logged in with a blank ip in the ban check.")
		return ..()	//default pager ban stuff
