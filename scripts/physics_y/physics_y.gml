function physics_y(_multiplier = 1, _gravity = PHYSICS_GLOBAL_GRAVITY, _nudge = true, _collision = true, _step = -1)
{
	
	
	var _delta_time = global.delta_time;
	var _velocity = _gravity * _multiplier * _delta_time / 2;
	
	yvelocity = clamp(yvelocity + _velocity, -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);
	
	var _yvelocity = yvelocity * _delta_time;
	
	yvelocity = clamp(yvelocity + _velocity, -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);
	
	if (_yvelocity == 0)
	{
		return false;
	}
	
	var _sign = sign(_yvelocity);
	var _speed = abs(_yvelocity);
	
	var _x;
	var _y = y + _yvelocity;
	
	/*
	if (!_collision) || (_speed < TILE_SIZE && !tile_meeting(x, _y))
	{
		y = _y;
		
		return false;
	}
	*/
	
	var _travel = _speed;
	var _repeat = ceil(_speed);
	var _val;
	var i = 0;
	var _nudged;
	
	repeat (_repeat)
	{
		_val = (_travel >= 1 ? _sign : _travel * _sign);
		
		_y = y + _val;
		
		if (_step != -1) && (_step(x, _y, id))
		{
			return false;
		}
		
		if (!tile_meeting(x, _y))
		{
			y = _y;
				
			continue;
		}
		
		// Nudge when almost at edge
		if (!_nudge) || (_val >= 0)
		{
			yvelocity = 0;
			
			return true;
		}
		
		_y = y - 1;
		_nudged = false;
			
		i = 1;
			
		repeat (PHYSICS_GLOBAL_THRESHOLD_NUDGE)
		{
			_x = x - i;
				
			if (!tile_meeting(_x, _y))
			{
				x = _x;
				_nudged = true;
				
				break;
			}
				
			_x = x + i;
			
			if (!tile_meeting(_x, _y))
			{
				x = _x;
				_nudged = true;
				
				break;
			}
			
			++i;
		}
			
		if (!_nudged)
		{
			yvelocity = 0;
				
			return true;
		}
		
		--_travel;
	}
	
	if (tile_meeting(x, y + 1)) || (tile_meeting(x, y - 1))
	{
		yvelocity = 0;
	}
	
	return false;
}