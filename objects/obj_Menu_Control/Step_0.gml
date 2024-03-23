if (room != rm_World)
{
	var _refresh_rate = global.settings.general.refresh_rate;
	// var _delta_time = real(_refresh_rate.values[_refresh_rate.value]) * (delta_time / 1_000_000);
	
	var _delta_time = GAME_FPS * (delta_time / 1_000_000);
	
	global.delta_time = _delta_time;
	global.timer_delta += _delta_time;
	
	++global.timer;
}

if (on_step != -1)
{
	on_step();
}