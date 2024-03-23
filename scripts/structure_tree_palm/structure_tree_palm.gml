function structure_tree_palm(px, py, seed)
{
	
	
	var _depth_wood = CHUNK_DEPTH_TREE;
	var _log_xscale = choose(-1, 1);
	
	var _height = irandom_range(8, 12);
	var _y;
	
	for (var i = 0; i <= _height; ++i)
	{
		_y = py - i;
		
		if (tile_get(px, _y, _depth_wood) == ITEM.EMPTY)
		{
			var _index = 1;
			
			if (i == _height)
			{
				_index = 2;
			}
			
			tile_place(px, _y, _depth_wood, new Tile(ITEM.PALM_WOOD)
				.set_xscale(_log_xscale)
				.set_index(_index)
				.set_xoffset(round(perlin_noise(px, _y, 4, 16, seed)) - 1));
		}
	}
	
	/*
	var tree_height = irandom_range(4, 6);
	var log_repeat  = irandom_range(2, 4);
	
	var xoffset = choose(-1, 1);
	var yoffset = irandom_range(1, 2);
	
	var tree_x = px;
	var tree_y = py;
	var tree_z = CHUNK_DEPTH_DEFAULT + choose(-1, 1);
	
	for (var i = 0; i < log_repeat; ++i)
	{
		for (var j = 0; j < max(tree_height, 1); ++j)
		{
			tile_place(tree_x, tree_y, tree_z, new Tile(ITEM.PALM_WOOD));
			
			--tree_y;
		}
		
		tile_place(tree_x, tree_y, tree_z, new Tile(ITEM.PALM_WOOD)
			.set_index(2));
		
		tree_x += xoffset;
		tree_height -= yoffset;
	}
	
	tile_place(tree_x, tree_y, tree_z, new Tile(ITEM.PALM_WOOD)
		.set_index(irandom(5) > 0 ? 1 : 3));
	
	tile_place(tree_x, tree_y - 1, tree_z, new Tile(ITEM.PALM_WOOD)
		.set_index(2));
	
	#region Leaves Generation
	
	var
	leaf_x = tree_x,
	leaf_y = tree_y - 1,
	leaf_z = tree_z + 1,
	
	leaf_repeat = irandom_range(3, 4);
	
	tile_place(leaf_x, leaf_y + 1, leaf_z, new Tile(ITEM.PALM_LEAVES));
	
	repeat (irandom_range(2, 3))
	{
		repeat (leaf_repeat)
		{
			++leaf_x;
			
			tile_place(leaf_x, leaf_y, leaf_z, new Tile(ITEM.PALM_LEAVES));
		}
		
		if (leaf_repeat > 1) && (irandom(9))
		{
			--leaf_repeat;
		}
		
		++leaf_y;
	}
	
	tile_place(leaf_x, leaf_y, leaf_z, new Tile(ITEM.PALM_LEAVES));
	
	leaf_x = tree_x;
	leaf_y = tree_y - 1;
	leaf_z = tree_z + 1;
	
	leaf_repeat = irandom_range(3, 4);
	
	repeat (irandom_range(2, 3))
	{
		repeat (leaf_repeat)
		{
			--leaf_x;
			
			tile_place(leaf_x, leaf_y, leaf_z, new Tile(ITEM.PALM_LEAVES));
		}
		
		if (leaf_repeat > 1) && (irandom(9))
		{
			--leaf_repeat;
		}
		
		++leaf_y;
	}
	
	tile_place(leaf_x, leaf_y, leaf_z, new Tile(ITEM.PALM_LEAVES));
	
	#endregion
	*/
}
