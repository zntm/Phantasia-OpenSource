function structure_cactus(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;

	var _length = irandom_range(3, 7);
	
	var i = 0;
	
	repeat (_length + 1)
	{
		tile_place(_x, _y - i++, _z, new Tile(ITEM.CACTUS)
			.set_index((i == _length ? irandom_range(5, 6) : irandom_range(1, 4))));
	}
}