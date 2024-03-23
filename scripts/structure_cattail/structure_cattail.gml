function structure_cattail(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;
			
	var i = 0;
	var _length = irandom_range(3, 6);
	
	repeat (_length)
	{
		tile_place(_x, _y - i++, _z, new Tile(ITEM.CATTAIL)
			.set_index(0));
	}
	
	tile_place(_x, _y - i, _z, new Tile(ITEM.CATTAIL)
		.set_index(1));
}