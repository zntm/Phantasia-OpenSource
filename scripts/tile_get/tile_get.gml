/// @func tile_get(x, y, z, [attribute])
/// @desc Gets the tile's item ID in the world at any given point.
/// @arg {Real} x The x position the _tile will be collected at
/// @arg {Real} y The y position the _tile will be collected at
/// @arg {Real} z The z position the _tile will be collected at
/// @arg {String} attribute The attribute of the tile will be collected at ("all" for whole data)
function tile_get(_x, _y, _z, _attribute = "item_id")
{
	if (_y < 0) || (_y >= WORLD_HEIGHT)
	{
		return ITEM.EMPTY;
	}
	
	var _cx = floor(_x / CHUNK_SIZE_X) * CHUNK_SIZE_WIDTH;
	var _cy = floor(_y / CHUNK_SIZE_Y) * CHUNK_SIZE_HEIGHT;
	
	var _inst = instance_position(_cx, _cy, obj_Chunk);
	
	if (!instance_exists(_inst))
	{
		_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
	}
	
	var _tile = _inst.chunk[(_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))];
	
	if (_tile == ITEM.EMPTY)
	{
		return ITEM.EMPTY;
	}
	
	return (_attribute == "all" ? _tile : _tile[$ _attribute]);
}