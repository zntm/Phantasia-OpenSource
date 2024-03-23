function tile_set(_x, _y, _z, _attribute, _value)
{
	if (_y < 0) || (_y >= WORLD_HEIGHT) exit;
	
	var _cx = floor(_x / CHUNK_SIZE_X) * CHUNK_SIZE_WIDTH;
	var _cy = floor(_y / CHUNK_SIZE_Y) * CHUNK_SIZE_HEIGHT;
	
	var _inst = instance_position(_cx, _cy, obj_Chunk);
	
	if (!instance_exists(_inst))
	{
		_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
		_inst.chunk[@ (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))][$ attribute] = value;
		
		exit;
	}
	
	var _index = (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT));
	
	if (_inst.chunk[_index] != ITEM.EMPTY)
	{
		_inst.chunk[@ _index][$ _attribute] = _value;
	}
}