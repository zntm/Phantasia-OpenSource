function structure_tree_oak(px, py, seed, tree_height)
{
	
	
	var depth_wood = CHUNK_DEPTH_TREE;
	var depth_leaves = depth_wood + 1;
	
	#region Log Generation
	
	var _val;
	
	var _y;
	var index;
	var has_generated_stump = false;
	
	var i = 0;
	
	repeat (tree_height + 1)
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
					_val = choose_weighted(
						1, 7,
						2, 2,
						3, 2,
						4, 1,
						5, 1,
					);
					
					if (index != _val)
					{
						index = _val;
						
						break;
					}
				}
			}
			
			tile_place(px, _y, depth_wood, new Tile(ITEM.OAK_WOOD)
				.set_index(index));
		}
		
		++i;
	}
	
	#endregion
	
	#region Leaves Generation
	
	i = -1;
	
	repeat (3)
	{
		var _x = px + i++;
		
		tile_place(_x, _y, depth_leaves, new Tile(ITEM.OAK_LEAVES));
			
		// Add gradient to bottom parts of the leaves
		if (tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y + 1, depth_leaves, new Tile(ITEM.OAK_LEAVES)
				.set_index_offset(16));
		}
	}
	
	i = -2;
	
	repeat (5)
	{
		var _x = px + i++;
		
		tile_place(_x, _y + 2, depth_leaves, new Tile(ITEM.OAK_LEAVES));
			
		// Add gradient to bottom parts of the leaves
		if (tile_get(_x, _y + 3, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y + 3, depth_leaves, new Tile(ITEM.OAK_LEAVES)
				.set_index_offset(16));
		}
	}
	
	#endregion
}
