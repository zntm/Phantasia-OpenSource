function string_is_hex_colour(_string)
{
	static __allowed = "1234567890abcdef";
	
	if (string_starts_with(_string, "#"))
	{
		_string = string_delete(_string, 1, 1);
	}
	
	var _length = string_length(_string);
	
	if (_length != 6)
	{
		return -1;
	}
	
	_string = string_lower(_string);
	
	var i = 1;
		
	repeat (6)
	{
		if (string_pos(string_char_at(_string, i), __allowed) < 0)
		{
			return -1;
		}
			
		++i;
	}
		
	return real("0x" +
		string_char_at(_string, 5) + string_char_at(_string, 6) +
		string_char_at(_string, 3) + string_char_at(_string, 4) +
		string_char_at(_string, 1) + string_char_at(_string, 2));
}