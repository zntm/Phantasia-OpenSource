function get_key_name(_value)
{
	
	
	switch (_value)
	{
		case vk_control:   return "Ctrl";
		case vk_shift:     return "Shift";
		case vk_tab:       return "Tab";
		case vk_escape:    return "Escape";
		case vk_space:     return "Enter";
		case vk_backspace: return "Bkspc";
	}
	
	return string_upper(chr(_value));
}