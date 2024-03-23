if (hotkey)
{
	if (mouse_check_button(mb_left))
	{
		hotkey = false;
		global.is_popup = false;
	}
	else if (keyboard_check(vk_anykey))
	{
		hotkey = false;
		inst.text = get_key_name(keyboard_key);
	
		global.settings[$ category][$ type].value = keyboard_key;
		global.is_popup = false;
	}
}