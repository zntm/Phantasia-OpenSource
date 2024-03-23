if (room != rm_World)
{
	global.timer = 0;
	global.timer_delta = 0;
	
	var _handle = call_later(1, time_source_units_frames, function()
	{
		if (on_layer == -1) exit;
		
		var _layers = layer_get_all();
		var _length = array_length(_layers);
	
		var _layer;
		var _name;
	
		var i = 0;
	
		repeat (_length)
		{
			_layer = _layers[i++];
			_name = layer_get_name(_layer);
	
			if (_name == "Background") || (_name == "Instances") || (_name == "Decoration") || (_name == on_layer) continue;
		
			instance_deactivate_layer(_layer);
		}
	
		with (obj_Menu_Anchor)
		{
			if (!destroy) continue;
		
			instance_destroy();
		}
	});

	if (global.menu_main_fade)
	{
		with (instance_create_layer(0, 0, "Instances", obj_Fade))
		{
			value = -FADE_SPEED;
		}
	
		global.menu_main_fade = false;
	}
	
	display_set_gui_size(room_width, room_height);
}

keyboard_string = "";

global.is_popup = false;

on_step = -1;
on_layer = -1;

surface = -1;

shader = -1;
on_shader = -1;

area = -1;