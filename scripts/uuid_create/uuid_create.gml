function uuid_create()
{
	static _hex_chars = "0123456789abcdef";
	static _uuid_template = "xxxxxxxx-xxxx-4xxx-axxx-xxxxxxxxxxxx";
	
	randomize();
	
	var _uuid = "";
	var _index = 0;
	var _random_bits = irandom(0xffffffff);
    
	var _current_char;
	var _random_value;
	
	repeat (36)
	{
		_current_char = string_char_at(_uuid_template, _index + 1);
		_random_value = _random_bits & 0xf;
		
		_uuid += (_current_char == "x" ? string_char_at(_hex_chars, (_current_char == "x" ? _random_value : (_random_value & 0x3 | 0x8)) + 1) : _current_char);
        
		_random_bits = (_index % 8 == 0 ? irandom(0xffffffff) : (_random_bits >> 4));
        
		++_index;
	}
    
	return _uuid;
}