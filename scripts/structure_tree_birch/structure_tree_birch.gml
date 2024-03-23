function structure_tree_birch(px, py, seed, tree_height, golden_leaves_chance = 0.2)
{
	
	
	var depth_wood = CHUNK_DEPTH_TREE;
	var depth_leaves = depth_wood + 1;
	
	#region Log Generation
	
	var _y;
	var index;
	var has_generated_stump = false;
	
	for (var i = 0; i <= tree_height; ++i)
	{
		_y = py - i;
		
		if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			if (!has_generated_stump)
			{
				index = 3;
				has_generated_stump = true;
			}
			else if (i == tree_height)
			{
				index = 2;
			}
			else
			{
				index = 1;
			}
			
			tile_place(px, _y, depth_wood, new Tile(ITEM.BIRCH_WOOD)
				.set_index(index));
		}
	}
	
	#endregion
	
	#region Leaves Generation
	
	var _leaves = (golden_leaves_chance ? ITEM.GOLDEN_BIRCH_LEAVES : ITEM.BIRCH_LEAVES);
	
	for (var i = -2; i <= 2; ++i)
	{
		var _x = px + i;
		
		// Add gradient to bottom parts of the leaves
		if (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y, depth_leaves, new Tile(_leaves)
				.set_index_offset(16));
		}
		
		// Add gradient to bottom parts of the leaves
		if (tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y + 1, depth_leaves, new Tile(_leaves)
				.set_index_offset(16));
		}
	}
	
	for (var i = -3; i <= 3; ++i)
	{
		var _x = px + i;
		
		if (tile_get(_x, _y + 2, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y + 2, depth_leaves, new Tile(_leaves));
		}
			
		// Add gradient to bottom parts of the leaves
		if (tile_get(_x, _y + 3, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y + 3, depth_leaves, new Tile(_leaves)
				.set_index_offset(16));
		}
	}
	
	#endregion
}
