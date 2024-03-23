function update_connected(px, py, pz, _item_id)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline");
	}
	
	static __init = false;
	static __val = [];
	
	if (!__init)
	{
		__init = true;
		
		__val[@ 0b_0000] = 1;
		__val[@ 0b_0111] = 2;
		__val[@ 0b_1011] = 3;
		__val[@ 0b_1101] = 4;
		__val[@ 0b_1110] = 5;
		__val[@ 0b_0011] = 6;
		__val[@ 0b_1001] = 7;
		__val[@ 0b_1100] = 8;
		__val[@ 0b_0110] = 9;
		__val[@ 0b_0010] = 10;
		__val[@ 0b_0001] = 11;
		__val[@ 0b_1000] = 12;
		__val[@ 0b_0100] = 13;
		__val[@ 0b_1010] = 14;
		__val[@ 0b_0101] = 15;
		__val[@ 0b_1111] = 16;
	}
	
	var _item_data = global.item_data;
	
	var _a = tile_get(px, py - 1, pz, "all");
		_a = (_a != ITEM.EMPTY) && ((_item_id == _a.item_id) || (_a.boolean & 1 && _item_data[_a.item_id].type & ITEM_TYPE.SOLID));
	
	var _b = tile_get(px + 1, py, pz, "all");
		_b = (_b != ITEM.EMPTY) && ((_item_id == _b.item_id) || (_b.boolean & 1 && _item_data[_b.item_id].type & ITEM_TYPE.SOLID));
	
	var _c = tile_get(px, py + 1, pz, "all");
		_c = (_c != ITEM.EMPTY) && ((_item_id == _c.item_id) || (_c.boolean & 1 && _item_data[_c.item_id].type & ITEM_TYPE.SOLID));
	
	var _d = tile_get(px - 1, py, pz, "all");
	
	return __val[(_a << 3) | (_b << 2) | (_c << 1) | ((_d != ITEM.EMPTY) && ((_item_id == _d.item_id) || (_d.boolean & 1 && _item_data[_d.item_id].type & ITEM_TYPE.SOLID)))];
}

function update_connected_to_self(px, py, pz, _item_id)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline");
	}
	
	static __init = false;
	static __val = [];
	
	if (!__init)
	{
		__init = true;
		
		__val[@ 0b_0000] = 1;
		__val[@ 0b_0111] = 2;
		__val[@ 0b_1011] = 3;
		__val[@ 0b_1101] = 4;
		__val[@ 0b_1110] = 5;
		__val[@ 0b_0011] = 6;
		__val[@ 0b_1001] = 7;
		__val[@ 0b_1100] = 8;
		__val[@ 0b_0110] = 9;
		__val[@ 0b_0010] = 10;
		__val[@ 0b_0001] = 11;
		__val[@ 0b_1000] = 12;
		__val[@ 0b_0100] = 13;
		__val[@ 0b_1010] = 14;
		__val[@ 0b_0101] = 15;
		__val[@ 0b_1111] = 16;
	}
	
	return __val[((tile_get(px, py - 1, pz) == _item_id) << 3) | ((tile_get(px + 1, py, pz) == _item_id) << 2) | ((tile_get(px, py + 1, pz) == _item_id) << 1) | (tile_get(px - 1, py, pz) == _item_id)];
}

function tile_update_connected(px, py, pz, _item_id)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline");
	}
	
	var _animation_type = global.item_data[_item_id].animation_type_index >> 16;
	
	if (_animation_type & ANIMATION_TYPE.CONNECTED)
	{
		return update_connected(px, py, pz, _item_id);
	}
	else if (_animation_type & ANIMATION_TYPE.CONNECTED_TO_SELF)
	{
		return update_connected_to_self(px, py, pz, _item_id);
	}
		
	return -1;
}