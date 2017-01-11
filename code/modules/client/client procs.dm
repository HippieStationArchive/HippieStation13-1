	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		2097152	//Restricts client uploads to the server to 2MB //Could probably do with being lower.
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()
	Such links can be spoofed.
	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return
	if(href_list["asset_cache_confirm_arrival"])
		//src << "ASSET JOB [href_list["asset_cache_confirm_arrival"]] ARRIVED."
		var/job = text2num(href_list["asset_cache_confirm_arrival"])
		completed_asset_jobs += job
		return
	//Admin PM
	if(href_list["priv_msg"])
		if (href_list["ahelp_reply"])
			cmd_ahelp_reply(href_list["priv_msg"])
			return
		cmd_admin_pm(href_list["priv_msg"],null)
		return

	if(href_list["mentor_msg"])
		if(config.mentors_mobname_only)
			var/mob/M = locate(href_list["mentor_msg"])
			cmd_mentor_pm(M,null)
		else
			cmd_mentor_pm(href_list["mentor_msg"],null)
		return

	if(href_list["mentor_follow"])
		var/mob/living/M = locate(href_list["mentor_follow"])

		if(istype(M))
			mentor_follow(M)

		return

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	..()	//redirect to hsrc.Topic()

/client/proc/is_content_unlocked()
	if(!prefs.unlock_content)
		src << "Become a BYOND member to access member-perks and features, as well as support the engine that makes this game possible. Only 10 bucks for 3 months! <a href='http://www.byond.com/membership'>Click Here to find out more</a>."
		return 0
	return 1

/client/proc/handle_spam_prevention(message, mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			src << "<span class='danger'>You have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>"
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			src << "<span class='danger'>You are nearing the spam filter limit for identical messages.</span>"
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
#if (PRELOAD_RSC == 0)
var/list/external_rsc_urls
var/next_external_rsc = 0
#endif


/client/New(TopicData)

	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker" && connection != "web")//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

#if (PRELOAD_RSC == 0)
	if(external_rsc_urls && external_rsc_urls.len)
		next_external_rsc = Wrap(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	clients += src
	directory[ckey] = src

	//Admin Authorisation
	if(protected_config.autoadmin)
		if(!admin_datums[ckey])
			var/datum/admin_rank/autorank
			for(var/datum/admin_rank/R in admin_ranks)
				if(R.name == protected_config.autoadmin_rank)
					autorank = R
					break
			if(!autorank)
				world << "Autoadmin rank not found"
			else
				var/datum/admins/D = new(autorank, ckey)
				admin_datums[ckey] = D

	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	//Mentor Authorisation
	var/mentor = mentor_datums[ckey]
	if(mentor)
		verbs += /client/proc/cmd_mentor_say
		verbs += /client/proc/show_mentor_memo
		mentors += src

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()

	if (connection == "web")
		if (!config.allowwebclient)
			src << "Web client is disabled"
			del(src)
			return 0
		if (config.webclientmembersonly && !IsByondMember())
			src << "Sorry, but the web client is restricted to byond members only."
			del(src)
			return 0

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		admin_memo_output("Show")
		adminGreet()
		if((global.comms_key == "default_pwd" || length(global.comms_key) <= 6) && global.comms_allowed) //It's the default value or less than 6 characters long, but it somehow didn't disable comms.
			src << "<span class='danger'>The server's API key is either too short or is the default value! Consider changing it immediately!</span>"

	if(mentor && !holder)
		mentor_memo_output("Show")

	add_verbs_from_config()
	set_client_age_from_db()

	if (isnum(player_age) && player_age == -1) //first connection
		if(config.proxykick) // proxyban's enabled
			var/danger = proxycheck()
			if(danger >= text2num(config.proxykicklimit))
				add_note(ckey, "[danger*100]% chance to be a proxy user", null, "Proxycheck", 0)
				log_access("Failed Login: [key] - New account attempting to connect with a proxy([danger*100]% possibility to be a proxy.)")
				message_admins("<span class='adminnotice'>Failed Login: [key] - with a proxy([danger*100]% possibility to be a proxy.</span>")
				src << "Sorry but you're not allowed to connect to the server through a proxy. Disable it and reconnect if you want to play."
				send2irc_admin_notice_handler("new_player","Proxy-check", "[key_name(src)] tried to log in with a proxy([danger*100]% chance)!")
				del(src)
				return 0
			else if(danger < 0) // means an issue popped up
				switch(danger)
					if(-1)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -1, IP-less client. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -1, IP-less client ( [address] )")
					if(-2)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -2, IP invalid. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -2, IP invalid ( [address] )")
					if(-3)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -3, private address detected. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -3, private address detected. ( [address] )")
					if(-4)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -4, ProxyChecker not working, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -4, ProxyChecker not working, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						if(!config.panic_bunker)
							panicbunker()
					if(-5)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -5, ProxyChecker stopped working! Server banned from the system. Fix immediately, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -5, ProxyChecker stopped working! Server banned from the system. Fix immediately, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						if(!config.panic_bunker)
							panicbunker()
					if(-6)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -6, ProxyChecker stopped working! PROXYKICKEMAIL config option is invalid. Fix immediately, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -6, ProxyChecker stopped working! PROXYKICKEMAIL config option is invalid. Fix immediately, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						if(!config.panic_bunker)
							panicbunker()
					if(-7)
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -7, ProxyChecker stopped working! Number of queries possible per minute exceeded, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -7, ProxyChecker stopped working! Server banned from the system. Number of queries possible per minute exceeded, [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						if(!config.panic_bunker)
							panicbunker()
					else
						message_admins("<span class='adminnotice'>Failed Login: [key] - ProxyKick error code -8, ProxyChecker stopped working! HTTP error code [danger], [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						log_access("Failed Login: [key] - ProxyKick errror code -8, ProxyChecker stopped working! HTTP error code [danger], [config.panic_bunker ? "panic bunker already active" : "activating panic bunker"]. ( [address] )")
						if(!config.panic_bunker)
							panicbunker()
				send2irc_admin_notice_handler("new_player","Proxy-check", "[key_name(src)] tried to log in but the ProxyChecker failed(Error code [danger])")
				src << "The Proxy Checker has encountered an error and your connection has been refused. Go on the forum ([config.forumurl]) and report this, along with the issue code [danger]."
				del(src)
				return 0
		if (config.panic_bunker && !holder && !(ckey in deadmins))
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			src << "Sorry but the server is currently not accepting connections from never before seen players."
			del(src)
			return 0

		if (config.notify_new_player_age >= 0)
			message_admins("New user: [key_name_admin(src)] is connecting here for the first time.")
			send2irc_admin_notice_handler("new_player","New-user", "[key_name(src)] is connecting for the first time!")

		player_age = 0 // set it from -1 to 0 so the job selection code doesn't have a panic attack

	else if (isnum(player_age) && player_age < config.notify_new_player_age)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [player_age] day[(player_age==1?"":"s")]")


	if (!ticker || ticker.current_state == GAME_STATE_PREGAME)
		spawn (rand(10,150))
			if (src)
				sync_client_with_db()
	else
		sync_client_with_db()

	send_resources()

	if(!void)
		void = new()

	screen += void

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		src << "<span class='info'>You have unread updates in the changelog.</span>"
		if(config.aggressive_changelog)
			src.changes()
		else
			winset(src, "rpane.changelogb", "background-color=#eaeaea;font-style=bold")

	if (ckey in clientmessages)
		for (var/message in clientmessages[ckey])
			src << message
		clientmessages.Remove(ckey)

	if (config && config.autoconvert_notes)
		convert_notes_sql(ckey)

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		src << "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>"

	if(check_rights(R_BAN))
		if(ahelp_count(0) > 0)
			list_ahelps(src, 0)


	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	cidspoofcheck()

/client/proc/proxycheck()
	var/list/httpstuff = world.Export("http://check.getipintel.net/check.php?ip=[address]&contact=[config.proxykickemail]&flags=b")
	if(!httpstuff)
		return -50 //error code
	var/n = httpstuff["CONTENT"]
	var/httpcode = httpstuff["STATUS"]
	httpcode = text2num(httpcode) // gets only the error number code, without suffixes such as "OK"
	if(httpcode == 429)
		return -7 // exceeded number of queries
	if(httpcode != 200)//something went wrong,fuck
		return -httpcode
	if(n)
		n = text2num(file2text(n))
	return n

//////////////
//DISCONNECT//
//////////////

/client/Del()
	if(holder)
		adminGreet(1)
		holder.owner = null
		admins -= src
	directory -= ckey
	clients -= src
	return ..()


/client/proc/set_client_age_from_db()
	if (IsGuestKey(src.key))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM [format_table_name("player")] WHERE ckey = '[sql_ckey]'")
	if (!query.Execute())
		return

	while (query.NextRow())
		player_age = text2num(query.item[2])
		return

	//no match mark it as a first connection for use in client/New()
	player_age = -1


/client/proc/sync_client_with_db()
	if (IsGuestKey(src.key))
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE ip = '[address]' AND ckey != '[sql_ckey]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE computerid = '[computer_id]' AND ckey != '[sql_ckey]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while (query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "

	var/watchreason = check_watchlist(sql_ckey)
	if(watchreason)
		message_admins("<font color='red'><B>Notice: </B></font><font color='blue'>[key_name_admin(src)] is on the watchlist and has just connected - Reason: [watchreason]</font>")
		send2irc_admin_notice_handler("watchlist", "Watchlist", "[key_name(src)] is on the watchlist and has just connected - Reason: [watchreason]")

	var/admin_rank = "Player"
	if (src.holder && src.holder.rank)
		admin_rank = src.holder.rank.name

	var/sql_ip = sanitizeSQL(src.address)
	var/sql_computerid = sanitizeSQL(src.computer_id)
	var/sql_admin_rank = sanitizeSQL(admin_rank)


	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO [format_table_name("player")] (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]') ON DUPLICATE KEY UPDATE lastseen = VALUES(lastseen), ip = VALUES(ip), computerid = VALUES(computerid), lastadminrank = VALUES(lastadminrank)")
	query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()

/client/proc/add_verbs_from_config()
	if(config.see_own_notes)
		verbs += /client/proc/self_notes


#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	. = ..()
	sleep(1)

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	//get the common files
	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/browser/common.css',
		'html/browser/scannernew.css',
		'html/browser/playeroptions.css',
		)

	spawn(10)
		//Send nanoui files to client
		SSnano.send_resources(src)

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		getFilesSlow(src, asset_cache, register_asset = FALSE)

/client/proc/cidspoofcheck()
	establish_db_connection()
	if (!dbcon.IsConnected())
		cid_check = 1
		return

	var/DBQuery/query_checkdb = dbcon.NewQuery("SHOW TABLES LIKE 'spoof_check'")
	if(query_checkdb.RowCount() == 0)
		cid_check = 1
		return

	var/sql_ckey = sanitizeSQL(ckey)
	var/sql_computerid = sanitizeSQL(computer_id)

	var/DBQuery/query_check_ckey = dbcon.NewQuery("SELECT ckey FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]'")
	query_check_ckey.Execute()

	if(query_check_ckey.RowCount() != 0) //check ckey

		var/DBQuery/query_check_white = dbcon.NewQuery("SELECT whitelist FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]' and whitelist = '1'")
		query_check_white.Execute()

		if(query_check_white.RowCount() != 0) //Whitelist check
			var/DBQuery/query_check_whiteextra = dbcon.NewQuery("SELECT ckey FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]' and (computerid_1 = '[sql_computerid]' or computerid_2 = '[sql_computerid]' or computerid_3 = '[sql_computerid]')")
			query_check_whiteextra.Execute()

			if(query_check_whiteextra.RowCount() != 0)//One of the three slots had the same cid
				cid_check = 1
			else
				var/DBQuery/query_check_cid1r = dbcon.NewQuery("SELECT ckey FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]' and computerid_1 = '0'")
				query_check_cid1r.Execute()

				if(query_check_cid1r.RowCount() != 0) // Check for reset
					alert(src, "Somebody reset your cid slots.")
					var/DBQuery/query_insert_cid1 = dbcon.NewQuery("UPDATE [format_table_name("spoof_check")] SET computerid_1 = '[sql_computerid]', datetime_1 = NOW() WHERE ckey = '[sql_ckey]'")
					query_insert_cid1.Execute()

				else
					var/DBQuery/query_check_cid2 = dbcon.NewQuery("SELECT ckey FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]' and computerid_2 IS NULL")
					query_check_cid2.Execute()

					if(query_check_cid2.RowCount() != 0) // check if it is NULL, it will only be NULL if it was reset or the person never used the new slot
						var/DBQuery/query_insert_cid2 = dbcon.NewQuery("UPDATE [format_table_name("spoof_check")] SET computerid_2 = '[sql_computerid]', datetime_2 = NOW() WHERE ckey = '[sql_ckey]'")
						query_insert_cid2.Execute()
						src << "You have used your second cid slot"
						cid_check = 1

					else // check if it is NULL, it will only be NULL if it was reset or the person never used the new slot
						var/DBQuery/query_check_cid3 = dbcon.NewQuery("SELECT ckey FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]' and computerid_3 IS NULL")
						query_check_cid3.Execute()

						if(query_check_cid3.RowCount() != 0)
							var/DBQuery/query_insert_cid3 = dbcon.NewQuery("UPDATE [format_table_name("spoof_check")] SET computerid_3 = '[sql_computerid]', datetime_3 = NOW() WHERE ckey = '[sql_ckey]'")
							query_insert_cid3.Execute()
							src << "You have used your third cid slot. This was your last cid slot. Now your first cid slot will start changing again. Please ask an admin if you want to reset all your slots."
							cid_check = 1
						else // Even if you use all slots you will still be able to connect. You will just change your first slot again.
							alert(src, "You have used your three computer_id slots. Your first slot will now be changed and you will have to authorize yourself again.")
							var/DBQuery/query_insert_cid1 = dbcon.NewQuery("UPDATE [format_table_name("spoof_check")] SET computerid_1 = '[sql_computerid]', datetime_1 = NOW() WHERE ckey = '[sql_ckey]'")
							query_insert_cid1.Execute()
							log_game("[sql_ckey] may be using Evasion Tools")
							winset(src, null, "command=.quit")
		else
			var/DBQuery/query_check_cid1 = dbcon.NewQuery("SELECT ckey FROM [format_table_name("spoof_check")] WHERE ckey = '[sql_ckey]' and computerid_1 = '[sql_computerid]'")
			query_check_cid1.Execute()
			if(query_check_cid1.RowCount() != 0)
				cid_check = 1
			else // Cid changed maybe wsock32 maybe a different pc.
				alert(src, "Maybe you used a different computer or you changed your cid. \nThis means that you will have to reauthorize yourself. Like last time your window will close and you will have to rejoin.")
				var/DBQuery/query_insert_cid1 = dbcon.NewQuery("UPDATE [format_table_name("spoof_check")] SET computerid_1 = '[sql_computerid]', datetime_1 = NOW() WHERE ckey = '[sql_ckey]'")
				query_insert_cid1.Execute()
				log_game("[sql_ckey] may be using Evasion Tools")
				winset(src, null, "command=.quit")

	else // ckey does not exist
		alert(src, "This is a anti-spoofing measure, you will have to rejoin again.\nAsk an admin if you wish to play on more than one computer without constantly rejoining.")

		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO [format_table_name("spoof_check")] (`id`, `whitelist`, `ckey`, `computerid_1`, `computerid_2`, `computerid_3`, `datetime_1`, `datetime_2`, `datetime_3`) VALUES (null,0,'[sql_ckey]','[sql_computerid]',null,null,NOW(),null,null);")

		if(!query_insert.Execute()) //alert if something is going wrong
			var/err = query_insert.ErrorMsg()
			log_game("SQL ERROR while adding a new Client towards spoof_cid. Error : \[[err]\]\n")
			src << "<span class='warning'>[query_insert.ErrorMsg()]</span>"

		else //everything is okay
			winset(src, null, "command=.quit")
