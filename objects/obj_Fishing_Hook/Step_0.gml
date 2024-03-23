if (point_distance(x, y, owner.x, owner.y) > 16 * 24)
{
	instance_destroy();
	
	exit;
}

var _delta_time = global.delta_time;

if (!tile_meeting(x, y, CHUNK_DEPTH_LIQUID, ITEM_TYPE.LIQUID))
{
	if (!tile_meeting(x, y + 1))
	{
		var _sign = sign(xvelocity);
		var _speed = abs(xvelocity * _delta_time);
	
		var _x;
	
		var _travel = _speed;
		
		repeat (ceil(_speed))
		{
			_x = x + (_travel >= 1 ? _sign : _travel * _sign);
			
			if (tile_meeting(_x, y))
			{
				xvelocity = 0;
				
				break;
			}
			
			x = _x;
		}
	}
	else
	{
		xvelocity = 0;
		yvelocity = 0;
	}
}
else
{
	xvelocity = 0;
	yvelocity -= 0.8;
	
	if (caught == ITEM.EMPTY)
	{
		var _x = round(x / TILE_SIZE);
		var _y = round(y / TILE_SIZE);
		
		var _liquid = tile_get(_x, _y, CHUNK_DEPTH_LIQUID);
		
		if (_liquid != ITEM.EMPTY)
		{
			var _biome = global.world_data[global.world.environment.value & 0xf].surface_biome;
			var _data = global.surface_biome_data[(is_method(_biome) ? _biome(_x, _y, global.world.info.seed) : SURFACE_BIOME.GREENIA)].fishing_loot;
		
			if (_data != -1) && (chance(0.05 * _delta_time * accessory_get_buff(BUFF_FISHING_LURE, obj_Player)))
			{
				var _caught = choose_weighted(_data[$ string(_liquid)]);
				
				if (_caught.fishing_power <= global.item_data[item_id].fishing_power + accessory_get_buff(BUFF_FISHING_POWER, obj_Player))
				{
					caught = _caught;
					yvelocity += 4;
				}
			}
		}
	}
}

if (caught != ITEM.EMPTY) && (chance(0.03 * _delta_time))
{
	caught = ITEM.EMPTY;
}

var _velocity = PHYSICS_GLOBAL_GRAVITY * _delta_time / 2;

yvelocity = clamp(yvelocity + _velocity, -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);
	
var _yvelocity = yvelocity * _delta_time;

yvelocity = clamp(yvelocity + _velocity, -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);

var _sign = sign(_yvelocity);
var _speed = abs(_yvelocity * _delta_time);

var _y;

var _travel = _speed;
	
repeat (ceil(_speed))
{
	_y = y + (_travel >= 1 ? _sign : _travel * _sign);
	
	if (tile_meeting(x, _y))
	{
		yvelocity = 0;
		
		break;
	}
	
	y = _y;
}