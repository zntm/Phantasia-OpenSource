enum STRUCTURE_TYPE {
	SURFACE,
	UNDERGROUND
}

function StructureData(_chance, _type, _xoffset, _yoffset, _width, _height) constructor
{
	self.chance = _chance;
	type = _type;
	
	xoffset = _xoffset;
	yoffset = _yoffset;
	
	width  = _width;
	height = _height;
	
	data = [];
}

global.structure_data = {};

var _handle = call_later(1, time_source_units_frames, function()
{
	var _item_data = global.item_data;
	var _data;

	var _buffer;
	var _buffer2;

	var _info;

	var _t;
	var _type;
	var _name;

	var _xoffset;
	var _yoffset;

	var _width;
	var _height;

	var _rectangle;

	var _index_xy;
	var _index_xyz;

	var _tile;
	var _item_id;
	var _flip_rotation_index;

	var i;
	var j;
	var l;
	var m;
	
	var t;
	var a;
	var g;
	var q;
	var w;
	var e;
	var f;

	var _file_name = file_find_first($"Resources\\Structures\\*", fa_directory);

	while (_file_name != "")
	{
		_buffer = buffer_load($"Resources\\Structures\\{_file_name}");
		_buffer2 = buffer_decompress(_buffer);
	
		_info = string_split(_file_name, " ");
	
		_t = _info[1];
		_name = string_replace(_info[2], ".dat", "");
	
		if (_t == "s")
		{
			_type = STRUCTURE_TYPE.SURFACE;
		}
		else if (_t == "u")
		{
			_type = STRUCTURE_TYPE.UNDERGROUND;
		}
		else
		{
			throw $"{_name} is not a valid structure type";
		}
	
		t = buffer_read(_buffer2, buffer_u32);
	
		_xoffset = ((t & 0x80000000) ? -(t >> 24) : (t >> 24));
		_yoffset = ((t & 0x800000) ? -(t >> 16) : (t >> 16));
	
		_width  = (t >> 8) & 0xff;
		_height = t & 0xff;
		
		_rectangle = _width * _height;
	
		m = 4;
	
		global.structure_data[$ _name] = new StructureData(real(_info[0]), _type, _xoffset, _yoffset, _width, _height);
	
		i = 0;
	
		repeat (_width)
		{
			j = 0;
		
			repeat (_height)
			{
				_index_xy = i + (j * _width);
			
				l = 0;
			
				repeat (CHUNK_SIZE_Z)
				{
					_index_xyz = _index_xy + (l++ * _rectangle);
				
					_tile = buffer_read(_buffer2, buffer_u64);
				
					if (_tile == 0xffff)
					{
						global.structure_data[$ _name].data[@ _index_xyz] = ITEM.EMPTY;
			
						continue;
					}
				
					if (_tile == ITEM.STRUCTURE_VOID)
					{
						global.structure_data[$ _name].data[@ _index_xyz] = ITEM.STRUCTURE_VOID;

						continue;
					}
				
					_item_id = _tile & 0xffff;
				
					global.structure_data[$ _name].data[@ _index_xyz] = {
						item_id: _item_id,
						offset: (_tile >> 16) & 0xff,
						boolean: (_tile >> 24) & 0xff,
						state_id: (_tile >> 32) & 0xffffff,
						flip_rotation_index: buffer_read(_buffer2, buffer_u64)
					};
		
					if (_item_data[_item_id].type & ITEM_TYPE.CONTAINER)
					{
						global.structure_data[$ _name].data[@ _index_xyz].inventory = [];
						
						a = buffer_read(_buffer2, buffer_u8);
			
						g = 0;
			
						repeat (a)
						{
							f = buffer_read(_buffer2, buffer_u64);
				
							if (f == 0xffff)
							{
								global.structure_data[$ _name].data[@ _index_xyz].inventory[@ g++] = INVENTORY_EMPTY;
					
								continue;
							}
				
							q = (f >> 40) & 0xff;
							w = (f >> 32) & 0xff;
				
							global.structure_data[$ _name].data[@ _index_xyz].inventory[@ g] = {
								item_id: f & 0xffff,
								amount: (f >> 16) & 0xffff,
								index: (q == 0xff ? -1 : q),
								index_offset: (w == 0xff ? -1 : w),
							};
				
							e = f >> 48;
				
							if (e > 0)
							{
								global.structure_data[$ _name].data[@ _index_xyz].inventory[@ g].durability = e;
							}
				
							e = buffer_read(_buffer2, buffer_u16);
				
							if (e != 0xffff)
							{
								global.structure_data[$ _name].data[@ _index_xyz].inventory[@ g].acclimation = e;
							}
				
							++g;
						}
					}
				}
			
				++j;
			}
		
			++i;
		}
		
		_file_name = file_find_next();
	}
});