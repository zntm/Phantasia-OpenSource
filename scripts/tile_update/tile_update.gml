function tile_update(_x, _y, _z)
{
	if (_y < 0) || (_y >= WORLD_HEIGHT) return;
	
	var _index = (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT));
	
	var _cx = floor(_x / CHUNK_SIZE_X) * CHUNK_SIZE_WIDTH;
	var _cy = floor(_y / CHUNK_SIZE_Y) * CHUNK_SIZE_HEIGHT;
	
	var _inst = instance_position(_cx, _cy, obj_Chunk);
		
	if (!instance_exists(_inst))
	{
		_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
	}
	
	var _tile = _inst.chunk[_index];
	
	if (_tile == ITEM.EMPTY) exit;
	
	var _i = tile_update_connected(_x, _y, _z, _tile.item_id);
		
	if (_i == -1) exit;
	
	_inst.chunk[@ _index].flip_rotation_index = (_i << 8) | (_tile.flip_rotation_index & 0xfffff00ff);
}