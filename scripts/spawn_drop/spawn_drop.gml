function spawn_drop(_x, _y, _item, _amount, _xvelocity, _direction, _yvelocity = 0, _timer = 20, _show_text = true, _index, _index_offset, _durability, _acclimation)
{
	
	
	if (_item == ITEM.EMPTY) exit;
	
	with (instance_create_layer(_x, _y, "Instances", obj_Item_Drop))
	{
		sprite_index = global.item_data[_item].sprite;
		
		xvelocity = _xvelocity;
		yvelocity = _yvelocity;
		
		image_xscale = 0.5;
		image_yscale = 0.5;
		
		image_speed = 0;
		
		item_id = _item;
		amount = _amount;
		
		if (_index != undefined)
		{
			index = _index;
			image_index = _index;
		}
		
		if (_index_offset != undefined)
		{
			index_offset = _index_offset;
			image_index += _index_offset;
		}
		
		if (_durability != undefined)
		{
			durability = _durability;
		}
		
		if (_acclimation != undefined)
		{
			acclimation = _acclimation;
		}
		
		xdirection = _direction;
		
		timer = _timer;
		show_text = _show_text;
		
		life = 0;
	}
}