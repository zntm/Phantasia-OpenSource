
#macro CREATURE_SPAWNING_CHANCE 0.04
#macro CREATURE_SPAWNING_CAVE_CHANCE 0.1
#macro CREATURE_SPAWNING_CAMERA_EDGE_XOFFSET 64
#macro CREATURE_SPAWNING_CAMERA_EDGE_YOFFSET 128

function ctrl_creature_spawn()
{
	if (!chance(0.01 * global.delta_time)) exit;
	
	var _camera = global.camera;
	
	var _camera_x = _camera.x;
	var _camera_y = _camera.y;
	
	var _camera_width  = _camera.width;
	var _camera_height = _camera.height;
	
	var _x = choose(_camera_x - (TILE_SIZE * 2), _camera_x + _camera_width + (TILE_SIZE * 2));
	var _y = random_range(_camera_y, _camera_y + _camera_height);
	
	var _tile_x = round(_x / TILE_SIZE);
	var _tile_y = round(_y / TILE_SIZE);
	
	// TODO: Update to check within creature size instead of only above
	var _t = tile_get(_tile_x, _tile_y, CHUNK_DEPTH_DEFAULT, "all");
	
	if (_t == ITEM.EMPTY) || ((_t.boolean & 1) == 0) exit;
	
	var _t2 = tile_get(_tile_x, _tile_y - 1, CHUNK_DEPTH_DEFAULT, "all");
	
	if (_t2 != ITEM.EMPTY) && (_t2.boolean & 1) exit;
	
	var _world = global.world;
		
	var _attributes = global.world_data[_world.environment.value & 0xf];
	var _seed = _world.info.seed;
		
	var _biome = _attributes.cave_biome;
		_biome = (is_method(_biome) ? _biome(_tile_x, _tile_y, _seed) : (_biome != -1 ? _biome : (_tile_y > EMUSTONE_YSTART ? CAVE_BIOME.EMUSTONE : CAVE_BIOME.STONE)));
		
	var _data;
		
	if (_biome != -1)
	{
		_data = global.cave_biome_data[_biome];
	}
	else
	{
		_biome = _attributes.surface_biome;
		_data = global.surface_biome_data[(is_method(_biome) ? _biome(_x, _y, _seed) : (_biome != -1 ? _biome : SURFACE_BIOME.GREENIA))];
	}
		
	var _creatures = _data.passive_creatures;
	var _length = array_length(_creatures);
		
	if (_length > 0) && (array_contains(_data.passive_creatures_tile, tile_get(_tile_x, _tile_y + 1, CHUNK_DEPTH_DEFAULT))) && (tile_get(_tile_x, _tile_y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		repeat (irandom_range(1, 3))
		{
			spawn_creature(_x, _y, _creatures[irandom(_length - 1)]);
		}
	}
}