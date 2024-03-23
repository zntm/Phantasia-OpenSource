function __ph_structure_tree_spruce(px, py, seed, tree_height, log = ITEM.PINE_WOOD, leaves = ITEM.PINE_LEAVES)
{
	// worldgen_set_seed(px, py, seed);
	
	var depth_wood = CHUNK_DEPTH_TREE;
	var depth_leaves = depth_wood + 1;
	
	#region Log Generation
	
	var _y;
	
	for (var i = 0; i < tree_height; ++i)
	{
		_y = py - i;
		
		if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(px, _y, depth_wood, new Tile(log)
				.set_index(1));
		}
	}
	
	if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		tile_place(px, _y, depth_wood, new Tile(log)
			.set_scale()
			.set_index(2));
	}
	
	if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		tile_place(px, _y, depth_leaves, new Tile(leaves)
			.set_scale()
			.set_index(2));
	}
	
	#endregion
	
	#region Leaves Generation
	
	var offset = tree_height - irandom_range(1, 3);
	var n = 2;
	var o = irandom_range(3, 5);
	
	for (var j = 0; j < offset; ++j)
	{
		if (j % o == 0) continue;
		
		var _ = n div 2;
		
		for (var l = -_; l <= _; ++l)
		{
			var _x = px + l;
			
			if (tile_get(_x, _y + j, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
			{
				tile_place(_x, _y + j, depth_leaves, new Tile(leaves));
			}
		}
		
		n += 0.5;
	}
	
	#endregion
}