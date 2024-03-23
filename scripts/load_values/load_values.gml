function load_values(_directory)
{
	if (!file_exists(_directory)) exit;
	
	var _buffer = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
		
	var _length = buffer_read(_buffer2, buffer_u16);
		
	repeat (_length)
	{
		global.command_value[$ buffer_read(_buffer2, buffer_string)] = buffer_read(_buffer2, buffer_s32);
	}

	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}