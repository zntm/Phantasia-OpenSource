#macro LIGHT_REFRESH_CULL_OFFSET (TILE_SIZE * 16)
#macro LIGHT_REFRESH_CULL_TIME 16

function light_refresh(_force = false)
{
	if (!_force) && (global.timer % LIGHT_REFRESH_CULL_TIME != 0) && (!instance_exists(obj_Creature)) && (!instance_exists(obj_Tile_Light)) exit;
	
	instance_deactivate_object(obj_Tile_Light);
	instance_deactivate_object(obj_Tile_Station);
	instance_deactivate_object(obj_Tile_Container);
		
	var _camera = global.camera;

	var _left = _camera.x_real - LIGHT_REFRESH_CULL_OFFSET;
	var _width = _camera.width + (LIGHT_REFRESH_CULL_OFFSET * 2);

	instance_activate_object(obj_Player);
	instance_activate_object(obj_Light_Sun);
	instance_activate_object(obj_Boss);
	instance_activate_object(obj_Chunk);
	instance_activate_object(obj_Toast);

	instance_activate_region(_left, 0, _width, 1, true);
	
	// Activates lights if its in the view
	instance_activate_region(_left, _camera.y_real - LIGHT_REFRESH_CULL_OFFSET, _width, _camera.height + (LIGHT_REFRESH_CULL_OFFSET * 2), true);

	var _layer = layer_get_id(global.menu_layer);
		
	with (obj_Menu_Button)
	{
		if (layer == _layer) continue;
			
		instance_deactivate_object(id);
	}
		
	with (obj_Menu_Textbox)
	{
		if (layer == _layer) continue;
			
		instance_deactivate_object(id);
	}
		
	with (obj_Menu_Text)
	{
		if (layer == _layer) continue;
			
		instance_deactivate_object(id);
	}
	
	if (!obj_Control.is_opened_inventory)
	{
		instance_deactivate_object(obj_Inventory);
	}
}