function __ph_structure_fossil_default(px, py, seed)
{
	
	
	// worldgen_set_seed(px, py, seed);
	
	var ore = (py > EMUSTONE_YSTART ? ITEM.DIAMOND_INLAID_BLOCK_OF_BONE : ITEM.COAL_INLAID_BLOCK_OF_BONE);
	var _y;
	
	for (var i = 0; i < 3; ++i)
	{
		_y = py - i;
		
		for (var j = 0; j < 3; ++j)
		{
			var _x = px + (j * 3);
			
			if (irandom(29) == 0) continue;
			
			tile_place(_x, py - i, CHUNK_DEPTH_DEFAULT, new Tile(irandom(10) > 8 ? ore : ITEM.BLOCK_OF_BONE));
		}
	}
	
	for (var l = 0; l < 5; ++l)
	{
		if (irandom(29) == 0) continue;
		
		tile_place(px + (l + 1), _y, CHUNK_DEPTH_DEFAULT, new Tile(irandom(10) > 8 ? ore : ITEM.BLOCK_OF_BONE)
			.set_rotation(90));
	}
}