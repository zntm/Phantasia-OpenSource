function item_update_liquid_flow(_x, _y, _z, _liquid, _frame_amount)
{
	var _item_data = global.item_data;
	
	static _flow = function(_x, _y, _z, _xoffset, _yoffset, _liquid, _frame_amount, _bypass_check_state = false)
	{
		var _tile = tile_get(_x, _y, _z, "all");
		
		if (_tile == ITEM.EMPTY) exit;
		
		var _x2 = _x + _xoffset;
		var _y2 = _y + _yoffset;
		
		var _tile2 = tile_get(_x2, _y2, _z, "all");
		
		var _state_id = _tile.state_id;
		var _state = _state_id >> 16;
		
		if (_tile2 == ITEM.EMPTY)
		{
			var _diff = (8 - _state) / 2;
			
			_state = abs(ceil(_diff) - 8);
			var _state2 = abs(floor(_diff) - 8);
			
			tile_set(_x, _y, _z, "state_id", (_state << 16) | (_state_id & 0xffff));
			tile_set(_x, _y, _z, "flip_rotation_index", (_tile.flip_rotation_index & 0x3ffffff00) | (_state * _frame_amount));
			tile_set(_x, _y, _z, "boolean", (1 << 1) | _tile.boolean);
				
			tile_place(_x2, _y2, _z, new Tile(_liquid)
				.set_state(_state2)
				.set_index_offset(_state2 * _frame_amount)
				.set_updated());
		}
		else
		{
			var _state_id2 = _tile2.state_id;
			var _state2 = _state_id2 >> 16;
			
			if (_state2 > 0) && (_state <= _state2 || _bypass_check_state)
			{
				++_state;
				
				tile_set(_x, _y, _z, "state_id", (_state << 16) | (_state_id & 0xffff));
				tile_set(_x, _y, _z, "flip_rotation_index", (_tile.flip_rotation_index & 0x3ffffff00) | (_state * _frame_amount));
				tile_set(_x, _y, _z, "boolean", (1 << 1) | _tile.boolean);
				
				--_state2;
				
				tile_set(_x2, _y2, _z, "state_id", (_state2 << 16) | (_state_id2 & 0xffff));
				tile_set(_x2, _y2, _z, "flip_rotation_index", (_tile2.flip_rotation_index & 0x3ffffff00) | (_state2 * _frame_amount));
			}
			
			if (_state2 >= 8)
			{
				tile_place(_x2, _y2, _z, ITEM.EMPTY);
			}
		}
		
		if (_state >= 8)
		{
			tile_place(_x, _y, _z, ITEM.EMPTY);
		}
	}
	
	#region Bottom
	
	var _bottom = tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT);
		
	if (_bottom == ITEM.EMPTY) || ((_item_data[_bottom].type & ITEM_TYPE.SOLID) == 0)
	{
		_flow(_x, _y, _z, 0, 1, _liquid, _frame_amount, true);
	}
	else
	{
		var _t = tile_get(_x, _y + 1, _z, "all");
		
		if (_t != ITEM.EMPTY) && (_t.item_id == _liquid)
		{
			_flow(_x, _y, _z, 0, 1, _liquid, _frame_amount, true);
		}
	}
	
	#endregion
	
	#region Left
	
	var _left = tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT);
		
	if (_left == ITEM.EMPTY) || ((_item_data[_left].type & ITEM_TYPE.SOLID) == 0)
	{
		_flow(_x, _y, _z, -1, 0, _liquid, _frame_amount);
	}
	else
	{
		var _t = tile_get(_x - 1, _y, _z, "all");
		
		if (_t != ITEM.EMPTY) && (_t.item_id == _liquid)
		{
			_flow(_x, _y, _z, -1, 0, _liquid, _frame_amount);
		}
	}
	
	#endregion
	
	#region Right
	
	var _right = tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT);
	
	if (_right == ITEM.EMPTY) || ((_item_data[_right].type & ITEM_TYPE.SOLID) == 0)
	{
		_flow(_x, _y, _z, 1, 0, _liquid, _frame_amount);
	}
	else
	{
		var _t = tile_get(_x + 1, _y, _z, "all");
		
		if (_t != ITEM.EMPTY) && (_t.item_id == _liquid)
		{
			_flow(_x, _y, _z, 1, 0, _liquid, _frame_amount);
		}
	}
	
	#endregion
	
	var _tile = tile_get(_x, _y, _z, "all");
	
	if (_tile == ITEM.EMPTY) exit;
	
	tile_set(_x, _y, _z, "flip_rotation_index", (_tile.flip_rotation_index & 0xfffffff00) | ((tile_get(_x, _y - 1, _z) == _liquid ? 8 : (_tile.state_id >> 16)) * _frame_amount));
}