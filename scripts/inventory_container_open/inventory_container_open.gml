function inventory_container_open(_x, _y, _inst = noone)
{
	if (!instance_exists(_inst))
	{
		_inst = instance_nearest(_x, _y, obj_Tile_Container);
	}
	
	if (!instance_exists(_inst)) || (point_distance(_x, _y, _inst.x, _inst.y) > TILE_SIZE * CRAFTING_STATION_MAX_DISTANCE) exit;
	
	instance_activate_object(obj_Inventory);
	
	audio_play_sound(sfx_Container_Chest_Open, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
	
	var _px = _inst.position_x;
	var _py = _inst.position_y;
	var _pz = _inst.position_z;
	
	var _tile = tile_get(_px, _py, _pz, "all");
	
	var _item_data = global.item_data;
	
	var _data = _item_data[_tile.item_id];
	
	var _size   = _data.container_size;
	var _sprite = _data.container_sprite;
	
	obj_Control.is_opened_container = true;
	obj_Control.is_opened_inventory = true;
	
	global.container_size = _size;
	
	global.container_tile_position_x = _px;
	global.container_tile_position_y = _py;
	global.container_tile_position_z = _pz;
		
	var _container_inventory = _tile.inventory;
	var _container_length = array_length(_container_inventory);
				
	var _inventory_row_height = floor(array_length(global.inventory.base) / INVENTORY_SIZE.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT;
				
	#macro INVENTORY_CONTAINER_XOFFSET (GUI_SAFE_ZONE_X + (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH))
	#macro INVENTORY_CONTAINER_YOFFSET (GUI_SAFE_ZONE_Y)
								
	var i = 0;
	
	repeat (_size)
	{
		global.inventory.container[@ i] = (i >= _container_length ? INVENTORY_EMPTY : _container_inventory[i]);
		global.inventory_instances.container[@ i] = instance_create_layer(0, 0, "Instances", obj_Inventory, {
			xoffset: GUI_SAFE_ZONE_X + INVENTORY_BACKPACK_XOFFSET + INVENTORY_CONTAINER_XOFFSET + ((i % INVENTORY_SIZE.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH),
			yoffset: GUI_SAFE_ZONE_Y + INVENTORY_BACKPACK_YOFFSET + INVENTORY_CONTAINER_YOFFSET + (floor(i / INVENTORY_SIZE.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT) + _inventory_row_height,
				
			inventory_placement: i,
			
			type: "container",
			slot_type: SLOT_TYPE.CONTAINER,
			
			sprite: _sprite,
										
			background_index: 2,
			background_alpha: 1,
		});
		
		++i;
	}
	
	obj_Control.surface_refresh_inventory = true;
}