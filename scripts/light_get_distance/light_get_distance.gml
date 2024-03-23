function light_get_distance(_x, _y, _lights, _length, enable_lighting = global.local_settings.enable_lighting)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline"); 
	}
	
	if (DEV_MODE) && (!enable_lighting)
	{
		return true;
	}
	
	var _inst;
	var _q;
	var _w;
	
	var i = 0;
	
	repeat (_length)
	{
		_inst = _lights[i];
		
		#macro LIGHT_DISTANCE_THRESHOLD TILE_SIZE * 9
		
		if (_inst[0] - _x < LIGHT_DISTANCE_THRESHOLD) && (_x - _inst[2] < LIGHT_DISTANCE_THRESHOLD) && (_inst[1] - _y < LIGHT_DISTANCE_THRESHOLD) && (_y - _inst[3] < LIGHT_DISTANCE_THRESHOLD)
		{
			return true;
		}
		
		++i;
	}
	
	return false;
}
