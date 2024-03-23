function __structure_tree_default(px, py, seed, tree_height, log = ITEM_EMPTY, leaves = ITEM_EMPTY)
{
	random_set_seed(seed + (py * py));
	
	// Lift up the tree a bit
	tree_height += 2;
	
	var depth_wood = choose(CHUNK_DEPTH.TREE_FRONT, CHUNK_DEPTH.TREE_BACK);
	var depth_leaves = depth_wood + 1;
	
	#region Stump Generation
	
	static __create_stump = function(px, py, pz, log)
	{
		if (irandom(9) > 0)
		{
			if (ph_get_tile(px, py - 1, CHUNK_DEPTH.DEFAULT) == ITEM_EMPTY)
			{
				ph_place_tile(px, py - 1, pz, log, 0, 0, 1, 1, 2);
			}
	
			for (var j = 0; j < 8; ++j)
			{
				if (ph_get_tile(px, py + j, CHUNK_DEPTH.DEFAULT) != ITEM_EMPTY) exit;
			
				ph_place_tile(px, py + j, pz, log, 0, 0, 1, 1, 1);
			}
		}
	}
	
	__create_stump(px - 1, py - choose(1, 2), depth_wood, log);
	__create_stump(px + 1, py - choose(1, 2), depth_wood, log);
	
	#endregion
	
	#region Log Generation
	
	for (var i = 0; i < tree_height; ++i)
	{
		var _y = py - i;
		
		if (ph_get_tile(px, _y, CHUNK_DEPTH.DEFAULT) == ITEM_EMPTY)
		{
			ph_place_tile(px, _y, depth_wood, log, 0, 0, 1, 1, 1);
		}
	}
	
	if (ph_get_tile(px, _y, CHUNK_DEPTH.DEFAULT) == ITEM_EMPTY)
	{
		ph_place_tile(px, _y, depth_wood, log, 0, 0, 1, 1, 2);
	}
	
	#endregion
	
	#region Leaves Generation
	
	static __create_leaves = function(px, py, pz, _xstart, leaves)
	{
		for (var i = -_xstart; i < _xstart + 1; ++i)
		{
			var _x = px + i;
		
			if (ph_get_tile(_x, py, CHUNK_DEPTH.DEFAULT) == ITEM_EMPTY)
			{
				ph_place_tile(_x, py, pz, leaves);
			}
			
			// Add gradient to bottom parts of the leaves
			if (ph_get_tile(_x, py + 1, CHUNK_DEPTH.DEFAULT) == ITEM_EMPTY)
			{
				ph_place_tile(_x, py + 1, pz, leaves, 0, 0, undefined, 1, 2);
			}
		}
	}
	
	__create_leaves(px, _y    , depth_leaves, 1, leaves);
	__create_leaves(px, _y + 2, depth_leaves, 2, leaves);
	
	#endregion
}
