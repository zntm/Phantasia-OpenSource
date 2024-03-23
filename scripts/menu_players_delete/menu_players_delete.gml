function menu_players_delete(_inst)
{
	global.is_popup = true;
	
	var _x = room_width / 2;
	var _y = room_height / 2;
	
	with (instance_create_layer(_x, _y - 16, "Popup", obj_Menu_Text))
	{
		text = "Delete";
		
		global.menu_worlds_delete_text = id;
	}
	
	with (instance_create_layer(_x - (16 * 3), _y + 16, "Popup", obj_Menu_Button))
	{
		sprite_index = spr_Menu_Button_Danger;
		
		image_xscale = 6;
		image_yscale = 3;
		
		text = "Delete";
		
		popup = true;
		directory = _inst.directory;
		
		on_press = function(_inst)
		{
			global.is_popup = false;
			
			// show_debug_message($"{DIRECTORY_DATA_PLAYER}/{_inst.directory}");
			
			directory_destroy($"{DIRECTORY_DATA_PLAYER}/{_inst.directory}");			
			
			room_goto(menu_Players);
		}
	}
	
	with (instance_create_layer(_x + (16 * 3), _y + 16, "Popup", obj_Menu_Button))
	{
		sprite_index = spr_Menu_Button_Main;
		
		image_xscale = 6;
		image_yscale = 3;
		
		text = "Cancel";
		
		popup = true;
		
		on_press = function(_inst)
		{
			global.is_popup = false;
			
			with (obj_Menu_Button)
			{
				if (popup)
				{
					instance_destroy();
				}
			}
			
			instance_destroy(global.menu_worlds_delete_text);
		}
	}
}