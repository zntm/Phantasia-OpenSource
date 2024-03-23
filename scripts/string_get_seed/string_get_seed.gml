function string_get_seed(_string)
{
	var _result = 0;
	var _length = string_length(_string);

	var i = 0;
	var j = _length - 1;
	
	repeat (_length)
	{
		_result += power(31, j - i++) * ord(string_char_at(_string, i));
	}
	
	return _result;
}