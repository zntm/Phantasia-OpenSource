function accessory_get_buff(_type, _object = id)
{
	try
	{
	var _val = 1;
	
	var _item_data = global.item_data;
	var _inventory = global.inventory;
	
	var _item = _inventory.armor_helmet[0];
		
	if (_item != INVENTORY_EMPTY)
	{
		_val += _item_data[_item.item_id].buffs[$ _type] ?? 0;
	}
	
	_item = _inventory.armor_breastplate[0];
	
	if (_item != INVENTORY_EMPTY)
	{
		_val += _item_data[_item.item_id].buffs[$ _type] ?? 0;
	}
	
	_item = _inventory.armor_leggings[0];
	
	if (_item != INVENTORY_EMPTY)
	{
		_val += _item_data[_item.item_id].buffs[$ _type] ?? 0;
	}
	
	var _accessories = _inventory.accessory;
	
	var i = 0;
	
	repeat (INVENTORY_SIZE.ACCESSORIES)
	{
		_item = _accessories[i++];
		
		if (_item != INVENTORY_EMPTY)
		{
			_val += _item_data[_item.item_id].buffs[$ _type] ?? 0;
		}
	}

	var _effects = _object.effects[$ _type];
	
	if (_effects.timer > 0)
	{
		_val += global.effect_data[$ _type].base_value * _effects.level;
	}
	
	return _val;
	}
	catch(er){return 1;}
}