function structure_vine(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;
	
	var _length = irandom_range(4, 14);
	
	for (var i = 0; i < _length; ++i)
	{
		if (tile_get(_x, _y + i, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) || (tile_get(_x, _y + i, _z) != ITEM.EMPTY) break;
		
		tile_place(_x, _y + i, _z, new Tile(ITEM.VINE)
			.set_index(chance(0.75) ? 0 : irandom_range(1, 4)));
	}
}