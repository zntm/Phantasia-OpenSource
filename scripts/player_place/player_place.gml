function player_place(_x, _y, _item_data)
{
	var _z = -1;
	
	var _inventory_selected_hotbar = global.inventory_selected_hotbar;
	
	var _holding = global.inventory.base[_inventory_selected_hotbar];
	var _item_id = _holding.item_id;
			
	var _data = _item_data[_item_id];
	var _type = _data.type;
	var _tile = ITEM.EMPTY;
			
	var _give_back = ITEM.EMPTY;
	var _is_deployable = false;
		
	if (_type & ITEM_TYPE.DEPLOYABLE)
	{
		if (tile_get(_x, _y, _data.z) == ITEM.EMPTY)
		{
			_z = _data.z;
			_tile = _data.tile;
				
			_give_back = _data.give_back;
			_is_deployable = true;
		}
	}
	else if (_type & (ITEM_TYPE.SOLID | ITEM_TYPE.UNTOUCHABLE | ITEM_TYPE.CONTAINER))
	{
		_z = CHUNK_DEPTH_DEFAULT;
	}
	else if (_type & ITEM_TYPE.WALL)
	{
		_z = CHUNK_DEPTH_WALL;
	}
	else if (_type & ITEM_TYPE.PLANT)
	{
		_z = CHUNK_DEPTH_PLANT;
	}
	else if (_type & ITEM_TYPE.LIQUID)
	{
		_z = CHUNK_DEPTH_LIQUID;
	}
			
	if (_type & ITEM_TYPE.LIQUID) || ((_z != -1) && (tile_get(_x, _y, _z) == ITEM.EMPTY) &&
		(tile_get(_x - 1, _y, _z) != ITEM.EMPTY ||
		tile_get(_x, _y - 1, _z) != ITEM.EMPTY ||
		tile_get(_x + 1, _y, _z) != ITEM.EMPTY ||
		tile_get(_x, _y + 1, _z) != ITEM.EMPTY))
	{
		var _requirement = _data.place_requirement;
					
		if (_is_deployable || (_requirement == -1 || _requirement(_x, _y, _z)))
		{
			if (!_is_deployable)
			{
				_tile = new Tile(_item_id)
					.set_index_offset(_holding.index_offset);
			}
			
			var _r = string(_x);
			
			obj_Control.surface_refresh_inventory = true;
			obj_Control.refresh_sun_ray = true;
			
			if (_type & ITEM_TYPE.SOLID) && (_y < global.sun_rays_y[$ _r])
			{
				global.sun_rays_y[$ _r] = _y;
				
				obj_Control.surface_refresh_lighting = true;
			}
				
			tile_place(_x, _y, _z, _tile);
			
			var i = _x - 1;
			var j;
			
			repeat (3)
			{
				j = _y - 1;
				
				repeat (3)
				{
					tile_update(i, j++, _z);
				}
				
				++i;
			}
			
			chunk_refresh(mouse_x, mouse_y, true);
			light_refresh(true);
						
			cooldown_build = COOLDOWN_MAX_BUILD;
					
			refresh_craftables();
			
			if (!_is_deployable) || (_item_id != _data.give_back) || (_data.get_inventory_max() != 1)
			{
				if (--global.inventory.base[_inventory_selected_hotbar].amount <= 0)
				{
					global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
				}
			
				if (_give_back != ITEM.EMPTY)
				{
					spawn_drop(x, y, _give_back, 1, 0, 0,,, false);
				}
			}
		}
	}
}