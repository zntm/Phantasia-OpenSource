function __ph_structure_large_red_mushroom(px, py, seed)
{
	
	
	// worldgen_set_seed(px, py, seed);
	
	var mushroom = ITEM.RED_MUSHROOM_BLOCK;
	var stem = ITEM.MUSHROOM_STEM_BLOCK;
	
	var depth_mushrooom = CHUNK_DEPTH_DEFAULT;
	var depth_stem = CHUNK_DEPTH_DEFAULT + choose(-1, 1);
	
	for (var i = -4; i < irandom_range(5, 10); ++i)
	{
		tile_place(px, py, depth_stem, new Tile(stem));
		
		--py;
	}

	for (var j = 0; j < 4; ++j)
	{
		for (var k = -2; k < 3; ++k)
		{
			if (j == 3) && (k == -2 || k == 2)
			{
				if (irandom(2) > 0)
				{
					tile_place(px + k, py, CHUNK_DEPTH_DEFAULT + choose(-1, 1), new Tile(ITEM.RED_MUSHROOM));
				}
				
				continue;
			}
			
			tile_place(px + k, py, depth_mushrooom, new Tile(mushroom));
			
			var tile = tile_get(px + k, py + 1, depth_mushrooom);
			
			if (irandom(2) > 0) && (tile_get(px + k, py - 1, depth_mushrooom) == ITEM.EMPTY) && (tile == mushroom)
			{
				tile_place(px + k, py - 1, CHUNK_DEPTH_DEFAULT + choose(-1, 1), new Tile(ITEM.RED_MUSHROOM));
			}
		}
		
		--py;
	}
	
	for (var o = -4; o < 9; ++o)
	{
		if (o == 0) continue;
		
		py = worldgen_get_ysurface(px + o, seed);
		
		if (tile_get(px + o, py, CHUNK_DEPTH_DEFAULT - 1) != ITEM.EMPTY)
		{
			tile_place(px + o, py, CHUNK_DEPTH_DEFAULT - 1, new Tile(ITEM.RED_MUSHROOM));
					
			continue;
		}
				
		if (tile_get(px + o, py, CHUNK_DEPTH_DEFAULT + 1) != ITEM.EMPTY)
		{
			tile_place(px + o, py, CHUNK_DEPTH_DEFAULT + 1, new Tile(ITEM.RED_MUSHROOM));
					
			continue;
		}
	}
}
