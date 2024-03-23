function __ph_structure_fossil_arch(px, py, seed)
{
	
	
	// worldgen_set_seed(px, py, seed);
	
	var ore = (py > EMUSTONE_YSTART ? ITEM.DIAMOND_INLAID_BLOCK_OF_BONE : ITEM.COAL_INLAID_BLOCK_OF_BONE);
	
	var i = 0;
	
	for (; i < irandom_range(3, 6); ++i)
	{
		tile_place(px, py - i, CHUNK_DEPTH_DEFAULT, new Tile(irandom(10) > 8 ? ore : ITEM.BLOCK_OF_BONE));
	}
	
	var n = choose(-1, 1);
	
	for (var j = n; i < irandom_range(2, 4) * n; i += n)
	{
		tile_place(px + j, py - i, CHUNK_DEPTH_DEFAULT, new Tile(irandom(10) > 8 ? ore : ITEM.BLOCK_OF_BONE)
			.set_rotation(90));
	}
}