function grass_condition(_x, _y, _z, _v, _tile, _r = 0xfffff00ff, _spread = true)
{
	var _t = tile_get(_x, _y, _z, "all");
	var _index = _t.flip_rotation_index;
	
	if (((_index >> 8) & 0xff) != _v)
	{
		tile_set(_x, _y, _z, "flip_rotation_index", (_v << 8) | (_index & _r));
		
		exit;
	}
	
	if (!_spread) || (!chance(0.01)) exit;
	
	_x += irandom_range(-3, 3);
	_y += irandom_range(-3, 3);
	
	if (tile_get(_x, _y, _z) == _tile) && (tile_get(_x, _y - 1, _z) == ITEM.EMPTY)
	{
		tile_place(_x, _y, _z, new Tile(_t.item_id));
	}
}

function item_update_grass(_x, _y, _z, _tile = ITEM.DIRT, _spread = true)
{
	
	
	if (tile_get(_x, _y - 1, _z) != ITEM.EMPTY)
	{
		tile_place(_x, _y, _z, new Tile(_tile));
		tile_update(_x, _y, _z);
			
		exit;
	}
	
	var _v = ((tile_get(_x + 1, _y, _z) == ITEM.EMPTY) << 2) | ((tile_get(_x, _y + 1, _z) == ITEM.EMPTY) << 1) | (tile_get(_x - 1, _y, _z) == ITEM.EMPTY);
	
	if (_v == 0b_111)
	{
		grass_condition(_x, _y, _z, 0, _tile,, _spread);
	}
	else if (_v == 0b_110)
	{
		grass_condition(_x, _y, _z, 1, _tile, 0x1ffff00ff, _spread);
	}
	else if (_v == 0b_010)
	{
		grass_condition(_x, _y, _z, 2, _tile,, _spread);
	}
	else if (_v == 0b_011)
	{
		grass_condition(_x, _y, _z, 3, _tile, 0x1ffff00ff, _spread);
	}
	else if (_v == 0b_101)
	{
		grass_condition(_x, _y, _z, 4, _tile,, _spread);
	}
	else if (_v == 0b_001)
	{
		grass_condition(_x, _y, _z, 5, _tile, 0x1ffff00ff, _spread);
	}
	else if (_v == 0b_000)
	{
		grass_condition(_x, _y, _z, 6, _tile,, _spread);
	}
	else if (_v == 0b_100)
	{
		grass_condition(_x, _y, _z, 7, _tile, 0x1ffff00ff, _spread);
	}
	else
	{
		tile_place(_x, _y, _z, new Tile(_tile));
	}
}