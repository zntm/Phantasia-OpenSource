function item_update_liquid_combine(_x, _y, _z, _combine, _tile, _frame_amount)
{
	if ((tile_get(_x, _y, _z, "state_id") >> 16) != 7)
	{
		if (tile_get(_x, _y - 1, _z) == _combine)
		{
			tile_place(_x, _y - 1, _z, ITEM.EMPTY);
			tile_place(_x, _y - 1, CHUNK_DEPTH_DEFAULT, new Tile(_tile));
		}
		else if (tile_get(_x + 1, _y, _z) == _combine)
		{
			tile_place(_x + 1, _y, _z, ITEM.EMPTY);
			tile_place(_x + 1, _y, CHUNK_DEPTH_DEFAULT, new Tile(_tile));
		}
		else if (tile_get(_x, _y + 1, _z) == _combine)
		{
			tile_place(_x, _y + 1, _z, ITEM.EMPTY);
			tile_place(_x, _y + 1, CHUNK_DEPTH_DEFAULT, new Tile(_tile));
		}
		else if (tile_get(_x - 1, _y, _z) == _combine)
		{
			tile_place(_x - 1, _y, _z, ITEM.EMPTY);
			tile_place(_x - 1, _y, CHUNK_DEPTH_DEFAULT, new Tile(_tile));
		}
		
		exit;
	}
	
	var _triggered = false;
			
	if (tile_get(_x, _y - 1, _z) == _combine)
	{
		tile_place(_x, _y - 1, _z, ITEM.EMPTY);
				
		_triggered = true;
	}
		
	if (tile_get(_x + 1, _y, _z) == _combine)
	{
		tile_place(_x + 1, _y, _z, ITEM.EMPTY);
				
		_triggered = true;
	}
		
	if (tile_get(_x, _y + 1, _z) == _combine)
	{
		tile_place(_x, _y + 1, _z, ITEM.EMPTY);
				
		_triggered = true;
	}
		
	if (tile_get(_x - 1, _y, _z) == _combine)
	{
		tile_place(_x - 1, _y, _z, ITEM.EMPTY);
				
		_triggered = true;
	}
			
	if (_triggered)
	{
		tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(_tile));
		tile_place(_x, _y, _z, ITEM.EMPTY);
	}
}