function structure_moss_clump(_x, _y, _seed)
{
	
	
	var _moss = new Tile(ITEM.MOSS);
	var _moss_wall = new Tile(ITEM.MOSS_WALL);
	
	tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, _moss);
	
	if (irandom(2))
	{
		tile_place(_x, _y - 1, CHUNK_DEPTH_DEFAULT, _moss);
		
		if (irandom(2))
		{
			tile_place(_x - 1, _y, CHUNK_DEPTH_DEFAULT, _moss);
		}
		
		if (irandom(2))
		{
			tile_place(_x + 1, _y, CHUNK_DEPTH_DEFAULT, _moss);
		}
	}
	
	var _size = (irandom(2) ? 2 : 3);
	
	for (var i = -_size; i <= _size; ++i)
	{
		for (var j = -_size; j <= _size; ++j)
		{
			if (abs(i) == _size) && (abs(j) == _size) continue;
			
			if (tile_get(_x + i, _y + j, CHUNK_DEPTH_WALL) == ITEM.EMPTY)
			{
				tile_place(_x + i, _y + j, CHUNK_DEPTH_WALL, _moss_wall);
			}
		}
	}
}