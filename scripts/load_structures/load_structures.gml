function load_structures()
{
	var _directory = $"{global.directory}/{global.world_data[global.world.environment.value & 0xf].name}/Structures.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _structure_data = global.structure_data;
	
	var _buffer = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	var _length = buffer_read(_buffer2, buffer_u64);
	
	repeat (_length)
	{
		var _x = buffer_read(_buffer2, buffer_f64);
		var _y = buffer_read(_buffer2, buffer_f64);
		
		var _v = buffer_read(_buffer2, buffer_u32);
		var _s = buffer_read(_buffer2, buffer_string);
		
		if (_structure_data[$ _s] == undefined) continue;
		
		with (instance_create_layer(_x, _y, "Instances", obj_Structure))
		{
			image_xscale = (_v >> 8) & 0xff;
			image_yscale = _v & 0xff;
			
			structure = _v >> 16;
			structure_id = _s;
		}
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}