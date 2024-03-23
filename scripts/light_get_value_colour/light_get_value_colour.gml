function light_get_value_colour(_x, _y, _lights, _length, enable_lighting = global.local_settings.enable_lighting)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline"); 
	}
	
	if (DEV_MODE && !enable_lighting) || (_y < 256 * TILE_SIZE)
	{
		return c_white;
	}
	
	#macro LIGHT_COLOUR_CACHE_AMOUNT 127
	
	static __init = false;
	static __values = [];
	
	if (!__init)
	{
		__init = true;

		var i = 0;
		var j;
		
		var ii;
		
		repeat (LIGHT_COLOUR_CACHE_AMOUNT)
		{
			ii = i * i;
	
			j = 0;
			
			repeat (LIGHT_COLOUR_CACHE_AMOUNT)
			{
				__values[@ (i << 7) | j] = round(127 - sqrt(ii + (j * j)));
				
				++j;
			}
			
			++i;
		}
	}
	
	var _r = 0;
	var _g = 0;
	var _b = 0;
	
	var _light;
	var _val;
	var _c;
	
	var _x1;
	var _y1;
	var _x2;
	var _y2;
	
	var _e;
	var _f;
	
	var _temp_r;
	var _temp_g;
	var _temp_b;
	
	var i = 0;
	
	repeat (_length)
	{
		_light = _lights[i++]
		
		_x1 = _light[0] - _x;
		_x2 = _x - _light[2];
		
		_y1 = _light[1] - _y;
		_y2 = _y - _light[3];
		
		_e = (_x1 > _x2 ? _x1 : _x2);
		_f = (_y1 > _y2 ? _y1 : _y2);
		
		if (_e <= 0)
		{
			if (_f <= 0)
			{
				_c = _light[4];
			
				_temp_r = (_c & 0x800000 ? 127 - ((_c >> 16) & 0x7f) : 127 + ((_c >> 16) & 0x7f));
				_temp_g = (_c & 0x8000 ? 127 - ((_c >> 8) & 0x7f) : 127 + ((_c >> 8) & 0x7f));
				_temp_b = (_c & 0x80 ? 127 - (_c & 0x7f) : 127 + (_c & 0x7f));
			}
			else
			{
				if (_f >= 127) continue;
					
				_val = 127 - _f;
				_c = _light[4];
			
				_temp_r = (_c & 0x800000 ? _val - ((_c >> 16) & 0x7f) : _val + ((_c >> 16) & 0x7f));
				_temp_g = (_c & 0x8000 ? _val - ((_c >> 8) & 0x7f) : _val + ((_c >> 8) & 0x7f));
				_temp_b = (_c & 0x80 ? _val - (_c & 0x7f) : _val + (_c & 0x7f));
			}
		}
		else if (_f <= 0)
		{
			if (_e >= 127) continue;
					
			_val = 127 - _e;
			_c = _light[4];
			
			_temp_r = (_c & 0x800000 ? _val - ((_c >> 16) & 0x7f) : _val + ((_c >> 16) & 0x7f));
			_temp_g = (_c & 0x8000 ? _val - ((_c >> 8) & 0x7f) : _val + ((_c >> 8) & 0x7f));
			_temp_b = (_c & 0x80 ? _val - (_c & 0x7f) : _val + (_c & 0x7f));
		}
		else if (_e < 127) && (_f < 127)
		{
			_val = __values[((_e << 7) | _f) & 0x3fff];
				
			if (_val <= 0) continue;
			
			_c = _light[4];
			
			_temp_r = (_c & 0x800000 ? _val - ((_c >> 16) & 0x7f) : _val + ((_c >> 16) & 0x7f));
			_temp_g = (_c & 0x8000 ? _val - ((_c >> 8) & 0x7f) : _val + ((_c >> 8) & 0x7f));
			_temp_b = (_c & 0x80 ? _val - (_c & 0x7f) : _val + (_c & 0x7f));
		}
		else continue;
		
		if (_r < _temp_r)
		{
			_r = _temp_r;
		}
		
		if (_g < _temp_g)
		{
			_g = _temp_g;
		}
		
		if (_b < _temp_b)
		{
			_b = _temp_b;
		}
	}
	
	return (((_b & 0xff) << 16) | ((_g & 0xff) << 8) | (_r & 0xff)) << 1;
}