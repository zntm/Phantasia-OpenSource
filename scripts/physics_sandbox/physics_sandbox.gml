function physics_sandbox(_key_left, _key_right, _delta_time = global.delta_time)
{
	if (keyboard_check(ord("W")))
	{
		light_refresh(true);
		chunk_refresh(x, y, true);
		
		image_yscale = -1;
		y -= 32 * _delta_time;
	}

	if (_key_left)
	{
		light_refresh(true);
		chunk_refresh(x, y, true);
		
		image_xscale = -1;
		x -= 32 * _delta_time;
	}

	if (keyboard_check(ord("S")))
	{
		light_refresh(true);
		chunk_refresh(x, y, true);
		
		image_yscale = 1;
		y += 32 * _delta_time;
	}

	if (_key_right)
	{
		light_refresh(true);
		chunk_refresh(x, y, true);
		
		image_xscale = 1;
		x += 32 * _delta_time;
	}
}