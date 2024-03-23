function structure_export(_file_name)
{
	var _inst = global.menu_inst;

	var _xstart = round((_inst.bbox_left + 8) / TILE_SIZE);
	var _ystart = round((_inst.bbox_top  + 8) / TILE_SIZE);

	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	#region Width
	
	var _width = inst_7C371565.text;
	
	try
	{
		_width = clamp((string_length(_width) > 0 ? real(_width) : 1), -127, 127);
	}
	catch (_error)
	{
		_width = 1;
	}
	
	#endregion
	
	#region Height
	
	var _height = inst_66C3DE5A.text;
	
	try
	{
		_height = clamp((string_length(_height) > 0 ? real(_height) : 1), -127, 127);
	}
	catch (_error)
	{
		_height = 1;
	}
	
	#endregion
	
	#region X Offset
	
	var _xoffset = inst_54641B01.text;
	
	try
	{
		_xoffset = clamp((string_length(_xoffset) > 0 ? real(_xoffset) : 0), -127, 127);
	}
	catch (_error)
	{
		_xoffset = 0;
	}
	
	#endregion
	
	#region Y Offset
	
	var _yoffset = inst_38989BF.text;
	
	try
	{
		_yoffset = clamp((string_length(_yoffset) > 0 ? real(_yoffset) : 0), -127, 127);
	}
	catch (_error)
	{
		_yoffset = 0;
	}
	
	#endregion
	
	var _treat_as_void = (inst_67D3D0DB.value ? ITEM.STRUCTURE_VOID : 0xffff);
	
	buffer_write(_buffer, buffer_u32, ((_xoffset < 0) << 31) | (abs(_xoffset) << 24) | ((_yoffset < 0) << 23) | (abs(_yoffset) << 16) | (_width << 8) | _height);
	
	var _m = global.menu_tile;
	var _mx = _m.x;
	var _my = _m.y;
	var _mz = _m.z;
	
	var _tile;
	var _item_id;
	var _v;
	
	var i = 0;
	var j;
	var l;
	var o;
	var q;
	var w;
	var m;
	var g;
	
	var _ax;
	var _ay;
	
	repeat (_width)
	{
		_ax = _xstart + i;
		
		j = 0;
		
		repeat (_height)
		{
			_ay = _ystart + j;
			
			l = 0;
			
			repeat (CHUNK_SIZE_Z)
			{
				if (_ax == _mx) && (_ay == _my) && (l == _mz)
				{
					buffer_write(_buffer, buffer_u64, _treat_as_void);
					
					++l;
					
					continue;
				}
				
				_tile = tile_get(_ax, _ay, l++, "all");
				
				if (_tile == ITEM.EMPTY)
				{
					buffer_write(_buffer, buffer_u64, _treat_as_void);
					
					continue;
				}
				
				_item_id = _tile.item_id;
		
				if (_item_id == ITEM.STRUCTURE_VOID)
				{
					buffer_write(_buffer, buffer_u64, ITEM.STRUCTURE_VOID);
					
					continue;
				}
		
				buffer_write(_buffer, buffer_u64, (_tile.state_id << 32) | (_tile.boolean << 24) | (_tile.offset << 16) | _item_id);
				buffer_write(_buffer, buffer_u64, _tile.flip_rotation_index);
		
				_v = _tile[$ "inventory"];
		
				if (_v != undefined)
				{
					o = 0;
					m = array_length(_v);
			
					buffer_write(_buffer, buffer_u8, m);
			
					repeat (m)
					{
						g = _v[o++];
				
						if (g == INVENTORY_EMPTY)
						{
							buffer_write(_buffer, buffer_u64, 0xffff);
					
							continue;
						}
				
						q = g.index;
						w = g.index_offset;
					
						buffer_write(_buffer, buffer_u64,
							((g[$ "durability"] ?? 0) << 48) |
							((q < 0 ? (0x80 | abs(q)) : q) << 40) |
							((w < 0 ? (0x80 | abs(w)) : w) << 32) |
							(g.amount << 16) |
							g.item_id
						);
				
						buffer_write(_buffer, buffer_u16, g[$ "acclimation"] ?? 0xffff);
					}
				}
			}
			
			++j;
		}
		
		++i;
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{DIRECTORY_DATA_EXPORTS_STRUCTURES}/{_file_name}.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}