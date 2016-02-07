
/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	show_laws(0)
	if(mind)
		ticker.mode.remove_revolutionary(mind)
		ticker.mode.remove_gangster(mind,1,remove_bosses=1)
		ticker.mode.remove_thrall(mind,0)
		ticker.mode.remove_shadowling(mind)
		ticker.mode.remove_hog_follower(mind, 0)

/mob/living/silicon/robot/update_hotkey_mode()
	winset(src, null, "mainwindow.macro=borghotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true input.background-color=#F0F0F0")

/mob/living/silicon/robot/update_normal_mode()
	winset(src, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")
