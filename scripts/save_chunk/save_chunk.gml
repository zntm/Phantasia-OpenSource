function save_chunk(_inst)
{
	var _item_data = global.item_data;
	
	var _f = current_time;
	
	// show_debug_message($"({floor(_inst.x / CHUNK_SIZE_WIDTH)}, {floor(_inst.y / CHUNK_SIZE_HEIGHT)}) - Saving Chunk");
	
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_bool, _inst.is_generated);
	
	var i = 0;
	
	var _slot;
	
	var l;
	var m;
	var q;
	var w;
	
	var _chunk = _inst.chunk;
	var _tile;
	var _v;
	
	repeat (CHUNK_SIZE_X * CHUNK_SIZE_Y * CHUNK_SIZE_Z)
	{
		_tile = _chunk[i++];
		
		if (_tile == ITEM.EMPTY)
		{
			buffer_write(_buffer, buffer_u64, 0xffff);
			
			continue;
		}
		
		buffer_write(_buffer, buffer_u64, (_tile.state_id << 32) | (_tile.boolean << 24) | (_tile.offset << 16) | _tile.item_id);
		buffer_write(_buffer, buffer_u64, _tile.flip_rotation_index);
		
		_v = _tile[$ "inventory"];
		
		if (_v == undefined) continue;
		
		l = 0;
		m = array_length(_v);
			
		buffer_write(_buffer, buffer_u8, m);
			
		repeat (m)
		{
			_slot = _v[l++];
				
			if (_slot == INVENTORY_EMPTY)
			{
				buffer_write(_buffer, buffer_u64, 0xffff);
				
				continue;
			}
				
			q = _slot.index;
			w = _slot.index_offset;
					
			buffer_write(_buffer, buffer_u64,
				((_slot[$ "durability"] ?? 0) << 48) |
				((q < 0 ? (0x80 | abs(q)) : q) << 40) |
				((w < 0 ? (0x80 | abs(w)) : w) << 32) |
				(_slot.amount << 16) |
				_slot.item_id
			);
				
			buffer_write(_buffer, buffer_u16, _slot[$ "acclimation"] ?? 0xffff);
		}
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.directory}/{global.world_data[global.world.environment.value & 0xf].name}/{_inst.chunk_xstart} {_inst.chunk_ystart}.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	// show_debug_message($"({floor(_inst.x / CHUNK_SIZE_WIDTH)}, {floor(_inst.y / CHUNK_SIZE_HEIGHT)}) - Saved Chunk ({current_time - _f}ms)");
}