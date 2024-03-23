function gui_inventory(_name, _value)
{
	
	
	var _x;
	var _x2;
	
	var _y;
	var _y2;
	
	var _item;
	var _data;
	var _instance;
	var _sprite;
	var _index;
	var _scale;
		
	var _length;
		
	if (!obj_Control.is_opened_inventory)
	{
		if (_name != "base") exit;
		
		_length = INVENTORY_SIZE.ROW;
	}
	else
	{
		_length = array_length(_value);
	}
		
	var _item_data = global.item_data;
	var _instances = global.inventory_instances[$ _name];
	
	var i;
	
	#region Draw Slots
		
	// Draw Outline
	i = 0;
	
	repeat (_length)
	{
		_instance = _instances[i];
			
		_x = _instance.xoffset;
		_y = _instance.yoffset;
			
		draw_sprite_ext(_instance.sprite, 1, _x, _y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, 1);
		
		++i;
	}
		
	// Draw Slot
	i = 0;
	
	repeat (_length)
	{
		_instance = _instances[i];
			
		_x = _instance.xoffset;
		_y = _instance.yoffset;
		
		_sprite = _instance.sprite;
		
		draw_sprite_ext(_sprite, 0, _x, _y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, 1);
		draw_sprite_ext(_sprite, _instance.background_index, _x, _y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, _instance.background_alpha);
		
		++i;
	}
	
	if (_name == "base")
	{
		draw_sprite_ext(gui_Slot_Inventory, 7, GUI_SAFE_ZONE_X + (INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE * global.inventory_selected_hotbar), GUI_SAFE_ZONE_Y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, 1);
	}
	
	#endregion
	
	var _inventory_selected_backpack = global.inventory_selected_backpack;
	
	var _d1;
	var _d2;
	var _v;
	var _s;
	
	#region Draw Items & Durability
	
	var _xoffset;
	var _yoffset;
	var _index_offset;
	
	i = 0;
	
	repeat (_length)
	{
		_item = _value[i];
			
		if (_item != INVENTORY_EMPTY) && (_item != ITEM.EMPTY)
		{
			_data = _item_data[_item.item_id];
			_instance = _instances[i];
			
			_xoffset = _instance.xoffset;
			_yoffset = _instance.yoffset;
			
			_x = (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH  / 2) + _xoffset;
			_y = (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT / 2) + _yoffset;
			
			_sprite = _data.sprite;
			_index = _item.index;
			_scale = _data.get_inventory_scale();
			
			if (_data.type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP | ITEM_TYPE.BOW | ITEM_TYPE.FISHING_POLE))
			{
				_d1 = _item.durability;
				_d2 = _data.get_durability();
				
				if (_d1 < _d2)
				{
					_v = real(_d1) / _d2;
					
					_x2 = _xoffset - INVENTORY_SLOT_SCALE;
					_y2 = _yoffset + (13 * INVENTORY_SLOT_SCALE);
						
					draw_sprite_ext(gui_Slot_Durability, 0, _x2, _y2, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, 1);
					
					if (_v > 0.67)
					{
						_s = _v * INVENTORY_SLOT_SCALE;
						_x2 -= _s / 2;
						
						draw_sprite_ext(gui_Slot_Durability, 2, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, 1);
						draw_sprite_ext(gui_Slot_Durability, 1, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, normalize(_v, 0.33, 0.67));
					}
					else if (_v > 0.33)
					{
						_s = _v * INVENTORY_SLOT_SCALE;
						_x2 -= _s / 2;
						
						draw_sprite_ext(gui_Slot_Durability, 3, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, 1);
						draw_sprite_ext(gui_Slot_Durability, 2, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, normalize(_v, 0, 0.33));
					}
					else
					{
						draw_sprite_ext(gui_Slot_Durability, 3, _x2 - (_v * INVENTORY_SLOT_SCALE / 2), _y2, INVENTORY_SLOT_SCALE * _v, INVENTORY_SLOT_SCALE, 0, c_white, 1);
					}
				}
			}
			
			if (_instance.slot_type == SLOT_TYPE.CRAFTABLE)
			{
				_index_offset = _instance.index_offset;
				
				_index += (_index_offset & 0x80 ? -(_index_offset & 0x7f) : (_index_offset & 0x7f));
			}
			
			if (_inventory_selected_backpack == _instance)
			{
				draw_sprite_ext(_sprite, _index, _x, _y, _scale, _scale, 0, c_white, 0.5);
				draw_sprite_ext(_sprite, _index, global.gui_mouse_x, global.gui_mouse_y, _scale, _scale, 0, c_white, 1);
			}
			else
			{
				draw_sprite_ext(_sprite, _index, _x, _y, _scale, _scale, 0, c_white, 1);
			}
		}
		
		++i;
	}
		
	#endregion
		
	#region Draw Amount
	
	i = 0;
	
	repeat (_length)
	{
		_item = _value[i];
			
		if (_item != INVENTORY_EMPTY) && (_item != ITEM.EMPTY)
		{
			#macro GUI_AMOUNT_XOFFSET 4
			#macro GUI_AMOUNT_YOFFSET 4
			
			_instance = _instances[i];
			
			_x = (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH  / 2) + GUI_AMOUNT_XOFFSET + _instance.xoffset;
			_y = (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT / 2) + GUI_AMOUNT_YOFFSET + _instance.yoffset;
			
			if (_item.amount > 1) && (_inventory_selected_backpack != _instance)
			{
				draw_text_transformed(_x, _y, _item.amount, 1, 1, 0);
			}
		}
		
		++i;
	}
	
	#endregion
}