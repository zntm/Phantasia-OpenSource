function structure_kelp(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;
			
	var i = 0;
	var _length = irandom_range(8, 16);
			
	for (; i <= _length; ++i)
	{
		if (_y - i <= WORLD_HEIGHT_CONSTANT) || (tile_get(_x, _y - i, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) break;
		
		tile_place(_x, _y - i, _z, new Tile(ITEM.KELP)
			.set_index(1));
	}
	
	if (i > 0)
	{
		tile_place(_x, _y - i, _z, new Tile(ITEM.KELP)
			.set_index(choose(2, 3)));
	}
}