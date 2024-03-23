function Inventory(_item, _amount = 1) constructor
{
	item_id = _item;
	amount  = _amount;
	
	var _data = global.item_data[_item];
	
	index = _data.get_inventory_index();
	
	static set_index = function(_index)
	{
		index = _index;
		
		return self;
	}
	
	index_offset = _data.get_index_offset();
	
	static set_index_offset = function(_index)
	{
		index_offset = _index;
		
		return self;
	}
	
	var _type = _data.type;
	
	if (_type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP | ITEM_TYPE.BOW))
	{
		durability = _data.get_durability();
		acclimation = 0;
	}
	
	if (_type & ITEM_TYPE.FISHING_POLE)
	{
		durability = _data.get_durability();
	}
}