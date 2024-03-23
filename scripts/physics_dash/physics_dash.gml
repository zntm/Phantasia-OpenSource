function physics_dash(_key_left, _key_right, _dash, _delta_time)
{
	if (dash_speed > 0)
	{
		_key_left = false;
		_key_right = false;
		
		dash_speed -= _delta_time;
	}
	
	if (_dash == 0)
	{
		dash_facing = 0;
		dash_speed = 0;
		
		if (dash_timer > 0)
		{
			dash_timer += _delta_time;
			
			if (dash_timer > COOLDOWN_MAX_DASH)
			{
				dash_timer = 0;
			}
		}
		
		exit;
	}
	
	if (dash_speed > 0) exit;
	
	if (dash_timer > 0)
	{
		var _controls = global.settings.controls;
			
		if (dash_facing == (keyboard_check_pressed(_controls.right.value) - keyboard_check_pressed(_controls.left.value)))
		{
			dash_speed = _dash;
			dash_timer = 0;
			
			audio_play_sound(choose(sfx_Dash_00, sfx_Dash_01), 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value, 0, random_range(0.8, 1.2));
			
			exit;
		}
		
		dash_timer += _delta_time;
		
		if (dash_timer > COOLDOWN_MAX_DASH)
		{
			dash_timer = 0;
		}
			
		exit;
	}
		
	dash_facing = _key_right - _key_left;
		
	if (dash_facing != 0)
	{
		dash_timer = _delta_time;
	}
}