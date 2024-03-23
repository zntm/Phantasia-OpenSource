function ctrl_weather()
{
	var _delta_time = global.delta_time;
	
	if (global.world.environment.time < _delta_time)
	{
		#macro WEATHER_WIND_OFFSET 0.25
		
		global.world.environment.weather_wind = clamp(global.world.environment.weather_wind + random_range(-WEATHER_WIND_OFFSET, WEATHER_WIND_OFFSET), 0, 1);
		
		/*
		var _storm = global.world.environment.weather_storm;
		
		#macro WEATHER_HEAVY_STORM_CHANCE 3
		#macro WEATHER_HEAVY_STORM_MIN 0.3
		#macro WEATHER_HEAVY_STORM_MAX 0.5
		
		if (_storm >= WEATHER_HEAVY_STORM_MIN) && (_storm < WEATHER_HEAVY_STORM_MAX) && (irandom(99) < WEATHER_HEAVY_STORM_CHANCE)
		{
			global.world.environment.weather_storm = random_range(0.7, 1);
		}
		else if (global.world.environment.weather_storm >= 0.6)
		{
			global.world.environment.weather_storm = random_range(0, 0.2);
		}
		else
		{
			global.world.environment.weather_storm = clamp(_storm + random_range(-0.1, 0.1), 0, 1);
		}
		*/
	}
	
	/*
	var _weather_storm = global.world.environment.weather_storm;

	#macro WEATHER_RAIN_THRESHOLD 0.3

	if (_weather_storm >= WEATHER_RAIN_THRESHOLD) && (chance(_weather_storm * random_range(1, 2) * _delta_time))
	{
		var _camera = global.camera;
		
		var cx = _camera.x;
		var cy = _camera.y;
	
		var _xw = cx + _camera.width;
		var _ystart = cy - 16;
		var _direction = global.world.environment.weather_wind - 0.5;
		var _xvelocity;
		
		static __rain = new Particle()
			.set_sprite(prt_Rain_Drop)
			.set_destroy_on_collision();
		
		#macro WEATHER_RAIN_SPAWN_MIN 3
		#macro WEATHER_RAIN_SPAWN_MAX 14
		
		repeat (irandom_range(WEATHER_RAIN_SPAWN_MIN, WEATHER_RAIN_SPAWN_MAX) * _weather_storm)
		{
			#macro WEATHER_RAIN_XVELOCITY_MIN 1
			#macro WEATHER_RAIN_XVELOCITY_MAX 4
			
			_xvelocity = _direction * random_range(WEATHER_RAIN_XVELOCITY_MIN, WEATHER_RAIN_XVELOCITY_MAX);
		
			#macro WEATHER_RAIN_YSPEED_MIN 6
			#macro WEATHER_RAIN_YSPEED_MAX 16
		
			spawn_particle(random_range(cx, _xw), _ystart, CHUNK_DEPTH_LIQUID, __rain
				.set_speed(_xvelocity, random_range(WEATHER_RAIN_YSPEED_MIN, WEATHER_RAIN_YSPEED_MAX))
				.set_angle(_xvelocity * 4));
		}
	}
	*/
}