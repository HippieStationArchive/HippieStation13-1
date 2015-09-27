
/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	if(mind)	ticker.mode.remove_revolutionary(mind)
	if(mind)	ticker.mode.remove_gangster(mind)
	if(mind)	ticker.mode.remove_thrall(mind,0)
	if(mind)	ticker.mode.remove_shadowling(mind)
	sleep(5) //Hopefully this will be able to fix the issue where borgs don't have zeroth law when the AI is traitor.
	show_laws()

/mob/living/silicon/robot/update_hotkey_mode()
	winset(src, null, "mainwindow.macro=borghotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true input.background-color=#F0F0F0")

/mob/living/silicon/robot/update_normal_mode()
	winset(src, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")
