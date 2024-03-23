function cuteify_get_width(_string, _data = -1)
{
	var _data_sprite_prefix;
	
	var _data_bracket_open;
	var _data_bracket_close;
	
	if (_data != -1)
	{
		_data_sprite_prefix = _data.s_prefix;
		
		_data_bracket_open = _data.bracket_open;
		_data_bracket_close = _data.bracket_close;
	}
	else
	{
		_data_sprite_prefix = "";
		
		_data_bracket_open = "{";
		_data_bracket_close = "}";
	}
	
	#region Static variables
	
	static __bracket_pos_open = [];
	static __bracket_pos_close = [];
	
	static __bracket_length_open = [];
	static __bracket_length_close = [];
	
	static __formats = [];
	static __formats_length = [];
	
	#endregion
	
	var i = 0;
	var j;
	var l;
	
	var _xoffset;
	var _xoffset_max = 0;
	
	var _strings = string_split(_string, "\n");
	var _strings_length = array_length(_strings);
	
	var _string_current;
	var _string_length;
	
	var _format;
	var _formatting;
	var _formats_index;
	var _formats_length_min;
	
	var _asset;
	var _char;
	var _continue;
	var _hex;
	var _open;
	
	repeat (_strings_length)
	{
		_string_current = _strings[i];
		_string_length = string_length(_string_current);
		
		__bracket_length_open[@ i] = 0;
		__bracket_length_close[@ i] = 0;
		
		__formats_length[@ i] = 0;
		
		#region Get bracket positions
		
		j = 1;
		
		repeat (_string_length)
		{
			_char = string_char_at(_string_current, j);
			
			if (_char == _data_bracket_open)
			{
				__bracket_pos_open[@ i][@ __bracket_length_open[i]++] = j;
			}
			else if (_char == _data_bracket_close)
			{
				__bracket_pos_close[@ i][@ __bracket_length_close[i]++] = j;
			}
			
			++j;
		}
		
		#endregion
		
		#region Get formatting
		
		_formats_length_min = min(__bracket_length_open[i], __bracket_length_close[i]);
	
		j = 0;
		
		repeat (_formats_length_min)
		{
			if (j >= __bracket_length_open[i]) || (j >= __bracket_length_close[i]) break;
			
			_open = __bracket_pos_open[i][j];
			_format = string_copy(_string_current, _open, __bracket_pos_close[i][j] - _open + 1);
		
			__formats[@ i][@ __formats_length[i]++] = _format;
			
			++j;
		}
		
		#endregion
	
		_xoffset = 0;
		_continue = false;
	
		_formats_index = 0;
	
		j = 1;
	
		repeat (_string_length)
		{
			_formatting = false;
		
			l = 0;
			
			repeat (__formats_length[i])
			{
				if (j < __bracket_pos_open[i][l]) || (j > __bracket_pos_close[i][l])
				{
					++l;
					
					continue;
				}
				
				_formatting = true;
				
				break;
			}
		
			if (_formatting)
			{
				if (_formats_index < __formats_length[i]) && (j == __bracket_pos_open[i][_formats_index])
				{
					_format = string_delete(__formats[i][_formats_index++], 1, 1);
					_format = string_delete(_format, string_length(_format), 1);
					
					_hex = string_is_hex_colour(_format);
				
					if (_hex != -1)
					{
						_continue = true;
						
						++j;
						
						continue;
					}
					
					_asset = asset_get_index(_data_sprite_prefix + _format);
						
					if (_asset > -1) && (sprite_exists(_asset))
					{
						_xoffset += sprite_get_width(_asset);
						_continue = true;
							
						++j;
							
						continue;
					}
					
					_continue = false;
				}
			
				if (_continue)
				{
					++j;
					
					continue;
				}
			}
			
			_xoffset += string_width(string_char_at(_string_current, j));
			
			++j;
		}
		
		_xoffset_max = max(_xoffset, _xoffset_max);
		
		++i;
	}
	
	return _xoffset_max;
}