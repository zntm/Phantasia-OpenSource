function structure_lumin_vine(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;
	
	var _length = irandom_range(4, 14);
	
	for (var i = 0; i < _length; ++i)
	{
		if (tile_get(_x, _y + i, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) || (tile_get(_x, _y + i, _z) != ITEM.EMPTY) break;
		
		tile_place(_x, _y + i, _z, new Tile(ITEM.LUMIN_BERRY)
			.set_index(chance(0.75) ? 1 : 2));
	}
}