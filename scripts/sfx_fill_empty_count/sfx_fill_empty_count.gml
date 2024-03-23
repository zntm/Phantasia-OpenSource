function sfx_fill_empty_count(_x, _y)
{
	if (global.sfx_fill_depth >= 16) exit;
	
	var _empty_count = 0;
	
	if (tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		++_empty_count;
	}
	
	if (tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		++_empty_count;
	}
	
	if (tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		++_empty_count;
	}
	
	if (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		++_empty_count;
	}
	
	global.sfx_fill_amount += _empty_count;
	global.sfx_fill_depth += _empty_count;
	
	if (_empty_count <= 2) exit;
	
	sfx_fill_empty_count(_x + 1, _y);
	sfx_fill_empty_count(_x, _y + 1);
	sfx_fill_empty_count(_x - 1, _y);
	sfx_fill_empty_count(_x, _y - 1);
}