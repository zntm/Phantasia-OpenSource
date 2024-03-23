function structure_bamboo(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;
	
	var _xoffset = irandom_range(-2, 2);
	var _height = irandom_range(8, 20);
	
	for (var i = 0; i <= _height; ++i)
	{
		if (tile_get(_x, _y - i, _z) != ITEM.EMPTY) continue;
		
		var _index;
		
		if (i == _height)
		{
			_index = 4;
		}
		else if (i > _height - 4) && (chance(0.4))
		{
			_index = 3;
		}
		else
		{
			_index = irandom_range(1, 2);
		}
		
		tile_place(_x, _y - i, _z, new Tile(ITEM.BAMBOO)
			.set_xoffset(_xoffset)
			.set_index(_index));
	}
}