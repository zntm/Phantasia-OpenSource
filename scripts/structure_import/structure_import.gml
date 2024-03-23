function structure_import(_x, _y, _file_name)
{
	var _directory = $"{DIRECTORY_DATA_EXPORTS_STRUCTURES}/{_file_name}.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _item_data = global.item_data;
	
	var _buffer = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	var _v = buffer_read(_buffer2, buffer_u32);
	
	_x += ((_v & 0x80000000) ? -(_v >> 24) : (_v >> 24));
	_y += ((_v & 0x800000)   ? -((_v >> 16) & 0x7f) : ((_v >> 16) & 0x7f));
	
	var _width   = (_v >> 8) & 0xff;
	var _height  = _v & 0xff;
	var _rectangle = _width * _height;
	
	var _tile;
	var _item_id;
	var _t;
	var a;
	var g;
	var f;
	var q;
	var w;
	var e;
	
	var i = 0;
	var j;
	var l;
	
	repeat (_width)
	{
		j = 0;
		
		repeat (_height)
		{
			l = 0;
			
			repeat (CHUNK_SIZE_Z)
			{
				_tile = buffer_read(_buffer2, buffer_u64);
				
				if (_tile == 0xffff)
				{
					tile_place(_x + i, _y + j, l++, ITEM.EMPTY);
			
					continue;
				}
				
				if (_tile == ITEM.STRUCTURE_VOID)
				{
					tile_place(_x + i, _y + j, l++, new Tile(ITEM.STRUCTURE_VOID));

					continue;
				}
				
				_item_id = _tile & 0xffff;
				
				_t = {
					item_id: _item_id,
					offset: (_tile >> 16) & 0xff,
					boolean: (_tile >> 24) & 0xff,
					state_id: (_tile >> 32) & 0xffffff,
					flip_rotation_index: buffer_read(_buffer2, buffer_u64)
				};
		
				if (_item_data[_item_id].type & ITEM_TYPE.CONTAINER)
				{
					_t.inventory = [];
						
					a = buffer_read(_buffer2, buffer_u8);
			
					g = 0;
			
					repeat (a)
					{
						f = buffer_read(_buffer2, buffer_u64);
				
						if (f == 0xffff)
						{
							_t.inventory[@ g++] = INVENTORY_EMPTY;
					
							continue;
						}
				
						q = (f >> 40) & 0xff;
						w = (f >> 32) & 0xff;
				
						_t.inventory[@ g] = {
							item_id: f & 0xffff,
							amount: (f >> 16) & 0xffff,
							index: (q == 0xff ? -1 : q),
							index_offset: (w == 0xff ? -1 : w),
						};
				
						e = f >> 48;
				
						if (e > 0)
						{
							_t.inventory[@ g].durability = e;
						}
				
						e = buffer_read(_buffer2, buffer_u16);
				
						if (e != 0xffff)
						{
							_t.inventory[@ g].acclimation = e;
						}
				
						++g;
					}
				}
				
				tile_place(_x + i, _y + j, l++, _t);
			}
			
			++j;
		}
		
		++i;
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}