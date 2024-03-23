/// @func Tile(item)
/// @desc Creates a tile data for the tile_place function
/// @arg {Real} _item Item ID to create the tile _data for
/// @self Tile
function Tile(_item, _item_data = global.item_data) constructor
{
	// ffff_ffff_ffff_ffff
	// ffff item id
	// ff x offset, y offset
	// ffff index, index offset
	// ff state
	// ffff id
	
	item_id = _item;
	
	// updated, collision
	boolean = 0b_01;
	
	static set_updated = function(_updated = true)
	{
		boolean = (_updated << 1) | (boolean & 0b_01);
		
		return self;
	}
	
	static get_updated = function()
	{
		return boolean >> 1;
	}
	
	static set_collision = function(_collision = true)
	{
		boolean = (boolean & 0b_10) | _collision;
		
		return self;
	}
	
	static get_collision = function()
	{
		return boolean & 0b_1;
	}
	
	// first 4 bits are x offset, last 4 bits are y offset
	offset = 0;
	
	static set_offset = function(_xoffset = 0, _yoffset = 0)
	{
		offset = (_xoffset << 4) | _yoffset;
		
		return self;
	}
	
	static set_xoffset = function(_xoffset = 0)
	{
		offset = (offset & 0x0f) | ((_xoffset < 0) << 7) | (abs(_xoffset) << 4);
		
		return self;
	}
	
	static set_yoffset = function(_yoffset = 0)
	{
		offset = (offset & 0xf0) | ((_yoffset < 0) << 3) | abs(_yoffset);
		
		return self;
	}
	
	var _data = _item_data[_item];
	var _flip_on_random_index = _data.flip_on_random_index;
	
	// 0x3ffff - first 2 bits are checking if scales are negatives, next 8 bits for index, last 8 bits for index offset
	flip_rotation_index = 0;
	
	if (_flip_on_random_index >> 33) && (irandom(1))
	{
		flip_rotation_index = 1 << 33;
	}
	
	if ((_flip_on_random_index >> 32) & 1) && (irandom(1))
	{
		flip_rotation_index = flip_rotation_index | (1 << 32);
	}
	
	static set_scale = function(_xscale = false, _yscale = false)
	{
		flip_rotation_index = (_xscale << 33) | (_yscale << 32) | (flip_rotation_index & 0xffffffff);
		
		return self;
	}
	
	static set_xscale = function(_xscale = false)
	{
		flip_rotation_index = (_xscale << 33) | (flip_rotation_index & 0x1ffffffff);
		
		return self;
	}
	
	static get_xscale = function()
	{
		return ((flip_rotation_index >> 33) ? -1 : 1);
	}
	
	static set_yscale = function(_yscale = false)
	{
		flip_rotation_index = (_yscale << 32) | (flip_rotation_index & 0x2ffffffff);
		
		return self;
	}
	
	static get_yscale = function()
	{
		return (((flip_rotation_index >> 32) & 1) ? -1 : 1);
	}
	
	static set_rotation = function(_rotation = 0)
	{
		flip_rotation_index = ((_rotation < 0) << 31) | (abs(_rotation) << 16) | (0xf0000ffff);
		
		return self;
	}
	
	flip_rotation_index = flip_rotation_index | (irandom_range((_flip_on_random_index >> 8) & 0xff, _flip_on_random_index & 0xff) << 8);
	
	static set_index = function(_index = 1)
	{
		flip_rotation_index = (_index << 8) | (flip_rotation_index & 0xfffff00ff);
		
		return self;
	}
	
	static get_index = function(_index = 1)
	{
		return (flip_rotation_index >> 8) & 0xff;
	}
	
	static set_index_offset = function(_index = 1)
	{
		flip_rotation_index = (flip_rotation_index & 0xfffffff00) | _index;
		
		return self;
	}
	
	static get_index_offset = function(_index = 1)
	{
		return flip_rotation_index & 0xff;
	}
	
	// 0xff_ffff state, id
	// 0b0000_0000__0000_0000_0000_0000
	state_id = 0;
	
	static set_state = function(_state)
	{
		state_id = (_state << 16) | (state_id & 0xffff);
		
		return self;
	}
	
	static get_state = function()
	{
		return state_id >> 16;
	}
	
	static set_id = function(_id)
	{
		state_id = (state_id & 0xff0000) | _id;
		
		return self;
	}
	
	static get_id = function()
	{
		return state_id & 0xffff;
	}
	
	var _variable = _data.variable;
	
	if (_variable != -1)
	{
		var _name;
		var _names = struct_get_names(_variable);
		var _names_length = array_length(_names);
		
		var i = 0;
		
		repeat (_names_length)
		{
			_name = _names[i++];
			
			self[$ $"variable.{_name}"] = _variable[$ _name];
		}
	}
	
	var _type = _data.type;
	
	if (_type & ITEM_TYPE.PLANT)
	{
		skew = 0;
		skew_to = 0;
	}
	else if (_type & ITEM_TYPE.CONTAINER)
	{
		var j = 0;
		
		repeat (_data.container_size)
		{
			inventory[@ j++] = INVENTORY_EMPTY;
		}
		
		static set_loot = function(_selected_loot)
		{
			var _loot;
			var _item;
			var _index;
			var _slot_amount;
			var _probability;
			var _amount;
			
			var _size = global.item_data[item_id].container_size;
			var _size_1 = _size - 1;
			
			var _data = global.loot_data[$ _selected_loot];
			
			var _loots = _data.loots;
			var _loots_length = _data.loots_length;
			
			var i = 0;
			var j;
			
			repeat (_loots_length)
			{
				_loot = _loots[i++];
				_item = is_array_choose(_loot >> 40);
				
				_slot_amount = _loot & 0xffff;
				_probability = (_loot >> 16) & 0xff;
				
				_amount = irandom_range((_loot >> 32) & 0xff, (_loot >> 24) & 0xff);
				
				if (_slot_amount == 0xffff)
				{
					j = 0;
					
					repeat (_size)
					{
						if (inventory[j] == INVENTORY_EMPTY) && (irandom(99) < _probability)
						{
							inventory[@ j] = new Inventory(_item, is_array_irandom(_amount));
						}
						
						++j;
					}
					
					continue;
				}
				
				repeat (is_array_random(_slot_amount))
				{
					_index = irandom(_size_1);
					
					if (inventory[_index] == INVENTORY_EMPTY) && (irandom(99) < _probability)
					{
						inventory[@ _index] = new Inventory(_item, is_array_irandom(_amount));
					}
				}
			}
			
			return self;
		}
	}
}