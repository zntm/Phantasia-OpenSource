function ctrl_structure(_camera_x, _camera_y, _camera_width, _camera_height)
{
	var _seed = global.world.info.seed;
	
	#macro WORLDGEN_STRUCTURE_OFFSET 128
	
	var _xstart = floor(_camera_x / TILE_SIZE) - WORLDGEN_STRUCTURE_OFFSET;
	
	var _surface_biome_data = global.surface_biome_data;
	var _surface_biome = global.world_data[global.world.environment.value & 0xf].surface_biome;
	var _surface_biome_function = is_method(_surface_biome);
	
	var _structure_data = global.structure_data;
	
	var i = 0;
	
	var _repeat = floor(_camera_width / TILE_SIZE) + (WORLDGEN_STRUCTURE_OFFSET * 2);
	
	repeat (_repeat)
	{
		var _n = _xstart + i++;
		var _ysurface = worldgen_get_ysurface(_n, _seed);
		
		random_set_seed((_seed + _n) & 0xffffffffffff);
		
		var _structure_surface = _surface_biome_data[(_surface_biome_function ? _surface_biome(_n, _ysurface, _seed, _ysurface) : _surface_biome)].structure_surface;
		var _length = array_length(_structure_surface);
		
		if (_length <= 0) continue;
		
		var _x = _n * TILE_SIZE;
		var _y = _ysurface * TILE_SIZE;
		
		var j = 0;
			
		repeat (_length)
		{
			var _s = _structure_surface[j];
			var _structure = _structure_data[$ _s];
				
			if (random(1) >= _structure.chance)
			{
				++j;
					
				continue;
			}
			
			var _xscale = _structure.width;
			var _yscale = _structure.height;
			
			var _x2 = _x + (_structure.xoffset * TILE_SIZE);
			var _y2 = _y + (_structure.yoffset * TILE_SIZE);
			
			if (_xscale % 2 == 0)
			{
				_x2 -= TILE_SIZE / 2;
			}
			
			if (_yscale % 2 == 0)
			{
				_y2 -= TILE_SIZE / 2;
			}
					
			var _x1 = _xscale * TILE_SIZE / 2;
			var _y1 = _yscale * TILE_SIZE / 2;
			
			if (collision_rectangle(_x2 - _x1, _y2 - _y1, _x2 + _x1, _y2 + _y1, obj_Structure, false, true))
			{
				++j;
					
				continue;
			}
			
			with (instance_create_layer(_x2 - (round(_x1 / TILE_SIZE) * TILE_SIZE), _y2 - (round(_y1 / TILE_SIZE) * TILE_SIZE), "Instances", obj_Structure))
			{
				image_xscale = _xscale;
				image_yscale = _yscale;
					
				structure = _s;
				structure_id = irandom_range(1, 0xffff);
				
				if (place_meeting(x, y, obj_Structure))
				{
					instance_destroy();
				}
			}
			
			break;
		}
	}
}