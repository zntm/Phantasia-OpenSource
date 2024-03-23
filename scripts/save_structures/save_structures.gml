function save_structures()
{
	var _buffer = buffer_create(64, buffer_grow, 1);
	
	instance_activate_object(obj_Structure);
	
	buffer_write(_buffer, buffer_u64, instance_number(obj_Structure));
	
	with (obj_Structure)
	{
		buffer_write(_buffer, buffer_f64, x);
		buffer_write(_buffer, buffer_f64, y);
		buffer_write(_buffer, buffer_u32, (structure_id << 16) | (image_xscale << 8) | image_yscale);
		buffer_write(_buffer, buffer_string, structure);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.directory}/{global.world_data[global.world.environment.value & 0xf].name}/Structures.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}