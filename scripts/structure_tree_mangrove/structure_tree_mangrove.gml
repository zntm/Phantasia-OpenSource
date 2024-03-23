function structure_tree_mangrove(px, py, seed, tree_height)
{
	
	
	// worldgen_set_seed(px, py, seed);
	
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
				index = 7;
				has_generated_stump = true;
			}
			else if (i == tree_height)
			{
				index = 6;
			}
			else
			{
				while (true)
				{
					var val = choose_weighted(
						1, 7,
						2, 2,
						3, 2,
						4, 1,
						5, 1,
					);
					
					if (index != val)
					{
						index = val;
						
						break;
					}
				}
			}
			
			tile_place(px, _y, depth_wood, new Tile(ITEM.MANGROVE_WOOD)
				.set_index(index));
		}
	}
	
	#endregion
	
	#region Leaves Generation
	
	static __create_leaves = function(px, py, pz, _xstart)
	{
		
		
		for (var i = -_xstart; i <= _xstart; ++i)
		{
			var _x = px + i;
		
			if (tile_get(_x, py, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
			{
				tile_place(_x, py, pz, new Tile(ITEM.MANGROVE_LEAVES));
			}
		}
	}
	
	__create_leaves(px, _y    , depth_leaves, 2);
	__create_leaves(px, _y + 1, depth_leaves, 4);
	__create_leaves(px, _y + 2, depth_leaves, 4);
	
	#region Drooping Leaves
	
	var drooping_ystart = _y + 3;
	var current_y = -1;
	
	for (var j = -3; j <= 3; ++j)
	{
		var _x = px + j;
		
		while (true)
		{
			var val = choose(0, 0, 1, 2, 3);
			
			if (current_y != val)
			{
				current_y = val;
				
				break;
			}
		}
		
		for (var l = 0; l < current_y; ++l)
		{
			if (tile_get(_x, drooping_ystart + l, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) break;
			
			tile_place(_x, drooping_ystart + l, depth_leaves, new Tile(ITEM.MANGROVE_LEAVES));
		}
	}
	
	#endregion
	
	#endregion

	var _xscale = irandom_range(3, 5);
	var _yscale = irandom_range(4, 5);
	
	// __ph_// structure_blob_inside(px, py, CHUNK_DEPTH_DEFAULT, seed, _xscale, _yscale, ITEM.MANGROVE_ROOTS, 1, ITEM.MANGROVE_ROOTS, 2, [ITEM.DIRT, ITEM.SWAMPY_GRASS_BLOCK, ITEM.MUD]);
}
