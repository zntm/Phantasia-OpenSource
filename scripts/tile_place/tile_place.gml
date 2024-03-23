/// @func tile_place(x, y, z, tile)
/// @desc Place a tile in the world at any given point.
/// @arg {Real} x The x position the tile will be placed at
/// @arg {Real} y The y position the tile will be placed at
/// @arg {Real} z The z position the tile will be placed at
/// @arg {Any} tile A structure that is created using the Tile() constructor function
function tile_place(_x, _y, _z, _tile)
{
	if (_y < 0) || (_y >= WORLD_HEIGHT) exit;
	
	var _cx = floor(_x / CHUNK_SIZE_X) * CHUNK_SIZE_WIDTH;
	var _cy = floor(_y / CHUNK_SIZE_Y) * CHUNK_SIZE_HEIGHT;
	
	var _inst = instance_position(_cx, _cy, obj_Chunk);

	if (!instance_exists(_inst))
	{
		_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
		
		_inst.is_refresh = true;
		_inst.surface_display = _inst.surface_display | (1 << _z);
		
		_inst.chunk[@ (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile;
		
		exit;
	}
	
	tile_instance_destroy(_x, _y, _z);

	var _item_data = global.item_data;
	
	_inst.chunk[@ (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile;
	
	if (!_inst.is_generated)
	{
		_inst.chunk[@ (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile;
		
		#region Check if surrounding tiles are invalid after tile place update
		
		#macro TILE_UPDATE_SURRUNDING_THRESHOLD 1
		
		var _xoffset;
		var _yoffset;
		
		var _tile_x;
		var _tile_y;
		
		var _ystart = _inst.chunk_ystart + _y;
		
		var _t;
		var _data;
		
		var _place_requirement;
		var _drops;
		
		var _inst_x = _x * TILE_SIZE;
		var _inst_y = _y * TILE_SIZE;
		
		_xoffset = -TILE_UPDATE_SURRUNDING_THRESHOLD;
	
		repeat ((TILE_UPDATE_SURRUNDING_THRESHOLD * 2) + 1)
		{
			_tile_x = _x + _xoffset++;
			
			_yoffset = -TILE_UPDATE_SURRUNDING_THRESHOLD;
		
			repeat ((TILE_UPDATE_SURRUNDING_THRESHOLD * 2) + 1)
			{
				_tile_y = _y + _yoffset++;
				
				_t = tile_get(_tile_x, _tile_y, _z);
				
				if (_t == ITEM.EMPTY) continue;
				
				_data = _item_data[_t];
				_place_requirement = _data.place_requirement;
					
				if (_place_requirement == -1) || (_place_requirement(_tile_x, _tile_y, _z))
				{
					tile_update(_tile_x, _tile_y, _z);
					
					continue;
				}
				
				_drops = _data.drops;
							
				if (is_array(_drops))
				{
					_drops = choose_weighted(_drops);
				}
				
				spawn_drop(_inst_x, _inst_y, _drops, 1, 0, 0);
				tile_place(_x, _ystart, _z, ITEM.EMPTY);
			}
		}
		
		#endregion
	}
	
	if (_tile == ITEM.EMPTY) exit;
	
	_inst.is_refresh = true;
	_inst.surface_display = _inst.surface_display | (1 << _z);
	
	var _on_place = _item_data[_tile.item_id].on_place;
		
	if (_on_place != -1)
	{
		_on_place(_x, _y, _z);
	}
	
	tile_instance_create(_x, _y, _z, _tile);
}