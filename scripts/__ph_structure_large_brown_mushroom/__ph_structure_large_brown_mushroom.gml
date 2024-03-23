function __ph_structure_large_brown_mushroom(px, py, seed)
{
	
	
	// worldgen_set_seed(px, py, seed);
	
	var mushroom = ITEM.BROWN_MUSHROOM_BLOCK;
	var stem = ITEM.MUSHROOM_STEM_BLOCK;
	
	var depth_mushrooom = CHUNK_DEPTH_DEFAULT;
	var depth_stem = CHUNK_DEPTH_DEFAULT + choose(-1, 1);
	
	for (var i = -4; i < irandom_range(2, 5); ++i)
	{
		tile_place(px, py, depth_stem, new Tile(stem));
		
		--py;
	}

	for (var j = 0; j < 2; ++j)
	{
		for (var k = -3; k < 4; ++k)
		{
			if (j == 1) && (k == -3 || k == 3)
			{
				if (irandom(2) > 0)
				{
					tile_place(px + k, py, CHUNK_DEPTH_DEFAULT + choose(-1, 1), new Tile(ITEM.BROWN_MUSHROOM));
				}
				
				continue;
			}
			
			tile_place(px + k, py, depth_mushrooom, new Tile(mushroom));
			
			if (irandom(2) > 0) && (tile_get(px + k, py - 1, depth_mushrooom) == ITEM.EMPTY) && (tile_get(px + k, py + 1, depth_mushrooom) == mushroom)
			{
				tile_place(px + k, py - 1, CHUNK_DEPTH_DEFAULT + choose(-1, 1), new Tile(ITEM.BROWN_MUSHROOM));
			}
		}
		
		--py;
	}
	
	if (irandom(2) > 0)
	{
		var _x = px + irandom_range(-1, 1);
	
		for (var l = 0; l < irandom_range(2, 3); ++l)
		{
			tile_place(_x, py, depth_stem, new Tile(stem));
		
			--py;
		}
	
		for (var m = 0; m < 2; ++m)
		{
			for (var n = -2; n < 3; ++n)
			{
				if (m == 1) && (n == -2 || n == 2)
				{
					if (irandom(2) > 0)
					{
						tile_place(_x + n, py, CHUNK_DEPTH_DEFAULT + choose(-1, 1), new Tile(ITEM.BROWN_MUSHROOM));
					}
				
					continue;
				}
			
				tile_place(_x + n, py, depth_mushrooom, new Tile(mushroom));
			
				if (irandom(2) > 0) && (tile_get(_x + n, py - 1, depth_mushrooom) == ITEM.EMPTY) && (tile_get(_x + n, py + 1, depth_mushrooom) == ITEM.BROWN_MUSHROOM_BLOCK)
				{
					tile_place(_x + n, py - 1, CHUNK_DEPTH_DEFAULT + choose(-1, 1), new Tile(ITEM.BROWN_MUSHROOM));
				}
			}
		
			--py;
		}
	}
	
	for (var o = -4; o < 9; ++o)
	{
		if (o == 0) continue;
		
		py = worldgen_get_ysurface(px + o, seed);
		
		if (tile_get(px + o, py, CHUNK_DEPTH_DEFAULT - 1) != ITEM.EMPTY)
		{
			tile_place(px + o, py, CHUNK_DEPTH_DEFAULT - 1, new Tile(ITEM.BROWN_MUSHROOM));
					
			continue;
		}
				
		if (tile_get(px + o, py, CHUNK_DEPTH_DEFAULT + 1) != ITEM.EMPTY)
		{
			tile_place(px + o, py, CHUNK_DEPTH_DEFAULT + 1, new Tile(ITEM.BROWN_MUSHROOM));
					
			continue;
		}
	}
}
