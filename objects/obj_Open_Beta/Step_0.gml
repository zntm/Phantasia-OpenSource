var _refresh_rate = global.settings.general.refresh_rate;

global.delta_time = real(_refresh_rate.values[_refresh_rate.value]) * (delta_time / 1_000_000);

if (instance_exists(obj_Fade)) exit;

transition -= global.delta_time;

if (transition <= 0 || keyboard_check_pressed(vk_anykey))
{
	with (instance_create_layer(0, 0, "Instances", obj_Fade))
	{
		image_alpha = 0;
		
		value = FADE_SPEED;
		goto_room = menu_Main;
	}
}