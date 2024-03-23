function save_info()
{
	var _world = global.world;
	var _in_biome = obj_Background.in_biome;
	
	// show_debug_message($"Saving World Info - {_world.name}");
	
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	var _info = _world.info;
	
	buffer_write(_buffer, buffer_string, _info.name);
	buffer_write(_buffer, buffer_s32, _info.seed);
	
	var _environment = _world.environment;
	
	buffer_write(_buffer, buffer_u64, (round(_environment.weather_wind * 100) << 56) | (round(_environment.weather_storm * 100) << 48) | (_in_biome.type << 40) | (_in_biome.biome << 32) | _environment.value);
	buffer_write(_buffer, buffer_f64, _environment.time);
	
	buffer_write(_buffer, buffer_f64, date_current_datetime());
	buffer_write(_buffer, buffer_u32, (VERSION_NUMBER.TYPE << 24) | (VERSION_NUMBER.MAJOR << 16) | (VERSION_NUMBER.MINOR << 8) | (VERSION_NUMBER.PATCH));
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.directory}/Info.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	// show_debug_message($"Saved World Info - {_world.name}");
}