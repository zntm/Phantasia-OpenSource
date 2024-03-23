function entity_fall(_multiplier = 1)
{
	var _diff = round((y - ylast) / TILE_SIZE);
			
	if (_diff > 10)
	{
		var _v = _multiplier * -(power(_diff / 1.44, 1.21) - 10);
		
		if (_v >= 0)
		{
			hp_add(id, _v, DAMAGE_TYPE.FALL);
		}
		
		if (object_index == obj_Player)
		{
			var _t = -_v / 8;
			
			if (_t > 0)
			{
				global.camera.shake = _t;
			}
		}
	}
	
	ylast = y;
}