function cuteify_get_height(_string)
{
	var _strings = string_split(_string, "\n");
	var _strings_length = array_length(_strings);
	
	var i = 0;
	var _yoffset = 0;
	
	repeat (_strings_length)
	{
		_yoffset += string_height(_strings[i++]);
	}
	
	return _yoffset;
}