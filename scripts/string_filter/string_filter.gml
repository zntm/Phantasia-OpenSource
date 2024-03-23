function string_filter(_string, _function)
{
	var _filtered_string = "";
	
	var _char;
	
	var i = 0;
	var _length = string_length(_string);
	
	repeat (_length)
	{
		_char = string_char_at(_string, i++);
		
		if (_function(_char))
		{
			_filtered_string += _char;
		}
	}
	
	return _filtered_string;
}