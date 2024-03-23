#macro PHYSICS_GLOBAL_SLIPPERINESS 0.2

function physics_x(_direction, _speed, _slow_down = true, _collision = true, _step = -1)
{
	var _item_data = global.item_data;
	
	if (_slow_down)
	{
		var _slipperiness = PHYSICS_GLOBAL_SLIPPERINESS;
		
		var _x = round(x / TILE_SIZE);
		var _y = round(y / TILE_SIZE) + 1;
		
		var _tile = tile_get(_x, _y, CHUNK_DEPTH_DEFAULT);
		
		if (_tile == ITEM.EMPTY)
		{
			_tile = tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT);
			
			if (_tile == ITEM.EMPTY)
			{
				_tile = tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT);
				
				if (_tile != ITEM.EMPTY)
				{
					_slipperiness = _item_data[_tile].slipperiness;
				}
			}
			else
			{
				_slipperiness = _item_data[_tile].slipperiness;
			}
		}
		else
		{
			_slipperiness = _item_data[_tile].slipperiness;
		}
		
		var _travel = _slipperiness * global.delta_time;
		var _repeat = ceil(_travel);
		
		repeat (_repeat)
		{
			xvelocity = lerp(xvelocity, _direction, (_travel > 1 ? 1 : _travel));
			
			--_travel;
		}
	}
	
	if (xvelocity == 0)
	{
		return false;
	}
	
	var _sign = sign(xvelocity);
		
	image_xscale = _sign * abs(image_xscale);
	
	if (abs(_sign) > abs(xvelocity))
	{
		_sign = xvelocity;
	}
	
	_speed *= global.delta_time;
	
	var _delta_speed = _sign * _speed;
	
	var _x = x + _delta_speed;
	
	/*
	if (!_collision) || (_speed < TILE_SIZE && !tile_meeting(_x, y))
	{
		x = _x;
		
		return false;
	}
	*/
	
	var _travel = _speed;
	var _repeat = ceil(_speed);
	
	repeat (_repeat)
	{
		_x = x + (_travel >= 1 ? _sign : _travel * _sign);
		
		if (tile_meeting(_x, y))
		{
			xvelocity = 0;
				
			return true;
		}
		
		x = _x;
		
		if (_step != -1) && (_step(_x, y, id))
		{
			return false;
		}
		
		--_travel;
	}
	
	return false;
}