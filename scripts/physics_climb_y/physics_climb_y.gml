function physics_climb_y(_key_up, _key_down, _delta_time = global.delta_time)
{
	yvelocity = 0;
		
	var _tile_x = round(x / TILE_SIZE);
	var _moved = false;
		
	var _travel = PHYSICS_GLOBAL_CLIMB_YSPEED * _delta_time;
		
	var _repeat = ceil(_travel);
	var _sign = sign(_travel);
		
	var _val;
		
	if (_key_up)
	{
		repeat (_repeat)
		{
			_val = y - (_travel > 1 ? _sign : _travel);
				
			if (tile_get(_tile_x, round(_val / TILE_SIZE), CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) || (tile_meeting(x, _val)) break;
				
			y = _val;
			--_travel;
				
			_moved = true;
		}
	}
		
	if (_key_down)
	{
		repeat (_repeat)
		{
			_val = y + (_travel > 1 ? _sign : _travel);
				
			if (tile_get(_tile_x, round(_val / TILE_SIZE), CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) || (tile_meeting(x, _val)) break;
				
			y = _val;
			--_travel;
				
			_moved = true;
		}
	}
	
	return _moved;
}