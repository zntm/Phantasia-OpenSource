function structure_tree_default(px, py, seed, tree_height, log = ITEM.EMPTY, leaves = ITEM.EMPTY, check = false)
{
	
	
	var _item_data = global.item_data;
	
	static __create_stump = function(px, py, pz, log)
	{
		if (irandom(9) > 0)
		{
			var _y1 = py - 1;
			
			if (tile_get(px, _y1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
			{
				tile_place(px, _y1, pz, new Tile(log)
					.set_scale()
					.set_index(2));
			}
	
			var _y2 = py;
			
			repeat (8)
			{
				if (tile_get(px, _y2, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) exit;
			
				tile_place(px, _y2, pz, new Tile(log)
					.set_scale()
					.set_index(1));
				
				++_y2;
			}
		}
	}
	
	// Check if there are any solid blocks
	if (check)
	{
		var _tile;
		
		var i = 0;
		
		repeat (tree_height - 1)
		{
			_tile = tile_get(px, py - i, CHUNK_DEPTH_DEFAULT);
		
			if (_tile == log) || (_tile != ITEM.EMPTY && (_item_data[_tile].type & ITEM_TYPE.SOLID)) exit;
			
			++i;
		}
	}
	
	var depth_wood = CHUNK_DEPTH_TREE;
	var depth_leaves = depth_wood + 1;
	
	#region Stump Generation
	
	__create_stump(px - 1, py - choose(1, 2), depth_wood, log);
	__create_stump(px + 1, py - choose(1, 2), depth_wood, log);
	
	#endregion
	
	#region Log Generation
	
	var _y = py;
	
	repeat (tree_height)
	{
		if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(px, _y, depth_wood, new Tile(log)
				.set_index(1));
		}
		
		--_y;
	}
	
	if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
	{
		tile_place(px, _y, depth_wood, new Tile(log)
			.set_index(2));
	}
	
	#endregion
	
	#region Leaves Generation
	
	static __create_leaves = function(px, py, pz, _repeat, leaves)
	{
		var _y = py + 1;
		
		repeat (_repeat)
		{
			if (tile_get(px, py, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
			{
				tile_place(px, py, pz, new Tile(leaves)
					.set_scale());
			}
			
			// Add gradient to bottom parts of the leaves
			if (tile_get(px, _y, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
			{
				tile_place(px, _y, pz, new Tile(leaves)
					.set_scale()
					.set_index(2));
			}
			
			++px;
		}
	}
	
	__create_leaves(px - 1, _y,		depth_leaves, 3, leaves);
	__create_leaves(px - 2, _y + 2,	depth_leaves, 5, leaves);
	
	#endregion
}
