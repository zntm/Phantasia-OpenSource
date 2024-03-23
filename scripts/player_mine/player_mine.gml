function player_mine(_x, _y, _holding, _delta_time, _item_data)
{
	var _tile;
	
	if (!is_mining)
	{
		var _z = CHUNK_SIZE_Z - 1;
				
		repeat (CHUNK_SIZE_Z)
		{
			_tile = tile_get(_x, _y, _z);
			
			if (_tile == ITEM.EMPTY)
			{
				--_z;
					
				continue;
			}
				
			is_mining = true;
				
			mining_current = 0;
			mining_current_fixed = 0;
			
			mine_position_x = _x;
			mine_position_y = _y;
			mine_position_z = _z;
				
			break;
		}
	}
	
	if (!is_mining) || (_x != mine_position_x) || (_y != mine_position_y)
	{
		return true;
	}
			
	_tile = tile_get(_x, _y, mine_position_z, "all");
		
	if (_tile == ITEM.EMPTY)
	{
		return true;
	}
	
	var _item_id = _tile.item_id;
	
	var _data = _item_data[_item_id];
	var _mining_amount = _data.get_mining_amount();
	
	if (_mining_amount < 0)
	{
		return true;
	}
	
	var _type = _data.get_mining_type();
				
	var _mining_speed;
				
	if (_type == ITEM_TYPE.DEFAULT)
	{
		_mining_speed = 1;
		
		if (_type & (ITEM_TYPE.SOLID | ITEM_TYPE.UNTOUCHABLE | ITEM_TYPE.WALL | ITEM_TYPE.PLANT | ITEM_TYPE.CONTAINER | ITEM_TYPE.LIQUID)) && (_data.get_mining_power() != TOOL_POWER.ALL)
		{
			return true;
		}
	}
	else
	{
		if (_holding == INVENTORY_EMPTY)
		{
			return true;
		}
		
		var _holding_data = _item_data[_holding.item_id];
		var _holding_type = _holding_data.type;
		var _mining_type = _data.get_mining_type();
		
		if (_mining_type != ITEM_TYPE.DEFAULT) && ((_holding_type & _mining_type) == 0 || ((_holding_type & (ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER)) && (_holding_data.get_mining_power() < _data.get_mining_power())))
		{
			return true;
		}
		
		_mining_speed = _holding_data.get_mining_speed();
	}
	
	var _sfx = _data.sfx;
	
	mining_current += _mining_speed * _delta_time;
	++mining_current_fixed;
	
	if (_holding != INVENTORY_EMPTY)
	{
		var _holding_data = _item_data[_holding.item_id];
		
		if (_holding_data.type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP))
		{
			mining_current += round((_holding.acclimation / _holding_data.get_acclimation_amount()) * _holding_data.get_acclimation_max());
		}
	}
	
	var _tile_x = _x * TILE_SIZE;
	var _tile_y = _y * TILE_SIZE;
				
	if (round(mining_current_fixed) % 8 == 0)
	{
		sfx_play(_tile_x, _tile_y, _sfx, "mine");
	}
		
	if (mining_current < _mining_amount)
	{
		return false;
	}
	
	var _drops = _data.drops;
						
	if (is_array(_drops))
	{
		_drops = choose_weighted(_drops);
	}
	
	if (_data.type & ITEM_TYPE.CONTAINER)
	{
		var i = 0;
		var _inventory = _tile.inventory;
		var _item;
		
		repeat (_data.container_size)
		{
			_item = _inventory[i++];
			
			if (_item == INVENTORY_EMPTY) continue;
			
			spawn_drop(_tile_x, _tile_y, _item.item_id, _item.amount, random_range(-2, 2), choose(-1, 1),,,, _item.index, _item.index_offset, _item[$ "durability"], _item[$ "acclimation"]);
		}
	}
					
	if (_drops != ITEM.EMPTY)
	{
		spawn_drop(_x * TILE_SIZE, _y * TILE_SIZE, _drops, 1, 0, 0);
	}
	
	sfx_play(_tile_x, _tile_y, _sfx, "destroy");
	
	tile_place(_x, _y, mine_position_z, ITEM.EMPTY);
	
	chunk_refresh(mouse_x, mouse_y, true);
	light_refresh(true);
					
	var _on_destroy = _data.on_destroy;
					
	if (_on_destroy != -1)
	{  
		_on_destroy(_x, _y, mine_position_z);
	}
							
	mining_current = 0;
	mining_current_fixed = 0;
						
	if (_holding != INVENTORY_EMPTY)
	{
		var _holding_data = _item_data[_holding.item_id];
		
		if (_holding_data.type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP | ITEM_TYPE.BOW))
		{
			obj_Control.surface_refresh_inventory = true;
		
			var _inventory_selected_hotbar = global.inventory_selected_hotbar;
		
			if (--global.inventory.base[_inventory_selected_hotbar].durability <= 0)
			{
				global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
			}
			else if (global.inventory.base[_inventory_selected_hotbar].acclimation < _holding_data.get_acclimation_amount())
			{
				++global.inventory.base[@ _inventory_selected_hotbar].acclimation;
			}
		}
	}
	
	obj_Control.refresh_sun_ray = true;
	
	global.camera.shake = 1;
	
	var _camera = global.camera;
	
	#region Adjust Sun Ray
	
	var _string_x = string(_x);
	
	var _i = global.sun_rays_y[$ _string_x] + 1;
	
	if (_i == _tile_y) && (_type & ITEM_TYPE.SOLID) && (_tile.boolean & 1)
	{
		var _b = floor(_x / CHUNK_SIZE_X) * CHUNK_SIZE_WIDTH;
	
		while (true)
		{
			if (!instance_exists(instance_position(_b, floor(_i / CHUNK_SIZE_Y) * CHUNK_SIZE_HEIGHT, obj_Chunk)))
			{
				global.sun_rays_y[$ _string_x] = WORLD_HEIGHT;
			
				return true;
			}
		
			_tile = tile_get(_x, _i, CHUNK_DEPTH_DEFAULT, "all");
		
			if (_tile != ITEM.EMPTY) && (_tile.boolean & 1) && (_item_data[_tile.item_id].type & ITEM_TYPE.SOLID)
			{
				global.sun_rays_y[$ _string_x] = _i;
			
				return true;
			}
		
			++_i;
		}
	}
	
	#endregion
}