function structure_lumin_nub(_x, _y, _seed)
{
	
	
	var _z = CHUNK_DEPTH_PLANT;
	
	var _length = irandom_range(2, 5);
	
	var i = 0; 
	
	for (; i <= _length; ++i)
	{
		if (tile_get(_x, _y - i, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY)
		{
			if (i > 0)
			{
				tile_place(_x, _y - i, _z, new Tile(ITEM.LUMIN_NUB)
					.set_index(i == 1 ? choose(3, 7) : choose(2, 6)));	
			}
			
			exit;
		}
		
		tile_place(_x, _y - i, _z, new Tile(ITEM.LUMIN_NUB)
			.set_index(i == 0 ? choose(0, 4) : (i == _length ? choose(2, 6) : choose(1, 5))));
	}
}