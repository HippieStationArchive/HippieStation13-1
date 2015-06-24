/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys. \nTo speak on the general radio frequency, use ; before speaking."
	icon_state = "headset"
	item_state = "headset"
	g_amt = 0
	m_amt = 75
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = SLOT_EARS
	var/obj/item/device/encryptionkey/keyslot2 = null
	maxf = 1489

/obj/item/device/radio/headset/New()
	..()
	recalculateChannels()

/obj/item/device/radio/headset/Destroy()
	qdel(keyslot)
	qdel(keyslot2)
	keyslot = null
	keyslot2 = null
	..()

/obj/item/device/radio/headset/talk_into(mob/living/M as mob, message, channel)
	if (!listening)
		return
	..()

/obj/item/device/radio/headset/receive_range(freq, level, var/AIuser)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.ears == src)
			return ..(freq, level)
	else if(AIuser)
		return ..(freq, level)
	return -1

/obj/item/device/radio/headset/syndicate //disguised to look like a normal headset for stealth ops
	origin_tech = "syndicate=3"

/obj/item/device/radio/headset/syndicate/alt //undisguised bowman with flash protection
	name = "syndicate headset"
	desc = "A syndicate headset that can be used to hear all radio frequencies. Protects ears from flashbangs. \nTo access the syndicate channel, use ; before speaking."
	flags = EARBANGPROTECT
	origin_tech = "syndicate=3"
	icon_state = "syndie_headset"
	item_state = "syndie_headset"

/obj/item/device/radio/headset/syndicate/New()
	..()
	make_syndie()

/obj/item/device/radio/headset/binary
	origin_tech = "syndicate=3"
/obj/item/device/radio/headset/binary/New()
	..()
	qdel(keyslot)
	keyslot = new /obj/item/device/encryptionkey/binary
	recalculateChannels()

/obj/item/device/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force. \nTo access the security channel, use :s."
	icon_state = "sec_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/headset_sec/alt
	name = "security bowman headset"
	desc = "This is used by your elite security force. Protects ears from flashbangs. \nTo access the security channel, use :s."
	flags = EARBANGPROTECT
	icon_state = "sec_headset_alt"
	item_state = "sec_headset_alt"

/obj/item/device/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls. \nTo access the engineering channel, use :e. "
	icon_state = "eng_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists, who cannot decide between departments. \nTo access the engineering channel, use :e. For research, use :n."
	icon_state = "rob_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_rob

/obj/item/device/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay. \nTo access the medical channel, use :m."
	icon_state = "med_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual. \nTo access the science channel, use :n."
	icon_state = "sci_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_sci

/obj/item/device/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science. \nTo access the medical channel, use :m. For science, use :n."
	icon_state = "medsci_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_medsci

/obj/item/device/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel. \nTo access the command channel, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_com

/obj/item/device/radio/headset/heads/captain
	name = "\proper the captain's headset"
	desc = "The headset of the king. \nChannels are as follows: :c - command, :s - security, :e - engineering, :u - supply, :v - service, :m - medical, :n - science."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/captain/alt
	name = "\proper the captain's bowman headset"
	desc = "The headset of the boss. Protects ears from flashbangs. \nChannels are as follows: :c - command, :s - security, :e - engineering, :u - supply, :v - service, :m - medical, :n - science."
	flags = EARBANGPROTECT
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"

/obj/item/device/radio/headset/heads/rd
	name = "\proper the research director's headset"
	desc = "Headset of the fellow who keeps society marching towards technological singularity. \nTo access the science channel, use :n. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/rd

/obj/item/device/radio/headset/heads/hos
	name = "\proper the head of security's headset"
	desc = "The headset of the man in charge of keeping order and protecting the station. \nTo access the security channel, use :s. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/heads/hos/alt
	name = "\proper the head of security's bowman headset"
	desc = "The headset of the man in charge of keeping order and protecting the station. Protects ears from flashbangs. \nTo access the security channel, use :s. For command, use :c."
	flags = EARBANGPROTECT
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"

/obj/item/device/radio/headset/heads/ce
	name = "\proper the chief engineer's headset"
	desc = "The headset of the guy in charge of keeping the station powered and undamaged. \nTo access the engineering channel, use :e. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/ce

/obj/item/device/radio/headset/heads/cmo
	name = "\proper the chief medical officer's headset"
	desc = "The headset of the highly trained medical chief. \nTo access the medical channel, use :m. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/cmo

/obj/item/device/radio/headset/heads/hop
	name = "\proper the head of personnel's headset"
	desc = "The headset of the guy who will one day be captain. \nChannels are as follows: :u - supply, :v - service, :c - command."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/hop

/obj/item/device/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the QM and his slaves. \nTo access the supply channel, use :u."
	icon_state = "cargo_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_srv
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping the station full, happy and clean. \nTo access the service channel, use :v."
	icon_state = "srv_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/headset_service

/obj/item/device/radio/headset/headset_cent
	name = "\improper Centcom headset"
	desc = "A headset used by the upper echelons of Nanotrasen. \nChannels are as follows: :c - command, :s - security, :e - engineering, :u - supply, :v - service, :m - medical, :n - science."
	icon_state = "cent_headset"
	item_state = "headset"
	keyslot = new /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/ai
	name = "\proper Integrated Subspace Transceiver "
	keyslot2 = new /obj/item/device/encryptionkey/ai

/obj/item/device/radio/headset/ai/receive_range(freq, level)
	return ..(freq, level, 1)

/obj/item/device/radio/headset/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
//	..()
	user.set_machine(src)
	if (!( istype(W, /obj/item/weapon/screwdriver) || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(keyslot || keyslot2)


			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.loc = T
					keyslot = null



			if(keyslot2)
				var/turf/T = get_turf(user)
				if(T)
					keyslot2.loc = T
					keyslot2 = null

			recalculateChannels()
			user << "You pop out the encryption keys in the headset!"

		else
			user << "This headset doesn't have any unique encryption keys!  How useless..."

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot && keyslot2)
			user << "The headset can't hold another key!"
			return

		if(!keyslot)
			user.drop_item()
			W.loc = src
			keyslot = W

		else
			user.drop_item()
			W.loc = src
			keyslot2 = W


		recalculateChannels()

	return


/obj/item/device/radio/headset/recalculateChannels()
	..()
	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			src.translate_binary = 1

		if(keyslot2.translate_hive)
			src.translate_hive = 1

		if(keyslot2.syndie)
			src.syndie = 1


	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = add_radio(src, radiochannels[ch_name])

	return
