#macro CRAFTABLE_XSTART 40
#macro CRAFTIABLE_YSTART 256

function refresh_craftables(_refresh_slots = true)
{
	if (!obj_Control.is_opened_inventory) exit;
	
	static __distance = [];
	
	#region Refresh nearest stations
	
	var _station;
	
	var _item_stations = global.item_stations;
	var _length_item_stations = array_length(_item_stations);
	
	var i = 0;
	var j;
	var l;
	
	var _x = obj_Player.x;
	var _y = obj_Player.y;
	
	repeat (_length_item_stations)
	{
		__distance[@ i] = false;
		
		_station = _item_stations[i];
		
		with (obj_Tile_Station)
		{
			if (_station != item_id) || (point_distance(x, y, _x, _y) >= TILE_SIZE * CRAFTING_STATION_MAX_DISTANCE) continue;
			
			__distance[@ i] = true;
				
			break;
		}
		
		++i;
	}
	
	#endregion
	
	if (_refresh_slots)
	{
		with (obj_Inventory)
		{
			if (type != "craftable") continue;
			
			instance_destroy();
		}
		
		global.inventory.craftable = [];
		global.inventory_instances.craftable = [];
	}
	
	var _crafting_data = global.crafting_data;
	var _length_crafting_data = array_length(_crafting_data);
		
	var _craftable_amount = 0;
	
	var _data, _stations, _stations_length, _value, _near_station;
	var _recipes, _data_id, _data_amount, _recipe_length, _recipe, _has_required_items;

	i = 0;
	
	var _inventory = global.inventory;
	var _ystart = (array_length(_inventory.base) div INVENTORY_SIZE.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT;
	
	repeat (_length_crafting_data)
	{
		_data = _crafting_data[i];
		
		_value = _data.value;
		
		_stations = _data.item_stations;
		_stations_length = (_value >> 8) & 0xff;
		
		_near_station = ITEM.EMPTY;
		
		if (_stations_length > 0)
		{
			j = 0;
		
			repeat (_stations_length)
			{
				_station = _stations[j];
			
				l = 0;
			
				repeat (_length_item_stations)
				{
					if (__distance[l]) && (_item_stations[l] == _station)
					{
						_near_station = _station;
						
						break;
					}
					
					++l;
				}
			
				if (_near_station) break;
			
				++j;
			}
		}
		
		if (_stations_length == 0 || _near_station != ITEM.EMPTY) && (_refresh_slots)
		{
			_recipes = _data.crafting_recipes;
			_recipe_length = _value >> 16;
			
			_has_required_items = true;
	
			j = 0;
			
			repeat (_recipe_length)
			{
				_recipe = _recipes[j++];
				
				if (!inventory_includes(_recipe & 0xffff, _recipe >> 32,, _inventory))
				{
					_has_required_items = false;
			
					break;
				}
			}
			
			if (_has_required_items)
			{
				global.player.recipe_unlocks[@ i] = true;
				
				_data_id = _data.item_id;
				_data_amount = _data.amount;
				
				#macro INVENTORY_CRAFTABLE_XOFFSET 0
				#macro INVENTORY_CRAFTABLE_YOFFSET (GUI_SAFE_ZONE_Y)
				
				global.inventory.craftable[@ _craftable_amount] = new Inventory(_data_id, _data_amount);
				global.inventory_instances.craftable[@ _craftable_amount] = instance_create_layer(0, 0, "Instances", obj_Inventory, {
					xoffset: GUI_SAFE_ZONE_X + INVENTORY_BACKPACK_XOFFSET + INVENTORY_CRAFTABLE_XOFFSET,
					yoffset: GUI_SAFE_ZONE_Y + INVENTORY_BACKPACK_YOFFSET + INVENTORY_CRAFTABLE_YOFFSET + (_craftable_amount * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT) + _ystart,
					
					enough_ingredients: _has_required_items,
					station: _near_station,
					
					type: "craftable",
					slot_type: SLOT_TYPE.CRAFTABLE,
					
					sprite: gui_Slot_Inventory,
					item_id: _data_id,
					
					amount: _data_amount,
			
					background_index: 2,
					background_alpha: 0.95,
					
					crafting_recipes: _recipes,
					index_offset: _value & 0xff
				});
				
				++_craftable_amount;
			}
		}
		
		++i;
	}
}