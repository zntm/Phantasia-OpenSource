function Cuteify() constructor
{
	s_prefix = "";
	
	static set_sprite_prefix = function(_prefix)
	{
		s_prefix = _prefix;
		
		return self;
	}
	
	s_xoffset = 0;
	s_yoffset = 0;
	
	static set_sprite_offset = function(_xoffset, _yoffset)
	{
		s_xoffset = _xoffset;
		s_yoffset = _yoffset;
		
		return self;
	}
	
	bracket_open = "{";
	bracket_close = "}";
	
	static set_bracket = function(_open, _close)
	{
		bracket_open = _open;
		bracket_close = _close;
		
		return self;
	}
}

function draw_text_cuteify(_x, _y, _string, _xscale = 1, _yscale = 1, _angle = 0, _colour = draw_get_colour(), _alpha = 1, _data = -1)
{
	var _data_sprite_prefix;
	var _data_sprite_xoffset;
	var _data_sprite_yoffset;
	
	var _data_bracket_open;
	var _data_bracket_close;
	
	if (_data != -1)
	{
		_data_sprite_prefix = _data.s_prefix;
		_data_sprite_xoffset = _data.s_xoffset;
		_data_sprite_yoffset = _data.s_yoffset;
		
		_data_bracket_open = _data.bracket_open;
		_data_bracket_close = _data.bracket_close;
	}
	else
	{
		_data_sprite_prefix = "";
		_data_sprite_xoffset = 0;
		_data_sprite_yoffset = 0;
		
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
	
	var _current_halign = draw_get_halign();
	var _current_valign = draw_get_valign();
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	var _current_colour = draw_get_colour();
	var _current_alpha = draw_get_alpha();
	
	draw_set_colour(_colour);
	draw_set_alpha(_alpha);
	
	var _current_height;
	var _current_height_half;
	
	var _x2 = _x;
	
	if (_current_valign == fa_bottom)
	{
		_y -= (cuteify_get_height(_string) * _yscale);
	}
	else if (_current_valign == fa_middle)
	{
		_y -= (cuteify_get_height(_string) * _yscale / 2);
	}
	
	var _xoffset;
	var _yoffset = 0;
	
	var _strings = string_split(_string, "\n");
	var _strings_length = array_length(_strings);
	
	var _string_current;
	var _string_length;
	
	var _format;
	var _formatting;
	var _formats_index;
	var _formats_length_min;
	
	var _a;
	var _b;
	
	var _asset;
	var _char;
	var _continue;
	var _hex;
	var _open;
	
	var _asset_yoffset;
	var _asset_height;
	
	var _cos = dcos(_angle);
	var _sin = -dsin(_angle);
	
	var _angle_90 = _angle - 90;
	var _cos_90 = dcos(_angle_90);
	var _sin_90 = -dsin(_angle_90);
	
	repeat (_strings_length)
	{
		_string_current = _strings[i];
		_string_length = string_length(_string_current);
		
		_current_height = string_height(_string_current) * _yscale;
		_current_height_half = _current_height / 2;
		
		if (_current_halign == fa_right)
		{
			_x2 = _x - (cuteify_get_width(_string_current) * _xscale);
		}
		else if (_current_halign == fa_center)
		{
			_x2 = _x - (cuteify_get_width(_string_current) * _xscale / 2);
		}
		
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
					
					#region Format colours
					
					_hex = string_is_hex_colour(_format);
				
					if (_hex != -1)
					{
						draw_set_colour(_hex);
						
						_colour = _hex;
						_continue = true;
						
						++j;
						
						continue;
					}
					
					#endregion
					
					#region Draw sprite
					
					_asset = asset_get_index(_data_sprite_prefix + _format);
						
					if (_asset > -1) && (sprite_exists(_asset))
					{
						_asset_yoffset = sprite_get_yoffset(_asset);
						_asset_height = sprite_get_height(_asset);
						
						_a = _xoffset + ((_data_sprite_xoffset + sprite_get_xoffset(_asset)) * _xscale);
						_b = _yoffset + ((_data_sprite_yoffset + _asset_yoffset * _yscale) + ((_asset_height - _asset_yoffset) / _current_height)) - ((_asset_height * _asset_yoffset) / 256);
						
						draw_sprite_ext(_asset, 0, _x2 + (_b * _cos_90) + (_a * _cos), _y + (_b * _sin_90) + (_a * _sin), _xscale, _yscale, _angle, _colour, _alpha);
						
						_xoffset += sprite_get_width(_asset) * _xscale;
						_continue = true;
							
						++j;
							
						continue;
					}
					
					#endregion
					
					_continue = false;
				}
			
				if (_continue)
				{
					++j;
					
					continue;
				}
			}
			
			_char = string_char_at(_string_current, j);
			
			draw_text_transformed(_x2 + (_yoffset * _cos_90) + (_xoffset * _cos), _y + (_yoffset * _sin_90) + (_xoffset * _sin), _char, _xscale, _yscale, _angle);
		
			_xoffset += string_width(_char) * _xscale;
			
			++j;
		}
		
		_yoffset += _current_height;
		
		++i;
	}
	
	draw_set_colour(_current_colour);
	draw_set_alpha(_current_alpha);
	
	draw_set_halign(_current_halign);
	draw_set_valign(_current_valign);
}