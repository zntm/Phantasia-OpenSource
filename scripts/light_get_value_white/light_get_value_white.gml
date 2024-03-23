function light_get_value_white(_x, _y, _lights, _length, enable_lighting = global.local_settings.enable_lighting)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline"); 
	}
	
	if (DEV_MODE && !enable_lighting) || (_y < 256 * TILE_SIZE)
	{
		return c_white;
	}
	
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
	var _temp_r;
	
	var _light;
	var _val;
	var _v;
	
	var _x1;
	var _y1;
	var _x2;
	var _y2;
	
	var _e;
	var _f;
	
	
	var i = 0;
	
	repeat (_length)
	{
		_light = _lights[i++];
		
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
				_v = _light[4] >> 24;
				_temp_r = (_v & 0x80 ? 127 - (_v & 0x7f) : 127 + (_v & 0x7f));
			}
			else
			{
				if (_f >= 127) continue;
					
				_val = 127 - _f;
				
				_v = _light[4] >> 24;
				_temp_r = (_v & 0x80 ? _val - (_v & 0x7f) : _val + (_v & 0x7f));
			}
		}
		else if (_f <= 0)
		{
			if (_e >= 127) continue;
					
			_val = 127 - _e;
			
			_v = _light[4] >> 24;
			_temp_r = (_v & 0x80 ? _val - (_v & 0x7f) : _val + (_v & 0x7f));
		}
		else if (_e < 127) && (_f < 127)
		{
			_val = __values[((_e << 7) | _f) & 0x3fff];
				
			if (_val <= 0) continue;
			
			_v = _light[4] >> 24;
			_temp_r = (_v & 0x80 ? _val - (_v & 0x7f) : _val + (_v & 0x7f));
		}
		else continue;
		
		if (_r < _temp_r)
		{
			_r = _temp_r;
		}
	}
	
	var _c = _r & 0xff;
	
	return ((_c << 16) | (_c << 8) | _c) << 1;
}