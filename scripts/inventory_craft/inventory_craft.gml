function inventory_craft(_player_x, _player_y, _inst)
{
	var _item_data = global.item_data;
	
	spawn_drop(_player_x, _player_y, _inst.item_id, _inst.amount, 0, 0,, 0);
						
	audio_play_sound(sfx_Inventory_Click, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value, 0, random_range(0.9, 1.1));
						
	var _station = _inst.station;
						
	if (_station != ITEM.EMPTY)
	{
		audio_play_sound(_item_data[_station].sfx_craft, 0, false, global.settings.audio.master.value * global.settings.audio.blocks.value, 0, random_range(0.9, 1.1));
	}
						
	var _count;
				            
	var i = 0;
	var _item;
				
	var _recipes = _inst.crafting_recipes;
	var length = array_length(_recipes);
				
	var j;
	var _inventory_base;
	var _recipe;
	var _recipe_id;
	var _recipe_amount;
	var _amount;
	var _give_back;
				
	repeat (length)
	{
		_recipe = _recipes[i];
		_recipe_id = _recipe & 0xffff;
		_recipe_amount = _recipe >> 32;
						
		_give_back = (_recipe >> 16) & 0xffff;
					
		if (_give_back != 0xffff)
		{
			spawn_drop(_player_x, _player_y, _give_back, _recipe_amount, 0, 0);
		}
						
		_count = 0;
					
		j = 0;
		_inventory_base = global.inventory.base;
					
		repeat (INVENTORY_SIZE.BASE)
		{
			_item = _inventory_base[j];
						
			if (_item != INVENTORY_EMPTY) && (_item.item_id == _recipe_id)
			{
				_amount = _item.amount;
						
				while (_amount > 0 && _recipe_amount > _count)
				{
					--global.inventory.base[@ j].amount;
					--_amount;
										
					++_count;
							
					if (_amount <= 0)
					{
						global.inventory.base[@ j] = INVENTORY_EMPTY;
								
						break;
					}
				}
			}
						
			++j;
		}
					
		++i;
	}
				
	refresh_craftables();
				
	obj_Control.surface_refresh_inventory = true;
}