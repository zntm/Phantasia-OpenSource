function inventory_includes(_item, _amount = 1, _type = "base", __inventory = global.inventory)
{
	var _count = 0;
	
	var _inventory = __inventory[$ _type];
	var _length = array_length(_inventory);
	
	var _slot;
	var i = 0;
	
	repeat (_length)
	{
		_slot = _inventory[i++];
		
		if (_slot != INVENTORY_EMPTY) && (_slot.item_id == _item)
		{
			_count += _slot.amount;
		}
	}
	
	return (_count >= _amount);
}