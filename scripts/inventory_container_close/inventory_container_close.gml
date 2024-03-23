function inventory_container_close()
{
	if (obj_Control.is_opened_container)
	{
		var _container = [];
	
		array_copy(_container, 0, global.inventory.container, 0, global.container_size);
		tile_set(global.container_tile_position_x, global.container_tile_position_y, global.container_tile_position_z, "inventory", _container);
		
		audio_play_sound(sfx_Container_Chest_Close, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
	}
	
	obj_Control.is_opened_container = false;
	obj_Control.surface_refresh_inventory = true;
	
	global.inventory.container = [];
	global.inventory_instances.container = [];
	
	global.container_size = 0;
	
	with (obj_Inventory)
	{
		if (type != "container") continue;
		
		instance_destroy();
	}
}