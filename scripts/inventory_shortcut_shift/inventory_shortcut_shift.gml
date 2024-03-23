function inventory_shortcut_shift(_from_type, _from_index, _to_type)
{
	var _item_data = global.item_data;
	
	var _inventory = global.inventory;
	var _item = _inventory[$ _from_type][_from_index];
					
	if (_item == INVENTORY_EMPTY) exit;
	
	var _item_id = _item.item_id;
	var _item_amount = _item.amount;
					
	var _slots = _inventory[$ _to_type];
	
	var _slot;
	
	var _data;
	var _max;
	
	var _diff;
	
	var i = 0;
						
	repeat (INVENTORY_SIZE.BASE)
	{
		_slot = _slots[i];
							
		if (_slot == INVENTORY_EMPTY)
		{
			global.inventory[$ _to_type][@ i] = new Inventory(_item_id, _item_amount);
			global.inventory[$ _from_type][@ _from_index] = INVENTORY_EMPTY;
			
			obj_Control.surface_refresh_inventory = true;
							
			exit;
		}
		
		if (_slot.item_id != _item_id)
		{
			++i;
								
			continue;
		}
		
		global.inventory[$ _from_type][@ _from_index] = INVENTORY_EMPTY;
		
		obj_Control.surface_refresh_inventory = true;
		
		_data = _item_data[_item_id];
		_max = _data.get_inventory_max();
									
		if (_slot.amount + _item_amount <= _max)
		{
			global.inventory[$ _to_type][@ i].amount = _slot.amount + _item_amount;
			
			exit;
		}
		
		var _v = abs(_slot.amount - _item_amount);
										
		global.inventory[$ _to_type][@ i].amount = _max;
										
		var j = i;
		var _h;
		var _n;
										
		while (_v <= 0 || i >= INVENTORY_SIZE.BASE)
		{
			_h = global.inventory[$ _to_type][j];
											
			if (_h == ITEM.EMPTY)
			{
				global.inventory[$ _to_type][@ j] = new Inventory(_item_id, _v);
												
				exit;
			}
											
			if (_h.item_id == _item_id)
			{
				_diff = _h.amount + _v;
					
				if (_diff <= _max)
				{
					global.inventory[$ _to_type][@ j].amount += _v;
													
					exit;
				}
												
				_v = abs(_diff - _max);
					
				global.inventory[$ _to_type][@ j].amount = _max;
												
				if (_v <= 0) exit;
			}
			
			++j;
		}
	}
}