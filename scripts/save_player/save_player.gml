function save_player(_directory_name, _name, _hp, _hp_max, _hotbar, _parts, _in_world = true)
{
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u64, (_hotbar << 32) | (_hp << 16) | _hp_max);
	buffer_write(_buffer, buffer_string, _name);
	
	var _parts_headwear    = _parts.headwear;
	var _parts_hair        = _parts.hair;
	var _parts_head_detail = _parts.head_detail;
	var _parts_eyes        = _parts.eyes;
	
	buffer_write(_buffer, buffer_u64,
		(_parts.base_body.colour << 48) |
		(_parts_headwear    == -1 ? 0 : ((_parts_headwear.index << 42)    | (_parts_headwear.colour    << 36))) |
		(_parts_hair        == -1 ? 0 : ((_parts_hair.index << 30)        | (_parts_hair.colour        << 24))) |
		(_parts_head_detail == -1 ? 0 : ((_parts_head_detail.index << 18) | (_parts_head_detail.colour << 12))) |
		(_parts_eyes        == -1 ? 0 : ((_parts_eyes.index << 6)         | _parts_eyes.colour))
	);
	
	var _parts_pants       = _parts.pants;
	var _parts_shirt       = _parts.shirt;
	var _parts_undershirt  = _parts.undershirt;
	var _parts_body_detail = _parts.body_detail;
	var _parts_footwear    = _parts.footwear;
	
	buffer_write(_buffer, buffer_u64,
		(_parts_pants       == -1 ? 0 : ((_parts_pants.index << 54)       | (_parts_pants.colour       << 48))) |
		(_parts_shirt       == -1 ? 0 : ((_parts_shirt.index << 42)       | (_parts_shirt.colour       << 36))) |
		(_parts_undershirt  == -1 ? 0 : ((_parts_undershirt.index << 30)  | (_parts_undershirt.colour  << 24))) |
		(_parts_body_detail == -1 ? 0 : ((_parts_body_detail.index << 18) | (_parts_body_detail.colour << 12))) |
		(_parts_footwear    == -1 ? 0 : ((_parts_footwear.index << 6)     | _parts_footwear.colour))
	);
	
	buffer_write(_buffer, buffer_f64, date_current_datetime());
	
	buffer_write(_buffer, buffer_u64, (_in_world ? ((obj_Player.hp << 8) | obj_Player.hp_max) : ((100 << 8) | 100)));
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{DIRECTORY_DATA_PLAYER}/{_directory_name}/Info.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	if (!_in_world) exit;
	
	#region Save Position
	
	_buffer = buffer_create(0xff, buffer_fixed, 1);
	
	buffer_write(_buffer, buffer_f64, obj_Player.x);
	buffer_write(_buffer, buffer_f64, obj_Player.y);
	
	_buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{DIRECTORY_DATA_WORLD}/{global.world.directory_name}/{global.world_data[global.world.environment.value & 0xf].name}/Spawnpoint/{_directory_name}.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	#endregion
	
	var _inventory = global.inventory;
	var _n;
	var _r;
	var _l;
	var _names = struct_get_names(_inventory);
	var _length = array_length(_names);
	
	var _item;
	var _index;
	var _index_offset;
	
	var j;
	var _v;
	
	var i = 0;
	
	repeat (_length)
	{
		_n = _names[i++];
		
		if (_n == "container") || (_n == "craftable") continue;
		
		_v = _inventory[$ _n];
		
		_l = array_length(_v);
		
		_buffer = buffer_create(16 * _l, buffer_grow, 1);
		
		j = 0;
		
		repeat (_l)
		{
			_item = _v[j++];
			
			if (_item == INVENTORY_EMPTY)
			{
				buffer_write(_buffer, buffer_u64, 0xffff);
				
				continue;
			}
			
			_index = _item.index;
			_index_offset = _item.index_offset;
			
			buffer_write(_buffer, buffer_u64,
				((_item[$ "durability"] ?? 0) << 48) |
				((_index < 0 ? (0x80 | abs(_index)) : _index) << 40) |
				((_index_offset < 0 ? (0x80 | abs(_index_offset)) : _index_offset) << 32) |
				(_item.amount << 16) |
				_item.item_id
			);
			
			_r = _item[$ "acclimation"];
			
			if (_r != undefined)
			{
				buffer_write(_buffer, buffer_u16, _r);
			}
		}
		
		_buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
		
		buffer_save(_buffer2, $"{DIRECTORY_DATA_PLAYER}/{_directory_name}/Inventory/{_n}.dat");
	
		buffer_delete(_buffer);
		buffer_delete(_buffer2);
	}
}