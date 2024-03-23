function save_values()
{
	var _command_value = global.command_value;
	
	var _names = struct_get_names(_command_value);
	var _length = array_length(_names);
	
	if (_length <= 0) exit;
	
	var _f = current_time;
	
	var _buffer = buffer_create(0x4000, buffer_grow, 1);
	
	#region Save Key & Values
	
	buffer_write(_buffer, buffer_u16, _length);
	
	var _key;
	var _v;
	
	var i = 0;
	
	repeat (_length)
	{
		_key = _names[i++];
		_v = _command_value[$ _key];
		
		if (_v == undefined) continue;
		
		buffer_write(_buffer, buffer_string, _key);
		buffer_write(_buffer, buffer_s32, _v);
	}
	
	#endregion
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));

	buffer_save(_buffer2, $"{global.directory}/Values.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	// show_debug_message($"Save - Command Values: {current_time - _f}ms");
}